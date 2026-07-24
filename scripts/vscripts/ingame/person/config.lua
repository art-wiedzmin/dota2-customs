--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Person.Data = {}
Person.Template = {
    page = false,
    --天梯分（5v5)
    point = 0,
    --天梯分（1v1）
    point2 = 0,
    -- 登录后是否已成功同步服务端天梯分（未同步时结算不增减分）
    score_synced_5v5 = false,
    score_synced_1v1 = false,
    --历史最高分（5v5）
    high_point = 0,
    --历史最高分（1v1）
    high_point2 = 0,
    --总场次（5v5）
    total_game = 0,
    --总场次（1v1）
    total_game2 = 0,
    --胜利场数（只有5v5有）
    win_count = 0,
    --失败场数（只有5v5有）
    lose_count = 0,
    --胜率（只有5v5有）
    win_rate = 0,
    --吃鸡场数（只有1v1有）
    top_count = 0,
    --前三场数（只有1v1有）
    top3_count = 0,
    --逃跑率（通用）：tag7 次数 / (total_game + total_game2)，百分比
    run_rate = 0,
    --称号（通用）
    tags = {
        --tag1(mvp)
        tag1 = 0,
        --tag2(神)
        tag2 = 0,
        --tag3(暴)
        tag3 = 0,
        --tag4(硬)
        tag4 = 0,
        --tag5(杀)
        tag5 = 0,
        --tag6(僵)
        tag6 = 0,
        --tag7(逃)
        tag7 = 0,
        --tag8(伐木)
        tag8 = 0,
        --tag9(力)
        tag9 = 0,
        --tag10(敏)
        tag10 = 0,
        --tag11(智)
        tag11 = 0,
        --tag12(贪)
        tag12 = 0,
        --tag13(无双)
        tag13 = 0,
        --tag14(夯)
        tag14 = 0,
        --tag15(狂)
        tag15 = 0,
    },
    --人机模式最短用时
    bot_time = 99999,
    --- 今日已领完赛金豆次数（登录时由 user.daily_game_bonus_* 与本地日历对齐；未知为 -1）
    daily_game_bonus_today = -1,
    --- 逃跑惩罚剩余局数（user.tpcf；>0 时结算页提示且不可领完赛金豆）
    tpcf = 0,
}
