function InitData() {
  var tp = "init";
  SendServer("Lua_SelectHero", { data: { tp } });

}

// 英雄 unit 名（npc_dota_hero_*）→ 官方 HeroID；用法：hero_list["npc_dota_hero_axe"] 或 GetHeroIdByName("axe")
var hero_list = {
  "npc_dota_hero_antimage": 1,
  "npc_dota_hero_axe": 2,
  "npc_dota_hero_bane": 3,
  "npc_dota_hero_bloodseeker": 4,
  "npc_dota_hero_crystal_maiden": 5,
  "npc_dota_hero_drow_ranger": 6,
  "npc_dota_hero_earthshaker": 7,
  "npc_dota_hero_juggernaut": 8,
  "npc_dota_hero_mirana": 9,
  "npc_dota_hero_morphling": 10,
  "npc_dota_hero_nevermore": 11,
  "npc_dota_hero_phantom_lancer": 12,
  "npc_dota_hero_puck": 13,
  "npc_dota_hero_pudge": 14,
  "npc_dota_hero_razor": 15,
  "npc_dota_hero_sand_king": 16,
  "npc_dota_hero_storm_spirit": 17,
  "npc_dota_hero_sven": 18,
  "npc_dota_hero_tiny": 19,
  "npc_dota_hero_vengefulspirit": 20,
  "npc_dota_hero_windrunner": 21,
  "npc_dota_hero_zuus": 22,
  "npc_dota_hero_kunkka": 23,
  "npc_dota_hero_lina": 25,
  "npc_dota_hero_lion": 26,
  "npc_dota_hero_shadow_shaman": 27,
  "npc_dota_hero_slardar": 28,
  "npc_dota_hero_tidehunter": 29,
  "npc_dota_hero_witch_doctor": 30,
  "npc_dota_hero_lich": 31,
  "npc_dota_hero_riki": 32,
  "npc_dota_hero_enigma": 33,
  "npc_dota_hero_tinker": 34,
  "npc_dota_hero_sniper": 35,
  "npc_dota_hero_necrolyte": 36,
  "npc_dota_hero_warlock": 37,
  "npc_dota_hero_beastmaster": 38,
  "npc_dota_hero_queenofpain": 39,
  "npc_dota_hero_venomancer": 40,
  "npc_dota_hero_faceless_void": 41,
  "npc_dota_hero_skeleton_king": 42,
  "npc_dota_hero_death_prophet": 43,
  "npc_dota_hero_phantom_assassin": 44,
  "npc_dota_hero_pugna": 45,
  "npc_dota_hero_templar_assassin": 46,
  "npc_dota_hero_viper": 47,
  "npc_dota_hero_luna": 48,
  "npc_dota_hero_dragon_knight": 49,
  "npc_dota_hero_dazzle": 50,
  "npc_dota_hero_rattletrap": 51,
  "npc_dota_hero_leshrac": 52,
  "npc_dota_hero_furion": 53,
  "npc_dota_hero_life_stealer": 54,
  "npc_dota_hero_dark_seer": 55,
  "npc_dota_hero_clinkz": 56,
  "npc_dota_hero_omniknight": 57,
  "npc_dota_hero_enchantress": 58,
  "npc_dota_hero_huskar": 59,
  "npc_dota_hero_night_stalker": 60,
  "npc_dota_hero_broodmother": 61,
  "npc_dota_hero_bounty_hunter": 62,
  "npc_dota_hero_weaver": 63,
  "npc_dota_hero_jakiro": 64,
  "npc_dota_hero_batrider": 65,
  "npc_dota_hero_chen": 66,
  "npc_dota_hero_spectre": 67,
  "npc_dota_hero_ancient_apparition": 68,
  "npc_dota_hero_doom_bringer": 69,
  "npc_dota_hero_ursa": 70,
  "npc_dota_hero_spirit_breaker": 71,
  "npc_dota_hero_gyrocopter": 72,
  "npc_dota_hero_alchemist": 73,
  "npc_dota_hero_invoker": 74,
  "npc_dota_hero_silencer": 75,
  "npc_dota_hero_obsidian_destroyer": 76,
  "npc_dota_hero_lycan": 77,
  "npc_dota_hero_brewmaster": 78,
  "npc_dota_hero_shadow_demon": 79,
  "npc_dota_hero_lone_druid": 80,
  "npc_dota_hero_chaos_knight": 81,
  "npc_dota_hero_meepo": 82,
  "npc_dota_hero_treant": 83,
  "npc_dota_hero_ogre_magi": 84,
  "npc_dota_hero_undying": 85,
  "npc_dota_hero_rubick": 86,
  "npc_dota_hero_disruptor": 87,
  "npc_dota_hero_nyx_assassin": 88,
  "npc_dota_hero_naga_siren": 89,
  "npc_dota_hero_keeper_of_the_light": 90,
  "npc_dota_hero_wisp": 91,
  "npc_dota_hero_visage": 92,
  "npc_dota_hero_slark": 93,
  "npc_dota_hero_medusa": 94,
  "npc_dota_hero_troll_warlord": 95,
  "npc_dota_hero_centaur": 96,
  "npc_dota_hero_magnataur": 97,
  "npc_dota_hero_shredder": 98,
  "npc_dota_hero_bristleback": 99,
  "npc_dota_hero_tusk": 100,
  "npc_dota_hero_skywrath_mage": 101,
  "npc_dota_hero_abaddon": 102,
  "npc_dota_hero_elder_titan": 103,
  "npc_dota_hero_legion_commander": 104,
  "npc_dota_hero_techies": 105,
  "npc_dota_hero_ember_spirit": 106,
  "npc_dota_hero_earth_spirit": 107,
  "npc_dota_hero_abyssal_underlord": 108,
  "npc_dota_hero_terrorblade": 109,
  "npc_dota_hero_phoenix": 110,
  "npc_dota_hero_oracle": 111,
  "npc_dota_hero_winter_wyvern": 112,
  "npc_dota_hero_arc_warden": 113,
  "npc_dota_hero_monkey_king": 114,
  "npc_dota_hero_dark_willow": 119,
  "npc_dota_hero_pangolier": 120,
  "npc_dota_hero_grimstroke": 121,
  "npc_dota_hero_hoodwink": 123,
  "npc_dota_hero_void_spirit": 126,
  "npc_dota_hero_target_dummy": 127,
  "npc_dota_hero_snapfire": 128,
  "npc_dota_hero_mars": 129,
  "npc_dota_hero_ringmaster": 131,
  "npc_dota_hero_dawnbreaker": 135,
  "npc_dota_hero_marci": 136,
  "npc_dota_hero_primal_beast": 137,
  "npc_dota_hero_muerta": 138,
  "npc_dota_hero_kez": 145,
  "npc_dota_hero_largo": 155,
};

function GetHeroIdByName(heroName) {
  if (heroName == null || heroName === "") return undefined;
  var key =
    heroName.indexOf("npc_dota_hero_") === 0
      ? heroName
      : "npc_dota_hero_" + heroName;
  return hero_list[key];
}

//选属性
function SelectAttr(num) {
  if (HeroSelect == true) {
    return;
  }
  var tp = "SelectAttr";
  var text = num;
  // SendServer("Lua_SelectHero", { data: { tp, text } });
}

//重新随机
function RollHero() {
  if (HeroSelect == true) {
    return;
  }
  var tp = "RollHero";
  SendServer("Lua_SelectHero", { data: { tp } });
}

//加次数
function AddRefresh() {
  if (HeroSelect == true) {
    return;
  }
  var tp = "AddRefresh";
  SendServer("Lua_SelectHero", { data: { tp } });
}

function SelectFace(num) {
  HeroFace = num;
}

var HeroFace = 1;
// 默认0
var check = 0;
//选英雄

var HeroSelect = false;
// 最近一次选英雄面板的三个槽数据（含 rmb_battle / rmb_abilities）
var lastSelectHeroList = null;
// 选人天赋 1–9，默认 1；与服务端 SelectHero.Data[ID].talent_index 同步
var selectTalentIndex = 1;
// 暂时隐藏的天赋（与 SelectHero.HiddenTalentIndices 同步；空对象=全部可选）
var clrbHiddenTalentIndices = {};

function isClrbTalentHidden(n) {
  return clrbHiddenTalentIndices[Number(n)] === true;
}

function sanitizeClrbTalentIndex(ti) {
  var v = Number(ti);
  if (!isFinite(v) || v < 1 || v > 9 || isClrbTalentHidden(v)) {
    return 1;
  }
  return v;
}

function applyClrbHiddenTalentCells(hiddenList) {
  // 服务端下发时一律覆盖（含空列表=取消全部隐藏）；无参调用则沿用当前表
  if (hiddenList !== undefined && hiddenList !== null) {
    clrbHiddenTalentIndices = {};
    var i;
    if (hiddenList.length !== undefined) {
      for (i = 0; i < hiddenList.length; i++) {
        clrbHiddenTalentIndices[Number(hiddenList[i])] = true;
      }
    } else {
      for (var k in hiddenList) {
        if (Object.prototype.hasOwnProperty.call(hiddenList, k)) {
          clrbHiddenTalentIndices[Number(hiddenList[k])] = true;
        }
      }
    }
  }
  for (var n = 1; n <= 9; n++) {
    var cell = GetPanel("talent_cell_" + n);
    if (cell) {
      cell.visible = !isClrbTalentHidden(n);
    }
  }
}

function RefreshSelectTalentVisual() {
  for (var n = 1; n <= 9; n++) {
    var cell = GetPanel("talent_cell_" + n);
    if (cell) {
      if (n === selectTalentIndex) {
        cell.AddClass("SelectTalentCellSelected");
      } else {
        cell.RemoveClass("SelectTalentCellSelected");
      }
    }
  }
}

function InitSelectTalentTooltips() {
  for (var i = 1; i <= 9; i++) {
    (function (idx) {
      var cell = GetPanel("talent_cell_" + idx);
      if (!cell) {
        return;
      }
      WhenOver(cell, function () {
        $.DispatchEvent(
          "DOTAShowTitleTextTooltip",
          cell,
          $.Localize("#SelectHero_Talent_" + idx + "_Title"),
          $.Localize("#SelectHero_Talent_" + idx + "_Desc")
        );
        cell.style.tooltipPosition = "bottom";
      });
      WhenOut(cell, function () {
        $.DispatchEvent("DOTAHideTitleTextTooltip", cell);
      });
    })(i);
  }
}

function PickSelectTalent(n) {
  // 与选英雄解耦：锁定英雄后仍允许改天赋（服务端 SelectTalent 会同步并刷新被动）
  var v = Number(n);
  if (!isFinite(v) || v < 1 || v > 9 || isClrbTalentHidden(v)) {
    return;
  }
  if (selectTalentIndex === v) {
    return;
  }
  selectTalentIndex = v;
  RefreshSelectTalentVisual();
  SendServer("Lua_SelectHero", {
    data: { tp: "SelectTalent", talent_index: v },
  });
}

function SelectHero(num2) {
  if (HeroSelect == true) {
    return;
  }
  if (check == 0) {
    return;
  }
  var tp = "SelectHero";
  var text = check; //英雄序号
  var face = num2; //默认第一个命石
  SendServer("Lua_SelectHero", { data: { tp, text, face } });
  HeroSelect = true;
  GetPanel("is_ok").text = "已选择";
  UpdateHeroRefreshButtonsVisibility(null);
}

// function SelectHero(num) {
//   var tp = "SelectHero";
//   var text = num;
//   SendServer("Lua_SelectHero", { data: { tp, text } });

// }

// 倒计时（显示为 分:秒）
var time = 0;
var selectHeroDownTimeGen = 0;
function FormatSelectHeroTime(sec) {
  var t = Math.max(0, Math.floor(sec));
  var m = Math.floor(t / 60);
  var s = t % 60;
  return m + ":" + (s < 10 ? "0" : "") + s;
}
function DownTime(times) {
  selectHeroDownTimeGen++;
  var gen = selectHeroDownTimeGen;
  time = Number(times);
  if (!isFinite(time)) {
    time = 0;
  }
  var el = GetPanel("time_text");
  if (!el) {
    return;
  }
  el.text = FormatSelectHeroTime(time);
  if (time <= 0) {
    return;
  }
  // $.Schedule 只执行一次，return 数字不会自动续期；需每秒再次 Timers
  var tick = function () {
    if (gen !== selectHeroDownTimeGen) {
      return;
    }
    time--;
    el.text = FormatSelectHeroTime(time);
    if (time <= 0) {
      return;
    }
    Timers(1, tick);
  };
  Timers(1, tick);
}

/* 服务端 ready/battle_prep 备战阶段：顶栏用英雄正方形图盖住 Steam/Bot 小头像（见 ApplyTopHeroSlot） */
var ClrbHeroSelectPrepModeActive = false;

/** 在当前顶栏格的 PlayerPortraitWrap 内叠加/隐藏 ClrbPrepTopHeroIcon（与 XML 一致：PortraitWrap 为 TopPickSlot 的第一子面板） */
function ClrbTopPrepPortraitOnPanel(panel, hname, enabled) {
  if (!panel || !panel.GetChild) {
    return;
  }
  var wrap = panel.GetChild(0);
  if (!wrap || !wrap.FindChildTraverse || (wrap.IsValid && !wrap.IsValid())) {
    return;
  }
  /* Panorama 无 FindChildWithClassTraverse；用稳定 id + FindChildTraverse（与顶层 top_player_avatar 用法一致） */
  var hid = "clrb_prep_top_hero_icon";
  var hi = wrap.FindChildTraverse(hid);
  if (!hi) {
    hi = $.CreatePanel("Image", wrap, hid);
    hi.AddClass("ClrbPrepTopHeroIcon");
    hi.hittest = false;
  }
  if (!enabled || !hname) {
    hi.visible = false;
    return;
  }
  hi.SetImage(
    "s2r://panorama/images/heroes/icons/" + String(hname) + "_png.vtex"
  );
  hi.visible = true;
}

/** 选人界面「全英雄自选」按钮：选人阶段显示（消耗英雄自选卡，与是否工具模式无关） */
function ApplySelectHeroToolButtonVisibility(data) {
  var btn = GetPanel("tool_btn");
  if (!btn) {
    return;
  }
  var prep =
    data &&
    (data.battle_prep === 1 ||
      data.battle_prep === true ||
      data.battle_prep === "1");
  var locked = data && IsHeroLocked(data.hero_state);
  var toolEnabled =
    data && (data.tool === 1 || data.tool === true) && !locked;
  btn.visible = !prep && toolEnabled;
  if (btn.visible) {
    UpdateSelectHeroToolPickCount();
  }
}

/** 刷新英雄按钮：仅未确认英雄前显示 */
function UpdateHeroRefreshButtonsVisibility(data) {
  var fbx = GetPanel("full_btn");
  var cbx = GetPanel("cost_btn");
  if (!fbx || !cbx) {
    return;
  }
  var prep =
    data &&
    (data.battle_prep === 1 ||
      data.battle_prep === true ||
      data.battle_prep === "1");
  if (HeroSelect || prep) {
    fbx.visible = false;
    cbx.visible = false;
    return;
  }
  if (data && data.free == 0) {
    fbx.visible = false;
    cbx.visible = true;
    if (data.cost !== undefined && data.cost !== null) {
      GetPanel("cost_num").text = data.cost;
    }
    GetPanel("cost_text").text = "刷新";
    GetPanel("cost_right").visible = true;
    cbx.RemoveClass("over_class");
  } else {
    fbx.visible = true;
    cbx.visible = false;
  }
}

var HERO_PICK_INSUFFICIENT_MSG = "英雄自选卡数量不足";
var selectHeroHeroPickCount = 0;
/** 本局自选：请求已发出 / 已成功，防止 UI 卡顿连点 */
var selectHeroPickRequestSent = false;

function UpdateSelectHeroToolPickCount() {
  var numLbl = GetPanel("tool_pick_num");
  if (!numLbl) {
    return;
  }
  var n = Number(selectHeroHeroPickCount);
  if (!isFinite(n) || n < 0) {
    n = 0;
  }
  numLbl.text = String(Math.floor(n));
}

function ShowDevHeroPickHint(msg) {
  var hint = GetPanel("dev_hero_picker_hint");
  if (!hint) {
    return;
  }
  var text = msg != null && msg !== undefined ? String(msg) : "";
  if (text === "") {
    hint.text = "";
    hint.visible = false;
    hint.RemoveClass("visible");
    return;
  }
  // 失败提示：允许再次点击（成功锁定由 HeroSelect / hero_pick_used 控制）
  if (HeroSelect !== true) {
    selectHeroPickRequestSent = false;
  }
  hint.text = text;
  hint.visible = true;
  hint.AddClass("visible");
  if (typeof GameEvents !== "undefined") {
    GameEvents.SendEvent("bottom_notification", {
      text: text,
      duration: 4,
      class: "NotificationMessage",
    });
  }
}

function OnSelectHeroHeroPickHint(data) {
  if (!data) {
    return;
  }
  ShowDevHeroPickHint(data.hint != null ? data.hint : data.hero_pick_hint);
}

function CloseDevHeroPicker() {
  var o = GetPanel("dev_hero_picker_overlay");
  if (o) {
    o.visible = false;
    o.hittest = false;
    o.SetHasClass("DevHeroPickerOverlayHidden", true);
  }
}

function OpenDevHeroPicker() {
  var o = GetPanel("dev_hero_picker_overlay");
  if (!o) {
    return;
  }
  o.SetHasClass("DevHeroPickerOverlayHidden", false);
  o.visible = true;
  o.hittest = true;
  ShowDevHeroPickHint("");
}

/** Lua 经 CustomGameEvent 下发的数组有时是带字符串键的对象，不能直接用 .length 遍历 */
function DevHeroListToArray(heroes) {
  if (!heroes) {
    return [];
  }
  if (Object.prototype.toString.call(heroes) === "[object Array]") {
    return heroes;
  }
  var len = heroes.length;
  if (typeof len === "number" && len > 0) {
    var asArray = [];
    for (var i = 0; i < len; i++) {
      if (heroes[i] !== undefined) {
        asArray.push(heroes[i]);
      }
    }
    if (asArray.length > 0) {
      return asArray;
    }
  }
  var out = [];
  for (var k in heroes) {
    if (Object.prototype.hasOwnProperty.call(heroes, k)) {
      out.push(heroes[k]);
    }
  }
  return out;
}

function DevHeroGridForType(tp) {
  var n = Number(tp);
  if (!isFinite(n) || n < 1 || n > 4) {
    n = 1;
  }
  return GetPanel("dev_hero_grid_" + n);
}

function SelectHeroToolsPickFree() {
  return (
    typeof ClrbIsLocalToolsMode === "function" && ClrbIsLocalToolsMode()
  );
}

function TryDevPickHero(heroIndex) {
  if (HeroSelect === true) {
    return;
  }
  if (selectHeroPickRequestSent) {
    return;
  }
  if (!SelectHeroToolsPickFree() && selectHeroHeroPickCount < 1) {
    ShowDevHeroPickHint(HERO_PICK_INSUFFICIENT_MSG);
    return;
  }
  selectHeroPickRequestSent = true;
  SendServer("Lua_SelectHero", {
    data: { tp: "DevPickHero", hero_index: heroIndex },
  });
}

function BindDevHeroPickerCell(cell, heroIndex, heroName) {
  cell.SetPanelEvent("onactivate", function () {
    TryDevPickHero(heroIndex);
  });
  WhenOver(cell, function () {
    $.DispatchEvent("DOTAShowTextTooltip", cell, Local(heroName));
    cell.style.tooltipPosition = "bottom";
  });
  WhenOut(cell, function () {
    $.DispatchEvent("DOTAHideTextTooltip", cell);
  });
}

function AppendDevHeroPickerCell(grid, h, slotIndex, heroTp) {
  if (!grid || !h || !h.name) {
    return;
  }
  var idx = Number(h.index);
  if (!isFinite(idx)) {
    return;
  }
  var wrap = NewPanel(grid, "dev_hero_wrap_" + idx, "Panel");
  wrap.BLoadLayoutSnippet("dev_hero_picker_hero_snippet");
  wrap.style.width = "65px";
  wrap.style.height = "85px";
  var heroImg = wrap.FindChildTraverse("dev_hero_picker_hero_image");
  if (heroImg) {
    heroImg.heroname = h.name;
    heroImg.hittest = false;
  }
  var noImg = wrap.FindChildTraverse("dev_hero_picker_no_image");
  if (noImg) {
    noImg.visible = false;
  }
  var tp = Number(heroTp);
  if (tp >= 1 && tp <= 3) {
    if (slotIndex > 0 && slotIndex % 5 === 0) {
      wrap.style.marginRight = "0px";
    } else {
      wrap.style.marginRight = "10px";
    }
  } else {
    wrap.style.marginRight = "10px";
  }
  wrap.hittest = true;
  BindDevHeroPickerCell(wrap, idx, h.name);
}

function OnSelectHeroDevHeroes(data) {
  if (!data) {
    return;
  }
  if (data.pick_hint != null && data.pick_hint !== undefined) {
    ShowDevHeroPickHint(String(data.pick_hint));
    if (!data.heroes) {
      return;
    }
  }
  if (data.hero_pick_count !== undefined && data.hero_pick_count !== null) {
    var c = Number(data.hero_pick_count);
    selectHeroHeroPickCount = isFinite(c) ? c : 0;
    UpdateSelectHeroToolPickCount();
  }
  if (!data.heroes) {
    return;
  }
  var colCounts = [0, 0, 0, 0];
  for (var c = 1; c <= 4; c++) {
    var grid = GetPanel("dev_hero_grid_" + c);
    if (grid) {
      grid.RemoveAndDeleteChildren();
    }
  }
  var list = DevHeroListToArray(data && data.heroes ? data.heroes : null);
  list.sort(function (a, b) {
    return (Number(a.index) || 0) - (Number(b.index) || 0);
  });
  for (var j = 0; j < list.length; j++) {
    var h = list[j];
    if (!h || !h.name) {
      continue;
    }
    var tp = Number(h.hero_tp != null ? h.hero_tp : h.tp);
    if (!isFinite(tp) || tp < 1 || tp > 4) {
      tp = 1;
    }
    colCounts[tp - 1] += 1;
    AppendDevHeroPickerCell(DevHeroGridForType(tp), h, colCounts[tp - 1], tp);
  }
}

function Tool() {
  var btn = GetPanel("tool_btn");
  if (!btn || !btn.visible) {
    return;
  }
  if (HeroSelect === true) {
    return;
  }
  if (!SelectHeroToolsPickFree() && selectHeroHeroPickCount < 1) {
    ShowDevHeroPickHint(HERO_PICK_INSUFFICIENT_MSG);
    return;
  }
  OpenDevHeroPicker();
  SendServer("Lua_SelectHero", { data: { tp: "DevRequestHeroList" } });
}

function GetData(data) {
  if (!data) {
    return;
  }
  ApplySelectHeroToolButtonVisibility(data);
  if (data.hero_pick_count !== undefined && data.hero_pick_count !== null) {
    var pickCount = Number(data.hero_pick_count);
    selectHeroHeroPickCount = isFinite(pickCount) ? pickCount : 0;
    UpdateSelectHeroToolPickCount();
  }
  /* UI_SelectHero 常带空 hero_pick_hint，勿在此清空弹层提示 */
  if (
    data.hero_pick_hint != null &&
    data.hero_pick_hint !== undefined &&
    String(data.hero_pick_hint) !== ""
  ) {
    ShowDevHeroPickHint(data.hero_pick_hint);
  }
  SyncHeroSelectLockedFromServer(data);
  if (data.talent_index !== undefined && data.talent_index !== null) {
    var ti = sanitizeClrbTalentIndex(data.talent_index);
    selectTalentIndex = ti;
  }
  if (data.hidden_talent_indices) {
    applyClrbHiddenTalentCells(data.hidden_talent_indices);
  }

  GetRoot().style.opacity = data.page;
  if (GameUI.CustomUIConfig()) {
    GameUI.CustomUIConfig().ClrbSelectHeroMsgHandlesEvents = data.page != 0;
  }
  if (data.page == 0) {
    var closeMsg = GameUI.CustomUIConfig().SelectHeroMsg_ForceClose;
    if (typeof closeMsg === "function") {
      closeMsg();
    }
  }
  time = data.time;
  if (data.exit == 1) {
    Lua2Js_ShutDownMap();
  }
  if (data.load == 1) {
    CloseDevHeroPicker();
    GetPanel("load").style.opacity = 1;
    GetPanel("Content").style.opacity = 0;
  } else {
    GetPanel("load").style.opacity = 0;
    GetPanel("Content").style.opacity = 1;
  }

  var talentWrap = GetPanel("select_talent_wrap");
  if (talentWrap) {
    talentWrap.visible = data.page != 0 && data.attr_state != 0;
  }
  if (data.page == 0) {
    CloseDevHeroPicker();
    RefreshSelectTalentVisual();
    return;
  }
  if (
    data.battle_prep === 1 ||
    data.battle_prep === true ||
    data.battle_prep === "1"
  ) {
    ClrbHeroSelectPrepModeActive = true;
    var grBp = GetRoot();
    if (grBp && grBp.SetHasClass) {
      grBp.SetHasClass("BattlePrepMode", true);
    }
    DownTime(
      Number(
        data.battle_prep_sec !== undefined && data.battle_prep_sec !== null
          ? data.battle_prep_sec
          : 15
      )
    );
  } else if (
    data.battle_prep === 0 ||
    data.battle_prep === false ||
    data.battle_prep === "0"
  ) {
    ClrbHeroSelectPrepModeActive = false;
    var grBp0 = GetRoot();
    if (grBp0 && grBp0.SetHasClass) {
      grBp0.SetHasClass("BattlePrepMode", false);
    }
    DownTime(data.time);
  } else {
    DownTime(data.time);
  }
  if (data.attr_state == 0) {
    // GetPanel("attr_page").style.opacity = 1;
    // GetPanel("hero_page").style.opacity = 0;
    // GetPanel("func_page").style.opacity = 0;
  } else {
    // GetPanel("attr_page").style.opacity = 0;
    // GetPanel("hero_page").style.opacity = 1;
    // GetPanel("func_page").style.opacity = 1;
    // GetPanel("roll_num").text = "重新随机(" + data.refresh + ")";
    //print(data.list);
    lastSelectHeroList = data.list;
    SetHeroModel(data.list);
  }
  check = 0; //重置
  CheckBtnFun(check);
  UpdateRecommendedRMB(check);
  ["hero_pick_card_1", "hero_pick_card_2", "hero_pick_card_3"].forEach(function (cid) {
    var box = GetPanel(cid);
    if (box) {
      box.RemoveClass("light_img");
    }
  });


  UpdateHeroRefreshButtonsVisibility(data);

  RefreshSelectTalentVisual();

  /* 单行 UI_SelectHero：备战字段再压控件（抵消上面免费刷新会把按钮亮起） */
  if (
    data.battle_prep === 1 ||
    data.battle_prep === true ||
    data.battle_prep === "1"
  ) {
    var ybx = GetPanel("yesbtn");
    var tlx = GetPanel("tool_btn");
    if (ybx) ybx.visible = false;
    if (tlx) tlx.visible = false;
    ["hero_pick_card_1", "hero_pick_card_2", "hero_pick_card_3"].forEach(
      function (cid) {
        var bx = GetPanel(cid);
        if (bx) {
          bx.hittest = false;
        }
      }
    );
  }

}
function Lua2Js_ShutDownMap() {
  print("关闭游戏");
  Game.LeaveCurrentGame();
  //Game.Disconnect()
}

var index_name = {
  index_1: "npc_dota_hero_pudge",
  index_2: "npc_dota_hero_tidehunter",

  index_3: "npc_dota_hero_abaddon",
  index_4: "npc_dota_hero_centaur",

  index_5: "npc_dota_hero_life_stealer",
  index_6: "npc_dota_hero_huskar",

  index_7: "npc_dota_hero_slardar",
  index_8: "npc_dota_hero_tusk",

  index_9: "npc_dota_hero_legion_commander",
  index_10: "npc_dota_hero_axe",

  index_11: "npc_dota_hero_juggernaut",
  index_12: "npc_dota_hero_kez",

  index_13: "npc_dota_hero_drow_ranger",
  index_14: "npc_dota_hero_phantom_assassin",

  index_15: "npc_dota_hero_troll_warlord",
  index_16: "npc_dota_hero_medusa",

  index_17: "npc_dota_hero_faceless_void",
  index_18: "npc_dota_hero_sniper",

  index_19: "npc_dota_hero_broodmother",
  index_20: "npc_dota_hero_gyrocopter",

  index_21: "npc_dota_hero_ursa",
  index_22: "npc_dota_hero_luna",

  index_23: "npc_dota_hero_techies",
  index_24: "npc_dota_hero_silencer",

  index_25: "npc_dota_hero_lina",
  index_26: "npc_dota_hero_lion",

  index_27: "npc_dota_hero_necrolyte",
  index_28: "npc_dota_hero_zuus",

  index_29: "npc_dota_hero_enchantress",
  index_30: "npc_dota_hero_shadow_demon",

  index_31: "npc_dota_hero_muerta",
  index_32: "npc_dota_hero_dark_willow",

  index_33: "npc_dota_hero_obsidian_destroyer",
  index_34: "npc_dota_hero_jakiro",

  index_35: "npc_dota_hero_rubick",
  index_36: "npc_dota_hero_sven",

  index_37: "npc_dota_hero_magnataur",
  index_38: "npc_dota_hero_brewmaster",

  index_39: "npc_dota_hero_dragon_knight",
  index_40: "npc_dota_hero_omniknight",

  index_41: "npc_dota_hero_abyssal_underlord",
  index_42: "npc_dota_hero_kunkka",

  index_43: "npc_dota_hero_spirit_breaker",
  index_44: "npc_dota_hero_treant",

  index_45: "npc_dota_hero_ogre_magi",
  index_46: "npc_dota_hero_rattletrap",

  index_47: "npc_dota_hero_lycan",
  index_48: "npc_dota_hero_snapfire",

  index_49: "npc_dota_hero_slark",
  index_50: "npc_dota_hero_bounty_hunter",

  index_51: "npc_dota_hero_marci",
  index_52: "npc_dota_hero_vengefulspirit",

  index_53: "npc_dota_hero_viper",
  index_54: "npc_dota_hero_bloodseeker",

  index_55: "npc_dota_hero_razor",
  index_56: "npc_dota_hero_spectre",

  index_57: "npc_dota_hero_batrider",
  index_58: "npc_dota_hero_oracle",

  index_59: "npc_dota_hero_venomancer",
  index_60: "npc_dota_hero_ancient_apparition",

  index_61: "npc_dota_hero_tinker",
  index_62: "npc_dota_hero_leshrac",

  index_63: "npc_dota_hero_death_prophet",
  index_64: "npc_dota_hero_furion",

  index_65: "npc_dota_hero_windrunner",
  index_66: "npc_dota_hero_chen",

  index_67: "npc_dota_hero_dazzle",
  index_68: "npc_dota_hero_largo",

  index_69: "npc_dota_hero_riki",
  index_70: "npc_dota_hero_queenofpain",
  index_71: "npc_dota_hero_mirana",
  index_72: "npc_dota_hero_morphling",
};
var model_list = {
  slot_1: "",
  slot_2: "",
  slot_3: "",
};

var heroname_list = {
  slot_1: "",
  slot_2: "",
  slot_3: "",
};

// 英雄名
var heronamelist = {
  1: "npc_dota_hero_pudge",
  2: "npc_dota_hero_tidehunter",
  3: "npc_dota_hero_abaddon",
  4: "npc_dota_hero_centaur",
  5: "npc_dota_hero_life_stealer",
  6: "npc_dota_hero_huskar",
  7: "npc_dota_hero_slardar",
  8: "npc_dota_hero_tusk",
  9: "npc_dota_hero_legion_commander",
  10: "npc_dota_hero_axe",
  11: "npc_dota_hero_juggernaut",
  12: "npc_dota_hero_kez",
  13: "npc_dota_hero_drow_ranger",
  14: "npc_dota_hero_phantom_assassin",
  15: "npc_dota_hero_troll_warlord",
  16: "npc_dota_hero_medusa",
  17: "npc_dota_hero_faceless_void",
  18: "npc_dota_hero_sniper",
  19: "npc_dota_hero_broodmother",
  20: "npc_dota_hero_gyrocopter",
  21: "npc_dota_hero_ursa",
  22: "npc_dota_hero_luna",
  23: "npc_dota_hero_techies",
  24: "npc_dota_hero_silencer",
  25: "npc_dota_hero_lina",
  26: "npc_dota_hero_lion",
  27: "npc_dota_hero_necrolyte",
  28: "npc_dota_hero_zuus",
  29: "npc_dota_hero_enchantress",
  30: "npc_dota_hero_shadow_demon",
  31: "npc_dota_hero_muerta",
  32: "npc_dota_hero_dark_willow",
  33: "npc_dota_hero_obsidian_destroyer",
  34: "npc_dota_hero_jakiro",
  35: "npc_dota_hero_rubick",
  36: "npc_dota_hero_sven",
  37: "npc_dota_hero_magnataur",
  38: "npc_dota_hero_brewmaster",
  39: "npc_dota_hero_dragon_knight",
  40: "npc_dota_hero_omniknight",
  41: "npc_dota_hero_abyssal_underlord",
  42: "npc_dota_hero_kunkka",
  43: "npc_dota_hero_spirit_breaker",
  44: "npc_dota_hero_treant",
  45: "npc_dota_hero_ogre_magi",
  46: "npc_dota_hero_rattletrap",
  47: "npc_dota_hero_lycan",
  48: "npc_dota_hero_snapfire",
  49: "npc_dota_hero_slark",
  50: "npc_dota_hero_bounty_hunter",
  51: "npc_dota_hero_marci",
  52: "npc_dota_hero_vengefulspirit",
  53: "npc_dota_hero_viper",
  54: "npc_dota_hero_bloodseeker",
  55: "npc_dota_hero_razor",
  56: "npc_dota_hero_spectre",
  57: "npc_dota_hero_batrider",
  58: "npc_dota_hero_oracle",
  59: "npc_dota_hero_venomancer",
  60: "npc_dota_hero_ancient_apparition",
  61: "npc_dota_hero_tinker",
  62: "npc_dota_hero_leshrac",
  63: "npc_dota_hero_death_prophet",
  64: "npc_dota_hero_furion",
  65: "npc_dota_hero_windrunner",
  66: "npc_dota_hero_chen",
  67: "npc_dota_hero_dazzle",
  68: "npc_dota_hero_largo",
  69: "npc_dota_hero_riki",
  70: "npc_dota_hero_queenofpain",
  71: "npc_dota_hero_mirana",
  72: "npc_dota_hero_morphling",
};

//天赋技能
var talent_list = {
  "npc_dota_hero_pudge": "pudge_innate_graft_flesh",
  "npc_dota_hero_tidehunter": "tidehunter_leviathans_catch",
  "npc_dota_hero_abaddon": "abaddon_withering_mist",
  "npc_dota_hero_centaur": "centaur_horsepower",
  "npc_dota_hero_life_stealer": "life_stealer_ghoul_frenzy",
  "npc_dota_hero_huskar": "huskar_blood_magic",
  "npc_dota_hero_slardar": "slardar_seaborn_sentinel",
  "npc_dota_hero_tusk": "tusk_bitter_chill",
  "npc_dota_hero_legion_commander": "legion_commander_outfight_them",
  "npc_dota_hero_axe": "axe_one_man_army",
  "npc_dota_hero_juggernaut": "juggernaut_bladeform",
  "npc_dota_hero_kez": "kez_switch_weapons",
  "npc_dota_hero_drow_ranger": "drow_ranger_trueshot",
  "npc_dota_hero_phantom_assassin": "phantom_assassin_blur",
  "npc_dota_hero_troll_warlord": "troll_warlord_switch_stance",
  "npc_dota_hero_medusa": "medusa_mana_shield",
  "npc_dota_hero_faceless_void": "faceless_void_distortion_field",
  "npc_dota_hero_sniper": "sniper_keen_scope",
  "npc_dota_hero_broodmother": "broodmother_spiders_milk",
  "npc_dota_hero_gyrocopter": "gyrocopter_afterburner",
  "npc_dota_hero_ursa": "ursa_maul",
  "npc_dota_hero_luna": "luna_lunar_blessing",
  "npc_dota_hero_techies": "techies_mutually_assured_destruction",
  "npc_dota_hero_silencer": "silencer_brain_drain",
  "npc_dota_hero_lina": "lina_slow_burn",
  "npc_dota_hero_lion": "lion_to_hell_and_back",
  "npc_dota_hero_necrolyte": "necrolyte_sadist",
  "npc_dota_hero_zuus": "zuus_static_field",
  "npc_dota_hero_enchantress": "enchantress_rabblerouser",
  "npc_dota_hero_shadow_demon": "shadow_demon_menace",
  "npc_dota_hero_muerta": "muerta_supernatural",
  "npc_dota_hero_dark_willow": "dark_willow_pixie_dust",
  "npc_dota_hero_jakiro": "jakiro_double_trouble",
  "npc_dota_hero_rubick": "rubick_curiosity",
  "npc_dota_hero_magnataur": "magnataur_solid_core",
  "npc_dota_hero_brewmaster": "brewmaster_liquid_courage",
  "npc_dota_hero_dragon_knight": "dragon_knight_dragon_blood",
  "npc_dota_hero_omniknight": "omniknight_degen_aura",
  "npc_dota_hero_abyssal_underlord": "abyssal_underlord_raid_boss",
  "npc_dota_hero_kunkka": "kunkka_admirals_rum",
  "npc_dota_hero_spirit_breaker": "spirit_breaker_herd_mentality",
  "npc_dota_hero_treant": "treant_natures_guise",
  "npc_dota_hero_ogre_magi": "ogre_magi_dumb_luck",
  "npc_dota_hero_rattletrap": "rattletrap_armor_power",
  "npc_dota_hero_lycan": "lycan_apex_predator",
  "npc_dota_hero_snapfire": "snapfire_boomstick",
  "npc_dota_hero_slark": "slark_essence_shift",
  "npc_dota_hero_bounty_hunter": "bounty_hunter_cutpurse",
  "npc_dota_hero_marci": "marci_special_delivery",
  "npc_dota_hero_vengefulspirit": "vengefulspirit_retribution",
  "npc_dota_hero_viper": "viper_predator",
  "npc_dota_hero_bloodseeker": "bloodseeker_sanguivore",
  "npc_dota_hero_razor": "razor_unstable_current",
  "npc_dota_hero_spectre": "spectre_desolate",
  "npc_dota_hero_batrider": "batrider_smoldering_resin",
  "npc_dota_hero_oracle": "oracle_prognosticate",
  "npc_dota_hero_venomancer": "venomancer_poison_sting",
  "npc_dota_hero_ancient_apparition": "ancient_apparition_bone_chill",
  "npc_dota_hero_tinker": "tinker_eureka",
  "npc_dota_hero_leshrac": "leshrac_defilement",
  "npc_dota_hero_death_prophet": "death_prophet_witchcraft",
  "npc_dota_hero_furion": "furion_spirit_of_the_forest",
  "npc_dota_hero_windrunner": "windrunner_tailwind",
  "npc_dota_hero_chen": "chen_zealot",
  "npc_dota_hero_dazzle": "dazzle_innate_weave",
  "npc_dota_hero_largo": "largo_encore",
  "npc_dota_hero_riki": "riki_innate_backstab",
  "npc_dota_hero_queenofpain": "queenofpain_masochist",
  "npc_dota_hero_mirana": "mirana_celestial_quiver",
  "npc_dota_hero_morphling": "morphling_ebb_and_flow",
  "npc_dota_hero_skywrath_mage": "skywrath_mage_shield_of_the_scion",
  "npc_dota_hero_phoenix": "phoenix_dying_light",
  "npc_dota_hero_earthshaker": "earthshaker_slugger",
  "npc_dota_hero_mars": "mars_dauntless",
  "npc_dota_hero_bristleback": "bristleback_prickly",
  "npc_dota_hero_wisp": "wisp_equilibrium",
  "npc_dota_hero_pugna": "pugna_oblivion_savant",
  "npc_dota_hero_elder_titan": "elder_titan_momentum",
  "npc_dota_hero_clinkz": "clinkz_infernal_shred",
  "npc_dota_hero_pangolier": "pangolier_fortune_favors_the_bold",
  "npc_dota_hero_night_stalker": "night_stalker_hunter_in_the_night",
  "npc_dota_hero_terrorblade": "terrorblade_dark_unity",
  "npc_dota_hero_crystal_maiden": "crystal_maiden_glacial_guard",
  "npc_dota_hero_dark_seer": "dark_seer_quick_wit",
  "npc_dota_hero_shadow_shaman": "shadow_shaman_fowl_play",
  "npc_dota_hero_puck": "puck_puckish",
  "npc_dota_hero_nevermore": "nevermore_necromastery",
  "npc_dota_hero_dawnbreaker": "dawnbreaker_break_of_dawn",
  "npc_dota_hero_alchemist": "alchemist_goblins_greed",
  "npc_dota_hero_doom_bringer": "doom_bringer_lvl_pain",
  "npc_dota_hero_shredder": "shredder_exposure_therapy",
  "npc_dota_hero_antimage": "antimage_persectur",
  "npc_dota_hero_void_spirit": "void_spirit_intrinsic_edge",
  "npc_dota_hero_beastmaster": "beastmaster_inner_beast",
  "npc_dota_hero_monkey_king": "monkey_king_mischief",
  "npc_dota_hero_primal_beast": "primal_beast_colossal",
  "npc_dota_hero_earth_spirit": "earth_spirit_stone_caller",
  "npc_dota_hero_winter_wyvern": "winter_wyvern_accelerated_learning",
  "npc_dota_hero_weaver": "weaver_threads_of_fate",
  "npc_dota_hero_ember_spirit": "ember_spirit_immolation",
  "npc_dota_hero_enigma": "enigma_event_horizon",
  "npc_dota_hero_storm_spirit": "storm_spirit_galvanized",
  "npc_dota_hero_undying": "undying_ceaseless_dirge",
  "npc_dota_hero_witch_doctor": "witch_doctor_gris_gris",
  "npc_dota_hero_chaos_knight": "chaos_knight_reins_of_chaos",
  "npc_dota_hero_templar_assassin": "templar_assassin_third_eye",
  "npc_dota_hero_hoodwink": "hoodwink_mistwoods_wayfarer",
  "npc_dota_hero_lich": "lich_death_charge",
  "npc_dota_hero_sven": "sven_wrath_of_god",
  "npc_dota_hero_obsidian_destroyer": "obsidian_destroyer_equilibrium",
  "npc_dota_hero_tiny": "tiny_insurmountable"
};

function SetHeroModel(data) {
  // print(data);
  $.Each(data, function (v, k) {
    var model_name = "index_" + v.index;
    // var model_name = "index_1";
    var hero_panel = GetPanel(k);
    // hero_panel.RemoveAndDeleteChildren();
    // var sonpanel = NewPanel(hero_panel, "hero_model_panel", "Panel");
    // sonpanel.BLoadLayoutSnippet(model_name);
    // var face1_name = k + "_face_1";
    // var face1 = GetPanel(face1_name);
    // var face2_name = k + "_face_2";
    // var face2 = GetPanel(face2_name);
    // var face_1_key = model_name + "_1";
    // var face_2_key = model_name + "_2";
    // face1.text = face_list[face_1_key];
    // face2.text = face_list[face_2_key];
    hero_panel.panelstyle = model_name;
    if (model_list[k] !== model_name) {
      model_list[k] = model_name;
      hero_panel.RemoveAndDeleteChildren();
      var sonpanel = NewPanel(hero_panel, "hero_model_panel", "Panel");
      sonpanel.BLoadLayoutSnippet(model_name);
      var heroname = GetPanel(k + "_hero_text");
      heroname.text = Local(v.name);
      heroname_list[k] = v.name;
      //
    }

    // 技能列表（slot_1..4）在每次数据刷新时都重建，避免刷新/重随导致图标残留或缺失
    SetHeroAbilityList(k, v.ab_list);
  });
  // InitTipTalent()
  for (var i = 1; i <= 3; i++) {
    var xtpanel = GetPanel("top_xt_" + i);
    var tfpanel = GetPanel("tf_" + i);
    xtpanel.SlotName = i
    tfpanel.SlotName = i
    ShowTips(xtpanel, i, 1);
    ShowTips(tfpanel, i, 2);
  }
}

function SetHeroAbilityList(slotKey, ab_list) {
  var listPanel = GetPanel(slotKey + "_ability_list");
  if (!listPanel) return;

  listPanel.RemoveAndDeleteChildren();
  if (!ab_list) return;

  for (var i = 1; i <= 4; i++) {
    var key = "slot_" + i;
    var abName = ab_list[key];
    if (!abName || abName === "") continue;

    var icon = NewPanel(listPanel, "", "Panel");
    icon.AddClass("HeroAbilityIcon");

    var img = NewPanel(icon, "", "DOTAAbilityImage");
    img.AddClass("HeroAbilityImage");
    img.abilityname = abName;

    // 用 IIFE 固定住本次循环的 icon/abName，避免闭包拿到最后一个技能
    (function (p, abilityName) {
      WhenOver(p, function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", p, abilityName);
        p.style.tooltipPosition = "bottom";
      });
      WhenOut(p, function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", p);
      });
    })(icon, abName);
  }
}

function RmbAbilitiesToArray(abs) {
  if (!abs) {
    return [];
  }
  if (typeof abs === "string") {
    return [abs];
  }
  if (abs.length !== undefined) {
    var a = [];
    for (var i = 0; i < abs.length; i++) {
      a.push(abs[i]);
    }
    return a;
  }
  var keys = Object.keys(abs).sort(function (x, y) {
    return parseInt(x, 10) - parseInt(y, 10);
  });
  var out = [];
  for (var j = 0; j < keys.length; j++) {
    out.push(abs[keys[j]]);
  }
  return out;
}

function UpdateRecommendedRMB(slotIndex) {
  var row = GetPanel("rmb_skill_row");
  var battle = GetPanel("rmb_battle_type");
  var hint = GetPanel("rmb_hint");
  if (!row) {
    return;
  }
  row.RemoveAndDeleteChildren();
  if (slotIndex < 1 || slotIndex > 3) {
    if (battle) {
      battle.text = "";
    }
    if (hint) {
      hint.visible = true;
    }
    return;
  }
  if (hint) {
    hint.visible = false;
  }
  var slot =
    lastSelectHeroList && lastSelectHeroList["slot_" + slotIndex]
      ? lastSelectHeroList["slot_" + slotIndex]
      : null;
  if (!slot) {
    if (battle) {
      battle.text = "";
    }
    return;
  }
  if (battle) {
    battle.text = slot.rmb_battle || "";
  }
  var arr = RmbAbilitiesToArray(slot.rmb_abilities);
  for (var i = 0; i < arr.length; i++) {
    var ab = arr[i];
    if (!ab) {
      continue;
    }
    var cell = NewPanel(row, "rmb_cell_" + i, "Panel");
    cell.AddClass("RmbSkillCell");
    var wrap = NewPanel(cell, "", "Panel");
    wrap.AddClass("RmbSkillIconWrap");
    var img = NewPanel(wrap, "", "DOTAAbilityImage");
    img.AddClass("RmbSkillIcon");
    img.abilityname = ab;
    (function (p, name) {
      WhenOver(p, function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", p, name);
        p.style.tooltipPosition = "bottom";
      });
      WhenOut(p, function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", p);
      });
    })(wrap, ab);
    var lbl = NewPanel(cell, "", "Label");
    lbl.AddClass("RmbSkillLabel");
    lbl.text = $.Localize("#DOTA_Tooltip_ability_" + ab);
  }
}

//function TipTalent(panel) {
//   panel.SetPanelEvent("onmouseover", function () {
//     var num = panel.SlotNum
//     var heroname = GetHeroNameBySlot(num);
//     $.DispatchEvent("DOTAHUDShowHeroStatBranchTooltip", panel, GetHeroIdByName(heroname), 111);
//   });
//   panel.SetPanelEvent("onmouseout", function () {
//     $.DispatchEvent("DOTAHUDHideStatBranchTooltip", panel);
//   });
// }

function ShowTips(panel, num, tp) {
  if (tp == 1) {
    WhenOver(panel, function () {
      var num = panel.SlotName;
      var slot_name = "slot_" + num;
      var heroname = heroname_list[slot_name];
      // print(heroname);
      $.DispatchEvent("DOTAShowAbilityTooltip", panel, talent_list[heroname]);
      // $.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "TestTips", "file://{resources}/layout/custom_game/tips/selectherotip/selectherotip.xml", "ID=" + indexnum + "&Type=" + Type)
      panel.style.tooltipPosition = "bottom";
    })
    WhenOut(panel, function () {
      $.DispatchEvent("DOTAHideAbilityTooltip", panel);
    })
  }
  if (tp == 2) {
    WhenOver(panel, function () {
      var num = panel.SlotName;
      var slot_name = "slot_" + num;
      var heroname = heroname_list[slot_name];
      // print(heroname);
      $.DispatchEvent("DOTAHUDShowHeroStatBranchTooltip", panel, GetHeroIdByName(heroname), 111);
      // $.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "TestTips", "file://{resources}/layout/custom_game/tips/selectherotip/selectherotip.xml", "ID=" + indexnum + "&Type=" + Type)
      panel.style.tooltipPosition = "bottom";
    })
    WhenOut(panel, function () {
      // $.DispatchEvent("UIHideCustomLayoutTooltip", "TestTips")
      $.DispatchEvent("DOTAHUDHideStatBranchTooltip", panel);
    })
  }

}





// 选择英雄
function CheckHero(pa) {
  if (HeroSelect == true) {
    return;
  }
  if (pa == "model_1") check = 1;
  else if (pa == "model_2") check = 2;
  else if (pa == "model_3") check = 3;
  else return;

  var cardIds = ["hero_pick_card_1", "hero_pick_card_2", "hero_pick_card_3"];
  var slotIds = ["model_1", "model_2", "model_3"];
  for (var i = 0; i < 3; i++) {
    var box = GetPanel(cardIds[i]);
    if (box) {
      box.SetHasClass("light_img", slotIds[i] === pa);
    }
  }
  CheckBtnFun(check);
  UpdateRecommendedRMB(check);
  SendServer("Lua_SelectHero", { data: { tp: "PreviewSlot", text: check } });
}

function CheckBtnFun(tab) {
  if (tab > 0) {
    GetPanel("yesbtn").AddClass("check");
  } else {
    GetPanel("yesbtn").RemoveClass("check");
  }
}

//玩家自己的队伍
var LocalTeam = -1;
var LocalID = -1
var team_model_slots = [1, 2, 3, 4];
var team_model_list = {
  "team_model_1": "",
  "team_model_2": "",
  "team_model_3": "",
  "team_model_4": "",
}

function SetTeamAvatar(slotNum, steamId) {
  var avatar = GetPanel("team_avatar_" + slotNum);
  if (!avatar) {
    return;
  }
  var sid = ClrbSteamIdOrEmpty(steamId);
  avatar.steamid = sid;
  avatar.style.opacity = sid ? 1 : 0;
  if (sid) {
    ClrbApplyTeamAvatarBorder(avatar, LocalTeam);
  } else {
    avatar.style.borderColor = CLRB_TEAM_AVATAR_DEFAULT_BORDER + ";";
  }
}

function SetTeamCardVisible(slotNum, visible) {
  var card = GetPanel("team_card_" + slotNum);
  if (!card) {
    return;
  }
  card.SetHasClass("HiddenTeamCard", !visible);
}

function IsHeroLocked(hero_state) {
  return (
    hero_state === 1 ||
    hero_state === true ||
    hero_state === "1" ||
    hero_state === "true"
  );
}

// 与引擎一致：2 天辉，3 夜魇，6/7 自定义队（rank_3x4）
var TEAM_RADIANT = 2;
var TEAM_DIRE = 3;
var TEAM_CUSTOM_1 = 6;
var TEAM_CUSTOM_2 = 7;

var CLRB_TEAM_COLOR_FALLBACK = {};
CLRB_TEAM_COLOR_FALLBACK[TEAM_RADIANT] = "#3d8f5c";
CLRB_TEAM_COLOR_FALLBACK[TEAM_DIRE] = "#8f3d3d";
CLRB_TEAM_COLOR_FALLBACK[TEAM_CUSTOM_1] = "#5c9fd4";
CLRB_TEAM_COLOR_FALLBACK[TEAM_CUSTOM_2] = "#d49f5c";
/* rank_1v1 十队：与 custom_ui_manifest ClrbApplyClrbTeamColorsForHud 保持一致 */
CLRB_TEAM_COLOR_FALLBACK[8] = "#5588c8";
CLRB_TEAM_COLOR_FALLBACK[9] = "#c85588";
CLRB_TEAM_COLOR_FALLBACK[10] = "#88c855";
CLRB_TEAM_COLOR_FALLBACK[11] = "#55c8a8";
CLRB_TEAM_COLOR_FALLBACK[12] = "#c8a855";
CLRB_TEAM_COLOR_FALLBACK[13] = "#8855c8";

/* Panorama 不接受 borderColor/boxShadow 空串；清除内联样式时用与 CSS 一致的合法值 */
var CLRB_TEAM_AVATAR_DEFAULT_BORDER = "#111111";

function ClrbDefaultTopPortraitBorderHex(panel) {
  if (panel && panel.BHasClass && panel.BHasClass("DirePickSlot")) {
    return CLRB_TEAM_COLOR_FALLBACK[TEAM_DIRE];
  }
  return CLRB_TEAM_COLOR_FALLBACK[TEAM_RADIANT];
}

function ClrbTopPortraitUnlockedShadowStyle() {
  return "inset 0px 1px 0px 0px #ffffff14, 0px 2px 5px #000000aa;";
}

function ClrbByteToHex2(n) {
  var s = Math.max(0, Math.min(255, n | 0)).toString(16);
  return s.length < 2 ? "0" + s : s;
}

function ClrbNormalizeHex6(c) {
  if (!c || typeof c !== "string") {
    return "";
  }
  var s = c.replace(/;/g, "").trim();
  if (s.charAt(0) !== "#") {
    return "";
  }
  s = s.substr(1);
  if (s.length === 3) {
    return (
      "#" +
      s.charAt(0) +
      s.charAt(0) +
      s.charAt(1) +
      s.charAt(1) +
      s.charAt(2) +
      s.charAt(2)
    ).toLowerCase();
  }
  if (s.length >= 6) {
    return ("#" + s.substr(0, 6)).toLowerCase();
  }
  return "";
}

function ClrbHexToRgb(hex) {
  var h = ClrbNormalizeHex6(hex);
  if (!h || h.length < 7) {
    return null;
  }
  var x = h.substr(1);
  return {
    r: parseInt(x.substr(0, 2), 16),
    g: parseInt(x.substr(2, 2), 16),
    b: parseInt(x.substr(4, 2), 16),
  };
}

function ClrbRgbToHex6(r, g, b) {
  return (
    "#" + ClrbByteToHex2(r) + ClrbByteToHex2(g) + ClrbByteToHex2(b)
  ).toLowerCase();
}

function ClrbPackedRgbToHex6(n) {
  if (n === undefined || n === null || typeof n !== "number" || n < 0) {
    return "";
  }
  var u = n >>> 0;
  var r = u & 0xff;
  var g = (u >> 8) & 0xff;
  var b = (u >> 16) & 0xff;
  return ClrbRgbToHex6(r, g, b);
}

function ClrbColorFromDetailsValue(val) {
  if (val === undefined || val === null) {
    return "";
  }
  if (typeof val === "string") {
    var t = val.replace(/;/g, "").trim();
    if (t.charAt(0) === "#") {
      return t;
    }
    return "";
  }
  if (typeof val === "number") {
    return ClrbPackedRgbToHex6(val);
  }
  return "";
}

function ClrbHexColorFromTeamDetails(details) {
  if (!details) {
    return "";
  }
  var k;
  for (k in details) {
    if (!details.hasOwnProperty(k)) {
      continue;
    }
    var low = k.toLowerCase();
    if (low.indexOf("color") < 0) {
      continue;
    }
    var got = ClrbColorFromDetailsValue(details[k]);
    if (got) {
      return got;
    }
  }
  return "";
}

function ClrbGetTeamUiColorHex(teamId) {
  var tid = Number(teamId);
  if (tid !== tid || tid <= 0) {
    return "";
  }
  var cfg = GameUI.CustomUIConfig();
  if (cfg && cfg.team_colors) {
    var tc = cfg.team_colors[tid];
    if (tc === undefined || tc === null) {
      tc = cfg.team_colors[String(tid)];
    }
    if (tc !== undefined && tc !== null) {
      var fromTc = ClrbNormalizeHex6(String(tc));
      if (fromTc) {
        return fromTc;
      }
    }
  }
  var fromDet = ClrbHexColorFromTeamDetails(Game.GetTeamDetails(tid));
  if (fromDet) {
    return ClrbNormalizeHex6(fromDet);
  }
  if (CLRB_TEAM_COLOR_FALLBACK[tid]) {
    return CLRB_TEAM_COLOR_FALLBACK[tid];
  }
  return "";
}

function ClrbLightenTeamBorderColor(hex) {
  var rgb = ClrbHexToRgb(hex);
  if (!rgb) {
    return hex;
  }
  var t = 0.45;
  var r = Math.min(255, Math.round(rgb.r + (255 - rgb.r) * t));
  var g = Math.min(255, Math.round(rgb.g + (255 - rgb.g) * t));
  var b = Math.min(255, Math.round(rgb.b + (255 - rgb.b) * t));
  return ClrbRgbToHex6(r, g, b);
}

function ClrbHexWithAlpha(hex6, a) {
  var h = ClrbNormalizeHex6(hex6);
  if (!h || h.length < 7) {
    return hex6;
  }
  var ai = Math.round(Math.max(0, Math.min(1, a)) * 255);
  return h + ClrbByteToHex2(ai);
}

function ClrbClearTopPortraitTeamStyle(panel) {
  if (!panel) {
    return;
  }
  var wrap = panel.GetChild(0);
  if (!wrap || !wrap.style) {
    return;
  }
  var d = ClrbDefaultTopPortraitBorderHex(panel);
  wrap.style.borderColor = d + ";";
  wrap.style.boxShadow = ClrbTopPortraitUnlockedShadowStyle();
}

function ClrbApplyTopPortraitTeamStyle(panel, teamId, locked) {
  if (!panel) {
    return;
  }
  var wrap = panel.GetChild(0);
  if (!wrap || !wrap.style) {
    return;
  }
  var hex = ClrbGetTeamUiColorHex(teamId);
  if (!hex) {
    var d0 = ClrbDefaultTopPortraitBorderHex(panel);
    wrap.style.borderColor = d0 + ";";
    wrap.style.boxShadow = ClrbTopPortraitUnlockedShadowStyle();
    return;
  }
  var borderMain = locked ? ClrbLightenTeamBorderColor(hex) : hex;
  wrap.style.borderColor = borderMain + ";";
  if (locked) {
    var glow = ClrbHexWithAlpha(hex, 0.53);
    wrap.style.boxShadow =
      "inset 0px 1px 0px 0px #ffffff22, 0px 0px 10px 1px " +
      glow +
      ", 0px 2px 6px #000000aa;";
  } else {
    wrap.style.boxShadow =
      "inset 0px 1px 0px 0px #ffffff14, 0px 2px 5px #000000aa;";
  }
}

function ClrbApplyTeamAvatarBorder(avatarPanel, teamId) {
  if (!avatarPanel || !avatarPanel.style) {
    return;
  }
  var hex = ClrbGetTeamUiColorHex(teamId);
  if (!hex) {
    avatarPanel.style.borderColor = CLRB_TEAM_AVATAR_DEFAULT_BORDER + ";";
    return;
  }
  avatarPanel.style.borderColor = hex + ";";
}

/* rank_3x4：友方只占用 2、3 槽（左列 team_model_2、右列 team_model_3），1/4 不用，相对中央三格主选区左右对称。
   队友按 id 排序：第 1 个→2，第 2 个→3（每队除自己外至多 2 人）。 */
var TEAM_MODEL_SLOT_ORDER_3X4 = [2, 3];

function TeammateOrderIndexToTeamModelSlot(oi, gameType) {
  if (gameType === 3 && oi >= 0 && oi < TEAM_MODEL_SLOT_ORDER_3X4.length) {
    return TEAM_MODEL_SLOT_ORDER_3X4[oi];
  }
  return oi + 1;
}

function SetTopPickSideClass(panel, side) {
  if (!panel) {
    return;
  }
  panel.SetHasClass("RadiantPickSlot", side === "radiant");
  panel.SetHasClass("DirePickSlot", side === "dire");
}

function SortPlayersByTeamThenId(a, b) {
  var ta = a && a.team !== undefined ? Number(a.team) : 0;
  var tb = b && b.team !== undefined ? Number(b.team) : 0;
  if (ta !== tb) {
    return ta - tb;
  }
  return SortPlayersBySlotId(a, b);
}

function IsSelectHeroBotPlayer(v) {
  if (!v) {
    return false;
  }
  return (
    v.bot == 1 ||
    v.bot === true ||
    v.bot == "1" ||
    v.bot === "true"
  );
}

function ApplyTopHeroSlot(panel, v) {
  if (!panel) {
    return;
  }
  var avatar = panel.FindChildTraverse("top_player_avatar");
  var botImg = panel.FindChildTraverse("top_bot_avatar");
  var readyImg = panel.FindChildTraverse("ready_img");

  if (!v) {
    panel.SetHasClass("TopPortraitLocked", false);
    panel.style.opacity = 0;
    ClrbClearTopPortraitTeamStyle(panel);
    if (avatar) {
      avatar.steamid = "";
      avatar.style.opacity = 0;
    }
    if (botImg) {
      botImg.style.opacity = 0;
    }
    if (readyImg) {
      readyImg.style.opacity = 0;
    }
    ClrbTopPrepPortraitOnPanel(panel, "", false);
    return;
  }

  var done = IsHeroLocked(v.hero_state);
  var hname = v.hero_name;
  if (done && (!hname || hname === "") && v.hero_index > 0) {
    var idxKey = "index_" + v.hero_index;
    hname = index_name[idxKey] || "";
  }
  var locked = done && hname && hname !== "";
  var teamNum =
    v.team !== undefined && v.team !== null ? Number(v.team) : -1;

  var prepPortrait =
    !!(ClrbHeroSelectPrepModeActive && locked && hname && hname !== "");

  if (IsSelectHeroBotPlayer(v)) {
    panel.style.opacity = 1;
    if (avatar) {
      avatar.steamid = "";
      avatar.style.opacity = 0;
    }
    if (botImg) {
      if (prepPortrait) {
        botImg.style.opacity = 0;
        botImg.style.visibility = "collapse";
      } else {
        botImg.style.opacity = 1;
        botImg.style.visibility = "visible";
      }
    }
    ClrbTopPrepPortraitOnPanel(panel, hname, prepPortrait);
    panel.SetHasClass("TopPortraitLocked", locked);
    ClrbApplyTopPortraitTeamStyle(panel, teamNum, locked);
    if (readyImg) {
      readyImg.style.opacity = locked ? 1 : 0;
    }
    return;
  }

  if (botImg) {
    botImg.style.opacity = 0;
  }
  panel.style.opacity = 1;
  var pid = v.id;
  var pinfo = Game.GetPlayerInfo(pid);
  var steamId = ClrbSteamIdOrEmpty(pinfo && pinfo.player_steamid);
  if (avatar) {
    avatar.steamid = steamId;
    if (prepPortrait) {
      avatar.style.opacity = 0;
      avatar.style.visibility = "collapse";
    } else {
      avatar.style.opacity = 1;
      avatar.style.visibility = "visible";
    }
  }
  ClrbTopPrepPortraitOnPanel(panel, hname, prepPortrait);
  panel.SetHasClass("TopPortraitLocked", locked);
  ClrbApplyTopPortraitTeamStyle(panel, teamNum, locked);
  if (readyImg) {
    readyImg.style.opacity = locked ? 1 : 0;
  }
}

function SortPlayersBySlotId(a, b) {
  var ia = a && a.id !== undefined ? Number(a.id) : 0;
  var ib = b && b.id !== undefined ? Number(b.id) : 0;
  return ia - ib;
}

function GetPublicData(data) {
  var players = data && data.players ? data.players : data;
  var gameType =
    data && data.game_type !== undefined && data.game_type !== null
      ? Number(data.game_type)
      : 1;

  ClrbHeroSelectPrepModeActive =
    !!(data &&
    (data.ready === 1 ||
      data.ready === true ||
      data.ready === "1" ||
      data.battle_prep === 1 ||
      data.battle_prep === true ||
      data.battle_prep === "1"));

  var topRow = GetPanel("top_player_row");
  if (topRow) {
    topRow.SetHasClass("Mode12Players", gameType === 3);
    /* 5v5/1v1：每侧仅5人，与 rank_3x4 六格区分，便于 CSS 折叠第6槽、相对中间倒计时对称 */
    topRow.SetHasClass("TopBarSlots5", gameType !== 3);
  }
  var localPlayerId = Game.GetLocalPlayerID();
  LocalID = localPlayerId;
  var localInfo = Game.GetPlayerInfo(localPlayerId);
  if (!localInfo) {
    return;
  }
  LocalTeam = localInfo.player_team_id;

  $.Each(team_model_slots, function (_, slotNum) {
    var team_model_key = "team_model_" + slotNum;
    var team_model_panel = GetPanel(team_model_key);
    if (!team_model_panel) {
      return;
    }
    team_model_panel.RemoveAndDeleteChildren();
    team_model_panel.style.opacity = 0;
    team_model_list[team_model_key] = "";
    SetTeamAvatar(slotNum, "");
    SetTeamCardVisible(slotNum, false);
  });

  var radiantList = [];
  var direList = [];
  var unknownList = [];

  if (gameType === 3) {
    var left12 = [];
    var right12 = [];
    $.Each(players, function (v, k) {
      if (!v) {
        return;
      }
      var t = v.team !== undefined && v.team !== null ? Number(v.team) : -1;
      if (t === TEAM_RADIANT || t === TEAM_DIRE) {
        left12.push(v);
      } else if (t === TEAM_CUSTOM_1 || t === TEAM_CUSTOM_2) {
        right12.push(v);
      }
    });
    left12.sort(SortPlayersByTeamThenId);
    right12.sort(SortPlayersByTeamThenId);
    var si;
    for (si = 0; si < 6; si++) {
      var lp = GetPanel("top_rad_" + si);
      var rp = GetPanel("top_dire_" + si);
      var lv = left12[si];
      var rv = right12[si];
      if (lp) {
        SetTopPickSideClass(
          lp,
          lv && Number(lv.team) === TEAM_DIRE ? "dire" : "radiant"
        );
        ApplyTopHeroSlot(lp, lv);
      }
      if (rp) {
        SetTopPickSideClass(
          rp,
          rv && Number(rv.team) === TEAM_CUSTOM_2 ? "dire" : "radiant"
        );
        ApplyTopHeroSlot(rp, rv);
      }
    }
  } else {
    $.Each(players, function (v, k) {
      if (!v) {
        return;
      }
      var t = v.team !== undefined && v.team !== null ? Number(v.team) : -1;
      if (t === TEAM_RADIANT) {
        radiantList.push(v);
      } else if (t === TEAM_DIRE) {
        direList.push(v);
      } else {
        unknownList.push(v);
      }
    });
    radiantList.sort(SortPlayersBySlotId);
    direList.sort(SortPlayersBySlotId);
    unknownList.sort(SortPlayersBySlotId);
    if (
      radiantList.length === 0 &&
      direList.length === 0 &&
      unknownList.length > 0
    ) {
      for (var ui = 0; ui < unknownList.length; ui++) {
        var pu = unknownList[ui];
        var pid = pu && pu.id !== undefined ? Number(pu.id) : ui;
        if (pid < 5) {
          radiantList.push(pu);
        } else {
          direList.push(pu);
        }
      }
      radiantList.sort(SortPlayersBySlotId);
      direList.sort(SortPlayersBySlotId);
    } else {
      for (var uj = 0; uj < unknownList.length; uj++) {
        if (radiantList.length < 5) {
          radiantList.push(unknownList[uj]);
        } else if (direList.length < 5) {
          direList.push(unknownList[uj]);
        }
      }
      radiantList.sort(SortPlayersBySlotId);
      direList.sort(SortPlayersBySlotId);
    }

    for (var ti = 0; ti < 5; ti++) {
      var pr = GetPanel("top_rad_" + ti);
      var pd = GetPanel("top_dire_" + ti);
      if (pr) {
        SetTopPickSideClass(pr, "radiant");
      }
      if (pd) {
        SetTopPickSideClass(pd, "dire");
      }
      ApplyTopHeroSlot(pr, radiantList[ti]);
      ApplyTopHeroSlot(pd, direList[ti]);
    }
    ApplyTopHeroSlot(GetPanel("top_rad_5"), undefined);
    ApplyTopHeroSlot(GetPanel("top_dire_5"), undefined);
    if (GetPanel("top_rad_5")) {
      SetTopPickSideClass(GetPanel("top_rad_5"), "radiant");
    }
    if (GetPanel("top_dire_5")) {
      SetTopPickSideClass(GetPanel("top_dire_5"), "dire");
    }
  }

  /* 两侧队友英雄卡 team_model_1～4：同队除自己外按 id 排序，与槽位一一对应。
     rank_3x4 仅用 2、3 槽，见 TeammateOrderIndexToTeamModelSlot。
     顶栏 $.Each(players) 仍不遍历机器人展示逻辑；此处单独按槽位写模型。
     真人：Steam 角标 + 模型；机器人：仅模型（与真人相同 snippet），不占 Steam 角标 */
  var teamOthersSorted = [];
  $.Each(players, function (v, k) {
    if (!v || v.id === LocalID) {
      return;
    }
    if (Number(v.team) !== Number(LocalTeam)) {
      return;
    }
    teamOthersSorted.push(v);
  });
  teamOthersSorted.sort(function (a, b) {
    return Number(a.id) - Number(b.id);
  });
  var teammateModelSlotCap =
    gameType === 3 ? TEAM_MODEL_SLOT_ORDER_3X4.length : team_model_slots.length;
  for (
    var oi = 0;
    oi < teamOthersSorted.length && oi < teammateModelSlotCap;
    oi++
  ) {
    var vm = teamOthersSorted[oi];
    if (!IsHeroLocked(vm.hero_state) || !vm.hero_index || vm.hero_index <= 0) {
      continue;
    }
    var slotNumM = TeammateOrderIndexToTeamModelSlot(oi, gameType);
    var team_model_key_m = "team_model_" + slotNumM;
    if (team_model_list[team_model_key_m] === vm.hero_index) {
      continue;
    }
    var team_model_panel_m = GetPanel("team_model_" + slotNumM);
    if (!team_model_panel_m) {
      continue;
    }
    team_model_panel_m.RemoveAndDeleteChildren();
    var sonpanelM = NewPanel(team_model_panel_m, "hero_model_panel", "Panel");
    sonpanelM.BLoadLayoutSnippet("index_" + vm.hero_index);
    team_model_list[team_model_key_m] = vm.hero_index;
    team_model_panel_m.style.opacity = 1;
    if (IsSelectHeroBotPlayer(vm)) {
      SetTeamAvatar(slotNumM, "");
    } else {
      var steamM = ClrbSteamIdOrEmpty(pinfoM && pinfoM.player_steamid);
      SetTeamAvatar(slotNumM, steamM);
    }
    SetTeamCardVisible(slotNumM, true);
  }

  /* 备战：顶栏已通过 ClrbHeroSelectPrepModeActive + ApplyTopHeroSlot 换成英雄正方形图标 */
  var rootGr = GetRoot();
  if (rootGr && rootGr.SetHasClass) {
    rootGr.SetHasClass("BattlePrepMode", !!ClrbHeroSelectPrepModeActive);
  }
  var inBattlePrep =
    data &&
    (data.ready === 1 ||
      data.ready === true ||
      data.ready === "1" ||
      data.battle_prep === 1 ||
      data.battle_prep === true ||
      data.battle_prep === "1");
  if (inBattlePrep) {
    var secPrep = data.battle_prep_sec;
    DownTime(
      Number(
        secPrep !== undefined && secPrep !== null && String(secPrep).length > 0
          ? secPrep
          : 15
      )
    );
    $.Each(["full_btn", "cost_btn", "yesbtn"], function (_, id) {
      var pHide = GetPanel(id);
      if (pHide) {
        pHide.visible = false;
      }
    });
    $.Each(
      ["hero_pick_card_1", "hero_pick_card_2", "hero_pick_card_3"],
      function (_, id) {
        var card = GetPanel(id);
        if (card) {
          card.hittest = false;
        }
      }
    );
    var tbtn = GetPanel("tool_btn");
    if (tbtn) {
      tbtn.visible = false;
    }
    HeroSelect = true;
    var okL = GetPanel("is_ok");
    if (okL) {
      okL.text = "已选择";
    }
  } else if (
    data &&
    (data.ready === 0 ||
      data.ready === false ||
      data.ready === "0" ||
      data.battle_prep === 0 ||
      data.battle_prep === false ||
      data.battle_prep === "0")
  ) {
    $.Each(
      ["hero_pick_card_1", "hero_pick_card_2", "hero_pick_card_3"],
      function (_, id) {
        var cardOn = GetPanel(id);
        if (cardOn) {
          cardOn.hittest = true;
        }
      }
    );
  }
}

function GetExitData(data) {
  if (data.state == 1) {
    // print("关闭游戏");
    Game.LeaveCurrentGame();
  }
}

function SyncHeroSelectLockedFromServer(data) {
  if (!data) {
    return;
  }
  if (
    data.hero_pick_pending === true ||
    data.hero_pick_pending === 1 ||
    data.hero_pick_pending === "1" ||
    data.hero_pick_used === true ||
    data.hero_pick_used === 1 ||
    data.hero_pick_used === "1"
  ) {
    selectHeroPickRequestSent = true;
  } else if (
    data.hero_pick_pending === false ||
    data.hero_pick_pending === 0 ||
    data.hero_pick_pending === "0"
  ) {
    if (HeroSelect !== true) {
      selectHeroPickRequestSent = false;
    }
  }
  if (
    data.hero_state === true ||
    data.hero_state === 1 ||
    data.hero_state === "1" ||
    data.hero_state === "true"
  ) {
    HeroSelect = true;
    selectHeroPickRequestSent = true;
    var okEl = GetPanel("is_ok");
    if (okEl) {
      okEl.text = "已选择";
    }
    CloseDevHeroPicker();
    UpdateHeroRefreshButtonsVisibility(data);
  }
}

function bloadSelectHeroAuxPanels() {
  var payPanel = GetPanel("pay_container");
  if (payPanel) {
    payPanel.RemoveAndDeleteChildren();
    payPanel.BLoadLayout(
      "file://{resources}/layout/custom_game/ingame/Code/Code.xml",
      false,
      false
    );
    payPanel.hittest = false;
  }

  var alterPanel = GetPanel("alter_container");
  if (alterPanel) {
    alterPanel.RemoveAndDeleteChildren();
    alterPanel.BLoadLayout(
      "file://{resources}/layout/custom_game/ingame/SelectHeroMsg/SelectHeroMsg.xml",
      false,
      false
    );
    alterPanel.hittest = false;
  }
}

var selectHeroPageOverlayIds = [
  "achieve_container",
  "book_container",
  "task_container",
  "shop_container",
  "leave_confirm_container",
];

var selectHeroActivePageId = "";

function SelectHeroSetActivePageId(pageId) {
  selectHeroActivePageId = pageId || "";
}

function SelectHeroIsServerPageOpen(page) {
  return page === true || page === 1 || page === "1";
}

function SelectHeroCloseOtherPagesOnServer(activeId) {
  if (activeId !== "shop_container") {
    SendServer("Lua_Shop", { data: { tp: "ClosePage" } });
    SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
  }
  if (activeId !== "achieve_container") {
    SendServer("Lua_Achieve", { data: { tp: "ClosePage" } });
  }
  if (activeId !== "task_container") {
    SendServer("Lua_Rank", { data: { tp: "ClosePage" } });
  }
  if (activeId !== "book_container") {
    SendServer("Lua_Book", { data: { tp: "ClosePage" } });
  }
  if (activeId !== "leave_confirm_container") {
    SendServer("Lua_LeaveConfirm", { data: { tp: "ClosePage" } });
  }
}

function SelectHeroSuppressOverlayIfInactive(containerId, isOpen) {
  if (!isOpen || selectHeroActivePageId === containerId) {
    return;
  }
  var root = SelectHeroGetOverlayLayoutRoot(containerId);
  if (root && root.style) {
    root.style.opacity = "0";
    root.hittest = false;
  }
  var container = GetPanel(containerId);
  if (container) {
    container.hittest = false;
  }
}

function SelectHeroGetOverlayLayoutRoot(containerId) {
  var container = GetPanel(containerId);
  if (!container || !container.GetChildCount || container.GetChildCount() < 1) {
    return null;
  }
  return container.GetChild(0);
}

function SelectHeroHideHudPublic() {
  var publicPanel = $("#Public");
  if (publicPanel) {
    publicPanel.style.opacity = "0";
  }
}

function SelectHeroSetPageOverlayVisible(containerId, visible) {
  for (var i = 0; i < selectHeroPageOverlayIds.length; i++) {
    var id = selectHeroPageOverlayIds[i];
    var root = SelectHeroGetOverlayLayoutRoot(id);
    if (root && root.style) {
      var show = visible && id === containerId;
      root.style.opacity = show ? "1" : "0";
      root.hittest = show;
    }
    var c = GetPanel(id);
    if (c) {
      c.hittest = visible && id === containerId;
    }
  }
}

function SelectHeroHideOverlayPanels() {
  SelectHeroSetPageOverlayVisible("", false);
}

function SelectHeroActivateOverlay(containerId) {
  SelectHeroCloseOtherPagesOnServer(containerId);
  SelectHeroSetActivePageId(containerId);
  SelectHeroHideHudPublic();
  SelectHeroSetPageOverlayVisible(containerId, true);
}

function bloadSelectHeroPages() {
  var layouts = [
    [
      "achieve_container",
      "file://{resources}/layout/custom_game/ingame/Achieve/Achieve.xml",
    ],
    [
      "book_container",
      "file://{resources}/layout/custom_game/ingame/Book/Book.xml",
    ],
    [
      "task_container",
      "file://{resources}/layout/custom_game/ingame/Task/Task.xml",
    ],
    [
      "shop_container",
      "file://{resources}/layout/custom_game/ingame/SelectHeroShop/SelectHeroShop.xml",
    ],
    [
      "leave_confirm_container",
      "file://{resources}/layout/custom_game/ingame/LeaveConfirm/LeaveConfirm.xml",
    ],
  ];
  for (var i = 0; i < layouts.length; i++) {
    var panel = GetPanel(layouts[i][0]);
    if (!panel) {
      continue;
    }
    panel.RemoveAndDeleteChildren();
    panel.BLoadLayout(layouts[i][1], false, false);
  }
}

function OpenLeaveConfirm() {
  SelectHeroActivateOverlay("leave_confirm_container");
  SendServer("Lua_LeaveConfirm", { data: { tp: "OpenPage" } });
}

function OpenPage(num) {
  var tp = "OpenPage";

  var SendTp = "";
  if (num == 1) {
    SendTp = "Lua_Person";
    GameUI.CustomUIConfig().Home_Click_Show_Public("person");
  }
  if (num == 2) {
    SendTp = "Lua_Store";
    GameUI.CustomUIConfig().Home_Click_Show_Public("store");
  }
  if (num == 3) {
    SelectHeroActivateOverlay("shop_container");
    SendServer("Lua_Shop", { data: { tp } });
    var shopOpen = GameUI.CustomUIConfig().SelectHeroShop_OpenPage;
    if (typeof shopOpen === "function") {
      shopOpen();
    }
    return;
  }
  if (num == 4) {
    SelectHeroActivateOverlay("task_container");
    SendServer("Lua_Rank", { data: { tp: tp, task_page: 1 } });
    return;
  }
  if (num == 5) {
    SelectHeroActivateOverlay("task_container");
    SendServer("Lua_Rank", { data: { tp: tp, task_page: 2 } });
    return;
  }
  if (num == 6) {
    SelectHeroActivateOverlay("book_container");
    SendServer("Lua_Book", { data: { tp } });
    return;
  }
  if (num == 9) {
    SelectHeroActivateOverlay("achieve_container");
    SendServer("Lua_Achieve", { data: { tp: "OpenPage" } });
    return;
  }
  if (!SendTp) {
    return;
  }
  SendServer(SendTp, { data: { tp } });
}

var CLRB_SELECTHERO_MENU_ICON_PATHS = {
  menu_icon_exit: "file://{images}/custom_game/tuichu.png",
  menu_icon_setting: "file://{images}/custom_game/shezhi.png",
  menu_icon_shop: "file://{images}/custom_game/shangdian.png",
  menu_icon_achieve: "file://{images}/custom_game/chengjiu.png",
  menu_icon_record: "file://{images}/custom_game/zanji.png",
  menu_icon_book: "file://{images}/custom_game/book.png",
};

function InitSelectHeroMenuIcons() {
  for (var id in CLRB_SELECTHERO_MENU_ICON_PATHS) {
    if (!CLRB_SELECTHERO_MENU_ICON_PATHS.hasOwnProperty(id)) {
      continue;
    }
    var img = GetPanel(id);
    if (img) {
      img.SetImage(CLRB_SELECTHERO_MENU_ICON_PATHS[id]);
    }
  }
}

function SelectHeroSetAchieveRedDot(show) {
  var dot = GetPanel("selecthero_menu_achieve_red_dot");
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

function SelectHeroOnAchieveData(data) {
  if (!data) {
    return;
  }
  var open = SelectHeroIsServerPageOpen(data.page);
  if (selectHeroActivePageId === "achieve_container" && !open) {
    SelectHeroSetActivePageId("");
  }
  SelectHeroSuppressOverlayIfInactive("achieve_container", open);
  if (data.has_claimable !== undefined && data.has_claimable !== null) {
    SelectHeroSetAchieveRedDot(
      data.has_claimable === true || data.has_claimable === 1
    );
  }
}

function SelectHeroOnBookData(data) {
  if (!data) {
    return;
  }
  var open = SelectHeroIsServerPageOpen(data.page);
  if (selectHeroActivePageId === "book_container" && !open) {
    SelectHeroSetActivePageId("");
  }
  SelectHeroSuppressOverlayIfInactive("book_container", open);
}

function SelectHeroOnLeaveConfirmData(data) {
  if (!data) {
    return;
  }
  var open = SelectHeroIsServerPageOpen(data.page);
  if (selectHeroActivePageId === "leave_confirm_container" && !open) {
    SelectHeroSetActivePageId("");
  }
  SelectHeroSuppressOverlayIfInactive("leave_confirm_container", open);
}

function SelectHeroOnRankData(data) {
  if (!data) {
    return;
  }
  var open = SelectHeroIsServerPageOpen(data.page);
  if (selectHeroActivePageId === "task_container" && !open) {
    SelectHeroSetActivePageId("");
  }
  SelectHeroSuppressOverlayIfInactive("task_container", open);
}

function SelectHeroOnShopData(data) {
  if (!data) {
    return;
  }
  var open = SelectHeroIsServerPageOpen(data.page);
  SelectHeroSuppressOverlayIfInactive("shop_container", open);
}

function SelectHeroOnShopClosed() {
  SelectHeroSetActivePageId("");
  var shopContainer = GetPanel("shop_container");
  if (shopContainer) {
    shopContainer.hittest = false;
  }
}

function InitSelectHeroMenuIconsRetry() {
  InitSelectHeroMenuIcons();
  $.Schedule(0.2, InitSelectHeroMenuIcons);
  $.Schedule(1.0, InitSelectHeroMenuIcons);
}

function RequestSelectHeroAchieveSync() {
  SendServer("Lua_Achieve", { data: { tp: "Sync" } });
}


(function () {
  InitData();
  bloadSelectHeroAuxPanels();
  bloadSelectHeroPages();
  $.Schedule(0, function () {
    if (typeof ClrbEnsureNativeSettingsHud === "function") {
      try {
        ClrbEnsureNativeSettingsHud();
      } catch (e) {}
    }
  });
  $.Schedule(0.5, function () {
    if (typeof ClrbEnsureNativeSettingsHud === "function") {
      try {
        ClrbEnsureNativeSettingsHud();
      } catch (e) {}
    }
  });
  GameUI.CustomUIConfig().SelectHeroShop_OnClosed = SelectHeroOnShopClosed;
  SelectHeroSetActivePageId("");
  SelectHeroHideOverlayPanels();
  InitSelectHeroMenuIconsRetry();
  RequestSelectHeroAchieveSync();
  // 默认进来选1
  SelectAttr(1);

  InitSelectTalentTooltips();
  applyClrbHiddenTalentCells();
  RefreshSelectTalentVisual();
  ApplySelectHeroToolButtonVisibility({
    battle_prep: 0,
    tool: 1,
  });
  CloseDevHeroPicker();

  SubEvent("UI_SelectHero", GetData);
  SubEvent("UI_SelectHeroPlayer", GetPublicData);
  SubEvent("UI_SelectHeroDevHeroes", OnSelectHeroDevHeroes);
  SubEvent("UI_SelectHeroHeroPickHint", OnSelectHeroHeroPickHint);
  SubEvent("UI_OverGame", GetExitData);
  SubEvent("UI_Achieve", SelectHeroOnAchieveData);
  SubEvent("UI_Book", SelectHeroOnBookData);
  SubEvent("UI_LeaveConfirm", SelectHeroOnLeaveConfirmData);
  SubEvent("UI_Rank", SelectHeroOnRankData);
  SubEvent("UI_Shop", SelectHeroOnShopData);
  // GetPanel("game_title_text").style.fontFamily = "Microsoft YaHei";
})();

