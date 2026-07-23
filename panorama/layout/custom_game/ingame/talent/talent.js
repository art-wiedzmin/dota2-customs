--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function InitData() {
  var tp = "init";
  SendServer("Lua_TalentData", { data: { tp } });
}

function SelectTalent(num) {
  var tp = "SelectTalent";
  var text = num;
  SendServer("Lua_TalentData", { data: { tp, text } });
}

function GetData(data) {
  if (!data) {
    return;
  }
  //print(data);
  GetRoot().style.opacity = data.page;
  if(data.page == 1){
    GameUI.CustomUIConfig().Hover_hide_box();
  }
  
}

function ClearTip() {
  var tp = "ClearTip";
  SendServer("Lua_TalentData", { data: { tp } });
}

// tip
function UI_ShowPetTooltip(pa) {
	var pa=GetPanel(pa);
		WhenOver(pa,function(){
      var paid=pa.id    
      $.DispatchEvent("UIShowCustomLayoutParametersTooltip",pa,"Bag_Pet_Tips","file://{resources}/layout/custom_game/ingame/Talent/talenttip/talenttip.xml","slot="+paid)
            
		})
		WhenOut(pa,function(){
				$.DispatchEvent("UIHideCustomLayoutTooltip","Bag_Pet_Tips") 
		})
}

// tip隐藏
function UI_HidePetTooltip() {
   $.DispatchEvent("UIHideCustomLayoutTooltip","Bag_Pet_Tips") 
}

(function () {
  InitData();
  SubEvent("UI_Talent", GetData);
  UI_ShowPetTooltip("item_goods_17");
  UI_ShowPetTooltip("item_goods_18");
  UI_ShowPetTooltip("item_goods_19");
  UI_ShowPetTooltip("item_goods_24");
  var tag4 = $("#text_img_4");
  if (tag4) {
    tag4.text = "特效";
  }
  // 雷电戟：game 目录需有 custom_game png/vtex，此处用 flash3 兜底避免图标空白
  var halberdBox = $("#item_goods_24");
  if (halberdBox) {
    var imgs = halberdBox.FindChildrenWithClassTraverse("Img");
    if (imgs && imgs.length > 0) {
      var path =
        typeof GetItemIconFlash3Path === "function"
          ? GetItemIconFlash3Path("item_goods_24")
          : "raw://resource/flash3/images/items/item_goods_24.png";
      imgs[0].SetImage(path);
    }
  }
  UI_HidePetTooltip();
})();