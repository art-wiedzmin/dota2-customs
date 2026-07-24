--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function ApplyCardTipBgClass(bgPanel, bgName) {
  if (!bgPanel) {
    return;
  }
  bgPanel.RemoveClass("card_tip_bg_race1");
  bgPanel.RemoveClass("card_tip_bg_race2");
  bgPanel.RemoveClass("card_tip_bg_race3");
  bgPanel.AddClass("card_tip_bg_" + (bgName || "race3"));
}

function UpdateCardTip() {
  var root = GetRoot();
  var key = root.GetAttributeString("key", "gold");
  var meta = GetCardTipMeta(key) || CARD_TIP_META.gold;
  ApplyCardTipBgClass(GetPanel("card_tip_bg"), meta.bg);
  var titleLabel = GetPanel("card_tip_title");
  var textLabel = GetPanel("card_tip_text");
  if (titleLabel) {
    titleLabel.text = meta.name || "";
  }
  if (textLabel) {
    textLabel.text = meta.text || "";
  }
}

(function () {})();