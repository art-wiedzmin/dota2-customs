--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function InitData() {
  var tp = "init";
  SendServer("Lua_SkillData", { data: { tp } });
}

function ChangeSlot() {
  var tp = "ChangeSlot";
  SendServer("Lua_SkillData", { data: { tp } });
}

// ---------------------------------------------------------------------------
// 改键：本地输入 + 保存时 list 发往 Lua_KeySet；监听 UI_KeySet 同步服务端数据
// ---------------------------------------------------------------------------

function ClrbNormalizeKeyToken(s) {
  if (s == null) {
    return "";
  }
  return ("" + s).replace(/^\s+|\s+$/g, "").toUpperCase();
}

/** Lua 下发并保存后的按键快照（仅随 UI_KeySet 更新，与输入框未保存编辑无关） */
var gClrbSkillSlotLuaSavedKeybind = {
  scoreboard: "",
  eazyshop: "",
};

var savekey = {
  scoreboard: "",
  eazyshop: "",
};

function SkillSlot_SyncLuaSavedKeybindFromServer(kb) {
  if (!kb) {
    return;
  }
  gClrbSkillSlotLuaSavedKeybind.scoreboard = ClrbNormalizeKeyToken(
    kb.scoreboard
  );
  gClrbSkillSlotLuaSavedKeybind.eazyshop = ClrbNormalizeKeyToken(kb.eazyshop);
}

// ---------------------------------------------------------------------------
// 玩家按键监听（Panorama 无原生 keydown，用 CreateCustomKeyBind + AddCommand）
// 只注册/只响应 gClrbSkillSlotLuaSavedKeybind 中与 Lua 一致的键
// ---------------------------------------------------------------------------

var gClrbSkillSlotKeySinkRegistered = false;
var gClrbSkillSlotBoundKeyByAction = {
  scoreboard: null,
  eazyshop: null,
};

function ClrbSkillSlotRegisterKeySinkOnce() {
  if (gClrbSkillSlotKeySinkRegistered) {
    return;
  }
  gClrbSkillSlotKeySinkRegistered = true;
  var sink = "clrb_skillslot_key_sink";
  Game.AddCommand(
    "+" + sink,
    function () { },
    "",
    1 << 32
  );
  Game.AddCommand(
    "-" + sink,
    function () { },
    "",
    1 << 32
  );
}

function ClrbSkillSlotBindKeyToSink(key) {
  if (!key) {
    return;
  }
  ClrbSkillSlotRegisterKeySinkOnce();
  Game.CreateCustomKeyBind(key, "+clrb_skillslot_key_sink");
}

function SkillSlot_IsKeyBindModalBlockingActions() {
  var overlay = GetPanel("keybind_modal_overlay");
  return overlay && overlay.visible === true;
}

function SkillSlot_OnPlayerKeybind(actionId, keyToken) {
  if (SkillSlot_IsKeyBindModalBlockingActions()) {
    return;
  }
  var pressed = ClrbNormalizeKeyToken(keyToken);
  var saved = ClrbNormalizeKeyToken(
    gClrbSkillSlotLuaSavedKeybind[actionId]
  );
  if (!saved || pressed !== saved) {
    return;
  }
  // $.Msg(
  //   "[SkillSlot] PlayerKeyDown action=" + actionId + " key=" + pressed
  // );
  SendServer("Lua_KeySet", {
    data: {
      tp: "PlayerKeyDown",
      action: actionId,
      key: pressed,
    },
  });
}

function SkillSlot_ApplyKeybindListeners() {
  var ids = ["scoreboard", "eazyshop"];
  for (var i = 0; i < ids.length; i++) {
    var actionId = ids[i];
    var newKey = ClrbNormalizeKeyToken(
      gClrbSkillSlotLuaSavedKeybind[actionId]
    );
    var prevKey = gClrbSkillSlotBoundKeyByAction[actionId];
    if (prevKey && prevKey !== newKey) {
      ClrbSkillSlotBindKeyToSink(prevKey);
    }
    if (!newKey) {
      if (prevKey) {
        ClrbSkillSlotBindKeyToSink(prevKey);
      }
      gClrbSkillSlotBoundKeyByAction[actionId] = null;
      continue;
    }
    if (prevKey === newKey) {
      continue;
    }
    var cmdBase =
      "clrb_sk_" +
      actionId +
      "_" +
      Date.now() +
      "_" +
      Math.floor(Math.random() * 1000000);
    var cmdPlus = "+" + cmdBase;
    var cmdMinus = "-" + cmdBase;
    (function (aid, ktok) {
      Game.CreateCustomKeyBind(ktok, cmdPlus);
      Game.AddCommand(
        cmdPlus,
        function () {
          SkillSlot_OnPlayerKeybind(aid, ktok);
        },
        "",
        1 << 32
      );
      Game.AddCommand(cmdMinus, function () { }, "", 1 << 32);
    })(actionId, newKey);
    gClrbSkillSlotBoundKeyByAction[actionId] = newKey;
  }
}

function KeyBindModal_BuildKeyList() {
  var sb = GetPanel("keybind_input_scoreboard");
  var ez = GetPanel("keybind_input_eazyshop");
  savekey.scoreboard = ClrbNormalizeKeyToken(sb && sb.text);
  savekey.eazyshop = ClrbNormalizeKeyToken(ez && ez.text);
  return [
    { id: "scoreboard", key: ClrbNormalizeKeyToken(sb && sb.text) },
    { id: "eazyshop", key: ClrbNormalizeKeyToken(ez && ez.text) },
  ];
}

function KeyBindModal_ApplyKeybindToInputs(kb) {
  if (!kb) {
    return;
  }
  var sb = GetPanel("keybind_input_scoreboard");
  var ez = GetPanel("keybind_input_eazyshop");
  if (sb && kb.scoreboard != null && kb.scoreboard !== undefined) {
    sb.text = kb.scoreboard;
  }
  if (ez && kb.eazyshop != null && kb.eazyshop !== undefined) {
    ez.text = kb.eazyshop;
  }
}

// ---------------------------------------------------------------------------
// 宠物：三套预设；pet_preset_active 为服务端存档（保存时提交的当前页）；局内/选人打开弹窗时用其作为默认分页
// ---------------------------------------------------------------------------

var gPetPresetsCommitted = { 1: {}, 2: {}, 3: {} };
var gPetPresetsDraft = { 1: {}, 2: {}, 3: {} };
var gPetUiPreset = 1;
/** 最近一次 UI_KeySet 中的 pet_preset_active（存档页，用于默认打开分页） */
var gPetServerActivePreset = 1;
var gPetDraftState = {};
var gPetRbOrder = [];
var gPetSlotUi = {};

function SkillSlot_ClampPresetIndex(v) {
  var x = Number(v);
  if (!(x >= 1 && x <= 3)) {
    return 1;
  }
  return Math.floor(x);
}

function SkillSlot_FindPresetSlice(ps, slot) {
  if (!ps || typeof ps !== "object") {
    return null;
  }
  return ps[slot] || ps[String(slot)] || null;
}

function SkillSlot_NormalizePetMap(raw) {
  var out = {};
  for (var i = 0; i < gPetRbOrder.length; i++) {
    var name = gPetRbOrder[i];
    if (!name) {
      continue;
    }
    out[name] =
      raw && (raw[name] === true || raw[name] === 1 || raw[name] === "1");
  }
  return out;
}

function SkillSlot_CopyPetMap(obj) {
  var out = {};
  for (var k in obj) {
    if (Object.prototype.hasOwnProperty.call(obj, k)) {
      out[k] = !!obj[k];
    }
  }
  return out;
}

/** 服务端 UI_KeySet 合并：pet + 可选 pet_presets + pet_preset_active */
function SkillSlot_AbsorbServerPetBundle(data) {
  if (!data || !data.pet) {
    return;
  }
  if (data.pet_rb_order && data.pet_rb_order.length) {
    gPetRbOrder = data.pet_rb_order;
  } else {
    gPetRbOrder = SkillSlot_DefaultPetOrder(data.pet);
  }
  var base = SkillSlot_NormalizePetMap(data.pet);
  var hasPs =
    !!(data.pet_presets && typeof data.pet_presets === "object");
  var sidx;
  for (sidx = 1; sidx <= 3; sidx++) {
    var slice = hasPs ? SkillSlot_FindPresetSlice(data.pet_presets, sidx) : null;
    gPetPresetsCommitted[sidx] = SkillSlot_NormalizePetMap(slice || base);
  }
  if (data.pet_preset_active !== undefined && data.pet_preset_active !== null) {
    gPetServerActivePreset = SkillSlot_ClampPresetIndex(data.pet_preset_active);
  }
}

function SkillSlot_SyncAllDraftFromCommitted() {
  var idx;
  for (idx = 1; idx <= 3; idx++) {
    gPetPresetsDraft[idx] = SkillSlot_CopyPetMap(gPetPresetsCommitted[idx]);
  }
}

function KeyBindModal_FlushDraftIntoCurrentPresetSlot() {
  var cur = SkillSlot_CopyPetMap(gPetDraftState);
  gPetPresetsDraft[gPetUiPreset] = cur;
}

function KeyBindModal_LoadDraftForPresetSlot(slot) {
  var idx;
  var src = gPetPresetsDraft[slot] || {};
  gPetDraftState = {};
  for (idx = 0; idx < gPetRbOrder.length; idx++) {
    var nm = gPetRbOrder[idx];
    if (!nm) {
      continue;
    }
    gPetDraftState[nm] = !!src[nm];
  }
}

function SkillSlot_RefreshPetPresetToolbar() {
  for (var s = 1; s <= 3; s++) {
    var p = GetPanel("keybind_pet_btn_preset_" + s);
    if (p) {
      p.SetHasClass("KeyBindModalPetPresetMiniActive", gPetUiPreset === s);
    }
  }
}

function KeyBindModal_PetSelectPreset(slot) {
  var n = Number(slot) || 1;
  if (n < 1 || n > 3) {
    n = 1;
  }
  if (n === gPetUiPreset) {
    return;
  }
  KeyBindModal_FlushDraftIntoCurrentPresetSlot();
  gPetUiPreset = n;
  KeyBindModal_LoadDraftForPresetSlot(gPetUiPreset);
  SkillSlot_RefreshPetPresetToolbar();
  for (var pi = 0; pi < gPetRbOrder.length; pi++) {
    KeyBindModal_PetRefreshOne(gPetRbOrder[pi]);
  }
}

function SkillSlot_PetItemImagePath(itemName) {
  // 与 npc_items_custom 中 AbilityTextureName「item_ability_scrolls/item_skill_*」一致
  return (
    "raw://resource/flash3/images/items/ability_scrolls/" +
    itemName +
    ".png"
  );
}

function SkillSlot_SkillItemSortKey(name) {
  var m = /_(\d+)\s*$/.exec(name || "");
  return m ? parseInt(m[1], 10) : 0;
}

function SkillSlot_DefaultPetOrder(pet) {
  return Object.keys(pet || {}).sort(function (a, b) {
    return SkillSlot_SkillItemSortKey(a) - SkillSlot_SkillItemSortKey(b);
  });
}

function SkillSlot_ClearPetGrid() {
  var grid = GetPanel("keybind_pet_grid");
  if (!grid) {
    return;
  }
  grid.RemoveAndDeleteChildren();
  gPetSlotUi = {};
}

function KeyBindModal_PetRefreshOne(itemName) {
  var rec = gPetSlotUi[itemName];
  if (!rec || !rec.root) {
    return;
  }
  var on = !!gPetDraftState[itemName];
  rec.root.SetHasClass("KeyBindModalPetSlotOn", on);
  rec.root.SetHasClass("KeyBindModalPetSlotOff", !on);
}

function KeyBindModal_PetToggle(itemName) {
  if (!itemName || gPetDraftState[itemName] === undefined) {
    return;
  }
  gPetDraftState[itemName] = !gPetDraftState[itemName];
  KeyBindModal_PetRefreshOne(itemName);
}

/** 宠物页：草稿全部改为未点亮，弹窗保持打开（未点「保存」则不下发服务端） */
function KeyBindModal_PetClearAll() {
  for (var i = 0; i < gPetRbOrder.length; i++) {
    var name = gPetRbOrder[i];
    if (!name) {
      continue;
    }
    gPetDraftState[name] = false;
    KeyBindModal_PetRefreshOne(name);
  }
}


function SkillSlot_BuildPetGrid() {
  var grid = GetPanel("keybind_pet_grid");
  if (!grid) {
    return;
  }
  SkillSlot_ClearPetGrid();
  for (var i = 0; i < gPetRbOrder.length; i++) {
    var itemName = gPetRbOrder[i];
    if (!itemName) {
      continue;
    }
    if (gPetDraftState[itemName] === undefined) {
      gPetDraftState[itemName] = false;
    }
    var built = ClrbCreatePetSkillSlotCell(
      grid,
      "pet_slot_" + itemName,
      itemName,
      SkillSlot_PetItemImagePath(itemName)
    );
    var cell = built.root;
    var on = !!gPetDraftState[itemName];
    cell.SetHasClass("KeyBindModalPetSlotOn", on);
    cell.SetHasClass("KeyBindModalPetSlotOff", !on);
    (function (name) {
      cell.SetPanelEvent("onactivate", function () {
        KeyBindModal_PetToggle(name);
      });
    })(itemName);
    gPetSlotUi[itemName] = { root: cell };
  }
}

function SkillSlot_OnPetDataFromServer(data) {
  SkillSlot_AbsorbServerPetBundle(data);
}

/** 写入当前编辑页后进包；pet_preset_active=当前配置页（局内拾取即该套） */
function KeyBindModal_BuildPetSavePayload() {
  KeyBindModal_FlushDraftIntoCurrentPresetSlot();
  var p1 = SkillSlot_NormalizePetMap(gPetPresetsDraft[1]);
  var p2 = SkillSlot_NormalizePetMap(gPetPresetsDraft[2]);
  var p3 = SkillSlot_NormalizePetMap(gPetPresetsDraft[3]);
  var act = SkillSlot_NormalizePetMap(gPetPresetsDraft[gPetUiPreset]);
  return {
    pet_presets: { "1": p1, "2": p2, "3": p3 },
    pet_preset_active: gPetUiPreset,
    pet: act,
  };
}

function OnUI_KeySet(data) {
  if (!data) {
    return;
  }
  if (data.keybind) {
    savekey.scoreboard = data.keybind.scoreboard;
    savekey.eazyshop = data.keybind.eazyshop;
    SkillSlot_SyncLuaSavedKeybindFromServer(data.keybind);
    KeyBindModal_ApplyKeybindToInputs(data.keybind);
    SkillSlot_ApplyKeybindListeners();
  }
  if (data.pet) {
    SkillSlot_OnPetDataFromServer(data);
    if (SkillSlot_IsKeyBindModalBlockingActions()) {
      SkillSlot_SyncAllDraftFromCommitted();
      KeyBindModal_LoadDraftForPresetSlot(gPetUiPreset);
      SkillSlot_RefreshPetPresetToolbar();
      for (var pj = 0; pj < gPetRbOrder.length; pj++) {
        KeyBindModal_PetRefreshOne(gPetRbOrder[pj]);
      }
    }
  }
}

function KeyBindModal_Open() {
  var overlay = GetPanel("keybind_modal_overlay");
  if (!overlay) {
    return;
  }
  KeyBindModal_SetTab(2);
  var sb = GetPanel("keybind_input_scoreboard");
  var ez = GetPanel("keybind_input_eazyshop");
  ClrbSetTextEntryEnabled(sb, true);
  ClrbSetTextEntryEnabled(ez, true);
  if (sb && (!sb.text || sb.text === "")) {
    sb.text = "TAB";
  }
  if (ez && (!ez.text || ez.text === "")) {
    ez.text = "F4";
  }
  var defaultPage = SkillSlot_ClampPresetIndex(gPetServerActivePreset);
  gPetUiPreset = defaultPage;
  SkillSlot_SyncAllDraftFromCommitted();
  KeyBindModal_LoadDraftForPresetSlot(defaultPage);
  SkillSlot_RefreshPetPresetToolbar();
  SkillSlot_BuildPetGrid();
  overlay.SetHasClass("KeyBindModalOverlayHidden", false);
  overlay.visible = true;
  overlay.hittest = true;
}

function KeyBindModal_Close() {
  var overlay = GetPanel("keybind_modal_overlay");
  if (!overlay) {
    return;
  }
  ClrbSetTextEntryEnabled(GetPanel("keybind_input_scoreboard"), false);
  ClrbSetTextEntryEnabled(GetPanel("keybind_input_eazyshop"), false);
  ClrbDropInputFocusSafe();
  overlay.visible = false;
  overlay.hittest = false;
  overlay.SetHasClass("KeyBindModalOverlayHidden", true);
}

function KeyBindModal_SetTab(tab) {
  var n = Number(tab);
  var t1 = GetPanel("keybind_tab_key");
  var t2 = GetPanel("keybind_tab_pet");
  var p1 = GetPanel("keybind_panel_keys");
  var p2 = GetPanel("keybind_panel_pet");
  if (n === 1) {
    if (t1) {
      t1.SetHasClass("KeyBindModalTabSelected", true);
    }
    if (t2) {
      t2.SetHasClass("KeyBindModalTabSelected", false);
    }
    if (p1) {
      p1.SetHasClass("KeyBindModalBodyHidden", false);
    }
    if (p2) {
      p2.SetHasClass("KeyBindModalBodyHidden", true);
    }
  } else {
    if (t1) {
      t1.SetHasClass("KeyBindModalTabSelected", false);
    }
    if (t2) {
      t2.SetHasClass("KeyBindModalTabSelected", true);
    }
    if (p1) {
      p1.SetHasClass("KeyBindModalBodyHidden", true);
    }
    if (p2) {
      p2.SetHasClass("KeyBindModalBodyHidden", false);
    }
  }
}

function KeyBindModal_Save() {
  var list = KeyBindModal_BuildKeyList();
  var pb = KeyBindModal_BuildPetSavePayload();
  SendServer("Lua_KeySet", {
    data: {
      tp: "SaveKeyBind",
      list: list,
      pet: pb.pet,
      pet_presets: pb.pet_presets,
      pet_preset_active: pb.pet_preset_active,
    },
  });
  KeyBindModal_Close();
}

function SetKeyBind() {
  KeyBindModal_Open();
}

(function () {
  InitData();
  /* UI_Skill 由 ingame/Skill/Skill.js 消费；本面板无需订阅（曾空转 GameEvents） */
  SubEvent("UI_KeySet", OnUI_KeySet);
  SendServer("Lua_KeySet", { data: { tp: "init" } });
  ClrbSetTextEntryEnabled(GetPanel("keybind_input_scoreboard"), false);
  ClrbSetTextEntryEnabled(GetPanel("keybind_input_eazyshop"), false);
  KeyBindModal_Close();
})();