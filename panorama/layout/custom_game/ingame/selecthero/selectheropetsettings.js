// 选将界面：宠物拾取技能设置。与局内 SkillSlot 弹窗同协议（Lua_KeySet / UI_KeySet），独立 DOM，避免选将层覆盖 HUD 导致弹窗不可见。

var gShPetPresetsCommitted = { 1: {}, 2: {}, 3: {} };
var gShPetPresetsDraft = { 1: {}, 2: {}, 3: {} };
var gShPetUiPreset = 1;
/** UI_KeySet / 存档中的 pet_preset_active：上次保存时的分页，选人再开弹窗时用 */
var gShPetServerSavedPage = 1;
/** 当前配置页的勾选（与 gShPetPresetsDraft[gShPetUiPreset] 同步） */
var gShPetDraft = {};
var gShPetOrder = [];
var gShPetSlotUi = {};
var gShKeybind = { scoreboard: "TAB", eazyshop: "F4" };
var gShPetOpenPending = false;

function SelectHeroPet_SkillItemSortKey(name) {
  var m = /_(\d+)\s*$/.exec(name || "");
  return m ? parseInt(m[1], 10) : 0;
}

function SelectHeroPet_DefaultOrder(pet) {
  return Object.keys(pet || {}).sort(function (a, b) {
    return SelectHeroPet_SkillItemSortKey(a) - SelectHeroPet_SkillItemSortKey(b);
  });
}

function SelectHeroPet_ClampPresetIndex(v) {
  var x = Number(v);
  if (!(x >= 1 && x <= 3)) {
    return 1;
  }
  return Math.floor(x);
}

function SelectHeroPet_FindPresetSlice(ps, slot) {
  if (!ps || typeof ps !== "object") {
    return null;
  }
  return ps[slot] || ps[String(slot)] || null;
}

function SelectHeroPet_Normalize(raw) {
  var out = {};
  for (var i = 0; i < gShPetOrder.length; i++) {
    var name = gShPetOrder[i];
    if (!name) {
      continue;
    }
    out[name] =
      raw && (raw[name] === true || raw[name] === 1 || raw[name] === "1");
  }
  return out;
}

function SelectHeroPet_CopyMap(obj) {
  var out = {};
  for (var k in obj) {
    if (Object.prototype.hasOwnProperty.call(obj, k)) {
      out[k] = !!obj[k];
    }
  }
  return out;
}

function SelectHeroPet_AbsorbServerPetBundle(data) {
  if (!data || !data.pet) {
    return;
  }
  if (data.pet_rb_order && data.pet_rb_order.length) {
    gShPetOrder = data.pet_rb_order;
  } else {
    gShPetOrder = SelectHeroPet_DefaultOrder(data.pet);
  }
  var base = SelectHeroPet_Normalize(data.pet);
  var hasPs =
    !!(data.pet_presets && typeof data.pet_presets === "object");
  var sidx;
  for (sidx = 1; sidx <= 3; sidx++) {
    var slice = hasPs
      ? SelectHeroPet_FindPresetSlice(data.pet_presets, sidx)
      : null;
    gShPetPresetsCommitted[sidx] = SelectHeroPet_Normalize(slice || base);
  }
  if (data.pet_preset_active !== undefined && data.pet_preset_active !== null) {
    gShPetServerSavedPage = SelectHeroPet_ClampPresetIndex(data.pet_preset_active);
  }
}

function SelectHeroPet_SyncAllDraftFromCommitted() {
  var idx;
  for (idx = 1; idx <= 3; idx++) {
    gShPetPresetsDraft[idx] = SelectHeroPet_CopyMap(
      gShPetPresetsCommitted[idx]
    );
  }
}

function SelectHeroPet_FlushDraftIntoCurrentPresetSlot() {
  gShPetPresetsDraft[gShPetUiPreset] = SelectHeroPet_CopyMap(gShPetDraft);
}

function SelectHeroPet_LoadDraftForPresetSlot(slot) {
  var src = gShPetPresetsDraft[slot] || {};
  gShPetDraft = {};
  for (var i = 0; i < gShPetOrder.length; i++) {
    var nm = gShPetOrder[i];
    if (!nm) {
      continue;
    }
    gShPetDraft[nm] = !!src[nm];
  }
}

function SelectHeroPet_RefreshPresetToolbar() {
  for (var s = 1; s <= 3; s++) {
    var p = GetPanel("selecthero_pet_btn_preset_" + s);
    if (p) {
      p.SetHasClass("KeyBindModalPetPresetMiniActive", gShPetUiPreset === s);
    }
  }
}

function SelectHeroPet_SelectPreset(slot) {
  var n = Number(slot) || 1;
  if (n < 1 || n > 3) {
    n = 1;
  }
  if (n === gShPetUiPreset) {
    return;
  }
  SelectHeroPet_FlushDraftIntoCurrentPresetSlot();
  gShPetUiPreset = n;
  SelectHeroPet_LoadDraftForPresetSlot(gShPetUiPreset);
  SelectHeroPet_RefreshPresetToolbar();
  for (var pi = 0; pi < gShPetOrder.length; pi++) {
    SelectHeroPet_RefreshOne(gShPetOrder[pi]);
  }
}

function SelectHeroPet_ItemImagePath(itemName) {
  return (
    "raw://resource/flash3/images/items/ability_scrolls/" +
    itemName +
    ".png"
  );
}

function SelectHeroPet_ClearGrid() {
  var grid = GetPanel("selecthero_pet_grid");
  if (!grid) {
    return;
  }
  grid.RemoveAndDeleteChildren();
  gShPetSlotUi = {};
}

function SelectHeroPet_RefreshOne(itemName) {
  var rec = gShPetSlotUi[itemName];
  if (!rec || !rec.root) {
    return;
  }
  var on = !!gShPetDraft[itemName];
  rec.root.SetHasClass("KeyBindModalPetSlotOn", on);
  rec.root.SetHasClass("KeyBindModalPetSlotOff", !on);
}

function SelectHeroPet_Toggle(itemName) {
  if (!itemName || gShPetDraft[itemName] === undefined) {
    return;
  }
  gShPetDraft[itemName] = !gShPetDraft[itemName];
  SelectHeroPet_RefreshOne(itemName);
}

function SelectHeroPet_ClearAll() {
  for (var i = 0; i < gShPetOrder.length; i++) {
    var name = gShPetOrder[i];
    if (!name) {
      continue;
    }
    gShPetDraft[name] = false;
    SelectHeroPet_RefreshOne(name);
  }
}

function SelectHeroPet_BuildGrid() {
  var grid = GetPanel("selecthero_pet_grid");
  if (!grid) {
    return;
  }
  SelectHeroPet_ClearGrid();
  for (var i = 0; i < gShPetOrder.length; i++) {
    var itemName = gShPetOrder[i];
    if (!itemName) {
      continue;
    }
    if (gShPetDraft[itemName] === undefined) {
      gShPetDraft[itemName] = false;
    }
    var built = ClrbCreatePetSkillSlotCell(
      grid,
      "sh_pet_slot_" + itemName,
      itemName,
      SelectHeroPet_ItemImagePath(itemName)
    );
    var cell = built.root;
    var on = !!gShPetDraft[itemName];
    cell.SetHasClass("KeyBindModalPetSlotOn", on);
    cell.SetHasClass("KeyBindModalPetSlotOff", !on);
    (function (name) {
      cell.SetPanelEvent("onactivate", function () {
        SelectHeroPet_Toggle(name);
      });
    })(itemName);
    gShPetSlotUi[itemName] = { root: cell };
  }
}

function SelectHeroPet_OnPetDataFromServer(data) {
  SelectHeroPet_AbsorbServerPetBundle(data);
}

/** 写入当前编辑页并进包 */
function SelectHeroPet_BuildSavePayload() {
  SelectHeroPet_FlushDraftIntoCurrentPresetSlot();
  var p1 = SelectHeroPet_Normalize(gShPetPresetsDraft[1]);
  var p2 = SelectHeroPet_Normalize(gShPetPresetsDraft[2]);
  var p3 = SelectHeroPet_Normalize(gShPetPresetsDraft[3]);
  var act = SelectHeroPet_Normalize(gShPetPresetsDraft[gShPetUiPreset]);
  return {
    pet_presets: { "1": p1, "2": p2, "3": p3 },
    pet_preset_active: gShPetUiPreset,
    pet: act,
  };
}

function SelectHeroPet_NormKey(s) {
  if (s == null) {
    return "";
  }
  return ("" + s).replace(/^\s+|\s+$/g, "").toUpperCase();
}

function SelectHero_PetSettings_ShowOverlay() {
  var overlay = GetPanel("selecthero_pet_settings_overlay");
  if (!overlay) {
    return;
  }
  var page = SelectHeroPet_ClampPresetIndex(gShPetServerSavedPage);
  gShPetUiPreset = page;
  SelectHeroPet_SyncAllDraftFromCommitted();
  SelectHeroPet_LoadDraftForPresetSlot(page);
  SelectHeroPet_RefreshPresetToolbar();
  SelectHeroPet_BuildGrid();
  overlay.SetHasClass("KeyBindModalOverlayHidden", false);
  overlay.visible = true;
  overlay.hittest = true;
}

function SelectHero_PetSettings_Open() {
  gShPetOpenPending = true;
  SendServer("Lua_KeySet", { data: { tp: "init" } });
  if (gShPetOrder.length) {
    gShPetOpenPending = false;
    SelectHero_PetSettings_ShowOverlay();
  }
}

function SelectHeroPetSettings_Close() {
  var overlay = GetPanel("selecthero_pet_settings_overlay");
  if (!overlay) {
    return;
  }
  gShPetOpenPending = false;
  overlay.visible = false;
  overlay.hittest = false;
  overlay.SetHasClass("KeyBindModalOverlayHidden", true);
}

function SelectHeroPetSettings_Save() {
  var sb = SelectHeroPet_NormKey(
    (gShKeybind && gShKeybind.scoreboard) != null
      ? gShKeybind.scoreboard
      : "TAB"
  );
  var ez = SelectHeroPet_NormKey(
    (gShKeybind && gShKeybind.eazyshop) != null
      ? gShKeybind.eazyshop
      : "F4"
  );
  if (!sb) {
    sb = "TAB";
  }
  if (!ez) {
    ez = "F4";
  }
  var list = [
    { id: "scoreboard", key: sb },
    { id: "eazyshop", key: ez },
  ];
  var pb = SelectHeroPet_BuildSavePayload();
  SendServer("Lua_KeySet", {
    data: {
      tp: "SaveKeyBind",
      list: list,
      pet: pb.pet,
      pet_presets: pb.pet_presets,
      pet_preset_active: pb.pet_preset_active,
    },
  });
  SelectHeroPetSettings_Close();
}

function SelectHeroPet_OnKeySet(data) {
  if (!data) {
    return;
  }
  if (data.keybind) {
    gShKeybind = data.keybind;
  }
  if (data.pet) {
    SelectHeroPet_OnPetDataFromServer(data);
  }
  var overlay = GetPanel("selecthero_pet_settings_overlay");
  var visible = overlay && overlay.visible === true;
  if (gShPetOpenPending && gShPetOrder.length) {
    gShPetOpenPending = false;
    SelectHero_PetSettings_ShowOverlay();
  } else if (visible && data.pet) {
    SelectHeroPet_SyncAllDraftFromCommitted();
    SelectHeroPet_LoadDraftForPresetSlot(gShPetUiPreset);
    SelectHeroPet_RefreshPresetToolbar();
    for (var pj = 0; pj < gShPetOrder.length; pj++) {
      SelectHeroPet_RefreshOne(gShPetOrder[pj]);
    }
  }
}

(function () {
  SubEvent("UI_KeySet", SelectHeroPet_OnKeySet);
})();
