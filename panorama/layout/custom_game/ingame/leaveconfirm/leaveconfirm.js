--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


//初始化加载
function InitData() {
  var tp = "init";
  SendServer("Lua_LeaveConfirm", { data: { tp } });
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  SendServer("Lua_LeaveConfirm", { data: { tp } });
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_LeaveConfirm", { data: { tp } });
}

function ConfirmLeaveGame() {
  var tp = "ConfirmLeave";
  SendServer("Lua_LeaveConfirm", { data: { tp } });
  $.DispatchEvent("DOTAHUDShowDashboard");
}

//获取数据
function GetData(data) {
  if (!data) {
    return;
  }
  GetRoot().style.opacity = data.page;
}

(function () {
  InitData();
  SubEvent("UI_LeaveConfirm", GetData);
})();