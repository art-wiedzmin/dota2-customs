--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function InitData() {
  var tp = "init";
  SendServer("Lua_PackData", { data: { tp } });
}

function ClickPersonItem(pa) {
  WhenActive(pa, function () {
    var tp = "TackItem";
    var text = pa.panelslot;
    //print("取道具");
    //print(text);
    SendServer("Lua_PackData", { data: { tp, text } });
  });
}

var InitHeroSlot = false;

//查看私人仓库物品
function TipPersonItem(pa) {
  pa.SetPanelEvent("onmouseover", function () {
    if (pa.ItemName != "") {
      var item_name = pa.ItemName;
      $.DispatchEvent("DOTAShowAbilityTooltip", pa, item_name);
      pa.style.tooltipPosition = "left";
    }
  });
  pa.SetPanelEvent("onmouseout", function () {
    $.DispatchEvent("DOTAHideAbilityTooltip", pa);
  });
}

function InitSlot() {
  if (InitHeroSlot == false) {
    var panel1 = GetPanel("pack_box");
    panel1.RemoveAndDeleteChildren();
    for (let i = 1; i <= 20; i++) {
      var sonpanel1 = NewPanel(panel1, "slot_" + i, "Panel");
      sonpanel1.BLoadLayoutSnippet("pack_slot");
      sonpanel1.panelslot = "slot_" + i;
      ClickPersonItem(sonpanel1);
      TipPersonItem(sonpanel1);
    }
  }
  InitHeroSlot = true;
}

//获取个人数据
function GetData(data) {
  //print(data)
  if (!data) {
    return;
  }
  GetRoot().style.opacity = data.page;
  //print(data);
  SetPack(data.pack);
}

function SetPack(data) {
  $.Each(data, function (v, k) {
    var panel = GetPanel(k);
    var img_panel = panel.FindChildTraverse("goods_img");
    var text_panel = panel.FindChildTraverse("goods_num");
    var path = "raw://resource/flash3/images/items/item_null.png";
    var text_num = "";
    if (v.state == 1) {
      var name = v.item;
      panel.ItemName = name;
      text_num = v.num;
      path = GetItemIconFlash3Path(name);
    } else {
      panel.ItemName = "";
    }
    img_panel.SetImage(path);
    text_panel.text = text_num;
  });
}

(function () {
  InitSlot();
  //print("Pack")
  InitData();
  SubEvent("UI_Pack", GetData);
})();