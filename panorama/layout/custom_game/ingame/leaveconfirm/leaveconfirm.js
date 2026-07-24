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
