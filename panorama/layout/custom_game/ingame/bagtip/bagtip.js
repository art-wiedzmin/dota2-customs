function InitData() {
  var tp = "init";
  SendServer("Lua_TalentData", { data: { tp } });
}

var item_name = {};
var slot_pos=0;
function GetTipSlot(data){
  
  if(data!=""){
    slot_pos = data.slot;
  }

}

var elsedata={
  // 荆棘者之甲
  item_goods_18:{
    name:"荆棘者之甲",
    attr_1:{
        attr_num:{
          0:"2",
          1:"4",
          2:"6",
          3:"8",
          4:"10",
          5:"12",
        },
        attr_name:"护甲", 
    },
    attr_2:{
        attr_num:{
          0:"5",
          1:"10",
          2:"15",
          3:"20",
          4:"25",
          5:"30",
        },
        attr_name:"生命回复", 
    },
    // 被动名称
    atttext:"伤害反弹",
    text:"每次受到攻击时，都会对攻击自身的单位反弹 固定加上自身力量一定百分比的魔法伤害。",
    awaytext:"0",
    awaynum:"0",
    attr_3:{
        attr_num:{
          0:"20",
          1:"30",
          2:"40",
          3:"50",
          4:"60",
          5:"70",
        },
        attr_name:"反弹伤害", 
    },
    attr_4:{
        attr_num:{
          0:"0%",
          1:"0%",
          2:"0%",
          3:"0%",
          4:"0%",
          5:"20%",
        },
        attr_name:"力量伤害", 
    },
    timetext:"0",
    timenum:"0",
    toptext:"一件可以通过吸收血液逐渐强化的鲜血铠甲。",
  },
  // 严法师斗篷
  item_goods_19:{
    name:"炎法师斗篷",
    attr_1:{
        attr_num:{
          0:"4%",
          1:"8%",
          2:"12%",
          3:"16%",
          4:"18%",
          5:"20%",
        },
        attr_name:"技能强度", 
    },
    // 被动名称
    atttext:"火焰灼烧",
    text:"每秒对周围敌方单位造成固定魔法伤害加上自身蓝量一定百分比的魔法伤害",
    // 范围
    awaytext:"作用范围：",
    awaynum:"600",
    attr_3:{
        attr_num:{
          0:"20",
          1:"30",
          2:"40",
          3:"50",
          4:"60",
          5:"70",
        },
        attr_name:"魔法伤害:", 
    },
    attr_4:{
        attr_num:{
          0:"0%",
          1:"0%",
          2:"0%",
          3:"0%",
          4:"0%",
          5:"3%",
        },
        attr_name:"蓝量伤害:", 
    },
    timetext:"0",
    timenum:"0",
    toptext:"一件可以通过吸收血液逐渐增强威力的火焰斗篷。",
  },
  // 迅捷之刃
  item_goods_17:{
    name:"迅捷之刃",
    attr_1:{
        attr_num:{
          0:"10",
          1:"20",
          2:"30",
          3:"40",
          4:"50",
          5:"60",
        },
        attr_name:"攻速", 
    },
    awaytext:"0",
    awaynum:"0",
    // 被动名称
    atttext:"迅捷之力",
    text:"攻击时降低目标护甲，并有15%概率额外造成一次敏捷系数的物理伤害",
    attr_3:{
        attr_num:{
          0:"3",
          1:"4",
          2:"5",
          3:"6",
          4:"7",
          5:"8",
        },
        attr_name:"降低护甲:", 
    },
    attr_4:{
        attr_num:{
          0:"1.4",
          1:"1.8",
          2:"1.8",
          3:"2.2",
          4:"2.8",
          5:"3.5",
        },
        attr_name:"敏捷伤害:", 
    },
    timetext:"持续时间",
    timenum:"7秒",
    toptext:"一件可以通过净化血液逐渐蜕变的雷霆之刃。",
  }
}





function GetTipData(data) {
  if(slot_pos==0){
    GetRoot().style.marginLeft = "1350px";
    GetRoot().style.marginBottom = "20px";
    GetPanel("jiantou").style.marginBottom="80px";
  }else if(slot_pos==1){
    GetRoot().style.marginLeft = "1410px";
    GetRoot().style.marginBottom = "20px";
    GetPanel("jiantou").style.marginBottom="80px";
// GetRoot().style.marginLeft = "1500px";
  }else if(slot_pos==2){
    GetRoot().style.marginLeft = "1480px";
    GetRoot().style.marginBottom = "20px";
    GetPanel("jiantou").style.marginBottom="80px";
  }else if(slot_pos==3){
    GetRoot().style.marginLeft = "1350px";
    GetRoot().style.marginBottom = "0px";
    GetPanel("jiantou").style.marginBottom="53px";
  }else if(slot_pos==4){
    GetRoot().style.marginLeft = "1410px";
    GetRoot().style.marginBottom = "0px";
    GetPanel("jiantou").style.marginBottom="53px";
  }else if(slot_pos==5){
    GetRoot().style.marginLeft = "1480px";
    GetRoot().style.marginBottom = "0px";
    GetPanel("jiantou").style.marginBottom="53px";
  }

  GetRoot().style.opacity = data.page;
// print(data)
  // GetRoot().style.opacity = 1;
  print(55555)
 
  if (data.page == 1) {
    // 没有升级的词条
    var attrlength = Length(data.attr);
    var attrpanel=GetPanel("attr_list_box");
        attrpanel.RemoveAndDeleteChildren();
    if(attrlength==0){
      GetPanel("attr_list_box").visible=false;
    }else{
      GetPanel("attr_list_box").visible=true;
      for (var i = 1; i <= attrlength; i++) {
        var sonpanel=NewPanel(attrpanel, "attr_list_"+i, "Panel");
            sonpanel.AddClass("attr_list_panel");
            sonpanel.hittest=false;
            sonpanel.BLoadLayoutSnippet("citiao_snippet");
            sonpanel.FindChildTraverse("attr_num").text ="+ "+ data.attr["slot_"+i].value;
            sonpanel.FindChildTraverse("attr_name").text = Local(data.attr["slot_"+i].name);
            // sonpanel.FindChildTraverse("attr_lv").text = Local(data.attr[i].name);
      }
    }
      // 显示信息
      var item=data.item_name;
      // 等级
      var itemlv=data.level;
      // 静态数据
      var itemdata=elsedata[item];
      // 名字
      GetPanel("tip_name").text=itemdata.name;
      GetPanel("jineng_bottom_text").text=itemdata.atttext;
      GetPanel("jineng_text_label").text=itemdata.text;
      // GetPanel("fanwei_name").text=itemdata.awaytext;
      // GetPanel("fanwei_num").text=itemdata.awaynum;
      // GetPanel("shijian_name").text=itemdata.timetext;
      // GetPanel("shijian_num").text=itemdata.timenum;
      
      // print(itemdata)
      // 词条1
      var ctpanel_1=GetPanel("citiao_list_1");
          ctpanel_1.RemoveAndDeleteChildren();
          var citi_1_length=Length(itemdata.attr_1.attr_num);
          for (var i = 0; i < citi_1_length; i++) {
            var sonpanel_e=NewPanel(ctpanel_1, "citiao_text_e_"+i, "Label");
            var sonpanel=NewPanel(ctpanel_1, "citiao_text_"+i, "Label");
            
                sonpanel_e.AddClass("citiao_text")
                sonpanel.AddClass("citiao_text")
                sonpanel.text = itemdata.attr_1.attr_num[i];
                sonpanel_e.text="/";

                if(itemlv==i){
                  sonpanel.AddClass("light");
                }else{
                  sonpanel.RemoveClass("light")
                }
          }
          ctpanel_1.GetChild(0).visible=false;
          GetPanel("citiao_panel_1").FindChildTraverse("citiao_name").text =itemdata.attr_1.attr_name;

          // 词条2
          print(GetPanel("citiao_list_2"))
          var ctpanel_2=GetPanel("citiao_list_2");
          // print(ctpanel_2.id)
              ctpanel_2.RemoveAndDeleteChildren();
          if(itemdata.attr_2){
            GetPanel("citiao_panel_2").visible=true;
            
            var citi_2_length=Length(itemdata.attr_2.attr_num);
            for (var i = 0; i < citi_2_length; i++) {
              var sonpanel_e=NewPanel(ctpanel_2, "citiao_text_e_"+i, "Label");
              var sonpanel=NewPanel(ctpanel_2, "citiao_text_"+i, "Label");
              
                  sonpanel_e.AddClass("citiao_text")
                  sonpanel.AddClass("citiao_text")
                  sonpanel.text = itemdata.attr_2.attr_num[i];
                  sonpanel_e.text="/";

                  if(itemlv==i){
                    sonpanel.AddClass("light");
                  }else{
                    sonpanel.RemoveClass("light")
                  }
            }
            ctpanel_2.GetChild(0).visible=false;
            GetPanel("citiao_panel_2").FindChildTraverse("citiao_panel_2_name").text =itemdata.attr_2.attr_name;

          }else{
            GetPanel("citiao_panel_2").visible=false;
            GetPanel("citiao_panel_2").FindChildTraverse("citiao_panel_2_name").text ="";

          }
          
          // 词条3
          var ctpanel_3=GetPanel("citiao_list_3");
          ctpanel_3.RemoveAndDeleteChildren();
          var citi_3_length=Length(itemdata.attr_3.attr_num);
          for (var i = 0; i < citi_3_length; i++) {
            var sonpanel_e=NewPanel(ctpanel_3, "citiao_text_e_"+i, "Label");
            var sonpanel=NewPanel(ctpanel_3, "citiao_text_"+i, "Label");
            
                sonpanel_e.AddClass("citiao_text")
                sonpanel.AddClass("citiao_text")
                sonpanel.text = itemdata.attr_3.attr_num[i];
                sonpanel_e.text="/";

                if(itemlv==i){
                  sonpanel.AddClass("light");
                }else{
                  sonpanel.RemoveClass("light")
                }
          }
          ctpanel_3.GetChild(0).visible=false;
          GetPanel("citiao_panel_3").FindChildTraverse("citiao_panel_3_name").text =itemdata.attr_3.attr_name;
          // 词条4
          var ctpanel_4=GetPanel("citiao_list_4");
          ctpanel_4.RemoveAndDeleteChildren();
          var citi_4_length=Length(itemdata.attr_4.attr_num);
          for (var i = 0; i < citi_4_length; i++) {
            var sonpanel_e=NewPanel(ctpanel_4, "citiao_text_e_"+i, "Label");
            var sonpanel=NewPanel(ctpanel_4, "citiao_text_"+i, "Label");
            
                sonpanel_e.AddClass("citiao_text")
                sonpanel.AddClass("citiao_text")
                sonpanel.text = itemdata.attr_4.attr_num[i];
                sonpanel_e.text="/";

                if(itemlv==i){
                  sonpanel.AddClass("light");
                }else{
                  sonpanel.RemoveClass("light")
                }
          }
          ctpanel_4.GetChild(0).visible=false;
          GetPanel("citiao_panel_4").FindChildTraverse("citiao_panel_4_name").text =itemdata.attr_4.attr_name;

          GetPanel("bottom_panel_text").text=itemdata.toptext;



          // item_goods_17 迅捷之刃
      // item_goods_18 荆棘者之甲
      // item_goods_19 法师斗篷
      if(item=="item_goods_17"){
        GetPanel("citiao_panel_2").visible=false;
      }else if(item=="item_goods_18"){
        GetPanel("citiao_panel_2").visible=true;
      }else if(item=="item_goods_19"){
        GetPanel("citiao_panel_2").visible=false;
      }
    }



    var item_name = data.item_name;
    var item_main_name = item_name + "_" + data.level;
    var item_main_attr = item_name + "_" + data.level + "_attr";
    //print(item_main_name);
    //print(item_main_attr);
    var path = "raw://resource/flash3/images/items/" + item_name + ".png";
    GetPanel("tip_img").SetImage(path);
    // GetPanel("tip_name").text = Local(item_main_name);
    GetPanel("main_attr").text = Local(item_main_attr);
    SetAttr(data.attr);
  }


function SetAttr(data) {
  if (!data) {
    return;
  }
  var panel = GetPanel("attr_list");
  panel.RemoveAndDeleteChildren();
  $.Each(data, function (v, k) {
    var attr_key = "attr_" + k;
    var sonpanel = NewPanel(panel, attr_key, "Panel");
    sonpanel.BLoadLayoutSnippet("attr_data");
    sonpanel.FindChildTraverse("attr_name").text = Local(v.name);
    sonpanel.FindChildTraverse("attr_num").text = v.value;
  });
}



(function () {
  InitData();
  SubEvent("UI_BagSlot", GetTipSlot);
  SubEvent("UI_TipData", GetTipData);
})();
