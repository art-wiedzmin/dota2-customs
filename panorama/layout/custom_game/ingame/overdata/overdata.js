/** 与每日完赛金豆服务端上限一致（仅展示用，写死） */
var DAILY_GAME_BONUS_CAP = 5;

var OVER_SUBMIT_MSG = {
  loading: "结算数据载入中...",
};

/** 结算页底部：上报 loading / ok / fail 与按钮显隐 */
function applyOverSubmitFooter(status) {
  var st = status != null ? String(status) : "";
  var loading = st === "loading";
  var ok = st === "ok";
  var fail = st === "fail";
  var skip = st === "skip";
  var showButtons = ok || fail || skip;

  var statusLbl = GetPanel("over_submit_status_label");
  if (statusLbl) {
    if (loading) {
      statusLbl.text = OVER_SUBMIT_MSG.loading;
      statusLbl.AddClass("visible");
      statusLbl.RemoveClass("fail");
    } else {
      // 失败时不再提示「网络异常，本次游戏数据录入失败」
      statusLbl.text = "";
      statusLbl.RemoveClass("visible");
      statusLbl.RemoveClass("fail");
    }
  }

  var exitBtn = GetPanel("over_button");
  if (exitBtn) {
    exitBtn.visible = showButtons;
  }
  var closePageBtn = GetPanel("over_close_page_button");
  if (closePageBtn) {
    closePageBtn.visible = showButtons;
  }
  var btnRow = GetPanel("over_footer_buttons");
  if (btnRow) {
    btnRow.visible = showButtons;
  }
}

function resetOverSubmitFooter() {
  applyOverSubmitFooter("");
}

function InitData() {
  resetOverSubmitFooter();
  var tp = "init";
  SendServer("Lua_OverData", { data: { tp } });
}

function GetData(data) {
  if (!data) {
    return;
  }
  var pageOn = data.page === 1 || data.page === true;
  if (!pageOn) {
    GetRoot().style.opacity = 0;
    GetRoot().hittest = false;
    resetOverSubmitFooter();
  } else {
    GetRoot().style.opacity = 1;
    GetRoot().hittest = true;
    var submitStatus = data.submit_status;
    if (
      (submitStatus === undefined || submitStatus === null || submitStatus === "") &&
      pageOn
    ) {
      submitStatus = "loading";
    }
    applyOverSubmitFooter(submitStatus);
  }
  GetPanel("game_time_num").text = data.time + "分钟";
  var prophecyLbl = GetPanel("prophecy_bonus_label");
  if (prophecyLbl) {
    var pg = parseInt(data.prophecy_bonus_gold, 10) || 0;
    if (pg > 0) {
      prophecyLbl.text = "预言奖励：" + pg + "金豆";
      prophecyLbl.AddClass("visible");
    } else {
      prophecyLbl.RemoveClass("visible");
      prophecyLbl.text = "";
    }
  }
  var bonusLbl = GetPanel("daily_game_bonus_label");
  if (bonusLbl) {
    var tpcf = parseInt(data.tpcf, 10);
    if (!isNaN(tpcf) && tpcf > 0) {
      bonusLbl.text = "剩余每日金豆无法获取惩罚" + tpcf + "局";
    } else {
      var n = data.daily_game_bonus_today;
      if (n === undefined || n === null || n < 0) {
        bonusLbl.text = "今日完赛30金豆奖励：--/" + DAILY_GAME_BONUS_CAP;
      } else {
        bonusLbl.text =
          "今日完赛30金豆奖励：" + n + "/" + DAILY_GAME_BONUS_CAP;
      }
    }
  }
  if (data.tp == 1) {
    // 5v5
    // print(data.data.team_1)
    GetPanel("box_1").visible = true;
    GetPanel("box_2").visible = false;
    if (!data.data.team_1) {
      return;
    }
    var team_1 = data.data.team_1;
    GetPanel("jifen_1").text = "积分: " + team_1.kill;

    var panel_1 = GetPanel("list_box_1");
    panel_1.RemoveAndDeleteChildren();
    for (var i = 1; i <= 5; i++) {
      if (team_1.list["player_" + i]) {
        if (team_1.list["player_" + i].state !== 0) {
          var sonpanel = NewPanel(panel_1, "player_" + i, "Panel");
          sonpanel.BLoadLayoutSnippet("rank_snippet");
          var playdata = team_1.list["player_" + i];
          SetPlayer(sonpanel, playdata, data.tp);
        }
      }
    }
    if (!data.data.team_2) {
      return;
    }
    var team_2 = data.data.team_2;
    GetPanel("jifen_2").text = "积分: " + team_2.kill;

    var panel_2 = GetPanel("list_box_2");
    panel_2.RemoveAndDeleteChildren();
    for (var i = 1; i <= 5; i++) {
      if (team_2.list["player_" + i]) {
        if (team_2.list["player_" + i].state !== 0) {
          var sonpanel = NewPanel(panel_2, "player_" + i, "Panel");
          sonpanel.BLoadLayoutSnippet("rank_snippet");
          var playdata = team_2.list["player_" + i];
          SetPlayer(sonpanel, playdata, data.tp);
        }
      }
    }

    if (team_1.kill > team_2.kill) {
      GetPanel("sucess_text_1").text = "胜利";
      GetPanel("sucess_text_2").text = "失败";
    } else if (team_1.kill < team_2.kill) {
      GetPanel("sucess_text_1").text = "失败";
      GetPanel("sucess_text_2").text = "胜利";
    } else {
      GetPanel("sucess_text_1").text = "";
      GetPanel("sucess_text_2").text = "";
    }
  } else if (data.tp == 3) {
    GetPanel("box_1").visible = false;
    GetPanel("box_2").visible = true;
    var panel34 = GetPanel("list_box");
    panel34.RemoveAndDeleteChildren();
    var teams34 = [];
    for (var ti = 1; ti <= 4; ti++) {
      var tk = "team_" + ti;
      var tdata = data.data[tk];
      if (tdata && tdata.list) {
        teams34.push({ key: tk, slot: ti, data: tdata });
      }
    }
    teams34.sort(function (a, b) {
      var kb = Number(b.data.kill) || 0;
      var ka = Number(a.data.kill) || 0;
      if (kb !== ka) {
        return kb - ka;
      }
      return (a.slot || 0) - (b.slot || 0);
    });
    var rowIx = 0;
    for (var tj = 0; tj < teams34.length; tj++) {
      var tdata = teams34[tj].data;
      var tk = teams34[tj].key;
      for (var pi = 1; pi <= 3; pi++) {
        var pk = "player_" + pi;
        var playdata = tdata.list[pk];
        if (playdata && playdata.state !== 0) {
          var sonpanel = NewPanel(panel34, tk + "_" + pk + "_" + rowIx, "Panel");
          sonpanel.BLoadLayoutSnippet("rank_snippet");
          SetPlayer(sonpanel, playdata, 3);
          rowIx++;
        }
      }
    }
  } else if (data.tp == 2) {
    // 1v1
    GetPanel("box_1").visible = false;
    GetPanel("box_2").visible = true;
    var panel = GetPanel("list_box");
    panel.RemoveAndDeleteChildren();
    var listlength = Length(data.data);
    for (var i = 1; i <= listlength; i++) {
      $.Each(data.data, function (v, k) {
        if (v.state == 1) {
          var slot = v.slot;
          var playerkey = "player_" + slot;
          var rank = v.list[playerkey].rank;
          if (rank == i) {
            var sonpanel = NewPanel(panel, "player_" + i, "Panel");
            sonpanel.BLoadLayoutSnippet("rank_snippet");
            SetPlayer(sonpanel, v.list[playerkey], data.tp);
          }
        }
      });
    }
  }
}
var colortab = {
  1: "#3476FF",
  2: "#C44DA9",
  3: "#5FBB0D",
  4: "#F7C300",
  5: "#C6D501",
  6: "#FF6F00",
  7: "#0FB2DC",
  8: "#35C09A",
  9: "#9443FE",
  10: "#855539",
};
// 每一条个人计分
function SetPlayer(panel, data, modetype) {
  // rank_3x4：左侧大数字为队伍总击杀（胜利目标见服务端 team_kill_3x4）；K/D/A 仍为个人
  if (modetype == 3) {
    var tk = data.team_kill;
    panel.FindChildTraverse("color_num").text =
      tk !== undefined && tk !== null ? tk : data.kill;
  } else {
    panel.FindChildTraverse("color_num").text = data.kill;
  }
  panel.FindChildTraverse("hero_img").heroname = data.hero;
  panel.FindChildTraverse("player_name").steamid = ClrbSteamIdOrEmpty(data.pid);
  panel.FindChildTraverse("level_label").text = data.level;
  panel.FindChildTraverse("hero_name").text = Local(data.hero);
  panel.FindChildTraverse("ji_text").text =
    data.kill + "/" + data.death + "/" + data.assit;
  panel
    .FindChildTraverse("zb_img")
    .SetImage("raw://resource/flash3/images/items/" + data.weapon + "_s.png");

  panel.FindChildTraverse("label_color").style.backgroundColor =
    colortab[data.team];
  panel
    .FindChildTraverse("color_img")
    .SetImage("raw://resource/flash3/images/team/b_" + data.team + ".png");

  panel.FindChildTraverse("jinbi_text").text = data.gold;
  panel.FindChildTraverse("shanghai_text").text = data.damage;
  panel.FindChildTraverse("csshanghai_text").text = data.tank;
  // 5v5 / 3x4 / 1v1 统一天梯分 point2
  if (modetype == 1 || modetype == 2 || modetype == 3) {
    panel.FindChildTraverse("tianti_text").text =
      data.point2 + "(" + data.point2_change + ")";
  }
  for (var i = 1; i <= 10; i++) {
    var pa = panel.FindChildTraverse("ability_" + i);
    if (!pa) {
      continue;
    }
    var skid = "skill_" + i;
    var sk = data.skill ? data.skill[skid] : null;
    var active = sk && sk.state !== 0 && sk.state !== false;
    if (active && sk.name) {
      if (i <= 4) {
        pa.FindChildTraverse("ability_img").SetImage(
          "raw://resource/flash3/images/skill/" + sk.name + ".png"
        );
      } else {
        pa.FindChildTraverse("ability_img").SetImage(
          "raw://resource/flash3/images/ability/" + sk.name + ".png"
        );
      }
    } else {
      pa.FindChildTraverse("ability_img").SetImage(
        "raw://resource/flash3/images/skill/skill_0.png"
      );
    }
  }

  // 本局称号
  var taglegth = Length(data.tag);
  var tagpanel = panel.FindChildTraverse("tag_box");
  tagpanel.RemoveAndDeleteChildren();
  for (var k = 1; k <= taglegth; k++) {
    var tagimage = NewPanel(tagpanel, "tag_img_" + k, "Image");
    tagimage.SetHasClass("tag_img", true);
    if (data.tag["tag" + k] == 1) {
      tagimage.visible = true;
      tagimage.SetImage("raw://resource/flash3/images/tag/tag" + k + ".png");
    } else {
      tagimage.visible = false;
      tagimage.SetImage("");
    }
    ShowTagTips(tagimage, "tag" + k);
  }

  var myid = Game.GetLocalPlayerID();
  if (data.id == myid) {
    panel.SetHasClass("myself", true);
  } else {
    panel.SetHasClass("myself", false);
  }
}

function ShowTagTips(panel, tagname) {
  WhenOver(panel, function () {
    var pa = GetPanel("tag_hover");
    pa.style.opacity = "1";
    pa.style.marginLeft = "0px";
    pa.style.marginTop = "0px";
    var screenPos = GetScreenOffset(panel);
    var x = screenPos.x / pa.actualuiscale_x - 140;
    var y = screenPos.y / pa.actualuiscale_y + 25;
    pa.style.marginLeft = x + "px";
    pa.style.marginTop = y + "px";
    pa.style.preTransformScale2d = "1";
    pa.FindChildTraverse("tag_hover_img").SetImage(
      "raw://resource/flash3/images/tag/" + tagname + "_h.png"
    );
  });
  WhenOut(panel, function () {
    var pa = GetPanel("tag_hover");
    pa.style.opacity = "0";
    pa.style.preTransformScale2d = "0.1";
  });
}

// 仅关闭结算面板，不断开游戏
function DismissOverSettlementWindow() {
  resetOverSubmitFooter();
  var r = GetRoot();
  if (!r) {
    return;
  }
  r.style.opacity = 0;
  r.hittest = false;
}

// 结束游戏
function CloseOver() {
  Game.Disconnect();
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
  SubEvent("UI_OverData", GetData);
})();
