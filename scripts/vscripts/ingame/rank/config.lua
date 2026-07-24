--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Rank.Data = {}
--排行榜（5v5 = data1，1v1 = data2）
--list_5v5 / list_1v1: 各模式排行榜列表 rank1..rank100
--data.rank / data.point: 5v5 排名与分数；data.rank2 / data.point2: 1v1 排名与分数
Rank.Template = {
    page = false,
    list = {},
    list_5v5 = {},
    list_1v1 = {},
    list_bot_1v1 = {},
    -- 当前前端视图模式："5v5" / "1v1" / "bot_1v1"
    view_mode = "1v1",
    -- live=当前赛季 history=历史赛季
    rank_view = "live",
    history_season = "",
    seasons = {},
    current_season_label = "S0",
    data = {
        pid = -1,
        sid = -1,
        rank = -1,
        point = -1,
        rank2 = -1,
        point2 = -1,
        --- 人机 1v1 竞速榜（data3）：上榜时名次与榜上的用时（秒）
        rank_bot = -1,
        point_bot = -1,
    }
}
Rank.Public = {
    server = false,
    seasons_loaded = false,
    live_data1 = nil,
    live_data2 = nil,
    live_data3 = nil,
    data = {}
}
