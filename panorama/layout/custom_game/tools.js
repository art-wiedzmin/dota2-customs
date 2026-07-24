--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


//注：！！！当你怀疑多引用了一份JS文件报错时，首先检查自调用前的函数有没有加分号！！！！！
//非常重要！！！！！！！！
//非常重要！！！！！！！！

/** steamid 为 0 时 DOTAAvatarImage 会请求 panorama/images/players/0_png（常缺失）。空字符串则不打该资源。 */
function ClrbSteamIdOrEmpty(v) {
  if (v === undefined || v === null || v === "") {
    return "";
  }
  var s = typeof v === "number" ? String(v) : String(v);
  if (s === "0" || Number(s) === 0 || s === "-1" || Number(s) === -1) {
    return "";
  }
  return s;
}

function print2(key1, key2, key3, key4) {
  $.Msg(key1);
  if (key2) {
    print2(key2);
  }
  if (key3) {
    print2(key3);
  }
  if (key4) {
    print2(key4);
  }
}
//打印
function print() {
  for (let i = 0; i <= arguments.length - 1; i++) {
    if (typeof arguments[i] == "object") {
      DeepPrint3(arguments[i]);
    } else {
      $.Msg(arguments[i]);
    }
  }
}

//提取某str对应的在ntab里的网表值，返回这个tab
function NetOut(str) {
  var tab = CustomNetTables.GetTableValue("ntab", str);
  return tab;
}

//监听ntab变化并执行fun
function ListenNtab(fun) {
  CustomNetTables.SubscribeNetTableListener("ntab", fun);
}

//新建版,父名str+id+类型,三位都可以省略
function NewPanel(father, id, style) {
  if (!id || id == 0) {
    id = "";
  }
  if (!style) {
    style = "Panel";
  }
  if (father == 0 || !father) {
    father = GetRoot(0);
  }
  father = Str2Panel(father);
  if (!father) {
    return;
  }
  var pan = $.CreatePanel(style, father, id);
  return pan;
}

function Str2Panel(panel) {
  if (typeof panel == "string") {
    panel = GetPanel(panel);
    return panel;
  }
  if (typeof panel == "object") {
    return panel;
  }
}

//板实体，宽，高，颜色，上偏，左偏
function BaseStyle(panel, width, height, color, flowc, h, v, left, top) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (typeof width == "number") {
    panel.style.width = width + "px";
  }
  if (typeof width == "string") {
    panel.style.width = width;
  }
  if (typeof height == "number") {
    panel.style.height = height + "px";
  }
  if (typeof height == "string") {
    panel.style.height = height;
  }
  if (top) {
    panel.style.marginTop = top + "px";
  }
  if (left) {
    panel.style.marginLeft = left + "px";
  }
  if (h && h != 0) {
    panel.style.horizontalAlign = h;
  }
  if (v && v != 0) {
    panel.style.verticalAlign = v;
  }
  if (h == 0) {
    panel.style.horizontalAlign = "center";
  }
  if (v == 0) {
    panel.style.verticalAlign = "center";
  }
  if (color) {
    panel.style.backgroundColor = color;
  }
  if (flowc) {
    panel.style.flowChildren = flowc;
  }
}

//对齐 AlignPanel(panel,100,100)
function AlignPanel(panel, h, v) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (!h || h == 0) {
    panel.style.horizontalAlign = "center";
  }
  if (!v || v == 0) {
    panel.style.verticalAlign = "center";
  }
  if (typeof h == "number" && h != 0) {
    panel.style.marginLeft = h + "px";
  }
  if (typeof v == "number" && v != 0) {
    panel.style.marginTop = v + "px";
  }
  if (typeof h == "string") {
    panel.style.horizontalAlign = h;
  }
  if (typeof v == "string") {
    panel.style.verticalAlign = v;
  }
}

//板，边宽，圆角，边颜色
function SetBorder(panel, edge, radius, color) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (!color) {
    color = "gray";
  }
  panel.style.border = edge + "px " + "solid " + color;
  if (radius) {
    panel.style.borderRadius = radius + "px";
  }
}

//给image标签设置图片 SetIma(panel,"pic/stone")      图必须先被编译！！！
function SetIma(panel, str) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.SetImage("file://{resources}/images/custom_game/" + str + ".png");
}

//给任意类型标签设置css里的背景图 (pane,"pic/stone")  图必须先被编译！！！
function SetBackground(panel, str, num) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.style.backgroundImage =
    "url('file://{images}/custom_game/" + str + ".png')";
  if (num) {
    panel.style.backgroundSize = num + "%";
  }
  panel.style.backgroundRepeat = "no-repeat";
}

//在某个板正中间输入文字
function TextIn(panel, id, str, size, color) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  var textpan = NewPanel(panel, id, "Label");
  textpan.text = str;
  AlignPanel(textpan);
  if (color) {
    FontSet(textpan, size, color);
  } else FontSet(textpan, size, "#d6d6d6");
  return textpan;
}

function GetDad(a) {
  return a.GetParent();
}

//0-4取依次从上下文板向上级
function GetRoot(n) {
  var root = $.GetContextPanel();
  for (let i = 0; i < n; i++) {
    root = GetDad(root);
  }
  return root;
}

/** 从当前 Panorama 上下文向上找到 HUD 根节点 */
function ClrbFindHudRoot() {
  var panel = $.GetContextPanel();
  while (panel && panel.GetParent()) {
    panel = panel.GetParent();
  }
  return panel;
}

//ID定位板
function GetPanel(str) {
  return $("#" + str);
}

//n 0-4不同等级从上下文板向上作父取子板
function FindSon(son, father, n) {
  if (!n) {
    n = 0;
  }
  if (!father) {
    father = GetRoot(n);
  }
  father = Str2Panel(father);
  if (!father) {
    return;
  }
  return father.FindChildTraverse(son);
}

function SetTrans(panel) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.style.transition =
    "opacity 0.5s ease-in-out 0s, height 0.5s ease-in-out 0s,width 0.5s ease-in-out 0.0s;";
}

//简单的延时  如果要循环就要把这个计时器放在一个函数内部
//延时执行自己来循环
function Timers(n, func) {
  return $.Schedule(n, func);
}
//销毁计时器
function DestroyTimer(timer) {
  $.CancelScheduled(timer);
}
//全局存 也可以存Game下 存str键或值键
function Gsave(k, v) {
  GameUI.CustomUIConfig().k = v;
}

function Gout(k) {
  return GameUI.CustomUIConfig().k;
}

//发声
function Esound(str) {
  Game.EmitSound(str);
}

function ShowPanel(panel, num) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (num == 0) {
    panel.visible = false;
  } else {
    panel.visible = true;
  }
}

function TogglePanel(panel) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (panel.visible == true) {
    panel.visible = false;
  } else {
    panel.visible = true;
  }
}

//字体简单设置 FontSet(text,50,"green")
/*字体对齐style.textAlign="center";
	    style.uiScale="102%"
	    style.textOverflow="shrink" 缩小全显示
	    style.borderRadius="10px";*/
function FontSet(panel, size, color, family) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (!size) {
    size = 35;
  }
  panel.style.fontSize = size + "px";
  if (color) {
    panel.style.color = color;
  }
  if (family) {
    panel.style.fontFamily = family;
  } else {
    panel.style.fontFamily = "FZKai-Z03";
  }
  panel.style.textShadow = "2px 2px 4px 2.0 #000000";
}
//只有Button有效
function WhenDouble(panel, fun) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.SetPanelEvent("ondblclick", function () {
    if (!ThrottleTool(panel)) {
      return;
    }
    if (fun && typeof fun == "function") {
      fun();
    }
  });
}

function WhenActive(panel, fun) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.SetPanelEvent("onmouseactivate", function () {
    if (!ThrottleTool(panel)) {
      return;
    }
    if (fun && typeof fun == "function") {
      fun();
    }
  });
}

function WhenOver(panel, fun) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.SetPanelEvent("onmouseover", fun);
}

function WhenOut(panel, fun) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.SetPanelEvent("onmouseout", fun);
}

/** 肉搏技能书 item_skill_N(_up) → 对应 ability_item_N(_up)，用于名称与悬停详情 */
function ClrbPetRbItemToAbilityName(itemName) {
  if (!itemName) {
    return "";
  }
  var m = /^item_skill_(\d+)(_up)?$/.exec(itemName);
  if (m) {
    return "ability_item_" + m[1] + (m[2] || "");
  }
  return itemName;
}

function ClrbPetRbSkillLocalizedName(itemName) {
  var ab = ClrbPetRbItemToAbilityName(itemName);
  var t = $.Localize("#DOTA_Tooltip_ability_" + ab);
  if (t && t.indexOf("#DOTA_Tooltip") !== 0) {
    return t;
  }
  t = $.Localize("#DOTA_Tooltip_ability_" + itemName);
  if (t && t.indexOf("#DOTA_Tooltip") !== 0) {
    return t;
  }
  return itemName;
}

/** 悬停显示肉搏技能完整 ability tooltip（与选将推荐技能一致） */
function ClrbBindPetSkillAbilityTooltip(panel, itemName) {
  if (!panel || !itemName) {
    return;
  }
  var ab = ClrbPetRbItemToAbilityName(itemName);
  WhenOver(panel, function () {
    $.DispatchEvent("DOTAShowAbilityTooltip", panel, ab);
    panel.style.tooltipPosition = "bottom";
  });
  WhenOut(panel, function () {
    $.DispatchEvent("DOTAHideAbilityTooltip", panel);
  });
}

/**
 * 宠物设置格子：图标 + 下方技能名；iconWrap 悬停出技能详情
 * @param {string} imagePath SetImage 用路径
 * @returns {{ root: Panel, iconWrap: Panel }}
 */
function ClrbCreatePetSkillSlotCell(parent, slotId, itemName, imagePath) {
  var cell = $.CreatePanel("Panel", parent, slotId);
  cell.AddClass("KeyBindModalPetSlot");
  cell.hittest = true;

  var iconWrap = $.CreatePanel("Panel", cell, slotId + "_icon");
  iconWrap.AddClass("KeyBindModalPetIconWrap");
  iconWrap.hittest = true;

  var img = $.CreatePanel("Image", iconWrap, "");
  img.AddClass("KeyBindModalPetIcon");
  img.hittest = false;
  if (imagePath) {
    img.SetImage(imagePath);
  }

  ClrbBindPetSkillAbilityTooltip(iconWrap, itemName);

  var lbl = $.CreatePanel("Label", cell, slotId + "_name");
  lbl.AddClass("KeyBindModalPetName");
  lbl.hittest = false;
  lbl.text = ClrbPetRbSkillLocalizedName(itemName);

  return { root: cell, iconWrap: iconWrap };
}

//bottom right left top 兼容文字/物品提示/标题提示
function ShowTip(panel, str, pos, title) {
  var lx = "DOTAShowTextTooltip";
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (str.substring(0, 2) == "ab" || str.substring(0, 4) == "item") {
    var lx = "DOTAShowAbilityTooltip";
  }
  if (title) {
    lx = "DOTAShowTitleTextTooltip";
    $.DispatchEvent(lx, panel, title, str);
  } else {
    $.DispatchEvent(lx, panel, str);
  }
  if (pos) {
    panel.style.tooltipPosition = pos;
  } else {
    panel.style.tooltipPosition = "right";
  }
}

//普通是关文字，加后缀0关技能提示，加1关标题提示
function HideTip(panel, lx) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (!lx) {
    $.DispatchEvent("DOTAHideTextTooltip", panel);
  }
  if (lx && lx == 0) {
    $.DispatchEvent("DOTAHideAbilityTooltip", panel);
  }
  if (lx && lx == 1) {
    $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
  }
}

function OnBright(panel, num) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (!num) {
    num = "2";
  }
  panel.SetPanelEvent("onmouseover", function () {
    panel.style.brightness = num;
  });
  panel.SetPanelEvent("onmouseout", function () {
    panel.style.brightness = "1";
  });
}

//切换某个类的有无
function SwitchClass(panel, classstr) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.SetHasClass(classstr, !panel.BHasClass(classstr));
}

//有A时，是否有B
function TrueClassAdd(panel, classa, classb, bool) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (panel.BHasClass(classa)) {
    panel.SetHasClass(classb, bool);
  }
}

//无A时，是否有B
function FalseClassAdd(panel, classa, classb, bool) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  if (!panel.BHasClass(classa)) {
    panel.SetHasClass(classb, bool);
  }
}

//-----------------------------------------------------Entities
function I2IsValid(index) {
  return Entities.IsValidEntity(index);
}

function I2IsHero(index) {
  return Entities.IsRealHero(index);
}

function I2ID(index) {
  return Entities.GetPlayerOwnerID(index);
}

function I2Ve(index) {
  return Entities.GetAbsOrigin(index);
}

function I2Alive(index) {
  return Entities.IsAlive(index);
}

function I2Health(index) {
  return Entities.GetHealth(index);
}

function I2Health(index) {
  return Entities.GetHealth(index);
}

function I2MaxHealth(index) {
  return Entities.GetMaxHealth(index);
}

function I2Level(index) {
  return Entities.GetLevel(index);
}

function I2Name(index) {
  return Entities.GetUnitName(index);
}

function I2Slot(indexplayer, indexslot) {
  return Entities.GetItemInSlot(indexplayer, indexslot);
}

//-----------------------------------------------------Players
//玩家昵称 string
function ID2PlayerName(ID) {
  if (!ID) {
    ID = Players.GetLocalPlayer();
  }
  return Players.GetPlayerName(ID);
}

//英雄昵称 string
function ID2HeroName(ID) {
  if (!ID) {
    ID = Players.GetLocalPlayer();
  }
  return Players.GetPlayerSelectedHero(ID);
}

//当前操作英雄索引 num
function ID2HeroIndex(ID) {
  if (!ID) {
    ID = Players.GetLocalPlayer();
  }
  return Players.GetPlayerHeroEntityIndex(ID);
}
//----------------------------------------------------Game
function GLocalID() {
  return Game.GetLocalPlayerID();
}
function GInfoTab() {
  return Game.GetLocalPlayerInfo();
}

//----------------------------------------------------GameEvents
function SubEvent(str, fun) {
  GameEvents.Subscribe(str, fun);
}
function SendServer(str, tab) {
  if (!str || !tab) {
    return;
  }
  if (tab.data != null && typeof tab.data != "string") {
    tab.data = JSON.stringify(tab.data);
  }
  GameEvents.SendCustomGameEventToServer(str, tab);
}

/**
 * 合并短时间内的同事件请求，减少 Panorama→服务器 CustomGameEvent 次数（最后一次 payload 生效）。
 * 用于 hover/拖拽/高频 UI 回调等；若每次都必须到达服务器请勿使用。
 */
function SendServerDebounced(str, tab, delayMs) {
  if (!SendServerDebounced._pending) {
    SendServerDebounced._pending = {};
  }
  var d = delayMs != null ? delayMs : 50;
  var p = SendServerDebounced._pending[str];
  if (p && p.timer != null) {
    $.CancelScheduled(p.timer);
  }
  var payload = tab;
  var t = $.Schedule(d, function () {
    var q = SendServerDebounced._pending[str];
    if (q) {
      q.timer = null;
    }
    SendServer(str, payload);
  });
  SendServerDebounced._pending[str] = { timer: t };
}

//----------------------------------------------------
function Bloadout(panel, str) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.BLoadLayout(
    "file://{resources}/layout/custom_game/" + str + ".xml",
    true,
    false
  );
}

//panel.RemoveAndDeleteChildren()
//GetRoot().RemoveAndDeleteChildren()
function DelPanel(panel) {
  panel = Str2Panel(panel);
  if (!panel) {
    return;
  }
  panel.DeleteAsync(0);
}

//用一个目标的索引，或一个含有三轴的tab表，转成屏幕x,y
function W2Screen(index) {
  if (typeof index == "number") {
    var pos = I2Ve(index);
  }
  if (typeof index == "objecdt") {
    var pos = index;
  }
  if (!pos) {
    return;
  }
  var x = Game.WorldToScreenX(pos[0], pos[1], pos[2]);
  var y = Game.WorldToScreenY(pos[0], pos[1], pos[2]);
  //var sw = Game.GetScreenWidth()
  var sh = Game.GetScreenHeight();
  var scal = 1080 / sh;
  x = x * scal;
  y = y * scal;
  return { x, y };
}

//屏幕坐标等比转换成当前
function GetScreenConver() {
  var pos = GameUI.GetCursorPosition();
  var x = pos[0];
  var y = pos[1];
  var sh = Game.GetScreenHeight();
  var scal = 1080 / sh;
  x = x * scal;
  y = y * scal;
  return { x, y };
}

//一个板转到指定坐标或实体的位置 对
//设置板的坐标是在左上角，要居中就需要把板减少一半
function SetPanelPosition(panel, objindex) {
  if (typeof panel == "string") {
    panel = GetPanel(panel);
  }
  var xytab = W2Screen(objindex);
  if (!xytab) {
    return;
  }
  var acw = panel.actuallayoutwidth;
  var ach = panel.actuallayoutheight;
  if (!acw || !ach) {
    panel.SetPositionInPixels(xytab.x - 60, xytab.y - 80, 0);
    return;
  }
  var x = xytab.x - acw / 2 - 50;
  var y = xytab.y - ach - 100;
  panel.SetPositionInPixels(x, y, 0);
}

function GetFrame() {
  return Game.GetGameFrameTime();
}

function FormatTime(sec, needMS) {
  if (!sec) {
    sec = Game.Time() - 93;
  }
  if (isNaN(sec)) {
    return "00:00";
  } else {
    var min = 0;
    if (sec >= 60) {
      min = parseInt(sec / 60);
      sec = sec % 60;
    }

    var ms = null;
    if (needMS) {
      var str = sec.toString();
      if (str.indexOf(".") >= 0) {
        ms = str.split(".")[1];
        if (ms.length > 3) {
          ms = ms.substring(0, 3);
        }
        sec = Math.floor(sec);
      }
    } else {
      sec = Math.round(sec);
    }
    if (sec < 10) {
      sec = "0" + sec;
    }

    if (min < 10) {
      min = "0" + min;
    }

    return min + ":" + sec + (ms != null ? "." + ms : "");
  }
}

//调用Lua创建一个板 onactivate="LuaCreatePanel('xmlname')",括号里是.xml的文件命名
function LuaCreatePanel(xmlname) {
  GameEvents.SendCustomGameEventToServer("EventCreatePanel", { str: xmlname });
}

//调用Lua关闭一个板 onactivate="LuaDestroyPanel('shop')"，括号里是.xml的文件命名
function LuaDestroyPanel(xmlname) {
  GameEvents.SendCustomGameEventToServer("EventDestroyPanel", { str: xmlname });
}

function DeepPrint(Obj, indent) {
  indent = indent || 0;

  if (indent == 0) {
    $.Msg("{");
  }
  for (let key in Obj) {
    var value = Obj[key];
    if (typeof value == "object") {
      $.Msg(repeatStr("\t", indent) + key.toString() + ":");
      DeepPrint(value, indent + 1);
    } else if (typeof value == "function") {
      $.Msg(repeatStr("\t", indent) + key.toString() + ": function");
    } else {
      $.Msg(
        repeatStr("\t", indent) +
          key.toString() +
          ":" +
          (value != null ? value.toString() : "NULL")
      );
    }
  }
  if (indent == 0) {
    $.Msg("}");
  }
}
function DeepPrint3(obj, indent = 0, done = new WeakMap()) {
  if (typeof obj !== "object" || obj === null) return;

  if (indent === 0) {
    $.Msg(Array.isArray(obj) ? "[" : "{");
    indent++;
  }

  done.set(obj, true);

  const isPureArray = Array.isArray(obj);
  const keys = Object.keys(obj);

  keys.sort((a, b) => {
    if (typeof a === "number" && typeof b === "number") {
      return a - b;
    } else {
      return a.toString() > b.toString() ? 1 : -1;
    }
  });

  keys.forEach((key, index) => {
    const value = obj[key];
    const isLastElement = index === keys.length - 1;
    const indentStr = "\t".repeat(indent);
    const nextIndentStr = "\t".repeat(indent + 1);

    if (typeof value === "object" && value !== null && !done.has(value)) {
      done.set(value, true);
      $.Msg(
        `${indentStr}${isPureArray ? "" : key + ": "}${
          Array.isArray(value) ? "[" : "{"
        }`
      );
      DeepPrint3(value, indent + 1, done);
      $.Msg(
        `${indentStr}${Array.isArray(value) ? "]" : "}"}${
          isLastElement ? "" : ","
        }`
      );
    } else {
      const valueStr = typeof value === "string" ? `'${value}'` : value;
      $.Msg(
        `${indentStr}${isPureArray ? "" : key + ": "}${valueStr}${
          isLastElement ? "" : ","
        }`
      );
    }
  });

  if (indent === 1) {
    $.Msg(isPureArray ? "]" : "}");
  }
}
function repeatStr(str, times) {
  var result = "";
  for (var i = 0; i < times; i++) {
    result += str;
  }
  return result;
}

function Localize(str, defaultValue) {
  if (str != null && str.trim() != "") {
    var localized = $.Localize(str);
    if (localized != str) {
      return localized;
    }
  }
  return defaultValue == null ? "???" : defaultValue;
} //值为空返回 "???"  不为空返回自己

function Local(str) {
  if (str && typeof str == "number") {
    return str;
  }
  if (str != null && str.trim() != "") {
    var localized = $.Localize("#" + str);
    if (localized != str && localized != "#" + str) {
      return localized;
    } else {
      return str;
    }
  }
}

/**
 * 发送给服务器用GameEvents.SendCustomGameEventToServer
 * 本地玩家发送消息给所有玩家用GameEvents.SendCustomGameEventToAllClients
 * @param msg  消息内容，可以是一个字符串也可以是一个对象。如果是字符串，则会到达客户端后进行国际化显示；如果是对象将会把对象中的各个串国际化后进行拼接。
 * @param msgFmtObj 格式化消息中的{s:xxx}用的
 * @param item 物品名称或者物品id
 * @param alert_unit 要提示位置的单位，有的话会在小地图ping一下该单位的位置
 */
function SendCustomMessageToAllClients(msg, msgFmtObj, item, alert_unit) {
  if (IsLocalPlayerValid()) {
    if (msg) {
      var dataObj = {};
      dataObj.msg = msg;
      dataObj.player = GetLocalPlayerID(true);
      if (msgFmtObj) {
        dataObj.fmtKV = msgFmtObj;
      }
      if (item != null) {
        dataObj.item = item;
      }
      if (alert_unit != null) {
        dataObj.alert_unit = alert_unit;
      }
      GameEvents.SendCustomGameEventToAllClients(
        "show_custom_sys_msg",
        dataObj
      );
    }
  }
}

function SetDataToCustomUI(key, value) {
  GameUI.CustomUIConfig()[key] = value;
}

function GetDataFromCustomUI(key) {
  return GameUI.CustomUIConfig()[key];
}

function SetGlobalKV(key, value) {
  Game[key] = value;
}

function GetGlobalKV(key) {
  return Game[key];
}

function FindCursorItemID(itemName) {
  var entities = GameUI.FindScreenEntities(GameUI.GetCursorPosition());
  if (entities) {
    for (let k in entities) {
      var entity = entities[k].entityIndex;
      if (Entities.IsItemPhysical(entity)) {
        var idx = Entities.GetContainedItem(entity);
        //很奇葩，必须用这个转换一下才能获取到实际的物品id
        idx &= ~0xffffc000;
        if (Abilities.GetAbilityName(idx) == itemName) {
          return idx;
        }
      }
    }
  }
}

//计算长度
function Length(tab) {
  var len = 0;
  $.Each(tab, function (v, k) {
    len += 1;
  });
  return len;
}

//合并数组a,b
function MergeArray(a, b) {
  a.push(...b);
  return a;
}

// slice 截取分割 100,000,215
function FormatNumber(num, char = ",", length = 3) {
  let result = "";
  let nums = num.toString().split(".");
  let int = nums[0];
  let decmial = nums[1] ? "." + nums[1] : "";
  while (int.length > length) {
    result = char + int.slice(-length) + result;
    int = int.slice(0, int.length - length);
  }
  if (int) {
    result = int + result;
  }
  return result + decmial;
}

//随机数字
function RandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
/*
当前选中单位
var index=Players.GetLocalPlayerPortraitUnit()
var name=Entities.GetUnitName(index)
if(name.startsWith("name_")){
	if (IsLocalPlayerValid()) {
		 GameUI.SelectUnit(index,false)
		}
}
GameEvents.Subscribe("dota_player_update_selected_unit", OnClickShopNPC);
GameEvents.Subscribe("dota_player_update_query_unit", OnClickShopNPC);

*/

//<include src="file://{resources}/scripts/custom_game/custom_zmjj.js" />

//************Game.GetPlayerInfo(PlayerID)**********************
//{
//	"player_id": 0,
//	"player_name": "å½±å¾@å",
//	"player_connection_state": 2,
//	"player_steamid": "76561198109342076",
//	"player_kills": 5,
//	"player_deaths": 36,
//	"player_assists": 0,
//	"player_selected_hero_id": 2,
//	"player_selected_hero": "npc_dota_hero_axe",
//	"player_selected_hero_entity_index": 454,
//	"possible_hero_selection": "",
//	"player_level": 200,
//	"player_respawn_seconds": -1,
//	"player_gold": 0,
//	"player_team_id": 2,
//	"player_is_local": true,
//	"player_has_host_privileges": true
//}

function DeepPrint(Obj, indent) {
  indent = indent || 0;

  if (indent == 0) {
    $.Msg("{");
  }
  for (let key in Obj) {
    var value = Obj[key];
    if (typeof value == "object") {
      $.Msg(repeatStr("\t", indent) + key.toString() + ":");
      DeepPrint(value, indent + 1);
    } else if (typeof value == "function") {
      $.Msg(repeatStr("\t", indent) + key.toString() + ": function");
    } else {
      $.Msg(
        repeatStr("\t", indent) +
          key.toString() +
          ":" +
          (value != null ? value.toString() : "NULL")
      );
    }
  }
  if (indent == 0) {
    $.Msg("}");
  }
}

function repeatStr(str, times) {
  var result = "";
  for (var i = 0; i < times; i++) {
    result += str;
  }
  return result;
}

/**
 * 给panel添加标题+描述类型的悬浮提示
 *
 * @param panel
 * @param title
 *            标题文本，可以使字符串或者函数。如果是字符串，显示前会进行国际化；如果是函数，会将panel作为参数传入
 * @param text
 *            标题详情，可以使字符串或者函数。如果是字符串，显示前会进行国际化；如果是函数，会将panel作为参数传入
 */
function AddHoverTooltipWithTitle(panel, title, text) {
  panel.SetPanelEvent("onmouseover", function () {
    if (typeof title == "function") {
      title = title(panel);
    }

    if (typeof text == "function") {
      text = text(panel);
    }
    // 事件默认会对字符串进行格式化
    $.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, text);
  });

  panel.SetPanelEvent("onmouseout", function () {
    $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
  });
}
/**
 * 在指定面板上显示文本提示
 * @param panel  可以直接在ui中使用  $('#panelID')的方式，将面板直接传入
 * @param text DOTAShowTextTooltip这个函数可以直接使用不带引号的国际化串，比如DOTAShowTextTooltip(#aaa)，
 * 但是自定义的函数好像必须用引号括起来，参数要写成'#aaa'才行，否则会出错
 */
function UI_ShowTooltip(panel, text) {
  $.DispatchEvent("DOTAShowTextTooltip", panel, text);
}
/**
 * 隐藏指定面板上的文本提示
 * @param panel
 */
function UI_HideTooltip(panel) {
  $.DispatchEvent("DOTAHideTextTooltip", panel);
}

/**
 * 给panel添加纯文本类型的悬浮提示
 *
 * @param panel
 * @param text
 *            可以使字符串或者函数。如果是字符串，显示前会进行国际化；如果是函数，会将panel作为参数传入
 */
function AddHoverTooltip(panel, text) {
  panel.SetPanelEvent("onmouseover", function () {
    if (typeof text == "function") {
      text = text(panel);
    }
    // 事件默认会对字符串进行格式化
    $.DispatchEvent("DOTAShowTextTooltip", panel, text);
  });
  panel.SetPanelEvent("onmouseout", function () {
    $.DispatchEvent("DOTAHideTextTooltip", panel);
  });
}

/**
 * 技能图标默认是没有悬浮事件的，用此方法添加悬浮事件
 *
 * @param abilityPanel
 *            panel必须有abilityname属性代表对应的技能
 */
function AddAbilityImageTooltip(abilityPanel) {
  if (abilityPanel == null) {
    return;
  }
  abilityPanel.SetPanelEvent("onmouseover", function () {
    if (abilityPanel.abilityname) {
      if (abilityPanel.contextEntityIndex != null) {
        $.DispatchEvent(
          "DOTAShowAbilityTooltipForEntityIndex",
          abilityPanel,
          abilityPanel.abilityname,
          abilityPanel.contextEntityIndex
        );
      } else {
        $.DispatchEvent(
          "DOTAShowAbilityTooltip",
          abilityPanel,
          abilityPanel.abilityname
        );
      }
    }
  });

  abilityPanel.SetPanelEvent("onmouseout", function () {
    $.DispatchEvent("DOTAHideAbilityTooltip", abilityPanel);
  });
}
/**
 * 获取当前玩家id，如果当前玩家是观众，则获取当前玩家观察的单位所属玩家ID
 *
 * @returns
 */
function GetLocalPlayerID(noSpectatorCheck) {
  var PlayerID = Players.GetLocalPlayer();

  // 观战时这些函数的返回值：
  // [PanoramaScript] Players.IsSpectator(PlayerID)false
  // [PanoramaScript] Players.GetPerspectivePlayerId()-1
  // [PanoramaScript] Players.GetLocalPlayerPortraitUnit():430
  // [PanoramaScript] Game.GetLocalPlayerID():-1
  // [PanoramaScript] Players.GetLocalPlayer():-1

  // 这个好像不大好使，具体什么情况下生效没有研究，不考虑了
  // if (Players.IsSpectator(PlayerID)) {
  // PlayerID = Players.GetPerspectivePlayerId();
  // }

  if (!noSpectatorCheck && !Players.IsValidPlayerID(PlayerID)) {
    var unitIndex = Players.GetLocalPlayerPortraitUnit();
    if (Entities.IsValidEntity(unitIndex)) {
      PlayerID = Entities.GetPlayerOwnerID(unitIndex);
    } else {
      return -1;
    }
  }

  return PlayerID;
}
/**
 * 获取当前(观察的)玩家的英雄实体索引
 *
 * @returns
 */
function GetLocalPlayerHero(noSpectatorCheck) {
  return Players.GetPlayerHeroEntityIndex(GetLocalPlayerID(noSpectatorCheck));
}

/**
 * 当前玩家是否是一个有效玩家（非观战模式）
 *
 * @returns
 */
function IsLocalPlayerValid() {
  return Players.IsValidPlayerID(Players.GetLocalPlayer());
}

/** 本地是否在 Dota 工具模式（线上对局为 false） */
function ClrbIsLocalToolsMode() {
  try {
    return !!(Game.IsInToolsMode && Game.IsInToolsMode());
  } catch (e) {
    return false;
  }
}

/**
 * 与 ingame/Talent/Config.lua Talent.Equip 每级增量一致（修改 Config 后须同步此处）
 * item_goods_18：smzf 生命增幅每级 +5 → 累计 5% / 10% / … / 30%
 */
var CLRB_TALENT_EQUIP_RANK_INC = {
  item_goods_17: { gjsd: [30, 15, 15, 20, 30, 40], jcys: [15, 15, 15, 15, 15, 15] },
  item_goods_18: { smzf: [5, 5, 5, 5, 5, 5], wlkx: [4, 4, 4, 4, 4, 4] },
  item_goods_19: { jnzq: [4, 4, 4, 4, 4, 4], zyfw: [15, 15, 15, 15, 15, 15] },
  item_goods_24: { jcll: [6, 6, 6, 6, 6, 6] },
};

function ClrbBuildEquipCumulativeAttrNum(increments, asPercent) {
  var out = {};
  var sum = 0;
  if (!increments || !increments.length) {
    return out;
  }
  for (var i = 0; i < increments.length; i++) {
    sum += increments[i];
    out[i] = asPercent ? String(sum) + "%" : String(sum);
  }
  return out;
}

/** 用 Config 表覆盖 elsedata 中攻速/护甲/生命增幅/技能增强累计条（NetTable 未到时作兜底） */
function ClrbApplyTalentEquipBaseToElsedata(elsedata) {
  if (!elsedata) {
    return;
  }
  var inc17 = CLRB_TALENT_EQUIP_RANK_INC.item_goods_17;
  if (elsedata.item_goods_17 && inc17) {
    if (inc17.gjsd && elsedata.item_goods_17.attr_1) {
      elsedata.item_goods_17.attr_1.attr_num = ClrbBuildEquipCumulativeAttrNum(
        inc17.gjsd,
        false
      );
    }
    if (inc17.jcys && elsedata.item_goods_17.attr_2) {
      elsedata.item_goods_17.attr_2.attr_num = ClrbBuildEquipCumulativeAttrNum(
        inc17.jcys,
        false
      );
    }
  }
  var inc18 = CLRB_TALENT_EQUIP_RANK_INC.item_goods_18;
  if (elsedata.item_goods_18 && inc18) {
    if (inc18.wlkx && elsedata.item_goods_18.attr_1) {
      elsedata.item_goods_18.attr_1.attr_num = ClrbBuildEquipCumulativeAttrNum(
        inc18.wlkx,
        false
      );
    }
    if (inc18.smzf && elsedata.item_goods_18.attr_2) {
      elsedata.item_goods_18.attr_2.attr_num = ClrbBuildEquipCumulativeAttrNum(
        inc18.smzf,
        true
      );
    }
  }
  var inc19 = CLRB_TALENT_EQUIP_RANK_INC.item_goods_19;
  if (elsedata.item_goods_19 && inc19) {
    if (inc19.jnzq && elsedata.item_goods_19.attr_1) {
      elsedata.item_goods_19.attr_1.attr_num = ClrbBuildEquipCumulativeAttrNum(
        inc19.jnzq,
        true
      );
    }
    if (inc19.zyfw && elsedata.item_goods_19.attr_2) {
      elsedata.item_goods_19.attr_2.attr_num = ClrbBuildEquipCumulativeAttrNum(
        inc19.zyfw,
        false
      );
    }
  }
  var inc24 = CLRB_TALENT_EQUIP_RANK_INC.item_goods_24;
  if (elsedata.item_goods_24 && inc24) {
    if (inc24.jcll && elsedata.item_goods_24.attr_1) {
      elsedata.item_goods_24.attr_1.attr_num = ClrbBuildEquipCumulativeAttrNum(
        inc24.jcll,
        false
      );
    }
  }
}

/** 服务端同步的天赋装备 tooltip 基础属性（含铁匠 +30%） */
function ClrbGetTalentEquipTipNetRow() {
  var pid = GetLocalPlayerID();
  if (pid === undefined || pid === null || pid < 0) {
    return null;
  }
  return CustomNetTables.GetTableValue("clrb_talent_equip_tip", String(pid));
}

/** 用 NetTable 覆盖 elsedata 中攻速/护甲/生命增幅/技能增强累计条 */
function ClrbApplyTalentEquipTipNums(itemnum, itemdata) {
  if (!itemdata || !itemnum) {
    return itemdata;
  }
  var row = ClrbGetTalentEquipTipNetRow();
  if (!row || !row[itemnum]) {
    return itemdata;
  }
  var tip = row[itemnum];
  var applyAttr = function (dstAttr, srcAttr) {
    if (!dstAttr || !srcAttr || !srcAttr.attr_num) {
      return;
    }
    for (var i = 0; i < 6; i++) {
      var key = String(i);
      if (srcAttr.attr_num[key] !== undefined) {
        dstAttr.attr_num[i] = srcAttr.attr_num[key];
      }
    }
  };
  applyAttr(itemdata.attr_1, tip.attr_1);
  applyAttr(itemdata.attr_2, tip.attr_2);
  return itemdata;
}

/**
 * 本地玩家的英雄单位是否存活？ 仅当本地玩家有英雄，且英雄存活的时候返回true
 */
function IsLocalHeroAlive() {
  var hero = GetLocalPlayerHero(true);
  return Entities.IsAlive(hero);
}

function TimeStringLocalize(time) {
  if (typeof time != "string") {
    return time;
  }

  if ("schinese" == $.Language()) {
    return time;
  } else if (time.indexOf("-") > -1) {
    var a1 = time.split(" ");
    var a2 = a1[0].split("-");

    var pre = a1[0];
    if (a2.length == 3) {
      pre = a2[1] + "/" + a2[2] + "/" + a2[0];
    }

    if (a1.length == 2) {
      return pre + " " + a1[1];
    } else {
      return pre;
    }
  } else {
    return time;
  }
}

function IsFloatNumber(num) {
  if (isNaN(num)) {
    return false;
  }
  return Math.ceil(num) > num;
}

function SetDataToCustomUI(key, value) {
  GameUI.CustomUIConfig()[key] = value;
}

function GetDataFromCustomUI(key) {
  return GameUI.CustomUIConfig()[key];
}

/**
 * 在给定的label上显示一个可能会很大的数字，形式为：123,456,789 (1.23亿)
 * （用默认的SetDialogVariableInt只能支持2^31，要支持更大用这个）
 * @param number
 * @param label
 * @param hideSuffix 默认会在最后加上“(xxx万/亿)”，如果要去掉，设置此项为true
 */
function ShowLargeNumberForLabel(number, label, hideSuffix) {
  if (label) {
    number = number || 0;
    var text = FormatNumber2(number);

    if (!hideSuffix) {
      var value = null;
      if ("schinese" == $.Language()) {
        value = ShowChineseLargeNum(number);
      } else {
        value = ShowEnglishLargeNum(number);
      }

      if (value != number) {
        text = text + " (" + value + ")";
      }
    }
    label.text = text;
  }
}

function FormatNumber2(num) {
  if (isNaN(num)) {
    return num;
  }
  //只处理整数
  var num = Math.round(num).toString();
  var result = "";
  while (num.length > 3) {
    result = "," + num.slice(-3) + result;
    num = num.slice(0, num.length - 3);
  }
  if (num) {
    result = num + result;
  }
  return result;
}

/**
 * @param number 转化成xxx.xx万或者xxx.xx亿的形式。 如果小于10万，则返回number
 */
function ShowChineseLargeNum(number) {
  if (number < 100000) {
    return number;
  } else if (number < 100000000) {
    //万级(100W~1E)  //万
    return (number / 10000).toFixed(2) + $.Localize("#ui_large_number_unit_1");
  } else {
    //亿级  //亿
    return (
      (number / 100000000).toFixed(2) + $.Localize("#ui_large_number_unit_2")
    );
  }
}

/**
 * @param number 转化成xxx.xxM或者xxx.xxB的形式。 如果小于1M，则返回number
 */
function ShowEnglishLargeNum(number) {
  if (number < 1000000) {
    return number;
  } else if (number < 1000000000) {
    //xxx.xxM
    return (
      (number / 1000000).toFixed(2) + $.Localize("#ui_large_number_unit_1")
    );
  } else {
    //xxx.xxB
    return (
      (number / 1000000000).toFixed(2) + $.Localize("#ui_large_number_unit_2")
    );
  }
}

/**
 * 在指定面板上监听alt按键，当按下alt键的时候会给该面板添加class： AltPressed。
 * 如果需要执行某些操作可以传入callback函数。 但是因为调用频率很高，不知道效率怎么样
 */
//function SetAltListener(panel,callback){
//	panel.SetHasClass("AltPressed",GameUI.IsAltDown())
//
//	if (typeof(callback) == "function" && GameUI.IsAltDown()) {
//		callback()
//	}
//
//	$.Schedule(0.05,function(){
//		SetAltListener(panel)
//	})
//}

/**
 * 显示物品信息。 如果有自定义属性，显示自定义，否则显示默认的
 *
 * @param panel
 * @param itemName
 * @param itemID
 */
function ShowCustomItemTooltip(panel, itemName, itemID) {
  if (!panel) {
    return;
  }

  if (itemName == null && itemID == null) {
    itemName = panel.itemname;
    itemID = panel.contextEntityIndex;
  }

  if (itemID != null) {
    if (itemName == null) {
      itemName = Abilities.GetAbilityName(itemID);
    }
    if (itemName.startsWith("item_sj_") || itemName.startsWith("item_net_")) {
      DoShowCustomItemTooltip(panel, itemID);
    } else if (itemName.startsWith("item_sq_")) {
      $.DispatchEvent(
        "DOTAShowAbilityTooltipForEntityIndex",
        panel,
        itemName,
        itemID
      );
    } else {
      $.DispatchEvent("DOTAShowAbilityTooltip", panel, itemName);
    }
  } else if (itemName) {
    $.DispatchEvent("DOTAShowAbilityTooltip", panel, itemName);
  }
}

function DoShowCustomItemTooltip(panel, itemID) {
  GameUI.CustomUIConfig()["net_equip_temp_data"] = null;
  $.DispatchEvent(
    "UIShowCustomLayoutParametersTooltip",
    panel,
    "CustomItemTooltip",
    "file://{resources}/layout/custom_game/tooltips/random_item/random_item_tooltip.xml",
    "item=" + itemID
  );
}

function ShowNetEquipWithData(panel, data) {
  if (panel && data) {
    //自定义tooltip传参的时候，参数是有长度限制的（255），所以转成json串没法用了。这里用全局变量来存储。
    GameUI.CustomUIConfig()["net_equip_temp_data"] = data;
    $.DispatchEvent(
      "UIShowCustomLayoutParametersTooltip",
      panel,
      "CustomItemTooltip",
      "file://{resources}/layout/custom_game/tooltips/random_item/random_item_tooltip.xml",
      ""
    );
  }
}

/**
 * 隐藏某个面板上的所有物品信息
 * @param panel
 */
function HideCustomItemTooltip(panel) {
  if (!panel) {
    return;
  }
  $.DispatchEvent("UIHideCustomLayoutTooltip", panel, "CustomItemTooltip");
  $.DispatchEvent("DOTAHideAbilityTooltip", panel);
}

/**
 * label 当文本框内容超出实际大小时，悬浮提示其内容<br>
 * @param label
 * @param localize 默认只使用label的text进行显示，当文本内容有格式化内容的时候，需要先设置好格式化的SetDialogVariable相关值，然后这里传入国际化文本的key
 */
function LabelHoverShowValue(label, localize) {
  if (label.paneltype != "Label") {
    return;
  }
  label.hittest = true;
  label.SetPanelEvent("onmouseover", function () {
    if (
      label.contentwidth > label.actuallayoutwidth ||
      label.contentheight > label.actuallayoutheight
    ) {
      $.DispatchEvent(
        "DOTAShowTextTooltipStyled",
        label,
        localize || label.text,
        "LongTextTooltip"
      );
    }
  });
  label.SetPanelEvent("onmouseout", function () {
    $.DispatchEvent("DOTAHideTextTooltip", label);
  });
}

function GetNetEquipNameLocal(itemName, grade, quality, enhance) {
  var nameLocal = $.Localize("#DOTA_Tooltip_ability_" + itemName);

  var prefixKey = "item_net_prefix_g" + grade + "_q" + quality;
  var prefix = $.Localize(prefixKey);
  if (prefix != prefixKey) {
    nameLocal = prefix + nameLocal;
  }

  if (typeof enhance == "number" && enhance > 0) {
    nameLocal = nameLocal + " +" + enhance;
  }

  var color = NAME_COLORS_FOR_QUALITY[quality + ""];
  if (color) {
    return "<font color='" + color + "'>" + nameLocal + "</font>";
  } else {
    return nameLocal;
  }
}

function ShowBossDPSTooltip(panel, data) {
  if (panel && data) {
    //自定义tooltip传参的时候，参数是有长度限制的（255），所以转成json串没法用了。这里用全局变量来存储。
    GameUI.CustomUIConfig().boss_dps_tooltip = data;
    $.DispatchEvent(
      "UIShowCustomLayoutParametersTooltip",
      panel,
      "SurvivalStageBossTooltip",
      "file://{resources}/layout/custom_game/tooltips/stage_boss_dps/stage_boss_dps.xml",
      ""
    );
  }
}

function HideBossDPSTooltip(panel) {
  $.DispatchEvent(
    "UIHideCustomLayoutTooltip",
    panel,
    "SurvivalStageBossTooltip"
  );
}

/**
 * 使用一次商城道具，返回2代表需要发往服务器处理，返回1代表打开了其他界面
 * @param itemName
 * @returns {Boolean}
 */
function ConsumeStoreItem(itemName) {
  if (itemName && GameUI.CustomUIConfig().StoreData_items) {
    var item = GameUI.CustomUIConfig().StoreData_items[itemName];
    if (item) {
      if (item.catalog1 == "chest") {
        GameUI.CustomUIConfig().ShowChestUI(true, itemName);
        return 1;
      } else if (
        item.catalog1 == "consumable" &&
        (item.catalog2 == "enhance" || itemName.startsWith("shopmall_bs_tool_"))
      ) {
        GameUI.CustomUIConfig().ShowAttributeUI("NetEquip");

        if (itemName.startsWith("shopmall_sstone_")) {
          GameUI.CustomUIConfig().ShowEnhance(true);
        } else if (itemName.startsWith("shopmall_xlstone_")) {
          GameUI.CustomUIConfig().ShowNetEquipRefine(true);
        } else if (itemName.startsWith("shopmall_czstone_")) {
          GameUI.CustomUIConfig().ShowRecast(true);
        } else if (itemName.startsWith("shopmall_bs_tool_")) {
          GameUI.CustomUIConfig().ShowInlay(true);
        }

        return 1;
      } else {
        return 2;
      }
    }
  }
}

function StoreItemJump(item) {
  if (!item) {
    return;
  }

  if (item.catalog1 == "certificate") {
    if (item.catalog2 == "pass") {
      GameUI.CustomUIConfig().GD_SwitchTab(true, "pass");
    } else {
      GameUI.CustomUIConfig().GD_SwitchTab(true, "mine", 1, item.name);
    }
  } else {
    GameUI.CustomUIConfig().GD_SwitchTab(
      true,
      "warehouse",
      item.catalog1,
      item.catalog2,
      item.name
    );
  }
}

function GetNetEquipType(itemName) {
  if (typeof itemName == "string") {
    var array = itemName.split("_");
    if (array.length > 2) {
      return array[2];
    }
  }
}

function GetStoreItemCount(PlayerID, itemName) {
  var data = CustomNetTables.GetTableValue(
    "shopmall",
    "player_data_" + PlayerID
  );
  if (data && data[itemName]) {
    return data[itemName].stack || 1;
  }

  return 0;
}

function StoreItemComparator(str1, str2) {
  if (str1 == str2) {
    return 0;
  } else if (str1 == null && str2 != null) {
    return 1;
  } else if (str1 != null && str2 == null) {
    return -1;
  } else {
    var array1 = str1.split("_");
    var array2 = str2.split("_");
    if (array1.length == array2.length) {
      for (var int = 0; int < array1.length; int++) {
        var v1 = array1[int];
        var v2 = array2[int];
        if (v1 != v2) {
          if (isNaN(v1 - v2)) {
            return v1 < v2 ? -1 : 1;
          } else {
            return parseInt(v1) - parseInt(v2);
          }
        }
      }

      return 0;
    } else {
      return array1.length - array2.length;
    }
  }
}

//绑定技能.物品提示
function BindAbilityTip(abson, abname) {
  //默认测试
  if (abname) {
    //显示tip
    abson.SetPanelEvent("onmouseover", function () {
      $.DispatchEvent("DOTAShowAbilityTooltip", abson, abname);
    });
  }
  //移除tip
  abson.SetPanelEvent("onmouseout", function () {
    $.DispatchEvent("DOTAHideAbilityTooltip", abson);
  });
}

var Con_Rules = [
  [1, ""],
  [10000, "万"],
  [100000000, "亿"],
  [1000000000000, "万亿"],
  [10000000000000000, "京"],
  [100000000000000000000, "万京"],
];

function ConvertInt(num, fix) {
  if (typeof num !== "number") {
    num = Number(num);
  }
  var len = Con_Rules.length - 1;
  for (let i = len; i >= 0; i--) {
    let temp = Con_Rules[i];
    if (num >= temp[0]) {
      if (i == 0) {
        return Math.floor(num / temp[0]) + temp[1];
      } else {
        return (num / temp[0]).toFixed(fix) + temp[1];
      }
    }
  }
  return num + "";
}

function ConvertInt2(num, fix) {
  if (typeof num !== "number") {
    num = Number(num);
  }
  var len = Con_Rules.length - 1;
  for (let i = len; i >= 0; i--) {
    let temp = Con_Rules[i];
    if (num >= temp[0] && num > 100000) {
      return (num / temp[0]).toFixed(fix) + temp[1];
    }
  }
  return num.toFixed(fix) + "";
}

//时间格式化
function FormatTime2(time) {
  var minute = Math.floor(time / 60);
  var second = Math.floor(time % 60);
  return (
    (minute < 10 ? "0" + minute : minute) +
    ":" +
    (second < 10 ? "0" + second : second)
  );
}

//节流
var throttleData = {};
function ThrottleTool(panel) {
  if (!panel) {
    return;
  }
  var name = panel.id;
  if (!name) {
    return true;
  }
  if (throttleData[name]) {
    return;
  }
  throttleData[name] = true;
  $.Schedule(0.2, function () {
    throttleData[name] = false;
  });
  return true;
}

function deepEqual(obj1, obj2) {
  // 检查两者类型是否一致
  if (
    typeof obj1 !== "object" ||
    typeof obj2 !== "object" ||
    obj1 == null ||
    obj2 == null
  ) {
    return obj1 === obj2;
  }

  // 比较两个对象的键的数量
  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);
  if (keys1.length !== keys2.length) {
    return false;
  }

  // 递归比较每个键对应的值
  for (let key of keys1) {
    if (!keys2.includes(key)) {
      return false;
    }
    if (!deepEqual(obj1[key], obj2[key])) {
      return false;
    }
  }

  return true;
}

//节流
const LimiterNumRecord = {};
var LimiterSerial = 0;
const ResetTimers = {};
//无效点击累计上限
const LimitMax = 6;
//每次点击消除时间
const FadeTimer = 1;
//强制冷却时间
var CoolTime = 3;
var TimerRecord = 3;
function TimerCountDown() {
  if (TimerRecord > 0) {
    Timers(1, function () {
      TimerRecord--;
      TimerCountDown();
    });
  } else {
    TimerRecord = CoolTime;
  }
}
function BtnLimiter(pa, second) {
  if (IfPauseSendMsg()) {
    return true;
  }
  //给按钮自增编号
  if (pa == null) {
    return true;
  }
  if (pa.LimiterName == null) {
    pa.LimiterName = `${pa.id}_${LimiterSerial}`;
    LimiterSerial++;
  }

  //点击自增
  if (pa.LimiterName && typeof LimiterNumRecord[pa.LimiterName] != "number") {
    LimiterNumRecord[pa.LimiterName] = 0;
  } else if (
    pa.LimiterName &&
    typeof LimiterNumRecord[pa.LimiterName] == "number"
  ) {
    LimiterNumRecord[pa.LimiterName]++;
    //print("当前数量：" + LimiterNumRecord[pa.LimiterName])
    Timers(FadeTimer, function () {
      //print("点击消除")
      if (LimiterNumRecord[pa.LimiterName] > 0) {
        LimiterNumRecord[pa.LimiterName]--;
      }
      //print("当前数量：" + LimiterNumRecord[pa.LimiterName])
    });
  }

  //超过50直接忽略
  if (LimiterNumRecord[pa.LimiterName] > 50) {
    if (RandomInt(1, 500) <= 2) {
      SendServer("Js2Lua_NetMallUIConnect", {
        data: { tp: "btncooldown", TimerRecord },
      });
    }

    return true;
  }

  //如果还在CD
  if (ResetTimers[pa.LimiterName] == true) {
    SendServer("Js2Lua_NetMallUIConnect", {
      data: { tp: "btncooldown", TimerRecord },
    });
    return true;
  }

  //如果点到 则CD
  var limit = LimiterNumRecord[pa.LimiterName];
  if (typeof limit == "number" && limit >= LimitMax) {
    SendServer("Js2Lua_NetMallUIConnect", {
      data: { tp: "btncooldown", TimerRecord },
    });
    if (ResetTimers[pa.LimiterName] == true) {
      //print("正在冷却")
    } else {
      //print("创建计时器")
      ResetTimers[pa.LimiterName] = true;
      TimerCountDown();
      Timers(CoolTime, function () {
        //print("结束限制")
        ResetTimers[pa.LimiterName] = null;
      });
    }
    return true;
  }

  //是否已限制
  if (pa.enabledMark == true) {
    return true;
  } else {
    pa.enabledMark = true;
    Timers(second || 0.3, function () {
      if (pa) {
        pa.enabledMark = false;
      }
    });
  }
}

function IfPauseSendMsg() {
  if (Game.IsGamePaused()) {
    SendMsg("游戏暂停时不可用", 3, "simple");
    return true;
  }
}

function SendMsg(msg, state, tp) {
  GameUI.CustomUIConfig.AlterWindowPop_JS2JS_Fun({
    msg,
    state,
    tp,
  });
}

// 交易行防抖
function search(tp, page, orderby, sort, filterobj) {
  SendServer("Js2Lua_NetTradeUIConnect", {
    data: { tp, page, orderby, sort, filterobj },
  });
}
var timeout;
function debounce(func, wait) {
  return function (...args) {
    // 清除之前的定时器
    if (timeout) {
      $.CancelScheduled(timeout);
    }
    // 设定新的定时器
    timeout = $.Schedule(wait, function () {
      func.apply(this, args);
    });
  };
}
// 交易行计算天数
function calculateRemainingTime(endTime) {
  var now = new Date(); // 获取当前时间
  var end = new Date(endTime); // 将结束时间转换为 Date 对象
  var timeDifference = end - now; // 计算时间差

  if (timeDifference <= 0) {
    return "0秒"; // 如果时间差小于等于0，表示已经结束
  }

  var seconds = Math.floor(timeDifference / 1000); // 将毫秒转换为秒
  var minutes = Math.floor(seconds / 60); // 将秒转换为分
  var hours = Math.floor(minutes / 60); // 将分转换为小时
  var days = Math.floor(hours / 24); // 将小时转换为天

  return `${days}天${hours % 24}小时${minutes % 60}分`;
}
// 交易行交易时间
function formatIsoDate(isoDate) {
  const date = new Date(isoDate);

  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");

  return `${year}-${month}-${day} ${hours}:${minutes}`;
}
/*
sound: "ui_generic_button_click";
sound: "ui_select_md";
sound:"General.SelectAction";
sound: "ui.replay_dn_complete";
sound:"ui_rollover_sm";
*/


// 获取当前panel离窗口的偏移量
 function GetScreenOffset(panel) {
    var x = 0;
    var y = 0;
    var current = panel;

    // 1. 向上遍历父级
    while (current) {
        // 2. 累加每一层的偏移量
        x += current.actualxoffset;
        y += current.actualyoffset;

        // 3. 移动到父级
        current = current.GetParent();

        // 4. 安全退出条件
        // 如果到了最顶层，或者到达了 HUD/Menu 根节点，停止遍历
        if (!current || current.id === "Hud" || current.id === "Root") {
            break;
        }
    }

    return { x: x, y: y };
}

// ---------- Item icon paths (flash3) ----------
// BLoadLayout 子面板脚本是独立作用域，不能依赖父级已 include 的 item_icon_map.js；此处保证任意先加载 tools 的布局可用。
// 与 item_icon_map.js 保持同步；item_icon_map 在 tools 之后加载时若已存在则跳过定义。
var ItemIconTextureMap = {
  item_goods_11: "item_aegis",
  item_goods_23: "item_moon_shard",
  item_equip_4: "item_equpi_4",
};

function ResolveItemIconBaseName(item_name) {
  if (!item_name) {
    return item_name;
  }
  return ItemIconTextureMap[item_name] || item_name;
}

function GetItemIconFlash3Path(item_name) {
  var base = ResolveItemIconBaseName(item_name);
  return "raw://resource/flash3/images/items/" + base + ".png";
}

function GetItemIconTalentFlash3Path(item_name) {
  var b = ResolveItemIconBaseName(item_name);
  if (b !== item_name) {
    return "raw://resource/flash3/images/items/" + b + ".png";
  }
  return "raw://resource/flash3/images/items/" + item_name + "_y.png";
}

function ClrbDropInputFocusSafe() {
  try {
    $.DispatchEvent("DropInputFocus");
  } catch (e) {}
}

/** 仅面板打开时允许 TextEntry 抢焦点，避免 opacity:0 时隐形卡键 */
function ClrbSetTextEntryEnabled(entryPanel, enabled) {
  if (!entryPanel) {
    return;
  }
  entryPanel.hittest = !!enabled;
  if (entryPanel.SetAcceptsFocus) {
    entryPanel.SetAcceptsFocus(!!enabled);
  }
  if (
    !enabled &&
    entryPanel.BHasKeyFocus &&
    entryPanel.BHasKeyFocus()
  ) {
    ClrbDropInputFocusSafe();
  }
}

/** Dota Reborn 原生设置：保持 ButtonBar 可见，透明 SettingsRebornButton 叠在默认位置（勿 SetParent/transform） */
function ClrbFindSettingsRebornButton() {
  var hud = ClrbFindHudRoot();
  if (!hud || !hud.FindChildTraverse) {
    return null;
  }
  return hud.FindChildTraverse("SettingsRebornButton");
}

function ClrbEnsureNativeSettingsHud() {
  var hud = ClrbFindHudRoot();
  if (!hud || !hud.FindChildTraverse) {
    return null;
  }
  var buttonBar = hud.FindChildTraverse("ButtonBar");
  if (buttonBar) {
    buttonBar.visible = true;
    buttonBar.style.opacity = "1";
  }
  var dashboard = hud.FindChildTraverse("DashboardButton");
  if (dashboard) {
    dashboard.style.opacity = "0";
    dashboard.hittest = false;
  }
  var btn = hud.FindChildTraverse("SettingsRebornButton");
  if (btn) {
    btn.visible = true;
    btn.hittest = true;
    btn.style.opacity = "0.01";
  }
  return btn;
}

function ClrbScheduleSettingsButtonAlign(anchorPanelId) {
  function run() {
    try {
      ClrbEnsureNativeSettingsHud();
    } catch (e) {}
  }
  run();
  $.Schedule(0.1, run);
  $.Schedule(0.5, run);
  $.Schedule(1.0, run);
}

function ClrbOpenNativeSettings(anchorPanelId) {
  try {
    ClrbEnsureNativeSettingsHud();
  } catch (e) {}

  // 纵向原生设置弹窗（勿用 DOTAShowSettingsPopup）
  try {
    $.DispatchEvent("DOTAShowSettingsRebornPopup");
    return;
  } catch (e) {}

  var btn = ClrbFindSettingsRebornButton();
  if (!btn) {
    return;
  }
  // ingame 下 $.DispatchEvent("Activated", btn) 会报错，改在按钮自身上下文触发
  if (btn.RunScriptInPanelContext) {
    try {
      btn.RunScriptInPanelContext("$.DispatchEvent('Activated');");
      return;
    } catch (e2) {}
  }
}

/** 自定义菜单「设置」备用入口 */
function OpenSetting() {
  ClrbOpenNativeSettings("set_button_id");
}

function ClrbTryScheduleSettingsButtonAlign(anchorPanelId, attempt) {
  attempt = attempt || 0;
  try {
    ClrbScheduleSettingsButtonAlign(anchorPanelId);
  } catch (e) {
    if (attempt < 10) {
      $.Schedule(0.15, function () {
        ClrbTryScheduleSettingsButtonAlign(anchorPanelId, attempt + 1);
      });
    }
  }
}

function ClrbGetLocalTalentIndex() {
  var lp = Players.GetLocalPlayer();
  if (lp === -1) {
    return 1;
  }
  var row = CustomNetTables.GetTableValue("clrb_talent", String(lp));
  var ti = row && row.talent_index != null ? Number(row.talent_index) : 1;
  if (!isFinite(ti) || ti < 1 || ti > 9) {
    ti = 1;
  }
  return ti;
}

function ClrbGetLocalTalentSkillItemName() {
  return "item_talent_skill_" + ClrbGetLocalTalentIndex();
}

function ClrbGetLocalHeroTpSlotItemEnt() {
  var lp = Players.GetLocalPlayer();
  if (lp === -1) {
    return -1;
  }
  var hero = Players.GetPlayerHeroEntityIndex(lp);
  if (hero === -1) {
    return -1;
  }
  return Entities.GetItemInSlot(hero, 15);
}

function ClrbShowTalentTpTooltip(panel) {
  if (!panel) {
    return;
  }
  var itemName = ClrbGetLocalTalentSkillItemName();
  var itemEnt = ClrbGetLocalHeroTpSlotItemEnt();
  try {
    if (
      itemEnt !== -1 &&
      Abilities.GetAbilityName(itemEnt) === itemName
    ) {
      $.DispatchEvent(
        "DOTAShowAbilityTooltipForEntityIndex",
        panel,
        itemName,
        itemEnt
      );
    } else {
      $.DispatchEvent("DOTAShowAbilityTooltip", panel, itemName);
    }
  } catch (e) {
    $.DispatchEvent("DOTAShowAbilityTooltip", panel, itemName);
  }
  panel.style.tooltipPosition = "bottom";
}

function ClrbHideTalentTpTooltip(panel) {
  if (!panel) {
    return;
  }
  $.DispatchEvent("DOTAHideAbilityTooltip", panel);
  $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
}

function ClrbBindSingleTalentTpPanel(panel) {
  if (!panel || panel._clrb_talent_tp_bound) {
    return;
  }
  panel._clrb_talent_tp_bound = true;
  panel.hittest = true;
  var hideTimer = null;
  function clearHideTimer() {
    if (hideTimer != null) {
      $.CancelScheduled(hideTimer);
      hideTimer = null;
    }
  }
  WhenOver(panel, function () {
    clearHideTimer();
    ClrbShowTalentTpTooltip(panel);
  });
  WhenOut(panel, function () {
    clearHideTimer();
    hideTimer = $.Schedule(0.08, function () {
      hideTimer = null;
      ClrbHideTalentTpTooltip(panel);
    });
  });
}

function ClrbEnsureTalentTpTipLayer(hud) {
  if (!hud || !hud.FindChildTraverse) {
    return null;
  }
  var layer = hud.FindChildTraverse("ClrbTalentTpTipLayer");
  if (layer) {
    return layer;
  }
  var boxFun = hud.FindChildTraverse("BoxFun");
  var parent = boxFun && boxFun.GetParent ? boxFun.GetParent() : null;
  if (!parent) {
    return null;
  }
  layer = $.CreatePanel("Panel", parent, "ClrbTalentTpTipLayer");
  layer.hittest = false;
  layer.AddClass("ClrbTalentTpTipLayer");
  layer.style.width = "100%";
  layer.style.height = "100%";
  layer.style.zIndex = "505";
  return layer;
}

/** 自定义 HUD 层透明命中区：原生 TP 槽被 BoxFun/baghover 等挡住时由此显示 tooltip；成功返回 true */
function ClrbSyncTalentTpHoverProxy(hud) {
  if (!hud) {
    hud = ClrbFindHudRoot();
  }
  if (!hud || !hud.FindChildTraverse) {
    return false;
  }
  var tp = hud.FindChildTraverse("inventory_tpscroll_container");
  if (!tp) {
    return false;
  }
  var layer = ClrbEnsureTalentTpTipLayer(hud);
  if (!layer) {
    return false;
  }
  var cfg = GameUI.CustomUIConfig();
  var proxy = cfg._clrbTalentTpProxy;
  if (!proxy) {
    proxy = $.CreatePanel("Panel", layer, "clrb_talent_tp_hit");
    proxy.hittest = true;
    cfg._clrbTalentTpProxy = proxy;
    ClrbBindSingleTalentTpPanel(proxy);
  }
  try {
    var pos = tp.GetPositionWithinWindow();
    var w =
      tp.actuallayoutwidth != null && tp.actuallayoutwidth > 0
        ? tp.actuallayoutwidth
        : 54;
    var h =
      tp.actuallayoutheight != null && tp.actuallayoutheight > 0
        ? tp.actuallayoutheight
        : 54;
    proxy.style.width = Math.max(44, Math.floor(w)) + "px";
    proxy.style.height = Math.max(44, Math.floor(h)) + "px";
    proxy.style.horizontalAlign = "left";
    proxy.style.verticalAlign = "top";
    proxy.style.marginLeft = Math.floor(pos.x) + "px";
    proxy.style.marginTop = Math.floor(pos.y) + "px";
    proxy.visible = true;
    return true;
  } catch (e) {
    return false;
  }
}

function ClrbBindTalentTpPanelTree(panel, depth) {
  if (!panel || !panel.GetChildCount) {
    return;
  }
  depth = depth || 0;
  if (depth > 12) {
    return;
  }
  ClrbBindSingleTalentTpPanel(panel);
  var n = panel.GetChildCount();
  for (var i = 0; i < n; i++) {
    ClrbBindTalentTpPanelTree(panel.GetChild(i), depth + 1);
  }
}

var _clrbTalentTpNetSub = false;
var _clrbTalentTpBindDone = false;
var _clrbTalentTpHudFlipBound = false;
var CLRB_TALENT_TP_BIND_MAX_ATTEMPTS = 80;

function ClrbSubscribeTalentTpNetTable(tpContainer) {
  if (
    _clrbTalentTpNetSub ||
    !CustomNetTables ||
    !CustomNetTables.SubscribeNetTableListener
  ) {
    return;
  }
  _clrbTalentTpNetSub = true;
  CustomNetTables.SubscribeNetTableListener("clrb_talent", function () {
    try {
      var cfg = GameUI.CustomUIConfig();
      var proxy = cfg && cfg._clrbTalentTpProxy;
      if (proxy && proxy.IsHover && proxy.IsHover()) {
        ClrbShowTalentTpTooltip(proxy);
        return;
      }
      if (tpContainer && tpContainer.IsHover && tpContainer.IsHover()) {
        ClrbShowTalentTpTooltip(tpContainer);
      }
    } catch (e) {}
  });
}

/** 回城卷轴栏展示所选天赋 item_talent_skill_N；悬停显示完整 ability tooltip */
function ClrbBindTalentTpSlotTooltip(attempt) {
  if (_clrbTalentTpBindDone) {
    ClrbSyncTalentTpHoverProxy(null);
    return;
  }
  attempt = attempt || 0;
  var hud = $.GetContextPanel();
  while (hud && hud.GetParent()) {
    hud = hud.GetParent();
  }
  if (!hud || !hud.FindChildTraverse) {
    if (attempt < CLRB_TALENT_TP_BIND_MAX_ATTEMPTS) {
      $.Schedule(0.25, function () {
        ClrbBindTalentTpSlotTooltip(attempt + 1);
      });
    }
    return;
  }
  var tp = hud.FindChildTraverse("inventory_tpscroll_container");
  if (!tp) {
    if (attempt < CLRB_TALENT_TP_BIND_MAX_ATTEMPTS) {
      $.Schedule(0.25, function () {
        ClrbBindTalentTpSlotTooltip(attempt + 1);
      });
    }
    return;
  }
  tp.visible = true;
  ClrbBindTalentTpPanelTree(tp);
  var tpSlot = hud.FindChildTraverse("inventory_tpscroll");
  if (tpSlot) {
    ClrbBindTalentTpPanelTree(tpSlot);
  }
  if (!ClrbSyncTalentTpHoverProxy(hud)) {
    if (attempt < CLRB_TALENT_TP_BIND_MAX_ATTEMPTS) {
      $.Schedule(0.25, function () {
        ClrbBindTalentTpSlotTooltip(attempt + 1);
      });
    }
    return;
  }
  _clrbTalentTpBindDone = true;
  ClrbSubscribeTalentTpNetTable(tp);
  if (!_clrbTalentTpHudFlipBound) {
    _clrbTalentTpHudFlipBound = true;
    try {
      GameEvents.Subscribe("hud_flip_changed", function () {
        ClrbSyncTalentTpHoverProxy(null);
      });
    } catch (e) {}
  }
}

if (GameUI.CustomUIConfig()) {
  GameUI.CustomUIConfig().ClrbOpenNativeSettings = ClrbOpenNativeSettings;
  GameUI.CustomUIConfig().ClrbEnsureNativeSettingsHud = ClrbEnsureNativeSettingsHud;
  GameUI.CustomUIConfig().ClrbScheduleSettingsButtonAlign =
    ClrbScheduleSettingsButtonAlign;
  GameUI.CustomUIConfig().ClrbTryScheduleSettingsButtonAlign =
    ClrbTryScheduleSettingsButtonAlign;
  GameUI.CustomUIConfig().ClrbBindTalentTpSlotTooltip = ClrbBindTalentTpSlotTooltip;
  GameUI.CustomUIConfig().ClrbDropInputFocusSafe = ClrbDropInputFocusSafe;
  GameUI.CustomUIConfig().ClrbSetTextEntryEnabled = ClrbSetTextEntryEnabled;
}