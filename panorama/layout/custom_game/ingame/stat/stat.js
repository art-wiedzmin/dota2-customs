--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


//初始化加载加载
function InitData() {
  var tp = "init";
  SendServer("Lua_Stat", { data: { tp } });
}

//获取当前游戏时间
function GetTime() {
  var time = Game.GetDOTATime(true, true);
  time = Math.floor(time);
  var min = Math.floor(time / 60);
  var mm = time - min * 60;
  min = min.toString();
  mm = mm.toString();
  if (min < 10) {
    min = "0" + min;
  }
  if (mm < 10) {
    mm = "0" + mm;
  }
  var timekey = min + ":" + mm;
  GetPanel("time_label").text = timekey;
  if (Game.IsDayTime()) {
    GetPanel("bac_img").SetHasClass("night", false);
  } else {
    GetPanel("bac_img").SetHasClass("night", true);
  }

  Timers(1, function () {
    GetTime();
  });
}

var colortab = {
  1: "#3476FF",
  2: "#C44DA9",
  3: "#5FBB0D",
  4: "#F7C300",
  5: "#C6D501",
  6: "#FF6F00",
  7: "#0FB2DC",
  8: "#35C09A",
  9: "#9443FE",
  10: "#855539",
};
// 按玩家 ID 记录复活结束的游戏时间，避免后端多次推送覆盖本地倒计时
var ResurrectionEndTime = {};
// 避免死亡状态下每次顶栏推送都叠一层 1s 倒计时 Timer
var ResurrectionTimerActive = {};

function GetResurrectionRemaining(playerId, backendTime) {
  var now = Game.GetDOTATime(true, true);
  if (ResurrectionEndTime[playerId] !== undefined) {
    var remaining = Math.ceil(ResurrectionEndTime[playerId] - now);
    if (remaining > 0) return remaining;
    delete ResurrectionEndTime[playerId];
  }
  ResurrectionEndTime[playerId] = now + backendTime;
  return backendTime;
}

function ClearResurrection(playerId) {
  delete ResurrectionEndTime[playerId];
  delete ResurrectionTimerActive[playerId];
}

/** 顶栏单个玩家 snippet：复用 panel，只改数据 */
function UpdatePlayerSnippet(panel, playerData, clickPayload) {
  if (!panel || !playerData) {
    return;
  }
  ClrbStatSetHeroImg(panel.FindChildTraverse("hero_img"), playerData.hero);
  if (playerData.online == 1) {
    panel.style.brightness = 1;
  } else {
    panel.style.brightness = 0.1;
  }
  var playerId = playerData.id;
  if (playerData.alive == 1) {
    ClearResurrection(playerId);
    panel.FindChildTraverse("hero_bottom").visible = false;
    panel.FindChildTraverse("hero_img").style.washColor = "none";
    panel.FindChildTraverse("hero_img").style.saturation = 1;
  } else {
    panel.FindChildTraverse("hero_bottom").visible = true;
    panel.FindChildTraverse("hero_img").style.washColor = "#b8b8b8";
    panel.FindChildTraverse("hero_img").style.saturation = 0.2;
    var displayTime = GetResurrectionRemaining(playerId, playerData.time);
    DeathTime(panel, displayTime, playerId);
  }
  panel.hittest = true;
  if (clickPayload && !panel._clrbStatClickBound) {
    panel._clrbStatClickBound = true;
    panel.SetPanelEvent("onmouseactivate", function () {
      SendServer("Lua_HeroCard", { data: clickPayload });
    });
  }
}

function RemoveStaleChildPanels(parent, activeIds) {
  if (!parent) {
    return;
  }
  var children = parent.Children();
  for (var i = children.length - 1; i >= 0; i--) {
    var child = children[i];
    if (child && child.id && !activeIds[child.id]) {
      child.RemoveAndDeleteChildren();
      child.DeleteAsync(0);
    }
  }
}

/** 顶栏英雄图：landscape 立绘，非 icon 小地图方图 */
function ClrbStatSetHeroImg(img, heroName) {
  if (!img) {
    return;
  }
  img.heroname = heroName;
  img.heroimagestyle = "landscape";
}

/* 顶栏 #Stat 下 .root：仅 rank_3x4 加 .stat_top_3x4（由 GetPublicData 里 data.change==2 时 SetStatTop3x4Layout(true)） */
function SetStatTop3x4Layout(on) {
  var sec = GetPanel("section");
  var bar = sec && sec.GetParent();
  if (bar) {
    bar.SetHasClass("stat_top_3x4", on === true);
  }
}

// 顶部数据
function GetPublicData(data) {
  if (!data) {
    return;
  }
  GetRoot().style.opacity = data.page;
  GameTp = data.change;
  /* 仅 rank_3x4 需要 .stat_top_3x4；5v5/1v1 若误加会整块顶栏偏左、不居中 */
  SetStatTop3x4Layout(data.change == 2);
  var bacTop = GetPanel("bac_img");
  // 5v5
  if (data.change == 0) {
    if (bacTop) {
      bacTop.SetHasClass("t3x4", false);
      bacTop.SetHasClass("t5v5", true);
      bacTop.SetHasClass("t1v10", false);
    }
    GetPanel("box_1").visible = true;
    GetPanel("box_2").visible = false;
    if (Length(data.list) !== 0) {
      var team1 = data.list.team_1;
      var leftpanel = GetPanel("list_left");
      if (team1) {
        GetPanel("box_1").FindChildTraverse("num_label_left").text =
          team1.kill != null ? team1.kill : 0;
        SetPlayer(team1.list || {}, leftpanel, 1);
      }
      var team2 = data.list.team_2;
      var rightpanel = GetPanel("list_right");
      if (team2) {
        GetPanel("box_1").FindChildTraverse("num_label_right").text =
          team2.kill != null ? team2.kill : 0;
        SetPlayer(team2.list || {}, rightpanel, 2);
      }
    }
  } else if (data.change == 2) {
    InitTopList();
    GetPanel("box_1").visible = false;
    GetPanel("box_2").visible = true;
    // rank_3x4：盾牌日/夜图 + 服务端 kill_target（与 5v5/1v1 顶图分离）
    if (bacTop) {
      bacTop.SetHasClass("t5v5", false);
      bacTop.SetHasClass("t1v10", false);
      bacTop.SetHasClass("t3x4", true);
    }
    var teamdata4 = data.list;
    var panel4 = GetPanel("box_2_list");
    SetPlayer4Teams(teamdata4, panel4);
  } else {
    InitTopList();
    // print(data);
    // 1v10
    if (bacTop) {
      bacTop.SetHasClass("t3x4", false);
      bacTop.SetHasClass("t5v5", false);
      bacTop.SetHasClass("t1v10", true);
    }
    GetPanel("box_1").visible = false;
    GetPanel("box_2").visible = true;
    var teamdata = data.list;
    var panel = GetPanel("box_2_list");
    SetPlayer10(teamdata, panel);
  }
  var r =
    GameUI.CustomUIConfig &&
    GameUI.CustomUIConfig()._clrb_ScoreboardRefreshTopStatKills;
  if (typeof r === "function") {
    r(data);
  } else {
    $.Schedule(0, function () {
      var r2 =
        GameUI.CustomUIConfig &&
        GameUI.CustomUIConfig()._clrb_ScoreboardRefreshTopStatKills;
      if (typeof r2 === "function") {
        r2(data);
      }
    });
  }
}

// rank_3x4：四队 × 三人（固定 team_1～4 从左到右对应服务端槽位，不按击杀排序，减轻客户端每帧重排）
function SetPlayer4Teams(listdata, panel) {
  for (var i = 1; i <= 4; i++) {
    var teamkey = "team_" + i;
    var sonpanel = panel.FindChildTraverse(teamkey);
    if (!sonpanel) {
      continue;
    }
    var teamData = listdata[teamkey];
    if (!teamData || teamData.state != 1) {
      sonpanel.style.opacity = 0;
      sonpanel.hittest = false;
      continue;
    }
    sonpanel.style.opacity = teamData.state;
    sonpanel.FindChildTraverse("num_label_left").text = teamData.kill;
    sonpanel
      .FindChildTraverse("img_color")
      .SetImage("raw://resource/flash3/images/team/1_" + teamData.team + ".png");
    var rowPanel = sonpanel.FindChildTraverse("heroes_row");
    var players = [];
    $.Each(teamData.list, function (v, k) {
      if (v && v.state == 1) {
        players.push(v);
      }
    });
    players.sort(function (a, b) {
      return (a.gid || 0) - (b.gid || 0);
    });
    var myid = Game.GetLocalPlayerID();
    var hasMe = false;
    for (var j = 0; j < players.length; j++) {
      if (players[j].id == myid) {
        hasMe = true;
      }
    }
    sonpanel.SetHasClass("myself", hasMe);
    var teamRgb = colortab[teamData.team] || colortab[1];
    var activeHeroIds = {};
    for (var j2 = 0; j2 < players.length; j2++) {
      (function (playerData, side, gid) {
        var hpId = "p_" + side + "_" + gid;
        activeHeroIds[hpId] = true;
        var hp = rowPanel.FindChildTraverse(hpId);
        if (!hp) {
          hp = NewPanel(rowPanel, hpId, "Panel");
          hp.BLoadLayoutSnippet("player_snippet");
        }
        var hc = hp.FindChildTraverse("hero_color");
        if (hc && hc.style) {
          hc.style.backgroundColor = teamRgb;
        }
        UpdatePlayerSnippet(hp, playerData, {
          tp: "peer",
          side: side,
          gid: gid,
        });
      })(players[j2], teamData.slot, players[j2].gid);
    }
    RemoveStaleChildPanels(rowPanel, activeHeroIds);
    sonpanel.hittest = true;
  }
}
// 1v1
function SetPlayer10(listdata, panel) {
  var teams = [];
  $.Each(listdata, function (v, k) {
    if (v && v.state == 1) {
      teams.push(v);
    }
  });
  teams.sort(function (a, b) {
    return (a.rank || 999) - (b.rank || 999);
  });
  for (var i = 1; i <= 10; i++) {
    var teamkey = "team_" + i;
    var sonpanel = panel.FindChildTraverse(teamkey);
    if (!sonpanel) {
      continue;
    }
    var teamData = teams[i - 1];
    if (!teamData) {
      sonpanel.style.opacity = 0;
      sonpanel.hittest = false;
      continue;
    }

    var playerkey = "player_" + teamData.team;
    var playerData = teamData.list[playerkey];
    if (!playerData) {
      sonpanel.style.opacity = 0;
      sonpanel.hittest = false;
      continue;
    }

    sonpanel.style.opacity = teamData.state;
    sonpanel.FindChildTraverse("num_label_left").text = teamData.kill;
    ClrbStatSetHeroImg(sonpanel.FindChildTraverse("hero_img"), playerData.hero);
    sonpanel
      .FindChildTraverse("img_color")
      .SetImage("raw://resource/flash3/images/team/1_" + playerData.team + ".png");
    sonpanel.FindChildTraverse("hero_color").style.backgroundColor =
      colortab[playerData.team];

    if (playerData.online == 1) {
      sonpanel.style.brightness = 1;
    } else {
      sonpanel.style.brightness = 0.1;
    }

    var playerId = playerData.id;
    if (playerData.alive == 1) {
      ClearResurrection(playerId);
      sonpanel.FindChildTraverse("hero_bottom").visible = false;
      sonpanel.FindChildTraverse("hero_img").style.washColor = "none";
      sonpanel.FindChildTraverse("hero_img").style.saturation = 1;
    } else {
      sonpanel.FindChildTraverse("hero_bottom").visible = true;
      sonpanel.FindChildTraverse("hero_img").style.washColor = "#b8b8b8";
      sonpanel.FindChildTraverse("hero_img").style.saturation = 0.2;
      var displayTime = GetResurrectionRemaining(playerId, playerData.time);
      DeathTime(sonpanel, displayTime, playerId);
    }

    var myid = Game.GetLocalPlayerID();
    if (playerData.id == myid) {
      sonpanel.SetHasClass("myself", true);
    } else {
      sonpanel.SetHasClass("myself", false);
    }

    sonpanel.hittest = true;
    (function (row) {
      //打印单机板的信息
      // print(row)
      sonpanel.SetPanelEvent("onmouseactivate", function () {
        var pl = { data: { tp: "peer", row: row } };
        SendServer("Lua_HeroCard", pl);
      });
    })(i);
  }
}

// 5v5 side: 1=左队 team_1，2=右队 team_2；gid 与 Stat.Public player_N 一致
function SetPlayer(playerlist, panel, side) {
  if (Length(playerlist) === 0) {
    RemoveStaleChildPanels(panel, {});
    return;
  }
  var players = [];
  $.Each(playerlist, function (v, k) {
    if (v && v.state == 1) {
      players.push(v);
    }
  });
  players.sort(function (a, b) {
    return (a.gid || 0) - (b.gid || 0);
  });
  var activeIds = {};
  var myid = Game.GetLocalPlayerID();
  var hasMe = false;
  $.Each(players, function (v, _) {
    if (v.id == myid) {
      hasMe = true;
    }
    var k = "player_" + v.gid;
    activeIds[k] = true;
    var sonpanel = panel.FindChildTraverse(k);
    if (!sonpanel) {
      sonpanel = NewPanel(panel, k, "Panel");
      sonpanel.BLoadLayoutSnippet("player_snippet");
    }
    UpdatePlayerSnippet(sonpanel, v, {
      tp: "peer",
      side: side,
      gid: v.gid,
    });
  });
  RemoveStaleChildPanels(panel, activeIds);
  var box =
    panel.GetParent() &&
    panel.GetParent().GetParent() &&
    panel.GetParent().GetParent().GetParent();
  if (box) {
    box.SetHasClass("myself_bac", hasMe);
  }
}

function DeathTime(panel, time, playerId) {
  if (!panel) {
    return;
  }
  if (playerId !== undefined && ResurrectionTimerActive[playerId]) {
    return;
  }
  if (panel && panel.IsValid()) {
    if (playerId !== undefined) {
      ResurrectionTimerActive[playerId] = true;
    }
    SetTime(panel, time, playerId);
  }
}
function SetTime(panel, time, playerId) {
  if (!panel) {
    return;
  }
  if (panel && panel.IsValid()) {
    panel.FindChildTraverse("hero_time").text = time;
    if (time > 0) {
      Timers(1, function () {
        SetTime(panel, time - 1, playerId);
      });
    } else if (playerId !== undefined) {
      delete ResurrectionTimerActive[playerId];
    }
  }
}

//顶部列表：0=5v5；1=1v1；2=rank_3x4 四队
var GameTp = 0;
var InitTopListState = false;

//初始化顶部计分栏
function InitTopList() {
  if (InitTopListState == true) {
    return;
  }
  if (GameTp != 1 && GameTp != 2) {
    return;
  }
  InitTopListState = true;
  var panel = GetPanel("box_2_list");
  var count = GameTp == 1 ? 10 : 4;
  var snippet = GameTp == 1 ? "player_2_snippet" : "team_4x_row";
  for (var i = 1; i <= count; i++) {
    var sonpanel = NewPanel(panel, "team_" + i, "Panel");
    sonpanel.BLoadLayoutSnippet(snippet);
    if (GameTp == 2) {
      sonpanel.AddClass("clrb_3x4_team_row");
    }
  }
}

function ShowTips(panel, name) {
  WhenOver(panel, function () {
    $.DispatchEvent("DOTAShowAbilityTooltip", panel, name);
  });
  WhenOut(panel, function () {
    $.DispatchEvent("DOTAHideAbilityTooltip", panel);
  });
}

(function () {
  InitData();
  GetTime();
  //获取左侧计分板数据
  // SubEvent("UI_Stat", GetData);
  //获取顶部列表数据
  SubEvent("UI_TopStat", GetPublicData);
})();