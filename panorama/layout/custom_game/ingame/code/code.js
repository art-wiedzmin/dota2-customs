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
  SendServer("Lua_Code", { data: { tp } });
}
function InitShopData() {
  var tp = "init";
  SendServer("Lua_Shop", { data: { tp } });
}
//打开页面
function OpenPage() {
  // print("code");
  var tp = "OpenPage";
  SendServer("Lua_Code", { data: { tp } });
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_Code", { data: { tp } });
}

//切换支付方式
function PayType(num) {
  var tp = "PayType";
  var text = num;
  SendServer("Lua_Code", { data: { tp, text } });
  
}
function GetShopData(data){
  

}
//获取数据
function GetData(data) {
  if (!data) {
    return;
  }
  
  GetRoot().style.opacity = data.page;
  GetRoot().hittest=true;
  // 微信
  var ewm_panel_wx = GetPanel("wx_ma");
  var ewm_code = "";
  //微信二维码
  if (data.pay_type == 1) {
    ewm_code = data.ewm1;
    GetPanel("btn_1").AddClass("active");
    GetPanel("btn_2").RemoveClass("active");
    GetPanel("pay_text_text").text="微信支付:"
  }
  //支付宝二维码
  if (data.pay_type == 2) {
    ewm_code = data.ewm2;
    GetPanel("btn_1").RemoveClass("active");
    GetPanel("btn_2").AddClass("active");
    GetPanel("pay_text_text").text="支付宝支付:"
  }
  if (ewm_code == "") {
    return;
  }
  if (data.pay_page == 1) {
    CreateQRCode(ewm_code, ewm_panel_wx, 200);
    
  } else {
    ewm_panel_wx.RemoveAndDeleteChildren();
  }

  if(data.price){
    GetPanel("pay_text_num").text ="¥ " +data.price;
  }else{
    GetPanel("pay_text_num").text ="";
  }

}

(function () {
  InitData();
  // InitShopData();
  // SubEvent("UI_Shop", GetShopData);
  SubEvent("UI_Code", GetData);
})();