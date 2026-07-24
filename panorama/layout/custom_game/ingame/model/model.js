--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]



var state=0;

function newbieGuideShouldShow(data) {
    var t5 = Number(data.total_game);
    var t1 = Number(data.total_game2);
    if (isNaN(t5)) {
        t5 = 0;
    }
    if (isNaN(t1)) {
        t1 = 0;
    }
    // 5v5 + 1v1 总场数；超过 1 场不再显示新手指引
    return t5 + t1 == 0;
}

function GetData(data){
    if(!data){
        return;
    }
    if(newbieGuideShouldShow(data) && state==0){
        GetRoot().visible=true;
    }else{
        GetRoot().visible=false;
    }
}

function clickNext(){
    if (!GetPanel("tip_1").visible) {
        return;
    }
    GetPanel("tip_1").visible=false;
    GetPanel("tip_2").visible=true;
}

function clickClose(){
    if (!GetRoot().visible) {
        return;
    }
    GetRoot().visible=false;
    state=1;
}

// 点击全屏半透明遮罩（非小卡片区域）：与对应步骤的「我知道了」同效
function onGuideBackdropActivate(){
    var root = GetRoot();
    if (!root.visible) {
        return;
    }
    if (GetPanel("tip_1").visible) {
        clickNext();
    } else if (GetPanel("tip_2").visible) {
        clickClose();
    }
}

(function(){
    SubEvent("UI_Person", GetData);
})()