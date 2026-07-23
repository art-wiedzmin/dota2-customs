function InitData() {
  var tp = "init";
  SendServer("Lua_TalentData", { data: { tp } });
}

var item_name = {};
var slot_pos = 0;
function GetTipSlot(data) {
  if (data != "") {
    slot_pos = data.slot;
  }
}

var elsedata = {
  // 荆棘者之甲
  item_goods_18: {
    name: "荆棘之甲",
    attr_1: {
      attr_num: {
        0: "4",
        1: "8",
        2: "12",
        3: "16",
        4: "20",
        5: "24",
      },
      attr_name: "护甲",
    },
    attr_2: {
      attr_num: {
        0: "5%",
        1: "10%",
        2: "15%",
        3: "20%",
        4: "25%",
        5: "30%",
      },
      attr_name: "生命增幅",
    },
    // 被动名称
    atttext: "荆棘领域",
    text: "每次受到攻击时，都会对攻击自身的单位反弹 固定加上自身力量一定百分比的纯粹伤害。被攻击时添加 30% 吸血减半效果、600 码光环降低敌人 30% 吸血与治疗效果",
    awaytext: "0",
    awaynum: {
      0: "0",
      1: "0",
      2: "0",
      3: "0",
      4: "0",
      5: "0",
    },
    attr_3: {
      attr_num: {
        0: "40",
        1: "60",
        2: "80",
        3: "100",
        4: "120",
        5: "150",
      },
      attr_name: "反弹伤害:",
    },
    attr_4: {
      attr_num: {
        0: "5%",
        1: "10%",
        2: "15%",
        3: "20%",
        4: "25%",
        5: "30%",
      },
      attr_name: "力量伤害:",
    },
    timetext: "0",
    timenum: "0",
    toptext: "一件可以通过吸收血液逐渐强化的鲜血铠甲。",
  },
  // 严法师斗篷
  item_goods_19: {
    name: "炎术斗篷",
    attr_1: {
      attr_num: {
        0: "4%",
        1: "8%",
        2: "12%",
        3: "16%",
        4: "18%",
        5: "20%",
      },
      attr_name: "技能强度",
    },
    attr_2: {
      attr_num: {
        0: "15",
        1: "30",
        2: "45",
        3: "60",
        4: "75",
        5: "90",
      },
      attr_name: "基础作用范围",
    },
    // 被动名称
    atttext: "火焰灼烧",
    text: "每秒对周围敌方单位造成固定魔法伤害加上自身蓝量一定百分比的魔法伤害",
    // 范围
    awaytext: "作用范围:",
    awaynum: {
      0: "400",
      1: "450",
      2: "550",
      3: "600",
      4: "650",
      5: "700",
    },
    attr_3: {
      attr_num: {
        0: "30",
        1: "45",
        2: "60",
        3: "80+1.5%",
        4: "100+3%",
        5: "120+5%",
      },
      attr_name: "魔法伤害:",
    },
    attr_4: {
      attr_num: {
        0: "0%",
        1: "0%",
        2: "0%",
        3: "1.5%",
        4: "3%",
        5: "5%",
      },
      attr_name: "蓝量伤害:",
    },
    timetext: "0",
    timenum: "0",
    toptext: "一件可以通过吸收血液逐渐增强威力的火焰斗篷。",
  },
  // 迅捷之刃
  item_goods_17: {
    name: "迅捷之刃",
    attr_1: {
      attr_num: {
        0: "30",
        1: "45",
        2: "60",
        3: "80",
        4: "110",
        5: "150",
      },
      attr_name: "攻速",
    },
    attr_2: {
      attr_num: {
        0: "15",
        1: "30",
        2: "45",
        3: "60",
        4: "75",
        5: "90",
      },
      attr_name: "基础移速",
    },
    awaytext: "0",
    awaynum: {
      0: "0",
      1: "0",
      2: "0",
      3: "0",
      4: "0",
      5: "0",
    },
    // 被动名称
    atttext: "迅捷之力",
    text: "攻击时无视目标部分护甲，并有15%概率额外造成一次攻击力系数的物理伤害，每次攻击给目标添加一层持续3秒的伤害加深效果",
    attr_3: {
      attr_num: {
        0: "5%",
        1: "10%",
        2: "15%",
        3: "20%",
        4: "25%",
        5: "30%",
      },
      attr_name: "护甲穿透:",
    },
    attr_4: {
      attr_num: {
        0: "0.6",
        1: "0.8",
        2: "1.0",
        3: "1.2",
        4: "1.4",
        5: "1.6",
      },
      attr_name: "攻击伤害:",
    },
    timetext: "伤害加深：",
    timenum: "1%",
    toptext: "一件可以通过净化血液逐渐蜕变的雷霆之刃。",
  },
  item_goods_24: {
    name: "雷电戟",
    attr_1: {
      attr_num: {
        0: "6",
        1: "12",
        2: "18",
        3: "24",
        4: "30",
        5: "36",
      },
      attr_name: "全属性",
    },
    attr_2: {
      attr_num: {
        0: "25",
        1: "50",
        2: "75",
        3: "100",
        4: "125",
        5: "150",
      },
      attr_name: "雷电伤害",
    },
    awaytext: "0",
    awaynum: {
      0: "0",
      1: "0",
      2: "0",
      3: "0",
      4: "0",
      5: "0",
    },
    atttext: "连锁闪电",
    text: "攻击附带雷电魔法伤害；20% 概率释放连锁闪电，对目标 650 范围内最多 5 名敌人造成魔法伤害，并麻痹主目标0.3秒，造成减少90%移速效果",
    attr_3: {
      attr_num: {
        0: "80",
        1: "120",
        2: "160",
        3: "200",
        4: "240",
        5: "300",
      },
      attr_name: "闪电伤害:",
    },
    attr_4: {
      attr_num: {
        0: "0.1",
        1: "0.2",
        2: "0.3",
        3: "0.4",
        4: "0.5",
        5: "0.6",
      },
      attr_name: "全属性系数:",
    },
    timetext: "0",
    timenum: "0",
    toptext: "一柄引雷附体的战戟，随杀戮不断积蓄雷霆之力。",
  },
};

if (typeof ClrbApplyTalentEquipBaseToElsedata === "function") {
  ClrbApplyTalentEquipBaseToElsedata(elsedata);
}

var color_list = {
  1: "#636E7C",
  2: "#00FF00",
  3: "#006DFF",
  4: "#FF16F1",
  5: "#FF0000",
};
var rank_lv = {
  1: "D",
  2: "C",
  3: "B",
  4: "A",
  5: "S",
};
function GetTipData(data) {
  var rootBox = GetPanel("root_box");
  if (!data) {
    rootBox.style.visibility = "collapse";
    return;
  }
  GetRoot().style.opacity = data.page;
  if (data.item_name === "" || data.page !== 1) {
    rootBox.style.visibility = "collapse";
    return;
  }
  rootBox.style.visibility = "visible";

  Timers(0.05, function () {
    // GetRoot().style.marginLeft = "0px";
    GetPanel("bag_tip").style.position = "0px 0px 0px 108px"
    if (slot_pos == 0) {
      GetPanel("root_box").style.marginLeft = "1350px";
      GetPanel("root_box").style.marginBottom = "20px";
      GetPanel("jiantou").style.marginBottom = "80px";
    } else if (slot_pos == 1) {
      GetPanel("root_box").style.marginLeft = "1410px";
      GetPanel("root_box").style.marginBottom = "20px";
      GetPanel("jiantou").style.marginBottom = "80px";
      // GetRoot().style.marginLeft = "1500px";
    } else if (slot_pos == 2) {
      GetPanel("root_box").style.marginLeft = "1480px";
      GetPanel("root_box").style.marginBottom = "20px";
      GetPanel("jiantou").style.marginBottom = "80px";
    } else if (slot_pos == 3) {
      GetPanel("root_box").style.marginLeft = "1350px";
      GetPanel("root_box").style.marginBottom = "10px";
      GetPanel("jiantou").style.marginBottom = "53px";
    } else if (slot_pos == 4) {
      GetPanel("root_box").style.marginLeft = "1410px";
      GetPanel("root_box").style.marginBottom = "10px";
      GetPanel("jiantou").style.marginBottom = "53px";
    } else if (slot_pos == 5) {
      GetPanel("root_box").style.marginLeft = "1480px";
      GetPanel("root_box").style.marginBottom = "10px";
      GetPanel("jiantou").style.marginBottom = "53px";
    } else if (slot_pos == 6) {
      /* BoxFun 天赋图标（root ~1130px）：tip 偏左上避免挡宝箱 */
      GetPanel("root_box").style.marginLeft = "1190px";
      GetPanel("root_box").style.marginBottom = "118px";
      GetPanel("jiantou").style.marginBottom = "88px";
    } else {
      GetPanel("root_box").style.marginLeft = "1540px";
      GetPanel("root_box").style.marginBottom = "45px";
      GetPanel("jiantou").style.marginBottom = "88px";
    }
  })




  if (data.page == 1) {
    // 没有升级的词条
    var attrlength = Length(data.attr);
    var attrpanel = GetPanel("attr_list_box");
    attrpanel.RemoveAndDeleteChildren();
    if (attrlength == 0) {
      GetPanel("attr_list_box").visible = false;
    } else {
      GetPanel("attr_list_box").visible = true;
      for (var i = 1; i <= attrlength; i++) {
        var sonpanel = NewPanel(attrpanel, "attr_list_" + i, "Panel");
        sonpanel.AddClass("attr_list_panel");
        sonpanel.hittest = false;
        sonpanel.RemoveAndDeleteChildren();
        sonpanel.BLoadLayoutSnippet("citiaosnippet");
        //     if (name == "gjjg") {
        //   value = value.toFixed(2);
        // }
        if (data.attr["slot_" + i].name == "gjjg") {
          sonpanel.FindChildTraverse("attr_num").text =
            "+ " + data.attr["slot_" + i].value.toFixed(2);
        } else {
          sonpanel.FindChildTraverse("attr_num").text =
            "+ " + data.attr["slot_" + i].value;
        }

        sonpanel.FindChildTraverse("attr_name").text = Local(
          data.attr["slot_" + i].name
        );
        var lv = data.attr["slot_" + i].rank.split("_")[1];
        // sonpanel.FindChildTraverse("attr_lv").text = "T" + lv;
        sonpanel.FindChildTraverse("attr_lv").text = rank_lv[lv];
        sonpanel.FindChildTraverse("attr_lv").style.color = color_list[lv];
        sonpanel.FindChildTraverse("attr_name").style.color = color_list[lv];
      }
    }
    // 显示信息
    var item = data.item_name;
    // 等级
    var itemlv = data.level;
    // 静态数据（铁匠等由服务端 clrb_talent_equip_tip 覆盖基础属性条）
    var itemdata = ClrbApplyTalentEquipTipNums(item, elsedata[item]);
    // 名字
    GetPanel("tip_name").text = itemdata.name;
    GetPanel("jineng_bottom_text").text = itemdata.atttext;
    GetPanel("jineng_text_label").text = itemdata.text;
    GetPanel("fanwei_name").text = itemdata.awaytext;
    // GetPanel("fanwei_num").text = itemdata.awaynum;
    GetPanel("shijian_name").text = itemdata.timetext;
    GetPanel("shijian_num").text = itemdata.timenum;

    // print(itemdata)
    // 斗篷范围
    var fwpanel = GetPanel("fanwei_list");
    fwpanel.RemoveAndDeleteChildren();
    var fw_length = Length(itemdata.awaynum);
    for (var i = 0; i < fw_length; i++) {
      var sonpanel_e = NewPanel(fwpanel, "fw_text_e_" + i, "Label");
      var sonpanel = NewPanel(fwpanel, "fw_text_" + i, "Label");
      sonpanel_e.hittest = false;
      sonpanel.hittest = false;

      sonpanel_e.AddClass("citiao_text");
      sonpanel.AddClass("citiao_text");
      sonpanel.text = itemdata.awaynum[i];
      sonpanel_e.text = "/";

      if (itemlv == i) {
        sonpanel.AddClass("light");
      } else {
        sonpanel.RemoveClass("light");
      }
    }
    fwpanel.GetChild(0).visible = false;

    // 词条1
    var ctpanel_1 = GetPanel("citiao_list_1");
    ctpanel_1.RemoveAndDeleteChildren();
    var citi_1_length = Length(itemdata.attr_1.attr_num);
    for (var i = 0; i < citi_1_length; i++) {
      var sonpanel_e = NewPanel(ctpanel_1, "citiao_text_e_" + i, "Label");
      var sonpanel = NewPanel(ctpanel_1, "citiao_text_" + i, "Label");
      sonpanel_e.hittest = false;
      sonpanel.hittest = false;

      sonpanel_e.AddClass("citiao_text");
      sonpanel.AddClass("citiao_text");
      sonpanel.text = itemdata.attr_1.attr_num[i];
      sonpanel_e.text = "/";

      if (itemlv == i) {
        sonpanel.AddClass("light");
      } else {
        sonpanel.RemoveClass("light");
      }
    }
    ctpanel_1.GetChild(0).visible = false;
    GetPanel("citiao_panel_1").FindChildTraverse("citiao_name_1").text =
      itemdata.attr_1.attr_name;

    // 词条2

    var ctpanel_2 = GetPanel("citiao_list_2");
    // print(ctpanel_2.id)
    ctpanel_2.RemoveAndDeleteChildren();
    if (itemdata.attr_2) {
      GetPanel("citiao_panel_2").visible = true;

      var citi_2_length = Length(itemdata.attr_2.attr_num);
      for (var i = 0; i < citi_2_length; i++) {
        var sonpanel_e = NewPanel(ctpanel_2, "citiao_text_e_" + i, "Label");
        var sonpanel = NewPanel(ctpanel_2, "citiao_text_" + i, "Label");
        sonpanel_e.hittest = false;
        sonpanel.hittest = false;

        sonpanel_e.AddClass("citiao_text");
        sonpanel.AddClass("citiao_text");
        sonpanel.text = itemdata.attr_2.attr_num[i];
        sonpanel_e.text = "/";

        if (itemlv == i) {
          sonpanel.AddClass("light");
        } else {
          sonpanel.RemoveClass("light");
        }
      }
      ctpanel_2.GetChild(0).visible = false;
      GetPanel("citiao_panel_2").FindChildTraverse("citiao_name_2").text =
        itemdata.attr_2.attr_name;
    } else {
      GetPanel("citiao_panel_2").visible = false;
      GetPanel("citiao_panel_2").FindChildTraverse("citiao_name_2").text = "";
    }

    // 词条3
    var ctpanel_3 = GetPanel("citiao_list_3");
    ctpanel_3.RemoveAndDeleteChildren();
    var citi_3_length = Length(itemdata.attr_3.attr_num);
    for (var i = 0; i < citi_3_length; i++) {
      var sonpanel_e = NewPanel(ctpanel_3, "citiao_text_e_" + i, "Label");
      var sonpanel = NewPanel(ctpanel_3, "citiao_text_" + i, "Label");
      sonpanel_e.hittest = false;
      sonpanel.hittest = false;

      sonpanel_e.AddClass("citiao_text");
      sonpanel.AddClass("citiao_text");
      sonpanel.text = itemdata.attr_3.attr_num[i];
      sonpanel_e.text = "/";

      if (itemlv == i) {
        sonpanel.AddClass("light");
      } else {
        sonpanel.RemoveClass("light");
      }
    }
    ctpanel_3.GetChild(0).visible = false;
    GetPanel("citiao_panel_3").FindChildTraverse("citiao_panel_3_name").text =
      itemdata.attr_3.attr_name;
    // 词条4
    var ctpanel_4 = GetPanel("citiao_list_4");
    ctpanel_4.RemoveAndDeleteChildren();
    var citi_4_length = Length(itemdata.attr_4.attr_num);
    for (var i = 0; i < citi_4_length; i++) {
      var sonpanel_e = NewPanel(ctpanel_4, "citiao_text_e_" + i, "Label");
      var sonpanel = NewPanel(ctpanel_4, "citiao_text_" + i, "Label");
      sonpanel_e.hittest = false;
      sonpanel.hittest = false;

      sonpanel_e.AddClass("citiao_text");
      sonpanel.AddClass("citiao_text");
      sonpanel.text = itemdata.attr_4.attr_num[i];
      sonpanel_e.text = "/";

      if (itemlv == i) {
        sonpanel.AddClass("light");
      } else {
        sonpanel.RemoveClass("light");
      }
    }
    ctpanel_4.GetChild(0).visible = false;
    GetPanel("citiao_panel_4").FindChildTraverse("citiao_panel_4_name").text =
      itemdata.attr_4.attr_name;

    GetPanel("bottom_panel_text").text = itemdata.toptext;

    // item_goods_17 迅捷之刃
    // item_goods_18 荆棘者之甲
    // item_goods_19 法师斗篷
    if (item == "item_goods_17") {
      GetPanel("citiao_panel_2").visible = true;
      GetPanel("fanwei").visible = false;
    } else if (item == "item_goods_18") {
      GetPanel("citiao_panel_2").visible = true;
      GetPanel("shijian").visible = false;
      GetPanel("fanwei").visible = false;
    } else if (item == "item_goods_19") {
      GetPanel("citiao_panel_2").visible = true;
      GetPanel("shijian").visible = false;
    } else if (item == "item_goods_24") {
      GetPanel("citiao_panel_2").visible = true;
      GetPanel("shijian").visible = false;
      GetPanel("fanwei").visible = false;
    }
  }

  var item_name = data.item_name;
  var item_main_name = item_name + "_" + data.level;
  var item_main_attr = item_name + "_" + data.level + "_attr";
  //print(item_main_name);
  //print(item_main_attr);
  var path = GetItemIconFlash3Path(item_name);
  GetPanel("tip_img").SetImage(path);
  // GetPanel("tip_name").text = Local(item_main_name);
  // GetPanel("main_attr").text = Local(item_main_attr);
  SetAttr(data.attr);
}

function SetAttr(data) {
  if (!data) {
    return;
  }
  //   var panel = GetPanel("attr_list");
  //   panel.RemoveAndDeleteChildren();
  //   $.Each(data, function (v, k) {
  //     var attr_key = "attr_" + k;
  //     var sonpanel = NewPanel(panel, attr_key, "Panel");
  //     sonpanel.BLoadLayoutSnippet("attr_data");
  //     sonpanel.FindChildTraverse("attr_name").text = Local(v.name);
  //     sonpanel.FindChildTraverse("attr_num").text = v.value;
  //   });
}

(function () {
  InitData();
  SubEvent("UI_BagSlot", GetTipSlot);
  SubEvent("UI_TipData", GetTipData);
})();
