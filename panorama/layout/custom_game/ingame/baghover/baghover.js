--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]



function hovershow(){
    var panel=GetPanel("hover_panel");
    WhenOver(panel,function(){
        GetPanel("hover_tip").visible=true;
    })
    WhenOut(panel,function(){
        GetPanel("hover_tip").visible=false;
    })
}

hovershow();
function hoverHide(){
    var panel=GetRoot();
    panel.visible=false;
    var cfg = GameUI.CustomUIConfig();
    if (cfg.Hide_box_bag_hover) {
        cfg.Hide_box_bag_hover();
    }
}
(function(){
    GameUI.CustomUIConfig().Hover_hide_box=hoverHide;
})()