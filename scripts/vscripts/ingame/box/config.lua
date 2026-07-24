--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Box.Data = {}
Box.Template = {
    show = false,
    page = false,
    --假人索引
    dummy = -1,
    -- 是否已经抽取
    draw_state = true,
    -- 支付货币
    cost = 0,
    -- 宝箱剩余可抽取次数
    box_sy_draw = 1,
    -- 宝箱抽取次数
    box_draw_num = 0,
    -- 重新随机剩余次数
    roll_sy_draw = 0,
    -- 抽到天气之子·狂风后开启：后续宝箱保底出现未获得的随机天气，直到四种天气抽完
    weather_pity = false,
    -- 本局已获得的天气 id（57~60），人机无 modifier 时也靠此判断
    weather_got = {},
    bag = {
        slot_1 = -1,
        slot_2 = -1,
        slot_3 = -1,
        slot_4 = -1,
        slot_5 = -1,
        slot_6 = -1
    },
    -- 十二个宝箱列表
    list = {},
    -- 权重1装备列表
    weight_1 = {},
    -- 权重2装备列表
    weight_2 = {},
    -- 宝箱池子
    box_1 = {
        z_0 = true,
        z_1 = true,
        z_2 = true,
        z_3 = true,
        -- z_4 = true,
        z_5 = true,
        z_6 = true,
        -- z_7 = true,
        z_8 = true,
        z_9 = true,
        z_10 = true,
        z_11 = true,
        z_12 = true,
        z_13 = true,
        z_14 = true,
        z_15 = true,
        z_16 = true,
        z_17 = true,
        z_18 = true,
        z_19 = true,
        z_20 = true,
        z_21 = true,
        z_57 = true,
        z_58 = false,
        z_59 = false,
        z_60 = false,
        -- z_66 = true,
        z_73 = true
    },
    box_2 = {
        z_22 = false,
        z_23 = false,
        z_24 = false,
        z_71 = false,
        z_72 = false,
        z_26 = true,
        -- z_27 = true,
        z_32 = true,
        -- z_4 = true,
        z_74 = false,
        z_5 = true,
        -- z_7 = true,
        z_35 = true,
        z_61 = true,
        z_65 = true,
        z_63 = true,
        z_50 = true,
        z_52 = true,
        z_37 = false,
        z_9 = true,
        z_39 = true,
        z_77 = true,
        z_1 = true,
        z_2 = true,
        z_3 = true,
        z_40 = true,
        z_31 = true,
        z_8 = true,
        z_57 = true,
        z_58 = false,
        z_59 = false,
        z_60 = false,
        z_87 = true,
        z_49 = false,

    },
    box_3 = {
        z_42 = false,
        z_43 = false,
        z_45 = true,
        z_46 = false,
        z_54 = true,
        z_55 = true,
        z_56 = true,
        z_47 = true,
        z_64 = false,
        z_48 = false,
        z_78 = false,
        z_62 = true,
        z_22 = false,
        z_23 = false,
        z_24 = false,
        z_71 = false,
        z_72 = false,
        z_26 = true,
        z_39 = true,
        z_31 = true,
        -- z_27 = true,
        z_9 = true,
        z_50 = true,
        z_52 = true,
        z_37 = false,
        z_76 = false,
        z_5 = false,
        -- z_70 = false,
        z_75 = false,
        z_51 = true,
        z_53 = true,
        z_58 = false,
        z_59 = false,
        z_60 = false,

        z_79 = true,
        z_80 = true,
        z_81 = true,
        z_82 = true,
        -- z_83 = true,
        z_84 = true,
        -- z_85 = true
        z_86 = true,
        z_88 = false,
        -- z_89 = true,
        z_90 = false,
        z_91 = false,
        z_92 = true,
        z_69 = true,
        z_49 = false,
    },
    run_cd = -1,
    run_state = true,
    -- 技能增强
    skill = { item_54 = false, item_55 = false, item_56 = false, item_92 = false }
}
Box.SlotTemplate = {
    -- 槽位id
    id = -1,
    -- 是否高亮
    light = false,
    -- 物品id
    item = -1
}
Box.Static = {
    run_cd = 40,
    -- 单局每名玩家最多完成宝箱抽取（开启一轮 RollBox）的次数
    max_draw_per_game = 20,
    box_slot_num = 12,
    -- 一次抽取物品数量
    roll_num = 3,
    -- 重新随机次数
    sy_draw = 4,
    add_box = {
        min_4 = false,
        min_8 = false,
        min_12 = false,
        min_16 = false,
        min_20 = false,
        min_24 = false,
        min_28 = false,
    },
    roll_cost = { num1 = 19, num2 = 9, num3 = 1, num4 = 0 }
}

-- 宝箱内重随
Box.Roll = {
    -- 权重为1的装备
    box_1 = {
        -- 天气 57~60 固定为稀有
        weight_1 = { 1, 2, 3, 5, 8, 9, 57, 58, 59, 60 },
        weight_2 = {
            0, 6, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 73
        }
    },
    box_2 = {
        weight_1 = { 22, 23, 24, 71, 72, 26, 27, 49, 37, 57, 58, 59, 60 },
        weight_2 = {
            32, 74, 5, 35, 61, 65, 63, 50, 52, 9, 39, 77, 1, 2, 3, 40,
            31, 8, 87
        }
    },
    box_3 = {
        weight_1 = { 42, 43, 46, 54, 55, 56, 47, 64, 48, 78, 62, 83, 81, 45, 84, 88, 92, 69, 58, 59, 60 },
        weight_2 = {
            22, 23, 24, 71, 72, 26, 27, 9, 50, 52, 37, 76, 5, 75, 51,
            53, 31, 79, 80, 82, 86, 90, 91, 49, 39, 31
        }
    }
}

--不加进虚拟体的物品列表
Box.NoDummy = {
    7, 70, 12, 37, 72, 76, 43, 49, 19, 76
}
Box.Item = {
    -- 初级技能书
    item_box_0 = {
        id = 0,
        name = "item_box_0",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 夜叉
    item_box_1 = {
        id = 1,
        name = "item_box_1",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 22,
        son_list = {},
        buff = "item_yasha"
    },
    -- 散华
    item_box_2 = {
        id = 2,
        name = "item_box_2",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 22,
        son_list = {},
        buff = "item_sange"
    },
    -- 慧光
    item_box_3 = {
        id = 3,
        name = "item_box_3",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 23,
        son_list = {},
        buff = "item_kaya"
    },
    -- 林野长弓
    -- item_box_4 = {
    --     id = 4,
    --     name = "item_box_4",
    --     fa = false,
    --     son = false,
    --     cost = false,
    --     copy = false,
    --     fa_list = {},
    --     son_list = {},
    --     buff = "item_grove_bow"
    -- },
    -- 水晶剑
    item_box_5 = {
        id = 5,
        name = "item_box_5",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 45,
        son_list = {},
        buff = "item_lesser_crit"
    },
    -- 幽魂披风
    item_box_6 = {
        id = 6,
        name = "item_box_6",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 24,
        son_list = {},
        buff = "item_cloak",
        diff = true,
        item_name = "item_planeswalkers_cloak"
    },
    -- 漩涡
    -- item_box_7 = {
    --     id = 7,
    --     name = "item_box_7",
    --     fa = true,
    --     son = false,
    --     cost = false,
    --     copy = false,
    --     fa_list = 70,
    --     son_list = {},
    --     buff = "item_maelstrom"
    -- },
    -- 魔龙枪
    item_box_8 = {
        id = 8,
        name = "item_box_8",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 90,
        son_list = {},
        buff = "item_dragon_lance"
    },
    -- 吸血鬼的祭品
    item_box_9 = {
        id = 9,
        name = "item_box_9",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_vladmir"
    },
    -- 碎裂背心
    item_box_10 = {
        id = 10,
        name = "item_box_10",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_chipped_vest"
    },
    -- 穷鬼盾
    item_box_11 = {
        id = 11,
        name = "item_box_11",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_poor_mans_shield"
    },
    -- 速度之靴
    item_box_12 = {
        id = 12,
        name = "item_box_12",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 37,
        son_list = {},
        buff = "item_boots",
        diff = true,
        item_name = "item_boots_of_speed"
    },
    -- 阔剑
    item_box_13 = {
        id = 13,
        name = "item_box_13",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 71,
        son_list = {},
        buff = "item_broadsword"
    },
    -- 吸血面具
    item_box_14 = {
        id = 14,
        name = "item_box_14",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_lifesteal",
        diff = true,
        item_name = "item_mask_of_death"
    },
    -- 怨灵系带
    item_box_15 = {
        id = 15,
        name = "item_box_15",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_wraith_band"
    },
    -- 护腕
    item_box_16 = {
        id = 16,
        name = "item_box_16",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_bracer"
    },
    -- 空灵挂件
    item_box_17 = {
        id = 17,
        name = "item_box_17",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_null_talisman"
    },
    -- 腐蚀之球
    item_box_18 = {
        id = 18,
        name = "item_box_18",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_orb_of_corrosion"
    },
    -- 标枪
    item_box_19 = {
        id = 19,
        name = "item_box_19",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 49,
        son_list = {},
        buff = "item_javelin"
    },
    -- 铁意头盔
    item_box_20 = {
        id = 20,
        name = "item_box_20",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_helm_of_iron_will"
    },
    -- 闪避护符
    item_box_21 = {
        id = 21,
        name = "item_box_21",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 72,
        son_list = {},
        buff = "item_talisman_of_evasion"
    },
    -- 散夜对剑
    item_box_22 = {
        id = 22,
        name = "item_box_22",
        fa = true,
        son = true,
        cost = false,
        copy = false,
        fa_list = 42,
        son_list = { 1, 2 },
        buff = "item_sange_and_yasha"
    },
    -- 散慧对剑
    item_box_23 = {
        id = 23,
        name = "item_box_23",
        fa = true,
        son = true,
        cost = false,
        copy = false,
        fa_list = 42,
        son_list = { 3 },
        buff = "item_yasha_and_kaya"
    },
    -- 永世法衣
    item_box_24 = {
        id = 24,
        name = "item_box_24",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 6 },
        buff = "item_eternal_shroud"
    },
    -- 林肯法球
    item_box_25 = {
        id = 25,
        name = "item_box_25",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_sphere"
    },
    -- 法师克星
    item_box_26 = {
        id = 26,
        name = "item_box_26",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_mage_slayer"
    },
    -- 简朴短帽
    item_box_27 = {
        id = 27,
        name = "item_box_27",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_ascetic_cap"
    },
    -- 智灭
    item_box_28 = {
        id = 28,
        name = "item_box_28",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_mind_breaker"
    },
    -- 亲王短刀
    item_box_29 = {
        id = 29,
        name = "item_box_29",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_princes_knife"
    },
    -- 碎骨锤
    item_box_30 = {
        id = 30,
        name = "item_box_30",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_cranium_basher",
        diff = true,
        item_name = "item_basher"
    },
    -- 圣者遗物
    item_box_31 = {
        id = 31,
        name = "item_box_31",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 43,
        son_list = {},
        buff = "item_relic",
        diff = true,
        item_name = "item_sacred_relic"
    },
    -- 法术棱镜
    item_box_32 = {
        id = 32,
        name = "item_box_32",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "spell_prism",
        diff = true,
        item_name = "item_spell_prism"
    },
    -- 巫师之刃
    item_box_33 = {
        id = 33,
        name = "item_box_33",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 44,
        son_list = {},
        buff = "item_witch_blade"
    },
    -- 漩涡
    item_box_34 = {
        id = 34,
        name = "item_box_34",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = 44,
        son_list = {},
        buff = "item_maelstrom"
    },
    -- 放大单片镜
    item_box_35 = {
        id = 35,
        name = "item_box_35",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_magnifying_monocle"
    },
    -- 风暴宝器
    item_box_36 = {
        id = 36,
        name = "item_box_36",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_stormcrafter",
        diff = true,
        item_name = "item_stormcrafter"
    },
    -- 远行鞋
    item_box_37 = {
        id = 37,
        name = "item_box_37",
        fa = true,
        son = true,
        cost = false,
        copy = false,
        fa_list = 91,
        son_list = { 12 },
        -- buff = "item_boots_of_travel",
        buff = "item_travel_boots",
        diff = true,
        item_name = "item_boots_of_travel"
    },
    -- 吸血鬼的祭品
    item_box_38 = {
        id = 38,
        name = "item_box_38",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_vladmir"
    },
    -- 振奋宝石
    item_box_39 = {
        id = 39,
        name = "item_box_39",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 76,
        son_list = {},
        buff = "item_hyperstone"
    },
    -- 恐惧邪说
    item_box_40 = {
        id = 40,
        name = "item_box_40",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_whisper_of_the_dread"
    },
    -- 弩炮
    item_box_41 = {
        id = 41,
        name = "item_box_41",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_ballista"
    },
    -- 三元重戟
    item_box_42 = {
        id = 42,
        name = "item_box_42",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 22, 23 },
        buff = "item_trident"
    },
    -- 圣剑
    item_box_43 = {
        id = 43,
        name = "item_box_43",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 31 },
        buff = "item_divine_rapier",
        diff = true,
        item_name = "item_rapier"
    },
    -- 血棘
    item_box_44 = {
        id = 44,
        name = "item_box_44",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 33 },
        buff = "item_devastator"
    },
    -- 代达罗斯之殇
    item_box_45 = {
        id = 45,
        name = "item_box_45",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 5 },
        buff = "item_greater_crit"
    },
    -- 蝴蝶
    item_box_46 = {
        id = 46,
        name = "item_box_46",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 52 },
        buff = "item_butterfly"
    },
    -- 极（绿字主属性，见 modifier_box_47）
    item_box_47 = {
        id = 47,
        name = "item_box_47",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 寂灭
    item_box_48 = {
        id = 48,
        name = "item_box_48",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 74 },
        buff = "item_desolator_2"
    },
    -- 金箍棒
    item_box_49 = {
        id = 49,
        name = "item_box_49",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 19 },
        buff = "item_monkey_king_bar"
    },
    -- 板甲
    item_box_50 = {
        id = 50,
        name = "item_box_50",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 75,
        son_list = {},
        buff = "item_platemail",
        diff = true,
        item_name = "item_plate_mail"
    },
    -- 恶魔刀锋
    item_box_51 = {
        id = 51,
        name = "item_box_51",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_demon_edge"
    },
    -- 鹰歌弓
    item_box_52 = {
        id = 52,
        name = "item_box_52",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 46,
        son_list = {},
        buff = "item_eaglehorn",
        diff = true,
        item_name = "item_eagle"
    },
    -- 亡魂胸针
    item_box_53 = {
        id = 53,
        name = "item_box_53",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_revenants_brooch"
    },
    -- 粉碎之心
    item_box_54 = {
        id = 54,
        name = "item_box_54",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 雷霆之心
    item_box_55 = {
        id = 55,
        name = "item_box_55",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 全能之心
    item_box_56 = {
        id = 56,
        name = "item_box_56",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 天气之子·狂风
    item_box_57 = {
        id = 57,
        name = "item_box_57",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 天气之子·寒霜
    item_box_58 = {
        id = 58,
        name = "item_box_58",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 天气之子·雨露
    item_box_59 = {
        id = 59,
        name = "item_box_59",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 天气之子·艳阳
    item_box_60 = {
        id = 60,
        name = "item_box_60",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 高级技能书
    item_box_61 = {
        id = 61,
        name = "item_box_61",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 究极技能书
    item_box_62 = {
        id = 62,
        name = "item_box_62",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    },
    -- 极限法球
    item_box_63 = {
        id = 63,
        name = "item_box_63",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 64,
        son_list = {},
        buff = "item_ultimate_orb"
    },
    -- 冰眼
    item_box_64 = {
        id = 64,
        name = "item_box_64",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 63 },
        buff = "item_skadi"
    },
    -- 先锋盾
    item_box_65 = {
        id = 65,
        name = "item_box_65",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_vanguard"
    },
    -- 魔龙枪
    item_box_66 = {
        id = 66,
        name = "item_box_66",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_dragon_lance"
    },
    -- 连击刀
    item_box_67 = {
        id = 67,
        name = "item_box_67",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_echo_sabre"
    },
    -- 镇魂石
    item_box_68 = {
        id = 68,
        name = "item_box_68",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 69,
        son_list = {},
        buff = "item_soul_booster"
    },
    -- 玲珑心
    item_box_69 = {
        id = 69,
        name = "item_box_69",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_octarine_core"
    },
    -- 雷神之锤
    -- item_box_70 = {
    --     id = 70,
    --     name = "item_box_70",
    --     fa = false,
    --     son = true,
    --     cost = false,
    --     copy = false,
    --     fa_list = {},
    --     son_list = { 7 },
    --     buff = "item_mjollnir"
    -- },
    -- 狂战斧
    item_box_71 = {
        id = 71,
        name = "item_box_71",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 13 },
        buff = "item_bfury",
        diff = true,
        item_name = "item_battlefury"
    },
    -- 辉耀
    item_box_72 = {
        id = 72,
        name = "item_box_72",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 21 },
        buff = "item_radiance"
    },
    -- 密银锤
    item_box_73 = {
        id = 73,
        name = "item_box_73",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 74,
        son_list = {},
        buff = "item_mithril_hammer"
    },
    -- 暗灭
    item_box_74 = {
        id = 74,
        name = "item_box_74",
        fa = true,
        son = true,
        cost = false,
        copy = false,
        fa_list = 48,
        son_list = { 73 },
        buff = "item_desolator"
    },
    -- 西瓦的守护
    item_box_75 = {
        id = 75,
        name = "item_box_75",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 50 },
        buff = "item_shivas_guard"
    },
    -- 强袭胸甲
    item_box_76 = {
        id = 76,
        name = "item_box_76",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 39 },
        buff = "item_assault"
    },
    -- 恐鳌之戒
    item_box_77 = {
        id = 77,
        name = "item_box_77",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 78,
        son_list = {},
        buff = "item_ring_of_tarrasque"
    },
    -- 龙心
    item_box_78 = {
        id = 78,
        name = "item_box_78",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 77 },
        buff = "item_heart"
    },
    -- 以太透镜
    item_box_79 = {
        id = 79,
        name = "item_box_79",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_aether_lens"
    },
    -- 银闪护符
    item_box_80 = {
        id = 80,
        name = "item_box_80",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_quicksilver_amulet"
    },
    -- 德尊血誓
    item_box_81 = {
        id = 81,
        name = "item_box_81",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_dezun_bloodrite"
    },
    -- 五锋长剑
    item_box_82 = {
        id = 82,
        name = "item_box_82",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_penta_edged_sword"
    },
    -- 永恒遗物
    -- item_box_83 = {
    --     id = 83,
    --     name = "item_box_83",
    --     fa = false,
    --     son = false,
    --     cost = false,
    --     copy = false,
    --     fa_list = {},
    --     son_list = {},
    --     buff = "item_timeless_relic"
    -- },
    -- 散魂剑
    item_box_84 = {
        id = 84,
        name = "item_box_84",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_disperser"
    },
    -- 林肯法球
    -- item_box_85 = {
    --     id = 85,
    --     name = "item_box_85",
    --     fa = false,
    --     son = false,
    --     cost = false,
    --     copy = false,
    --     fa_list = {},
    --     son_list = {},
    --     buff = "item_sphere"
    -- }
    -- 亲王短刀
    item_box_86 = {
        id = 86,
        name = "item_box_86",
        fa = false,
        son = false,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = "item_princes_knife"
    },
    -- 巫师之刃
    item_box_87 = {
        id = 87,
        name = "item_box_87",
        fa = true,
        son = false,
        cost = false,
        copy = false,
        fa_list = 88,
        son_list = {},
        buff = "item_witch_blade"
    },
    -- 血棘
    item_box_88 = {
        id = 88,
        name = "item_box_88",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 87 },
        buff = "item_devastator"
    },
    -- 巨人之戒
    -- item_box_89 = {
    --     id = 89,
    --     name = "item_box_89",
    --     fa = false,
    --     son = false,
    --     cost = false,
    --     copy = false,
    --     fa_list = {},
    --     son_list = {},
    --     buff = "item_giants_ring"
    -- },
    -- 许德拉吐息
    item_box_90 = {
        id = 90,
        name = "item_box_90",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 8 },
        buff = "item_hydras_breath",
        diff = true,
        item_name = "hydras_breath"
    },
    --踏云靴
    item_box_91 = {
        id = 91,
        name = "item_box_91",
        fa = false,
        son = true,
        cost = false,
        copy = false,
        fa_list = {},
        son_list = { 37 },
        buff = "item_equip_4",
        diff = true,
        item_name = "item_equip_4_buff"
    },
    item_box_92 = {
        id = 92,
        name = "item_box_92",
        fa = false,
        son = false,
        cost = true,
        copy = false,
        fa_list = {},
        son_list = {},
        buff = ""
    }
}
