--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 图鉴末尾「无归属 / 未收录英雄」技能行：头像用 dummy，标题走本地化 token
Book.UnassignedSkillRow = {
    hero_name = "npc_dota_hero_target_dummy",
    display_name = "clrb_book_unassigned_skills",
}

Book.Data = {}
Book.Template = {
    page = false,
    -- 当前页面
    page_type = 1,
    -- 页面列表(tp1:力量英雄，tp2:敏捷英雄，tp3:智力英雄，tp4:全才英雄)
    --对应HeroType
    list1 = { tp1 = {}, tp2 = {}, tp3 = {}, tp4 = {} },
    -- Dota技能
    --对应HeroSkill
    list2 = {},
    -- 公共技能（hero 为空），技能图鉴顶部单独栏位
    list_public = {
        display_name = "clrb_book_unassigned_skills",
        list = {},
    },
    -- 战斗技能
    --对应BattleSort
    list3 = { tp1 = {}, tp2 = {}, tp3 = {}, tp4 = {} }
}
Book.HeroType = {
    -- 英雄顺序
    index = -1,
    -- 英雄类型(1,力量，2敏捷，3智力，4全才)
    tp = -1,
    -- 英雄名称
    name = "",
    -- 英雄在系统中是否存在
    state = false,
    -- 英雄在系统中的ID，如果不存在就为-1
    id = -1
}
Book.HeroSkill = {
    --索引
    index = -1,
    --英雄名称
    name = "",
    --技能列表
    list = {
        slot_1 = {
            state = false,
            name = "",
            img = "",
            rank = -1,
        },
        slot_2 = {
            state = false,
            name = "",
            img = "",
            rank = -1,

        },
        slot_3 = {
            state = false,
            name = "",
            img = "",
            rank = -1,

        },
        slot_4 = {
            state = false,
            name = "",
            img = "",
            rank = -1,

        },
        slot_5 = {
            state = false,
            name = "",
            img = "",
            rank = -1,

        },
    }
}
Book.BattleSkill = {
    index = -1,
    name = "",
    text = ""
}
Book.BattleSort = {
    ability_item_1 = 4,
    ability_item_2 = 4,
    ability_item_3 = 1,
    ability_item_4 = -1,
    ability_item_5 = 1,
    ability_item_6 = 3,
    ability_item_7 = 3,
    ability_item_8 = 3,
    ability_item_9 = 3,
    ability_item_10 = -1,
    ability_item_11 = 2,
    ability_item_12 = -1,
    ability_item_13 = 4,
    ability_item_14 = 2,
    ability_item_15 = 1,
    ability_item_16 = 4,
    ability_item_17 = 3,
    ability_item_18 = 4,
    ability_item_19 = 1,
    ability_item_20 = 2,
    ability_item_21 = 2,
    ability_item_22 = 3,
    ability_item_23 = 2,
    ability_item_24 = 4,
    ability_item_25 = 3,
    ability_item_26 = 1,
    ability_item_27 = 1,
    ability_item_28 = 4,
    ability_item_29 = 3,
    ability_item_30 = 3,
    ability_item_31 = 3,
    ability_item_32 = 4,
    ability_item_33 = 2,
    ability_item_34 = 4,
    ability_item_35 = 4,
    ability_item_36 = 2,
    ability_item_37 = 1,
    ability_item_38 = 3,
}
Book.HeroList = {
    tp1 = {
        slot_1 = "npc_dota_hero_elder_titan",
        slot_2 = "npc_dota_hero_undying",
        slot_3 = "npc_dota_hero_shredder",
        slot_4 = "npc_dota_hero_omniknight",
        slot_5 = "npc_dota_hero_legion_commander",
        slot_6 = "npc_dota_hero_skeleton_king",
        slot_7 = "npc_dota_hero_phoenix",
        slot_8 = "npc_dota_hero_centaur",
        slot_9 = "npc_dota_hero_rattletrap",
        slot_10 = "npc_dota_hero_huskar",
        slot_11 = "npc_dota_hero_life_stealer",
        slot_12 = "npc_dota_hero_earth_spirit",
        slot_13 = "npc_dota_hero_abyssal_underlord",
        slot_14 = "npc_dota_hero_tiny",
        slot_15 = "npc_dota_hero_tusk",
        slot_16 = "npc_dota_hero_pudge",
        slot_17 = "npc_dota_hero_earthshaker",
        slot_18 = "npc_dota_hero_axe",
        slot_19 = "npc_dota_hero_slardar",
        slot_20 = "npc_dota_hero_sven",
        slot_21 = "npc_dota_hero_kunkka",
        slot_22 = "npc_dota_hero_night_stalker",
        slot_23 = "npc_dota_hero_largo",
        slot_24 = "npc_dota_hero_doom_bringer",
        slot_25 = "npc_dota_hero_treant",
        slot_26 = "npc_dota_hero_chaos_knight",
        slot_27 = "npc_dota_hero_tidehunter",
        slot_28 = "npc_dota_hero_alchemist",
        slot_29 = "npc_dota_hero_lycan",
        slot_30 = "npc_dota_hero_primal_beast",
        slot_31 = "npc_dota_hero_mars",
        slot_32 = "npc_dota_hero_dawnbreaker",
        slot_33 = "npc_dota_hero_spirit_breaker",
        slot_34 = "npc_dota_hero_bristleback",
        slot_35 = "npc_dota_hero_ogre_magi",
        slot_36 = "npc_dota_hero_dragon_knight"
    },
    tp2 = {
        slot_1 = "npc_dota_hero_juggernaut",
        slot_2 = "npc_dota_hero_clinkz",
        slot_3 = "npc_dota_hero_viper",
        slot_4 = "npc_dota_hero_kez",
        slot_5 = "npc_dota_hero_riki",
        slot_6 = "npc_dota_hero_drow_ranger",
        slot_7 = "npc_dota_hero_morphling",
        slot_8 = "npc_dota_hero_templar_assassin",
        slot_9 = "npc_dota_hero_vengefulspirit",
        slot_10 = "npc_dota_hero_naga_siren",
        slot_11 = "npc_dota_hero_troll_warlord",
        slot_12 = "npc_dota_hero_phantom_assassin",
        slot_13 = "npc_dota_hero_phantom_lancer",
        slot_14 = "npc_dota_hero_spectre",
        slot_15 = "npc_dota_hero_nevermore",
        slot_16 = "npc_dota_hero_terrorblade",
        slot_17 = "npc_dota_hero_antimage",
        slot_18 = "npc_dota_hero_slark",
        slot_19 = "npc_dota_hero_hoodwink",
        slot_20 = "npc_dota_hero_ember_spirit",
        slot_21 = "npc_dota_hero_ursa",
        slot_22 = "npc_dota_hero_sniper",
        slot_23 = "npc_dota_hero_lone_druid",
        slot_24 = "npc_dota_hero_gyrocopter",
        slot_25 = "npc_dota_hero_mirana",
        slot_26 = "npc_dota_hero_meepo",
        slot_27 = "npc_dota_hero_weaver",
        slot_28 = "npc_dota_hero_medusa",
        slot_29 = "npc_dota_hero_broodmother",
        slot_30 = "npc_dota_hero_faceless_void",
        slot_31 = "npc_dota_hero_bloodseeker",
        slot_32 = "npc_dota_hero_bounty_hunter",
        slot_33 = "npc_dota_hero_razor",
        slot_34 = "npc_dota_hero_luna",
        slot_35 = "npc_dota_hero_monkey_king"
    },
    tp3 = {
        slot_1 = "npc_dota_hero_tinker",
        slot_2 = "npc_dota_hero_keeper_of_the_light",
        slot_3 = "npc_dota_hero_skywrath_mage",
        slot_4 = "npc_dota_hero_grimstroke",
        slot_5 = "npc_dota_hero_zuus",
        slot_6 = "npc_dota_hero_winter_wyvern",
        slot_7 = "npc_dota_hero_witch_doctor",
        slot_8 = "npc_dota_hero_lich",
        slot_9 = "npc_dota_hero_puck",
        slot_10 = "npc_dota_hero_pugna",
        slot_11 = "npc_dota_hero_disruptor",
        slot_12 = "npc_dota_hero_leshrac",
        slot_13 = "npc_dota_hero_rubick",
        slot_14 = "npc_dota_hero_shadow_demon",
        slot_15 = "npc_dota_hero_shadow_shaman",
        slot_16 = "npc_dota_hero_warlock",
        slot_17 = "npc_dota_hero_jakiro",
        slot_18 = "npc_dota_hero_obsidian_destroyer",
        slot_19 = "npc_dota_hero_crystal_maiden",
        slot_20 = "npc_dota_hero_silencer",
        slot_21 = "npc_dota_hero_muerta",
        slot_22 = "npc_dota_hero_queenofpain",
        slot_23 = "npc_dota_hero_necrolyte",
        slot_24 = "npc_dota_hero_ringmaster",
        slot_25 = "npc_dota_hero_invoker",
        slot_26 = "npc_dota_hero_oracle",
        slot_27 = "npc_dota_hero_lina",
        slot_28 = "npc_dota_hero_lion",
        slot_29 = "npc_dota_hero_ancient_apparition",
        slot_30 = "npc_dota_hero_dark_willow",
        slot_31 = "npc_dota_hero_chen",
        slot_32 = "npc_dota_hero_storm_spirit",
        slot_33 = "npc_dota_hero_enchantress",
        slot_34 = "npc_dota_hero_dark_seer"
    },
    tp4 = {
        slot_1 = "npc_dota_hero_abaddon",
        slot_2 = "npc_dota_hero_beastmaster",
        slot_3 = "npc_dota_hero_venomancer",
        slot_4 = "npc_dota_hero_nyx_assassin",
        slot_5 = "npc_dota_hero_arc_warden",
        slot_6 = "npc_dota_hero_techies",
        slot_7 = "npc_dota_hero_dazzle",
        slot_8 = "npc_dota_hero_death_prophet",
        slot_9 = "npc_dota_hero_sand_king",
        slot_10 = "npc_dota_hero_marci",
        slot_11 = "npc_dota_hero_snapfire",
        slot_12 = "npc_dota_hero_pangolier",
        slot_13 = "npc_dota_hero_bane",
        slot_14 = "npc_dota_hero_visage",
        slot_15 = "npc_dota_hero_furion",
        slot_16 = "npc_dota_hero_wisp",
        slot_17 = "npc_dota_hero_void_spirit",
        slot_18 = "npc_dota_hero_batrider",
        slot_19 = "npc_dota_hero_enigma",
        slot_20 = "npc_dota_hero_brewmaster",
        slot_21 = "npc_dota_hero_windrunner",
        slot_22 = "npc_dota_hero_magnataur"
    }
}
