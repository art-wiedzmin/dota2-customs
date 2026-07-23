--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function UpdateTips(){
   var root=GetRoot()
   var ItemName=root.GetAttributeString("ID","")
   var ItemIndex=root.GetAttributeString("Type","")
   if(!ItemName||ItemIndex==""){
       return
   }
    if(ItemIndex=="xt"){
        GetPanel("tip_img").SetImage("raw://resource/flash3/images/xt/" + ItemName + ".png")
    }else{
        GetPanel("tip_img").SetImage("raw://resource/flash3/images/tf/" + ItemName + ".png")
    }


}
(function(){

})()