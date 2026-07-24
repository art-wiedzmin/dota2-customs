--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


InitPlayer.Public = {
    --加载游戏
    game_state = false,
    --加载玩家
    player_state = false,
    --加载英雄
    hero_state = false,
    --英雄位置
    hero_pos = { 1, 2, 1, 4, 5, 6, 7, 8, 9, 10 },
    --所有玩家表
    players = {},
}
InitPlayer.PlayerTemp = {
    --玩家位置
    index = -1,
    --玩家ID
    id = -1,
    --是否存在
    state = false,
    --是否在线
    online = false,
    --是否已选择英雄
    hero_state = false,
    --英雄是否已经生成
    hero_spawned = false,
    --英雄名称
    hero_name = "",
    --出生点
    init_pos = -1,
    --队伍
    team = -1,
    --玩家编号
    team_num = 0,
    --英雄索引
    hero_index = -1,
    -- 选人天赋 1–9（由 SelectHero.Data 同步）
    talent_index = 1,
    --展示名字
    name = "",
    --是否为伪玩家机器人
    bot = false,
    -- 选人后断线、走异步出真：延迟到重连再跑 HeroData:InitHero（npc_spawn 不调度 InitHero）
    clrb_defer_inithero_until_reconnect = false,
}
