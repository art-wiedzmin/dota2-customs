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
  // SendServer("Lua_Task", { data: { tp } });
  SendServer("Lua_Person", { data: { tp } });
}

//打开页面
function OpenPage() {
  var tp = "OpenPage";
  // SendServer("Lua_Task", { data: { tp } });
  SendServer("Lua_Person", { data: { tp } });
}

//关闭页面
function ClosePage() {
  var tp = "ClosePage";
  // SendServer("Lua_Task", { data: { tp } });
  SendServer("Lua_Rank", { data: { tp } });
}
var mode = 2; // 1:5v5 2:1v1 3:人机竞速（最短通关）；默认与 Rank.view_mode 1v1 一致
var page = 1; // 1天梯 2历史战绩
var rankPayload = null; // 最近一次 UI_Rank 完整数据，用于 5v5 / 1v1 / 人机竞速 列表切换
var personPayload = null; // 最近一次 UI_Person 战绩，排行榜到达后刷新铭牌名次
var rankSeasonView = "live"; // live | history
var rankHistorySeason = ""; // 如 S0
// 切换天梯/历史战绩
function checkPage(num) {
  if (page == num) {
    return;
  }
  if (BtnLimiter(GetPanel("center_tag_1"), 0.3)) {
    return;
  }
  if (BtnLimiter(GetPanel("center_tag_2"), 0.3)) {
    return;
  }
  if (num === 2 && mode === 3) {
    mode = 2;
  }
  page = num;
  UpPageActive(num);
  UpModeActive(mode);
}
/** 历史战绩仅单人；人机竞速仅天梯排名；组队模式已隐藏 */
function HideTeamModeTabs() {
  var m1 = GetPanel("mode_1");
  var sep1 = GetPanel("mode_sep_1");
  if (m1) {
    m1.visible = false;
  }
  if (sep1) {
    sep1.visible = false;
  }
}
function UpdateModeTabsForPage(currentPage) {
  HideTeamModeTabs();
  var isLadder = currentPage === 1;
  var mode3 = GetPanel("mode_3");
  var sep3 = GetPanel("mode_sep_3");
  if (mode3) {
    mode3.visible = isLadder;
  }
  if (sep3) {
    sep3.visible = isLadder;
  }
}
// 更新天梯/战绩
function UpPageActive(num) {
  pa = GetPanel("center_tag_" + num);
  pa.AddClass("active");
  if (num == 1) {
    GetPanel("center_tag_2").RemoveClass("active");
    // 显示天梯内容块还是战绩内容块
    GetPanel("content_box_tianti").visible = true;
    GetPanel("content_box_zhanji").visible = false;
    var tp = "init";
    // SendServer("Lua_Task", { data: { tp } });
    SendServer("Lua_Rank", { data: { tp } });
    SendServer("Lua_Person", { data: { tp } });
    SendServer("Lua_Rank", { data: { tp: "RefreshSeasonList" } });
  } else {
    var tp = "init";
    // SendServer("Lua_Task", { data: { tp } });
    SendServer("Lua_Person", { data: { tp } });
    SendServer("Lua_Rank", { data: { tp } });
    GetPanel("center_tag_1").RemoveClass("active");
    // 显示天梯内容块还是战绩内容块
    GetPanel("content_box_tianti").visible = false;
    GetPanel("content_box_zhanji").visible = true;
  }
  UpdateModeTabsForPage(num);
}

// 切换单/多人模式

function checkFun(num) {
  if (num === 1) {
    return;
  }
  if (page === 2 && num === 3) {
    return;
  }
  if (BtnLimiter(GetPanel("mode_1"), 0.3)) {
    return;
  }
  if (BtnLimiter(GetPanel("mode_2"), 0.3)) {
    return;
  }
  if (BtnLimiter(GetPanel("mode_3"), 0.3)) {
    return;
  }
  UpModeActive(num);
  mode = num;
  InitData();
  // 若当前在天梯页，用缓存的排行榜数据按新 mode 重绘列表
  if (page === 1 && rankPayload) {
    UpdateData(rankPayload);
  }
  var awardTipPanel = GetPanel("award_tip");
  if (awardTipPanel && awardTipPanel.visible) {
    SetAwardTipTextForCurrentMode();
  }
}

// 更新单/多人模式点亮
function UpModeActive(num) {
  for (var m = 1; m <= 3; m++) {
    var p = GetPanel("mode_" + m);
    if (!p) {
      continue;
    }
    if (m === num) {
      p.AddClass("active");
    } else {
      p.RemoveClass("active");
    }
  }
}

// var myid=0;
// 战绩
function GetData(data) {
  if (!data) {
    return;
  }
  personPayload = data;
  UpdateZhanJi(data);
  if (page === 1 && rankPayload) {
    UpdateData(rankPayload);
  }
}

function ApplyRankViewMode(data) {
  if (!data || !data.view_mode) {
    return;
  }
  var m = 2;
  if (data.view_mode === "1v1") {
    m = 2;
  } else if (data.view_mode === "bot_1v1") {
    m = page === 2 ? 2 : 3;
  } else if (data.view_mode === "5v5") {
    m = 2;
  }
  if (mode !== m) {
    mode = m;
    UpModeActive(mode);
  }
  var awardTipPv = GetPanel("award_tip");
  if (awardTipPv && awardTipPv.visible) {
    SetAwardTipTextForCurrentMode();
  }
}

// 排行榜
function GetRankData(data) {
  if (!data) {
    return;
  }
  rankPayload = data;
  GetRoot().style.opacity = data.page;
  if (data.task_page === 2) {
    if (page !== 2) {
      page = 2;
      UpPageActive(2);
    }
  } else if (data.task_page === 1) {
    if (page !== 1) {
      page = 1;
      UpPageActive(1);
    }
  }
  ApplyRankViewMode(data);
  UpdateSeasonTabs(data);
  UpdateData(data);
  if (page === 2 && personPayload) {
    UpdateZhanJi(personPayload);
  }
}

/** 人机榜：秒数格式化为 m:ss */
function FormatBotTimeSec(sec) {
  var n = Number(sec);
  if (typeof n !== "number" || isNaN(n) || !isFinite(n) || n < 0) {
    return "--";
  }
  var s = Math.floor(n);
  var m = Math.floor(s / 60);
  var r = s % 60;
  return m + ":" + (r < 10 ? "0" : "") + r;
}

/** 排行榜名次：服务端未上榜时 Lua 为 -1 → 文案「未上榜」 */
function FormatRankLabelForLeaderboard(myrank, mode) {
  if (mode === 3) {
    return myrank >= 1 && myrank <= 100 ? String(myrank) : "未上榜";
  }
  var r = Number(myrank);
  if (
    myrank === undefined ||
    myrank === null ||
    myrank === "" ||
    !Number.isFinite(r) ||
    r < 1
  ) {
    return "未上榜";
  }
  return String(myrank);
}

/** 排行榜底栏：榜内未匹配到本人时用 Person 单人/组队天梯分兜底 */
function ResolveMyLadderScoreRaw(mypointRaw, currentMode) {
  if (currentMode === 3) {
    return mypointRaw;
  }
  var n = Number(mypointRaw);
  if (
    mypointRaw !== undefined &&
    mypointRaw !== null &&
    mypointRaw !== "" &&
    Number.isFinite(n) &&
    n >= 0 &&
    n !== -1
  ) {
    return mypointRaw;
  }
  if (personPayload) {
    if (currentMode === 2 && personPayload.point2 !== undefined) {
      return personPayload.point2;
    }
    if (currentMode === 1 && personPayload.point !== undefined) {
      return personPayload.point;
    }
  }
  return mypointRaw;
}

/** 排行榜天梯分：未拉取到时（=-1）显示 1000；人机榜仍用耗时 */
function FormatLadderScoreText(raw, mode) {
  if (mode === 3) {
    return FormatBotTimeSec(raw);
  }
  var n = Number(raw);
  if (
    raw === undefined ||
    raw === null ||
    raw === "" ||
    !Number.isFinite(n) ||
    n < 0 ||
    n === -1
  ) {
    return "1000";
  }
  return String(n);
}

/** 战绩区星级运算用：无效或 -1 当 1000（与段位表一致起点） */
function ClampLadderScoreNumber(v) {
  var n = Number(v);
  if (
    v === undefined ||
    v === null ||
    v === "" ||
    !Number.isFinite(n) ||
    n < 0 ||
    n === -1
  ) {
    return 1000;
  }
  return n;
}

function checkSeasonView(view, seasonLabel) {
  if (view === "history" && !seasonLabel) {
    return;
  }
  if (view === "live" && rankSeasonView === "live") {
    return;
  }
  if (view === "history" && rankSeasonView === "history" && rankHistorySeason === seasonLabel) {
    return;
  }
  rankSeasonView = view === "history" ? "history" : "live";
  rankHistorySeason = view === "history" ? seasonLabel : "";
  SendServer("Lua_Rank", {
    data: {
      tp: "SwitchSeason",
      view: rankSeasonView,
      season: rankHistorySeason,
    },
  });
}

function UpdateSeasonTabs(data) {
  if (!data) {
    return;
  }
  if (data.rank_view) {
    rankSeasonView = data.rank_view;
  }
  if (data.history_season !== undefined) {
    rankHistorySeason = data.history_season || "";
  }

  var liveBtn = GetPanel("season_live_btn");
  if (liveBtn) {
    liveBtn.SetHasClass("active", rankSeasonView === "live");
  }

  var currentLabel = data.current_season_label || "S0";
  var timeLabel = GetPanel("time_s");
  if (timeLabel) {
    if (rankSeasonView === "history" && rankHistorySeason) {
      timeLabel.text = "历史赛季：" + rankHistorySeason + "（已结束）";
    } else {
      timeLabel.text = "当前赛季：" + currentLabel;
    }
  }

  var host = GetPanel("season_history_tabs");
  if (!host) {
    return;
  }
  host.RemoveAndDeleteChildren();

  var seasons = data.seasons || [];
  if (!seasons.length) {
    return;
  }

  seasons.forEach(function (s) {
    var label = s.season_label || "S" + s.season_index;
    var tab = $.CreatePanel("Label", host, "season_hist_" + label);
    tab.AddClass("season_tab");
    if (rankSeasonView === "history" && rankHistorySeason === label) {
      tab.AddClass("active");
    }
    tab.text = label;
    tab.SetPanelEvent("onactivate", function () {
      checkSeasonView("history", label);
    });
  });
}

// 更新数据排名  5v5 / 1v1 / 人机竞速
function UpdateData(data) {
  if (!data || !data.data) {
    return;
  }
  var list =
    mode === 1
      ? data.list_5v5
      : mode === 2
        ? data.list_1v1
        : data.list_bot_1v1;
  if (!list) {
    list = data.list || {};
  }
  var mydata = data.data;
  var myid = mydata.sid;
  var myrank;
  var mypointRaw;
  if (mode === 1) {
    myrank = mydata.rank !== undefined ? mydata.rank : mydata.rank2;
    mypointRaw = mydata.point !== undefined ? mydata.point : mydata.point2;
  } else if (mode === 2) {
    myrank = mydata.rank2 !== undefined ? mydata.rank2 : mydata.rank;
    mypointRaw = mydata.point2 !== undefined ? mydata.point2 : mydata.point;
  } else {
    myrank = mydata.rank_bot;
    mypointRaw = mydata.point_bot;
  }
  mypointRaw = ResolveMyLadderScoreRaw(mypointRaw, mode);
  var scoreTitle = GetPanel("tianti_score_title");
  if (scoreTitle) {
    scoreTitle.text = mode === 3 ? "通关用时" : "天梯积分";
  }
  GetPanel("player_my_img").steamid = ClrbSteamIdOrEmpty(myid);
  GetPanel("player_my_name").steamid = ClrbSteamIdOrEmpty(myid);
  GetPanel("p_jifen").text = FormatLadderScoreText(mypointRaw, mode);
  GetPanel("p_num").text = FormatRankLabelForLeaderboard(myrank, mode);
  var playerList = Length(list);
  var listpanel = GetPanel("list_box_container");
  listpanel.RemoveAndDeleteChildren();
  if (playerList <= 0) {
    return;
  }
  for (var i = 1; i <= playerList; i++) {
    var panel = NewPanel(listpanel, "player_li_" + i, "Panel");
    panel.BLoadLayoutSnippet("list_snippet");
    if (i <= 3) {
      panel.AddClass("yellow_text");
    } else {
      panel.RemoveClass("yellow_text");
    }
    if (i % 2 == 1) {
      panel.AddClass("black_bg");
    } else {
      panel.RemoveClass("black_bg");
    }
    var playdata = list["rank" + i];
    var sid = playdata.sid;
    var rank = playdata.rank;
    var point = mode === 3 ? FormatBotTimeSec(playdata.point) : playdata.point;
    panel.FindChildTraverse("p_num_p").text = rank;
    panel.FindChildTraverse("player_name_p").steamid = ClrbSteamIdOrEmpty(sid);
    panel.FindChildTraverse("player_img_p").steamid = ClrbSteamIdOrEmpty(sid);
    panel.FindChildTraverse("p_jifen_p").text = point;
  }
}
function isIntegerString(str) {
    if (typeof str === 'number') {
        // 如果是 NaN 或 Infinity，直接返回 false
        if (!Number.isFinite(str)) return false;
        str = str.toString();
    }
    
    if (typeof str !== 'string') return false;
    return /^[+-]?\d+$/.test(str);
}

/** 胜率旁逃逸率等同源百分比尾：Lua/JSON NaN/null 显示为 0% */
function SafePercentTail(rateRaw) {
  var n = Number(rateRaw);
  if (!Number.isFinite(n)) {
    return "0%";
  }
  return n + "%";
}

/** 逃跑率：取整后显示，如 12% */
function SafeEscapeRatePercent(rateRaw) {
  var n = Number(rateRaw);
  if (!Number.isFinite(n)) {
    return "0%";
  }
  return Math.round(n) + "%";
}
// 战绩
function UpdateZhanJi(data) {
  if (!data) {
    return;
  }

  // 5v5
  if (mode == 1) {
    GetPanel("sl_text_1").text = "胜率";
    GetPanel("sl_cs_text_1").text = "胜利场数";
    GetPanel("sb_cs_text_1").text = "失利场数";
    GetPanel("sl_text_2").text = "胜率";
    GetPanel("sl_cs_text_2").text = "胜利场数";
    GetPanel("sb_cs_text_2").text = "失利场数";
    // 赛季（场数为 0 时服务端曾可能产生 NaN，此处兜底为 0%）
    var win_pec;
    var winRateNum = Number(data.win_rate);
    if (!Number.isFinite(winRateNum)) {
      win_pec = "0";
    } else if (isIntegerString(data.win_rate)) {
      win_pec = data.win_rate;
    } else {
      win_pec = winRateNum.toFixed(1);
    }
    // print(data.win_rate)
    // 天梯分
    var pt5 = ClampLadderScoreNumber(data.point);
    GetPanel("sj_num").text = pt5;
    SetRankImg(pt5, "sj_img_star", "sj_img", "sj_rank_plate", "sj_badge_box");
    
    // 胜率
    GetPanel("right_li_sl").text = win_pec + "%";
    // 逃跑率
    GetPanel("right_li_tpl").text = SafeEscapeRatePercent(data.run_rate);
    // 胜利场数
    GetPanel("right_li_slcs").text = data.win_count;
    // 失利场数
    GetPanel("right_li_sbcs").text = data.lose_count;
    // 总场数
    GetPanel("right_li_zcs").text = data.total_game;
    // 总战绩
    // 历史最高分
    var hp5 = ClampLadderScoreNumber(data.high_point);
    GetPanel("zj_num").text = hp5;
    SetRankImg(hp5, "zj_img_star", "zj_img", "zj_rank_plate", "zj_badge_box");
    // 胜率
    GetPanel("right_li_sl_zj").text = win_pec + "%";
    // 逃跑率
    GetPanel("right_li_tpl_zj").text = SafeEscapeRatePercent(data.run_rate);
    // 胜利场数
    GetPanel("right_li_slcs_zj").text = data.win_count;
    // 失利场数
    GetPanel("right_li_sbcs_zj").text = data.lose_count;
    // 总场数
    GetPanel("right_li_zcs_zj").text = data.total_game;

  } else if (mode == 2) {
    // 1v1 单人模式
    GetPanel("sl_text_1").text = "前三率";
    GetPanel("sl_cs_text_1").text = "吃鸡场数";
    GetPanel("sb_cs_text_1").text = "前三场数";
    GetPanel("sl_text_2").text = "前三率";
    GetPanel("sl_cs_text_2").text = "吃鸡场数";
    GetPanel("sb_cs_text_2").text = "前三场数";
    // 赛季
    // 天梯分
    var pt1 = ClampLadderScoreNumber(data.point2);
    GetPanel("sj_num").text = pt1;
    SetRankImg(pt1, "sj_img_star", "sj_img", "sj_rank_plate", "sj_badge_box");
    // 前三率（无场数时对分母为 0 兜底 0%，避免 NaN）
    var tg2 = Number(data.total_game2);
    var t3c = Number(data.top3_count);
    var top3 =
      Number.isFinite(tg2) && tg2 > 0 && Number.isFinite(t3c)
        ? Math.round((t3c / tg2) * 100)
        : 0;
    // print(data)
    GetPanel("right_li_sl").text = top3 + "%";
    // 逃跑率
    GetPanel("right_li_tpl").text = SafeEscapeRatePercent(data.run_rate);
    // 吃鸡场数
    GetPanel("right_li_slcs").text = data.top_count;
    // 前三场数
    GetPanel("right_li_sbcs").text = data.top3_count;
    // 总场数
    GetPanel("right_li_zcs").text = data.total_game2;
    // 总战绩
    // 历史最高分
    var hp1 = ClampLadderScoreNumber(data.highest_point2);
    GetPanel("zj_num").text = hp1;
    SetRankImg(hp1, "zj_img_star", "zj_img", "zj_rank_plate", "zj_badge_box");
    // 前三率
    GetPanel("right_li_sl_zj").text = top3 + "%";
    // 逃跑率
    GetPanel("right_li_tpl_zj").text = SafeEscapeRatePercent(data.run_rate);
    // 吃鸡场数
    GetPanel("right_li_slcs_zj").text = data.top_count;
    // 前三场数
    GetPanel("right_li_sbcs_zj").text = data.top3_count;
    // 总场数
    GetPanel("right_li_zcs_zj").text = data.total_game2;
  }

  // 称号
  var ch_list = 15;
  var chdata = data.tags;
  var panel = GetPanel("ch_list");
  panel.RemoveAndDeleteChildren();
  for (var i = 1; i <= ch_list; i++) {
    var sonpanel = NewPanel(panel, "ch_li_" + i, "Panel");
    sonpanel.BLoadLayoutSnippet("ch_snippet");
    sonpanel
      .FindChildTraverse("ch_img")
      .SetImage("raw://resource/flash3/images/tag/tag" + i + ".png");
    sonpanel.FindChildTraverse("ch_num").text = chdata["tag" + i];
  }
}

// 左上角玩家信息
function elseFun() {
  // 获取玩家id
  var playerid = Game.GetLocalPlayerID();
  var info = Game.GetPlayerInfo(playerid);
  myid = playerid;
  var sid = ClrbSteamIdOrEmpty(info.player_steamid);
  GetPanel("player_img").steamid = sid;
  GetPanel("player_name").steamid = sid;
}

/** 排行榜结算奖励规则（悬停「奖励规则」区域显示） */
var CLRB_RANK_AWARD_RULE_TEXT = [
  "排名1结算奖励：50000金豆",
  "排名2结算奖励：30000金豆",
  "排名3结算奖励：20000金豆",
  "排名4-5结算奖励：18000金豆",
  "排名6-10结算奖励：15000金豆",
  "排名11-20结算奖励：10000金豆",
  "排名21-50结算奖励：5000金豆",
  "排名51-100结算奖励：3000金豆",
  "冠绝段位结算时奖励：2000金豆",
  "超凡段位结算时奖励：1800金豆",
  "万古段位结算时奖励：1600金豆",
  "传奇段位结算时奖励：1400金豆",
  "统帅段位结算时奖励：1200金豆",
  "中军段位结算时奖励：1000金豆",
].join("\n");

/** 人机竞速排行榜：仅名次段奖励（与 mode===3 对齐） */
var CLRB_BOT_SPEED_AWARD_RULE_TEXT = [
  "排名1结算奖励：30000金豆",
  "排名2结算奖励：20000金豆",
  "排名3结算奖励：10000金豆",
  "排名4-5结算奖励：9000金豆",
  "排名6-10结算奖励：8000金豆",
  "排名11-20结算奖励：7000金豆",
  "排名21-50结算奖励：5000金豆",
  "排名51-100结算奖励：3000金豆",
].join("\n");

function SetAwardTipTextForCurrentMode() {
  var lab = GetPanel("award_tip_text");
  if (!lab) {
    return;
  }
  lab.text =
    typeof mode !== "undefined" && mode === 3
      ? CLRB_BOT_SPEED_AWARD_RULE_TEXT
      : CLRB_RANK_AWARD_RULE_TEXT;
}

function InitAwardTipText()
{
  SetAwardTipTextForCurrentMode();
}

// 悬浮显示规则（整行文案 + 图标）；延迟关闭 + 气泡可接住鼠标，避免子元素间划过/起泡瞬间触发 out 导致闪烁
var clrbAwardTipHideSchedule = null;
function clearClrbAwardTipHideSchedule() {
  if (clrbAwardTipHideSchedule !== null) {
    $.CancelScheduled(clrbAwardTipHideSchedule);
    clrbAwardTipHideSchedule = null;
  }
}
function showClrbAwardTipNow() {
  SetAwardTipTextForCurrentMode();
  clearClrbAwardTipHideSchedule();
  var tip = GetPanel("award_tip");
  if (tip) {
    tip.visible = true;
  }
}
function scheduleHideClrbAwardTip() {
  clearClrbAwardTipHideSchedule();
  clrbAwardTipHideSchedule = $.Schedule(0.14, function () {
    clrbAwardTipHideSchedule = null;
    var tip = GetPanel("award_tip");
    if (tip) {
      tip.visible = false;
    }
  });
}
function showawardtip() {
  var trig = GetPanel("award_rule_hover") || GetPanel("guizhe_icon");
  var tip = GetPanel("award_tip");
  if (!trig || !tip) {
    return;
  }
  WhenOver(trig, showClrbAwardTipNow);
  WhenOut(trig, scheduleHideClrbAwardTip);
  WhenOver(tip, showClrbAwardTipNow);
  WhenOut(tip, scheduleHideClrbAwardTip);
}

// SendServer("Lua_Person", { data: { tp } })

// 段位区间范围（本地 png 文件名，或 s2r 官服资源路径）
var ranklist={
  "xf": "0_499",
  "ws": "500_999",
  "zj": "1000_1499",
  "ts": "1500_2249",
  "cq": "2250_2999",
  "wg": "3000_3749",
  "cf": "3750_4499",
  "gj": "s2r://panorama/images/rank_tier_icons/rank8_psd.vtex",
}

function GetRankBadgeImagePath(rankName) {
  var entry = ranklist[rankName];
  if (!entry) {
    return "";
  }
  if (entry.indexOf("://") !== -1) {
    return entry;
  }
  return "raw://resource/flash3/images/rank/" + entry + ".png";
}

// 段位
function getRankInfo(score) {
    // step: 升1星所需的分数
    var rankConfig = [
        { name: "xf", min: 0,    step: 100 },
        { name: "ws", min: 500,  step: 100 },
        { name: "zj", min: 1000, step: 100 },
        // 统帅开始，step 变为 150
        { name: "ts", min: 1500, step: 150 }, 
        { name: "cq", min: 2250, step: 150 },
        { name: "wg", min: 3000, step: 150 },
        { name: "cf", min: 3750, step: 150 },
        { name: "gj", min: 4500, step: 150 },
    ];

    // 2. 找到当前分数对应的段位配置
    var currentRank = null;
    
    for (var i = 0; i < rankConfig.length; i++) {
        if (score >= rankConfig[i].min) {
            currentRank = rankConfig[i];
        }
    }

    // 3. 如果没有找到匹配的段位（例如分数小于0），返回最低等级
    if (!currentRank) {
        return { rankName: "xf", stars: 1 };
    }

    // 4. 计算星级 (从1开始)
    // 公式：(当前分数 - 当前段位起始分数) / 该段位的步长，向下取整，然后 +1
    var stars = Math.floor((score - currentRank.min) / currentRank.step) + 1;
    if (currentRank.name !== "gj") {
        stars = Math.min(Math.max(stars, 1), 5);
    }

    return {
        rankName: currentRank.name,
        stars: stars
    };
}
function IsValidLeaderboardRank(myrank) {
  var r = Number(myrank);
  return Number.isFinite(r) && r >= 1 && r <= 100;
}

function GetLeaderboardRankForCurrentMode() {
  if (!rankPayload || !rankPayload.data) {
    return -1;
  }
  var d = rankPayload.data;
  if (mode === 1) {
    return d.rank !== undefined ? d.rank : -1;
  }
  if (mode === 2) {
    return d.rank2 !== undefined ? d.rank2 : -1;
  }
  return -1;
}

function UpdateRankPlateLabel(plateLabel, rankinfo, leaderboardRank) {
  if (!plateLabel) {
    return;
  }
  var showPlate =
    rankinfo.rankName === "gj" && IsValidLeaderboardRank(leaderboardRank);
  if (!showPlate) {
    plateLabel.text = "";
    plateLabel.style.visibility = "collapse";
    plateLabel.SetHasClass("rank_plate_num_wide", false);
    return;
  }
  var rankNum = Number(leaderboardRank);
  plateLabel.text = String(rankNum);
  plateLabel.style.visibility = "visible";
  plateLabel.SetHasClass("rank_plate_num_wide", rankNum >= 100);
}

function SetRankImg(data, starId, badgeId, plateLabelId, badgeBoxId) {
  if (!data) {
    return;
  }
  var rankinfo = getRankInfo(data);
  var starPanel = GetPanel(starId);
  var badgePanel = GetPanel(badgeId);
  var plateLabel = plateLabelId ? GetPanel(plateLabelId) : null;
  var badgeBox = badgeBoxId ? GetPanel(badgeBoxId) : null;
  if (!starPanel || !badgePanel) {
    return;
  }
  var star = rankinfo.stars;
  var isGj = rankinfo.rankName === "gj";
  if (badgeBox) {
    badgeBox.SetHasClass("rank_badge_box_gj", isGj);
  }
  if (isGj) {
    starPanel.visible = false;
    badgePanel.AddClass("rank_badge_gj");
  } else {
    starPanel.visible = true;
    badgePanel.RemoveClass("rank_badge_gj");
    starPanel.SetImage("raw://resource/flash3/images/rank/" + star + ".png");
  }
  badgePanel.SetImage(GetRankBadgeImagePath(rankinfo.rankName));
  UpdateRankPlateLabel(
    plateLabel,
    rankinfo,
    GetLeaderboardRankForCurrentMode()
  );
}



(function () {
  InitAwardTipText();
  HideTeamModeTabs();
  InitData();
  elseFun();
  UpModeActive(mode);
  UpdateModeTabsForPage(page);
  showawardtip();
  SubEvent("UI_Person", GetData);
  SubEvent("UI_Rank", GetRankData);
})();