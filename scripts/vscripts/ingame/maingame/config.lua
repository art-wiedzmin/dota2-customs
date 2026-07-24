--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


MainGame.Data = {
    --当前游戏进程(1,初始，2第一次缩圈，3，第二次缩圈)
    state = 1,
    over = false,
    win_team = 0,
    --天气编号
    weather = -1,
    weather_time = -1,
    -- 上一轮已结束的天气 id（轮换时不可连续重复）
    weather_last_id = nil,
    --毒圈特效
    tx = -1,
    -- 天气配套环境粒子（烛火/路灯/蛾/蝶），轮换天气时重建；对局结束清理
    world_ambient_fx = {},
    --累计杀敌数
    kill = {
        --天辉
        Team2 = 0,
        --夜宴
        Team3 = 0,
        -- rank_3x4：CUSTOM_1 / CUSTOM_2
        Team6 = 0,
        Team7 = 0,
    },
    star_max_state = false,
    wy_state = false,
    door = {
        doors1 = {
            door1 = {
                name = "door1",
                pos = Vector(-7578.689941, 7358.165527, 256.000000),
                tx = -1,
                state = false
            },
            door2 = {
                name = "door2",
                pos = Vector(7654.781250, -7781.971680, 256.000000),
                tx = -1,
                state = false
            },
        },
        doors2 = {
            door3 = {
                name = "door3",
                pos = Vector(-7767.351074, -7692.657227, 128.000000),
                tx = -1,
                state = false
            },
            door4 = {
                name = "door4",
                pos = Vector(7879.106934, 7508.555664, 128.000000),
                tx = -1,
                state = false
            },
        }
    },
    dummy = -1,
    hero_reborn_index = 1,
    session_load_gate_started = false,
    session_load_gate_finished = false,
    -- passive_mode：已移除「被动模式」玩法，固定为 false（兼容旧引用）
    passive_mode = false,
    --禁止刷怪
    jzsg = false,
    --- 决战时刻 20000 全局金币只发一次（避免 EventTrigger 失败后重试重复加钱）
    lastfight_gold_done = false,
    -- 自定义昼夜：true=白天，false=黑夜
    daynight_is_day = true,
    daynight_elapsed = 0,
}
MainGame.Static = {
    doors_cd = 6,
    --- 传送门落地后短暂无敌（秒）
    door_teleport_invuln = 0.1,
    doors_tx = "particles/econ/items/underlord/underlord_2021_immortal/underlord_2021_immortal_portal.vpcf",
    -- 白天 / 黑夜时长（秒）
    day_time = 240,
    night_time = 360,
    -- 白天 / 黑夜天气效果持续时间（秒）
    weather_time_day = 120,
    weather_time_night = 180,
    --第一次缩醛范围
    rang1 = 7000,
    --第二次缩醛范围
    rang2 = 3000,
    --团队获胜人头数（5v5 等双人阵营）
    team_kill = 140,
    -- rank_3x4：单队阵营总击杀胜利线（与 team_kill 分离，避免改 3x4 影响 5v5）
    team_kill_3x4 = 150,
    --个人获胜人头数（beidong 等 game_type==2）
    person_kill = 80,
    -- rank_1v1 / beidong 个人获胜人头数
    person_kill_rank_1v1 = 75,
    -- 龙：首只/第二只 刷新时间（秒，与下 MainGame.EventList dragon1、dragon3 一致）；第二只 = 首只 + 3 分钟
    dragon1 = 1260, -- 21*60
    dragon3 = 1440, -- 24*60
    --- 被动模式：真人禁用该物品（商店购买、配方、合成/快递入库、使用）。键为成品 item_* 即可，item_recipe_* 会按成品自动视为禁用。
    PassiveModeBannedShopItems = {
        -- ["item_black_king_bar"] = true,
        ["item_ghost"] = true,           -- 幽灵权杖
        ["item_heavens_halberd"] = true, -- 天堂之戟（含 item_recipe_heavens_halberd 配方购买）
        ["item_skill_33"] = true,        -- 法力精研（技能书掉落/购买/使用）
        ["item_cyclone"] = true,         -- Eul 的神圣法杖（含 item_recipe_cyclone）
        ["item_octarine_core"] = true,   -- 玲珑心（含 item_recipe_octarine_core）
    },
}
MainGame.EventList = {
    --游戏结束
    game_over = {
        id = "game_over",
        time = 1800,
        state = true
    },
    --距离游戏时间结束的语音播报
    timeover1 = {
        id = "timeover1",
        time = 1740,
        state = true
    },
    --距离游戏时间结束的语音播报
    timeover2 = {
        id = "timeover2",
        time = 1677,
        state = true
    },
    --乱斗语音
    lastfight = {
        id = "lastfight",
        time = 1500,
        state = true
    },
    --毒圈2
    map2 = {
        id = "map2",
        time = 1440,
        state = true,
    },
    --毒圈语音2
    map30_2 = {
        id = "map30_2",
        time = 1410,
        state = true,
    },
    --清理2
    clear2 = {
        id = "clear2",
        time = 1380,
        state = true,
    },
    --毒圈1
    map1 = {
        id = "map1",
        time = 960,
        state = true,
    },
    --毒圈语音1
    map30_1 = {
        id = "map30_1",
        time = 930,
        state = true,
    },
    --清理
    clear1 = {
        id = "clear1",
        time = 900,
        state = true,
    },





    --龙2（第二只，顺延 3 分钟，24:00）
    dragon3 = {
        id = "dragon3",
        time = 1440,
        state = true
    },
    --龙1（首只魔龙，游戏时间 21:00）
    dragon1 = {
        id = "dragon1",
        time = 1260,
        state = true
    },
    --熊1
    bear1 = {
        id = "bear1",
        time = 1080,
        state = true
    },
    --熊2
    bear2 = {
        id = "bear2",
        time = 1200,
        state = true
    },
    --熊3
    bear3 = {
        id = "bear3",
        time = 1320,
        state = true
    },


    --狼3
    wolf3 = {
        id = "wolf3",
        time = 540,
        state = true
    },
    --狼2
    wolf2 = {
        id = "wolf2",
        time = 420,
        state = true
    },
    --狼1
    wolf1 = {
        id = "wolf1",
        time = 300,
        state = true
    },
    -- 陨落星辰（8 分钟，4 颗）
    fallstar1 = {
        id = "fallstar1",
        time = 480,
        state = true,
    },
    -- 陨落星辰（10 分钟，4 颗）
    fallstar2 = {
        id = "fallstar2",
        time = 600,
        state = true,
    },
}

MainGame.PlayerData = {
    --玩家steamid
    p_id = -1,
    hero_name = "",
    --名字
    name = "",
    KDA = {
        kill = 0,
        death = 0,
        assist = 0,
        kda = 0,
    },
    --物品栏
    items = {
        slot_1 = "",
        slot_2 = "",
        slot_3 = "",
        slot_4 = "",
        slot_5 = "",
        slot_6 = "",
    },
    --天赋物品=----------------------------------------------------------------
    talent = "item_goods_0",
    --技能栏
    skill = {
        skill_1 = "",
        skill_2 = "",
        skill_3 = "",
        skill_4 = "",
        skill_5 = "",
        skill_6 = "",
        skill_7 = "",
        skill_8 = "",
        skill_9 = "",
        skill_10 = "",
    },
    --金币
    gold = 0,
    --总伤害
    damage = 0,
    --承受伤害
    tank = 0,
    --天梯分
    point = 1000,
    --分数增减
    add_point = 0,
    --tag1(mvp)
    --tag2(神)
    --tag3(暴)
    --tag4(硬)
    --tag5(杀)
    --tag6(僵)
    --tag7(逃)
    --tag8(伐木)
    --tag9(力)
    --tag10(敏)
    --tag11(智)
    --tag12(贪)
    --tag13(无双)
    --tag14(夯)
    --tag15(狂)
    --称号栏
    tag = {
        tag1 = false,
        tag2 = false,
        tag3 = false,
        tag4 = false,
        tag5 = false,
        tag6 = false,
        tag7 = false,
        tag8 = false,
        tag9 = false,
        tag10 = false,
        tag11 = false,
        tag12 = false,
        tag13 = false,
        tag14 = false,
        tag15 = false,
    },
}
MainGame.OverData = {
    --天辉
    Team2 = {
        team = 2,
        result = 0,
        kill = 0,
        player = {
            -- player_0 = {
            --     id = 0,
            --     state = false,
            --     data = {}
            -- },
            -- player_1 = {
            --     id = 1,
            --     state = false,
            --     data = {}
            -- },
            -- player_2 = {
            --     id = 2,
            --     state = false,
            --     data = {}
            -- },
            -- player_3 = {
            --     id = 3,
            --     state = false,
            --     data = {}
            -- },
            -- player_4 = {
            --     id = 4,
            --     state = false,
            --     data = {}
            -- },
        }
    },
    --夜宴
    Team3 = {
        team = 3,
        result = 0,
        kill = 0,
        player = {
            -- player_5 = {
            --     id = 5,
            --     state = false,
            --     data = {}
            -- },
            -- player_6 = {
            --     id = 6,
            --     state = false,
            --     data = {}
            -- },
            -- player_7 = {
            --     id = 7,
            --     state = false,
            --     data = {}
            -- },
            -- player_8 = {
            --     id = 8,
            --     state = false,
            --     data = {}
            -- },
            -- player_9 = {
            --     id = 9,
            --     state = false,
            --     data = {}
            -- },
        }
    }
}
MainGame.TopList = {
    --页面开关
    page = false,
    --当前游戏时间
    time = -1,
    --当前白天夜晚
    day = -1,
    --玩家列表
    list = {
    },
}
MainGame.PlayerSlot = {
    --槽位
    slot = -1,
    --玩家队伍
    team = -1,
    --玩家ID
    id = -1,
    --是否存在
    state = false,
    --是否掉线
    online = false,
    --英雄头像
    hero = "",
    --玩家分数
    point = 0,
    --是否死亡
    death = false,
    --玩家复活时间
    reborn = -1,
}
