function InitData() {
  var tp = "init";
  SendServer("Lua_BoxData", { data: { tp } });

  SendServer("Lua_TalentData", { data: { tp } });
}

function Draw() {
  var tp = "Draw";
  SendServer("Lua_BoxData", { data: { tp } });
}

function Run() {
  if (GetPanel("run_cd").opacity == 1) {
    return;
  }
  var tp = "Run";
  SendServer("Lua_BoxData", { data: { tp } });
}

function GetData(data) {
  if (!data) {
    return;
  }
  GetRoot().style.opacity = data.show;
}

function GetRunData(data) {
  var run_panel = GetPanel("run_cd");
  if (data.run_state == 1) {
    run_panel.style.opacity = 0;
  } else {
    run_panel.style.opacity = 1;
    run_panel.text = data.run_cd;
  }
}

function LevelUp() {
  var tp = "LevelUp";
  SendServer("Lua_TalentData", { data: { tp } });
}

/** 是否已选天赋装备，供宝箱旁 TalentBox hover 使用（与背包 item tip 同一路由） */
var g_talent_equip_hover_ok = false;

//临时修改ui
var hero_list = {
  "npc_dota_hero_ogre_magi": true
};

function TalentData(data) {
  if (!data) {
    return;
  }
  var img_path = "";
  if (data.select_talent == 0) {
    img_path = "raw://resource/flash3/images/items/item_goods_0_y.png";
    GetPanel("talent_num").style.opacity = 0;
    g_talent_equip_hover_ok = false;
  } else {
    img_path = GetItemIconTalentFlash3Path(data.item_name);
    GetPanel("talent_num").style.opacity = 1;
    g_talent_equip_hover_ok =
      !!data.item_name &&
      data.item_name !== "" &&
      data.item_name !== "item_goods_0";
  }
  if (data.up == 1) {
    GetPanel("up_img").style.opacity = 1;
  } else {
    GetPanel("up_img").style.opacity = 0;
  }
  if (data.sy == -1) {
    GetPanel("talent_num").style.opacity = 0;
  }
  GetPanel("talent_num").text = data.sy;
  GetPanel("talent_img").SetImage(img_path);
  if (hero_list[data.hero_name] == true) {
    GetRoot().style.marginLeft = "1475px";
  }
}

/** 与 Bag 一致：走 Lua ShowTip → UI_TipData / bagtipnew；slot_pos=6 为宝箱上天赋位 */
var g_talent_tip_close_timer = null;

function hoverTalentEquipTip() {
  var panel = GetPanel("talent_box");
  WhenOver(panel, function () {
    if (g_talent_tip_close_timer != null) {
      $.CancelScheduled(g_talent_tip_close_timer);
      g_talent_tip_close_timer = null;
    }
    if (!g_talent_equip_hover_ok) {
      return;
    }
    if (typeof slot_pos !== "undefined") {
      slot_pos = 6;
    }
    SendServer("Lua_TalentData", { data: { tp: "show_tip" } });
  });
  WhenOut(panel, function () {
    if (!g_talent_equip_hover_ok) {
      return;
    }
    if (g_talent_tip_close_timer != null) {
      $.CancelScheduled(g_talent_tip_close_timer);
      g_talent_tip_close_timer = null;
    }
    g_talent_tip_close_timer = $.Schedule(0.12, function () {
      g_talent_tip_close_timer = null;
      SendServer("Lua_TalentData", { data: { tp: "close_tip" } });
    });
  });
}

function hovershowboxdata() {
  WhenOver("boxpage", function () {
    BoxShow();
  });
  WhenOut("boxpage", function () {
    BoxHide();
  });
}

function BoxShow() {
  var cfg = GameUI.CustomUIConfig();
  if (cfg.Cancel_hide_box_bag) {
    cfg.Cancel_hide_box_bag();
  }
  if (cfg.Hover_show_box) {
    cfg.Hover_show_box();
  }
}
function BoxHide() {
  var cfg = GameUI.CustomUIConfig();
  if (cfg.Schedule_hide_box_bag) {
    cfg.Schedule_hide_box_bag();
  }
}

(function () {
  InitData();
  SubEvent("UI_Box", GetData);
  SubEvent("UI_RunBox", GetRunData);
  SubEvent("UI_Talent", TalentData);
  hovershowboxdata();
  hoverTalentEquipTip();
})();
