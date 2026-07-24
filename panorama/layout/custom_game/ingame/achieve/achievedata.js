--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


/**
 * 成就系统 — 前端数据层
 *
 * 服务端 /achieve/get 返回:
 *   achieve.definitions.{ hero, daily, recharge }
 *   achieve.{ herodata, paydata, daydata }
 *   recharge_total
 *
 * status 映射: 1=claimable, 2=locked, 3=claimed
 */

var CLRB_ACHIEVE_TABS = {
  hero: { key: "hero", label: "英雄成就" },
  daily: { key: "daily", label: "日常成就" },
  recharge: { key: "recharge", label: "累计充值" },
};

/** 与 Shop.lua / CardReward.lua / Msg 兑换奖励弹窗一致（SetImage 须用 raw://） */
var CLRB_ACHIEVE_REWARD_ICON_GOLD =
  "raw://resource/flash3/images/shop/b_cost.png";
var CLRB_ACHIEVE_REWARD_ICON_HERO =
  "raw://resource/flash3/images/card/herocard.png";
var CLRB_ACHIEVE_REWARD_ICON_PET =
  "raw://resource/flash3/images/achive/pet.png";
var CLRB_ACHIEVE_REWARD_ICON_PROPHECY =
  "raw://resource/flash3/images/achive/yyk.png";

var CLRB_ACHIEVE_DEFAULT_REWARD_ICON = CLRB_ACHIEVE_REWARD_ICON_GOLD;

/** 与服务端 HERO_ACHIEVE_GOLD 一致 */
var CLRB_ACHIEVE_HERO_REWARD_GOLD = 50;

/** 与服务端 PAY_TIER_AMOUNTS 一致 */
var CLRB_ACHIEVE_PAY_TIERS = [30, 98, 198, 328, 648, 1280, 3280];

/** 与服务端 PAY_TIER_REWARDS 一致（UI 展示用） */
var CLRB_ACHIEVE_PAY_REWARDS = {
  30: { gold: 100, hero_pick: 1 },
  98: { gold: 300, hero_pick: 2 },
  198: { gold: 600, hero_pick: 3 },
  328: { gold: 1000, hero_pick: 5 },
  648: { gold: 2000, hero_pick: 5, pet: "pet_ti10_rosh" },
  1280: {
    gold: 4000,
    hero_pick: 10,
    items: [{ itemKey: "prophecy_card", amount: 2 }],
  },
  3280: {
    gold: 10000,
    hero_pick: 15,
    items: [{ itemKey: "title_whcl", amount: 1 }],
  },
};

var CLRB_ACHIEVE_TITLE_ICONS = {
  title_clxx: "raw://resource/flash3/images/card/ch_clxx.png",
  title_wrnd: "raw://resource/flash3/images/card/ch_wrnd.png",
  title_whcl: "raw://resource/flash3/images/card/ch_whcl.png",
  title_clxz: "raw://resource/flash3/images/card/ch_clxz.png",
  title_wszs: "raw://resource/flash3/images/card/ch_wszs.png",
  title_hsbh: "raw://resource/flash3/images/card/ch_hsbh.png",
  title_hdlm: "raw://resource/flash3/images/card/ch_hdlm.png",
  title_ysqwh: "raw://resource/flash3/images/card/ch_ysqwh.png",
  title_rzlf: "raw://resource/flash3/images/card/ch_rzlf.png",
  title_clls: "raw://resource/flash3/images/card/ch_clls.png",
  title_cllr: "raw://resource/flash3/images/card/ch_cllr.png",
  title_clzw: "raw://resource/flash3/images/card/ch_clzw.png",
  title_clmy: "raw://resource/flash3/images/card/ch_clmy.png",
  title_clzy: "raw://resource/flash3/images/card/ch_clzy.png",
  title_xxqc: "raw://resource/flash3/images/card/ch_xxqc.png",
  title_rzzl: "raw://resource/flash3/images/card/ch_rzzl.png",
};

function ClrbAchieveHeroLocalizedName(heroUnitName) {
  if (!heroUnitName) {
    return "";
  }
  var loc = $.Localize("#" + heroUnitName);
  if (loc && loc.charAt(0) !== "#") {
    return loc;
  }
  return heroUnitName;
}

function ClrbAchieveBuildHeroTitle(index) {
  var heroUnit = CLRB_ACHIEVE_INDEX_TO_HERO[String(index)];
  var name = ClrbAchieveHeroLocalizedName(heroUnit);
  return name ? "使用「" + name + "」完成一局游戏" : "使用英雄 #" + index + " 完成一局游戏";
}

function ClrbAchieveServerStatusToUi(status) {
  var n = Number(status);
  if (n === 1) {
    return "claimable";
  }
  if (n === 3) {
    return "claimed";
  }
  return "locked";
}

/** 英雄成就：完成 1/1，未完成 0/1 */
function ClrbAchieveHeroProgress(status) {
  var n = Number(status);
  if (n === 1 || n === 3) {
    return { current: 1, target: 1 };
  }
  return { current: 0, target: 1 };
}

/** 累计充值：进度不超过当前档位上限（如 8182 元时 3280 档显示 3280/3280） */
function ClrbAchievePayProgress(status, rechargeTotal, tierAmount) {
  var total = Math.max(0, Number(rechargeTotal) || 0);
  var target = Math.max(0, Number(tierAmount) || 0);
  var current = target > 0 ? Math.min(total, target) : total;
  return { current: current, target: target };
}

/** 将档位奖励配置转为 UI 多格奖励列表 */
function ClrbAchievePushPayItemSlot(slots, itemKey, amount) {
  if (!itemKey) {
    return;
  }
  if (itemKey === "prophecy_card") {
    slots.push({
      kind: "prophecy_card",
      tipKey: "prophecy_card",
      icon: CLRB_ACHIEVE_REWARD_ICON_PROPHECY,
      amount: Math.max(1, Number(amount) || 1),
    });
    return;
  }
  if (itemKey.indexOf("title_") === 0) {
    slots.push({
      kind: "title",
      tipKey: itemKey,
      icon:
        CLRB_ACHIEVE_TITLE_ICONS[itemKey] ||
        CLRB_ACHIEVE_DEFAULT_REWARD_ICON,
      amount: 0,
    });
    return;
  }
  if (itemKey.indexOf("pet_") === 0) {
    slots.push({
      kind: "pet",
      tipKey: itemKey,
      icon: CLRB_ACHIEVE_REWARD_ICON_PET,
      amount: 0,
    });
  }
}

function ClrbAchieveBuildPayRewardSlots(reward) {
  reward = reward || {};
  var slots = [];
  if (reward.gold > 0) {
    slots.push({
      kind: "gold",
      icon: CLRB_ACHIEVE_REWARD_ICON_GOLD,
      amount: reward.gold,
    });
  }
  if (reward.hero_pick > 0) {
    slots.push({
      kind: "hero_pick",
      icon: CLRB_ACHIEVE_REWARD_ICON_HERO,
      amount: reward.hero_pick,
    });
  }
  if (reward.prophecy_card > 0) {
    ClrbAchievePushPayItemSlot(slots, "prophecy_card", reward.prophecy_card);
  }
  if (reward.title) {
    ClrbAchievePushPayItemSlot(slots, reward.title, 1);
  }
  if (reward.items && reward.items.length) {
    for (var i = 0; i < reward.items.length; i++) {
      var it = reward.items[i];
      if (it && it.itemKey) {
        ClrbAchievePushPayItemSlot(slots, it.itemKey, it.amount);
      }
    }
  }
  if (reward.pet) {
    ClrbAchievePushPayItemSlot(slots, reward.pet, 1);
  }
  return slots;
}

/** 英雄成就单奖励 */
function ClrbAchieveBuildHeroRewardSlots() {
  return [
    {
      kind: "gold",
      icon: CLRB_ACHIEVE_REWARD_ICON_GOLD,
      amount: CLRB_ACHIEVE_HERO_REWARD_GOLD,
    },
  ];
}

/** 构建全部英雄成就列表（110 条） */
function ClrbAchieveBuildHeroList(herodata) {
  herodata = herodata || {};
  var list = [];
  for (var i = 0; i < CLRB_ACHIEVE_HERO_INDICES.length; i++) {
    var idx = CLRB_ACHIEVE_HERO_INDICES[i];
    var key = "hero_" + idx;
    var status = herodata[key];
    if (status === undefined || status === null) {
      status = 2;
    }
    var hprog = ClrbAchieveHeroProgress(status);
    list.push({
      id: key,
      name: ClrbAchieveBuildHeroTitle(idx),
      current: hprog.current,
      target: hprog.target,
      rewards: ClrbAchieveBuildHeroRewardSlots(),
      status: ClrbAchieveServerStatusToUi(status),
    });
  }
  return list;
}

/** 与服务端 DAY_ACHIEVEMENTS 一致（UI 展示用） */
var CLRB_ACHIEVE_DAILY_DEFS = [
  {
    key: "index_games_hero_pick_repeat",
    repeatable: true,
    progressSource: "games",
    spentKey: "games_hero_pick_spent",
    claimCountKey: "games_hero_pick_claim_count",
    name: "累计游戏场数30局",
    target: 30,
    rewardItem: "hero_pick",
  },
  {
    key: "index_time_prophecy_repeat",
    repeatable: true,
    progressSource: "time",
    spentKey: "time_prophecy_spent",
    claimCountKey: "time_prophecy_claim_count",
    name: "累计游戏时长300分钟",
    target: 300,
    rewardItem: "prophecy_card",
  },
  { key: "index_team_first_3", statKey: "team_first", name: "累计获得队伍第一名3次", target: 3, reward_gold: 100 },
  { key: "index_title_shen_3", statKey: "tag2", name: "获得三次「神」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_bao_3", statKey: "tag3", name: "获得三次「暴」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_ying_3", statKey: "tag4", name: "获得三次「硬」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_famu_3", statKey: "tag8", name: "获得三次「伐木」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_li_3", statKey: "tag9", name: "获得三次「力」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_min_3", statKey: "tag10", name: "获得三次「敏」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_zhi_3", statKey: "tag11", name: "获得三次「智」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_hang_3", statKey: "tag14", name: "获得三次「夯」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_kuang_3", statKey: "tag15", name: "获得三次「狂」结算称号", target: 3, reward_gold: 100 },
  { key: "index_title_wushuang_1", statKey: "tag13", name: "获得一次「无双」结算称号", target: 1, reward_gold: 200 },
  { key: "index_dmg_suicide_5m", statKey: "dmg_suicide", name: "累积通过自爆造成500W伤害", target: 5000000, reward_gold: 200 },
  { key: "index_dmg_lightning_5m", statKey: "dmg_lightning", name: "累积通过落雷造成500W伤害", target: 5000000, reward_gold: 200 },
  { key: "index_dmg_crush_5m", statKey: "dmg_crush", name: "累积通过粉碎造成500W伤害", target: 5000000, reward_gold: 200 },
  { key: "index_bash_enemy_500", statKey: "bash_enemy", name: "累积通过重击造成500W伤害", target: 5000000, reward_gold: 200 },
  { key: "index_dmg_flame_5m", statKey: "dmg_flame", name: "累积通过烈焰缠身造成500W伤害", target: 5000000, reward_gold: 200 },
  { key: "index_plunder_gold_200k", statKey: "plunder_gold", name: "累积通过掠夺获得20W金币", target: 200000, reward_gold: 200 },
  { key: "index_kill_neutral_5000", statKey: "kill_neutral", name: "累积击杀野怪单位达到5000", target: 5000, reward_gold: 200 },
  { key: "index_kill_hero_500", statKey: "kill_hero", name: "累积击杀英雄单位达到500", target: 500, reward_gold: 200 },
];

function ClrbAchieveBuildDailyRewardSlots(rewardGold, rewardItem) {
  if (rewardItem === "prophecy_card") {
    return [
      {
        kind: "prophecy_card",
        tipKey: "prophecy_card",
        icon: CLRB_ACHIEVE_REWARD_ICON_PROPHECY,
        amount: 1,
      },
    ];
  }
  if (rewardItem === "hero_pick") {
    return [
      {
        kind: "hero_pick",
        tipKey: "hero_pick",
        icon: CLRB_ACHIEVE_REWARD_ICON_HERO,
        amount: 1,
      },
    ];
  }
  var gold = Number(rewardGold) || 0;
  if (gold <= 0) {
    return [];
  }
  return [
    {
      kind: "gold",
      icon: CLRB_ACHIEVE_REWARD_ICON_GOLD,
      amount: gold,
    },
  ];
}

/** 日常成就：进度来自 daystat / achieve.time / achieve.games，状态来自 daydata */
function ClrbAchieveBuildDailyList(daydata, daystat, definitions, achieveTime, achieveGames) {
  daydata = daydata || {};
  daystat = daystat || {};
  var totalMinutes = Math.max(0, Math.floor(Number(achieveTime) || 0));
  var totalGames = Math.max(0, Math.floor(Number(achieveGames) || 0));
  var defs =
    definitions && definitions.daily && definitions.daily.length
      ? definitions.daily
      : CLRB_ACHIEVE_DAILY_DEFS;

  return defs.map(function (def) {
    var key = def.key;
    var status = daydata[key];
    if (status === undefined || status === null) {
      status = 2;
    }
    var target = Number(def.target) || 0;
    var cur = 0;
    var claimCount = 0;
    var repeatable = def.repeatable === true;

    if (repeatable) {
      var spentKey = def.spentKey || "time_prophecy_spent";
      var claimCountKey = def.claimCountKey || "time_prophecy_claim_count";
      var progressSource = def.progressSource || "time";
      var spent = Math.max(0, Math.floor(Number(daystat[spentKey]) || 0));
      claimCount = Math.max(
        0,
        Math.floor(Number(daystat[claimCountKey]) || 0)
      );
      var total =
        progressSource === "games" ? totalGames : totalMinutes;
      cur = Math.max(0, total - spent);
      if (cur >= target) {
        status = 1;
      } else {
        status = 2;
      }
    } else {
      var statKey = def.statKey || "";
      cur = Math.max(0, Math.floor(Number(daystat[statKey]) || 0));
      var n = Number(status);
      if (n === 3) {
        cur = target;
      } else if (n === 1 && cur < target) {
        cur = target;
      }
    }

    return {
      id: key,
      name: def.name || "",
      current: cur,
      target: target,
      claimCount: claimCount,
      repeatable: repeatable,
      rewards: ClrbAchieveBuildDailyRewardSlots(def.reward_gold, def.rewardItem),
      status: repeatable
        ? cur >= target
          ? "claimable"
          : "locked"
        : ClrbAchieveServerStatusToUi(status),
    };
  });
}

function ClrbAchieveBuildRechargeList(paydata, rechargeTotal) {
  paydata = paydata || {};
  var recharge = Math.max(0, Number(rechargeTotal) || 0);
  return CLRB_ACHIEVE_PAY_TIERS.map(function (amount) {
    var key = "pay_" + amount;
    var status = paydata[key];
    if (status === undefined || status === null) {
      status = 2;
    }
    var reward = CLRB_ACHIEVE_PAY_REWARDS[amount] || { gold: 0 };
    var pprog = ClrbAchievePayProgress(status, recharge, amount);
    return {
      id: key,
      name: "累计充值" + amount + "元",
      current: pprog.current,
      target: pprog.target,
      rewards: ClrbAchieveBuildPayRewardSlots(reward),
      status: ClrbAchieveServerStatusToUi(status),
    };
  });
}

/**
 * 将服务端 achieve 包转为 UI 列表
 * @param {object} achievePayload achieve/get 或登录 payload.achieve
 * @param {number} rechargeTotal
 */
function ClrbAchieveBuildListFromServer(achievePayload, rechargeTotal) {
  if (!achievePayload) {
    return ClrbAchieveCloneMockList();
  }

  return {
    hero: ClrbAchieveBuildHeroList(achievePayload.herodata),
    daily: ClrbAchieveBuildDailyList(
      achievePayload.daydata,
      achievePayload.daystat,
      achievePayload.definitions,
      achievePayload.time,
      achievePayload.games
    ),
    recharge: ClrbAchieveBuildRechargeList(
      achievePayload.paydata,
      rechargeTotal
    ),
  };
}

/** 本地默认列表（无服务端数据时：全部英雄 + 充值档位） */
function ClrbAchieveCloneMockList() {
  return {
    hero: ClrbAchieveBuildHeroList({}),
    daily: ClrbAchieveBuildDailyList({}, {}, null, 0, 0),
    recharge: ClrbAchieveBuildRechargeList({}, 0),
  };
}

/**
 * 成就进度数字展示（与文案 20W / 500W 一致，W = 万）
 * @param {number} n
 */
function ClrbAchieveFormatProgressNum(n) {
  var v = Math.max(0, Math.floor(Number(n) || 0));
  if (v >= 10000 && v % 10000 === 0) {
    return String(v / 10000) + "W";
  }
  return String(v);
}

/** @param {number} current @param {number} target */
function ClrbAchieveFormatProgressText(current, target) {
  return (
    ClrbAchieveFormatProgressNum(current) +
    "/" +
    ClrbAchieveFormatProgressNum(target)
  );
}

function ClrbAchieveResolveStatus(item) {
  if (!item) {
    return "locked";
  }
  if (item.repeatable) {
    return item.status === "claimable" ? "claimable" : "locked";
  }
  if (item.status === "claimed") {
    return "claimed";
  }
  if (item.status === "claimable") {
    return "claimable";
  }
  var cur = Number(item.current);
  var tar = Number(item.target);
  if (Number.isFinite(cur) && Number.isFinite(tar) && tar > 0 && cur >= tar) {
    return "claimable";
  }
  return "locked";
}

/** 待领取成就置顶，其余保持原顺序 */
function ClrbAchieveSortListForDisplay(list) {
  if (!list || list.length <= 1) {
    return list;
  }
  var indexed = [];
  for (var i = 0; i < list.length; i++) {
    indexed.push({ item: list[i], index: i });
  }
  indexed.sort(function (a, b) {
    var aClaim = ClrbAchieveResolveStatus(a.item) === "claimable" ? 0 : 1;
    var bClaim = ClrbAchieveResolveStatus(b.item) === "claimable" ? 0 : 1;
    if (aClaim !== bClaim) {
      return aClaim - bClaim;
    }
    return a.index - b.index;
  });
  var sorted = [];
  for (var j = 0; j < indexed.length; j++) {
    sorted.push(indexed[j].item);
  }
  return sorted;
}

/** 某分类成就列表是否存在可领取项 */
function ClrbAchieveListHasClaimable(list) {
  if (!list || !list.length) {
    return false;
  }
  for (var i = 0; i < list.length; i++) {
    if (ClrbAchieveResolveStatus(list[i]) === "claimable") {
      return true;
    }
  }
  return false;
}

/** 英雄 / 日常 / 充值成就是否有待领取 */
function ClrbAchieveHasAnyClaimable(listData) {
  if (!listData) {
    return false;
  }
  return (
    ClrbAchieveListHasClaimable(listData.hero) ||
    ClrbAchieveListHasClaimable(listData.daily) ||
    ClrbAchieveListHasClaimable(listData.recharge)
  );
}