(function () {
  var clrbBgmHandle = null;
  var clrbBgmStage = 0;
  var clrbBgmTrackIdx = -1;
  var clrbBgmLoopTimer = null;
  var clrbBgmLocalWasAlive = true;

  // duration：Panorama 无公开时长 API 时的兜底秒数，可按实际听感微调
  var CLRB_BGM_LOOPS = {
    1: [{ evt: "clrb_bgm_monster_hunter", duration: 178 }],
    2: [{ evt: "clrb_bgm_dsadowski_store_preview", duration: 75 }],
    3: [{ evt: "clrb_bgm_jlin_store_preview", duration: 75 }],
  };

  function ClrbBgmCancelLoop() {
    if (clrbBgmLoopTimer != null) {
      $.CancelScheduled(clrbBgmLoopTimer);
      clrbBgmLoopTimer = null;
    }
  }

  function ClrbBgmGetDuration(evt, fallback) {
    if (typeof Game.GetSoundDuration === "function") {
      var d = Game.GetSoundDuration(evt);
      if (d && d > 0) {
        return d;
      }
    }
    return fallback || 60;
  }

  function ClrbBgmStop() {
    ClrbBgmCancelLoop();
    if (clrbBgmHandle != null) {
      Game.StopSound(clrbBgmHandle);
      clrbBgmHandle = null;
    }
    clrbBgmStage = 0;
    clrbBgmTrackIdx = -1;
  }

  function ClrbBgmIsActive() {
    return clrbBgmStage > 0 && clrbBgmHandle != null && clrbBgmLoopTimer != null;
  }

  // 仅在循环已断时续播当前曲目，避免 force 重播把正在播放的 BGM 打断
  function ClrbBgmEnsurePlaying() {
    if (clrbBgmStage <= 0) {
      return;
    }
    if (ClrbBgmIsActive()) {
      return;
    }
    var idx = clrbBgmTrackIdx >= 0 ? clrbBgmTrackIdx : 0;
    ClrbBgmPlayTrack(clrbBgmStage, idx);
  }

  function ClrbBgmScheduleNext(stage, trackIdx) {
    var list = CLRB_BGM_LOOPS[stage];
    if (!list || !list.length || clrbBgmStage !== stage) {
      return;
    }
    var track = list[trackIdx];
    if (!track) {
      return;
    }
    var delay = Math.max(1, ClrbBgmGetDuration(track.evt, track.duration));
    ClrbBgmCancelLoop();
    clrbBgmLoopTimer = $.Schedule(delay, function () {
      clrbBgmLoopTimer = null;
      if (clrbBgmStage !== stage) {
        return;
      }
      var nextIdx = (trackIdx + 1) % list.length;
      ClrbBgmPlayTrack(stage, nextIdx);
    });
  }

  function ClrbBgmRetryTrack(stage, trackIdx, delaySec, retriesLeft) {
    ClrbBgmCancelLoop();
    clrbBgmLoopTimer = $.Schedule(delaySec || 2, function () {
      clrbBgmLoopTimer = null;
      if (clrbBgmStage !== stage || retriesLeft <= 0) {
        return;
      }
      var list = CLRB_BGM_LOOPS[stage];
      var track = list && list[trackIdx];
      if (!track) {
        return;
      }
      var handle = Game.EmitSound(track.evt);
      if (!handle) {
        ClrbBgmRetryTrack(stage, trackIdx, (delaySec || 2) + 1, retriesLeft - 1);
        return;
      }
      var prevHandle = clrbBgmHandle;
      if (prevHandle != null && prevHandle !== handle) {
        Game.StopSound(prevHandle);
      }
      clrbBgmHandle = handle;
      clrbBgmStage = stage;
      clrbBgmTrackIdx = trackIdx;
      ClrbBgmScheduleNext(stage, trackIdx);
    });
  }

  function ClrbBgmPlayTrack(stage, trackIdx) {
    var list = CLRB_BGM_LOOPS[stage];
    if (!list || !list.length) {
      return;
    }
    trackIdx = ((trackIdx % list.length) + list.length) % list.length;
    var track = list[trackIdx];
    var prevHandle = clrbBgmHandle;
    var handle = Game.EmitSound(track.evt);
    if (!handle) {
      ClrbBgmRetryTrack(stage, trackIdx, 2, 4);
      return;
    }
    if (prevHandle != null && prevHandle !== handle) {
      Game.StopSound(prevHandle);
    }
    clrbBgmHandle = handle;
    clrbBgmStage = stage;
    clrbBgmTrackIdx = trackIdx;
    ClrbBgmScheduleNext(stage, trackIdx);
  }

  function ClrbBgmPlayStage(stage, force) {
    stage = Number(stage) || 0;
    if (stage <= 0) {
      ClrbBgmStop();
      return;
    }
    if (stage === clrbBgmStage) {
      if (!force && ClrbBgmIsActive()) {
        return;
      }
      if (force) {
        ClrbBgmEnsurePlaying();
        return;
      }
    }
    ClrbBgmCancelLoop();
    if (clrbBgmHandle != null) {
      Game.StopSound(clrbBgmHandle);
      clrbBgmHandle = null;
    }
    clrbBgmTrackIdx = -1;
    clrbBgmStage = stage;
    ClrbBgmPlayTrack(stage, 0);
  }

  function ClrbBgmOnData(keys) {
    if (!keys) {
      return;
    }
    if (keys.resume === 1 || keys.resume === true) {
      ClrbBgmEnsurePlaying();
      return;
    }
    var force = keys.force === 1 || keys.force === true;
    ClrbBgmPlayStage(keys.stage, force);
  }

  // 死亡/复活时强制从当前曲目重播（引擎常会在此刻掐断 Panorama 音效）
  function ClrbBgmReloadCurrentTrack() {
    if (clrbBgmStage <= 0) {
      return;
    }
    var idx = clrbBgmTrackIdx >= 0 ? clrbBgmTrackIdx : 0;
    ClrbBgmCancelLoop();
    if (clrbBgmHandle != null) {
      Game.StopSound(clrbBgmHandle);
      clrbBgmHandle = null;
    }
    ClrbBgmPlayTrack(clrbBgmStage, idx);
  }

  function ClrbBgmScheduleReload() {
    $.Schedule(0.5, ClrbBgmReloadCurrentTrack);
    $.Schedule(2, ClrbBgmReloadCurrentTrack);
    $.Schedule(5, ClrbBgmReloadCurrentTrack);
  }

  function ClrbBgmWatchLocalHero() {
    if (typeof IsLocalHeroAlive === "function" && clrbBgmStage > 0) {
      var alive = IsLocalHeroAlive();
      if (clrbBgmLocalWasAlive && !alive) {
        ClrbBgmScheduleReload();
      } else if (!clrbBgmLocalWasAlive && alive) {
        ClrbBgmScheduleReload();
      }
      clrbBgmLocalWasAlive = alive;
    }
    $.Schedule(0.5, ClrbBgmWatchLocalHero);
  }

  function ClrbBgmWatchdog() {
    if (clrbBgmStage > 0) {
      ClrbBgmEnsurePlaying();
    }
    $.Schedule(2, ClrbBgmWatchdog);
  }

  SubEvent("UI_Bgm", ClrbBgmOnData);
  ClrbBgmWatchLocalHero();
  ClrbBgmWatchdog();
})();
