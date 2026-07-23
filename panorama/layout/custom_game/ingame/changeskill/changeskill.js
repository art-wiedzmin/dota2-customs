function InitData() {
  var tp = "init";
  SendServer("Lua_SkillData", { data: { tp } });
}

var ChangeSlot = -1
var TargetSlot = -1

function SlotReady() {
  if (ChangeSlot == -1 || TargetSlot == -1) {
    return
  }
  var tp = "SelectSlot";
  var text1 = ChangeSlot;
  var text2 = TargetSlot;
  SendServer("Lua_SkillData", { data: { tp, text1, text2 } });
}

function SelectSlot(num) {
  if (ChangeSlot == num) {
    ChangeSlot = -1
    NightSlot()
    return
  }
  if (TargetSlot == num) {
    TargetSlot = -1
    NightSlot()
    return
  }
  if (ChangeSlot == -1) {
    ChangeSlot = num;
    NightSlot()
    return
  } else if (TargetSlot == -1) {
    TargetSlot = num;
    NightSlot()
    SlotReady()
  }
}

function NightSlot() {
  for (var i = 1; i <= 4; i++) {
    var panel = GetPanel("slot_" + i);
    if (!panel) {
      continue;
    }
    if (i == ChangeSlot || i == TargetSlot) {
      panel.AddClass("light_img");
    } else {
      panel.RemoveClass("light_img");
    }
  }
}

function CloseSlotPage() {
  var tp = "CloseSlotPage";
  SendServer("Lua_SkillData", { data: { tp } });
}

function GetData(data) {
  GetRoot().style.opacity = data.page;
  // print(data)
  SetSlotImg(data.list);
  if (!data.page) {
    ChangeSlot = -1;
    TargetSlot = -1;
  }
  NightSlot();
}

function SetSlotImg(data) {
  $.Each(data, function (v, k) {
    var panel = GetPanel(k);
    var img_panel = panel.FindChildTraverse("slot_img");
    var path = "raw://resource/flash3/images/skill/" + v + ".png";
    img_panel.SetImage(path);
  });
}

(function () {
  InitData();
  SubEvent("UI_SlotSkill", GetData);
})();
