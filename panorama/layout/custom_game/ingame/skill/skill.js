--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function InitData() {
  var tp = "init";
  SendServer("Lua_SkillData", { data: { tp } });
}

function SelectSkill() {
  if (skill == 0 || slot == 0) {
    return;
  }
  var tp = "SelectSkill";
  var slot1 = skill;
  var slot2 = slot;
  SendServer("Lua_SkillData", { data: { tp, slot1, slot2 } });
  ClearNight();
}

function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_SkillData", { data: { tp } });
  ClearNight();
}

var skill = 0;
var slot = 0;

//选取技能的列表
var skill1_list = {
  slot_1: -1,
  slot_2: -1,
  slot_3: -1,
};
//自身技能槽位列表
var skill2_list = {
  slot_1: -1,
  slot_2: -1,
  slot_3: -1,
  slot_4: -1,
};
var skill2_name_list = {
  slot_1: "",
  slot_2: "",
  slot_3: "",
  slot_4: "",
};
var last_skill_ui_data = null;

function IsNullSkillName(name) {
  return !name || /^ability_null_\d+$/.test(name);
}

function IsSkill1SlotEmpty(slotKey) {
  var name = skill2_name_list[slotKey];
  if (name) {
    return IsNullSkillName(name);
  }
  return skill2_list[slotKey] == -1;
}

//是否有空的槽位（本地兜底；优先用服务端 skill_book_replace）
function IsHaveNullSlot() {
  for (var i = 1; i <= 4; i++) {
    if (IsSkill1SlotEmpty("slot_" + i)) {
      return true;
    }
  }
  return false;
}

function ShouldReplaceSkill(data) {
  if (data && data.skill_book_replace === true) {
    return true;
  }
  if (data && data.skill_book_replace === false) {
    return false;
  }
  return !IsHaveNullSlot();
}

function ChoseSkill(num) {
  if (skill == num) {
    ClearNight();
  } else {
    skill = num;
    Night();
  }
  if (ShouldReplaceSkill(last_skill_ui_data)) {
    return;
  }
  for (var i = 1; i <= 4; i++) {
    var our_slot = "slot_" + i;
    if (IsSkill1SlotEmpty(our_slot)) {
      skill = num;
      slot = i;
      SelectSkill();
      return;
    }
  }
}

function ChoseSlot(num) {
  if (slot == num) {
    ClearNight();
  } else {
    slot = num;
    Night();
  }
  SelectSkill();
  return;
}

function ClearNight() {
  skill = 0;
  slot = 0;
  Night();
}

function Night() {
  for (i = 1; i <= 3; i++) {
    var panel_name = "slot_" + i;
    var panel = GetPanel(panel_name);
    if (i == skill) {
      panel.style.brightness = 2;
      // panel.FindChildTraverse("skill_img").style.border = "2px solid white";
      panel.AddClass("light_img");
    } else {
      panel.style.brightness = 1;
      // panel.FindChildTraverse("skill_img").style.border = "0px solid white";
      panel.RemoveClass("light_img");
    }
  }
  for (i = 1; i <= 4; i++) {
    var panel_name = "slot_" + i + "_null";
    var panel = GetPanel(panel_name);
    if (i == slot) {
      panel.style.brightness = 2;
      // panel.FindChildTraverse("slot_img").style.border = "2px solid white";
      panel.AddClass("light_img");
    } else {
      panel.style.brightness = 1;
      // panel.FindChildTraverse("slot_img").style.border = "0px solid white";
      panel.RemoveClass("light_img");
    }
  }
}

function GetData(data) {
  last_skill_ui_data = data;
  GetRoot().style.opacity = data.page;
  SetSkillImg(data.list);
  SetSlotImg(data.Skill1);
  //四个英雄技能槽
  var panel1 = GetPanel("slot_list_page");
  var panel2 = GetPanel("root_box");
  var panel3 = GetPanel("title_text_img");
  //技能槽是否还有空位，满了需要替换（以服务端 skill_book_replace 为准）
  if (ShouldReplaceSkill(data)) {
    panel2.style.height = "320px";
    panel1.style.opacity = 1;
    panel3.SetImage("raw://resource/flash3/images/else/ji_text_2.png");
  } else {
    panel2.style.height = "220px";
    panel1.style.opacity = 0;
    panel3.SetImage("raw://resource/flash3/images/else/ji_text.png");
  }
}

function SetSkillImg(data) {
  $.Each(data, function (v, k) {
    var slot = k;
    skill1_list[slot] = v.skill;
    if (v.state == 1) {
      var img_id = v.skill;
      var skill_text = v.text;
      var panel = GetPanel(k);
      var img_pa = panel.FindChildTraverse("skill_img");
      var text_pa = panel.FindChildTraverse("skill_text");
      var path = "raw://resource/flash3/images/skill/skill_" + img_id + ".png";
      img_pa.SetImage(path);
      text_pa.text = Local(skill_text);
      var rank = v.rank.split("Rank")[1];
      // print(rank);
      for (var i = 0; i <= 4; i++) {
        img_pa.RemoveClass("rank_" + i);
      }
      var rankcolotkey = "rank_" + rank;

      img_pa.AddClass(rankcolotkey);
      // if (rank == 1) {
      //   img_pa.AddClass("rank_1");
      // } else if (rank == 2) {
      //   img_pa.AddClass("rank_2");
      // } else {
      //   img_pa.AddClass("rank_3");
      // }

      var abilityname = skill_text.split("text")[0];
      ShowTips(panel, abilityname);
    }
  });
}

function SetSlotImg(data) {
  $.Each(data, function (v, k) {
    skill2_list[k] = v.id;
    skill2_name_list[k] = v.name || "";

    var panel_name = k + "_null";
    var panel = GetPanel(panel_name);
    var img_panel = panel.FindChildTraverse("slot_img");
    var img_id = v.id;
    for (var i = 0; i <= 4; i++) {
      img_panel.RemoveClass("rank_" + i);
    }
    if (v.id == -1) {
      img_id = 0;
    } else {
      if (v.rank) {
        var rank = v.rank.split("Rank")[1];
        // if (rank == 1) {
        //   img_panel.AddClass("rank_1");
        // } else if (rank == 2) {
        //   img_panel.AddClass("rank_2");
        // } else {
        //   img_panel.AddClass("rank_3");
        // }
        var rankcolotkey = "rank_" + rank;
        img_panel.AddClass(rankcolotkey);
      }
    }

    var path = "raw://resource/flash3/images/skill/skill_" + img_id + ".png";
    img_panel.SetImage(path);

    ShowTips(panel, v.name);
    // print(data)
  });
}
function ShowTips(panel, name) {
  WhenOver(panel, function () {
    $.DispatchEvent("DOTAShowAbilityTooltip", panel, name);
  });
  WhenOut(panel, function () {
    $.DispatchEvent("DOTAHideAbilityTooltip", panel);
  });
}
(function () {
  InitData();
  SubEvent("UI_Skill", GetData);
})();