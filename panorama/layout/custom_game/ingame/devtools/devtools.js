--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


var DevToolsReady = false;

var DevToolsEnabled = false;

var DevToolsSlideOpen = false;

var DevToolsHideVisibleSeq = 0;



/** 面板宽度 400 + 边距，向左滑出屏幕 */

var DEVTOOLS_SLIDE_X_HIDDEN = -412;

var DEVTOOLS_ANIM_SHOW_SEC = "0.16s";

var DEVTOOLS_ANIM_HIDE_SEC = "0.14s";



function DevToolsIsLocalMode() {

  return typeof ClrbIsLocalToolsMode === "function" && ClrbIsLocalToolsMode();

}



function DevToolsIsEnabledFlag(v) {

  return v === true || v === 1 || v === "1" || v === "true";

}



function DevToolsGetRoot() {

  return GetRoot();

}



function DevToolsGetSlidePanel() {

  return $("#devtools_slide");

}



function DevToolsShowAnimated(slide) {

  if (!slide || !slide.IsValid()) {

    return;

  }

  slide.style.transitionDuration = "0s";

  slide.style.transitionProperty = "none";

  slide.style.transform = "translateX(" + DEVTOOLS_SLIDE_X_HIDDEN + "px)";

  slide.style.opacity = "0";

  $.Schedule(0.01, function () {

    if (!slide || !slide.IsValid()) {

      return;

    }

    slide.style.transitionDuration = DEVTOOLS_ANIM_SHOW_SEC;

    slide.style.transitionProperty = "transform, opacity";

    slide.style.transitionTimingFunction = "ease-out";

    slide.style.transform = "translateX(0px)";

    slide.style.opacity = "1";

  });

}



function DevToolsHideAnimated(slide) {

  if (!slide || !slide.IsValid()) {

    return;

  }

  slide.style.transitionDuration = DEVTOOLS_ANIM_HIDE_SEC;

  slide.style.transitionProperty = "transform, opacity";

  slide.style.transitionTimingFunction = "ease-in";

  slide.style.transform = "translateX(" + DEVTOOLS_SLIDE_X_HIDDEN + "px)";

  slide.style.opacity = "0";

}



function DevToolsSnapVisible(slide) {

  if (!slide || !slide.IsValid()) {

    return;

  }

  slide.style.transitionDuration = "0s";

  slide.style.transitionProperty = "none";

  slide.style.transform = "translateX(0px)";

  slide.style.opacity = "1";

}



function DevToolsSnapHidden(slide) {

  if (!slide || !slide.IsValid()) {

    return;

  }

  slide.style.transitionDuration = "0s";

  slide.style.transitionProperty = "none";

  slide.style.transform = "translateX(" + DEVTOOLS_SLIDE_X_HIDDEN + "px)";

  slide.style.opacity = "0";

}



function DevToolsUpdateSlideClasses() {

  var root = DevToolsGetRoot();

  if (!root) {

    return;

  }

  if (DevToolsSlideOpen) {

    root.AddClass("devtools_slide_open");

    root.RemoveClass("devtools_slide_closed");

  } else {

    root.AddClass("devtools_slide_closed");

    root.RemoveClass("devtools_slide_open");

  }

}



function DevToolsApplySlideState(animated) {

  var slide = DevToolsGetSlidePanel();

  if (!slide) {

    return;

  }

  DevToolsUpdateSlideClasses();

  if (DevToolsSlideOpen) {

    if (animated) {

      DevToolsShowAnimated(slide);

    } else {

      DevToolsSnapVisible(slide);

    }

  } else if (animated) {

    DevToolsHideAnimated(slide);

  } else {

    DevToolsSnapHidden(slide);

  }

}



function DevToolsToggleSlide() {

  if (!DevToolsEnabled || !DevToolsIsLocalMode()) {

    return;

  }

  DevToolsSlideOpen = !DevToolsSlideOpen;

  DevToolsHideVisibleSeq++;

  DevToolsApplySlideState(true);

}



function DevToolsHide() {

  var root = DevToolsGetRoot();

  if (!root) {

    return;

  }

  DevToolsEnabled = false;

  DevToolsHideVisibleSeq++;

  root.RemoveClass("devtools_visible");

  root.AddClass("devtools_hidden");

  root.style.visibility = "collapse";

  root.style.opacity = "0";

}



function DevToolsShow() {

  var root = DevToolsGetRoot();

  if (!root) {

    return;

  }

  DevToolsEnabled = true;

  root.RemoveClass("devtools_hidden");

  root.AddClass("devtools_visible");

  root.style.visibility = "visible";

  root.style.opacity = "1";

  DevToolsApplySlideState(false);

}



function DevToolsRequestInit() {

  if (!DevToolsIsLocalMode()) {

    return;

  }

  SendServer("Lua_DevTools", { data: { tp: "init" } });

}



function DevToolsScheduleInitSync() {

  if (!DevToolsIsLocalMode()) {

    DevToolsHide();

    return;

  }

  DevToolsRequestInit();

  var delays = [0.5, 1.5, 3, 8];

  for (var i = 0; i < delays.length; i++) {

    (function (sec) {

      $.Schedule(sec, function () {

        if (!DevToolsIsLocalMode()) {

          DevToolsHide();

          return;

        }

        if (!DevToolsReady) {

          DevToolsRequestInit();

        }

      });

    })(delays[i]);

  }

}



function DevToolsNormalizeTools(keys) {

  if (!keys) {

    return [];

  }

  if (keys.tools_json) {

    try {

      var parsed = JSON.parse(keys.tools_json);

      if (Array.isArray(parsed)) {

        return parsed;

      }

    } catch (e) {

      $.Msg("[DevTools] tools_json parse failed:", e);

    }

  }

  if (Array.isArray(keys.tools)) {

    return keys.tools.slice();

  }

  var tab = keys.tools;

  if (tab && typeof tab === "object") {

    var out = [];

    var n = typeof Length === "function" ? Length(tab) : 0;

    for (var i = 1; i <= n; i++) {

      if (tab[i]) {

        out.push(tab[i]);

      }

    }

    if (out.length) {

      return out;

    }

  }

  return [];

}



function DevToolsMergeTools(keys) {

  var out = DevToolsNormalizeTools(keys);

  var seen = {};

  var i;

  for (i = 0; i < out.length; i++) {

    if (out[i] && out[i].cmd) {

      seen[out[i].cmd] = true;

    }

  }

  var extra = typeof CLRB_DEVTOOLS_EXTRA !== "undefined" ? CLRB_DEVTOOLS_EXTRA : [];

  for (i = 0; i < extra.length; i++) {

    var row = extra[i];

    if (!row || !row.cmd || seen[row.cmd]) {

      continue;

    }

    out.push({

      cmd: row.cmd,

      label: row.label || row.cmd,

      group: row.group || "自定义",

    });

    seen[row.cmd] = true;

  }

  out.sort(function (a, b) {

    if (a.group !== b.group) {

      return String(a.group) < String(b.group) ? -1 : 1;

    }

    return String(a.label) < String(b.label) ? -1 : 1;

  });

  return out;

}



function DevToolsRunCmd(cmd) {

  if (!cmd || !DevToolsIsLocalMode()) {

    return;

  }

  SendServer("Lua_DevTools", { data: { tp: "run", cmd: String(cmd) } });

}



function DevToolsBeginButtonRow(list, state) {
  state.rowIndex += 1;
  state.colInRow = 0;
  state.rowPanel = $.CreatePanel("Panel", list, "devtools_row_" + state.rowIndex);
  state.rowPanel.AddClass("devtools_btn_row");
  return state.rowPanel;
}

function DevToolsGetButtonRow(list, state) {
  if (!state.rowPanel || state.colInRow >= 2) {
    DevToolsBeginButtonRow(list, state);
  }
  state.colInRow += 1;
  return state.rowPanel;
}

function DevToolsFormatButtonLabel(label, cmd) {
  var name = label || cmd || "";
  if (!cmd || name === cmd) {
    return name;
  }
  return name + " · " + cmd;
}

function DevToolsBuildList(tools) {
  var list = $("#devtools_list");
  if (!list) {
    return;
  }
  list.RemoveAndDeleteChildren();
  var lastGroup = null;
  var state = { rowPanel: null, colInRow: 0, rowIndex: 0 };
  var i;
  for (i = 0; i < tools.length; i++) {
    var row = tools[i];
    if (!row || !row.cmd) {
      continue;
    }
    var group = row.group || "其他";
    if (group !== lastGroup) {
      lastGroup = group;
      state.rowPanel = null;
      state.colInRow = 0;
      var title = $.CreatePanel("Label", list, "devtools_group_" + i);
      title.AddClass("devtools_group_title");
      title.AddClass("yahei");
      title.text = group;
    }
    var rowPanel = DevToolsGetButtonRow(list, state);
    (function (cmd, label) {
      var btn = $.CreatePanel("Button", rowPanel, "devtools_btn_" + cmd);
      btn.AddClass("devtools_btn");
      var lbl = $.CreatePanel("Label", btn, "");
      lbl.text = DevToolsFormatButtonLabel(label, cmd);
      btn.SetPanelEvent("onactivate", function () {
        DevToolsRunCmd(cmd);
      });
    })(row.cmd, row.label);
  }
}



function DevToolsOnData(keys) {

  if (!DevToolsIsLocalMode()) {

    DevToolsHide();

    return;

  }

  if (!keys || !DevToolsIsEnabledFlag(keys.enabled)) {

    DevToolsHide();

    return;

  }

  DevToolsShow();

  DevToolsBuildList(DevToolsMergeTools(keys));

  DevToolsReady = true;

}



function DevToolsInit() {

  DevToolsHide();

  if (!DevToolsIsLocalMode()) {

    return;

  }

  DevToolsSlideOpen =

    typeof CLRB_DEVTOOLS_UI !== "undefined" &&

    CLRB_DEVTOOLS_UI.start_collapsed !== true;

  SubEvent("UI_DevTools", DevToolsOnData);

  $.Schedule(0.2, function () {

    DevToolsScheduleInitSync();

  });

}



(function () {

  DevToolsInit();

})();
