
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