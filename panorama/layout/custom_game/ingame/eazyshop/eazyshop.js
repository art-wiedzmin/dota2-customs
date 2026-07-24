--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


// 列表重建后旧行会被删掉，已安排的 mouseout 延时仍可能触发，用代际号作废旧回调
var eazyShopGoodsListGeneration = 0;

/** 贴右侧：正值 translateX 把面板藏到屏幕右外，与 HeroCard 的负值对称 */
var EAZY_SHOP_SLIDE_X_HIDDEN = 380;
var EAZY_SHOP_ANIM_SHOW_SEC = "0.16s";
var EAZY_SHOP_ANIM_HIDE_SEC = "0.14s";
var eazyShopHideVisibleSeq = 0;
/** 上次 UI 数据里商店是否为打开；用于避免购买后 SendData 重复触发展开动画 */
var eazyShopLastPageOpen = null;
/** 刚执行展开动画后短时间内忽略 SnapVisible，避免连续两次 page:true 把滑入动画顶掉 */
var eazyShopJustStartedShowAnim = false;
var eazyShopShowAnimGuardSchedule = null;
/** 因游戏内原生商店打开而临时隐藏便捷商店（不改变 Lua 侧 page，关闭原生商店后可恢复） */
var eazyShopHiddenByHudShop = false;

function InitData() {
  var tp = "init";
  SendServer("Lua_EazyShop", { data: { tp: tp } });
}

function GoodsToArray(goods) {
  if (!goods) {
    return [];
  }
  if (Array.isArray(goods)) {
    return goods;
  }
  var arr = [];
  $.Each(goods, function (v, k) {
    arr.push({ k: k, v: v });
  });
  arr.sort(function (a, b) {
    return Number(a.k) - Number(b.k);
  });
  var out = [];
  for (var i = 0; i < arr.length; i++) {
    out.push(arr[i].v);
  }
  return out;
}

function BuyGoods(id) {
  if (!id) {
    return;
  }
  var tp = "Buy";
  SendServer("Lua_EazyShop", { data: { tp: tp, text: id } });
}

// 仅图标命中区悬停出 tip；整卡高亮由 EazyShop.css 的 .eazy_goods_row:hover 负责
function BindEazyGoodsItemTooltip(hitPanel, itemName, listGen) {
  if (!hitPanel || !itemName) {
    return;
  }
  var hideTimer = null;
  function clearHideTimer() {
    if (hideTimer != null) {
      $.CancelScheduled(hideTimer);
      hideTimer = null;
    }
  }
  function hitOk() {
    return hitPanel && hitPanel.IsValid && hitPanel.IsValid();
  }
  function showTip() {
    clearHideTimer();
    if (!hitOk()) {
      return;
    }
    if (listGen !== eazyShopGoodsListGeneration) {
      return;
    }
    $.DispatchEvent("DOTAShowAbilityTooltip", hitPanel, itemName);
  }
  function scheduleHideTip() {
    clearHideTimer();
    var savedGen = listGen;
    hideTimer = $.Schedule(0.08, function () {
      hideTimer = null;
      if (savedGen !== eazyShopGoodsListGeneration) {
        return;
      }
      if (!hitOk()) {
        return;
      }
      $.DispatchEvent("DOTAHideAbilityTooltip", hitPanel);
    });
  }
  hitPanel.SetPanelEvent("onmouseover", showTip);
  hitPanel.SetPanelEvent("onmouseout", scheduleHideTip);
}

function RebuildGoodsList(data) {
  var list = GetPanel("goods_list");
  if (!list) {
    return;
  }
  eazyShopGoodsListGeneration++;
  var listGen = eazyShopGoodsListGeneration;
  list.RemoveAndDeleteChildren();
  var rows = GoodsToArray(data.goods);
  for (var i = 0; i < rows.length; i++) {
    var g = rows[i];
    if (!g || !g.id || !g.item) {
      continue;
    }
    var row = NewPanel(list, "eazy_row_" + i, "Panel");
    row.BLoadLayoutSnippet("eazy_goods_snippet");
    var icon = row.FindChildTraverse("goods_icon");
    var iconHit = icon && icon.GetParent();
    if (icon) {
      icon.itemname = g.item;
    }
    var title = row.FindChildTraverse("goods_title");
    if (title) {
      title.text = g.title || "";
    }
    var price = row.FindChildTraverse("goods_price");
    if (price) {
      price.text = (g.price != null ? g.price : "") + " 金币";
    }
    (function (bid) {
      function activateBuy() {
        BuyGoods(bid);
      }
      row.SetPanelEvent("onactivate", activateBuy);
      if (iconHit) {
        iconHit.SetPanelEvent("onactivate", activateBuy);
      }
    })(g.id);
    BindEazyGoodsItemTooltip(iconHit, g.item, listGen);
  }
}

function EazyShopShowAnimated(root) {
  if (!root || !root.IsValid()) {
    return;
  }
  eazyShopJustStartedShowAnim = true;
  if (eazyShopShowAnimGuardSchedule != null) {
    $.CancelScheduled(eazyShopShowAnimGuardSchedule);
    eazyShopShowAnimGuardSchedule = null;
  }
  eazyShopShowAnimGuardSchedule = $.Schedule(0.2, function () {
    eazyShopShowAnimGuardSchedule = null;
    eazyShopJustStartedShowAnim = false;
  });
  root.style.transitionDuration = "0s";
  root.style.transitionProperty = "none";
  root.style.transform = "translateX(" + EAZY_SHOP_SLIDE_X_HIDDEN + "px)";
  root.style.opacity = "0";
  $.Schedule(0.01, function () {
    if (!root || !root.IsValid()) {
      return;
    }
    root.style.transitionDuration = EAZY_SHOP_ANIM_SHOW_SEC;
    root.style.transitionProperty = "transform, opacity";
    root.style.transitionTimingFunction = "ease-out";
    root.style.transform = "translateX(0px)";
    root.style.opacity = "1";
  });
}

function EazyShopHideAnimated(root) {
  if (!root || !root.IsValid()) {
    return;
  }
  root.style.transitionDuration = EAZY_SHOP_ANIM_HIDE_SEC;
  root.style.transitionProperty = "transform, opacity";
  root.style.transitionTimingFunction = "ease-in";
  root.style.transform = "translateX(" + EAZY_SHOP_SLIDE_X_HIDDEN + "px)";
  root.style.opacity = "0";
}

function EazyShopSnapVisible(root) {
  if (!root || !root.IsValid()) {
    return;
  }
  root.style.transitionDuration = "0s";
  root.style.transitionProperty = "none";
  root.style.transform = "translateX(0px)";
  root.style.opacity = "1";
}

function EazyShopSnapHidden(root) {
  if (!root || !root.IsValid()) {
    return;
  }
  root.style.transitionDuration = "0s";
  root.style.transitionProperty = "none";
  root.style.transform = "translateX(" + EAZY_SHOP_SLIDE_X_HIDDEN + "px)";
  root.style.opacity = "0";
}

function GetData(data) {
  if (!data) {
    return;
  }
  var show =
    data.page === true || data.page === 1 || data.page === "1";
  var root = GetRoot();
  if (!root || !root.IsValid()) {
    return;
  }
  if (eazyShopHiddenByHudShop && show) {
    /* 原生商店仍打开时不要把便捷商店显示出来；等 DOTAHUDShopClosed 再 InitData */
    RebuildGoodsList(data);
    return;
  }
  RebuildGoodsList(data);
  if (show) {
    eazyShopHideVisibleSeq++;
    var wasPanelVisible = root.visible === true;
    var alreadyOpenInData = eazyShopLastPageOpen === true;
    root.visible = true;
    eazyShopLastPageOpen = true;
    if (!wasPanelVisible || !alreadyOpenInData) {
      EazyShopShowAnimated(root);
    } else if (eazyShopJustStartedShowAnim) {
      /* 连续 page:true，不打断刚开始的滑入 */
    } else {
      EazyShopSnapVisible(root);
    }
  } else {
    eazyShopHiddenByHudShop = false;
    eazyShopHideVisibleSeq++;
    eazyShopJustStartedShowAnim = false;
    if (eazyShopShowAnimGuardSchedule != null) {
      $.CancelScheduled(eazyShopShowAnimGuardSchedule);
      eazyShopShowAnimGuardSchedule = null;
    }
    var wasOpen = eazyShopLastPageOpen === true;
    eazyShopLastPageOpen = false;
    var seq = eazyShopHideVisibleSeq;
    if (wasOpen) {
      EazyShopHideAnimated(root);
      $.Schedule(0.15, function () {
        if (seq !== eazyShopHideVisibleSeq) {
          return;
        }
        if (root && root.IsValid()) {
          root.visible = false;
        }
      });
    } else {
      EazyShopSnapHidden(root);
      root.visible = false;
    }
  }
}

function EazyShopOnHudShopOpened() {
  var root = GetRoot();
  if (!root || !root.IsValid()) {
    return;
  }
  if (eazyShopHiddenByHudShop) {
    return;
  }
  if (eazyShopLastPageOpen !== true) {
    return;
  }
  eazyShopHiddenByHudShop = true;
  eazyShopHideVisibleSeq++;
  eazyShopJustStartedShowAnim = false;
  if (eazyShopShowAnimGuardSchedule != null) {
    $.CancelScheduled(eazyShopShowAnimGuardSchedule);
    eazyShopShowAnimGuardSchedule = null;
  }
  var seq = eazyShopHideVisibleSeq;
  EazyShopHideAnimated(root);
  $.Schedule(0.15, function () {
    if (seq !== eazyShopHideVisibleSeq) {
      return;
    }
    if (root && root.IsValid()) {
      root.visible = false;
    }
  });
}

function EazyShopOnHudShopClosed() {
  if (!eazyShopHiddenByHudShop) {
    return;
  }
  eazyShopHiddenByHudShop = false;
  if (eazyShopLastPageOpen === true) {
    InitData();
  }
}

(function () {
  InitData();
  SubEvent("UI_EazyShop", GetData);
  $.RegisterForUnhandledEvent("DOTAHUDShopOpened", EazyShopOnHudShopOpened);
  $.RegisterForUnhandledEvent("DOTAHUDShopClosed", EazyShopOnHudShopClosed);
})();