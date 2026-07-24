--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]



var petidlist={
    1:"Devil_fish",
    2:"Mountain_Crab",
    3:"Magic_Pelican",
    4:"Luminaries_Lynx",
    5:"Azure_Lion",
}


function Bload(){
    var panel=GetPanel("section");
        panel.RemoveAndDeleteChildren();
    for(var i=1;i<=5;i++){
        var sonpanel=NewPanel(panel,"pet_li_"+i,"Panel");
        sonpanel.BLoadLayoutSnippet("pet_snippet");
        sonpanel.FindChildTraverse("pet_name").text=Local(petidlist[i]);
       var petpanel= sonpanel.FindChildTraverse("pet_box");
       petpanel.RemoveAndDeleteChildren();
       petpanel.BLoadLayoutSnippet(petidlist[i]+"_snippet");
        var petid=petidlist[i];
        ShowTips(sonpanel,petid);
    }
}

// tip
function ShowTips(panel, petid) {
  WhenOver(panel, function () {
    if (!petid) { return }
   var Type="pet";
    $.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "TestTips", "file://{resources}/layout/custom_game/tips/pettip/pettip.xml", "ID=" + petid + "&Type=" + Type)
    panel.style.tooltipPosition = "right";
  })
  WhenOut(panel, function () {
    $.DispatchEvent("UIHideCustomLayoutTooltip", "TestTips")
  })
}

(function(){
    Bload();
})()