//初始化加载加载
// function InitData() {
//     var tp = "init";
//     SendServer("Lua_Store", { data: { tp } });
//   }
  
//   //打开页面
//   function OpenPage() {
//     var tp = "OpenPage";
//     SendServer("Lua_Store", { data: { tp } });
//   }
  
 
  
  //获取数据
  function GetData(data) {
    if (!data) {
      return;
    }
    GameUI.CustomUIConfig.AllShopData = data;
    GetPanel("cost_text").text = data.gold;
  }

  /** 节日礼包页签开关 */
  var CLRB_HOLIDAY_PACK_TAB_ENABLED = true;

  /** 商店顶栏：全部页签本地/线上均显示 */
  function ApplyPublicShopTabVisibility() {
    for (var i = 1; i <= 5; i++) {
      var tag = GetPanel("tag_" + i);
      if (tag) {
        if (i === 2 && !CLRB_HOLIDAY_PACK_TAB_ENABLED) {
          tag.visible = false;
        } else {
          tag.visible = true;
        }
      }
    }
  }

  function SetPublicHitTest(enabled) {
    var root = GetRoot();
    if (root) {
      root.hittest = !!enabled;
    }
  }

  function ShowPublic(page) {
    GetRoot().style.opacity = "1";
    SetPublicHitTest(true);
    ClrbSetTextEntryEnabled(GetPanel("entry_code"), true);
    ApplyPublicShopTabVisibility();
    if (page === "shop") {
      ClickTag(1);
    } else if (page === "holiday" || page === "holidaypack") {
      ClickTag(CLRB_HOLIDAY_PACK_TAB_ENABLED ? 2 : 1);
    } else if (page === "battlepass") {
      ClickTag(3);
    } else if (page === "person") {
      ClickTag(4);
    } else if (page === "store" || page === "outbag" || page === "bag") {
      ClickTag(5);
    }
  }
 //关闭页面
  function ClosePage() {
    GetRoot().style.opacity = "0";
    SetPublicHitTest(false);
    click = 0;
    ClrbSetTextEntryEnabled(GetPanel("entry_code"), false);
    ClrbDropInputFocusSafe();
    SendServer("Lua_Shop", { data: { tp: "ClosePage" } });
    SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
    if (GameUI.CustomUIConfig().Click_Hide_Page) {
      GameUI.CustomUIConfig().Click_Hide_Page();
    }
  }

  var click = 0;

  /** 再次打开同一页签时刷新（不关面板、仅重载内容时用） */
  function RefreshActiveTab(num) {
    if (num === 1) {
      var boot = GameUI.CustomUIConfig().ShopBootstrap;
      if (typeof boot === "function") {
        boot();
        return;
      }
    }
    if (num === 2) {
      var hpBoot = GameUI.CustomUIConfig().HolidayPackBootstrap;
      if (typeof hpBoot === "function") {
        hpBoot();
        return;
      }
    }
    if (num === 3) {
      SendServer("Lua_Shop", { data: { tp: "OpenBattlePass" } });
      return;
    }
    SendServer("Lua_Shop", { data: { tp: "OpenPage" } });
  }

//   点击商店、节日礼包、战令、会员、背包
function ClickTag(num){
    if (num === 2 && !CLRB_HOLIDAY_PACK_TAB_ENABLED) {
        return;
    }
    if(click==num){
        RefreshActiveTab(num);
        return;
    }
    for(var i=1;i<=5;i++){
        var tag=GetPanel("tag_"+i);
        if(i==num){
            tag.AddClass("active");
        }else{
            tag.RemoveClass("active");
        }
    }

    BloadPage(num);
       click=num;
}


//   挂载页面
function BloadPage(tag){
    var pa=GetPanel("container_box");
        pa.RemoveAndDeleteChildren();
        panel=NewPanel(pa,"container_son","Panel")
        panel.style.width = "100%";
        panel.style.height = "100%";
        panel.hittest = true;
        var tp = "OpenPage";
    if(tag==1){
        SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
        panel.BLoadLayout("file://{resources}/layout/custom_game/ingame/Shop/Shop.xml", false, false);
    }else if(tag==2){
        SendServer("Lua_Shop", { data: { tp: "ClosePage" } });
        panel.BLoadLayout("file://{resources}/layout/custom_game/ingame/HolidayPack/HolidayPack.xml", false, false);
    }else if(tag==3){
        SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
        panel.BLoadLayout("file://{resources}/layout/custom_game/ingame/BattlePass/BattlePass.xml", false, false);
        SendServer("Lua_Shop", { data: { tp: "OpenBattlePass" } });
    }else if(tag==4){
        SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
        panel.BLoadLayout("file://{resources}/layout/custom_game/ingame/Person/Person.xml", false, false);
        SendServer("Lua_Shop", { data: { tp } });
    }else if(tag==5){
        SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
        panel.BLoadLayout("file://{resources}/layout/custom_game/ingame/OutBag/OutBag.xml", false, false);
        SendServer("Lua_Shop", { data: { tp: "OpenPage" } });
        SendServer("Lua_Shop", { data: { tp: "OutBagSync" } });
    }else{

    };
    
    
}

function GetPlayerData(){
    var playerid=Game.GetLocalPlayerID();
    var info=Game.GetPlayerInfo(playerid);
    var sid = ClrbSteamIdOrEmpty(info.player_steamid);
    GetPanel("player_img_p").steamid = sid;
    GetPanel("player_name_p").steamid = sid;
}

// 兑换码（public.xml Title #right_panel .InputBox #entry_text，回车提交）
function Code() {
  var ent = GetPanel("entry_code");
  if (!ent) {
    return;
  }
  var text = (ent.text || "").trim();
  if (!text) {
    return;
  }
  var tp = "Code";
  SendServer("Lua_Shop", { data: { tp, text } });
}
function shuaxin() {
  var tp = "Refresh";
  SendServer("Lua_Shop", { data: { tp } });
}



  (function () {
    // InitData();
    // SubEvent("UI_Store", GetData);
    GetPlayerData();
    ApplyPublicShopTabVisibility();
    ClrbSetTextEntryEnabled(GetPanel("entry_code"), false);
    SubEvent("UI_Shop", GetData);
    GameUI.CustomUIConfig().Home_Click_Show_Public=ShowPublic;
  })();
  
