function InitData() {
  var tp = "init";
  SendServer("Lua_TalentData", { data: { tp } });
}

function LevelUp() {
  var tp = "LevelUp";
  SendServer("Lua_TalentData", { data: { tp } });
}

function GetSlot(data) {
  if (!data) {
    return;
  }
  var left = 780;
  var bottom = 90;
  var panel = GetRoot();
  if (data.slot == 0) {
    left = 730;
    bottom = 90;
  }
  if (data.slot == 1) {
    left = 865;
    bottom = 90;
  }
  if (data.slot == 2) {
    left = 1000;
    bottom = 90;
  }
  if (data.slot == 3) {
    left = 730;
    bottom = 40;
  }
  if (data.slot == 4) {
    left = 865;
    bottom = 40;
  }
  if (data.slot == 5) {
    left = 1000;
    bottom = 40;
  }
  panel.style.marginLeft = left + "px";
  panel.style.marginBottom = bottom + "px";
}

function GetData(data) {
  GetRoot().style.opacity = data.bag_page;
  GetRoot().style.opacity = data.text_page;
  if (data.bag_page == 1) {
    GetPanel("up_img").style.opacity = data.up;
    GetPanel("kuang_img").style.opacity = data.up;
    if (data.sy == -1) {
      GetPanel("sy_num").text = "";
    } else {
      GetPanel("sy_num").text = data.sy;
    }
  }
}

(function () {
  // InitData();
  // SubEvent("UI_BagSlot", GetSlot);
  // SubEvent("UI_BagKill", GetData);
  // var panel = GetRoot();
  // panel.SetPanelEvent("onmouseover", function () {
  //   var tp = "show_tip";
  //   SendServer("Lua_TalentData", { data: { tp } });
  //   var tp2 = "drag";
  //   SendServer("Lua_TalentData", { data: { tp2 } });
  // });
  // panel.SetPanelEvent("onmouseout", function () {
  //   var tp = "close_tip";
  //   SendServer("Lua_TalentData", { data: { tp } });
  // });
})();
