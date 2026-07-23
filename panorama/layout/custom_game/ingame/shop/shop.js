--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


//初始化加载加载
function InitData() {
  var tp = "init";
  SendServer("Lua_Shop", { data: { tp } });
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  SendServer("Lua_Shop", { data: { tp } });
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_Shop", { data: { tp } });
}

//购买
function Pay(num, panel) {
  WhenActive(panel, function () {
    var tp = "Pay";
    var text = num;
    SendServer("Lua_Shop", { data: { tp, text } });
  })

}

//刷新商店
function shuaxin() {
  var tp = "Refresh";
  SendServer("Lua_Shop", { data: { tp } });
}

//免费领取
function Free(num, panel) {
  WhenActive(panel, function () {
    var tp = "Free";
    var text = num;
    SendServer("Lua_Shop", { data: { tp, text } });
  })

}

//获取数据
function GetData(data) {
  if (!data) {
    return;
  }
  GameUI.CustomUIConfig.AllShopData = data;
  var root = GetRoot();
  if (root) {
    // 挂在 public 容器内，显隐由 public 顶栏控制；勿用 init 的 page=false 把子面板 opacity 置 0
    root.style.opacity = "1";
  }
  SetData(data);
}

function ShopBootstrap() {
  var cached = GameUI.CustomUIConfig.AllShopData;
  if (cached) {
    GetData(cached);
  }
  SendServer("Lua_Shop", { data: { tp: "init" } });
  SendServer("Lua_Shop", { data: { tp: "OpenPage" } });
}
var newdata = {
  slot_1: {
    name: "freeday",
    price: "0",
    img: "mr",
    id: 1,
    isgot: 0,
    get: "check",
    cost_2: "50",
    orad: 0,
  },
  slot_2: {
    name: "card1day",
    price: "0",
    img: "hy",
    id: 2,
    isgot: 1,
    get: "check",
    cost_2: "100",
    orad: 0,
  },
  slot_3: {
    name: "card2day",
    price: "0",
    img: "jk",
    id: 3,
    isgot: 1,
    get: "check",
    cost_2: "100",
    orad: 0,
  },
  slot_4: {
    name: "gold6",
    price: "6",
    img: "sc",
    id: 4,
    isgot: 0,
    get: "cost",
    cost_2: "60",
    orad: 2,
  },
  slot_5: {
    name: "gold30",
    price: "30",
    img: "sc",
    id: 5,
    isgot: 0,
    get: "cost",
    cost_2: "300",
    orad: 3,
  },
  slot_6: {
    name: "gold68",
    price: "68",
    img: "sc",
    id: 6,
    isgot: 0,
    get: "cost",
    cost_2: "680",
    orad: 4,
  },
  slot_7: {
    name: "gold128",
    price: "128",
    img: "sc",
    id: 7,
    isgot: 0,
    get: "cost",
    cost_2: "1280",
    orad: 5,
  },
  slot_8: {
    name: "gold328",
    price: "328",
    img: "sc",
    id: 8,
    isgot: 0,
    get: "cost",
    cost_2: "3280",
    orad: 6,
  },
  slot_9: {
    name: "gold648",
    price: "648",
    img: "sc",
    id: 9,
    isgot: 0,
    get: "cost",
    cost_2: "6480",
    orad: 7,
  },
  slot_10: {
    name: "gold1280",
    price: "1280",
    img: "sc",
    id: 10,
    isgot: 0,
    get: "cost",
    cost_2: "12800",
    orad: 10,
  },
}

/** 金豆充值档（仅这些档位使用 item_*_{2|3} 与 gold_title_{2|3}） */
var SHOP_GOLD_TIER_NAMES = {
  gold6: true,
  gold30: true,
  gold68: true,
  gold128: true,
  gold328: true,
  gold648: true,
  gold1280: true,
};

function ShopGoldTierFirstChargeAvailable(shopData, goodsName) {
  if (!shopData || !SHOP_GOLD_TIER_NAMES[goodsName]) {
    return false;
  }
  if (
    shopData.first_recharge_double_open === true ||
    shopData.first_recharge_double_open === 1
  ) {
    return true;
  }
  var d = shopData.double;
  if (!d) {
    return false;
  }
  return d[goodsName] === 0 || d[goodsName] === "0";
}

function ShopGoldTierImagePaths(shopData, goodsName, cost2) {
  var suffix = ShopGoldTierFirstChargeAvailable(shopData, goodsName) ? "3" : "2";
  var base = "raw://resource/flash3/images/shop/";
  return {
    item: base + "item_" + cost2 + "_" + suffix + ".png",
    title: base + "gold_title_" + suffix + ".png",
  };
}

function SetData(data) {
  var uidata = newdata;
  var panel = GetPanel("list_panel");
  panel.RemoveAndDeleteChildren();
  $.Each(uidata, function (k, v) {
    var sonpanel = NewPanel(panel, v, "Panel")
    sonpanel.BLoadLayoutSnippet("item_snippet");
    var itemImagePanel = sonpanel.FindChildTraverse("item_image");
    var iconImagePanel = sonpanel.FindChildTraverse("icon_image");
    if (SHOP_GOLD_TIER_NAMES[k.name]) {
      var paths = ShopGoldTierImagePaths(data, k.name, k.cost_2);
      itemImagePanel.SetImage(paths.item);
      iconImagePanel.SetImage(paths.title);
    } else {
      itemImagePanel.SetImage(
        "raw://resource/flash3/images/shop/item_" + k.cost_2 + ".png"
      );
      iconImagePanel.SetImage(
        "raw://resource/flash3/images/shop/icon_" + k.img + ".png"
      );
    }


    if (k.get == "check") {
      sonpanel.FindChildTraverse("full_text").visible = true;
      sonpanel.FindChildTraverse("btn_text").visible = false;

    } else {
      sonpanel.FindChildTraverse("full_text").visible = false;
      sonpanel.FindChildTraverse("btn_text").visible = true;
      sonpanel.FindChildTraverse("btn_text").text = "¥ " + k.price;

    }
    sonpanel.paneltype = k.name;
    var key = k.name;
    if (data[key] == "") {
      if (data[key] == 0) {
        sonpanel.AddClass("over");
      } else {
        sonpanel.RemoveClass("over");
      }
    } else {

    }
    var keynum = k.orad;

    if (v == "slot_1") {
      var btn = sonpanel.FindChildTraverse("btn_panel")
      Free(1, btn);
    } else if (v == "slot_2") {
      var btn = sonpanel.FindChildTraverse("btn_panel")
      Free(2, btn)
    } else if (v == "slot_3") {
      var btn = sonpanel.FindChildTraverse("btn_panel")
      Free(3, btn)
    } else {
      var btn = sonpanel.FindChildTraverse("btn_panel")
      Pay(keynum, btn);
      // print(keynum)
    }





  })
}















function Click_Hide_Page() {
  GetRoot().style.opacity = "0";
}
(function () {
  SubEvent("UI_Shop", GetData);
  GameUI.CustomUIConfig().ShopBootstrap = ShopBootstrap;
  $.Schedule(0, ShopBootstrap);
  GameUI.CustomUIConfig().Click_Hide_Page = Click_Hide_Page;
})();