--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Boot.Data = {}
Boot.Config = {
    -- 进入选人前是否启用机器人（由队伍界面开启任一难度时自动为 true）
    enable_bot_players = false,
    -- 机器人难度：0 未选人机，1 简单电脑，2 困难电脑，3 令人发狂（数值见 ingame/BotAI/Config.lua 内 BOTAI_PRESET_*）
    bot_difficulty = 0,
    -- bot_passive_mode：已废弃，服务端固定为 false（兼容旧字段）
    bot_passive_mode = false,
    -- 启用机器人时，补齐到的总玩家数量（含真人和机器人）
    auto_fill_player_count = 10
}
--在这里AI英雄根据自身索引判断自己是什么类型的英雄
Boot.BootType = {
    tp1 = {
        -- 力量
        1, 2, 3, 6, 7, 8, 9, 36, 37, 38, 39, 40, 41, 42, 43, 44,
        47, 68, 74, 75, 76, 77, 78, 80, 83, 90, 91, 92, 93, 99, 105, 107, 111, 45
        -- 2
    },
    tp2 = {
        -- 敏捷
        11, 14, 15, 17, 19, 20, 21, 22, 23, 48, 49, 50, 51, 52, 53, 54,
        55, 69, 71, 81, 82, 84, 89, 94, 101, 102, 108, 109
        --20
    },
    tp3 = {
        -- 智力
        24, 25, 29, 30, 57, 58, 59, 60, 61, 63, 64, 65, 67, 70,
        73, 79, 26, 85, 86, 88, 95, 96, 103, 104, 106, 110,
        87, 66
        -- 33
    }
}
--人机购买物品的顺序
Boot.ItemOrder = {
    --力量
    tp1 = {
        slot1 = "item_phase_boots",
        slot2 = "item_blade_mail",
        slot3 = "item_sange_and_yasha",
        slot4 = "item_assault",
        slot5 = "item_heart",
        slot6 = "item_black_king_bar",
    },
    tp2 = {
        slot1 = "item_phase_boots",
        slot2 = "item_sange_and_yasha",
        slot3 = "item_satanic",
        slot4 = "item_butterfly",
        slot5 = "item_monkey_king_bar",
        slot6 = "item_black_king_bar",
    },
    tp3 = {
        slot1 = "item_phase_boots",
        slot2 = "item_yasha_and_kaya",
        slot3 = "item_heavens_halberd",
        slot4 = "item_shivas_guard",
        slot5 = "item_bloodstone",
        slot6 = "item_black_king_bar",
    }
}
