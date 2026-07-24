--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


//初始化加载加载
function InitData() {
  var tp = "init";
  SendServer("Lua_Msgs", { data: { tp } });
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  SendServer("Lua_Msgs", { data: { tp } });
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_Msgs", { data: { tp } });
}

// var textdata={
//   item1:"获得金豆：",
//   item2:"",
// }


function RedeemRowsToArray(rows) {
  if (!rows) {
    return [];
  }
  if (Array.isArray(rows)) {
    return rows;
  }
  var arr = [];
  $.Each(rows, function (v, k) {
    arr.push({ k: k, v: v });
  });
  arr.sort(function (a, b) {
    return Number(a.k) - Number(b.k);
  });
  var out = [];
  for (var i = 0; i < arr.length; i++) {
    out.push(arr[i].v);
  }
  return out;
}

var MSG_PANEL_MIN_W = 439;
var MSG_PANEL_MIN_H = 239;
var MSG_REDEEM_EXTRA_W = 165;
var MSG_PANEL_MAX_W = 1100;

function ResetRedeemDialogSize() {
  var alterPanel = MsgFind("alter_panel");
  if (!alterPanel) {
    return;
  }
  alterPanel.style.width = MSG_PANEL_MIN_W + "px";
  alterPanel.style.height = MSG_PANEL_MIN_H + "px";
}

function UpdateRedeemDialogSize(itemCount) {
  var alterPanel = MsgFind("alter_panel");
  if (!alterPanel) {
    return;
  }
  var n = parseInt(itemCount, 10);
  if (isNaN(n) || n < 1) {
    n = 1;
  }
  if (n <= 1) {
    ResetRedeemDialogSize();
    return;
  }
  var w = MSG_PANEL_MIN_W + (n - 1) * MSG_REDEEM_EXTRA_W;
  if (w > MSG_PANEL_MAX_W) {
    w = MSG_PANEL_MAX_W;
  }
  alterPanel.style.width = w + "px";
  alterPanel.style.height = MSG_PANEL_MIN_H + "px";
}

// GameEvents 回调里 GetContextPanel 不一定是本布局，必须从 #Msg 起搜
function MsgHostRoot() {
  var p = GetPanel("Msg");
  if (p) {
    return p;
  }
  var root = GetRoot();
  return root;
}

//获取数据（子控件在 alter_panel 下嵌套，#id 可能找不到，用 FindChildTraverse）
function MsgFind(id) {
  var root = MsgHostRoot();
  if (!root || !root.FindChildTraverse) {
    return null;
  }
  return root.FindChildTraverse(id);
}

function ApplyRedeemRowIcon(iconImg, imgPath) {
  if (!iconImg) {
    return;
  }
  iconImg.SetImage(imgPath);
  var isTitleIcon = imgPath && (imgPath.indexOf("ch_clxx") >= 0 || imgPath.indexOf("ch_wrnd") >= 0 || imgPath.indexOf("ch_whcl") >= 0 || imgPath.indexOf("ch_clxz") >= 0 || imgPath.indexOf("ch_wszs") >= 0 || imgPath.indexOf("ch_hsbh") >= 0 || imgPath.indexOf("ch_hdlm") >= 0 || imgPath.indexOf("ch_ysqwh") >= 0 || imgPath.indexOf("ch_rzlf") >= 0 || imgPath.indexOf("ch_clls") >= 0 || imgPath.indexOf("ch_cllr") >= 0 || imgPath.indexOf("ch_clzw") >= 0 || imgPath.indexOf("ch_clmy") >= 0 || imgPath.indexOf("ch_clzy") >= 0 || imgPath.indexOf("ch_xxqc") >= 0 || imgPath.indexOf("ch_rzzl") >= 0);
  if (isTitleIcon) {
    iconImg.AddClass("redeem_icon_title");
    if (iconImg.SetScaling) {
      iconImg.SetScaling("stretch-to-fit-preserve-aspect");
    }
  } else {
    iconImg.RemoveClass("redeem_icon_title");
    if (iconImg.SetScaling) {
      iconImg.SetScaling("stretch");
    }
  }
}

function MsgSyncHostOverlay(pageOpen) {
  var root = MsgHostRoot();
  if (!root) {
    return;
  }
  var host = root;
  while (host && host.id !== "alter_container" && host.id !== "Msg") {
    host = host.GetParent();
  }
  if (host) {
    host.hittest = !!pageOpen;
  }
}

//获取数据
function GetData(data) {
  if (!data) {
    return;
  }
  if (
    GameUI.CustomUIConfig() &&
    GameUI.CustomUIConfig().ClrbSelectHeroMsgHandlesEvents
  ) {
    return;
  }

  var root = MsgHostRoot();
  if (!root) {
    return;
  }
  if (data.page == 1) {
    root.visible = true;
    MsgSyncHostOverlay(true);
  } else {
    root.visible = false;
    MsgSyncHostOverlay(false);
  }

  var titleLbl = MsgFind("title_text");
  if (titleLbl && data.text != null) {
    titleLbl.text = data.text;
  }

  var panel = MsgFind("item_box");
  if (!panel) {
    return;
  }
  panel.RemoveAndDeleteChildren();
  panel.RemoveClass("ItemBoxRedeem");
  ResetRedeemDialogSize();

  var elsetext = MsgFind("elsetext");
  if (!elsetext) {
    return;
  }
  elsetext.visible = false;

  if (data.redeem_state === "ok") {
    panel.AddClass("ItemBoxRedeem");
    var rlist = RedeemRowsToArray(data.redeem_rows);
    for (var ri = 0; ri < rlist.length; ri++) {
      var row = rlist[ri];
      if (!row) {
        continue;
      }
      var rpanel = NewPanel(panel, "redeem_row_" + ri, "Panel");
      rpanel.BLoadLayoutSnippet("redeem_row_snippet");
      var iconImg = rpanel.FindChildTraverse("redeem_icon");
      if (row.img) {
        rpanel.RemoveClass("redeem_row_no_icon");
        if (iconImg) {
          iconImg.visible = true;
          ApplyRedeemRowIcon(iconImg, row.img);
        }
      } else {
        rpanel.AddClass("redeem_row_no_icon");
        if (iconImg) {
          iconImg.visible = false;
        }
      }
      var cnt = row.count != null ? row.count : "";
      var u = row.unit ? " " + row.unit : "";
      var countLbl = rpanel.FindChildTraverse("redeem_count");
      if (countLbl) {
        countLbl.text = "×" + cnt + u;
      }
    }
    UpdateRedeemDialogSize(rlist.length);
  } else if (data.redeem_state === "fail") {
    elsetext.visible = true;
    elsetext.text = "请重新尝试";
  } else if (data.item_state && data.item) {
    var itemdata = data.item;
    // $.Each 表为 (值, 键)，与 tools.js 中 Length 一致
    $.Each(itemdata, function (v, k) {
      var sonpanel = NewPanel(panel, k, "Panel");
      sonpanel.BLoadLayoutSnippet("item_snippet");
      if (k == "item1") {
        sonpanel.FindChildTraverse("item_name").text = "获得";
        sonpanel.FindChildTraverse("item_num").text = v + "金豆";
      } else if (k == "item2") {
        sonpanel.FindChildTraverse("item_name").text = "已激活月卡";
        sonpanel.FindChildTraverse("item_num").text = "";
      }
    });
    if (Length(itemdata) == 0) {
      elsetext.visible = true;
      elsetext.text = "请重新尝试";
    }
  }
}

(function () {
  InitData();
  SubEvent("UI_Msgs", GetData);
})();