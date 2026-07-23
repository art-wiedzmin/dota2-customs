--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


var LOADOUT_SLOTS = [
  { slot: "title", label: "称号", field: "equipped_title" },
  { slot: "attack_effect", label: "攻击特效", field: "equipped_attack_effect" },
  { slot: "effect", label: "特效", field: "equipped_effect" },
  { slot: "pet", label: "宠物", field: "equipped_pet" },
];

var BAG_SLOT_COLS = 10;
var BAG_MIN_ROWS = 5;
var BAG_MIN_SLOTS = BAG_SLOT_COLS * BAG_MIN_ROWS;

var FALLBACK_ITEM_META = {
  hero_pick: {
    name: "英雄自选卡",
    type: 1,
    stack: true,
    slot: null,
    icon: "raw://resource/flash3/images/card/herocard.png",
    text: "可在选择英雄界面使用，解锁任意英雄自选。",
  },
  prophecy_card: {
    name: "预言卡",
    type: 1,
    stack: true,
    slot: null,
    icon: "raw://resource/flash3/images/achive/yyk.png",
    text: "开局2分钟内可以预言，如果游戏结算时获得了第一名，获得888金豆。",
  },
  title_clxx: {
    name: "丛林新秀",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_clxx.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_wrnd: {
    name: "无人能挡",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_wrnd.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_whcl: {
    name: "卧虎藏龙",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_whcl.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_clxz: {
    name: "丛林行者",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_clxz.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_wszs: {
    name: "无双战神",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_wszs.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_hsbh: {
    name: "横扫八荒",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_hsbh.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_hdlm: {
    name: "横刀立马",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_hdlm.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_ysqwh: {
    name: "一醉轻王侯",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_ysqwh.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_rzlf: {
    name: "人中龙凤",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_rzlf.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_clls: {
    name: "丛林猎手",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_clls.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_cllr: {
    name: "丛林猎人",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_cllr.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_clzw: {
    name: "丛林之王",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_clzw.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_clmy: {
    name: "丛林梦魇",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_clmy.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_clzy: {
    name: "丛林之翼",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_clzy.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_xxqc: {
    name: "血洗全场",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_xxqc.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  title_rzzl: {
    name: "人中之龙",
    type: 2,
    stack: false,
    slot: "title",
    icon: "raw://resource/flash3/images/card/ch_rzzl.png",
    titleIcon: true,
    text: "头顶称号特效，可在背包内佩戴。",
  },
  effect_tx1: {
    name: "燃烧末日",
    type: 3,
    stack: false,
    slot: "effect",
    icon: "raw://resource/flash3/images/card/tx1.png",
    text: "周身特效，可在背包内佩戴。",
  },
  effect_lzqz: {
    name: "离子之气",
    type: 3,
    stack: false,
    slot: "effect",
    icon: "raw://resource/flash3/images/card/tx_lzzq.png",
    text: "周身特效，可在背包内佩戴。",
  },
  effect_txhb: {
    name: "嬉戏蝴蝶",
    type: 3,
    stack: false,
    slot: "effect",
    icon: "raw://resource/flash3/images/card/tx_xxhd.png",
    text: "周身特效，可在背包内佩戴。",
  },
  attack_lxhs: {
    name: "流星火矢",
    type: 5,
    stack: false,
    slot: "attack_effect",
    icon: "raw://resource/flash3/images/card/txz_lxhs.png",
    text: "攻击弹道特效，可在背包内佩戴。",
  },
  attack_atv3: {
    name: "碧光流矢",
    type: 5,
    stack: false,
    slot: "attack_effect",
    icon: "raw://resource/flash3/images/card/tx_bgls.png",
    text: "攻击弹道特效，可在背包内佩戴。",
  },
  effect_blue: {
    name: "幽蓝冰焰",
    type: 3,
    stack: false,
    slot: "effect",
    icon: "file://{images}/card/bg3.png",
    text: "周身特效，可在背包内佩戴。",
  },
  pet_meat: {
    name: "小肉山",
    type: 4,
    stack: false,
    slot: "pet",
    icon: "file://{images}/card/card2.png",
    text: "跟随宠物，可在背包内佩戴。",
  },
  pet_baby_rosh: {
    name: "肉山宝宝",
    type: 4,
    stack: false,
    slot: "pet",
    previewUnit: "CardPet",
    modelPath: "models/courier/baby_rosh/babyroshan.vmdl",
    text: "默认跟随宠物，创建账号后自动获得，可佩戴或卸下。",
  },
  pet_ti10_rosh: {
    name: "跨纬度肉山宝宝",
    type: 4,
    stack: false,
    slot: "pet",
    previewUnit: "CardPetTi10",
    modelPath: "models/courier/baby_rosh/babyroshan_ti10_flying.vmdl",
    text: "跟随宠物，可在背包内佩戴。",
  },
};

function InitData() {
  SendServer("Lua_Shop", { data: { tp: "init" } });
  SyncOutBag();
}

function OpenPage() {
  SendServer("Lua_Shop", { data: { tp: "OpenPage" } });
  SyncOutBag();
}

function SyncOutBag() {
  SendServer("Lua_Shop", { data: { tp: "OutBagSync" } });
}

/** Lua 表经 CustomGameEvent 到 JS 常为 object 而非 Array，需与 Msg/EazyShop 同样处理 */
function BagItemsToArray(items) {
  if (!items) {
    return [];
  }
  if (Array.isArray(items)) {
    return items;
  }
  var arr = [];
  $.Each(items, function (v, k) {
    arr.push({ k: k, v: v });
  });
  arr.sort(function (a, b) {
    return Number(a.k) - Number(b.k);
  });
  var out = [];
  for (var i = 0; i < arr.length; i++) {
    if (arr[i].v) {
      out.push(arr[i].v);
    }
  }
  return out;
}

/** 从 UI_OutBag / UI_Shop 解析背包（JSON 字符串 > 扁平字段 > 嵌套 bag） */
function ParseBagFromPayload(data) {
  if (!data) {
    return { items: [], loadout: {} };
  }
  if (data.bag_json && data.bag_json !== "") {
    try {
      var parsed = JSON.parse(data.bag_json);
      if (parsed) {
        return {
          items: BagItemsToArray(parsed.items),
          loadout: parsed.loadout || {},
        };
      }
    } catch (e) {
      $.Msg("[OutBag] bag_json parse failed");
    }
  }
  if (data.out_bag_n != null && data.out_bag_n > 0) {
    var flatItems = [];
    var n = parseInt(data.out_bag_n, 10) || 0;
    for (var i = 1; i <= n; i++) {
      var key = data["obi_" + i + "_key"];
      if (!key) {
        continue;
      }
      flatItems.push({
        item_key: key,
        count: parseInt(data["obi_" + i + "_count"], 10) || 0,
        name: data["obi_" + i + "_name"] || key,
        type: parseInt(data["obi_" + i + "_type"], 10) || 0,
      });
    }
    if (flatItems.length) {
      return {
        items: flatItems,
        loadout: {
          equipped_title: data.loadout_title || null,
          equipped_effect: data.loadout_effect || null,
          equipped_attack_effect: data.loadout_attack_effect || null,
          equipped_pet: data.loadout_pet || null,
        },
      };
    }
  }
  if (data.bag) {
    return {
      items: BagItemsToArray(data.bag.items),
      loadout: data.bag.loadout || {},
    };
  }
  return { items: [], loadout: {} };
}

function MergeShopBagData(data) {
  var base = GameUI.CustomUIConfig.AllShopData || {};
  var merged = {};
  for (var k in base) {
    if (base.hasOwnProperty(k)) {
      merged[k] = base[k];
    }
  }
  if (data) {
    for (var k2 in data) {
      if (data.hasOwnProperty(k2)) {
        merged[k2] = data[k2];
      }
    }
  }
  var bag = ParseBagFromPayload(data);
  if (bag.items.length || (bag.loadout && (bag.loadout.equipped_title || bag.loadout.equipped_effect || bag.loadout.equipped_attack_effect || bag.loadout.equipped_pet))) {
    merged.bag = bag;
  } else if (data && data.bag) {
    merged.bag = ParseBagFromPayload({ bag: data.bag });
  }
  return merged;
}

function OnOutBagEvent(data) {
  if (!data) {
    return;
  }
  var merged = MergeShopBagData(data);
  GameUI.CustomUIConfig.AllShopData = merged;
  if (merged.page !== undefined) {
    SetOutBagVisible(!!merged.page);
  }
  RenderOutBag(merged);
}

function GetItemMeta(data, itemKey) {
  var fallback = FALLBACK_ITEM_META[itemKey] || null;
  var fromList = data && data.itemList && data.itemList[itemKey];
  if (!fromList && !fallback) {
    return null;
  }
  if (!fromList) {
    return fallback;
  }
  if (!fallback) {
    return fromList;
  }
  var meta = {};
  var k;
  for (k in fromList) {
    if (fromList.hasOwnProperty(k)) {
      meta[k] = fromList[k];
    }
  }
  // 展示字段以 FALLBACK 为准（previewUnit 等）
  for (k in fallback) {
    if (fallback.hasOwnProperty(k)) {
      meta[k] = fallback[k];
    }
  }
  return meta;
}

function IsTitleIcon(meta) {
  return meta && (meta.titleIcon || itemKeyHasTitle(meta));
}

function itemKeyHasTitle(meta) {
  return (
    meta.icon &&
    (meta.icon.indexOf("ch_clxx") >= 0 || meta.icon.indexOf("ch_wrnd") >= 0 || meta.icon.indexOf("ch_whcl") >= 0 || meta.icon.indexOf("ch_clxz") >= 0 || meta.icon.indexOf("ch_wszs") >= 0 || meta.icon.indexOf("ch_hsbh") >= 0 || meta.icon.indexOf("ch_hdlm") >= 0 || meta.icon.indexOf("ch_ysqwh") >= 0 || meta.icon.indexOf("ch_rzlf") >= 0 || meta.icon.indexOf("ch_clls") >= 0 || meta.icon.indexOf("ch_cllr") >= 0 || meta.icon.indexOf("ch_clzw") >= 0 || meta.icon.indexOf("ch_clmy") >= 0 || meta.icon.indexOf("ch_clzy") >= 0 || meta.icon.indexOf("ch_xxqc") >= 0 || meta.icon.indexOf("ch_rzzl") >= 0)
  );
}

function HasPetPreview(meta) {
  if (!meta) {
    return false;
  }
  if (meta.itemdef) {
    return true;
  }
  if (meta.previewUnit) {
    return true;
  }
  return false;
}

function GetPetSceneSnippetName(unit) {
  if (unit === "CardPetTi10") {
    return "pet_scene_preview_ti10_snippet";
  }
  return "pet_scene_preview_snippet";
}

function GetPetScenePanelId(unit) {
  if (unit === "CardPetTi10") {
    return "pet_scene_preview_ti10";
  }
  return "pet_scene_preview";
}

function SetupPetPreview(slotPanel, iconPanel, modelWrap, meta, options) {
  options = options || {};
  if (!HasPetPreview(meta)) {
    if (slotPanel) {
      slotPanel.RemoveClass("has_model");
      slotPanel.RemoveClass("loadout_slot_pet_model");
    }
    if (modelWrap) {
      modelWrap.visible = false;
      modelWrap.RemoveAndDeleteChildren();
    }
    if (iconPanel) {
      iconPanel.visible = true;
    }
    return;
  }

  if (slotPanel) {
    slotPanel.AddClass("has_model");
    if (options.petModelOnly) {
      slotPanel.AddClass("loadout_slot_pet_model");
    }
  }
  if (iconPanel) {
    iconPanel.visible = false;
  }
  if (!modelWrap) {
    return;
  }

  modelWrap.RemoveAndDeleteChildren();
  if (meta.itemdef) {
    modelWrap.BLoadLayoutSnippet("pet_econ_preview_snippet");
    var preview = modelWrap.FindChildTraverse("pet_econ_preview");
    if (preview) {
      preview.itemdef = String(meta.itemdef);
    }
  } else {
    var unit = meta.previewUnit || "CardPet";
    modelWrap.BLoadLayoutSnippet(GetPetSceneSnippetName(unit));
    var scene = modelWrap.FindChildTraverse(GetPetScenePanelId(unit));
    if (scene) {
      scene.unit = unit;
    }
  }
  modelWrap.visible = true;
}

function SetItemIcon(iconPanel, meta, itemKey) {
  if (!iconPanel || !meta || !meta.icon) {
    return;
  }
  iconPanel.SetImage(meta.icon);
  iconPanel.RemoveClass("title_icon");
  iconPanel.RemoveClass("loadout_square_icon");
  if (IsTitleIcon(meta)) {
    if (iconPanel.SetScaling) {
      iconPanel.SetScaling("stretch-to-fit-preserve-aspect");
    }
    iconPanel.AddClass("title_icon");
  } else {
    if (iconPanel.SetScaling) {
      iconPanel.SetScaling("stretch");
    }
  }
}

function SetLoadoutItemIcon(iconPanel, meta, itemKey, slotType) {
  if (!iconPanel || !meta) {
    return;
  }
  SetItemIcon(iconPanel, meta, itemKey);
  iconPanel.RemoveClass("loadout_square_icon");
  iconPanel.RemoveClass("loadout_banner_icon");
  if (slotType === "effect" || slotType === "pet") {
    if (iconPanel.SetScaling) {
      iconPanel.SetScaling("stretch-to-fit-preserve-aspect");
    }
    iconPanel.AddClass("loadout_square_icon");
  } else if (slotType === "attack_effect") {
    if (iconPanel.SetScaling) {
      iconPanel.SetScaling("stretch-to-fit-preserve-aspect");
    }
    iconPanel.AddClass("loadout_banner_icon");
  }
}

function BindItemTooltip(panel, meta, itemKey) {
  BindItemTooltipByMeta(panel, meta, itemKey);
}

function EquipItem(slot, itemKey) {
  ApplyLocalLoadout(slot, itemKey);
  SendServer("Lua_Shop", {
    data: { tp: "OutBagEquip", slot: slot, item_key: itemKey },
  });
}

function UnequipItem(slot) {
  ApplyLocalLoadout(slot, null);
  SendServer("Lua_Shop", { data: { tp: "OutBagUnequip", slot: slot } });
}

function ApplyLocalLoadout(slot, itemKey) {
  var data = GameUI.CustomUIConfig.AllShopData;
  if (!data) {
    return;
  }
  if (!data.bag) {
    data.bag = { items: [], loadout: {} };
  }
  if (!data.bag.loadout) {
    data.bag.loadout = {
      equipped_title: null,
      equipped_effect: null,
      equipped_attack_effect: null,
      equipped_pet: null,
    };
  }
  var field = "equipped_" + slot;
  if (!field || field === "equipped_undefined") {
    return;
  }
  data.bag.loadout[field] = itemKey || null;
  GameUI.CustomUIConfig.AllShopData = data;
  RenderOutBag(data);
}

function GetBagSlotActionLabel(meta, item, loadout) {
  if (!meta || !meta.slot || !item) {
    return "佩戴";
  }
  var equippedKey = loadout["equipped_" + meta.slot] || "";
  if (equippedKey === item.item_key) {
    return "卸下";
  }
  if (equippedKey) {
    return "替换";
  }
  return "佩戴";
}

function BindLoadoutUnequip(bodyPanel, slot) {
  if (!bodyPanel || !slot) {
    return;
  }
  bodyPanel.SetPanelEvent("onactivate", function () {
    UnequipItem(slot);
  });
}

function RenderLoadout(data) {
  var list = GetPanel("loadout_list");
  if (!list) {
    return;
  }
  list.RemoveAndDeleteChildren();
  var bag = data && data.bag;
  var loadout =
    bag && bag.loadout
      ? bag.loadout
      : {
          equipped_title: null,
          equipped_effect: null,
          equipped_attack_effect: null,
          equipped_pet: null,
        };

  for (var i = 0; i < LOADOUT_SLOTS.length; i++) {
    var slotDef = LOADOUT_SLOTS[i];
    var equippedKey = loadout[slotDef.field] || null;
    var meta = equippedKey ? GetItemMeta(data, equippedKey) : null;
    var row = NewPanel(list, "loadout_" + slotDef.slot, "Panel");
    row.hittest = true;
    row.BLoadLayoutSnippet("loadout_slot_snippet");
    if (slotDef.slot === "title") {
      row.AddClass("loadout_slot_title");
    }
    if (slotDef.slot === "pet") {
      row.AddClass("loadout_slot_pet");
    }
    if (slotDef.slot === "effect") {
      row.AddClass("loadout_slot_effect");
    }
    if (slotDef.slot === "attack_effect") {
      row.AddClass("loadout_slot_attack_effect");
    }
    var label = row.FindChildTraverse("loadout_slot_label");
    var icon = row.FindChildTraverse("loadout_slot_icon");
    var modelWrap = row.FindChildTraverse("loadout_slot_model_wrap");
    var nameLabel = row.FindChildTraverse("loadout_slot_name");
    var bodyPanel = row.FindChildTraverse("loadout_slot_body");

    if (label) {
      label.text = slotDef.label;
    }

    if (equippedKey) {
      row.RemoveClass("empty");
      if (meta) {
        SetupPetPreview(row, icon, modelWrap, meta, {
          petModelOnly: slotDef.slot === "pet" && HasPetPreview(meta),
        });
        if (!HasPetPreview(meta)) {
          SetLoadoutItemIcon(icon, meta, equippedKey, slotDef.slot);
        }
        var titleIconOnly = slotDef.slot === "title" && IsTitleIcon(meta);
        var bannerOnly =
          titleIconOnly || slotDef.slot === "attack_effect";
        var petModelOnly = slotDef.slot === "pet" && HasPetPreview(meta);
        if (nameLabel) {
          if (bannerOnly) {
            nameLabel.text = "";
            nameLabel.visible = false;
          } else if (petModelOnly) {
            nameLabel.text = "";
            nameLabel.visible = false;
          } else {
            nameLabel.visible = true;
            nameLabel.text = meta.name || equippedKey;
          }
        }
        if (titleIconOnly) {
          row.AddClass("loadout_slot_title_only");
        }
        if (bannerOnly) {
          row.AddClass("loadout_slot_banner_only");
        }
        BindItemTooltip(row, meta, equippedKey);
      } else {
        if (icon) {
          icon.SetImage("");
        }
        if (nameLabel) {
          nameLabel.visible = true;
          nameLabel.text = equippedKey;
        }
      }
      BindLoadoutUnequip(bodyPanel, slotDef.slot);
    } else {
      row.AddClass("empty");
      if (bodyPanel) {
        bodyPanel.SetPanelEvent("onactivate", function () {});
      }
      if (icon) {
        icon.SetImage("");
      }
      if (nameLabel) {
        nameLabel.text = "";
        nameLabel.visible = false;
      }
    }
  }
}

function IsStackableItem(meta, item) {
  if (meta && (meta.stack || meta.type === 1)) {
    return true;
  }
  if (item && item.stack) {
    return true;
  }
  return false;
}

function GetBagSlotCount(itemCount) {
  var minSlots = BAG_MIN_SLOTS;
  if (itemCount <= 0) {
    return minSlots;
  }
  var rows = Math.ceil(itemCount / BAG_SLOT_COLS);
  if (rows < BAG_MIN_ROWS) {
    rows = BAG_MIN_ROWS;
  }
  return rows * BAG_SLOT_COLS;
}

function BindBagSlotAction(slotPanel, meta, item, loadout) {
  if (!slotPanel || !meta || !meta.slot || !item) {
    return;
  }
  var hoverBtn = slotPanel.FindChildTraverse("bag_slot_hover");
  var actionLabel = slotPanel.FindChildTraverse("bag_slot_action");
  if (!hoverBtn) {
    return;
  }
  var equippedKey = loadout["equipped_" + meta.slot] || "";
  var isEquipped = equippedKey === item.item_key;
  if (actionLabel) {
    actionLabel.text = GetBagSlotActionLabel(meta, item, loadout);
  }
  (function (slot, key, equipped) {
    hoverBtn.SetPanelEvent("onactivate", function () {
      if (equipped) {
        UnequipItem(slot);
      } else {
        EquipItem(slot, key);
      }
    });
  })(meta.slot, item.item_key, isEquipped);
}

function RenderBagSlot(grid, index, item, data, loadout) {
  var slotPanel = NewPanel(grid, "bag_slot_" + index, "Panel");
  slotPanel.hittest = true;
  slotPanel.BLoadLayoutSnippet("bag_slot_snippet");

  if (!item || !item.item_key) {
    slotPanel.AddClass("empty");
    return;
  }

  slotPanel.RemoveClass("empty");
  var meta = GetItemMeta(data, item.item_key);
  if (!meta) {
    meta = {
      name: item.name || item.item_key,
      type: item.type,
      icon: "",
      text: "",
      slot: null,
      stack: !!item.stack,
    };
  }

  var icon = slotPanel.FindChildTraverse("bag_slot_icon");
  var modelWrap = slotPanel.FindChildTraverse("bag_slot_model_wrap");
  var countLabel = slotPanel.FindChildTraverse("bag_slot_count");
  SetupPetPreview(slotPanel, icon, modelWrap, meta);
  if (!HasPetPreview(meta)) {
    SetItemIcon(icon, meta, item.item_key);
  }

  if (countLabel) {
    var cnt = parseInt(item.count, 10) || 0;
    if (IsStackableItem(meta, item) && cnt > 0) {
      countLabel.text = String(cnt);
      countLabel.AddClass("visible");
    } else {
      countLabel.RemoveClass("visible");
    }
  }

  if (meta.slot) {
    BindBagSlotAction(slotPanel, meta, item, loadout);
    BindItemTooltip(slotPanel, meta, item.item_key);
  } else {
    slotPanel.AddClass("no_action");
    BindItemTooltip(slotPanel, meta, item.item_key);
  }
}

function RenderItems(data) {
  var grid = GetPanel("items_grid");
  var emptyLabel = GetPanel("items_empty");
  if (!grid) {
    return;
  }
  grid.RemoveAndDeleteChildren();

  var bag = data && data.bag;
  var items = BagItemsToArray(bag && bag.items ? bag.items : null);
  var loadout =
    bag && bag.loadout
      ? bag.loadout
      : {
          equipped_title: null,
          equipped_effect: null,
          equipped_attack_effect: null,
          equipped_pet: null,
        };

  var slotCount = GetBagSlotCount(items.length);

  if (!items.length) {
    if (emptyLabel) {
      emptyLabel.AddClass("visible");
    }
  } else if (emptyLabel) {
    emptyLabel.RemoveClass("visible");
  }

  for (var i = 0; i < slotCount; i++) {
    RenderBagSlot(grid, i, items[i] || null, data, loadout);
  }
}

function SetOutBagHitTest(enabled) {
  var root = GetRoot();
  if (root) {
    root.hittest = !!enabled;
  }
  var block = GetPanel("outbag_hit_block");
  if (block) {
    block.hittest = !!enabled;
  }
}

function SetOutBagVisible(visible) {
  GetRoot().style.opacity = visible ? "1" : "0";
  SetOutBagHitTest(visible);
}

function RenderOutBag(data) {
  RenderLoadout(data);
  RenderItems(data);
}

function GetData(data) {
  if (!data) {
    return;
  }
  var merged = MergeShopBagData(data);
  GameUI.CustomUIConfig.AllShopData = merged;
  if (merged.page !== undefined) {
    SetOutBagVisible(!!merged.page);
  }
  RenderOutBag(merged);
}

(function () {
  SetOutBagVisible(true);
  SubEvent("UI_Shop", GetData);
  SubEvent("UI_OutBag", OnOutBagEvent);
  InitData();
})();