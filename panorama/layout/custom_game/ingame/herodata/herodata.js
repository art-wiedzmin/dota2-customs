--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function InitData() {
  var tp = "init";
  SendServer("Lua_HeroData", { data: { tp } });
}

//随机升星
function RollStar() {
  var tp = "RollStar";
  SendServer("Lua_HeroData", { data: { tp } });
}

//稳定升星
function LevelStar() {
  var tp = "LevelStar";
  SendServer("Lua_HeroData", { data: { tp } });
}

function GetData(data) {
  if (!data) {
    return;
  }
  // print(data);
  base_attr = data.cost;
  // print(base_attr);
  //成长属性
  SetAttr(data.attr);
  //3个假星星
  var faker_star = data.star + 3;
  SetStar(faker_star);
  GetPanel("lv_text").text = "lv" + faker_star;
}

var base_attr = {};

function SetStar(data) {
  for (i = 1; i <= 20; i++) {
    var panel_name = "star_" + i;
    var panel = GetPanel(panel_name);
    if (i <= data) {
      panel.style.opacity = 1;
    } else {
      panel.style.opacity = 0;
    }
  }
}

function SetAttr(data) {
  $.Each(data, function (v, k) {
    var panel = GetPanel(k);
    var num1 = Number(base_attr[k].toFixed(1));
    var num2 = Number(v.toFixed(1));
    var num = num1 + num2;
    panel.text = num.toFixed(1);
  });
}

function Testd() {
  //print("testd");
}

function HoverFun(pa) {
  WhenOver(pa, function () {
    if (pa == "suiji") {
      GetPanel("hover_2").visible = true;
    } else if (pa == "jia") {
      GetPanel("hover_1").visible = true;
    }
  });
  WhenOut(pa, function () {
    if (pa == "suiji") {
      GetPanel("hover_2").visible = false;
    } else if (pa == "jia") {
      GetPanel("hover_1").visible = false;
    }
  });
}

function EazyShop() {
  var tp = "EazyShopChange";
  SendServer("Lua_EazyShop", { data: { tp } });
}

HoverFun("suiji");
HoverFun("jia");

(function () {
  //print("HeroData");
  InitData();
  SubEvent("UI_HeroData", GetData);
  $.RegisterForUnhandledEvent("DOTAHUDShopOpened", function () {
    GetRoot().style.marginRight = "450px";
    GetRoot().style.opacity = 0;
    /* 便捷商店：见 ingame/EazyShop/EazyShop.js DOTAHUDShopOpened */
  });
  $.RegisterForUnhandledEvent("DOTAHUDShopClosed", () => {
    GetRoot().style.marginRight = "0px";
    GetRoot().style.marginTop = "50px";
    GetRoot().style.opacity = 1;
  });
})();