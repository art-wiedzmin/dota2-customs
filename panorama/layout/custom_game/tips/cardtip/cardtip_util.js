--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


var CARD_TIP_LAYOUT =
  "file://{resources}/layout/custom_game/tips/cardtip/cardtip.xml";
var CARD_TIP_ID = "ClrbCardTip";

/** 与 Shop.Config ItemList 的 name / text 一致；bg 对应 card/race1~3.png */
var CARD_TIP_META = {
  gold: {
    name: "金豆",
    text: "可用于随机英雄，抽取宝箱装备，刷新装备词条。",
    bg: "race3",
  },
  hero_pick: {
    name: "英雄自选卡",
    text: "可在选择英雄界面使用，解锁任意英雄自选。",
    bg: "race1",
  },
  prophecy_card: {
    name: "预言卡",
    text: "开局2分钟内可以预言，如果游戏结算时获得了第一名，获得888金豆。",
    bg: "race1",
  },
  title_clxx: {
    name: "丛林新秀",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race1",
  },
  title_wrnd: {
    name: "无人能挡",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  title_whcl: {
    name: "卧虎藏龙",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  title_clxz: {
    name: "丛林行者",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race1",
  },
  title_wszs: {
    name: "无双战神",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  title_hsbh: {
    name: "横扫八荒",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  title_hdlm: {
    name: "横刀立马",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  title_ysqwh: {
    name: "一醉轻王侯",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  title_rzlf: {
    name: "人中龙凤",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  title_clls: {
    name: "丛林猎手",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race1",
  },
  title_cllr: {
    name: "丛林猎人",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race1",
  },
  title_clzw: {
    name: "丛林之王",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race1",
  },
  title_clmy: {
    name: "丛林梦魇",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race1",
  },
  title_clzy: {
    name: "丛林之翼",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race1",
  },
  title_xxqc: {
    name: "血洗全场",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  title_rzzl: {
    name: "人中之龙",
    text: "头顶称号特效，可在背包内佩戴。",
    bg: "race2",
  },
  effect_tx1: {
    name: "燃烧末日",
    text: "周身特效，可在背包内佩戴。",
    bg: "race2",
  },
  effect_lzqz: {
    name: "离子之气",
    text: "周身特效，可在背包内佩戴。",
    bg: "race2",
  },
  effect_txhb: {
    name: "嬉戏蝴蝶",
    text: "周身特效，可在背包内佩戴。",
    bg: "race2",
  },
  attack_lxhs: {
    name: "流星火矢",
    text: "攻击弹道特效，可在背包内佩戴。",
    bg: "race2",
  },
  attack_atv3: {
    name: "碧光流矢",
    text: "攻击弹道特效，可在背包内佩戴。",
    bg: "race2",
  },
  effect_blue: {
    name: "幽蓝冰焰",
    text: "周身特效，可在背包内佩戴。",
    bg: "race2",
  },
  pet_meat: {
    name: "小肉山",
    text: "跟随宠物，可在背包内佩戴。",
    bg: "race1",
  },
  pet_baby_rosh: {
    name: "肉山宝宝",
    text: "默认跟随宠物，可佩戴或卸下。",
    bg: "race1",
  },
  pet_ti10_rosh: {
    name: "跨纬度肉山宝宝",
    text: "跟随宠物，可在背包内佩戴。",
    bg: "race1",
  },
};

/** 战令奖励图标 tipKey → ItemList key */
var CARD_TIP_KEY_ALIAS = {
  title: "title_clxz",
  title_premium: "title_hsbh",
  attack_premium: "attack_lxhs",
  effect_premium: "effect_tx1",
};

function ResolveCardTipKey(key) {
  if (!key) {
    return null;
  }
  if (CARD_TIP_META[key]) {
    return key;
  }
  if (CARD_TIP_KEY_ALIAS[key]) {
    return CARD_TIP_KEY_ALIAS[key];
  }
  return null;
}

function GetCardTipMeta(key) {
  var resolved = ResolveCardTipKey(key);
  if (!resolved) {
    return null;
  }
  return CARD_TIP_META[resolved];
}

function GetCardTipKeyFromItem(itemKey, meta) {
  if (ResolveCardTipKey(itemKey)) {
    return itemKey;
  }
  if (!meta) {
    return null;
  }
  if (meta.type === 0) {
    return "gold";
  }
  if (meta.type === 4) {
    if (ResolveCardTipKey(itemKey)) {
      return itemKey;
    }
    return "pet_meat";
  }
  if (meta.type === 5) {
    if (ResolveCardTipKey(itemKey)) {
      return itemKey;
    }
  }
  return null;
}

function BindCardItemTooltip(panel, tipKey) {
  if (!panel || !tipKey) {
    return;
  }
  if (!GetCardTipMeta(tipKey)) {
    return;
  }
  if (panel.__cardTipKey === tipKey) {
    return;
  }
  panel.__cardTipKey = tipKey;
  panel.style.tooltipPosition = "right";
  WhenOver(panel, function () {
    $.DispatchEvent(
      "UIShowCustomLayoutParametersTooltip",
      panel,
      CARD_TIP_ID,
      CARD_TIP_LAYOUT,
      "key=" + tipKey
    );
  });
  WhenOut(panel, function () {
    $.DispatchEvent("UIHideCustomLayoutTooltip", CARD_TIP_ID);
  });
}

function ClearCardItemTooltip(panel) {
  if (!panel || !panel.__cardTipKey) {
    return;
  }
  if (GetCardTipMeta(panel.__cardTipKey)) {
    $.DispatchEvent("UIHideCustomLayoutTooltip", CARD_TIP_ID);
  }
  panel.__cardTipKey = null;
  panel.SetPanelEvent("onmouseover", function () {});
  panel.SetPanelEvent("onmouseout", function () {});
}

function BindItemTooltipByMeta(panel, meta, itemKey) {
  if (!panel) {
    return;
  }
  var tipKey = GetCardTipKeyFromItem(itemKey, meta);
  if (!tipKey) {
    ClearCardItemTooltip(panel);
    return;
  }
  BindCardItemTooltip(panel, tipKey);
}