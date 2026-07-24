--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


// 与 Prophecy.UI_ENABLED 同步
var PROPHECY_UI_TEMP_HIDDEN = false;
var PROPHECY_CARD_ICON = "raw://resource/flash3/images/achive/yyk.png";
/** 本局预言：点击后锁定，失败才解锁，成功保持锁定 */
var prophecyAnnounceRequestSent = false;

function GetProphecyPanel() {
  var content = GetPanel("prophecy_content");
  if (content) {
    var parent = content.GetParent();
    if (parent) {
      return parent;
    }
  }
  return GetRoot();
}

function InitData() {
  SendServer("Lua_Prophecy", { data: { tp: "init" } });
}

function ScheduleInitSync() {
  InitData();
  var delays = [0.5, 1.5, 3];
  for (var i = 0; i < delays.length; i++) {
    (function (sec) {
      $.Schedule(sec, function () {
        InitData();
      });
    })(delays[i]);
  }
}

var gProphecyWindowEnd = 0;
var gProphecyCountdownTimer = null;

function GetGameTimeSec() {
  return Math.floor(Game.GetDOTATime(true, true));
}

function FormatRemainSec(sec) {
  sec = Math.max(0, Math.ceil(sec));
  var min = Math.floor(sec / 60);
  var mm = sec - min * 60;
  var minText = min.toString();
  var secText = mm.toString();
  if (mm < 10) {
    secText = "0" + secText;
  }
  return minText + ":" + secText;
}

function StopCountdown() {
  if (gProphecyCountdownTimer != null) {
    $.CancelScheduled(gProphecyCountdownTimer);
    gProphecyCountdownTimer = null;
  }
}

function SetCountdownText(text) {
  var label = GetPanel("prophecy_countdown");
  if (label) {
    label.text = text;
    return;
  }
  var title = GetPanel("prophecy_title");
  if (title) {
    title.text = "是否进行预测\n" + text;
  }
}

function UpdateCountdownLabel() {
  var remain = gProphecyWindowEnd - GetGameTimeSec();
  if (remain <= 0) {
    SetCountdownText("剩余 0:00");
    StopCountdown();
    return;
  }
  SetCountdownText("剩余 " + FormatRemainSec(remain));
  gProphecyCountdownTimer = $.Schedule(0.2, UpdateCountdownLabel);
}

function StartCountdown(windowEndTime) {
  gProphecyWindowEnd = parseInt(windowEndTime, 10);
  if (isNaN(gProphecyWindowEnd) || gProphecyWindowEnd <= 0) {
    gProphecyWindowEnd = GetGameTimeSec() + 120;
  }
  StopCountdown();
  UpdateCountdownLabel();
}

function SetAnnounceEnabled(canAnnounce) {
  var btn = GetPanel("prophecy_btn_announce");
  if (!btn) {
    return;
  }
  btn.enabled = canAnnounce;
  btn.SetHasClass("prophecy_btn_disabled", !canAnnounce);
}

function InitProphecyCardIcon() {
  var img = GetPanel("prophecy_card_img");
  if (img && img.SetImage) {
    img.SetImage(PROPHECY_CARD_ICON);
    if (img.SetScaling) {
      img.SetScaling("stretch-to-fit-preserve-aspect");
    }
  }
}

function UpdateProphecyCardCount(count) {
  var numLbl = GetPanel("prophecy_card_num");
  if (!numLbl) {
    return;
  }
  var n = Number(count);
  if (!isFinite(n) || n < 0) {
    n = 0;
  }
  numLbl.text = String(Math.floor(n));
}

function GetData(data) {
  if (!data) {
    return;
  }
  var panel = GetProphecyPanel();
  if (PROPHECY_UI_TEMP_HIDDEN) {
    panel.style.opacity = 0;
    panel.hittest = false;
    StopCountdown();
    return;
  }
  var on = data.page === 1 || data.page === true;
  panel.style.opacity = on ? 1 : 0;
  panel.hittest = on;
  var title = GetPanel("prophecy_title");
  if (title && !on) {
    title.text = "是否进行预测";
  }
  if (on) {
    StartCountdown(data.window_end_time);
  } else {
    StopCountdown();
  }
  var announcing =
    data.announcing === 1 ||
    data.announcing === true ||
    data.announcing === "1";
  var announced =
    data.announced === 1 ||
    data.announced === true ||
    data.announced === "1";
  if (announced || announcing) {
    prophecyAnnounceRequestSent = true;
  } else if (prophecyAnnounceRequestSent && !announcing && !announced) {
    // 服务端扣卡失败回滚 announcing
    prophecyAnnounceRequestSent = false;
  }
  var canAnnounce =
    !announcing &&
    !announced &&
    !prophecyAnnounceRequestSent &&
    (data.can_announce === 1 ||
      data.can_announce === true ||
      data.can_announce === "1");
  SetAnnounceEnabled(canAnnounce);
  if (
    data.prophecy_card_count !== undefined &&
    data.prophecy_card_count !== null
  ) {
    UpdateProphecyCardCount(data.prophecy_card_count);
  }
}

function OnProphecyAnnounce() {
  var btn = GetPanel("prophecy_btn_announce");
  if (btn && !btn.enabled) {
    return;
  }
  if (prophecyAnnounceRequestSent) {
    return;
  }
  prophecyAnnounceRequestSent = true;
  SetAnnounceEnabled(false);
  SendServer("Lua_Prophecy", { data: { tp: "Announce" } });
}

function OnProphecyClose() {
  SendServer("Lua_Prophecy", { data: { tp: "Close" } });
}

(function () {
  InitProphecyCardIcon();
  SubEvent("UI_Prophecy", GetData);
  ScheduleInitSync();
})();