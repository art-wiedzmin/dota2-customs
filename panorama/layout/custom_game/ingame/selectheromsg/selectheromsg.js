--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


/**
 * 选人界面奖励/兑换结果弹窗（独立子页，显隐方式对齐 Code 二维码支付）
 */
var SELECTHERO_MSG_PANEL_MIN_W = 439;
var SELECTHERO_MSG_PANEL_MIN_H = 239;
var SELECTHERO_MSG_REDEEM_EXTRA_W = 165;
var SELECTHERO_MSG_PANEL_MAX_W = 1100;

function SelectHeroMsgFind(id) {
  var root = GetRoot();
  if (!root || !root.FindChildTraverse) {
    return null;
  }
  return root.FindChildTraverse(id);
}

function SelectHeroMsgResetDialogSize() {
  var alterPanel = SelectHeroMsgFind("alter_panel");
  if (!alterPanel) {
    return;
  }
  alterPanel.style.width = SELECTHERO_MSG_PANEL_MIN_W + "px";
  alterPanel.style.height = SELECTHERO_MSG_PANEL_MIN_H + "px";
}

function SelectHeroMsgUpdateDialogSize(itemCount) {
  var alterPanel = SelectHeroMsgFind("alter_panel");
  if (!alterPanel) {
    return;
  }
  var n = parseInt(itemCount, 10);
  if (isNaN(n) || n < 1) {
    n = 1;
  }
  if (n <= 1) {
    SelectHeroMsgResetDialogSize();
    return;
  }
  var w = SELECTHERO_MSG_PANEL_MIN_W + (n - 1) * SELECTHERO_MSG_REDEEM_EXTRA_W;
  if (w > SELECTHERO_MSG_PANEL_MAX_W) {
    w = SELECTHERO_MSG_PANEL_MAX_W;
  }
  alterPanel.style.width = w + "px";
  alterPanel.style.height = SELECTHERO_MSG_PANEL_MIN_H + "px";
}

function SelectHeroMsgRedeemRowsToArray(rows) {
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

function SelectHeroMsgApplyRedeemRowIcon(iconImg, imgPath) {
  if (!iconImg) {
    return;
  }
  iconImg.SetImage(imgPath);
  var isTitleIcon =
    imgPath &&
    (imgPath.indexOf("ch_clxx") >= 0 || imgPath.indexOf("ch_wrnd") >= 0 || imgPath.indexOf("ch_whcl") >= 0 || imgPath.indexOf("ch_clxz") >= 0 || imgPath.indexOf("ch_wszs") >= 0 || imgPath.indexOf("ch_hsbh") >= 0 || imgPath.indexOf("ch_hdlm") >= 0 || imgPath.indexOf("ch_ysqwh") >= 0 || imgPath.indexOf("ch_rzlf") >= 0 || imgPath.indexOf("ch_clls") >= 0 || imgPath.indexOf("ch_cllr") >= 0 || imgPath.indexOf("ch_clzw") >= 0 || imgPath.indexOf("ch_clmy") >= 0 || imgPath.indexOf("ch_clzy") >= 0 || imgPath.indexOf("ch_xxqc") >= 0 || imgPath.indexOf("ch_rzzl") >= 0);
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

function SelectHeroMsgSetVisible(pageOpen) {
  var root = GetRoot();
  if (!root || !root.style) {
    return;
  }
  root.style.opacity = pageOpen ? "1" : "0";
  root.hittest = !!pageOpen;

  var host = root.GetParent && root.GetParent();
  if (host && host.id === "alter_container") {
    host.hittest = !!pageOpen;
  }
}

function SelectHeroMsgClosePage() {
  SendServer("Lua_Msgs", { data: { tp: "ClosePage" } });
}

function SelectHeroMsgForceClose() {
  SelectHeroMsgSetVisible(false);
}

function SelectHeroMsgIsOpen(page) {
  return page === true || page === 1 || page === "1";
}

function SelectHeroMsgGetData(data) {
  if (!data) {
    return;
  }

  var pageOpen = SelectHeroMsgIsOpen(data.page);
  SelectHeroMsgSetVisible(pageOpen);

  var titleLbl = SelectHeroMsgFind("title_text");
  if (titleLbl && data.text != null) {
    titleLbl.text = data.text;
  }

  var panel = SelectHeroMsgFind("item_box");
  if (!panel) {
    return;
  }
  panel.RemoveAndDeleteChildren();
  panel.RemoveClass("ItemBoxRedeem");
  SelectHeroMsgResetDialogSize();

  var elsetext = SelectHeroMsgFind("elsetext");
  if (!elsetext) {
    return;
  }
  elsetext.visible = false;

  if (data.redeem_state === "ok") {
    panel.AddClass("ItemBoxRedeem");
    var rlist = SelectHeroMsgRedeemRowsToArray(data.redeem_rows);
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
          SelectHeroMsgApplyRedeemRowIcon(iconImg, row.img);
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
    SelectHeroMsgUpdateDialogSize(rlist.length);
  } else if (data.redeem_state === "fail") {
    elsetext.visible = true;
    elsetext.text = "请重新尝试";
  } else if (data.item_state && data.item) {
    var itemdata = data.item;
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
  GameUI.CustomUIConfig().ClrbSelectHeroMsgHandlesEvents = true;
  GameUI.CustomUIConfig().SelectHeroMsg_ForceClose = SelectHeroMsgForceClose;
  SendServer("Lua_Msgs", { data: { tp: "init" } });
  SubEvent("UI_Msgs", SelectHeroMsgGetData);
})();