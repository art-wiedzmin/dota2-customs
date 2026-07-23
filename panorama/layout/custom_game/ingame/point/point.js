--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


//初始化加载加载
function InitData() {
  var tp = "init";
  SendServer("Lua_Point", { data: { tp } });
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  SendServer("Lua_Point", { data: { tp } });
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_Point", { data: { tp } });
}

//获取数据
function GetData(data) {
  if (!data) {
    return;
  }
  // print("Point");
  // print(data);
  //  GetRoot().style.opacity = data.page;
}

(function () {
  // InitData();
  // print("Point");
  SubEvent("UI_Point", GetData);
})();