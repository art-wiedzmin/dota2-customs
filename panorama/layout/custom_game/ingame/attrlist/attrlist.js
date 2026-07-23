--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function InitData() {
  var tp = "init";
  SendServer("Lua_TalentData", { data: { tp } });
}

function CloseAttr() {
  ClearSelect();
  var tp = "CloseAttr";
  SendServer("Lua_TalentData", { data: { tp } });
}

//清理选项框
function ClearSelect() {
  select_slot = "";
  GetPanel("yes_btn").RemoveClass("checkclass");
  attr = {
    slot_1: 0,
    slot_2: 0,
    slot_3: 0,
  };
  $.Each(attr, function (v, k) {
    var panel = GetPanel(k);
    panel.style.border = "1px solid #242f35";
  });
}

function SelectAttr() {
  if (select_slot == "") {
    return;
  }
  var tp = "SelectAttr";
  var text = select_slot;
  SendServer("Lua_TalentData", { data: { tp, text } });
}

var ckechnum=0;
// 重随
function RollAttr() {
    var tp = "RollAttr";
    SendServer("Lua_TalentData", { data: { tp } });
}

var rank_color = {
  rank_1: "white",
  rank_2: "rgb(0,238,118)",
  rank_3: "rgb(0,191,255)",
  rank_4: "rgb(255,185,15)",
  rank_5: "rgb(205,0,0)",
};
var rank_lv = {
  rank_1: "D",
  rank_2: "C",
  rank_3: "B",
  rank_4: "A",
  rank_5: "S",
};

function GetData(data) {
  GetRoot().style.opacity = data.page;
  $.Each(data.list, function (v, k) {
    var panel = GetPanel(k).FindChildTraverse("text_data");
    var panelnum = GetPanel(k).FindChildTraverse("text_num");
    var panellv= GetPanel(k).FindChildTraverse("text_lv");
    var name = v.name;
    var value = v.value;
    var rank = v.rank;
    if (name == "gjjg") {
      value = value.toFixed(2);
    }
    var text = Local(name)
    panel.text = text;
    panelnum.text= "+" +value;
    if (rank != -1) {
      var textlv = rank_lv[rank];
      panellv.text = textlv;
    }
  });
  // GetPanel("roll_cost").text ="x"+(4 - data.roll_num);
  ClearSelect();

  if(data.refresh_state==1){
    GetPanel("roll_panel").style.brightness = 1;
    if(data.cost==0){
      GetPanel("roll_num").text = "免费重随";
      GetPanel("cost_img").visible=false;
      GetPanel("roll_cost").visible=false;
    }else{
      GetPanel("roll_num").text="重随"
      GetPanel("cost_img").visible=true;
      GetPanel("roll_cost").visible=true;
      GetPanel("roll_cost").text ="x"+ data.cost;
    }
  }else{
    GetPanel("roll_panel").style.brightness = 0.3;
    GetPanel("roll_num").text="重随"
    GetPanel("cost_img").visible=true;
    GetPanel("roll_cost").text ="x"+ data.cost;
  }




  // if(data.cost){
  //   if(data.refresh_state==1&&data.cost==0){
  //     GetPanel("roll_num").text = "免费重随";
  //     GetPanel("cost_img").visible=false;
  //     GetPanel("roll_cost").visible=false;
  //   }else{
  //     GetPanel("roll_num").text="重随"
  //     GetPanel("cost_img").visible=true;
  //     GetPanel("roll_cost").text ="x"+ data.cost;
  //   }
    // 免费重随
    // if(data.cost==0){
    //   GetPanel("roll_num").text = "免费重随";
    //   GetPanel("cost_img").visible=false;
    //   GetPanel("roll_cost").visible=false;
    // }else{
    //   GetPanel("roll_num").text="重随"
    //   GetPanel("cost_img").visible=true;
    //   GetPanel("roll_cost").text ="x"+ data.cost;
      
    // }
  // }

  
}

function Night(num) {
  var slot_key = "slot_" + num;
  attr.slot_1 = 0;
  attr.slot_2 = 0;
  attr.slot_3 = 0;
  attr[slot_key] = 1;
  $.Each(attr, function (v, k) {
    var panel = GetPanel(k);
    if (k == slot_key) {
      panel.style.border = "2px solid #61829F";
      select_slot = slot_key;
      // GetPanel("yes_btn").AddClass("checkclass");
    } else {
      panel.style.border = "1px solid #242f35";
      // GetPanel("yes_btn").RemoveClass("checkclass");
     
    }
  });
  // GetPanel(slot_key).style.border = "2px solid #61829F";
  if(select_slot != ""){
    GetPanel("yes_btn").AddClass("checkclass");
  }else{
    GetPanel("yes_btn").RemoveClass("checkclass");
  }
}

var select_slot = "";
var attr = {
  slot_1: 0,
  slot_2: 0,
  slot_3: 0,
};




// 悬浮显示
function HoverFun(pa){
  var pa=GetPanel(pa);
  WhenOver(pa, function () {
      GetPanel("hovertip").visible=true
  })
  WhenOut(pa, function () {
      GetPanel("hovertip").visible=false
  })
}
HoverFun("TitleImg2");

(function () {
  InitData();
  SubEvent("UI_AttrData", GetData);
})();