//初始化加载加载
function InitData() {
  var tp = "init";
  SendServer("Lua_Shop", { data: { tp } });
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  SendServer("Lua_Shop", { data: { tp } });
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_Shop", { data: { tp } });
}
//购买
function Pay(num) {
   var tp = "Pay";
   var text = num;
   SendServer("Lua_Shop", { data: { tp, text } });
}
//获取数据
function GetData(data) {
  if (!data) {
    return;
  }
  GetRoot().style.opacity = data.page;
  GetPanel("label_30").text ="剩余"+ data.card1 + "天";
  GetPanel("label_90").text ="剩余"+ data.card2 + "天";
}
function Click_Hide_Page() {
  GetRoot().style.opacity = "0";
}
(function () {
  InitData();
  SubEvent("UI_Shop", GetData);
  GameUI.CustomUIConfig().Click_Hide_Page = Click_Hide_Page;
})();
