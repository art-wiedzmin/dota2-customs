--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function UpdateTips(){
   var root=GetRoot()
   var ItemName=root.GetAttributeString("ID","")
   var ItemIndex=root.GetAttributeString("Type","")
   if(!ItemName){
       return
   }
   GetPanel("tip_text").text=ItemName;
    


}
(function(){

})()