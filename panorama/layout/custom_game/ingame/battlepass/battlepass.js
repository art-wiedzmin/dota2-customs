--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


var sideTab = 1;
var EXP_BAR_TRACK_W = 1275;
var XP_PER_LEVEL = 500;
var CARD_MAX_LEVEL = 200;
var PREVIEW_PHASE_SIZE = 50;
var REWARD_COL_W = 163;
var REWARD_VIEW_W = 1310;
var SCROLL_EDGE_THRESHOLD = 12;
var REWARD_DEFAULT_FOCUS_LEVEL = 52;
var REWARD_MILESTONE_OVERLAY_LEVEL = 30;
var REWARD_SCROLL_APPLY_MAX_TRY = 15;
var rewardPreviewMax = PREVIEW_PHASE_SIZE;
var displayPhaseIndex = 0;
var rewardScrollStart = 1;
var rewardScrollEnd = PREVIEW_PHASE_SIZE - 1;
var rewardOverlayLevel = PREVIEW_PHASE_SIZE;
var rewardScrollEdgeLock = false;
var rewardLastScrollLeft = -1;
var battlePassCard = null;

function GetCardLevel(card) {
  var exp = 0;
  if (card && card.exp != null) {
    exp = parseInt(card.exp, 10) || 0;
  }
  if (exp < 0) {
    exp = 0;
  }
  return Math.floor(exp / XP_PER_LEVEL) + 1;
}

/** 奖励预览上限：每 50 级一阶段，玩家超过当前阶段则扩展至下一阶段，最高 200 */
function GetRewardPreviewMax(card) {
  var playerLevel = GetCardLevel(card);
  var phaseMax =
    Math.ceil(playerLevel / PREVIEW_PHASE_SIZE) * PREVIEW_PHASE_SIZE;
  if (phaseMax < PREVIEW_PHASE_SIZE) {
    phaseMax = PREVIEW_PHASE_SIZE;
  }
  if (phaseMax > CARD_MAX_LEVEL) {
    phaseMax = CARD_MAX_LEVEL;
  }
  return phaseMax;
}

function GetUnlockedPhaseCount(card) {
  return Math.ceil(GetRewardPreviewMax(card) / PREVIEW_PHASE_SIZE);
}

function GetPhaseForLevel(level) {
  return Math.floor((Math.max(1, level) - 1) / PREVIEW_PHASE_SIZE);
}

/** 根据领取进度定位应展示的阶段（下一待领等级所在页） */
function GetClaimFocusLevel(card) {
  if (!card) {
    return 1;
  }
  var currentLevel = GetCardLevel(card);
  var freeClaimed = CardNum(card, "get_level");
  var premiumClaimed = CardNum(card, "get_level_premium");
  var premiumActive = IsPremiumActive(card);
  var focus = currentLevel;

  if (freeClaimed < currentLevel) {
    focus = freeClaimed + 1;
  }
  if (premiumActive && premiumClaimed < currentLevel) {
    if (freeClaimed < currentLevel) {
      focus = Math.min(focus, premiumClaimed + 1);
    } else {
      focus = premiumClaimed + 1;
    }
  }
  if (focus < 1) {
    focus = 1;
  }
  return focus;
}

/** @returns {boolean} 阶段是否发生变化 */
function SyncDisplayPhase(card) {
  var maxPhase = GetUnlockedPhaseCount(card) - 1;
  if (maxPhase < 0) {
    maxPhase = 0;
  }
  var targetPhase = GetPhaseForLevel(GetClaimFocusLevel(card));
  if (targetPhase > maxPhase) {
    targetPhase = maxPhase;
  }
  if (targetPhase < 0) {
    targetPhase = 0;
  }
  var changed = displayPhaseIndex !== targetPhase;
  displayPhaseIndex = targetPhase;
  return changed;
}

function GetDefaultOverlayLevelForPhase(phaseIndex) {
  var phaseEnd = Math.min(
    (phaseIndex + 1) * PREVIEW_PHASE_SIZE,
    rewardPreviewMax
  );
  return phaseEnd;
}

/** 未满 30 级时，右侧固定栏预览 30 级里程碑奖励 */
function IsOverlayPinnedToMilestone(card) {
  return !!card && GetCardLevel(card) < REWARD_MILESTONE_OVERLAY_LEVEL;
}

function ResolveRewardOverlayLevel(card, phaseIndex) {
  if (IsOverlayPinnedToMilestone(card)) {
    return REWARD_MILESTONE_OVERLAY_LEVEL;
  }
  return GetDefaultOverlayLevelForPhase(phaseIndex);
}

function ShouldSkipScrollRewardLevel(level, card) {
  return (
    IsOverlayPinnedToMilestone(card) &&
    level === REWARD_MILESTONE_OVERLAY_LEVEL
  );
}

function ApplyPhaseDisplayRange(phaseIndex, card) {
  var phaseStart = phaseIndex * PREVIEW_PHASE_SIZE + 1;
  var phaseEnd = Math.min((phaseIndex + 1) * PREVIEW_PHASE_SIZE, rewardPreviewMax);
  rewardScrollStart = phaseStart;
  rewardScrollEnd = phaseEnd - 1;
  if (IsOverlayPinnedToMilestone(card)) {
    rewardScrollEnd = Math.min(
      rewardScrollEnd,
      REWARD_MILESTONE_OVERLAY_LEVEL - 1
    );
  }
  rewardOverlayLevel = ResolveRewardOverlayLevel(
    card || battlePassCard,
    phaseIndex
  );
}

function ApplyRewardPreviewRange(card) {
  var newMax = GetRewardPreviewMax(card);
  var oldMax = rewardPreviewMax;
  rewardPreviewMax = newMax;
  var phaseChanged = SyncDisplayPhase(card);
  return newMax !== oldMax || phaseChanged;
}

function GetRewardRowScrollWidth() {
  var count = rewardScrollEnd - rewardScrollStart + 1;
  if (
    battlePassCard &&
    ShouldSkipScrollRewardLevel(REWARD_MILESTONE_OVERLAY_LEVEL, battlePassCard) &&
    rewardScrollStart <= REWARD_MILESTONE_OVERLAY_LEVEL &&
    rewardScrollEnd >= REWARD_MILESTONE_OVERLAY_LEVEL
  ) {
    count -= 1;
  }
  if (count < 1) {
    count = 1;
  }
  return count * REWARD_COL_W;
}

function GetDefaultRewardFocusLevel(card) {
  var playerLevel = card ? GetCardLevel(card) : 1;
  var targetLevel = REWARD_DEFAULT_FOCUS_LEVEL;
  if (playerLevel <= PREVIEW_PHASE_SIZE) {
    targetLevel = rewardScrollStart;
  } else {
    if (targetLevel < rewardScrollStart) {
      targetLevel = rewardScrollStart;
    }
    if (targetLevel > rewardScrollEnd) {
      targetLevel = rewardScrollEnd;
    }
  }
  return targetLevel;
}

function GetScrollLeftForLevel(level) {
  var colIndex = level - rewardScrollStart;
  if (colIndex < 0) {
    colIndex = 0;
  }
  return colIndex * REWARD_COL_W;
}

function UpdateRewardRowWidth() {
  var row = GetPanel("reward_list_row");
  if (!row) {
    return;
  }
  row.style.width = GetRewardRowScrollWidth() + "px";
}

function GetRewardScrollMax() {
  var scroll = GetPanel("reward_list_scroll");
  if (!scroll) {
    return 0;
  }
  var contentW = GetRewardRowScrollWidth();
  var viewW = scroll.actuallayoutwidth;
  if (!viewW || viewW < 1) {
    viewW = REWARD_VIEW_W;
  }
  var max = contentW - viewW;
  return max > 0 ? max : 0;
}

/** 未满 30 级时滚动条最多滚到 29 级对应位置 */
function GetRewardScrollLeftCap(card) {
  var maxScroll = GetRewardScrollMax();
  if (!IsOverlayPinnedToMilestone(card)) {
    return maxScroll;
  }
  var milestoneCap = GetScrollLeftForLevel(REWARD_MILESTONE_OVERLAY_LEVEL - 1);
  return milestoneCap < maxScroll ? milestoneCap : maxScroll;
}

function ClampRewardScrollPosition(card) {
  var scroll = GetPanel("reward_list_scroll");
  if (!scroll || !card) {
    return;
  }
  var cap = GetRewardScrollLeftCap(card);
  var sl = scroll.scrollLeft || 0;
  if (sl > cap) {
    scroll.scrollLeft = cap;
    rewardLastScrollLeft = cap;
  }
}

function ApplyDefaultRewardScrollPosition(card) {
  var scroll = GetPanel("reward_list_scroll");
  if (!scroll) {
    return 0;
  }
  if (displayPhaseIndex === 0) {
    scroll.scrollLeft = 0;
    rewardLastScrollLeft = 0;
    UpdateRewardScrollEdgePanels();
    return 0;
  }
  var targetLevel = GetDefaultRewardFocusLevel(card);
  var offset = GetScrollLeftForLevel(targetLevel);
  var maxScroll = GetRewardScrollLeftCap(card);
  if (offset > maxScroll) {
    offset = maxScroll;
  }
  scroll.scrollLeft = offset;
  rewardLastScrollLeft = offset;
  UpdateRewardScrollEdgePanels();
  return offset;
}

function ScheduleRewardScrollApply(scrollMode) {
  var mode = scrollMode || "default";
  if (mode === "prev" || mode === "zero") {
    ApplyRewardScrollPosition(mode);
    return;
  }
  var tries = 0;
  function TryApplyScroll() {
    tries += 1;
    ApplyRewardScrollPosition("default");
    if (displayPhaseIndex === 0) {
      return;
    }
    var scroll = GetPanel("reward_list_scroll");
    if (!scroll) {
      return;
    }
    var wantLeft = GetScrollLeftForLevel(
      GetDefaultRewardFocusLevel(battlePassCard)
    );
    var maxScroll = GetRewardScrollMax();
    var sl = scroll.scrollLeft || 0;
    var layoutReady = maxScroll > 0;
    var scrollReady = layoutReady && sl >= wantLeft - SCROLL_EDGE_THRESHOLD;
    if (!scrollReady && tries < REWARD_SCROLL_APPLY_MAX_TRY) {
      $.Schedule(0.05, TryApplyScroll);
    } else {
      UpdateRewardScrollEdgePanels();
    }
  }
  TryApplyScroll();
}

function ApplyRewardScrollPosition(scrollMode) {
  var scroll = GetPanel("reward_list_scroll");
  if (!scroll) {
    return;
  }
  rewardScrollEdgeLock = true;
  if (scrollMode === "prev" || scrollMode === "zero") {
    scroll.scrollLeft = 0;
    rewardLastScrollLeft = 0;
  } else {
    ApplyDefaultRewardScrollPosition(battlePassCard);
  }
  UpdateRewardScrollEdgePanels();
  $.Schedule(0.12, function () {
    rewardScrollEdgeLock = false;
    UpdateRewardScrollEdgePanels();
  });
}

function UpdateRewardScrollEdgePanels() {
  var leftEdge = GetPanel("reward_scroll_edge_left");
  var scroll = GetPanel("reward_list_scroll");
  if (!leftEdge || !scroll) {
    return;
  }
  var sl = scroll.scrollLeft || 0;
  var showLeft =
    displayPhaseIndex > 0 && sl <= SCROLL_EDGE_THRESHOLD && !rewardScrollEdgeLock;
  leftEdge.visible = showLeft;
  leftEdge.hittest = showLeft;
}

function GoToPrevRewardPhase() {
  if (rewardScrollEdgeLock || displayPhaseIndex <= 0) {
    return;
  }
  rewardScrollEdgeLock = true;
  displayPhaseIndex -= 1;
  RebuildRewardListView("prev");
}

function OnRewardScrollEdgeCheck(trigger) {
  if (rewardScrollEdgeLock) {
    return;
  }
  var scroll = GetPanel("reward_list_scroll");
  if (!scroll || !battlePassCard) {
    return;
  }
  ClampRewardScrollPosition(battlePassCard);
  var sl = scroll.scrollLeft || 0;
  var maxScroll = GetRewardScrollMax();
  var playerLevel = GetCardLevel(battlePassCard);

  UpdateRewardScrollEdgePanels();

  if (
    trigger === "scroll" &&
    displayPhaseIndex > 0 &&
    sl <= SCROLL_EDGE_THRESHOLD
  ) {
    GoToPrevRewardPhase();
    return;
  }

  if (
    !IsOverlayPinnedToMilestone(battlePassCard) &&
    maxScroll > SCROLL_EDGE_THRESHOLD &&
    sl >= maxScroll - SCROLL_EDGE_THRESHOLD &&
    playerLevel > rewardOverlayLevel
  ) {
    var maxPhase = GetUnlockedPhaseCount(battlePassCard) - 1;
    if (displayPhaseIndex < maxPhase) {
      rewardScrollEdgeLock = true;
      displayPhaseIndex += 1;
      RebuildRewardListView("default");
    }
  }
}

function InitRewardScrollEdgeLeft() {
  var edge = GetPanel("reward_scroll_edge_left");
  if (!edge || edge.__rewardEdgeBound) {
    return;
  }
  edge.__rewardEdgeBound = true;
  edge.SetPanelEvent("onactivate", function () {
    GoToPrevRewardPhase();
  });
  edge.SetPanelEvent("onmousewheel", function (delta) {
    if (delta > 0) {
      GoToPrevRewardPhase();
    }
  });
}

function InitRewardScrollListener() {
  var scroll = GetPanel("reward_list_scroll");
  if (!scroll || scroll.__rewardScrollBound) {
    return;
  }
  scroll.__rewardScrollBound = true;
  scroll.SetPanelEvent("onscroll", function () {
    if (rewardScrollEdgeLock) {
      return;
    }
    var sc = GetPanel("reward_list_scroll");
    if (sc) {
      rewardLastScrollLeft = sc.scrollLeft || 0;
    }
    OnRewardScrollEdgeCheck("scroll");
  });
  scroll.SetPanelEvent("onmousewheel", function (delta) {
    if (rewardScrollEdgeLock) {
      return;
    }
    var sc = GetPanel("reward_list_scroll");
    if (!sc) {
      return;
    }
    var sl = sc.scrollLeft || 0;
    if (displayPhaseIndex > 0 && sl <= SCROLL_EDGE_THRESHOLD && delta > 0) {
      GoToPrevRewardPhase();
    }
  });
  function PollRewardScroll() {
    var sc = GetPanel("reward_list_scroll");
    if (sc) {
      var sl = sc.scrollLeft || 0;
      if (!rewardScrollEdgeLock && sl !== rewardLastScrollLeft) {
        rewardLastScrollLeft = sl;
        OnRewardScrollEdgeCheck("poll");
      }
    }
    UpdateRewardScrollEdgePanels();
    $.Schedule(0.08, PollRewardScroll);
  }
  PollRewardScroll();
  InitRewardScrollEdgeLeft();
}

function FindRewardCol(level) {
  if (level === rewardOverlayLevel) {
    return GetPanel("reward_overlay_col");
  }
  var row = GetPanel("reward_list_row");
  if (!row) {
    return null;
  }
  return row.FindChild("reward_col_" + level);
}

function RebuildRewardListView(scrollMode) {
  BuildRewardList(scrollMode || "default");
  BuildOverlayCol();
}

function IsPremiumActive(card) {
  if (!card || card.state == null) {
    return false;
  }
  var s = card.state;
  if (s === true || s === "true") {
    return true;
  }
  return CardNum(card, "state") >= 1;
}

function FindDirectChildByClass(parent, className) {
  if (!parent) {
    return null;
  }
  var count = parent.GetChildCount();
  for (var i = 0; i < count; i++) {
    var child = parent.GetChild(i);
    if (child && child.BHasClass(className)) {
      return child;
    }
  }
  return null;
}

/** @returns {"claimable"|"claimed"|"locked"} */
function GetRewardSlotState(currentLevel, rewardLevel, claimedUpToLevel, forceLocked) {
  if (forceLocked) {
    return "locked";
  }
  if (rewardLevel <= claimedUpToLevel) {
    return "claimed";
  }
  if (currentLevel >= rewardLevel) {
    return "claimable";
  }
  return "locked";
}

function ApplyRewardSlotVisual(slotPanel, lockImg, claimedLabel, state) {
  if (!slotPanel) {
    return;
  }
  slotPanel.RemoveClass("reward_slot_claimable");
  slotPanel.RemoveClass("reward_slot_claimed");
  slotPanel.RemoveClass("reward_slot_locked");
  slotPanel.AddClass("reward_slot_" + state);
  if (lockImg) {
    lockImg.visible = state === "locked";
  }
  if (claimedLabel) {
    claimedLabel.visible = state === "claimed";
  }
}

function InitData() {
  var tp = "init";
  SendServer("Lua_Shop", { data: { tp } });
}

function OpenPage() {
  SendServer("Lua_Shop", { data: { tp: "OpenBattlePass" } });
}

function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_Shop", { data: { tp } });
}

function ClickSideTab(num) {
  if (sideTab === num) {
    return;
  }
  sideTab = num;
  var rewardBtn = GetPanel("side_tab_reward");
  var taskBtn = GetPanel("side_tab_task");
  var rewardPanel = GetPanel("panel_reward");
  var taskPanel = GetPanel("panel_task");
  if (num === 1) {
    rewardBtn.AddClass("active");
    taskBtn.RemoveClass("active");
    rewardPanel.RemoveClass("hidden");
    taskPanel.AddClass("hidden");
  } else if (num === 2) {
    taskBtn.AddClass("active");
    rewardBtn.RemoveClass("active");
    taskPanel.RemoveClass("hidden");
    rewardPanel.AddClass("hidden");
  }
}

function UpdateRewardTop(card) {
  var exp = 0;
  if (card && card.exp != null) {
    exp = parseInt(card.exp, 10) || 0;
  }
  if (exp < 0) {
    exp = 0;
  }
  var level = Math.floor(exp / XP_PER_LEVEL) + 1;
  var curInLevel = exp % XP_PER_LEVEL;
  var levelText = GetPanel("level_text");
  var expText = GetPanel("exp_text");
  var fill = GetPanel("exp_bar_fill");
  if (levelText) {
    levelText.text = "战令等级：" + level + "/200级";
  }
  if (expText) {
    expText.text = curInLevel + "/" + XP_PER_LEVEL;
  }
  if (fill) {
    var ratio = XP_PER_LEVEL > 0 ? curInLevel / XP_PER_LEVEL : 0;
    if (ratio < 0) {
      ratio = 0;
    }
    if (ratio > 1) {
      ratio = 1;
    }
    fill.style.width = Math.floor(EXP_BAR_TRACK_W * ratio) + "px";
  }
}

var REWARD_ICON_GOLD = "file://{images}/card/jl1.png";
var REWARD_ICON_HERO = "file://{images}/card/herocard.png";
var REWARD_ICON_TITLE_FREE =
  "raw://resource/flash3/images/card/ch_clxz.png";
var REWARD_ICON_TITLE_PREMIUM =
  "raw://resource/flash3/images/card/ch_hsbh.png";
var REWARD_ICON_ATTACK_PREMIUM =
  "raw://resource/flash3/images/card/txz_lxhs.png";
var REWARD_TIP_TITLE_FREE = "title_clxz";
var REWARD_TIP_TITLE_PREMIUM = "title_hsbh";
var REWARD_TIP_PREMIUM_EFFECT = "attack_lxhs";
// 与 Shop.CardStaticData.free.title_by_level 一致（仅 30 级普通轨道为称号）
var FREE_TITLE_REWARD_LEVEL = 30;
var PREMIUM_TITLE_REWARD_LEVEL = 30;
var PREMIUM_EFFECT_REWARD_LEVEL = 1;
var battlePassItemList = null;
var passCosmeticsSeasonId = null;

function GetItemListIcon(itemKey) {
  if (!itemKey || !battlePassItemList) {
    return null;
  }
  var meta = battlePassItemList[itemKey];
  if (meta && meta.icon) {
    return meta.icon;
  }
  return null;
}

/** 按道具 key 推断默认图标（与 Shop.ItemList / 资源 ch_*.png 对齐） */
function GuessItemIcon(itemKey) {
  if (!itemKey) {
    return null;
  }
  if (itemKey.indexOf("title_") === 0) {
    return (
      "raw://resource/flash3/images/card/ch_" +
      itemKey.substring(6) +
      ".png"
    );
  }
  if (itemKey === "attack_lxhs") {
    return "raw://resource/flash3/images/card/txz_lxhs.png";
  }
  if (itemKey === "attack_atv3") {
    return "raw://resource/flash3/images/card/tx_bgls.png";
  }
  if (itemKey === "effect_tx1") {
    return "raw://resource/flash3/images/card/tx1.png";
  }
  if (itemKey === "effect_lzqz") {
    return "raw://resource/flash3/images/card/tx_lzzq.png";
  }
  if (itemKey === "effect_txhb") {
    return "raw://resource/flash3/images/card/tx_xxhd.png";
  }
  return null;
}

function ResolvePassItemIcon(itemKey, fallbackIcon) {
  // 与礼包相同：只用本地键取图，不依赖服务端 icon URL
  return (
    GetItemListIcon(itemKey) ||
    GuessItemIcon(itemKey) ||
    fallbackIcon ||
    null
  );
}

/** 赛季写死截止日期（与服务端 PASS_SEASONS.deadline 一致） */
var PASS_SEASON_DEADLINE_TEXT = {
  legacy: "截止日期：2026.08.07",
  "2026-08": "截止日期：2026.09.07",
  "2026-09": "截止日期：2026.10.07",
  "2026-10": "截止日期：2026.11.07",
};

/**
 * 客户端本地赛季表（与礼包同理：服务端只给 season_id / itemKey，图本地取）
 * 只要拿到 season_id，即可完整刷新图标与截止日期。
 */
var PASS_SEASON_LOCAL = {
  legacy: {
    freeKey: "title_clxz",
    premKey: "title_hsbh",
    fxKey: "attack_lxhs",
    fxKind: "attack",
    deadlineText: "截止日期：2026.08.07",
  },
  "2026-08": {
    freeKey: "title_clls",
    premKey: "title_hdlm",
    fxKey: "effect_lzqz",
    fxKind: "effect",
    deadlineText: "截止日期：2026.09.07",
  },
  "2026-09": {
    freeKey: "title_clmy",
    premKey: "title_xxqc",
    fxKey: "attack_atv3",
    fxKind: "attack",
    deadlineText: "截止日期：2026.10.07",
  },
  "2026-10": {
    freeKey: "title_clzw",
    premKey: "title_rzzl",
    fxKey: "effect_txhb",
    fxKind: "effect",
    deadlineText: "截止日期：2026.11.07",
  },
};

function DeadlineTextForSeason(seasonId) {
  if (!seasonId) {
    return null;
  }
  return PASS_SEASON_DEADLINE_TEXT[String(seasonId)] || null;
}

function CosmeticsFromSeasonId(seasonId, overrides) {
  var id = seasonId != null ? String(seasonId) : "";
  var row = PASS_SEASON_LOCAL[id];
  if (!row) {
    return null;
  }
  overrides = overrides || {};
  return {
    seasonId: id,
    deadlineText: overrides.deadline_text || row.deadlineText,
    freeTitle: {
      level: 30,
      itemKey: overrides.free_title_key || row.freeKey,
    },
    premiumTitle: {
      level: 30,
      itemKey: overrides.premium_title_key || row.premKey,
    },
    premiumEffect: {
      level: 1,
      itemKey: overrides.premium_effect_key || row.fxKey,
      kind: overrides.premium_effect_kind || row.fxKind,
    },
  };
}

function UpdateDeadlineLabel(cosmetics) {
  if (!cosmetics) {
    return;
  }
  var seasonId =
    cosmetics.seasonId || cosmetics.season_id || cosmetics.seasonid;
  var text =
    DeadlineTextForSeason(seasonId) ||
    cosmetics.deadlineText ||
    cosmetics.deadline_text ||
    cosmetics.deadlinetext;
  if (!text && cosmetics.deadline) {
    text = "截止日期：" + String(cosmetics.deadline).replace(/-/g, ".");
  }
  if (!text) {
    return;
  }
  var deadlineLabel = $("#deadline_text");
  if (!deadlineLabel && $.GetContextPanel) {
    deadlineLabel = $.GetContextPanel().FindChildTraverse("deadline_text");
  }
  if (deadlineLabel) {
    deadlineLabel.text = text;
  }
}

/** 兼容 camelCase / snake_case / 全小写，以及 JSON 字符串载荷 */
function NormalizePassRewardEntry(entry) {
  if (!entry || typeof entry !== "object") {
    return null;
  }
  return {
    level: entry.level != null ? entry.level : entry.Level,
    itemKey: entry.itemKey || entry.item_key || entry.itemkey,
    name: entry.name || entry.Name,
    kind: entry.kind || entry.Kind,
  };
}

function NormalizePassCosmetics(raw) {
  if (!raw) {
    return null;
  }
  var c = raw;
  if (typeof raw === "string") {
    try {
      c = JSON.parse(raw);
    } catch (e) {
      return null;
    }
  }
  if (typeof c !== "object") {
    return null;
  }
  var seasonId = c.seasonId || c.season_id || c.seasonid || null;
  // 优先用本地赛季表（只靠 season_id）
  if (seasonId && PASS_SEASON_LOCAL[String(seasonId)]) {
    return CosmeticsFromSeasonId(seasonId, {
      free_title_key: c.free_title_key || c.pass_free_title_key,
      premium_title_key: c.premium_title_key || c.pass_premium_title_key,
      premium_effect_key: c.premium_effect_key || c.pass_premium_effect_key,
      premium_effect_kind: c.premium_effect_kind || c.pass_premium_effect_kind,
      deadline_text: c.deadline_text || c.deadlineText || c.deadlinetext,
    });
  }
  var free = NormalizePassRewardEntry(
    c.freeTitle || c.free_title || c.freetitle
  );
  var prem = NormalizePassRewardEntry(
    c.premiumTitle || c.premium_title || c.premiumtitle
  );
  var fx = NormalizePassRewardEntry(
    c.premiumEffect || c.premium_effect || c.premiumeffect
  );
  if (c.free_title_key || c.pass_free_title_key) {
    free = {
      level: c.free_title_level != null ? c.free_title_level : 30,
      itemKey: c.free_title_key || c.pass_free_title_key,
      name: c.free_title_name || (free && free.name) || null,
    };
  }
  if (c.premium_title_key || c.pass_premium_title_key) {
    prem = {
      level: c.premium_title_level != null ? c.premium_title_level : 30,
      itemKey: c.premium_title_key || c.pass_premium_title_key,
      name: c.premium_title_name || (prem && prem.name) || null,
    };
  }
  if (c.premium_effect_key || c.pass_premium_effect_key) {
    fx = {
      level: c.premium_effect_level != null ? c.premium_effect_level : 1,
      itemKey: c.premium_effect_key || c.pass_premium_effect_key,
      name: c.premium_effect_name || (fx && fx.name) || null,
      kind:
        c.premium_effect_kind ||
        c.pass_premium_effect_kind ||
        (fx && fx.kind) ||
        "attack",
    };
  }
  var deadlineText =
    DeadlineTextForSeason(seasonId) ||
    c.deadlineText ||
    c.deadline_text ||
    c.deadlinetext ||
    null;
  return {
    seasonId: seasonId,
    seasonLabel: c.seasonLabel || c.season_label || c.seasonlabel || null,
    monthLabel: c.monthLabel || c.month_label || c.monthlabel || null,
    deadline: c.deadline || null,
    deadlineText: deadlineText,
    freeTitle: free,
    premiumTitle: prem,
    premiumEffect: fx,
  };
}

function ResolvePassCosmeticsFromData(data) {
  if (!data) {
    return null;
  }
  var seasonId = data.pass_season_id || data.season_id || data.seasonId;
  if (seasonId && PASS_SEASON_LOCAL[String(seasonId)]) {
    return CosmeticsFromSeasonId(seasonId, {
      free_title_key: data.pass_free_title_key || data.free_title_key,
      premium_title_key: data.pass_premium_title_key || data.premium_title_key,
      premium_effect_key: data.pass_premium_effect_key || data.premium_effect_key,
      premium_effect_kind:
        data.pass_premium_effect_kind || data.premium_effect_kind,
      deadline_text: data.pass_deadline_text || data.deadline_text,
    });
  }
  if (data.pass_free_title_key || data.pass_premium_title_key) {
    var flat = {
      season_id: data.pass_season_id,
      deadline_text: data.pass_deadline_text,
      free_title_key: data.pass_free_title_key,
      premium_title_key: data.pass_premium_title_key,
      premium_effect_key: data.pass_premium_effect_key,
      premium_effect_kind: data.pass_premium_effect_kind,
    };
    var fromFlat = NormalizePassCosmetics(flat);
    if (fromFlat && (fromFlat.freeTitle || fromFlat.premiumTitle || fromFlat.seasonId)) {
      return fromFlat;
    }
  }
  var fromJson = data.pass_cosmetics_json
    ? NormalizePassCosmetics(data.pass_cosmetics_json)
    : null;
  var fromObj = NormalizePassCosmetics(data.pass_cosmetics);
  return fromJson || fromObj;
}

/** 独立赛季小包 / NetTable 回调 */
function ApplyPassSeasonPayload(data) {
  if (!data) {
    return;
  }
  var seasonId = data.season_id || data.seasonId || data.pass_season_id;
  var cosmetics =
    CosmeticsFromSeasonId(seasonId, data) ||
    NormalizePassCosmetics(data) ||
    ResolvePassCosmeticsFromData(data);
  if (!cosmetics) {
    return;
  }
  var changed = !!ApplyPassCosmetics(cosmetics);
  UpdateDeadlineLabel(cosmetics);
  if (changed && battlePassCard) {
    RebuildRewardListView();
  }
}

function OnPassSeasonEvent(data) {
  ApplyPassSeasonPayload(data);
}

function ReadPassSeasonNetTable() {
  if (!CustomNetTables || !CustomNetTables.GetTableValue) {
    return;
  }
  var lp =
    typeof Game !== "undefined" && Game.GetLocalPlayerID
      ? Game.GetLocalPlayerID()
      : -1;
  if (lp == null || lp < 0) {
    return;
  }
  var row = CustomNetTables.GetTableValue("clrb_pass_season", String(lp));
  if (row) {
    ApplyPassSeasonPayload(row);
  }
}

/** 服务端通行证赛季热更新：替换称号/特效图标与 tip */
function ApplyPassCosmetics(cosmetics) {
  cosmetics = NormalizePassCosmetics(cosmetics);
  if (!cosmetics) {
    return false;
  }
  var nextFree =
    (cosmetics.freeTitle && cosmetics.freeTitle.itemKey) || REWARD_TIP_TITLE_FREE;
  var nextPrem =
    (cosmetics.premiumTitle && cosmetics.premiumTitle.itemKey) ||
    REWARD_TIP_TITLE_PREMIUM;
  var nextFx =
    (cosmetics.premiumEffect && cosmetics.premiumEffect.itemKey) ||
    REWARD_TIP_PREMIUM_EFFECT;
  var changed =
    !passCosmeticsSeasonId ||
    passCosmeticsSeasonId !== cosmetics.seasonId ||
    REWARD_TIP_TITLE_FREE !== nextFree ||
    REWARD_TIP_TITLE_PREMIUM !== nextPrem ||
    REWARD_TIP_PREMIUM_EFFECT !== nextFx ||
    !!(cosmetics.deadlineText || cosmetics.deadline);

  if (cosmetics.freeTitle) {
    if (cosmetics.freeTitle.itemKey) {
      REWARD_TIP_TITLE_FREE = cosmetics.freeTitle.itemKey;
    }
    REWARD_ICON_TITLE_FREE =
      ResolvePassItemIcon(REWARD_TIP_TITLE_FREE, cosmetics.freeTitle.icon) ||
      REWARD_ICON_TITLE_FREE;
    if (cosmetics.freeTitle.level != null) {
      FREE_TITLE_REWARD_LEVEL = parseInt(cosmetics.freeTitle.level, 10) || 30;
    }
  }
  if (cosmetics.premiumTitle) {
    if (cosmetics.premiumTitle.itemKey) {
      REWARD_TIP_TITLE_PREMIUM = cosmetics.premiumTitle.itemKey;
    }
    REWARD_ICON_TITLE_PREMIUM =
      ResolvePassItemIcon(
        REWARD_TIP_TITLE_PREMIUM,
        cosmetics.premiumTitle.icon
      ) || REWARD_ICON_TITLE_PREMIUM;
    if (cosmetics.premiumTitle.level != null) {
      PREMIUM_TITLE_REWARD_LEVEL =
        parseInt(cosmetics.premiumTitle.level, 10) || 30;
    }
  }
  if (cosmetics.premiumEffect) {
    if (cosmetics.premiumEffect.itemKey) {
      REWARD_TIP_PREMIUM_EFFECT = cosmetics.premiumEffect.itemKey;
    }
    REWARD_ICON_ATTACK_PREMIUM =
      ResolvePassItemIcon(
        REWARD_TIP_PREMIUM_EFFECT,
        cosmetics.premiumEffect.icon
      ) || REWARD_ICON_ATTACK_PREMIUM;
    if (cosmetics.premiumEffect.level != null) {
      PREMIUM_EFFECT_REWARD_LEVEL =
        parseInt(cosmetics.premiumEffect.level, 10) || 1;
    }
  }
  if (typeof CARD_TIP_KEY_ALIAS !== "undefined") {
    CARD_TIP_KEY_ALIAS.title = REWARD_TIP_TITLE_FREE;
    CARD_TIP_KEY_ALIAS.title_premium = REWARD_TIP_TITLE_PREMIUM;
    if (
      cosmetics.premiumEffect &&
      cosmetics.premiumEffect.kind === "effect"
    ) {
      CARD_TIP_KEY_ALIAS.effect_premium = REWARD_TIP_PREMIUM_EFFECT;
      CARD_TIP_KEY_ALIAS.attack_premium = REWARD_TIP_PREMIUM_EFFECT;
    } else {
      CARD_TIP_KEY_ALIAS.attack_premium = REWARD_TIP_PREMIUM_EFFECT;
      CARD_TIP_KEY_ALIAS.effect_premium = REWARD_TIP_PREMIUM_EFFECT;
    }
  }
  passCosmeticsSeasonId = cosmetics.seasonId || passCosmeticsSeasonId;
  UpdateDeadlineLabel(cosmetics);
  return changed;
}

function IsFreeTitleRewardLevel(level) {
  return parseInt(level, 10) === FREE_TITLE_REWARD_LEVEL;
}

function IsPremiumTitleRewardLevel(level) {
  return parseInt(level, 10) === PREMIUM_TITLE_REWARD_LEVEL;
}

function IsPremiumEffectRewardLevel(level) {
  return parseInt(level, 10) === PREMIUM_EFFECT_REWARD_LEVEL;
}

function IsTenMultipleRewardLevel(level) {
  return level > 0 && level % 10 === 0;
}

function GetFreeRewardCount(level) {
  if (IsFreeTitleRewardLevel(level)) {
    return "";
  }
  if (IsTenMultipleRewardLevel(level)) {
    return "80";
  }
  return "40";
}

function GetPremiumRewardCount(level) {
  if (IsPremiumTitleRewardLevel(level) || IsPremiumEffectRewardLevel(level)) {
    return "";
  }
  if (IsTenMultipleRewardLevel(level)) {
    return "160";
  }
  return "80";
}

function GetFreeRewardIcon(level) {
  if (IsFreeTitleRewardLevel(level)) {
    return REWARD_ICON_TITLE_FREE;
  }
  return REWARD_ICON_GOLD;
}

function GetPremiumPrimaryRewardIcon(level) {
  if (IsPremiumEffectRewardLevel(level)) {
    return REWARD_ICON_ATTACK_PREMIUM;
  }
  if (IsPremiumTitleRewardLevel(level)) {
    return REWARD_ICON_TITLE_PREMIUM;
  }
  return REWARD_ICON_GOLD;
}

function HasPremiumExtraReward(level) {
  return IsTenMultipleRewardLevel(level);
}

function IsTitleRewardIcon(iconPath) {
  if (!iconPath) {
    return false;
  }
  return (
    iconPath === REWARD_ICON_TITLE_FREE ||
    iconPath === REWARD_ICON_TITLE_PREMIUM ||
    iconPath.indexOf("/ch_") >= 0 ||
    iconPath.indexOf("ch_") >= 0
  );
}

function IsAttackRewardIcon(iconPath) {
  if (!iconPath) {
    return false;
  }
  return (
    iconPath === REWARD_ICON_ATTACK_PREMIUM ||
    iconPath.indexOf("txz_") >= 0 ||
    iconPath.indexOf("tx_bgls") >= 0 ||
    iconPath.indexOf("lxhs") >= 0 ||
    iconPath.indexOf("atv3") >= 0
  );
}

function IsEffectRewardIcon(iconPath) {
  if (!iconPath) {
    return false;
  }
  return (
    iconPath.indexOf("tx1") >= 0 ||
    iconPath.indexOf("tx_lzzq") >= 0 ||
    iconPath.indexOf("tx_xxhd") >= 0
  );
}

function IsWideCardRewardIcon(iconPath) {
  return IsTitleRewardIcon(iconPath);
}

function NormalizeRewardIconPath(iconPath) {
  if (!iconPath) {
    return iconPath;
  }
  // raw:// 与 file:// 一律原样使用，避免把热更新后的称号/特效图映射回旧图
  if (iconPath.indexOf("raw://") === 0 || iconPath.indexOf("file://") === 0) {
    return iconPath;
  }
  return iconPath;
}

function SetRewardItemIcon(item, iconPath) {
  if (!item || !iconPath) {
    return;
  }
  var icon = FindDirectChildByClass(item, "reward_item_icon");
  if (!icon) {
    return;
  }
  var path = NormalizeRewardIconPath(iconPath);
  icon.SetImage(path);
  icon.RemoveClass("reward_item_icon_title");
  icon.RemoveClass("reward_item_icon_attack");
  item.RemoveClass("reward_item_wide");
  if (IsTitleRewardIcon(path)) {
    if (icon.SetScaling) {
      icon.SetScaling("stretch-to-fit-preserve-aspect");
    }
    item.AddClass("reward_item_wide");
    icon.AddClass("reward_item_icon_title");
  } else {
    if (icon.SetScaling) {
      icon.SetScaling("stretch");
    }
  }
}

function GetRewardIconTipKey(iconPath) {
  if (!iconPath) {
    return null;
  }
  if (iconPath === REWARD_ICON_GOLD) {
    return "gold";
  }
  if (iconPath === REWARD_ICON_HERO || iconPath.indexOf("herocard") >= 0) {
    return "hero_pick";
  }
  if (iconPath === REWARD_ICON_ATTACK_PREMIUM) {
    return REWARD_TIP_PREMIUM_EFFECT || "attack_premium";
  }
  if (
    (iconPath && iconPath.indexOf("txz_lxhs") >= 0) ||
    (iconPath && iconPath.indexOf("lxhs") >= 0)
  ) {
    return REWARD_TIP_PREMIUM_EFFECT || "attack_premium";
  }
  if (IsTitleRewardIcon(iconPath)) {
    if (
      iconPath === REWARD_ICON_TITLE_PREMIUM ||
      (iconPath && iconPath.indexOf("ch_hsbh") >= 0) ||
      (iconPath && iconPath.indexOf("ch_wrnd") >= 0)
    ) {
      return REWARD_TIP_TITLE_PREMIUM || "title_premium";
    }
    if (iconPath === REWARD_ICON_TITLE_FREE) {
      return REWARD_TIP_TITLE_FREE || "title";
    }
    // 直接用文件名推断 tip key：ch_xxx.png -> title_xxx
    var m = iconPath.match(/ch_([a-z0-9]+)/i);
    if (m && m[1]) {
      return "title_" + m[1];
    }
    return REWARD_TIP_TITLE_FREE || "title";
  }
  if (IsEffectRewardIcon(iconPath)) {
    return REWARD_TIP_PREMIUM_EFFECT || "effect_premium";
  }
  return null;
}

function ApplyRewardItemTooltip(item, iconPath) {
  if (!item) {
    return;
  }
  var tipKey = GetRewardIconTipKey(iconPath);
  if (tipKey) {
    BindCardItemTooltip(item, tipKey);
  } else {
    ClearCardItemTooltip(item);
  }
}

function FindPremiumItem(premiumSlot, itemClass) {
  if (!premiumSlot) {
    return null;
  }
  return FindDirectChildByClass(premiumSlot, itemClass);
}

function FillPremiumItem(item, countText, state) {
  if (!item) {
    return;
  }
  var countLabel = FindDirectChildByClass(item, "reward_item_count");
  if (countLabel) {
    countLabel.text = countText;
    countLabel.visible = countText !== "";
  }
  var lockImg = FindDirectChildByClass(item, "reward_item_lock");
  var claimedLabel = FindDirectChildByClass(item, "reward_claimed_text");
  ApplyRewardSlotVisual(item, lockImg, claimedLabel, state);
}

function WireRewardClaimClick(itemPanel, level, track) {
  if (!itemPanel) {
    return;
  }
  itemPanel.hittest = true;
  itemPanel.SetPanelEvent("onactivate", function () {
    TryClaimCardReward(level, track);
  });
}

function TryClaimCardReward(level, track) {
  var lv = parseInt(level, 10);
  if (isNaN(lv) || lv < 1) {
    return;
  }
  if (track !== "free" && track !== "premium") {
    return;
  }
  var card = battlePassCard;
  var currentLevel = GetCardLevel(card);
  var claimedLevel =
    track === "premium"
      ? CardNum(card, "get_level_premium")
      : CardNum(card, "get_level");
  var forceLocked = track === "premium" && !IsPremiumActive(card);
  var state = GetRewardSlotState(
    currentLevel,
    lv,
    claimedLevel,
    forceLocked
  );
  if (state !== "claimable") {
    return;
  }
  ClickGetReward();
}

function SetRewardItemCounts(col, freeCount, premiumCount) {
  var freeCountLabel = col.FindChildTraverse("reward_free_count");
  if (freeCountLabel) {
    freeCountLabel.text = freeCount;
    freeCountLabel.visible = freeCount !== "";
  }
}

function FillRewardCol(col, level, card) {
  var levelLabel = col.FindChildTraverse("reward_col_level_text");
  if (levelLabel) {
    levelLabel.text = "" + level;
  }
  SetRewardItemCounts(col, GetFreeRewardCount(level), GetPremiumRewardCount(level));

  var premiumCount = GetPremiumRewardCount(level);
  var currentLevel = GetCardLevel(card);
  var freeClaimedLevel = CardNum(card, "get_level");
  var premiumClaimedLevel = CardNum(card, "get_level_premium");
  var premiumActive = IsPremiumActive(card);

  var freeSlot = FindDirectChildByClass(col, "reward_col_free");
  var premiumSlot = FindDirectChildByClass(col, "reward_col_premium");
  var freeItem = freeSlot
    ? FindDirectChildByClass(freeSlot, "reward_item")
    : null;
  var freeLock = freeItem
    ? FindDirectChildByClass(freeItem, "reward_item_lock")
    : null;
  var freeClaimedText = freeItem
    ? FindDirectChildByClass(freeItem, "reward_claimed_text")
    : null;

  var freeState = GetRewardSlotState(
    currentLevel,
    level,
    freeClaimedLevel,
    false
  );
  var premiumState = GetRewardSlotState(
    currentLevel,
    level,
    premiumClaimedLevel,
    !premiumActive
  );

  ApplyRewardSlotVisual(freeSlot, null, null, freeState);
  if (freeItem) {
    var freeIcon = GetFreeRewardIcon(level);
    SetRewardItemIcon(freeItem, freeIcon);
    ApplyRewardItemTooltip(freeItem, freeIcon);
    if (freeLock) {
      freeLock.visible = freeState === "locked";
    }
    if (freeClaimedText) {
      freeClaimedText.visible = freeState === "claimed";
    }
  }

  if (freeSlot) {
    WireRewardClaimClick(freeItem, level, "free");
  }

  if (premiumSlot) {
    var dualPremium = HasPremiumExtraReward(level);
    premiumSlot.RemoveClass("reward_premium_single");
    premiumSlot.RemoveClass("reward_premium_dual");
    premiumSlot.AddClass(
      dualPremium ? "reward_premium_dual" : "reward_premium_single"
    );
    var item1 = FindPremiumItem(premiumSlot, "reward_premium_item_1");
    var item2 = FindPremiumItem(premiumSlot, "reward_premium_item_2");
    FillPremiumItem(item1, premiumCount, premiumState);
    var premIcon1 = GetPremiumPrimaryRewardIcon(level);
    SetRewardItemIcon(item1, premIcon1);
    ApplyRewardItemTooltip(item1, premIcon1);
    if (dualPremium) {
      FillPremiumItem(item2, "1", premiumState);
      SetRewardItemIcon(item2, REWARD_ICON_HERO);
      ApplyRewardItemTooltip(item2, REWARD_ICON_HERO);
      if (item2) {
        item2.visible = true;
      }
    } else if (item2) {
      item2.visible = false;
    }
    var premItem1 = FindPremiumItem(premiumSlot, "reward_premium_item_1");
    var premItem2 = FindPremiumItem(premiumSlot, "reward_premium_item_2");
    WireRewardClaimClick(premItem1, level, "premium");
    if (dualPremium) {
      WireRewardClaimClick(premItem2, level, "premium");
    }
  }
}

function UpdateAllRewardCols(card) {
  rewardOverlayLevel = ResolveRewardOverlayLevel(card, displayPhaseIndex);
  for (var lv = rewardScrollStart; lv <= rewardScrollEnd; lv++) {
    if (ShouldSkipScrollRewardLevel(lv, card)) {
      continue;
    }
    var col = FindRewardCol(lv);
    if (col) {
      FillRewardCol(col, lv, card);
    }
  }
  var overlayCol = GetPanel("reward_overlay_col");
  if (overlayCol) {
    FillRewardCol(overlayCol, rewardOverlayLevel, card);
  }
}

function BuildRewardList(scrollMode) {
  var row = GetPanel("reward_list_row");
  if (!row) {
    return;
  }
  ApplyPhaseDisplayRange(displayPhaseIndex, battlePassCard);
  row.RemoveAndDeleteChildren();
  for (var lv = rewardScrollStart; lv <= rewardScrollEnd; lv++) {
    if (ShouldSkipScrollRewardLevel(lv, battlePassCard)) {
      continue;
    }
    var col = NewPanel(row, "reward_col_" + lv, "Panel");
    col.BLoadLayoutSnippet("reward_col");
    FillRewardCol(col, lv, battlePassCard);
  }
  UpdateRewardRowWidth();
  ScheduleRewardScrollApply(scrollMode);
}

function BuildOverlayCol() {
  var layer = GetPanel("reward_overlay_layer");
  if (!layer) {
    return;
  }
  layer.visible = true;
  layer.RemoveAndDeleteChildren();
  rewardOverlayLevel = ResolveRewardOverlayLevel(
    battlePassCard,
    displayPhaseIndex
  );
  var col = NewPanel(layer, "reward_overlay_col", "Panel");
  col.BLoadLayoutSnippet("reward_col");
  FillRewardCol(col, rewardOverlayLevel, battlePassCard);
}

var buyLevelCount = 1;
var BUY_LEVEL_MIN = 1;
var BUY_LEVEL_PRICE_YUAN = 5;

function GetBuyLevelMax(card) {
  var rem = CARD_MAX_LEVEL - GetCardLevel(card);
  if (rem < 0) {
    rem = 0;
  }
  return rem;
}

function UpdateBuyLevelSliderMax() {
  var maxVal = GetBuyLevelMax(battlePassCard);
  var maxLabel = GetPanel("buy_level_max");
  if (maxLabel) {
    maxLabel.text = "" + (maxVal > 0 ? maxVal : CARD_MAX_LEVEL);
  }
  var slider = GetPanel("buy_level_slider");
  if (slider) {
    slider.min = BUY_LEVEL_MIN;
    slider.max = maxVal > 0 ? maxVal : BUY_LEVEL_MIN;
    if (slider.value > slider.max) {
      slider.value = slider.max;
    }
  }
  if (maxVal > 0 && buyLevelCount > maxVal) {
    SetBuyLevelCount(maxVal);
  }
}

function UpdateBuyLevelModalPrice() {
  var hint = GetPanel("buy_level_hint");
  var price = GetPanel("buy_level_price");
  if (hint) {
    hint.text = "购买" + buyLevelCount + "级所需";
  }
  if (price) {
    price.text = "¥" + buyLevelCount * BUY_LEVEL_PRICE_YUAN;
  }
}

function SetBuyLevelCount(n, skipSlider) {
  var maxVal = GetBuyLevelMax(battlePassCard);
  if (maxVal <= 0) {
    maxVal = BUY_LEVEL_MIN;
  }
  var val = parseInt(n, 10);
  if (isNaN(val)) {
    val = BUY_LEVEL_MIN;
  }
  if (val < BUY_LEVEL_MIN) {
    val = BUY_LEVEL_MIN;
  }
  if (val > maxVal) {
    val = maxVal;
  }
  buyLevelCount = val;
  if (!skipSlider) {
    var slider = GetPanel("buy_level_slider");
    if (slider && slider.value !== val) {
      slider.value = val;
    }
  }
  UpdateBuyLevelModalPrice();
}

function OpenBuyLevelModal() {
  var maxVal = GetBuyLevelMax(battlePassCard);
  if (maxVal <= 0) {
    SendServer("Lua_Shop", { data: { tp: "PayCardLevel", text: 0 } });
    return;
  }
  UpdateBuyLevelSliderMax();
  SetBuyLevelCount(BUY_LEVEL_MIN);
  var overlay = GetPanel("buy_level_overlay");
  if (overlay) {
    overlay.RemoveClass("buy_level_overlay_hidden");
    overlay.hittest = true;
  }
}

function CloseBuyLevelModal() {
  var overlay = GetPanel("buy_level_overlay");
  if (overlay) {
    overlay.AddClass("buy_level_overlay_hidden");
    overlay.hittest = false;
  }
}

function BuyLevelStep(delta) {
  SetBuyLevelCount(buyLevelCount + delta);
}

function ConfirmBuyLevel() {
  var count = buyLevelCount;
  CloseBuyLevelModal();
  SendServer("Lua_Shop", { data: { tp: "PayCardLevel", text: count } });
}

function InitBuyLevelSlider() {
  var slider = GetPanel("buy_level_slider");
  if (!slider) {
    return;
  }
  slider.min = BUY_LEVEL_MIN;
  slider.max = CARD_MAX_LEVEL;
  slider.value = BUY_LEVEL_MIN;
  slider.SetPanelEvent("onvaluechanged", function () {
    SetBuyLevelCount(slider.value, true);
  });
}

function ClickBuyLevel() {
  OpenBuyLevelModal();
}

function IsBuyLevelModalOpen() {
  var overlay = GetPanel("buy_level_overlay");
  return overlay && !overlay.BHasClass("buy_level_overlay_hidden");
}

function UpdateBuyCardButton(card) {
  var btn = GetPanel("btn_buy_card");
  if (btn) {
    btn.visible = !IsPremiumActive(card);
  }
  var lockedText = GetPanel("card_track_premium_locked_text");
  if (lockedText) {
    lockedText.visible = !IsPremiumActive(card);
  }
}

function ClickBuyCard() {
  if (IsPremiumActive(battlePassCard)) {
    return;
  }
  SendServer("Lua_Shop", { data: { tp: "Pay", text: 9 } });
}

function HasAnyClaimableReward(card) {
  if (!card) {
    return false;
  }
  var currentLevel = GetCardLevel(card);
  var freeClaimed = CardNum(card, "get_level");
  var premiumClaimed = CardNum(card, "get_level_premium");
  if (currentLevel > freeClaimed) {
    return true;
  }
  return IsPremiumActive(card) && currentLevel > premiumClaimed;
}

function ClickGetReward() {
  if (!HasAnyClaimableReward(battlePassCard)) {
    return;
  }
  SendServer("Lua_Shop", { data: { tp: "ClaimAllCardRewards" } });
}

// 与 Shop.CardTaskData 顺序一致
var CARD_TASK_DAILY = [
  { desc: "登录丛林激战", xp: 50, target: 1, claimKey: "taskday1", key: "login" },
  { desc: "完成一局任意模式游戏", xp: 50, target: 1, claimKey: "taskday2", countKey: "daygamecount" },
  { desc: "完成三局任意模式游戏", xp: 100, target: 3, claimKey: "taskday3", countKey: "daygamecount" },
  { desc: "任意模式游戏获取队伍第一名", xp: 200, target: 1, claimKey: "taskday4", countKey: "daytop1count" },
  { desc: "任意模式游戏累计杀敌100人", xp: 200, target: 100, claimKey: "taskday5", countKey: "daykillcount" },
  { desc: "任意模式游戏累计杀敌200人", xp: 500, target: 200, claimKey: "taskday6", countKey: "daykillcount" },
];

var CARD_TASK_WEEKLY = [
  { desc: "任意模式游戏累计获取队伍第一名二次", xp: 500, target: 2, claimKey: "taskweed1", countKey: "weektop1count" },
  { desc: "任意模式游戏累计获取队伍第一名四次", xp: 500, target: 4, claimKey: "taskweed2", countKey: "weektop1count" },
  { desc: "任意模式游戏累计获取队伍第一名八次", xp: 500, target: 8, claimKey: "taskweed3", countKey: "weektop1count" },
  { desc: "任意模式游戏累计杀敌500人", xp: 1000, target: 500, claimKey: "taskweed4", countKey: "weekkillcount" },
  { desc: "任意模式游戏累计杀敌1000人", xp: 1000, target: 1000, claimKey: "taskweed5", countKey: "weekkillcount" },
  { desc: "任意模式游戏累计杀敌2000人", xp: 2000, target: 2000, claimKey: "taskweed6", countKey: "weekkillcount" },
];

function CardNum(card, key) {
  if (!card || key == null || card[key] == null) {
    return 0;
  }
  return parseInt(card[key], 10) || 0;
}

function BuildTaskItem(def, card) {
  var target = def.target != null ? def.target : 1;
  var count = 0;
  if (def.key === "login") {
    count = CardNum(card, def.claimKey) >= 1 ? 1 : 0;
  } else if (def.countKey) {
    count = CardNum(card, def.countKey);
  }
  var done = false;
  if (def.claimKey) {
    done = CardNum(card, def.claimKey) >= 1;
  } else {
    done = count >= target;
  }
  var showCount = done ? target : Math.min(count, target);
  return {
    desc: def.desc,
    progress: showCount + "/" + target,
    xp: def.xp,
    done: done,
  };
}

function BuildTasksFromDefs(defs, card) {
  var tasks = [];
  for (var i = 0; i < defs.length; i++) {
    tasks.push(BuildTaskItem(defs[i], card || {}));
  }
  return tasks;
}

function FormatTaskDesc(task) {
  var text = task.desc || "";
  if (task.progress != null && task.progress !== "") {
    text += "(" + task.progress + ")";
  }
  return text;
}

function FillTaskRow(row, task) {
  if (!row || !task) {
    return;
  }
  var descLabel = row.FindChildTraverse("task_desc");
  var xpLabel = row.FindChildTraverse("task_reward_xp");
  var statusBtn = row.FindChildTraverse("task_status_btn");
  var statusText = row.FindChildTraverse("task_status_text");
  if (descLabel) {
    descLabel.text = FormatTaskDesc(task);
  }
  if (xpLabel) {
    xpLabel.text = "" + (task.xp != null ? task.xp : "");
  }
  if (statusText) {
    statusText.text = task.done ? "已完成" : "未完成";
  }
  if (statusBtn) {
    if (task.done) {
      statusBtn.AddClass("done");
    } else {
      statusBtn.RemoveClass("done");
    }
  }
}

function BuildTaskColumn(listId, tasks) {
  var list = GetPanel(listId);
  if (!list) {
    return;
  }
  list.RemoveAndDeleteChildren();
  for (var i = 0; i < 6; i++) {
    var task = tasks[i];
    if (!task) {
      continue;
    }
    var row = NewPanel(list, listId + "_row_" + i, "Panel");
    row.BLoadLayoutSnippet("task_row");
    FillTaskRow(row, task);
  }
}

function BuildTaskList(card) {
  var daily = BuildTasksFromDefs(CARD_TASK_DAILY, card);
  var weekly = BuildTasksFromDefs(CARD_TASK_WEEKLY, card);
  BuildTaskColumn("task_daily_list", daily);
  BuildTaskColumn("task_weekly_list", weekly);
}

function UpdateBattlePassUI(data) {
  if (!data) {
    return;
  }
  if (data.itemList) {
    battlePassItemList = data.itemList;
  }
  var cosmeticsChanged = false;
  var cosmetics = ResolvePassCosmeticsFromData(data);
  if (cosmetics) {
    cosmeticsChanged = !!ApplyPassCosmetics(cosmetics);
    UpdateDeadlineLabel(cosmetics);
  }
  var cardChanged = false;
  if (data.card) {
    cardChanged = !CardsLookEqual(battlePassCard, data.card);
    battlePassCard = data.card;
  }
  var card = battlePassCard;
  if (card) {
    UpdateRewardTop(card);
    var pinnedOverlay = IsOverlayPinnedToMilestone(card);
    var needRebuild = ApplyRewardPreviewRange(card);
    if (!needRebuild) {
      needRebuild = SyncDisplayPhase(card);
    }
    if (card.__overlayPinnedMilestone !== pinnedOverlay) {
      needRebuild = true;
    }
    card.__overlayPinnedMilestone = pinnedOverlay;
    // 仅等级/领取/赛季图标真正变化时整表重建，避免每次打开闪一下空 1 级
    if (needRebuild || cosmeticsChanged || cardChanged) {
      RebuildRewardListView();
    } else {
      UpdateAllRewardCols(card);
    }
    UpdateBuyCardButton(card);
    BuildTaskList(card);
    if (IsBuyLevelModalOpen()) {
      UpdateBuyLevelSliderMax();
    }
    SetPageVisible(true);
  } else if (cosmetics) {
    UpdateDeadlineLabel(cosmetics);
  }
}

/** 判断两次 card 推送是否实质相同（避免无意义重建） */
function CardsLookEqual(a, b) {
  if (!a || !b) {
    return false;
  }
  if (
    String(a.exp) !== String(b.exp) ||
    String(a.state) !== String(b.state) ||
    String(a.get_level) !== String(b.get_level) ||
    String(a.get_level_premium) !== String(b.get_level_premium)
  ) {
    return false;
  }
  // 任务进度变化只需刷新任务列，不强制整表重建奖励
  return true;
}

function SetPageVisible(page) {
  GetRoot().style.opacity = page ? "1" : "0";
}

function GetData(data) {
  if (!data) {
    return;
  }
  // 缓存到全局，下次切回通行证页可立刻用真实 card 渲染，避免空 1 级闪烁
  if (GameUI.CustomUIConfig) {
    GameUI.CustomUIConfig.AllShopData = data;
  }
  if (data.page) {
    SetPageVisible(true);
  }
  UpdateBattlePassUI(data);
}

function Click_Hide_Page() {
  GetRoot().style.opacity = "0";
}

function SeedBattlePassFromShopCache() {
  var cfg = GameUI.CustomUIConfig;
  if (!cfg) {
    return false;
  }
  var cached = cfg.AllShopData;
  if (!cached && typeof cfg === "function") {
    try {
      cached = cfg().AllShopData;
    } catch (e) {
      cached = null;
    }
  }
  if (!cached) {
    return false;
  }
  if (cached.itemList) {
    battlePassItemList = cached.itemList;
  }
  var cos = ResolvePassCosmeticsFromData(cached);
  if (cos) {
    ApplyPassCosmetics(cos);
    UpdateDeadlineLabel(cos);
  }
  if (cached.card) {
    battlePassCard = cached.card;
    return true;
  }
  return false;
}

(function () {
  var hasCache = SeedBattlePassFromShopCache();
  // 有缓存则立刻画真实等级；无缓存先隐藏，等 UI_Shop 再显示，避免空 1 级闪一下
  if (hasCache) {
    SetPageVisible(true);
    BuildRewardList("default");
    BuildOverlayCol();
    UpdateRewardTop(battlePassCard);
    UpdateBuyCardButton(battlePassCard);
    BuildTaskList(battlePassCard);
  } else {
    SetPageVisible(false);
    BuildOverlayCol();
    UpdateBuyCardButton(null);
    BuildTaskList(null);
  }
  InitRewardScrollListener();
  InitBuyLevelSlider();
  InitData();
  // 父页 public.js 已发 OpenBattlePass，这里不再重复 OpenPage，减少空窗期推送
  SubEvent("UI_Shop", GetData);
  SubEvent("UI_PassSeason", OnPassSeasonEvent);
  ReadPassSeasonNetTable();
  if (
    typeof CustomNetTables !== "undefined" &&
    CustomNetTables.SubscribeNetTableListener
  ) {
    CustomNetTables.SubscribeNetTableListener("clrb_pass_season", function () {
      ReadPassSeasonNetTable();
    });
  }
  $.Schedule(2.0, ReadPassSeasonNetTable);
  $.Schedule(5.0, ReadPassSeasonNetTable);
  if (GameUI.CustomUIConfig) {
    GameUI.CustomUIConfig().Click_Hide_Page = Click_Hide_Page;
  }
})();