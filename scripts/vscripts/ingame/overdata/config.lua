--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


OverData.Data = {}
--玩家数据
OverData.Public = {}
OverData.Template = {
    --游戏模式（1，5v5,2.1v1）
    tp = 1,
    --页面显示（与 panorama OverData.js 一致：须为 1/0，勿用 boolean，否则 opacity 判断失败）
    page = 0,
    --- 今日完赛金豆次数（由 Person 同步；Panorama 上限写死 5）
    daily_game_bonus_today = -1,
    --- 逃跑惩罚剩余局数（user.tpcf）
    tpcf = 0,
    --- 本局预言第一名奖励金豆（/game/submit 后刷新）
    prophecy_bonus_gold = 0,
    --- 结算上报 UI：loading / ok / fail（Panorama 底部按钮区）
    submit_status = "",
    --游戏时间（分钟）
    time = 0,
    --队伍数据
    data = {

    },
}
OverData.TeamTemplate = {
    --队伍排名(从1-10)
    slot = -1,
    --是否显示队伍
    state = false,
    --胜利队伍
    win_team = -1,
    --队伍击杀数量
    kill = 0,
    --队伍玩家列表
    list = {}
}
--玩家数据
OverData.PlayerTemplate = {
    --是否为空
    state = false,
    --游戏内ID
    id = -1,
    --玩家steamid
    pid = -1,
    --队伍
    team = -1,
    --英雄
    hero = "",
    --排名
    rank = -1,
    --等级
    level = 1,
    --专属武器
    weapon = "",
    --金币
    gold = 0,
    --击杀
    kill = 0,
    -- rank_3x4：队伍总击杀（与 5v5 结算表头「积分」同为阵营人头合计，目标见 MainGame.Static.team_kill_3x4）
    team_kill = 0,
    --死亡
    death = 0,
    --助攻
    assit = 0,
    --kda
    kda = 0,
    --技能
    skill = {},
    --分数
    point = 1000,
    --分数增减
    point_change = 0,
    --个人分数
    point2 = 1000,
    --1v1分数增减
    point2_change = 0,
    --吃鸡
    top = false,
    --前三
    top3 = false,
    --称号
    tag = {}
}
--技能槽模板
OverData.SkillTemplate = {
    --槽索引
    slot = -1,
    --是否为空
    state = false,
    --技能名字
    name = ""
}
OverData.Point = {
    tp_1 = {
        win = 15,
        fail = -10
    },
    tp_3 = {
        team_1 = 15,
        team_2 = 10,
        team_3 = -5,
        team_4 = -10,
    },
    tp_2 = {
        team_1 = 40,
        team_2 = 24,
        team_3 = 18,
        team_4 = 12,
        team_5 = 8,
        team_6 = 0,
        team_7 = -3,
        team_8 = -5,
        team_9 = -8,
        team_10 = -12,
    }
}
