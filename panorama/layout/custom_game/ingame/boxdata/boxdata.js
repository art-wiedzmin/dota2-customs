--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


var ItemList = {
  item_0: "item_box_0",
  item_1: "item_yasha",
  item_2: "item_sange",
  item_3: "item_kaya",
  item_4: "item_box_4",
  item_5: "item_lesser_crit",
  item_6: "item_cloak",
  item_7: "item_maelstrom",
  item_8: "item_dragon_lance",
  item_9: "item_vladmir",
  item_10: "item_chipped_vest",
  item_11: "item_poor_mans_shield",
  item_12: "item_boots",
  item_13: "item_broadsword",
  item_14: "item_lifesteal",
  item_15: "item_wraith_band",
  item_16: "item_bracer",
  item_17: "item_null_talisman",
  item_18: "item_orb_of_corrosion",
  item_19: "item_javelin",
  item_20: "item_helm_of_iron_will",
  item_21: "item_talisman_of_evasion",
  item_22: "item_sange_and_yasha",
  item_23: "item_yasha_and_kaya",
  item_24: "item_eternal_shroud",
  item_25: "item_sphere",
  item_26: "item_mage_slayer",
  item_27: "item_box_27",
  item_28: "item_mind_breaker",
  item_29: "item_princes_knife",
  item_30: "item_basher",
  item_31: "item_relic",
  item_32: "item_spell_prism",
  item_33: "item_witch_blade",
  item_34: "item_maelstrom",
  item_35: "item_magnifying_monocle",
  item_36: "item_box_36",
  item_37: "item_travel_boots",
  item_38: "item_vladmir",
  item_39: "item_hyperstone",
  item_40: "item_whisper_of_the_dread",
  item_41: "item_ballista",
  item_42: "item_trident",
  item_43: "item_rapier",
  item_44: "item_devastator",
  item_45: "item_greater_crit",
  item_46: "item_butterfly",
  item_47: "item_box_47",
  item_48: "item_box_48",
  item_49: "item_monkey_king_bar",
  item_50: "item_platemail",
  item_51: "item_demon_edge",
  item_52: "item_eagle",
  item_53: "item_revenants_brooch",
  item_54: "item_box_54",
  item_55: "item_box_55",
  item_56: "item_box_56",
  item_57: "item_box_57",
  item_58: "item_box_58",
  item_59: "item_box_59",
  item_60: "item_box_60",
  item_61: "item_box_61",
  item_62: "item_box_62",
  item_63: "item_ultimate_orb",
  item_64: "item_skadi",
  item_65: "item_vanguard",
  item_66: "item_dragon_lance",
  item_67: "item_echo_sabre",
  item_68: "item_soul_booster",
  item_69: "item_octarine_core",
  item_70: "item_mjollnir",
  item_71: "item_bfury",
  item_72: "item_radiance",
  item_73: "item_mithril_hammer",
  item_74: "item_desolator",
  item_75: "item_shivas_guard",
  item_76: "item_assault",
  item_77: "item_ring_of_tarrasque",
  item_78: "item_heart",
  item_79: "item_aether_lens",
  item_80: "item_quicksilver_amulet",
  item_81: "item_dezun_bloodrite",
  item_82: "item_penta_edged_sword",
  item_83: "item_timeless_relic",
  item_84: "item_disperser",
  item_85: "item_sphere",
  item_86: "item_princes_knife",
  item_87: "item_witch_blade",
  item_88: "item_devastator",
  item_89: "item_giants_ring",
  item_90: "item_hydras_breath",
  item_91: "item_equip_4",
  item_92: "item_box_92",
  item_69: "item_octarine_core"
};

var boxdata = {
  slot_1: -1,
  slot_2: -1,
  slot_3: -1,
  slot_4: -1,
  slot_5: -1,
  slot_6: -1,
  slot_7: -1,
  slot_8: -1,
  slot_9: -1,
  slot_10: -1,
  slot_11: -1,
  slot_12: -1,
};

var bagdata = {
  slot_1: -1,
  slot_2: -1,
  slot_3: -1,
  slot_4: -1,
  slot_5: -1,
  slot_6: -1,
};

var night = {
  slot_1: 0,
  slot_2: 0,
  slot_3: 0,
  slot_4: 0,
  slot_5: 0,
  slot_6: 0,
  slot_7: 0,
  slot_8: 0,
  slot_9: 0,
  slot_10: 0,
  slot_11: 0,
  slot_12: 0,
};

var updata = {
  item_1: 22,
  item_2: 22,
  item_3: 23,
  // item_4: 41,
  item_5: 45,
  item_7: 70,
  item_6: 24,
  item_12: 37,
  item_13: 71,
  item_19: 49,
  item_21: 72,
  item_73: 74,
  item_74: 48,
  item_7: 70,
  item_50: 75,
  item_52: 46,
  item_39: 76,
  item_22: 42,
  item_23: 42,
  item_31: 43,
  item_63: 64,
  item_77: 78,
  item_8: 90,
  item_37: 91,
};

function boxPageToOpacity(pageVal) {
  if (pageVal === 1 || pageVal === true || pageVal === "1") {
    return 1;
  }
  return 0;
}

function InitData() {
  var tp = "init";
  SendServer("Lua_BoxData", { data: { tp } });
  //加载点亮
  LoadNight();
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  SendServer("Lua_BoxData", { data: { tp } });
}

//关闭页面
function ClosePage() {
  HideGiveUpConfirm();
  var tp = "ClosePage";
  SendServer("Lua_BoxData", { data: { tp } });
}

function ShowGiveUpConfirm() {
  var mask = GetPanel("give_up_confirm_mask");
  if (!mask) {
    return;
  }
  mask.visible = true;
  mask.hittest = true;
  mask.style.visibility = "visible";
}

function HideGiveUpConfirm() {
  var mask = GetPanel("give_up_confirm_mask");
  if (!mask) {
    return;
  }
  mask.visible = false;
  mask.hittest = false;
  mask.style.visibility = "collapse";
}

function ConfirmGiveUp() {
  HideGiveUpConfirm();
  hidepanel();
  var tp = "GiveUp";
  SendServer("Lua_BoxData", { data: { tp } });
}

var g_giveUpUiBound = false;

function BindGiveUpUi() {
  if (g_giveUpUiBound) {
    return;
  }
  var btn = GetPanel("give_up_btn");
  var noBtn = GetPanel("give_up_confirm_no");
  var yesBtn = GetPanel("give_up_confirm_yes");
  if (!btn) {
    $.Schedule(0.1, BindGiveUpUi);
    return;
  }
  g_giveUpUiBound = true;
  btn.SetPanelEvent("onactivate", function () {
    ShowGiveUpConfirm();
  });
  if (noBtn) {
    noBtn.SetPanelEvent("onactivate", function () {
      HideGiveUpConfirm();
    });
  }
  if (yesBtn) {
    yesBtn.SetPanelEvent("onactivate", function () {
      ConfirmGiveUp();
    });
  }
}

//随机宝物
function DrawRoll() {
  // ClearNight(1); //清除点亮
  hidepanel();
  var tp = "DrawRoll";
  SendServer("Lua_BoxData", { data: { tp } });
}

//选择宝物
function Select(num) {
  var tp = "Select";
  var text = "slot_" + num;
  SendServer("Lua_BoxData", { data: { tp, text } });
  hidepanel();
}

//摧毁宝物
function BreakItem(slot) {
  var tp = "BreakItem";
  var text = "slot_" + slot;
  SendServer("Lua_BoxData", { data: { tp, text } });
  hidepanel();
}

// 显示物品工具提示
function BoxTip(slot) {
  var slot_key = "slot_" + slot;
  var panel = GetPanel(slot_key);
  var item_id = boxdata[slot_key];
  if (item_id == -1) {
    return;
  }
  var item_key = "item_" + item_id;
  var item_name = ItemList[item_key];
  //如果是升级物品，显示升级信息
  IsUpItem(item_id);
  // $.DispatchEvent("DOTAHUDShowHeroStatBranchTooltip", panel, 20);
  $.DispatchEvent("DOTAShowAbilityTooltip", panel, item_name);
  panel.style.tooltipPosition = "left";
}

function BagTip(slot) {
  var slot_key = "slot_" + slot;
  var item_id = bagdata[slot_key];
  var bag_slot_key = "bag_slot_" + slot;
  var panel = GetPanel(bag_slot_key);
  if (item_id == -1) {
    return;
  }
  tipnum = slot;
  var item_key = "item_" + item_id;
  var item_name = ItemList[item_key];
  //如果是升级物品，显示升级信息
  IsUpItem(item_id);
  $.DispatchEvent("DOTAShowAbilityTooltip", panel, item_name);
}

// 隐藏工具提示
function HideTip() {
  var up_panel = GetPanel("up_page");
  up_panel.style.opacity = 0;
  var panel = $.GetContextPanel();
  $.DispatchEvent("DOTAHideAbilityTooltip", panel);
}

function IsUpItem(item_id) {
  var item_key = "item_" + item_id;

  $.Each(updata, function (v, k) {
    if (item_key == k) {
      var up_panel = GetPanel("up_page");
      up_panel.style.opacity = 1;
      var slot_1_panel = GetPanel("up_slot_1");
      var slot_2_panel = GetPanel("up_slot_2");
      var up_item_id = updata[item_key];
      path1 = "raw://resource/flash3/images/items/item_box_" + item_id + ".png";
      path2 =
        "raw://resource/flash3/images/items/item_box_" + up_item_id + ".png";
      slot_1_panel.SetImage(path1);
      slot_2_panel.SetImage(path2);
      GetPanel();
      return;
    }
  });
}

var Movie = false;
// 是否是数据开启的 默认未开启
var dataopen = 0;
function GetData(data) {
  if (!data) {
    return;
  }
  // if (data.box_sy_draw <= 0) {
  //   movie_state = false;
  // } else {
  //   movie_state = true;
  // }
  //print(data.list);
  var op = boxPageToOpacity(data.page);
  GetRoot().style.opacity = op;
  GetPanel("center_box").style.opacity = op;
  dataopen = op;
  var giveUpBtn = GetPanel("give_up_btn");
  if (giveUpBtn) {
    giveUpBtn.visible = op === 1;
  }
  if (op === 1) {
    BindGiveUpUi();
  } else {
    HideGiveUpConfirm();
  }
  //清空缓存
  ClearNight(data.clear);
  //加载宝箱物品
  LoadBoxItem(data.list);
  //加载高亮物品
  SetLightItem(data.list, data.movie);
  //加载背包物品
  LoadBagItem(data.bag);
  // print(data.bag)

  GetPanel("draw_num").text = "x" + data.cost;
  //print(data.list);
}

var g_box_bag_hide_timer = null;
var BOX_BAG_HIDE_DELAY = 0.06;

function cancelHideBoxBagHover() {
  if (g_box_bag_hide_timer != null) {
    $.CancelScheduled(g_box_bag_hide_timer);
    g_box_bag_hide_timer = null;
  }
}

function hideBoxBagHover() {
  cancelHideBoxBagHover();
  hidepanel();
  if (dataopen == 0) {
    GetRoot().style.opacity = 0;
    GetPanel("center_box").style.opacity = 1;
  }
}

/** 鼠标在宝箱图标或右侧背包区：显示背包栏 */
function showBoxBagHover() {
  cancelHideBoxBagHover();
  if (dataopen == 0) {
    GetRoot().style.opacity = 1;
    GetPanel("center_box").style.opacity = 0;
  }
}

/** 离开宝箱/背包区后短延迟隐藏，便于在两区域间移动 */
function scheduleHideBoxBagHover() {
  cancelHideBoxBagHover();
  g_box_bag_hide_timer = $.Schedule(BOX_BAG_HIDE_DELAY, function () {
    g_box_bag_hide_timer = null;
    hideBoxBagHover();
  });
}

function bindBoxBagHoverZones() {
  var rightPage = GetPanel("RightPage");
  if (!rightPage) {
    return;
  }
  WhenOver(rightPage, showBoxBagHover);
  WhenOut(rightPage, scheduleHideBoxBagHover);
}

// 开启宝箱（兼容 Hover_show_box）
function hovershowbox() {
  showBoxBagHover();
}

function ClickHide() {
  // var rootPanel = $.GetContextPanel();
  //   var contentPanel = rootPanel.FindChildTraverse("RightPage");
  //   // 根面板点击：隐藏内容
  //   rootPanel.SetPanelEvent("onactivate", function() {
  //       // 检查当前获得焦点的面板是不是我们的按钮
  //       // contentPanel.style.visibility = "collapse";
  //     if (isClicking) {
  //             GetRoot().style.opacity = 0;
  //             GetPanel("center_box").style.opacity = 1;
  //             // 重置标记，阻止隐藏逻辑
  //             isClicking = false;
  //             return;
  //         }
  //   });
}

//加载宝箱内容
function LoadBoxItem(data) {
  //设置宝箱内容
  $.Each(data, function (v, k) {
    var panel = GetPanel(k);
    var path = "raw://resource/flash3/images/items/item_null.png";
    if (v.item != -1) {
      path = "raw://resource/flash3/images/items/item_box_" + v.item + ".png";
      boxdata[k] = v.item;
    } else {
      boxdata[k] = -1;
    }
    panel.SetImage(path);

    var pa = k + "_label";
    var item_key = "item_" + v.item;
    GetPanel(pa).visible = false;
    $.Each(updata, function (i, j) {
      if (item_key == j) {
        GetPanel(pa).visible = true;
      } else {
        // GetPanel(pa).visible = false;
      }
    });
  });
}

//清空缓存
function ClearNight(clear) {
  if (clear == 1) {
    //print("清理缓存");
    $.Each(night, function (v, k) {
      var panel = GetPanel(k);
      night[k] = 0;
      panel.style.brightness = 0.1;
      // panel.style.border = "1px solid gray";
      panel.GetParent().RemoveClass("lightimg");
    });
  }
}

// var movie_state = true;

//播放动画以及延迟加载
function SetLightItem(data, movie) {
  // if (movie_state == false) {
  //   return;
  // }

  //延迟加载时间
  if (movie == 1) {
    //1秒动画
    NightMovie();
  }

  //1秒后加载物品
  Timers(0.6, function () {
    $.Each(data, function (v, k) {
      if (v.light == 1) {
        night[k] = 1;
      } else {
        night[k] = 0;
      }
    });
    Timers(0.1, function () {
      //第一次加载点亮
      LoadNight();
      Timers(0.1, function () {
        //第二次加载点亮
        LoadNight();
      });
    });
  });
}

//加载物品点亮缓存
function LoadNight() {
  $.Each(night, function (v, k) {
    var panel = GetPanel(k);
    if (v == 1) {
      panel.style.brightness = 1.5;
      // panel.style.border = "2px solid yellow";
      panel.GetParent().AddClass("lightimg");
    } else {
      panel.style.brightness = 0.1;
      // panel.style.border = "1px solid gray";
      panel.GetParent().RemoveClass("lightimg");
    }
  });
}

//获取所有未点亮的物品
function NoNightItem() {
  var list = [];
  $.Each(night, function (v, k) {
    if (v == 0) {
      list.push(k);
    }
  });
  return list;
}

//roll次数
var roll_count = 5;
var old_slot = "";
function NightMovie() {
  Timers(0.1, function () {
    if (roll_count <= 0) {
      roll_count = 5;
      return;
    }
    var list = NoNightItem();
    //复制一份数组
    var new_list = [];
    for (var i = 0; i < list.length; i++) {
      new_list[i] = list[i];
    }
    for (var i = 0; i < new_list.length; i++) {
      if (new_list[i] == old_slot) {
        new_list.splice(i, 1);
      }
    }
    //print(new_list);
    //随机一个槽位
    var val = new_list[Math.floor(Math.random() * new_list.length)];
    var panel = GetPanel(val);
    // panel.style.border = "2px solid yellow";
    if (panel) {
      panel.GetParent().AddClass("lightimg");
      panel.style.brightness = 1.5;
    } else {
      return;
    }

    Timers(0.1, function () {
      // panel.style.border = "1px solid gray";
      panel.GetParent().RemoveClass("lightimg");
      panel.style.brightness = 0.1;
    });
    //记录旧的槽位
    old_slot = val;
    roll_count = roll_count - 1;
    NightMovie();
  });
}

function LoadBagItem(data) {
  for (i = 1; i <= 6; i++) {
    var key = "slot_" + i;
    var panel_name = "bag_" + key;
    var panel = GetPanel(panel_name);
    var va = data[key];
    // var path = "raw://resource/flash3/images/items/item_null.png";
    var path = "";
    panel.state = 0;
    if (va !== -1) {
      path = "raw://resource/flash3/images/items/item_box_" + va + ".png";
      bagdata[key] = va;
      panel.state = va;
      ClickShowTipSmall(panel);
    } else {
      bagdata[key] = -1;
    }
    panel.SetImage(path);
  }
}
var mardata = {
  bag_slot_1: {
    left: "65",
    top: "75",
  },
  bag_slot_2: {
    left: "130",
    top: "75",
  },
  bag_slot_3: {
    left: "195",
    top: "75",
  },
  bag_slot_4: {
    left: "65",
    top: "125",
  },
  bag_slot_5: {
    left: "130",
    top: "125",
  },
  bag_slot_6: {
    left: "195",
    top: "125",
  },
};
function ShowTipSmall(panel) {
  WhenOver(panel, function () {
    pendingBagDestroySlot = null;
    GetPanel("hover_cost_panel").visible = true;
    GetPanel("hover_cost_panel").style.marginLeft =
      mardata[panel.id].left + "px";
    GetPanel("hover_cost_panel").style.marginTop = mardata[panel.id].top + "px";
  });
  WhenOut(panel, function () {
    var sid = panel.id.split("_")[2];
    if (pendingBagDestroySlot !== null && pendingBagDestroySlot === sid) {
      return;
    }
    GetPanel("hover_cost_panel").visible = false;
  });
}

var isClickingButton = false;
// 右键摧毁：先弹出「摧毁」按钮，点击后再发 BreakItem（二次确认）
var pendingBagDestroySlot = null;
var tipnum = 0;
var selfnum = 0;
function ClickShowTipSmall(panel) {
  WhenActive(panel, function () {
    hidepanel();
  });
  panel.SetPanelEvent("oncontextmenu", function () {
    if (panel.state == 0) {
      ClickHideTip();
      return;
    }
    var slot = panel.id.split("_")[2];
    $.DispatchEvent("DOTAHideAbilityTooltip", $.GetContextPanel());
    isClickingButton = false;
    tipnum = slot;
    selfnum = slot;
    pendingBagDestroySlot = slot;
    var hcp = GetPanel("hover_cost_panel");
    var pos = mardata[panel.id];
    if (pos) {
      hcp.style.marginLeft = pos.left + "px";
      hcp.style.marginTop = pos.top + "px";
    }
    hcp.style.visibility = "visible";
    hcp.visible = true;
  });
}
function BreakItemFun() {
  isClickingButton = true;
  if (selfnum == 0 || !selfnum) {
    isClickingButton = false;
    return;
  }
  BreakItem(selfnum);
}
// 点击其他地方隐藏摧毁功能块
function ClickHideTip() {
  var rootPanel = $.GetContextPanel();
  var contentPanel = rootPanel.FindChildTraverse("hover_cost_panel");
  // 根面板点击：隐藏内容
  rootPanel.SetPanelEvent("onactivate", function () {
    // 检查当前获得焦点的面板是不是我们的按钮
    if (isClickingButton) {
      // 重置标记，阻止隐藏逻辑
      isClickingButton = false;
      return;
    }
    pendingBagDestroySlot = null;
    contentPanel.style.visibility = "collapse";
    GetPanel("hover_cost_panel").visible = false;
  });
}
function hidepanel() {
  pendingBagDestroySlot = null;
  GetPanel("hover_cost_panel").visible = false;
  isClickingButton = false;
}
// tip
// function UI_ShowPetTooltip() {
// 	var pa=$.GetContextPanel();
// 		WhenOver(pa,function(){
//             if(Content!==-1){
//                 var PetTipId = Content.petIndex;
//                 var PetType="BagTip";
//                 $.DispatchEvent("UIShowCustomLayoutParametersTooltip",pa,"Bag_Pet_Tips","file://{resources}/layout/custom_game/outsider/pet/pettip/pettip.xml","PetTipId="+PetTipId+"&PetType="+PetType)
//             }
// 		})
// 		WhenOut(pa,function(){
// 				$.DispatchEvent("UIHideCustomLayoutTooltip","Bag_Pet_Tips")
// 		})
// }

// // tip隐藏
// function UI_HidePetTooltip() {
//    $.DispatchEvent("UIHideCustomLayoutTooltip","Bag_Pet_Tips")
// }

// 悬浮显示提示
function HoverFun(pa) {
  WhenOver(pa, function () {
    GetPanel("hover_panel").visible = true;
  });
  WhenOut(pa, function () {
    GetPanel("hover_panel").visible = false;
  });
}
HoverFun("hover_icon");

(function () {
  //print("BoxData");
  InitData();
  BindGiveUpUi();
  bindBoxBagHoverZones();
  SubEvent("UI_Box", GetData);
  var cfg = GameUI.CustomUIConfig();
  cfg.Hover_show_box = showBoxBagHover;
  cfg.Hide_box_bag_hover = hideBoxBagHover;
  cfg.Schedule_hide_box_bag = scheduleHideBoxBagHover;
  cfg.Cancel_hide_box_bag = cancelHideBoxBagHover;
})();