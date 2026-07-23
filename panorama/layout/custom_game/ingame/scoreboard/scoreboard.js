// 与 Lua Stat:OpenPage 一致：短节流内反复打开只拉一次 init
var gClrbScoreboardInitLastGt = null;
var CLRB_SCOREBOARD_REFRESH_SEC = 0.35;

function ClrbScoreboardRankCap(mode) {
  if (mode === 2) {
    return 12;
  }
  if (mode === 1) {
    return 10;
  }
  return 10;
}

function ClrbScoreboardResolveMode(data) {
  if (data && data.change !== undefined && data.change !== null && data.change !== false) {
    return data.change;
  }
  if (change !== undefined && change !== null && change !== -1) {
    return change;
  }
  return -1;
}

function ClrbScoreboardIsActive(row) {
  return row && (row.state === 1 || row.state === true);
}

function ClrbScoreboardSetHeroImg(img, heroName) {
  if (!img) {
    return;
  }
  img.heroname = heroName || "";
  img.heroimagestyle = "landscape";
}

//初始化加载加载
function InitData() {
  var tp = "init";
  SendServer("Lua_Stat", { data: { tp } });
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  SendServer("Lua_Stat", { data: { tp } });
  var gt = Game.GetGameTime();
  if (
    gClrbScoreboardInitLastGt === null ||
    gt - gClrbScoreboardInitLastGt >= CLRB_SCOREBOARD_REFRESH_SEC
  ) {
    gClrbScoreboardInitLastGt = gt;
    InitData();
  }
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  SendServer("Lua_Stat", { data: { tp } });
}

// 记录当前模式1v1还是5v5
var change = -1;

/** 侧栏计分条「积分:」与 UI_TopStat 同步；由 Stat.GetPublicData 末尾调用，避免对 UI_TopStat 二次订阅 */
function ScoreboardRefreshTopStatKills(data) {
  if (!data) {
    return;
  }
  change = data.change;
  if (GetPanel("jifen_1")) {
    if (data.list && data.list.team_1) {
      GetPanel("jifen_1").text = "积分: " + data.list.team_1.kill;
    } else {
      GetPanel("jifen_1").text = "积分:";
    }
  }
  if (GetPanel("jifen_2")) {
    if (data.list && data.list.team_2) {
      GetPanel("jifen_2").text = "积分: " + data.list.team_2.kill;
    } else {
      GetPanel("jifen_2").text = "积分:";
    }
  }
}

//获取数据
function GetData(data) {
  if (!data) {
    return;
  }

  if (data.page == 1) {
    GetRoot().visible = true;
  } else {
    GetRoot().visible = false;
  }

  var mode = ClrbScoreboardResolveMode(data);
  if (mode === -1) {
    return;
  }
  change = mode;

  // 5v5
  if (mode == 0) {
    GetPanel("box_1").visible = false;
    GetPanel("box_2").visible = true;
    var panel_1 = GetPanel("list_box_1");
    panel_1.RemoveAndDeleteChildren();
    var panel_2 = GetPanel("list_box_2");
    panel_2.RemoveAndDeleteChildren();
    for (var i = 1; i <= 10; i++) {
      if (data.list["rank_" + i]) {
        if (ClrbScoreboardIsActive(data.list["rank_" + i])) {
          if (data.list["rank_" + i].team == 1) {
            var sonpanel = NewPanel(panel_1, "rank_" + i, "Panel");
            sonpanel.BLoadLayoutSnippet("rank_snippet");
            var playdata = data.list["rank_" + i];
            SetPlayer(sonpanel, playdata);
          } else if (data.list["rank_" + i].team == 2) {
            var sonpanel = NewPanel(panel_2, "rank_" + i, "Panel");
            sonpanel.BLoadLayoutSnippet("rank_snippet");
            var playdata = data.list["rank_" + i];
            SetPlayer(sonpanel, playdata);
          }
        }
      }
    }
  } else if (mode == 1) {
    GetPanel("box_1").visible = true;
    GetPanel("box_2").visible = false;
    var panel = GetPanel("list_box");
    panel.RemoveAndDeleteChildren();
    for (var ri = 1; ri <= ClrbScoreboardRankCap(mode); ri++) {
      var rank_key = "rank_" + ri;
      var rank_data = data.list[rank_key];
      if (ClrbScoreboardIsActive(rank_data)) {
        var sonpanel = NewPanel(panel, rank_key, "Panel");
        sonpanel.BLoadLayoutSnippet("rank_snippet");
        SetPlayer(sonpanel, rank_data);
      }
    }
  } else if (mode == 2) {
    GetPanel("box_1").visible = true;
    GetPanel("box_2").visible = false;
    var panel34 = GetPanel("list_box");
    panel34.RemoveAndDeleteChildren();
    for (var r3 = 1; r3 <= ClrbScoreboardRankCap(mode); r3++) {
      var rk3 = "rank_" + r3;
      var rd3 = data.list[rk3];
      if (ClrbScoreboardIsActive(rd3)) {
        var sp3 = NewPanel(panel34, rk3, "Panel");
        sp3.BLoadLayoutSnippet("rank_snippet");
        SetPlayer(sp3, rd3);
      }
    }
  } else {
    return;
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
function SetPlayer(panel, data) {
  if (!panel || !data) {
    return;
  }
  panel.FindChildTraverse("color_num").text = data.kill;
  ClrbScoreboardSetHeroImg(panel.FindChildTraverse("hero_img"), data.hero);
  panel.FindChildTraverse("player_name").steamid = ClrbSteamIdOrEmpty(data.pid);
  panel.FindChildTraverse("level_label").text = data.level;
  panel.FindChildTraverse("hero_name").text = Local(data.hero || "");
  panel.FindChildTraverse("ji_text").text = data.kill;
  panel.FindChildTraverse("shi_text").text = data.death;
  panel.FindChildTraverse("zhu_text").text = data.assit;
  panel
    .FindChildTraverse("zb_img")
    .SetImage("raw://resource/flash3/images/items/" + data.weapon + "_s.png");

  panel.FindChildTraverse("label_color").style.backgroundColor =
    colortab[data.team];
  panel
    .FindChildTraverse("color_img")
    .SetImage("raw://resource/flash3/images/team/b_" + data.team + ".png");

  //加载星星
  var starpanel = panel.FindChildTraverse("star_box");
  starpanel.RemoveAndDeleteChildren();
  for (var i = 1; i <= data.star + 3; i++) {
    var star = NewPanel(starpanel, "star_" + i, "Image");
    star.SetHasClass("star_img", true);
  }
  //高亮自身
  var myid = Game.GetLocalPlayerID();
  if (data.id == myid) {
    panel.SetHasClass("myself", true);
  } else {
    panel.SetHasClass("myself", false);
  }
  // print("当前排名第" + data.rank);

  //加载技能
  for (var i = 1; i <= 10; i++) {
    var ab_key = "ability_" + i;
    var pa = panel.FindChildTraverse(ab_key);
    if (!pa) {
      continue;
    }
    var skillkey = "skill_" + i;
    var skill_data = data.skill && data.skill[skillkey];

    if (skill_data && (skill_data.state == 1 || skill_data.state === true)) {
      // print(skill_data);
      if (i <= 4) {
        pa.FindChildTraverse("ability_img").SetImage(
          "raw://resource/flash3/images/skill/" +
            data.skill["skill_" + i].name +
            ".png"
        );
      } else {
        pa.FindChildTraverse("ability_img").SetImage(
          "raw://resource/flash3/images/ability/" +
            data.skill["skill_" + i].name +
            ".png"
        );
      }
    } else {
      pa.FindChildTraverse("ability_img").SetImage(
        "raw://resource/flash3/images/skill/skill_0.png"
      );
    }

    // if (data.skill["skill_" + i].state !== 0) {
    //   if (i <= 4) {
    //     pa.FindChildTraverse("ability_img").SetImage(
    //       "raw://resource/flash3/images/skill/" +
    //         data.skill["skill_" + i].name +
    //         ".png"
    //     );
    //   } else {
    //     pa.FindChildTraverse("ability_img").SetImage(
    //       "raw://resource/flash3/images/ability/" +
    //         data.skill["skill_" + i].name +
    //         ".png"
    //     );
    //   }
    // } else {
    //   pa.FindChildTraverse("ability_img").SetImage(
    //     "raw://resource/flash3/images/skill/skill_0.png"
    //   );
    // }
  }
}

function BindPauseHotkey(key) {
  const command = "CustomPause_" + key + "_" + Date.now();
  let isPaused = false;

  Game.CreateCustomKeyBind(key, "+" + command);

  Game.AddCommand(
    "+" + command,
    () => {
        GameEvents.SendCustomGameEventToServer("custom_unpause_request", {});
    },
    "",
    1 << 32
  );
  GameEvents.Subscribe("custom_pause_result", function (data) {
    if (!data.ok) {
      $.Msg(data.msg || "暂停失败");
      Game.EmitSound("General.Cancel");
    }
  });

}

(function () {
  BindPauseHotkey("F9");
})();


(function () {
  gClrbScoreboardInitLastGt = Game.GetGameTime();
  InitData();
  if (GameUI.CustomUIConfig) {
    var cfg = GameUI.CustomUIConfig();
    if (cfg) {
      cfg._clrb_ScoreboardRefreshTopStatKills = ScoreboardRefreshTopStatKills;
    }
  }
  SubEvent("UI_Stat", GetData);
})();
