function Init() {
  //英雄选择界面中上边的队伍信息
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS,
    false
  );
  //英雄选择界面的倒计时
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK,
    false
  );
  //英雄选择界面中上边的队伍信息
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS,
    false
  );
  //英雄选择界面显示的游戏名字
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME,
    false
  );
  //顶部时间
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY,
    false
  );
  // 顶部分数与人头像：使用自制 Stat 顶部计分板 + GameUI.SelectUnit，不启用默认头像条
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES,
    false
  );
  // 选择英雄后的那个决策界面
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_PREGAME_STRATEGYUI,
    false
  );
  //信使相关按钮
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER,
    false
  );
  //建议出装
  // GameUI.SetDefaultUIEnabled(
  //   DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS,
  //   false
  // );
  // 左上角计分板
  GameUI.SetDefaultUIEnabled(
    DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS,
    false
  );
}

/* 与 SelectHero.js 中 CLRB_TEAM_COLOR_FALLBACK 使用同一套队伍色（含 1v1 的 CUSTOM_3～8），
   供队伍分配界面 team_select_team、小地图、以及 ClrbGetTeamUiColorHex 读取 team_colors 时一致。 */
function ClrbApplyClrbTeamColorsForHud() {
  var cfg = GameUI.CustomUIConfig();
  if (!cfg) {
    return;
  }
  var tc = cfg.team_colors;
  if (!tc) {
    tc = {};
    cfg.team_colors = tc;
  }
  function setTeam(teamId, hex6) {
    var h = hex6.indexOf(";") >= 0 ? hex6 : hex6 + ";";
    tc[teamId] = h;
    tc[String(teamId)] = h;
  }
  if (typeof DOTATeam_t !== "undefined") {
    setTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS, "#3d8f5c");
    setTeam(DOTATeam_t.DOTA_TEAM_BADGUYS, "#8f3d3d");
    setTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_1, "#5c9fd4");
    setTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_2, "#d49f5c");
    setTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_3, "#5588c8");
    setTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_4, "#c85588");
    setTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_5, "#88c855");
    setTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_6, "#55c8a8");
    setTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_7, "#c8a855");
    setTeam(DOTATeam_t.DOTA_TEAM_CUSTOM_8, "#8855c8");
  } else {
    setTeam(2, "#3d8f5c");
    setTeam(3, "#8f3d3d");
    setTeam(6, "#5c9fd4");
    setTeam(7, "#d49f5c");
    setTeam(8, "#5588c8");
    setTeam(9, "#c85588");
    setTeam(10, "#88c855");
    setTeam(11, "#55c8a8");
    setTeam(12, "#c8a855");
    setTeam(13, "#8855c8");
  }
}

function HideHero() {
  //玩家列表标题
  //  panel.FindChildTraverse("TeamHeader").visible = false;
  // GetPanel("CustomUIRoot").FindChildTraverse("TeamHeader").visible = false;
  var hud = GetRoot(3);
  var panel = hud.FindChildTraverse("PreGame");
  hud.FindChildTraverse("KillCam").visible = false;
  // 所有英雄列表内容
  panel.FindChildTraverse("MainContents").visible = false;
  // 英雄选择界面
  panel.FindChildTraverse("HeroPickScreen").visible = false;
  // 选择界面的前后按钮
  panel.FindChildTraverse("BacktoHeroGrid").visible = false;
  //panel.FindChildTraverse("RightContainerMain").visible = false;
  panel.FindChildTraverse("SelectedAbilitiesContainer").visible = false;
  panel.FindChildTraverse("StrategyTabTopRow").visible = false;
  hud.FindChildTraverse("StickyItemSlotContainer").visible = false;
  // hud.FindChildTraverse("ItemsCombines").visible = false;
  // panel.FindChildTraverse("HeroModelLoadout").style.marginLeft = "500px";
  // panel.FindChildTraverse("SelectionChoice").style.marginLeft = "500px";
  // panel.FindChildTraverse("FacetPicker").style.marginLeft = "500px";
  // panel.FindChildTraverse("StrategyHeroBadge").visible = false;
  // //背景
  panel.FindChildTraverse("PregameBG").visible = false;
  // //小地图聊天
  panel.FindChildTraverse("BottomPanelsContainer").visible = false;

  hud.FindChildTraverse("RoshanTimer").visible = false;
  hud.FindChildTraverse("TormentorTimerContainer").visible = false;
  // hud.FindChildTraverse("inventory_neutral_slot_container").visible = false;
  hud.FindChildTraverse("inventory_neutral_craft_holder").visible = false;
  // hud.FindChildTraverse("inventory_tpscroll_container").visible = false;
  hud.FindChildTraverse("GlyphScanContainer").visible = false;
  hud.FindChildTraverse("right_flare").style.height = "160px";
  //hud.FindChildTraverse("#inventory").style.height = "300px";
  // for(i=1;i<=6;i++){
  //   var drag_panel = hud.FindChildTraverse()
  // }

  // 返回
  var dashboardBtn = panel.FindChildTraverse("DashboardButton");
  if (dashboardBtn) {
    dashboardBtn.visible = false;
  }
  // 设置
  var settingsBtn = panel.FindChildTraverse("SettingsRebornButton");
  if (settingsBtn) {
    settingsBtn.visible = true;
    settingsBtn.style.opacity = "0.01";
  }
}

// function Clickm() {
//   GameUI.SetMouseCallback(function (eventName, arg) {
//     //print(eventName)
//     var CONSUME_EVENT = true;
//     var CONTINUE_PROCESSING_EVENT = false;
//     //print(arg)
//     if (arg == 0) {
//       var order = {};
//       order.Position = GameUI.GetScreenWorldPosition(
//         GameUI.GetCursorPosition()
//       );
//       //print(order)
//       var index = GameUI.FindScreenEntities(GameUI.GetCursorPosition());
//       //print(index)
//       if (index.length == 0) {
//         return;
//       }
//       var tp = "GetUnit";
//       var text = index;
//       SendServer("Lua_PackData", { data: { tp, text } });
//     }
//     return CONTINUE_PROCESSING_EVENT;
//   });
// }

(function () {
  Init();
  ClrbApplyClrbTeamColorsForHud();
  HideHero();
  if (typeof ClrbEnsureNativeSettingsHud === "function") {
    try {
      ClrbEnsureNativeSettingsHud();
    } catch (e) {}
  }
  if (typeof ClrbBindTalentTpSlotTooltip === "function") {
    try {
      ClrbBindTalentTpSlotTooltip();
    } catch (e2) {}
  }
  // Clickm();

  // 首连时原生 HUD 金币可能仍为 0：客户端就绪后通知服务端补推
  (function ClrbReconnectGoldSyncWatch() {
    var attempts = 0;
    var maxAttempts = 10;
    function tick() {
      attempts++;
      if (attempts > maxAttempts) {
        return;
      }
      var pid = Game.GetLocalPlayerID();
      if (pid === undefined || pid === null || pid < 0) {
        $.Schedule(1.5, tick);
        return;
      }
      if (typeof Game.GetState === "function" && Game.GetState() < 5) {
        $.Schedule(1.5, tick);
        return;
      }
      var info = Game.GetPlayerInfo(pid);
      if (!info) {
        $.Schedule(1.5, tick);
        return;
      }
      var heroIdx = info.player_selected_hero_entity_index;
      if (heroIdx > 0 && info.player_gold > 0) {
        return;
      }
      if (heroIdx > 0 && info.player_gold === 0) {
        if (typeof SendServer === "function") {
          SendServer("Lua_SelectHero", { data: { tp: "ReconnectGoldSync" } });
        }
      }
      $.Schedule(1.5, tick);
    }
    $.Schedule(2.0, tick);
  })();
})();
