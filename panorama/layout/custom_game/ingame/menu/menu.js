--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function OpenPage(num) {
  var tp = "OpenPage";
  var SendTp = "";
  if (num == 1) {
    SendTp = "Lua_Person";
    GameUI.CustomUIConfig().Home_Click_Show_Public("person");
  }
  if (num == 2) {
    SendTp = "Lua_Invite";
  }
  if (num == 3) {
    SendTp = "Lua_Shop";
    GameUI.CustomUIConfig().Home_Click_Show_Public("shop");
    return;
  }
  if (num == 7) {
    SendTp = "Lua_Shop";
    GameUI.CustomUIConfig().Home_Click_Show_Public("battlepass");
    return;
  }
  if (num == 8) {
    SendTp = "Lua_Shop";
    GameUI.CustomUIConfig().Home_Click_Show_Public("store");
    return;
  }
  if (num == 4) {
    SendTp = "Lua_Rank";
    var publicPanel = $("#Public");
    if (publicPanel) publicPanel.style.opacity = "0";
    SendServer(SendTp, { data: { tp: tp, task_page: 1 } });
    return;
  }
  if (num == 5) {
    SendTp = "Lua_Rank";
    var publicPanel = $("#Public");
    if (publicPanel) publicPanel.style.opacity = "0";
    SendServer(SendTp, { data: { tp: tp, task_page: 2 } });
    return;
  }
  if (num == 6) {
    SendTp = "Lua_Book";
  }
  if (num == 9) {
    var publicPanel = $("#Public");
    if (publicPanel) {
      publicPanel.style.opacity = "0";
    }
    if (GameUI.CustomUIConfig().Achieve_OpenPage) {
      GameUI.CustomUIConfig().Achieve_OpenPage();
    }
    return;
  }
  // print(SendTp);
  // print(tp);
  SendServer(SendTp, { data: { tp } });
}

function OpenScoreboard() {
  var tp = "OpenPage";
  SendServer("Lua_Stat", { data: { tp } });
}

function OpenLeaveConfirm() {
  var tp = "OpenPage";
  SendServer("Lua_LeaveConfirm", { data: { tp } });
}

function hideHud() {
  var hud = GetRoot(6);
  if (!hud || !hud.FindChildTraverse) {
    return;
  }
  var quickstats = hud.FindChildTraverse("quickstats");
  if (quickstats) {
    quickstats.style.marginTop = "85px";
  }
  if (typeof ClrbEnsureNativeSettingsHud === "function") {
    try {
      ClrbEnsureNativeSettingsHud();
    } catch (e) { }
  }
}

/** 设置按钮穿透到原生 SettingsRebornButton，并清掉旧版 onactivate=OpenSetting */
function MenuApplySettingsClickThrough() {
  var setBtn = $("#set_button_id");
  if (!setBtn) {
    return;
  }
  setBtn.hittest = false;
  if (setBtn.ClearPanelEvent) {
    setBtn.ClearPanelEvent("onactivate");
  }
  var children = setBtn.Children && setBtn.Children();
  if (children) {
    for (var i = 0; i < children.length; i++) {
      children[i].hittest = false;
    }
  }
  if (typeof ClrbEnsureNativeSettingsHud === "function") {
    try {
      ClrbEnsureNativeSettingsHud();
    } catch (e) { }
  }
}

function MenuApplySettingsClickThroughRetry() {
  MenuApplySettingsClickThrough();
  $.Schedule(0.2, MenuApplySettingsClickThrough);
  $.Schedule(0.5, MenuApplySettingsClickThrough);
  $.Schedule(1.0, MenuApplySettingsClickThrough);
}

/** 菜单图标统一在 JS 中 SetImage，避免 XML src 编译异常导致图标丢失 */
var CLRB_MENU_ICON_PATHS = {
  menu_icon_exit: "file://{images}/custom_game/tuichu.png",
  menu_icon_setting: "file://{images}/custom_game/shezhi.png",
  menu_icon_scoreboard: "file://{images}/custom_game/jifenban.png",
  menu_icon_shop: "file://{images}/custom_game/shangdian.png",
  menu_icon_achieve: "file://{images}/custom_game/chengjiu.png",
  menu_icon_record: "file://{images}/custom_game/zanji.png",
  menu_icon_book: "file://{images}/custom_game/book.png",
};

function InitMenuIcons() {
  for (var id in CLRB_MENU_ICON_PATHS) {
    if (!CLRB_MENU_ICON_PATHS.hasOwnProperty(id)) {
      continue;
    }
    var img = GetPanel(id);
    if (img) {
      img.SetImage(CLRB_MENU_ICON_PATHS[id]);
    }
  }
}

function MenuGetAchieveRedDotPanel() {
  var menu = $("#Menu");
  if (menu && menu.FindChildTraverse) {
    var dot = menu.FindChildTraverse("menu_achieve_red_dot");
    if (dot) {
      return dot;
    }
  }
  return $("#menu_achieve_red_dot");
}

function MenuSetAchieveRedDot(show) {
  var dot = MenuGetAchieveRedDotPanel();
  if (!dot) {
    return;
  }
  var on = !!show;
  dot.visible = on;
  if (on) {
    dot.AddClass("visible");
  } else {
    dot.RemoveClass("visible");
  }
}

function MenuOnAchieveData(data) {
  if (!data) {
    return;
  }
  if (data.has_claimable !== undefined && data.has_claimable !== null) {
    MenuSetAchieveRedDot(data.has_claimable === true || data.has_claimable === 1);
    return;
  }
  var refresh = GameUI.CustomUIConfig().Achieve_RefreshMenuRedDot;
  if (typeof refresh === "function") {
    refresh();
  }
}

function InitMenuIconsRetry() {
  InitMenuIcons();
  $.Schedule(0.2, InitMenuIcons);
  $.Schedule(1.0, InitMenuIcons);
}

(function () {
  hideHud();
  MenuApplySettingsClickThroughRetry();
  InitMenuIconsRetry();
  GameUI.CustomUIConfig().Menu_SetAchieveRedDot = MenuSetAchieveRedDot;
  SubEvent("UI_Achieve", MenuOnAchieveData);
})();