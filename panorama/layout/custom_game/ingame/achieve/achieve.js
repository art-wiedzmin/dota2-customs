var clrbAchieveCurrentTab = "hero";
var clrbAchieveListData = null;

function AchieveOpenPage() {
  var publicPanel = $("#Public");
  if (publicPanel) {
    publicPanel.style.opacity = "0";
  }
  GetRoot().style.opacity = "1";
  AchieveRefreshView();
  AchieveRefreshMenuRedDot();
  SendServer("Lua_Achieve", { data: { tp: "OpenPage" } });
}

function AchieveClosePage() {
  GetRoot().style.opacity = "0";
  SendServer("Lua_Achieve", { data: { tp: "ClosePage" } });
}

function AchieveSwitchTab(tabKey) {
  if (clrbAchieveCurrentTab === tabKey) {
    return;
  }
  if (BtnLimiter(GetPanel("achieve_tab_" + tabKey), 0.25)) {
    return;
  }
  clrbAchieveCurrentTab = tabKey;
  AchieveUpdateTabActive(tabKey);
  AchieveRefreshView();
  SendServer("Lua_Achieve", { data: { tp: "SwitchTab", tab: tabKey } });
}

function AchieveUpdateTabActive(tabKey) {
  var tabs = ["hero", "daily", "recharge"];
  for (var i = 0; i < tabs.length; i++) {
    var key = tabs[i];
    var panel = GetPanel("achieve_tab_" + key);
    if (!panel) {
      continue;
    }
    if (key === tabKey) {
      panel.AddClass("active");
    } else {
      panel.RemoveClass("active");
    }
  }
}

function AchieveGetClaimLabel(status, item) {
  if (item && item.repeatable) {
    if (status === "claimable") {
      return "领取";
    }
    return "未完成";
  }
  if (status === "claimable") {
    return "领取";
  }
  if (status === "claimed") {
    return "已领取";
  }
  return "未完成";
}

function AchieveApplyClaimButton(cardPanel, status, achieveId, item) {
  var btn = cardPanel.FindChildTraverse("achieve_claim_btn");
  var label = cardPanel.FindChildTraverse("achieve_claim_text");
  if (!btn || !label) {
    return;
  }
  btn.RemoveClass("locked");
  btn.RemoveClass("claimable");
  btn.RemoveClass("claimed");
  if (item && item.repeatable) {
    btn.AddClass(status === "claimable" ? "claimable" : "locked");
  } else {
    btn.AddClass(status);
  }
  label.text = AchieveGetClaimLabel(status, item);
  btn.SetPanelEvent("onactivate", function () {});
  if (status === "claimable") {
    btn.SetPanelEvent("onactivate", function () {
      if (BtnLimiter(btn, 0.45)) {
        return;
      }
      AchieveOnClaimClick(achieveId);
    });
  }
}

function AchieveFormatRewardAmount(reward) {
  if (!reward) {
    return "";
  }
  var amount = Number(reward.amount);
  if (!Number.isFinite(amount) || amount <= 0) {
    return "";
  }
  if (reward.kind === "pet") {
    return "";
  }
  return String(amount);
}

function AchieveApplyRewardIcon(icon, reward) {
  if (!icon) {
    return;
  }
  icon.SetImage(reward.icon || CLRB_ACHIEVE_DEFAULT_REWARD_ICON);
  if (reward.kind === "gold") {
    icon.AddClass("achieve_reward_icon_gold");
  } else {
    icon.RemoveClass("achieve_reward_icon_gold");
  }
  if (icon.SetScaling) {
    icon.SetScaling("stretch-to-fit-preserve-aspect");
  }
}

function AchieveApplyRewardIcon(icon, reward) {
  if (!icon) {
    return;
  }
  icon.SetImage(reward.icon || CLRB_ACHIEVE_DEFAULT_REWARD_ICON);
  if (reward.kind === "gold") {
    icon.AddClass("achieve_reward_icon_gold");
  } else {
    icon.RemoveClass("achieve_reward_icon_gold");
  }
  if (icon.SetScaling) {
    icon.SetScaling("stretch-to-fit-preserve-aspect");
  }
}

/** 与背包 / 战令一致：reward.kind → cardtip 键名 */
function AchieveGetRewardTipKey(reward) {
  if (!reward) {
    return null;
  }
  if (reward.tipKey && GetCardTipMeta(reward.tipKey)) {
    return reward.tipKey;
  }
  if (reward.kind === "gold") {
    return "gold";
  }
  if (reward.kind === "hero_pick") {
    return "hero_pick";
  }
  if (reward.kind === "pet") {
    return reward.tipKey || "pet_ti10_rosh";
  }
  if (reward.kind === "prophecy_card") {
    return "prophecy_card";
  }
  if (reward.kind === "title") {
    return reward.tipKey || null;
  }
  return null;
}

function AchieveBindRewardTooltip(slot, reward) {
  if (!slot) {
    return;
  }
  var tipKey = AchieveGetRewardTipKey(reward);
  if (!tipKey || !GetCardTipMeta(tipKey)) {
    ClearCardItemTooltip(slot);
    slot.__achieveTipKey = null;
    slot.SetPanelEvent("onmouseover", function () {});
    slot.SetPanelEvent("onmouseout", function () {});
    return;
  }
  if (slot.__achieveTipKey === tipKey) {
    return;
  }
  slot.__achieveTipKey = tipKey;
  /* 不用 BindCardItemTooltip：其 tooltipPosition=right 会导致图标左移 */
  WhenOver(slot, function () {
    $.DispatchEvent(
      "UIShowCustomLayoutParametersTooltip",
      slot,
      CARD_TIP_ID,
      CARD_TIP_LAYOUT,
      "key=" + tipKey
    );
  });
  WhenOut(slot, function () {
    $.DispatchEvent("UIHideCustomLayoutTooltip", CARD_TIP_ID);
  });
}

function AchieveBindRewards(cardPanel, item) {
  var row = cardPanel.FindChildTraverse("achieve_rewards_row");
  if (!row) {
    return;
  }
  row.RemoveAndDeleteChildren();

  var rewards = item.rewards;
  if (!rewards || rewards.length === 0) {
    rewards = [
      {
        kind: "gold",
        icon: item.rewardIcon || CLRB_ACHIEVE_DEFAULT_REWARD_ICON,
        amount: item.rewardAmount,
      },
    ];
  }

  var spacer = NewPanel(row, "achieve_rewards_spacer", "Panel");
  spacer.AddClass("achieve_rewards_spacer");
  spacer.hittest = false;

  /* 从右往左排：先插入 spacer 把图标顶到右侧，再逆序创建（数组第一项最靠右/贴近领取按钮） */
  for (var i = rewards.length - 1; i >= 0; i--) {
    var reward = rewards[i];
    var slot = NewPanel(row, "achieve_reward_slot_" + i, "Panel");
    slot.AddClass("achieve_reward_slot");
    slot.hittest = true;
    var icon = NewPanel(slot, "achieve_reward_icon_" + i, "Image");
    icon.AddClass("achieve_reward_icon");
    icon.hittest = false;
    AchieveApplyRewardIcon(icon, reward);
    var amountLab = NewPanel(slot, "achieve_reward_amount_" + i, "Label");
    amountLab.AddClass("achieve_reward_amount");
    amountLab.hittest = false;
    amountLab.text = AchieveFormatRewardAmount(reward);
    AchieveBindRewardTooltip(slot, reward);
  }
}

function AchieveBindCard(cardPanel, item) {
  if (!cardPanel || !item) {
    return;
  }
  var status = ClrbAchieveResolveStatus(item);
  var nameLab = cardPanel.FindChildTraverse("achieve_name");
  var countLab = cardPanel.FindChildTraverse("achieve_claim_count");
  var progressLab = cardPanel.FindChildTraverse("achieve_progress");
  if (nameLab) {
    nameLab.text = item.name || "";
  }
  if (countLab) {
    if (item.repeatable) {
      var times = Math.max(0, Math.floor(Number(item.claimCount) || 0));
      countLab.text = "已完成" + times + "次";
      countLab.RemoveClass("hidden");
    } else {
      countLab.text = "";
      countLab.AddClass("hidden");
    }
  }
  if (progressLab) {
    progressLab.text = ClrbAchieveFormatProgressText(item.current, item.target);
  }
  AchieveBindRewards(cardPanel, item);
  AchieveApplyClaimButton(cardPanel, status, item.id, item);
}

function AchieveRenderList(list) {
  var container = GetPanel("achieve_list_container");
  if (!container) {
    return;
  }
  container.RemoveAndDeleteChildren();
  if (!list || list.length <= 0) {
    return;
  }
  var rowPanel = null;
  for (var i = 0; i < list.length; i++) {
    if (i % 2 === 0) {
      rowPanel = NewPanel(container, "achieve_row_" + Math.floor(i / 2), "Panel");
      rowPanel.AddClass("achieve_row");
    }
    var card = NewPanel(rowPanel, "achieve_card_" + i, "Panel");
    card.BLoadLayoutSnippet("achieve_card_snippet");
    AchieveBindCard(card, list[i]);
  }
}

function AchieveApplyFromServerData(data) {
  if (!data) {
    return;
  }
  var recharge = Math.max(0, Number(data.recharge_total) || 0);
  var cfg = GameUI.CustomUIConfig();
  cfg.clrb_achieve_recharge_total = recharge;

  if (data.enabled && data.achieve) {
    cfg.clrb_achieve_payload = data.achieve;
    cfg.clrb_achieve_enabled = true;
    clrbAchieveListData = ClrbAchieveBuildListFromServer(data.achieve, recharge);
  } else {
    cfg.clrb_achieve_payload = null;
    cfg.clrb_achieve_enabled = false;
    clrbAchieveListData = ClrbAchieveCloneMockList();
    if (recharge > 0) {
      clrbAchieveListData.recharge = ClrbAchieveBuildRechargeList({}, recharge);
    }
  }
}

function AchieveTryLoadCachedServerData() {
  var cfg = GameUI.CustomUIConfig();
  if (!cfg || !cfg.clrb_achieve_payload) {
    if (cfg && cfg.clrb_achieve_recharge_total > 0) {
      var mock = ClrbAchieveCloneMockList();
      mock.recharge = ClrbAchieveBuildRechargeList(
        {},
        cfg.clrb_achieve_recharge_total
      );
      return mock;
    }
    return null;
  }
  return ClrbAchieveBuildListFromServer(
    cfg.clrb_achieve_payload,
    cfg.clrb_achieve_recharge_total
  );
}

function AchieveGetCurrentList() {
  if (!clrbAchieveListData) {
    clrbAchieveListData =
      AchieveTryLoadCachedServerData() || ClrbAchieveCloneMockList();
  }
  return clrbAchieveListData[clrbAchieveCurrentTab] || [];
}

function AchieveRefreshView() {
  AchieveRenderList(
    ClrbAchieveSortListForDisplay(AchieveGetCurrentList())
  );
}

function AchieveOnClaimClick(achieveId) {
  if (!achieveId || !clrbAchieveListData) {
    return;
  }
  var list = clrbAchieveListData[clrbAchieveCurrentTab];
  if (!list) {
    return;
  }
  for (var i = 0; i < list.length; i++) {
    if (list[i].id !== achieveId) {
      continue;
    }
    if (list[i].status !== "claimable") {
      return;
    }
    SendServer("Lua_Achieve", {
      data: {
        tp: "Claim",
        tab: clrbAchieveCurrentTab,
        id: achieveId,
      },
    });
    return;
  }
}

function AchieveRefreshMenuRedDot() {
  var cfg = GameUI.CustomUIConfig();
  if (!cfg || !cfg.Menu_SetAchieveRedDot) {
    return;
  }
  var listData = clrbAchieveListData;
  if (!listData && cfg.clrb_achieve_payload) {
    listData = ClrbAchieveBuildListFromServer(
      cfg.clrb_achieve_payload,
      cfg.clrb_achieve_recharge_total || 0
    );
  }
  if (!listData) {
    listData = AchieveTryLoadCachedServerData();
  }
  cfg.Menu_SetAchieveRedDot(ClrbAchieveHasAnyClaimable(listData));
}

function AchieveOnServerData(data) {
  if (!data) {
    return;
  }
  if (data.page !== undefined && data.page !== null) {
    GetRoot().style.opacity = String(data.page);
  }
  if (data.tab) {
    clrbAchieveCurrentTab = data.tab;
    AchieveUpdateTabActive(data.tab);
  }
  if (data.achieve !== undefined || data.enabled !== undefined) {
    AchieveApplyFromServerData(data);
  } else if (data.list) {
    if (!clrbAchieveListData) {
      clrbAchieveListData = ClrbAchieveCloneMockList();
    }
    clrbAchieveListData[clrbAchieveCurrentTab] = data.list;
  }
  AchieveRefreshView();
  var cfg = GameUI.CustomUIConfig();
  if (data.has_claimable !== undefined && data.has_claimable !== null) {
    if (cfg && cfg.Menu_SetAchieveRedDot) {
      cfg.Menu_SetAchieveRedDot(
        data.has_claimable === true || data.has_claimable === 1
      );
    }
  } else {
    AchieveRefreshMenuRedDot();
  }
}

(function () {
  clrbAchieveListData =
    AchieveTryLoadCachedServerData() || ClrbAchieveCloneMockList();
  AchieveUpdateTabActive(clrbAchieveCurrentTab);
  GameUI.CustomUIConfig().Achieve_OpenPage = AchieveOpenPage;
  GameUI.CustomUIConfig().Achieve_ClosePage = AchieveClosePage;
  GameUI.CustomUIConfig().Achieve_RefreshMenuRedDot = AchieveRefreshMenuRedDot;
  SubEvent("UI_Achieve", AchieveOnServerData);
  $.Schedule(0, AchieveRefreshMenuRedDot);
  $.Schedule(1.0, function () {
    SendServer("Lua_Achieve", { data: { tp: "Sync" } });
  });
})();
