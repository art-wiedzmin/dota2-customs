--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Stat.Data = {}
--左侧计分板
Stat.Template = {
    --计分板页面开关
    page = false,
    --计分板列表
    list = {}
}
--顶部公共列表
Stat.Public = {
    --是否动态变化排名
    change = false,
    --整体页面显示
    page = false,
    --目标人头数
    kill_target = 140,
    --队伍列表
    list = {}
}
Stat.SlotTemplate = {
    --槽位索引(相当于也是排名位置)
    slot = -1,
    --队伍索引
    team = -1,
    --是否显示队伍
    state = false,
    --排名（只有1v1才需要这个）
    rank = 0,
    --队伍击杀数量
    kill = 0,
    --队伍玩家列表
    list = {}
}
--顶部计分板玩家数据
Stat.PlayerTemplate = {
    --是否有效
    state = false,
    --玩家ID
    id = -1,
    --玩家队伍
    team = -1,
    --玩家游戏内位置
    gid = -1,
    --玩家英雄
    hero = "",
    --英雄是否存货
    alive = true,
    --复活时间
    time = -1,
    --是否在线
    online = true,
}
Stat.RankList = {
    --是否能更新
    updata = true,
    list = {}
}
--玩家计分板详细数据
Stat.PlayerDetail = {
    --是否为空
    state = false,
    --排名
    rank = -1,
    --游戏内ID
    id = -1,
    --玩家steamid(获取头像)
    pid = -1,

    --队伍
    team = -1,
    --英雄
    hero = "",
    --专属武器
    weapon = "",
    --等级
    level = 1,
    --金币
    gold = 500,
    --星星数量
    star = 3,
    --击杀
    kill = 0,
    --死亡
    death = 0,
    --助攻
    assit = 0,
    --技能
    skill = {},
}
--技能槽模板
Stat.SkillTemplate = {
    --槽索引
    slot = -1,
    --是否为空
    state = false,
    --技能名字
    name = ""
}
Stat.Static = {
    -- 顶栏 UI_TopStat：10 分钟前降频/缩包（减轻专用服序列化压力）
    top_stat_early_cutoff_sec = 600,
    top_stat_early_interval = 1,
    top_stat_pre_ring_interval = 0.6,
    -- 1v1 / beidong：击杀更密，顶栏可略放宽（仅 game_type==2 生效）
    top_stat_1v1_early_interval = 1.5,
    top_stat_1v1_pre_ring_interval = 0.8,
    --队伍数量
    team_num = {
        rank_5v5 = 2,
        rank_3x4 = 4,
        rank_1v1 = 10,
        beidong = 10,
    },
    --队伍索引
    team_index = {
        team_2 = 1,
        team_3 = 2,
        team_6 = 3,
        team_7 = 4,
        team_8 = 5,
        team_9 = 6,
        team_10 = 7,
        team_11 = 8,
        team_12 = 9,
        team_13 = 10,
    }
}
