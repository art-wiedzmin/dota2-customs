--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


var LIBAO_IMG_BASE = "raw://resource/flash3/images/libao/";

function InitData() {
  SendServer("Lua_HolidayPack", { data: { tp: "init" } });
}

function OpenPage() {
  SendServer("Lua_HolidayPack", { data: { tp: "OpenPage" } });
}

function HolidayPackBootstrap() {
  var cached = GameUI.CustomUIConfig.AllHolidayPackData;
  if (cached) {
    GetData(cached);
  }
  SendServer("Lua_HolidayPack", { data: { tp: "init" } });
  SendServer("Lua_HolidayPack", { data: { tp: "OpenPage" } });
}

function PayGiftPack(packKey, panel) {
  WhenActive(panel, function () {
    SendServer("Lua_HolidayPack", { data: { tp: "ClickGift", text: packKey } });
  });
}

function ClaimFreeGiftPack(packKey, panel) {
  WhenActive(panel, function () {
    // 与端午免费礼包同一事件：Lua -> HolidayPack:Free -> /user/free type=4
    SendServer("Lua_HolidayPack", {
      data: { tp: "Free", text: packKey },
    });
  });
}

function ParseJsonSafe(raw, fallback) {
  if (raw == null || raw === "") {
    return fallback;
  }
  if (typeof raw === "object") {
    return raw;
  }
  try {
    return JSON.parse(String(raw));
  } catch (e) {
    return fallback;
  }
}

/** 服务端礼包列表：优先 gift_packs_json，兼容旧字段 gift_packs */
function ResolvePackList(data) {
  if (!data) {
    return [];
  }
  var raw = null;
  if (data.gift_packs_json != null && data.gift_packs_json !== "") {
    raw = ParseJsonSafe(data.gift_packs_json, []);
  } else if (data.gift_packs != null) {
    raw = data.gift_packs;
  }
  if (!raw) {
    return [];
  }
  if (Array.isArray(raw)) {
    return raw;
  }
  var out = [];
  for (var k in raw) {
    if (!Object.prototype.hasOwnProperty.call(raw, k)) {
      continue;
    }
    var pack = raw[k];
    if (pack && pack.pack_key) {
      out.push(pack);
    }
  }
  out.sort(function (a, b) {
    var sa = parseInt(a.sort_order, 10) || 0;
    var sb = parseInt(b.sort_order, 10) || 0;
    if (sa !== sb) {
      return sa - sb;
    }
    return String(a.pack_key).localeCompare(String(b.pack_key));
  });
  return out;
}

function ResolveBuyCounts(data) {
  if (!data) {
    return {};
  }
  if (data.gift_buy_counts_json != null && data.gift_buy_counts_json !== "") {
    return ParseJsonSafe(data.gift_buy_counts_json, {}) || {};
  }
  if (data.gift_buy_counts && typeof data.gift_buy_counts === "object") {
    return data.gift_buy_counts;
  }
  return {};
}

function ResolveFreeClaimed(data) {
  if (!data) {
    return {};
  }
  if (
    data.gift_free_claimed_json != null &&
    data.gift_free_claimed_json !== ""
  ) {
    return ParseJsonSafe(data.gift_free_claimed_json, {}) || {};
  }
  if (data.gift_free_claimed && typeof data.gift_free_claimed === "object") {
    return data.gift_free_claimed;
  }
  if (
    data.free_claimed_today &&
    typeof data.free_claimed_today === "object"
  ) {
    return data.free_claimed_today;
  }
  return {};
}

function GetGiftBuyCount(counts, packKey) {
  if (!counts) {
    return 0;
  }
  var v = counts[packKey];
  if (v == null) {
    v = counts[String(packKey)];
  }
  return parseInt(v, 10) || 0;
}

function IsFreePack(pack) {
  if (!pack) {
    return false;
  }
  if (
    pack.is_free === true ||
    pack.is_free === 1 ||
    pack.is_free === "1" ||
    pack.is_free === "true"
  ) {
    return true;
  }
  var price = parseInt(pack.price_yuan, 10);
  if (price === 0) {
    return true;
  }
  var pt = String(pack.product_type || "").toUpperCase();
  if (pt.indexOf("FREE_") === 0 || pt.indexOf("FREE") >= 0) {
    return true;
  }
  var key = String(pack.pack_key || "").toLowerCase();
  if (key.indexOf("free") >= 0) {
    return true;
  }
  var img = String(pack.image_key || "").toLowerCase();
  if (img.indexOf("free") >= 0) {
    return true;
  }
  var name = String(pack.name || "");
  if (name.indexOf("免费") >= 0) {
    return true;
  }
  return false;
}

function IsFreeClaimedToday(freeClaimed, packKey) {
  if (!freeClaimed) {
    return false;
  }
  var v = freeClaimed[packKey];
  if (v == null) {
    v = freeClaimed[String(packKey)];
  }
  return v === true || v === 1 || v === "1";
}

function IsDwFreeClaimed(data) {
  if (!data) {
    return false;
  }
  // 与端午一致：dw_free_day === 1 可领，否则已领
  var day = data.dw_free_day;
  if (day === 1 || day === "1") {
    return false;
  }
  if (day === 0 || day === "0") {
    return true;
  }
  return false;
}

function IsGiftSoldOut(counts, freeClaimed, pack, data) {
  if (!pack) {
    return true;
  }
  if (IsFreePack(pack)) {
    // 免费礼包共用端午 dw_free_day 每日 1 次
    return IsDwFreeClaimed(data);
  }
  var limited =
    pack.is_limited === true ||
    pack.is_limited === 1 ||
    pack.is_limited === "1";
  if (!limited) {
    return false;
  }
  var limit = parseInt(pack.limit_count, 10) || 0;
  if (limit <= 0) {
    return false;
  }
  return GetGiftBuyCount(counts, pack.pack_key) >= limit;
}

function RenderGiftPacks(panel, data) {
  var packs = ResolvePackList(data);
  var counts = ResolveBuyCounts(data);
  var freeClaimed = ResolveFreeClaimed(data);
  var isFirstItem = true;
  for (var i = 0; i < packs.length; i++) {
    var pack = packs[i];
    if (!pack || !pack.pack_key) {
      continue;
    }
    var imageKey = pack.image_key || pack.pack_key;
    if (!imageKey) {
      continue;
    }
    var sonpanel = NewPanel(panel, "gift_" + pack.pack_key, "Panel");
    if (isFirstItem) {
      sonpanel.AddClass("first_item");
      isFirstItem = false;
    }
    sonpanel.BLoadLayoutSnippet("item_snippet");
    sonpanel.AddClass("gift_only_image");

    sonpanel.FindChildTraverse("item_image").SetImage(
      LIBAO_IMG_BASE + imageKey + ".png"
    );
    var titleImg = sonpanel.FindChildTraverse("title_image");
    if (titleImg) {
      titleImg.visible = false;
    }
    var btnImg = sonpanel.FindChildTraverse("btn_img");
    if (btnImg) {
      btnImg.visible = false;
    }
    var priceText = sonpanel.FindChildTraverse("price_text");
    if (priceText) {
      priceText.visible = false;
    }

    var soldOut = IsGiftSoldOut(counts, freeClaimed, pack, data);
    if (soldOut) {
      sonpanel.AddClass("over");
    } else {
      sonpanel.RemoveClass("over");
    }

    var btn = sonpanel.FindChildTraverse("btn_panel");
    if (btn) {
      btn.style.width = "100%";
      btn.style.height = "100%";
      btn.style.margin = "0px";
      btn.style["vertical-align"] = "center";
    }
    if (soldOut) {
      sonpanel.hittest = false;
      sonpanel.hittestchildren = false;
      if (btn) {
        btn.hittest = false;
      }
    } else {
      sonpanel.hittest = true;
      sonpanel.hittestchildren = true;
      (function (card, packKey, isFree) {
        card.SetPanelEvent("onmouseover", function () {
          card.AddClass("gift_hover");
        });
        card.SetPanelEvent("onmouseout", function () {
          card.RemoveClass("gift_hover");
        });
        if (btn) {
          btn.hittest = true;
          if (isFree) {
            ClaimFreeGiftPack(packKey, btn);
          } else {
            PayGiftPack(packKey, btn);
          }
        }
      })(sonpanel, pack.pack_key, IsFreePack(pack));
    }
  }
}

function GetData(data) {
  if (!data) {
    return;
  }
  GameUI.CustomUIConfig.AllHolidayPackData = data;
  var root = GetRoot();
  if (root) {
    root.style.opacity = "1";
  }
  SetData(data);
}

function SetData(data) {
  var panel = GetPanel("list_panel");
  if (!panel) {
    return;
  }
  panel.RemoveAndDeleteChildren();
  RenderGiftPacks(panel, data);
}

(function () {
  SubEvent("UI_HolidayPack", GetData);
  GameUI.CustomUIConfig().HolidayPackBootstrap = HolidayPackBootstrap;
  $.Schedule(0, HolidayPackBootstrap);
})();