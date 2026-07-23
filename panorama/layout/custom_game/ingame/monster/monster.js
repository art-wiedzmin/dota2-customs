/** 与 Game.IsHUDFlipped() 一致：true = 官方小地图在右，毒圈/倒计时镜像到右下 */
function InitMonsterHudMinimapAlign() {
  var root = GetRoot();
  if (!root) {
    return;
  }
  var minimapRight = Game.IsHUDFlipped();
  root.SetHasClass("monster_hud_minimap_left", !minimapRight);
  root.SetHasClass("monster_hud_minimap_right", minimapRight);
}

function InitData() {
  var tp = "init";
  SendServer("Lua_Monster", { data: { tp } });
}
var tipdata = {
  1: {
    name: "m1",
    text_1: "狼王暂未刷新。",
    text_1_1: "游戏时间5分钟后开始刷新。",
    text_2: "狼王已在地图中刷新。",
    text_3: "狼王已结束刷新。",
  },
  2: {
    name: "m2",
    text_1: "寰宇肉山暂未刷新。",
    text_1_1: "游戏时间18分钟后开始刷新。",
    text_2: "寰宇肉山已在地图中刷新。",
    text_3: "寰宇肉山已结束刷新。",
  },
  3: {
    name: "m3",
    text_1: "风暴领主暂未刷新。",
    text_1_1: "游戏时间21分钟后开始刷新。",
    text_2: "风暴领主已在地图中刷新。",
    text_3: "风暴领主已结束刷新。",
  },
};
var state1 = 0;
var state2 = 0;
var state3 = 0;
function GetData(data) {
  if (!data) {
    return;
  }
  wolf_time = data.wolf_time;
  bear_time = data.bear_time;
  dragon_time = data.dragon_time;
  SetMap(data.stage);
  //print(data);
  GetRoot().style.opacity = data.page;
  if (TimeState == false) {
    TimeStar();
    TimeState = true;
  }
  var wolf_state = data.wolf_state;
  var bear_state = data.bear_state;
  var dragon_state = data.dragon_state;
  setstate(wolf_state, 1);
  setstate(bear_state, 2);
  setstate(dragon_state, 3);
  SteText(wolf_state, 1);
  SteText(bear_state, 2);
  SteText(dragon_state, 3);
  if (state1 != wolf_state) {
    TimeBac(wolf_state, 1, wolf_time, wolf_time);
    state1 = wolf_state;
  }
  if (state2 != bear_state) {
    TimeBac(bear_state, 2, bear_time, bear_time);
    state2 = bear_state;
  }
  if (state3 != dragon_state) {
    TimeBac(dragon_state, 3, dragon_time, dragon_time);
    state3 = dragon_state;
  }
}

// 转圈
function TimeBac(state, id, timename, time) {
  Timers(1, function () {
    if (state !== 1) {
      return;
    }
    timename -= 1;
    if (timename <= 0) {
      GetPanel("TimeText_" + id).SetHasClass("Mask_transition", false);
      GetPanel("TimeText_" + id).style.clip = "radial(50% 50%, 0deg,0deg)";
    } else {
      GetPanel("TimeText_" + id).SetHasClass("Mask_transition", true);
      var angle = (360 / time) * (time - timename);
      if (angle || angle !== null) {
        GetPanel("TimeText_" + id).style.transitionDuration = "1s";

        GetPanel("TimeText_" + id).style.clip =
          "radial(50% 50%, 0deg, " + angle + "deg)";
      }
    }
    TimeBac(state, id, timename, time);
  });
}
function SteText(state, id) {
  var tip = GetPanel("tip_" + id);
  GetPanel("t" + id + "_1").text = tipdata[id]["text_" + state];
  GetPanel("t" + id + "_2").text = tipdata[id]["text_" + state + "_1"];
  if (state == 1) {
    GetPanel("t" + id + "_2").visible = true;
  } else {
    GetPanel("t" + id + "_2").visible = false;
  }
}
function HoverTip(id) {
  var pa = GetPanel("TimeBox_" + id);
  var tippa = GetPanel("tip_" + id);
  WhenOver(pa, function () {
    tippa.visible = true;
  });
  WhenOut(pa, function () {
    tippa.visible = false;
  });
}
// 设置状态
function setstate(state, id) {
  var img = GetPanel("TimeImg_" + id);
  var time = GetPanel("TimeText_" + id);
  if (state == 1) {
    img.style.washColor = "#b8b8b8";
    img.style.saturation = "0";
    time.style.opacity = "1";
  } else if (state == 2) {
    img.style.washColor = "none";
    img.style.saturation = "1";
    time.style.opacity = "0";
  } else {
    img.style.washColor = "#b8b8b8";
    img.style.saturation = "1";
    time.style.opacity = "0";
  }
}

function SetMap(data) {
  // print(data)
  var map_panel = GetPanel("map_page");
  var panel = GetPanel("range");
  if (data == 0) {
    map_panel.style.opacity = 0;
    panel.style.width = "0px";
  }
  if (data == 1) {
    map_panel.style.opacity = 1;
    panel.style.width = "200px";
    panel.style.height = "200px";
    panel.style.marginTop = "5px";
  }
  if (data == 2) {
    map_panel.style.opacity = 1;
    panel.style.width = "90px";
    panel.style.height = "90px";
    panel.style.marginTop = "10px";
  }
}

function TimeStar() {
  Timers(1, function () {
    wolf_time = wolf_time - 1;
    bear_time = bear_time - 1;
    dragon_time = dragon_time - 1;
    // GetPanel("time1").text = TimeText(wolf_time);
    // GetPanel("time2").text = TimeText(bear_time);
    // GetPanel("time3").text = TimeText(dragon_time);
    TimeStar();
  });
}

var TimeState = false;
var wolf_time = 0;
var bear_time = 0;
var dragon_time = 0;

function TimeText(time) {
  var min = Math.floor(time / 60);
  var mm = time - min * 60;
  var time = min + ":" + mm;
  return time;
}

(function () {
  InitMonsterHudMinimapAlign();
  InitData();
  HoverTip(1);
  HoverTip(2);
  HoverTip(3);
  SubEvent("UI_Monster", GetData);
})();
