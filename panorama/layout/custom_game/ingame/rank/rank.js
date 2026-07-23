//初始化加载加载
function InitData() {
  var tp = "init";
  SendServer("Lua_Rank", { data: { tp } });
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  SendServer("Lua_Rank", { data: { tp } });
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_Rank", { data: { tp } });
}

//获取数据
function GetData(data) {
  if (!data) {
    return;
  }
  GetRoot().style.opacity = data.page;
}
function Click_Hide_Page() {
  GetRoot().style.opacity = "0";
}

(function () {
  InitData();
  SubEvent("UI_Rank", GetData);
  GameUI.CustomUIConfig().Click_Hide_Page = Click_Hide_Page;
})();
