function InitData() {
  var tp = "init";
  SendServer("Lua_SkillData", { data: { tp } });
}

function ChoseSlot(num) {
  slot = num;
  for (i = 5; i <= 10; i++) {
    var panel_name = "slot_" + i;
    var panel = GetPanel(panel_name);
    if (i == slot) {
      panel.style.brightness = 2;
      panel.FindChildTraverse("slot_img").style.border = "2px solid white";
      panel.AddClass("light_img");
    } else {
      panel.style.brightness = 1;
      panel.FindChildTraverse("slot_img").style.border = "0px solid white";
      panel.RemoveClass("light_img");
    }
  }
}

function DelSkill() {
  if (slot == 0) {
    return;
  }
  var tp = "DelSkill";
  var text = slot;
  SendServer("Lua_SkillData", { data: { tp, text } });
  ChoseSlot(0);
}

var slot = 0;

function CloseDelPage() {
  var tp = "CloseDelPage";
  SendServer("Lua_SkillData", { data: { tp } });
  ChoseSlot(0);
}

function GetData(data) {
  //print(data);
  GetRoot().style.opacity = data.page;
  SetSlotImg(data.skill);
}

function SetSlotImg(data) {
  $.Each(data, function (v, k) {
    var panel = GetPanel(k);
    var img_panel = panel.FindChildTraverse("slot_img");
    var name = v.name;
    var path = "raw://resource/flash3/images/ability/" + name + ".png";
    img_panel.SetImage(path);
  });
}

(function () {
  InitData();
  SubEvent("UI_DelSkill", GetData);
})();
