--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Skill.Data = {}
Skill.Template = {
    page = false,
    --- 技能书 UI：四槽已满时为 true，客户端显示「替换」而非「学习」
    skill_book_replace = false,
    --- 工具模式图鉴学技能：下次替换的 Skill1 槽位（1→2→3→4 循环）
    tools_skill_rot = 1,
    select_num = 0,
    select_t1_num = 0,
    list = {
        slot_1 = {
            slot = 1,
            state = false,
            rank = -1,
            skill = -1,
            text = ""
        },
        slot_2 = {
            slot = 2,
            state = false,
            rank = -1,
            skill = -1,
            text = ""
        },
        slot_3 = {
            slot = 3,
            state = false,
            rank = -1,
            skill = -1,
            text = ""
        },
    },
    --拥有的技能
    --修改槽位界面
    slot_page = false,
    slot_img_page = false,
    --要修改的槽位
    log_slot = -1,
    Skill1 = {
        slot_1 = {
            slot = 1,
            name = "ability_null_1",
            id = -1,
        },
        slot_2 = {
            slot = 2,
            name = "ability_null_2",
            id = -1
        },
        slot_3 = {
            slot = 3,
            name = "ability_null_3",
            id = -1
        },
        slot_4 = {
            slot = 4,
            name = "ability_null_4",
            id = -1
        },
    },
    del_page = false,
    Skill2 = {
        slot_5 = {
            slot = 5,
            state = false,
            name = "ability_null_5",
        },
        slot_6 = {
            slot = 6,
            state = false,
            name = "ability_null_6",
        },
        slot_7 = {
            slot = 7,
            state = false,
            name = "ability_null_7",
        },
        slot_8 = {
            slot = 8,
            state = false,
            name = "ability_null_8",
        },
        slot_9 = {
            slot = 9,
            state = false,
            name = "ability_null_9",
        },
        slot_10 = {
            slot = 10,
            state = false,
            name = "ability_null_10",
        },
    },
    -- 肉搏技删除或卖店后禁止宠物拾取同名书；AddSkill2 成功或用书/商店新购时清项 [item_name]=true
    melee_pet_ban = {},
    HeroSkill = {}
}
Skill.Public = {

}
Skill.Static = {
    --t1保底次数
    t1_select = 20,
    --一次抽取技能书次数
    page_num = 3,
    -- 初级/高级技能书：Rank0/Rank1 需对局达到该分钟后才进入随机池
    book_rank01_unlock_min = 15,
}
Skill.Roll = {
    --初级技能书
    T2 = {
        Rank4 = 95000,
        Rank3 = 4825,
        Rank2 = 125,
        Rank1 = 45,
        Rank0 = 5
    },
    --高级技能书
    T1 = {
        Rank4 = 5000,
        Rank3 = 4855,
        Rank2 = 125,
        Rank1 = 15,
        Rank0 = 5
    },
    --究极技能书
    T0 = {
        Rank0 = 1000,
        Rank1 = 8999,
        Rank2 = 1
    }
}
--- 技能书英雄绑定保底：规则一 primary_ranks；规则二 override_ranks（roll 到该品阶时优先本体绑定）
Skill.BookGuarantee = {
    -- 初级技能书
    T2 = {
        primary_ranks = { 4 },
        override_ranks = { 2, 1 },
    },
    -- 中级技能书（配置注释为高级）
    T1 = {
        primary_ranks = { 3, 2 },
        override_ranks = { 4, 1, 0 },
    },
    -- 究极技能书
    T0 = {
        primary_ranks = { 1, 0 },
        override_ranks = { 2 },
    },
}
Skill.Rank1 = {}
Skill.Rank2 = {}
Skill.Rank3 = {}
Skill.Rank4 = {}
Skill.Rank0 = {}
--立即删除技能
Skill.RemoveAbilityImmediateNames = {
    "ability_hero_2",
    "ability_hero_3",
    "magnataur_empower",
    "bristleback_quill_spray",
    "tusk_walrus_punch",
    "drow_ranger_frost_arrows",
    "doom_bringer_infernal_blade",
}
--过滤烈焰缠绕的灼烧效果
Skill.Skill36Filter = {
    "item_goods_19",
    "item_radiance",
    "ability_item_36",
    "ability_item_19",
    "lina_slow_burn",
    -- 刃甲、尖刺外壳、灵呱一闪：不叠加烈焰缠身灼烧
    "item_blade_mail",
    "largo_croak_of_genius",
    -- 影之灵龛、魂之灵龛：持续伤害不重复触发灼烧
    "item_urn_of_shadows",
    "item_spirit_vessel",
}
--需要额外添加弹道的近战英雄
Skill.RangedAttacker = {
    "npc_dota_hero_antimage",
    "npc_dota_hero_slark",
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_largo",
    "npc_dota_hero_brewmaster",
    "npc_dota_hero_beastmaster",
    "npc_dota_hero_skeleton_king",
    "npc_dota_hero_slardar",
    "npc_dota_hero_earthshaker",
    "npc_dota_hero_pudge",
    "npc_dota_hero_sven",
    "npc_dota_hero_marci"
}
--技能列表目录
Skill.Ability = {
    -- 暗影之境（邪影芳灵一技能）
    skill_1 = {
        --技能索引
        id = 1,
        --技能类型（1，T0技能；2.T1技能；3：T2技能
        rank = 0,
        --技能名称
        name = "dark_willow_shadow_realm",
        --是否有对应英雄，可以为空
        hero = "npc_dota_hero_dark_willow"
    },
    -- 回光返照（亚巴顿大招）
    skill_2 = {
        id = 2,
        rank = 0,
        name = "abaddon_borrowed_time",
        hero = "npc_dota_hero_abaddon"
    },
    -- 重击（斯拉达被动）
    skill_3 = {
        id = 3,
        rank = 1,
        name = "slardar_bash",
        hero = "npc_dota_hero_slardar"
    },
    -- 时间锁定（虚空假面被动）
    skill_4 = {
        id = 4,
        rank = 2,
        name = "faceless_void_time_lock",
        hero = "npc_dota_hero_faceless_void"
    },
    -- 死亡一指（莱恩大招）
    skill_5 = {
        id = 5,
        rank = 2,
        --name = "lion_finger_of_death",
        name = "lion_finger_of_death",
        hero = "npc_dota_hero_lion"
    },
    --能量转移（移除）
    -- skill_6 = {
    --     id = 6,
    --     rank = 0,
    --     name = "slark_essence_shift",
    --     hero = ""
    -- },
    -- 智慧之刃（沉默术士被动）
    skill_7 = {
        id = 7,
        rank = 2,
        name = "silencer_glaives_of_wisdom",
        hero = "npc_dota_hero_silencer"
    },
    -- 天命（琼英碧灵大招）
    skill_8 = {
        id = 8,
        rank = 0,
        name = "muerta_pierce_the_veil",
        hero = ""
    },
    -- 血肉傀儡（不朽尸王大招）
    skill_9 = {
        id = 9,
        rank = 1,
        name = "undying_flesh_golem",
        hero = "npc_dota_hero_undying"
    },
    -- 神射手（卓尔游侠被动）
    skill_10 = {
        id = 10,
        rank = 1,
        name = "drow_ranger_marksmanship",
        hero = "npc_dota_hero_drow_ranger"
    },
    -- 影武长刀·隼冲（凯二技能）
    skill_11 = {
        id = 11,
        rank = 1,
        name = "kez_falcon_rush",
        hero = "npc_dota_hero_kez"
    },
    -- skill_12 = {
    --     id = 12,
    --     rank = 1,
    --     name = "elder_titan_natural_order_spirit",
    --     hero = ""
    -- },
    --猴子猴孙（移除）
    -- skill_13 = {
    --     id = 13,
    --     rank = 1,
    --     name = "monkey_king_wukongs_command",
    --     hero = "npc_dota_hero_monkey_king"
    -- },
    -- 严寒灼烧（寒冬飞龙一技能）
    skill_14 = {
        id = 14,
        rank = 1,
        name = "winter_wyvern_arctic_burn",
        hero = "npc_dota_hero_winter_wyvern"
    },
    -- 神智之蚀（殁境神蚀者大招）
    skill_15 = {
        id = 15,
        rank = 2,
        name = "ability_hero_2",
        hero = "npc_dota_hero_obsidian_destroyer"
    },
    -- 宙斯绑定技能（ability_hero_3，自定义位）
    skill_16 = {
        id = 16,
        rank = 0,
        name = "ability_hero_3",
        hero = ""
    },
    -- 虚妄之诺（神谕者大招）
    skill_17 = {
        id = 17,
        rank = 1,
        name = "oracle_false_promise",
        hero = "npc_dota_hero_oracle"
    },
    --普通一拳
    -- skill_18 = {
    --     id = 18,
    --     rank = 1,
    --     name = "dark_seer_normal_punch",
    --     hero = ""
    -- },
    -- 梦境缠绕（帕克大招）
    skill_19 = {
        id = 19,
        rank = 1,
        name = "puck_dream_coil",
        hero = "npc_dota_hero_puck"
    },
    -- 恩赐解脱（幻影刺客被动）
    skill_20 = {
        id = 20,
        rank = 2,
        name = "phantom_assassin_coup_de_grace",
        hero = "npc_dota_hero_phantom_assassin"
    },
    -- 反击螺旋（斧王被动）
    skill_21 = {
        id = 21,
        rank = 3,
        name = "axe_counter_helix",
        hero = "npc_dota_hero_axe"
    },
    -- 牺牲（哈斯卡大招）
    skill_22 = {
        id = 22,
        rank = 2,
        name = "huskar_life_break",
        hero = "npc_dota_hero_huskar"
    },
    -- 狂暴（食尸鬼一技能）
    skill_23 = {
        id = 23,
        rank = 0,
        name = "life_stealer_rage",
        hero = "npc_dota_hero_life_stealer"
    },
    -- 高射火炮（飞机三技能）
    skill_24 = {
        id = 24,
        rank = 4,
        name = "gyrocopter_flak_cannon",
        hero = "npc_dota_hero_gyrocopter"
    },
    -- 月刃（露娜被动）
    skill_25 = {
        id = 25,
        rank = 3,
        name = "luna_moon_glaive",
        hero = "npc_dota_hero_luna"
    },
    -- 神灭斩（莉娜大招）
    skill_26 = {
        id = 26,
        rank = 4,
        name = "lina_laguna_blade",
        hero = "npc_dota_hero_lina"
    },
    -- 寒霜之触（远古冰魄三技能）
    skill_27 = {
        id = 27,
        rank = 3,
        name = "ancient_apparition_chilling_touch",
        hero = "npc_dota_hero_ancient_apparition"
    },
    -- 奥术至尊（拉比克被动）
    skill_28 = {
        id = 28,
        rank = 3,
        name = "rubick_arcane_supremacy",
        hero = "npc_dota_hero_rubick"
    },
    -- 战斗专注（巨魔战将大招）
    skill_29 = {
        id = 29,
        rank = 1,
        name = "troll_warlord_battle_trance",
        hero = "npc_dota_hero_troll_warlord"
    },
    -- 爆头（狙击手被动）
    skill_30 = {
        id = 30,
        rank = 4,
        name = "sniper_headshot",
        hero = "npc_dota_hero_sniper"
    },
    -- 海象神拳（海民三技能）
    skill_31 = {
        id = 31,
        rank = 3,
        name = "tusk_walrus_punch",
        hero = "npc_dota_hero_tusk"
    },
    -- 阎刃（末日被动）
    skill_32 = {
        id = 32,
        rank = 3,
        name = "doom_bringer_infernal_blade",
        hero = "npc_dota_hero_doom_bringer"
    },
    -- 怒意狂击（拍拍被动）
    skill_33 = {
        id = 33,
        rank = 2,
        name = "ursa_fury_swipes",
        hero = "npc_dota_hero_ursa"
    },
    -- 激怒（拍拍大招）
    skill_34 = {
        id = 34,
        rank = 0,
        name = "ursa_enrage",
        hero = "npc_dota_hero_ursa"
    },
    -- 神之力量（斯文大招）
    skill_35 = {
        id = 35,
        rank = 2,
        name = "sven_gods_strength",
        hero = "npc_dota_hero_sven"
    },
    -- 衰退光环（孽主被动）
    skill_36 = {
        id = 36,
        rank = 2,
        name = "abyssal_underlord_atrophy_aura",
        hero = "npc_dota_hero_abyssal_underlord"
    },
    -- 无敌斩（主宰大招）
    skill_37 = {
        id = 37,
        rank = 3,
        name = "juggernaut_omni_slash",
        hero = "npc_dota_hero_juggernaut"
    },
    -- 极度饥渴（育母蜘蛛大招）
    skill_38 = {
        id = 38,
        rank = 2,
        name = "broodmother_insatiable_hunger",
        hero = "npc_dota_hero_broodmother"
    },
    -- 暗影之舞（斯拉克大招）
    skill_39 = {
        id = 39,
        rank = 2,
        name = "slark_shadow_dance",
        hero = "npc_dota_hero_slark"
    },
    -- 暴怒（兽二技能）
    skill_40 = {
        id = 40,
        rank = 2,
        name = "primal_beast_uproar",
        hero = "npc_dota_hero_primal_beast"
    },
    -- 纯洁之锤（全能三技能）
    skill_41 = {
        id = 41,
        rank = 2,
        name = "omniknight_hammer_of_purity",
        hero = "npc_dota_hero_omniknight"
    },
    -- 黑暗飞升（夜魔大招）
    skill_42 = {
        id = 42,
        rank = 2,
        name = "night_stalker_darkness",
        hero = "npc_dota_hero_night_stalker"
    },
    -- 变身（狼人大招）
    skill_43 = {
        id = 43,
        rank = 2,
        name = "lycan_shapeshift",
        hero = "npc_dota_hero_lycan"
    },
    -- 野性驱使（狼人被动）
    skill_44 = {
        id = 44,
        rank = 4,
        name = "lycan_feral_impulse",
        hero = "npc_dota_hero_lycan"
    },
    -- 侵蚀（斯拉达三技能/锚击改版）
    skill_45 = {
        id = 45,
        rank = 3,
        name = "slardar_amplify_damage",
        hero = "npc_dota_hero_slardar"
    },
    -- 灵能之刃（圣堂被动）
    skill_46 = {
        id = 46,
        rank = 3,
        name = "templar_assassin_psi_blades",
        hero = "npc_dota_hero_templar_assassin"
    },
    -- 折光（圣堂一技能）
    skill_47 = {
        id = 47,
        rank = 2,
        name = "templar_assassin_refraction",
        hero = "npc_dota_hero_templar_assassin"
    },
    -- 幻影突袭（幻影刺客一技能）
    skill_48 = {
        id = 48,
        rank = 4,
        name = "phantom_assassin_phantom_strike",
        hero = "npc_dota_hero_phantom_assassin"
    },
    -- 闪烁（敌法师一技能）
    skill_49 = {
        id = 49,
        rank = 3,
        name = "antimage_blink",
        hero = "npc_dota_hero_antimage"
    },
    -- 闪烁（痛苦女王一技能）
    skill_50 = {
        id = 50,
        rank = 2,
        name = "queenofpain_blink",
        hero = "npc_dota_hero_queenofpain"
    },
    -- 分裂箭（美杜莎被动）
    skill_51 = {
        id = 51,
        rank = 2,
        name = "medusa_split_shot",
        hero = "npc_dota_hero_medusa"
    },
    -- 妖术（莱恩二技能）
    skill_52 = {
        id = 52,
        rank = 2,
        name = "lion_voodoo",
        hero = "npc_dota_hero_lion"
    },
    -- 快枪手（琼英碧灵被动）
    skill_53 = {
        id = 53,
        rank = 2,
        name = "muerta_gunslinger",
        hero = "npc_dota_hero_muerta"
    },
    -- 竭心光环（瘟疫法师被动）
    skill_54 = {
        id = 54,
        rank = 3,
        name = "necrolyte_heartstopper_aura",
        hero = "npc_dota_hero_necrolyte"
    },
    -- 折射（幽鬼被动）
    skill_55 = {
        id = 55,
        rank = 1,
        name = "spectre_dispersion",
        hero = "npc_dota_hero_spectre"
    },
    -- 怒拳破（玛西大招）
    skill_56 = {
        id = 56,
        rank = 2,
        name = "marci_unleash",
        hero = "npc_dota_hero_marci"
    },
    -- 风行（风行者三技能）
    skill_57 = {
        id = 57,
        rank = 3,
        name = "windrunner_windrun",
        hero = "npc_dota_hero_windrunner"
    },
    -- 太虚之径（虚无之灵大招）
    skill_58 = {
        id = 58,
        rank = 3,
        name = "void_spirit_astral_step",
        hero = "npc_dota_hero_void_spirit"
    },
    skill_59 = {
        id = 59,
        rank = 3,
        name = "phantom_assassin_fan_of_knives",
        hero = ""
    },
    -- 授予力量（猛犸三技能）
    skill_60 = {
        id = 60,
        rank = 2,
        name = "magnataur_empower",
        hero = "npc_dota_hero_magnataur"
    },
    -- 巨力重击（白牛被动）
    skill_61 = {
        id = 61,
        rank = 2,
        name = "spirit_breaker_greater_bash",
        hero = "npc_dota_hero_spirit_breaker"
    },
    -- 战斗饥渴（斧王二技能）
    skill_62 = {
        id = 62,
        rank = 4,
        name = "axe_battle_hunger",
        hero = "npc_dota_hero_axe"
    },
    -- skill_63 = {
    --     id = 63,
    --     rank = 3,
    --     name = "ability_hero_6",
    --     hero = ""
    -- },
    -- 火焰风暴（孽主一技能）
    skill_64 = {
        id = 64,
        rank = 3,
        name = "abyssal_underlord_firestorm",
        hero = "npc_dota_hero_abyssal_underlord"
    },
    skill_65 = {
        id = 65,
        rank = 3,
        name = "drow_ranger_glacier",
        hero = ""
    },
    -- -- 尸鬼狂怒（噬魂鬼被动）
    -- skill_66 = {
    --     id = 66,
    --     rank = 4,
    --     name = "life_stealer_ghoul_frenzy",
    --     hero = "npc_dota_hero_life_stealer"
    -- },
    -- 锚击（潮汐猎人二技能）
    skill_67 = {
        id = 67,
        rank = 4,
        name = "tidehunter_anchor_smash",
        hero = "npc_dota_hero_tidehunter"
    },
    -- 数箭齐发（卓尔游侠二技能）
    skill_68 = {
        id = 68,
        rank = 4,
        name = "drow_ranger_multishot",
        hero = "npc_dota_hero_drow_ranger"
    },
    -- 无影拳（灰烬之灵一技能）
    skill_69 = {
        id = 69,
        rank = 4,
        name = "ember_spirit_sleight_of_fist",
        hero = "npc_dota_hero_ember_spirit"
    },
    -- 腐烂（屠夫二技能）
    skill_70 = {
        id = 70,
        rank = 2,
        name = "pudge_rot",
        hero = "npc_dota_hero_pudge"
    },
    -- 肢解（屠夫大招）
    skill_71 = {
        id = 71,
        rank = 4,
        name = "pudge_dismember",
        hero = "npc_dota_hero_pudge"
    },
    -- 法术反制（敌法师三技能）
    -- skill_72 = {
    --     id = 72,
    --     rank = 4,
    --     name = "antimage_counterspell",
    --     hero = "npc_dota_hero_antimage"
    -- },
    -- 腐蚀皮肤（冥界亚龙被动）
    skill_73 = {
        id = 73,
        rank = 4,
        name = "viper_corrosive_skin",
        hero = "npc_dota_hero_viper"
    },
    -- 狂战士之怒（巨魔战将被动）
    skill_74 = {
        id = 74,
        rank = 4,
        name = "troll_warlord_fervor",
        hero = "npc_dota_hero_troll_warlord"
    },
    -- 魔化（恐怖利刃大招）
    skill_75 = {
        id = 75,
        rank = 2,
        name = "terrorblade_metamorphosis",
        hero = "npc_dota_hero_terrorblade"
    },
    -- 连击（编织者被动）
    skill_76 = {
        id = 76,
        rank = 4,
        name = "weaver_geminate_attack",
        hero = "npc_dota_hero_weaver"
    },
    -- 长大（小小大招）
    skill_77 = {
        id = 77,
        rank = 4,
        name = "tiny_grow",
        hero = "npc_dota_hero_tiny"
    },
    -- 炽魂（莉娜被动）
    skill_78 = {
        id = 78,
        rank = 3,
        name = "lina_fiery_soul",
        hero = "npc_dota_hero_lina"
    },
    -- 麻痹之咬（育母蜘蛛被动）
    skill_79 = {
        id = 79,
        rank = 4,
        name = "broodmother_incapacitating_bite",
        hero = "npc_dota_hero_broodmother"
    },
    -- 黑暗契约（斯拉克一技能）
    skill_80 = {
        id = 80,
        rank = 4,
        name = "slark_dark_pact",
        hero = "npc_dota_hero_slark"
    },
    -- 决斗（军团指挥官大招）
    skill_81 = {
        id = 81,
        rank = 2,
        name = "legion_commander_duel",
        hero = "npc_dota_hero_legion_commander"
    },
    -- 勇气之霎（军团指挥官被动）
    skill_82 = {
        id = 82,
        rank = 4,
        name = "legion_commander_moment_of_courage",
        hero = "npc_dota_hero_legion_commander"
    },
    -- 反伤（半人马战行者被动）
    skill_83 = {
        id = 83,
        rank = 2,
        name = "centaur_return",
        hero = "npc_dota_hero_centaur"
    },
    -- 双刃剑（半人马战行者二技能）
    skill_84 = {
        id = 84,
        rank = 4,
        name = "centaur_double_edge",
        hero = "npc_dota_hero_centaur"
    },
    -- 潮汐使者（昆卡被动）
    skill_85 = {
        id = 85,
        rank = 2,
        name = "kunkka_tidebringer",
        hero = "npc_dota_hero_kunkka"
    },
    -- 熠熠生辉（破晓辰星被动）
    skill_86 = {
        id = 86,
        rank = 4,
        name = "dawnbreaker_luminosity",
        hero = "npc_dota_hero_dawnbreaker"
    },
    -- 踏（獸二技能）
    skill_87 = {
        id = 87,
        rank = 4,
        name = "primal_beast_trample",
        hero = "npc_dota_hero_primal_beast"
    },
    -- skill_88 = {
    --     id = 88,
    --     rank = 4,
    --     name = "skeleton_king_reincarnation",
    --     hero = ""
    -- },
    -- 守卫冲刺（斯拉达一技能）
    skill_89 = {
        id = 89,
        rank = 4,
        name = "slardar_sprint",
        hero = "npc_dota_hero_slardar"
    },
    -- 钢毛后背（钢背兽被动）
    skill_90 = {
        id = 90,
        rank = 4,
        name = "bristleback_bristleback",
        hero = "npc_dota_hero_bristleback"
    },
    -- 刺针扫射（钢背兽一技能）
    skill_91 = {
        id = 91,
        rank = 4,
        name = "bristleback_quill_spray",
        hero = "npc_dota_hero_bristleback"
    },
    -- 护身甲盾（玛尔斯被动）
    skill_92 = {
        id = 92,
        rank = 1,
        name = "mars_bulwark",
        hero = "npc_dota_hero_mars"
    },
    -- 狂战士之吼（斧王一技能）
    skill_93 = {
        id = 93,
        rank = 3,
        name = "axe_berserkers_call",
        hero = "npc_dota_hero_axe"
    },
    -- -- 暗夜猎影（夜魔被动）
    -- skill_94 = {
    --     id = 94,
    --     rank = 4,
    --     name = "night_stalker_hunter_in_the_night",
    --     hero = "npc_dota_hero_night_stalker"
    -- },
    -- 混沌一击（混沌骑士被动）
    skill_95 = {
        id = 95,
        rank = 3,
        name = "chaos_knight_chaos_strike",
        hero = "npc_dota_hero_chaos_knight"
    },
    -- 实相裂隙（混沌骑士二技能）
    skill_96 = {
        id = 96,
        rank = 4,
        name = "chaos_knight_reality_rift",
        hero = "npc_dota_hero_chaos_knight"
    },
    -- 威吓（裂魂人二技能）
    skill_97 = {
        id = 97,
        rank = 3,
        name = "spirit_breaker_bulldoze",
        hero = "npc_dota_hero_spirit_breaker"
    },
    -- 剑舞（主宰被动）
    skill_98 = {
        id = 98,
        rank = 4,
        name = "juggernaut_blade_dance",
        hero = "npc_dota_hero_juggernaut"
    },
    -- 扫射（克林克兹二技能）
    skill_99 = {
        id = 99,
        rank = 4,
        name = "clinkz_strafe",
        hero = "npc_dota_hero_clinkz"
    },
    -- 超强力量（熊战士二技能）
    skill_100 = {
        id = 100,
        rank = 4,
        name = "ursa_overpower",
        hero = "npc_dota_hero_ursa"
    },
    -- 忍术（赏金猎人被动）
    skill_101 = {
        id = 101,
        rank = 4,
        name = "bounty_hunter_jinada",
        hero = "npc_dota_hero_bounty_hunter"
    },
    -- 月之祝福（露娜被动）
    skill_102 = {
        id = 102,
        rank = 2,
        name = "luna_lunar_orbit",
        hero = "npc_dota_hero_luna"
    },
    -- 如意棒法（齐天大圣被动）
    skill_103 = {
        id = 103,
        rank = 3,
        name = "monkey_king_jingu_mastery",
        hero = "npc_dota_hero_monkey_king"
    },
    -- 寒冬诅咒（寒冬飞龙大招）
    skill_104 = {
        id = 104,
        rank = 4,
        name = "winter_wyvern_winters_curse",
        hero = "npc_dota_hero_winter_wyvern"
    },
    -- 冰霜魔盾（巫妖三技能）
    skill_105 = {
        id = 105,
        rank = 3,
        name = "lich_frost_shield",
        hero = "npc_dota_hero_lich"
    },
    -- 推进（魅惑魔女三技能）
    skill_106 = {
        id = 106,
        rank = 2,
        name = "enchantress_impetus",
        hero = "npc_dota_hero_enchantress"
    },
    -- 不可侵犯（魅惑魔女被动）
    skill_107 = {
        id = 107,
        rank = 3,
        name = "enchantress_untouchable",
        hero = "npc_dota_hero_enchantress"
    },
    -- 魔霭诅咒（亚巴顿被动）
    skill_108 = {
        id = 108,
        rank = 4,
        name = "abaddon_frostmourne",
        hero = "npc_dota_hero_abaddon"
    },
    --荒芜（移除）
    -- skill_109 = {
    --     id = 109,
    --     rank = 0,
    --     name = "spectre_desolate",
    --     hero = ""
    -- },
    -- 驱使恶灵（死亡先知大招）
    skill_110 = {
        id = 110,
        rank = 3,
        name = "death_prophet_exorcism",
        hero = "npc_dota_hero_death_prophet"
    },
    -- 护主（玛西三技能）
    skill_111 = {
        id = 111,
        rank = 4,
        name = "marci_bodyguard",
        hero = "npc_dota_hero_marci"
    },
    -- 集中火力（风行者三技能）
    skill_112 = {
        id = 112,
        rank = 4,
        name = "windrunner_focusfire",
        hero = "npc_dota_hero_windrunner"
    },
    -- 幸运一击（滚滚三技能）
    skill_113 = {
        id = 113,
        rank = 4,
        name = "pangolier_lucky_shot",
        hero = "npc_dota_hero_pangolier"
    },
    -- 黄泉颤抖（维萨吉一技能）
    skill_114 = {
        id = 114,
        rank = 4,
        name = "visage_grave_chill",
        hero = "npc_dota_hero_visage"
    },
    -- 醉拳（酒仙三技能）
    skill_115 = {
        id = 115,
        rank = 4,
        name = "brewmaster_drunken_brawler",
        hero = "npc_dota_hero_brewmaster"
    },
    -- 古龙形态（龙骑士大招）
    skill_116 = {
        id = 116,
        rank = 1,
        name = "dragon_knight_elder_dragon_form",
        hero = "npc_dota_hero_dragon_knight"
    },
    -- 追踪术（赏金猎人大招）
    skill_117 = {
        id = 117,
        rank = 3,
        name = "bounty_hunter_track",
        hero = "npc_dota_hero_bounty_hunter"
    },
    -- 强化图腾（撼地者二技能）
    skill_118 = {
        id = 118,
        rank = 3,
        name = "earthshaker_enchant_totem",
        hero = "npc_dota_hero_earthshaker"
    },
    -- skill_119 = {
    --     id = 119,
    --     rank = 3,
    --     name = "",
    --     hero = ""
    -- },
    -- 疯狂生长（树精卫士大招）
    skill_120 = {
        id = 120,
        rank = 2,
        name = "treant_overgrowth",
        hero = "npc_dota_hero_treant"
    },
    -- 毒性攻击（冥界亚龙一技能）
    skill_121 = {
        id = 121,
        rank = 3,
        name = "viper_poison_attack",
        hero = "npc_dota_hero_viper"
    },
    -- 血怒（嗜血狂魔一技能）
    skill_122 = {
        id = 122,
        rank = 3,
        name = "bloodseeker_bloodrage",
        hero = "npc_dota_hero_bloodseeker"
    },
    -- 剑刃风暴（主宰一技能）
    skill_123 = {
        id = 123,
        rank = 2,
        name = "juggernaut_blade_fury",
        hero = "npc_dota_hero_juggernaut"
    },
    -- 波浪形态（变体精灵一技能）
    skill_124 = {
        id = 124,
        rank = 3,
        name = "morphling_waveform",
        hero = "npc_dota_hero_morphling"
    },
    -- 脉冲新星（拉席克大招）
    skill_125 = {
        id = 125,
        rank = 3,
        name = "leshrac_pulse_nova",
        hero = "npc_dota_hero_leshrac"
    },
    -- 霹雳铁手（电炎绝手二技能）
    skill_126 = {
        id = 126,
        rank = 3,
        name = "snapfire_lil_shredder",
        hero = "npc_dota_hero_snapfire"
    },
    -- 奥术天球（殁境神蚀者一技能）
    skill_127 = {
        id = 127,
        rank = 0,
        name = "obsidian_destroyer_arcane_orb",
        hero = "npc_dota_hero_obsidian_destroyer"
    },
    -- skill_128 = {
    --     id = 128,
    --     rank = 3,
    --     name = "obsidian_destroyer_equilibrium",
    --     hero = "npc_dota_hero_obsidian_destroyer"
    -- },
    -- 焦渴（嗜血狂魔被动）
    skill_129 = {
        id = 129,
        rank = 2,
        name = "bloodseeker_thirst",
        hero = "npc_dota_hero_bloodseeker"
    },
    -- 风暴之眼（剃刀大招）
    skill_130 = {
        id = 130,
        rank = 3,
        name = "razor_eye_of_the_storm",
        hero = "npc_dota_hero_razor"
    },
    -- 薄葬（戴泽二技能）
    skill_131 = {
        id = 131,
        rank = 2,
        name = "dazzle_shallow_grave",
        hero = "npc_dota_hero_dazzle"
    },
    -- 感染（噬魂鬼大招）
    skill_132 = {
        id = 132,
        rank = 3,
        name = "life_stealer_infest",
        hero = "npc_dota_hero_life_stealer"
    },
    -- 暗杀（狙击手大招）
    skill_133 = {
        id = 133,
        rank = 4,
        name = "sniper_assassinate",
        hero = "npc_dota_hero_sniper"
    },
    -- 能量齿轮（发条技师二技能）
    skill_134 = {
        id = 134,
        rank = 4,
        name = "rattletrap_power_cogs",
        hero = "npc_dota_hero_rattletrap"
    },
    -- 寄生种子（树精卫士二技能）
    skill_135 = {
        id = 135,
        rank = 3,
        name = "treant_leech_seed",
        hero = "npc_dota_hero_treant"
    },
    -- 星破天惊（破晓辰星一技能）
    skill_136 = {
        id = 136,
        rank = 4,
        name = "dawnbreaker_fire_wreath",
        hero = "npc_dota_hero_dawnbreaker"
    },
    -- 嗜血术（食人魔魔法师三技能）
    skill_137 = {
        id = 137,
        rank = 4,
        name = "ogre_magi_bloodlust",
        hero = "npc_dota_hero_ogre_magi"
    },
    -- 赎罪（陈一技能）
    skill_138 = {
        id = 138,
        rank = 4,
        name = "chen_penitence",
        hero = "npc_dota_hero_chen"
    },
    -- 闪烁突袭（力丸二技能）
    skill_139 = {
        id = 139,
        rank = 4,
        name = "riki_blink_strike",
        hero = "npc_dota_hero_riki"
    },
    -- 风暴涌动（剃刀被动）
    skill_140 = {
        id = 140,
        rank = 4,
        name = "razor_storm_surge",
        hero = "npc_dota_hero_razor"
    },
    -- 闪电风暴（拉席克三技能）
    skill_141 = {
        id = 141,
        rank = 4,
        name = "leshrac_lightning_storm",
        hero = "npc_dota_hero_leshrac"
    },
    -- 恶魔敕令（拉席克一技能）
    skill_142 = {
        id = 142,
        rank = 3,
        name = "leshrac_diabolic_edict",
        hero = "npc_dota_hero_leshrac"
    },
    -- 毒刺（剧毒术士被动）
    -- skill_143 = {
    --     id = 143,
    --     rank = 4,
    --     name = "venomancer_poison_sting",
    --     hero = "npc_dota_hero_venomancer"
    -- },
    -- 粘性燃油（蝙蝠骑士一技能）
    skill_144 = {
        id = 144,
        rank = 4,
        name = "batrider_sticky_napalm",
        hero = "npc_dota_hero_batrider"
    },
    -- 棒击大地（齐天大圣一技能）
    skill_145 = {
        id = 145,
        rank = 4,
        name = "monkey_king_boundless_strike",
        hero = "npc_dota_hero_monkey_king"
    },
    -- skill_146 = {
    --     id = 146,
    --     rank = 1,
    --     name = "",
    --     hero = ""
    -- },
    -- 恐怖波动（复仇之魂二技能）
    skill_147 = {
        id = 147,
        rank = 4,
        name = "vengefulspirit_wave_of_terror",
        hero = "npc_dota_hero_vengefulspirit"
    },
    -- 静电连接（剃刀二技能）
    skill_148 = {
        id = 148,
        rank = 4,
        name = "razor_static_link",
        hero = "npc_dota_hero_razor"
    },
    -- 火焰爆轰（食人魔魔法师一技能）
    skill_149 = {
        id = 149,
        rank = 4,
        name = "ogre_magi_fireblast",
        hero = "npc_dota_hero_ogre_magi"
    },
    -- 突袭（斯拉克二技能）
    skill_150 = {
        id = 150,
        rank = 4,
        name = "slark_pounce",
        hero = "npc_dota_hero_slark"
    },
    -- 腐朽（不朽尸王一技能）
    skill_151 = {
        id = 151,
        rank = 4,
        name = "undying_decay",
        hero = "npc_dota_hero_undying",
    },
    -- 死亡旋风（伐木机一技能）
    skill_152 = {
        id = 152,
        rank = 3,
        name = "shredder_whirling_death",
        hero = "npc_dota_hero_shredder",
    },
    -- 洗礼（全能骑士一技能）
    skill_153 = {
        id = 153,
        rank = 4,
        name = "omniknight_purification",
        hero = "npc_dota_hero_omniknight"
    },
    -- 压倒性优势（军团指挥官二技能）
    skill_154 = {
        id = 154,
        rank = 4,
        name = "legion_commander_overwhelming_odds",
        hero = "npc_dota_hero_legion_commander"
    },
    -- 强攻（军团指挥官三技能）
    skill_155 = {
        id = 155,
        rank = 4,
        name = "legion_commander_press_the_attack",
        hero = "npc_dota_hero_legion_commander"
    },
    -- 本命一击（冥魂大帝被动）
    skill_156 = {
        id = 156,
        rank = 4,
        name = "skeleton_king_mortal_strike",
        hero = "npc_dota_hero_skeleton_king"
    },
    -- 弹幕冲击（发条技师一技能）
    skill_157 = {
        id = 157,
        rank = 3,
        name = "rattletrap_battery_assault",
        hero = "npc_dota_hero_rattletrap"
    },
    -- 心炎（哈斯卡二技能）
    skill_158 = {
        id = 158,
        rank = 4,
        name = "huskar_inner_fire",
        hero = "npc_dota_hero_huskar"
    },
    -- 沸血之矛（哈斯卡三技能）
    skill_159 = {
        id = 159,
        rank = 3,
        name = "huskar_burning_spear",
        hero = "npc_dota_hero_huskar"
    },
    -- 肉钩（屠夫一技能）
    skill_160 = {
        id = 160,
        rank = 4,
        name = "pudge_meat_hook",
        hero = "npc_dota_hero_pudge"
    },
    -- 巨力挥舞（斯温被动）
    skill_161 = {
        id = 161,
        rank = 4,
        name = "sven_great_cleave",
        hero = "npc_dota_hero_sven"
    },
    -- 焦土（末日使者二技能）
    skill_162 = {
        id = 162,
        rank = 4,
        name = "doom_bringer_scorched_earth",
        hero = "npc_dota_hero_doom_bringer"
    },
    -- 活体护甲（树精卫士三技能）
    skill_163 = {
        id = 163,
        rank = 4,
        name = "treant_living_armor",
        hero = "npc_dota_hero_treant"
    },
    -- 海妖外壳（潮汐猎人被动）
    skill_164 = {
        id = 164,
        rank = 2,
        name = "tidehunter_kraken_shell",
        hero = "npc_dota_hero_tidehunter"
    },
    -- 奔腾（黑暗贤者二技能）
    skill_165 = {
        id = 165,
        rank = 4,
        name = "dark_seer_surge",
        hero = "npc_dota_hero_dark_seer"
    },
    -- 腐蚀兵械（炼金术士被动）
    skill_166 = {
        id = 166,
        rank = 4,
        name = "alchemist_corrosive_weaponry",
        hero = "npc_dota_hero_alchemist"
    },
    -- 剧毒之触（戴泽一技能）
    skill_167 = {
        id = 167,
        rank = 4,
        name = "dazzle_poison_touch",
        hero = "npc_dota_hero_dazzle"
    },
    -- 神之谴戒（玛尔斯一技能）
    skill_168 = {
        id = 168,
        rank = 4,
        name = "mars_gods_rebuke",
        hero = "npc_dota_hero_mars"
    },
    -- 治疗守卫（主宰三技能）
    skill_169 = {
        id = 169,
        rank = 4,
        name = "juggernaut_healing_ward",
        hero = "npc_dota_hero_juggernaut"
    },
    -- 灼热之箭（克林克兹一技能）
    skill_170 = {
        id = 170,
        rank = 4,
        name = "clinkz_searing_arrows",
        hero = "npc_dota_hero_clinkz"
    },
    -- skill_171 = {
    --     id = 171,
    --     rank = 4,
    --     name = "terrorblade_reflection",
    --     hero = ""
    -- },
    -- 海妖之刃（斯拉克三技能）
    skill_172 = {
        id = 172,
        rank = 4,
        name = "slark_saltwater_shiv",
        hero = "npc_dota_hero_slark"
    },
    -- 等离子场（剃刀一技能）
    skill_173 = {
        id = 173,
        rank = 4,
        name = "razor_plasma_field",
        hero = "npc_dota_hero_razor"
    },
    -- 巫毒疗法（巫医三技能）
    skill_174 = {
        id = 174,
        rank = 4,
        name = "witch_doctor_voodoo_restoration",
        hero = "npc_dota_hero_witch_doctor"
    },
    -- 暗言术（术士一技能）
    -- skill_175 = {
    --     id = 175,
    --     rank = 4,
    --     name = "warlock_shadow_word",
    --     hero = "npc_dota_hero_warlock"
    -- },
    -- 自然之助（魅惑魔女二技能）
    skill_176 = {
        id = 176,
        rank = 4,
        name = "enchantress_natures_attendants",
        hero = "npc_dota_hero_enchantress"
    },
    -- 幽魂护罩（瘟疫法师二技能）
    skill_177 = {
        id = 177,
        rank = 3,
        name = "necrolyte_ghost_shroud",
        hero = "npc_dota_hero_necrolyte"
    },
    -- 活性护甲（伐木机被动）
    skill_178 = {
        id = 178,
        rank = 3,
        name = "shredder_reactive_armor",
        hero = "npc_dota_hero_shredder"
    },
    skill_179 = {
        id = 179,
        rank = 3,
        name = "tusk_snowball",
        hero = "npc_dota_hero_tusk",
        hide_ability = {"tusk_launch_snowball"}
    },
    -- 殉道（全能骑士三技能）
    skill_180 = {
        id = 180,
        rank = 2,
        name = "omniknight_martyr",
        hero = "npc_dota_hero_omniknight"
    },
    -- 余震（撼地者被动）
    skill_181 = {
        id = 181,
        rank = 2,
        name = "earthshaker_aftershock",
        hero = "npc_dota_hero_earthshaker"
    },
    -- 风暴之锤（斯温一技能）
    skill_182 = {
        id = 182,
        rank = 3,
        name = "sven_storm_bolt",
        hero = "npc_dota_hero_sven"
    },
    -- 末日（末日使者大招）
    skill_183 = {
        id = 183,
        rank = 2,
        name = "doom_bringer_doom",
        hero = "npc_dota_hero_doom_bringer"
    },
    -- skill_184 = {
    --     id = 184,
    --     rank = 3,
    --     name = "undying_decay",
    -- },
    -- 暗影冲刺（裂魂人一技能）
    skill_185 = {
        id = 185,
        rank = 4,
        name = "spirit_breaker_charge_of_darkness",
        hero = "npc_dota_hero_spirit_breaker"
    },
    -- 蝮蛇突袭（冥界亚龙大招）
    skill_186 = {
        id = 186,
        rank = 4,
        name = "viper_viper_strike",
        hero = "npc_dota_hero_viper"
    },
    -- 霜冻之箭（卓尔游侠一技能）
    skill_187 = {
        id = 187,
        rank = 3,
        name = "drow_ranger_frost_arrows",
        hero = "npc_dota_hero_drow_ranger"
    },
    -- 跳跃（米拉娜二技能）
    skill_188 = {
        id = 188,
        rank = 3,
        name = "mirana_leap",
        hero = "npc_dota_hero_mirana"
    },
    -- skill_189 = {
    --     id = 189,
    --     rank = 3,
    --     name = "bounty_hunter_track",
    -- },
    skill_190 = {
        id = 190,
        rank = 3,
        name = "ancient_apparition_ice_blast",
        hero = "npc_dota_hero_ancient_apparition",
        hide_ability = { "ancient_apparition_ice_blast_release" }
    },
    -- 时间漫游（虚空假面一技能）
    skill_191 = {
        id = 191,
        rank = 3,
        name = "faceless_void_time_walk",
        hero = "npc_dota_hero_faceless_void"
    },
    -- 反应装甲（工程师三技能）
    skill_192 = {
        id = 192,
        rank = 2,
        name = "techies_reactive_tazer",
        hero = "npc_dota_hero_techies"
    },
    -- 化学狂暴（炼金术士大招）
    skill_193 = {
        id = 193,
        rank = 2,
        name = "alchemist_chemical_rage",
        hero = "npc_dota_hero_alchemist"
    },
    -- 自然秩序（上古巨神被动）
    skill_194 = {
        id = 194,
        rank = 1,
        name = "elder_titan_natural_order",
        hero = "npc_dota_hero_elder_titan"
    },
    -- 狂战士之血（哈斯卡被动）
    skill_195 = {
        id = 195,
        rank = 3,
        name = "huskar_berserkers_blood",
        hero = "npc_dota_hero_huskar"
    },
    --授予力量
    -- skill_196 = {
    --     id = 196,
    --     rank = 3,
    --     name = "magnataur_empower",
    --     hero = "npc_dota_hero_magnataur"
    -- },
    -- 火焰气息（龙骑士一技能）
    skill_197 = {
        id = 197,
        rank = 4,
        name = "dragon_knight_breathe_fire",
        hero = "npc_dota_hero_dragon_knight"
    },
    -- 神龙摆尾（龙骑士二技能）
    skill_198 = {
        id = 198,
        rank = 4,
        name = "dragon_knight_dragon_tail",
        hero = "npc_dota_hero_dragon_knight"
    },
    -- 时间结界（虚空假面大招）
    skill_199 = {
        id = 199,
        rank = 3,
        name = "faceless_void_chronosphere",
        hero = "npc_dota_hero_faceless_void"
    },
    -- 瞄准（狙击手三技能，已从英雄绑定移除）
    skill_200 = {
        id = 200,
        rank = 1,
        name = "sniper_take_aim",
        hero = ""
    },
    -- 幽鬼之刃（幽鬼一技能）
    skill_201 = {
        id = 201,
        rank = 4,
        name = "spectre_spectral_dagger",
        hero = "npc_dota_hero_spectre"
    },
    -- 烈焰焚身（杰奇洛大招）
    skill_202 = {
        id = 202,
        rank = 4,
        name = "jakiro_macropyre",
        hero = "npc_dota_hero_jakiro"
    },
    -- 吸魂巫术（死亡先知二技能）
    skill_203 = {
        id = 203,
        rank = 4,
        name = "death_prophet_spirit_siphon",
        hero = "npc_dota_hero_death_prophet"
    },
    -- 发芽（先知一技能）
    skill_204 = {
        id = 204,
        rank = 4,
        name = "furion_sprout",
        hero = "npc_dota_hero_furion"
    },
    -- 变体攻击（水人大招衍生/敏捷）
    skill_205 = {
        id = 205,
        rank = 4,
        name = "morphling_adaptive_strike_agi",
        hero = "npc_dota_hero_morphling"
    },
    -- 黑洞（谜团大招）
    skill_206 = {
        id = 206,
        rank = 2,
        name = "enigma_black_hole",
        hero = "npc_dota_hero_enigma"
    },
    -- 两极反转（猛犸大招）
    skill_207 = {
        id = 207,
        rank = 3,
        name = "magnataur_reverse_polarity",
        hero = "npc_dota_hero_magnataur"
    },
    -- 獠牙冲刺（猛犸二技能）
    skill_208 = {
        id = 208,
        rank = 4,
        name = "magnataur_skewer",
        hero = "npc_dota_hero_magnataur"
    },
    -- 掘地穿刺（沙王一技能）
    skill_209 = {
        id = 209,
        rank = 3,
        name = "sandking_burrowstrike",
        hero = "npc_dota_hero_sand_king"
    },
    -- skill_210 = {
    --     id = 210,
    --     rank = 3,
    --     name = "puck_phase_shift",
    --     hero = ""
    -- },
    -- 冰封禁制（水晶室女二技能）
    skill_211 = {
        id = 211,
        rank = 4,
        name = "crystal_maiden_frostbite",
        hero = "npc_dota_hero_crystal_maiden"
    },
    -- 极寒领域（水晶室女大招）
    skill_212 = {
        id = 212,
        rank = 3,
        name = "crystal_maiden_freezing_field",
        hero = "npc_dota_hero_crystal_maiden"
    },
    -- skill_213 = {
    --     id = 213,
    --     rank = 4,
    --     name = "pangolier_gyroshell",
    --     hero = ""
    -- },
    -- 山崩（小小一技能）
    skill_214 = {
        id = 214,
        rank = 3,
        name = "tiny_avalanche",
        hero = "npc_dota_hero_tiny"
    },
    -- 捶（兽大招）
    skill_215 = {
        id = 215,
        rank = 3,
        name = "primal_beast_pulverize",
        hero = "npc_dota_hero_primal_beast"
    },
    -- 战神迅矛（马尔斯一技能）
    skill_216 = {
        id = 216,
        rank = 3,
        name = "mars_spear",
        hero = "npc_dota_hero_mars"
    },
    -- 热血竞技场（马尔斯大招）
    skill_217 = {
        id = 217,
        rank = 3,
        name = "mars_arena_of_blood",
        hero = "npc_dota_hero_mars"
    },
    -- 战意（刚背兽大招）
    skill_218 = {
        id = 218,
        rank = 3,
        name = "bristleback_warpath",
        hero = "npc_dota_hero_bristleback"
    },
    -- 沟壑（小牛一技能）
    skill_219 = {
        id = 219,
        rank = 4,
        name = "earthshaker_fissure",
        hero = "npc_dota_hero_earthshaker"
    },
    -- 邪恶净化（暗影恶魔大招）
    skill_220 = {
        id = 220,
        rank = 3,
        name = "shadow_demon_demonic_purge",
        hero = "npc_dota_hero_shadow_demon"
    },
    -- 燃烧枷锁（蝙蝠骑士大招）
    skill_221 = {
        id = 221,
        rank = 4,
        name = "batrider_flaming_lasso",
        hero = "npc_dota_hero_batrider"
    },
    -- 凤凰冲击（凤凰一技能）
    skill_222 = {
        id = 222,
        rank = 4,
        name = "phoenix_icarus_dive",
        hero = "npc_dota_hero_phoenix",
        hide_ability = {"phoenix_icarus_dive_stop"}
    },
    -- skill_223 = {
    --     id = 223,
    --     rank = 4,
    --     name = "",
    --     hero = ""
    -- },
    -- skill_224 = {
    --     id = 224,
    --     rank = 3,
    --     name = "phoenix_supernova",
    --     hero = "npc_dota_hero_phoenix"
    -- },
    -- 爆栗出击（小松鼠一技能）
    -- skill_225 = {
    --     id = 225,
    --     rank = 4,
    --     name = "hoodwink_acorn_shot",
    --     hero = "npc_dota_hero_hoodwink"
    -- },
    -- 奥术箭（天怒一技能）
    skill_226 = {
        id = 226,
        rank = 4,
        name = "skywrath_mage_arcane_bolt",
        hero = "npc_dota_hero_skywrath_mage"
    },
    -- 震荡光弹（天怒二技能）
    skill_227 = {
        id = 227,
        rank = 4,
        name = "skywrath_mage_concussive_shot",
        hero = "npc_dota_hero_skywrath_mage"
    },
    -- 上古封印（天怒三技能）
    skill_228 = {
        id = 228,
        rank = 4,
        name = "skywrath_mage_ancient_seal",
        hero = "npc_dota_hero_skywrath_mage"
    },
    -- 神秘之耀（天怒大招）
    skill_229 = {
        id = 229,
        rank = 3,
        name = "skywrath_mage_mystic_flare",
        hero = "npc_dota_hero_skywrath_mage"
    },
    -- 羁绊（艾欧一技能）
    skill_230 = {
        id = 230,
        rank = 4,
        name = "wisp_tether",
        hero = "npc_dota_hero_wisp",
        hide_ability = {"wisp_tether_break"}
    },
    -- 过载（艾欧二技能）
    skill_231 = {
        id = 231,
        rank = 4,
        name = "wisp_overcharge",
        hero = "npc_dota_hero_wisp"
    },
    -- 割裂（血魔大招）
    skill_232 = {
        id = 232,
        rank = 4,
        name = "bloodseeker_rupture",
        hero = "npc_dota_hero_bloodseeker"
    },
    -- 伤残恐惧（夜魔二技能）
    skill_233 = {
        id = 233,
        rank = 4,
        name = "night_stalker_crippling_fear",
        hero = "npc_dota_hero_night_stalker"
    },
    -- 极寒之拥（冰龙二技能）
    skill_234 = {
        id = 234,
        rank = 3,
        name = "winter_wyvern_cold_embrace",
        hero = "npc_dota_hero_winter_wyvern"
    },
    -- 幽冥爆轰（骨法一技能）
    skill_235 = {
        id = 235,
        rank = 4,
        name = "pugna_nether_blast",
        hero = "npc_dota_hero_pugna"
    },
    -- 衰老（骨法二技能）
    skill_236 = {
        id = 236,
        rank = 2,
        name = "pugna_decrepify",
        hero = "npc_dota_hero_pugna"
    },
    -- 裂地沟壑（大牛大招）
    skill_237 = {
        id = 237,
        rank = 3,
        name = "elder_titan_earth_splitter",
        hero = "npc_dota_hero_elder_titan"
    },
    -- 守护天使（全能大招）
    skill_238 = {
        id = 238,
        rank = 3,
        name = "omniknight_guardian_angel",
        hero = "npc_dota_hero_omniknight"
    },
    -- 淘汰之刃（斧王大招）
    skill_239 = {
        id = 239,
        rank = 4,
        name = "axe_culling_blade",
        hero = "npc_dota_hero_axe"
    },
    -- 虚张声势（滚滚一技能）
    skill_240 = {
        id = 240,
        rank = 4,
        name = "pangolier_swashbuckle",
        hero = "npc_dota_hero_pangolier"
    },
    -- 甲盾冲击（滚滚二技能）
    skill_241 = {
        id = 241,
        rank = 4,
        name = "pangolier_shield_crash",
        hero = "npc_dota_hero_pangolier"
    },
    -- 球状闪电（蓝猫大招）
    skill_242 = {
        id = 242,
        rank = 1,
        name = "storm_spirit_ball_lightning",
        hero = "npc_dota_hero_storm_spirit"
    },
    -- 绝杀秘技（力丸三技能）
    skill_243 = {
        id = 243,
        rank = 3,
        name = "riki_tricks_of_the_trade",
        hero = "npc_dota_hero_riki"
    },
    -- 魂之挽歌（影魔大招）
    skill_244 = {
        id = 244,
        rank = 4,
        name = "nevermore_requiem",
        hero = "npc_dota_hero_nevermore"
    },
    -- 魔王降临（影魔被动）
    skill_245 = {
        id = 245,
        rank = 4,
        name = "nevermore_dark_lord",
        hero = "npc_dota_hero_nevermore"
    },
    -- 死神镰刀（瘟疫法师大招）
    skill_246 = {
        id = 246,
        rank = 3,
        name = "necrolyte_reapers_scythe",
        hero = "npc_dota_hero_necrolyte"
    },
    -- 死亡脉冲（瘟疫法师一技能）
    skill_247 = {
        id = 247,
        rank = 4,
        name = "necrolyte_death_pulse",
        hero = "npc_dota_hero_necrolyte"
    },
    -- 酸性喷雾（炼金一技能）
    skill_248 = {
        id = 248,
        rank = 4,
        name = "alchemist_acid_spray",
        hero = "npc_dota_hero_alchemist"
    },
    -- 群星风暴（白虎二技能）
    skill_249 = {
        id = 249,
        rank = 4,
        name = "mirana_starfall",
        hero = "npc_dota_hero_mirana"
    },
    -- 月神之箭（白虎一技能）
    skill_250 = {
        id = 250,
        rank = 4,
        name = "mirana_arrow",
        hero = "npc_dota_hero_mirana"
    },
    -- 法力损毁（敌法被动）
    skill_251 = {
        id = 251,
        rank = 4,
        name = "antimage_mana_break",
        hero = "npc_dota_hero_antimage"
    },
    -- 法力虚空（敌法大招）
    skill_252 = {
        id = 252,
        rank = 4,
        name = "antimage_mana_void",
        hero = "npc_dota_hero_antimage"
    },
    -- 命运敕令（神谕二技能）
    skill_253 = {
        id = 253,
        rank = 3,
        name = "oracle_fates_edict",
        hero = "npc_dota_hero_oracle"
    },
    -- 涤罪之焰（神谕三技能）
    skill_254 = {
        id = 254,
        rank = 4,
        name = "oracle_purifying_flames",
        hero = "npc_dota_hero_oracle"
    },
    -- 超声冲击波（女王大招）
    skill_255 = {
        id = 255,
        rank = 3,
        name = "queenofpain_sonic_wave",
        hero = "npc_dota_hero_queenofpain"
    },
    -- 痛苦尖叫（女王二技能）
    skill_256 = {
        id = 256,
        rank = 4,
        name = "queenofpain_scream_of_pain",
        hero = "npc_dota_hero_queenofpain"
    },
    -- 穿刺（莱恩一技能）
    skill_257 = {
        id = 257,
        rank = 4,
        name = "lion_impale",
        hero = "npc_dota_hero_lion"
    },
    -- 离子外壳（黑暗贤者二技能）
    skill_258 = {
        id = 258,
        rank = 4,
        name = "dark_seer_ion_shell",
        hero = "npc_dota_hero_dark_seer"
    },
    -- 妖术（暗影萨满二技能）
    skill_259 = {
        id = 259,
        rank = 2,
        name = "shadow_shaman_voodoo",
        hero = "npc_dota_hero_shadow_shaman"
    },
    -- 枷锁（暗影萨满三技能）
    skill_260 = {
        id = 260,
        rank = 4,
        name = "shadow_shaman_shackles",
        hero = "npc_dota_hero_shadow_shaman"
    },
    -- 散播（暗影恶魔二技能）
    skill_261 = {
        id = 261,
        rank = 2,
        name = "shadow_demon_disseminate",
        hero = "npc_dota_hero_shadow_demon"
    },
    -- -- 崩裂禁锢（暗影恶魔一技能）
    -- skill_262 = {
    --     id = 262,
    --     rank = 4,
    --     name = "shadow_demon_disruption",
    --     hero = "npc_dota_hero_shadow_demon"
    -- },
    -- 冰霜新星（水晶室女一技能）
    skill_263 = {
        id = 263,
        rank = 4,
        name = "crystal_maiden_crystal_nova",
        hero = "npc_dota_hero_crystal_maiden"
    },
    -- 异界穿梭（虚无之灵二技能）
    skill_264 = {
        id = 264,
        rank = 3,
        name = "void_spirit_dissimilate",
        hero = "npc_dota_hero_void_spirit"
    },
    -- 共鸣脉冲（虚无之灵三技能）
    skill_265 = {
        id = 265,
        rank = 4,
        name = "void_spirit_resonant_pulse",
        hero = "npc_dota_hero_void_spirit"
    },
    -- 野性之斧（兽王一技能）
    skill_266 = {
        id = 266,
        rank = 2,
        name = "beastmaster_wild_axes",
        hero = "npc_dota_hero_beastmaster"
    },
    -- 原始咆哮（兽王大招）
    skill_267 = {
        id = 267,
        rank = 3,
        name = "beastmaster_primal_roar",
        hero = "npc_dota_hero_beastmaster"
    },
    -- -- 野性之心（兽王被动）
    -- skill_268 = {
    --     id = 268,
    --     rank = 4,
    --     name = "beastmaster_inner_beast",
    --     hero = "npc_dota_hero_beastmaster"
    -- },
    -- 相位转移（帕克三技能）
    skill_269 = {
        id = 269,
        rank = 2,
        name = "puck_phase_shift",
        hero = "npc_dota_hero_puck"
    },
    -- 新月之痕（帕克二技能）
    skill_270 = {
        id = 270,
        rank = 4,
        name = "puck_waning_rift",
        hero = "npc_dota_hero_puck"
    },
    -- 善咒（戴泽三技能）
    skill_271 = {
        id = 271,
        rank = 0,
        name = "dazzle_good_juju",
        hero = "npc_dota_hero_dazzle"
    },
    -- 巫蛊咒术（巫医二技能）
    skill_272 = {
        id = 272,
        rank = 4,
        name = "witch_doctor_maledict",
        hero = "npc_dota_hero_witch_doctor"
    },
    -- 寒霜爆发（巫妖一技能）
    skill_273 = {
        id = 273,
        rank = 4,
        name = "lich_frost_nova",
        hero = "npc_dota_hero_lich"
    },
    -- 奥术光环（水晶室女被动）
    skill_274 = {
        id = 274,
        rank = 4,
        name = "crystal_maiden_brilliance_aura",
        hero = "npc_dota_hero_crystal_maiden"
    },
    -- 缩地（编织者一技能）
    skill_275 = {
        id = 275,
        rank = 3,
        name = "weaver_shukuchi",
        hero = "npc_dota_hero_weaver"
    },
    -- 午夜凋零（谜团二技能）
    skill_276 = {
        id = 276,
        rank = 3,
        name = "enigma_midnight_pulse",
        hero = "npc_dota_hero_enigma"
    },
    -- 虚弱（祸乱之源一技能）
    skill_277 = {
        id = 277,
        rank = 4,
        name = "bane_enfeeble",
        hero = "npc_dota_hero_bane"
    },
    -- 蚀脑（祸乱之源二技能）
    skill_278 = {
        id = 278,
        rank = 4,
        name = "bane_brain_sap",
        hero = "npc_dota_hero_bane"
    },
    -- 噩梦（祸乱之源三技能）
    skill_279 = {
        id = 279,
        rank = 4,
        name = "bane_nightmare",
        hero = "npc_dota_hero_bane"
    },
    -- 粘稠鼻液（刚背兽一技能）
    skill_280 = {
        id = 280,
        rank = 4,
        name = "bristleback_viscous_nasal_goo",
        hero = "npc_dota_hero_bristleback"
    },
    -- 残影（蓝猫一技能）
    skill_281 = {
        id = 281,
        rank = 4,
        name = "storm_spirit_static_remnant",
        hero = "npc_dota_hero_storm_spirit"
    },
    -- 电子涡流（蓝猫二技能）
    skill_282 = {
        id = 282,
        rank = 4,
        name = "storm_spirit_electric_vortex",
        hero = "npc_dota_hero_storm_spirit"
    },
    -- 超负荷（风暴之灵三技能）
    skill_283 = {
        id = 283,
        rank = 4,
        name = "storm_spirit_overload",
        hero = "npc_dota_hero_storm_spirit"
    },
    -- 陵位斗篷（维萨吉被动减伤）
    skill_284 = {
        id = 284,
        rank = 4,
        name = "visage_gravekeepers_cloak",
        hero = "npc_dota_hero_visage"
    },
    -- 神智爆裂（小强二技能）
    skill_285 = {
        id = 285,
        rank = 3,
        name = "nyx_assassin_jolt",
        hero = "npc_dota_hero_nyx_assassin"
    },
    -- 发射钩爪（发条大招）
    skill_286 = {
        id = 286,
        rank = 3,
        name = "rattletrap_hookshot",
        hero = "npc_dota_hero_rattletrap"
    },
    -- 魂断（恐怖利刃大招）
    skill_287 = {
        id = 287,
        rank = 4,
        name = "terrorblade_sunder",
        hero = "npc_dota_hero_terrorblade"
    },
    -- 幽冥剧毒（毒龙二技能）
    skill_288 = {
        id = 288,
        rank = 4,
        name = "viper_nethertoxin",
        hero = "npc_dota_hero_viper"
    },
    -- 激光（修补匠一技能）
    skill_289 = {
        id = 289,
        rank = 4,
        name = "tinker_laser",
        hero = "npc_dota_hero_tinker"
    },
    -- 机械行军（修补匠二技能）
    skill_290 = {
        id = 290,
        rank = 4,
        name = "tinker_march_of_the_machines",
        hero = "npc_dota_hero_tinker"
    },
    -- -- 防御矩阵（修补匠三技能）
    -- skill_291 = {
    --     id = 291,
    --     rank = 4,
    --     name = "tinker_defense_matrix",
    --     hero = "npc_dota_hero_tinker"
    -- },
    -- 再装填（修补匠大招）
    skill_292 = {
        id = 292,
        rank = 0,
        name = "tinker_rearm",
        hero = "npc_dota_hero_tinker"
    },
    -- 幽冥守卫（骨法的棒子）
    skill_293 = {
        id = 293,
        rank = 3,
        name = "pugna_nether_ward",
        hero = "npc_dota_hero_pugna"
    },
    -- 生命汲取（骨法大招）
    skill_294 = {
        id = 294,
        rank = 4,
        name = "pugna_life_drain",
        hero = "npc_dota_hero_pugna"
    },
    -- 弱化能流（拉比克二技能）
    skill_295 = {
        id = 295,
        rank = 4,
        name = "rubick_fade_bolt",
        hero = "npc_dota_hero_rubick"
    },
    -- 群蛇守卫（暗影萨满大招）
    skill_296 = {
        id = 296,
        rank = 2,
        name = "shadow_shaman_mass_serpent_ward",
        hero = "npc_dota_hero_shadow_shaman"
    },
    -- 奥术诅咒（沉默一技能）
    skill_297 = {
        id = 297,
        rank = 4,
        name = "silencer_curse_of_the_silent",
        hero = "npc_dota_hero_silencer"
    },
    -- 遗言（沉默三技能）
    skill_298 = {
        id = 298,
        rank = 4,
        name = "silencer_last_word",
        hero = "npc_dota_hero_silencer"
    },
    -- -- 全领域静默（沉默大招）
    -- skill_299 = {
    --     id = 299,
    --     rank = 3,
    --     name = "silencer_global_silence",
    --     hero = ""
    -- },
    -- 憎恶（谜团一技能）
    skill_300 = {
        id = 300,
        rank = 4,
        name = "enigma_malefice",
        hero = "npc_dota_hero_enigma"
    },
    -- 恶性瘟疫（剧毒大招）
    skill_301 = {
        id = 301,
        rank = 3,
        name = "venomancer_noxious_plague",
        hero = "npc_dota_hero_venomancer"
    },
    -- 瘴气（剧毒一技能）
    skill_302 = {
        id = 302,
        rank = 4,
        name = "venomancer_venomous_gale",
        hero = "npc_dota_hero_venomancer"
    },
    -- 烈焰破击（蝙蝠骑士二技能）
    skill_303 = {
        id = 303,
        rank = 4,
        name = "batrider_flamebreak",
        hero = "npc_dota_hero_batrider"
    },
    -- 火焰飞行（蝙蝠骑士三技能）
    skill_304 = {
        id = 304,
        rank = 3,
        name = "batrider_firefly",
        hero = "npc_dota_hero_batrider"
    },
    -- 束缚击（风行一技能）
    skill_305 = {
        id = 305,
        rank = 4,
        name = "windrunner_shackleshot",
        hero = "npc_dota_hero_windrunner"
    },
    -- 强力击（风行二技能）
    skill_306 = {
        id = 306,
        rank = 4,
        name = "windrunner_powershot",
        hero = "npc_dota_hero_windrunner"
    },
    -- 传送（自然先知二技能）
    skill_307 = {
        id = 307,
        rank = 3,
        name = "furion_teleportation",
        hero = "npc_dota_hero_furion"
    },
    -- 感应地雷（工程师大招）
    skill_308 = {
        id = 308,
        rank = 3,
        name = "techies_land_mines",
        hero = "npc_dota_hero_techies"
    },
    -- 爆破起飞（炸弹人三技能）
    skill_309 = {
        id = 309,
        rank = 3,
        name = "techies_suicide",
        hero = "npc_dota_hero_techies"
    },
    -- 狂风（小黑二技能）
    skill_310 = {
        id = 310,
        rank = 4,
        name = "drow_ranger_wave_of_silence",
        hero = "npc_dota_hero_drow_ranger"
    },
    -- 投掷（小小二技能）
    skill_311 = {
        id = 311,
        rank = 4,
        name = "tiny_toss",
        hero = "npc_dota_hero_tiny"
    },
    -- 炎阳索（火猫一技能）
    skill_312 = {
        id = 312,
        rank = 4,
        name = "ember_spirit_searing_chains",
        hero = "npc_dota_hero_ember_spirit"
    },
    -- 鱼人碎击（大鱼人二技能）
    skill_313 = {
        id = 313,
        rank = 4,
        name = "slardar_slithereen_crush",
        hero = "npc_dota_hero_slardar"
    },
    -- 魔法箭（复仇之魂一技能）
    skill_314 = {
        id = 314,
        rank = 4,
        name = "vengefulspirit_magic_missile",
        hero = "npc_dota_hero_vengefulspirit"
    },
    -- 震撼大地（拍拍熊一技能）
    skill_315 = {
        id = 315,
        rank = 4,
        name = "ursa_earthshock",
        hero = "npc_dota_hero_ursa"
    },
    -- 密林奔走（小松鼠三技能）
    skill_316 = {
        id = 316,
        rank = 3,
        name = "hoodwink_scurry",
        hero = "npc_dota_hero_hoodwink"
    },
    -- 死亡守卫（巫医大招）
    skill_317 = {
        id = 317,
        rank = 2,
        name = "witch_doctor_death_ward",
        hero = "npc_dota_hero_witch_doctor"
    },
    -- 静态风暴（萨尔大招）
    skill_318 = {
        id = 318,
        rank = 3,
        name = "disruptor_static_storm",
        hero = "npc_dota_hero_disruptor"
    },
    -- 阳炎冲击（卡尔天火）
    skill_319 = {
        id = 319,
        rank = 2,
        name = "invoker_sun_strike_ad",
        hero = "npc_dota_hero_invoker"
    },
    -- 混沌陨石（卡尔陨石）
    skill_320 = {
        id = 320,
        rank = 2,
        name = "invoker_chaos_meteor_ad",
        hero = "npc_dota_hero_invoker"
    },
    -- 洗劫（米波三技能被动）
    skill_321 = {
        id = 321,
        rank = 2,
        name = "meepo_ransack",
        hero = "npc_dota_hero_meepo"
    },
    -- 火箭弹幕（飞机一技能）
    skill_322 = {
        id = 322,
        rank = 4,
        name = "gyrocopter_rocket_barrage",
        hero = "npc_dota_hero_gyrocopter"
    },
    -- 追踪导弹（飞机二技能）
    skill_323 = {
        id = 323,
        rank = 4,
        name = "gyrocopter_homing_missile",
        hero = "npc_dota_hero_gyrocopter"
    },
    -- 回音击（小牛大招）
    skill_324 = {
        id = 324,
        rank = 4,
        name = "earthshaker_echo_slam",
        hero = "npc_dota_hero_earthshaker"
    },
    -- 隐匿（圣堂刺客二技能）
    -- skill_325 = {
    --     id = 325,
    --     rank = 4,
    --     name = "templar_assassin_meld",
    --     hero = "npc_dota_hero_templar_assassin"
    -- },
    -- 石化凝视（美杜莎大招）
    skill_326 = {
        id = 326,
        rank = 4,
        name = "medusa_stone_gaze",
        hero = "npc_dota_hero_medusa"
    },
    -- 连环霜冻（巫妖大招）
    skill_327 = {
        id = 327,
        rank = 3,
        name = "lich_chain_frost",
        hero = "npc_dota_hero_lich"
    },
    -- 震荡波（猛犸一技能）
    skill_328 = {
        id = 328,
        rank = 4,
        name = "magnataur_shockwave",
        hero = "npc_dota_hero_magnataur"
    },
    -- 午夜盛宴（夜魔新技能）
    skill_329 = {
        id = 329,
        rank = 4,
        name = "night_stalker_midnight_feast",
        hero = "npc_dota_hero_night_stalker"
    },
    -- 责难（黑鸟新护盾技能）
    skill_330 = {
        id = 330,
        rank = 3,
        name = "obsidian_destroyer_objurgation",
        hero = "npc_dota_hero_obsidian_destroyer"
    },
    -- 毒蛇撕咬（剧毒新技能）
    skill_331 = {
        id = 331,
        rank = 3,
        name = "venomancer_snakebite",
        hero = "npc_dota_hero_venomancer"
    },
    -- 盛宴（小狗三技能盛宴）
    skill_332 = {
        id = 332,
        rank = 2,
        name = "life_stealer_feast",
        hero = "npc_dota_hero_life_stealer"
    },
    -- 撕裂伤害（小狗二技能）
    skill_333 = {
        id = 333,
        rank = 4,
        name = "life_stealer_open_wounds",
        hero = "npc_dota_hero_life_stealer"
    },
    -- 飞龙之怒（龙骑三技能被动）
    skill_334 = {
        id = 334,
        rank = 3,
        name = "dragon_knight_wyrms_wrath",
        hero = "npc_dota_hero_dragon_knight"
    },
    -- 抓树（小小三技能）
    skill_335 = {
        id = 335,
        rank = 2,
        name = "tiny_tree_grab",
        hero = "npc_dota_hero_tiny"
    },
    -- 部署炮塔（修补匠三技能）
    skill_336 = {
        id = 336,
        rank = 3,
        name = "tinker_deploy_turrets",
        hero = "npc_dota_hero_tinker"
    },
    -- 灵呱一闪（朗戈三技能）
    skill_337 = {
        id = 337,
        rank = 1,
        name = "largo_croak_of_genius",
        hero = "npc_dota_hero_largo"
    },
    -- 无光之盾（亚巴顿一技能）
    skill_338 = {
        id = 338,
        rank = 3,
        name = "abaddon_aphotic_shield",
        hero = "npc_dota_hero_abaddon"
    },
    -- 龙破斩（莉娜一技能）
    skill_339 = {
        id = 339,
        rank = 4,
        name = "lina_dragon_slave",
        hero = "npc_dota_hero_lina"
    },
    -- 光击阵（莉娜二技能）
    skill_340 = {
        id = 340,
        rank = 4,
        name = "lina_light_strike_array",
        hero = "npc_dota_hero_lina"
    },
    -- 复仇（小强大招）
    skill_341 = {
        id = 341,
        rank = 2,
        name = "nyx_assassin_vendetta",
        hero = "npc_dota_hero_nyx_assassin"
    },
    -- 伐木锯链（伐木机二技能）
    skill_342 = {
        id = 342,
        rank = 4,
        name = "shredder_timber_chain",
        hero = "npc_dota_hero_shredder"
    },
    -- 巨石翻滚（大地之灵二技能）
    skill_343 = {
        id = 343,
        rank = 3,
        name = "earth_spirit_rolling_boulder",
        hero = "npc_dota_hero_earth_spirit"
    },
    -- 战吼（斯温三技能）
    skill_344 = {
        id = 344,
        rank = 4,
        name = "sven_warcry",
        hero = "npc_dota_hero_sven"
    },
    -- 洪流（昆卡一技能）
    skill_345 = {
        id = 345,
        rank = 4,
        name = "kunkka_torrent",
        hero = "npc_dota_hero_kunkka"
    },
    -- 蛙力千钧（朗戈二技能）
    skill_346 = {
        id = 346,
        rank = 4,
        name = "largo_frogstomp",
        hero = "npc_dota_hero_largo"
    },
    -- 巨浪（潮汐猎人一技能）
    skill_347 = {
        id = 347,
        rank = 4,
        name = "tidehunter_gush",
        hero = "npc_dota_hero_tidehunter"
    },
    -- 烟雾（力丸一技能）
    skill_348 = {
        id = 348,
        rank = 4,
        name = "riki_smoke_screen",
        hero = "npc_dota_hero_riki"
    },
    -- 暗影步（赏金猎人三技能）
    skill_349 = {
        id = 349,
        rank = 4,
        name = "bounty_hunter_wind_walk",
        hero = "npc_dota_hero_bounty_hunter"
    },
    -- 月光（露娜一技能）
    skill_350 = {
        id = 350,
        rank = 4,
        name = "luna_lucent_beam",
        hero = "npc_dota_hero_luna"
    },
    -- 月蚀（露娜大招）
    skill_351 = {
        id = 351,
        rank = 4,
        name = "luna_eclipse",
        hero = "npc_dota_hero_luna"
    },
    -- 缚魂（天涯墨客大招）
    skill_352 = {
        id = 352,
        rank = 3,
        name = "grimstroke_soul_chain",
        hero = "npc_dota_hero_grimstroke"
    },
    -- 麻痹药剂（巫医一技能）
    skill_353 = {
        id = 353,
        rank = 4,
        name = "witch_doctor_paralyzing_cask",
        hero = "npc_dota_hero_witch_doctor"
    },
    -- 阴邪凝视（巫妖三技能）
    skill_354 = {
        id = 354,
        rank = 4,
        name = "lich_sinister_gaze",
        hero = "npc_dota_hero_lich"
    },
    -- 致命链接（术士一技能）
    skill_355 = {
        id = 355,
        rank = 4,
        name = "warlock_fatal_bonds",
        hero = "npc_dota_hero_warlock"
    },
    -- 地狱火（术士大招）
    skill_356 = {
        id = 356,
        rank = 2,
        name = "warlock_rain_of_chaos",
        hero = "npc_dota_hero_warlock"
    },
    -- 唤魂（琼英碧灵二技能）
    -- skill_357 = {
    --     id = 357,
    --     rank = 4,
    --     name = "muerta_the_calling",
    --     hero = "npc_dota_hero_muerta"
    -- },
    -- 尖刺外壳（司夜刺客三技能）
    skill_358 = {
        id = 358,
        rank = 3,
        name = "nyx_assassin_spiked_carapace",
        hero = "npc_dota_hero_nyx_assassin"
    },
    -- 磁场（天穹守望者二技能）
    skill_359 = {
        id = 359,
        rank = 4,
        name = "arc_warden_magnetic_field",
        hero = "npc_dota_hero_arc_warden"
    },
    -- 作祟（邪影芳灵大招）
    skill_360 = {
        id = 360,
        rank = 3,
        name = "dark_willow_bedlam",
        hero = "npc_dota_hero_dark_willow"
    },
    -- 奇观轮（百戏大王大招）
    skill_361 = {
        id = 361,
        rank = 3,
        name = "ringmaster_wheel",
        hero = "npc_dota_hero_ringmaster"
    },
    -- 地震（沙王大招）
    skill_362 = {
        id = 362,
        rank = 3,
        name = "sandking_epicenter",
        hero = "npc_dota_hero_sand_king"
    },
    -- 暗影突袭（痛苦女王一技能）
    skill_363 = {
        id = 363,
        rank = 4,
        name = "queenofpain_shadow_strike",
        hero = "npc_dota_hero_queenofpain"
    },
    -- 窒碍短匕（幻影刺客一技能）
    skill_364 = {
        id = 364,
        rank = 4,
        name = "phantom_assassin_stifling_dagger",
        hero = "npc_dota_hero_phantom_assassin"
    },
    -- 瘟疫守卫（剧毒三技能）
    skill_365 = {
        id = 365,
        rank = 4,
        name = "venomancer_plague_ward",
        hero = "npc_dota_hero_venomancer"
    },
    -- -- 真熊形态（德鲁伊大招）
    -- skill_366 = {
    --     id = 366,
    --     rank = 3,
    --     name = "lone_druid_true_form",
    --     hero = "npc_dota_hero_lone_druid"
    -- },
    -- 缠绕之根（德鲁伊一技能）
    skill_367 = {
        id = 367,
        rank = 4,
        name = "lone_druid_entangle",
        hero = "npc_dota_hero_lone_druid"
    },
    -- 野蛮咆哮（德鲁伊二技能）
    skill_368 = {
        id = 368,
        rank = 5,
        name = "lone_druid_savage_roar",
        hero = "npc_dota_hero_lone_druid"
    },
    -- 灵魂盛宴（影魔二技能）
    skill_369 = {
        id = 369,
        rank = 4,
        name = "nevermore_frenzy",
        hero = "npc_dota_hero_nevermore"
    },
    -- 猛禽之舞（凯大招）
    skill_370 = {
        id = 370,
        rank = 2,
        name = "kez_raptor_dance",
        hero = "npc_dota_hero_kez"
    },
    -- 回音重斩（凯一技能）
    skill_371 = {
        id = 371,
        rank = 4,
        name = "kez_echo_slash",
        hero = "npc_dota_hero_kez"
    },
    -- 恶魔之扉（孽主大招）
    skill_372 = {
        id = 372,
        rank = 4,
        name = "abyssal_underlord_dark_portal",
        hero = "npc_dota_hero_abyssal_underlord"
    },
    -- 怨念深渊（孽主二技能）
    skill_373 = {
        id = 373,
        rank = 4,
        name = "abyssal_underlord_pit_of_malice",
        hero = "npc_dota_hero_abyssal_underlord"
    },
    -- 急速冷却（卡尔）
    skill_374 = {
        id = 374,
        rank = 4,
        name = "invoker_cold_snap_ad",
        hero = "npc_dota_hero_invoker"
    },
    -- 强袭飓风（卡尔）
    skill_375 = {
        id = 375,
        rank = 4,
        name = "invoker_tornado_ad",
        hero = "npc_dota_hero_invoker"
    },
    -- 飘忽不定（幻影刺客三技能）
    skill_376 = {
        id = 376,
        rank = 4,
        name = "phantom_assassin_immaterial",
        hero = "npc_dota_hero_phantom_assassin"
    },
    -- 召唤飞弹（飞机大招）
    skill_377 = {
        id = 377,
        rank = 4,
        name = "gyrocopter_call_down",
        hero = "npc_dota_hero_gyrocopter"
    },
    -- 烈火罩（灰烬之灵二技能）
    skill_378 = {
        id = 378,
        rank = 4,
        name = "ember_spirit_flame_guard",
        hero = "npc_dota_hero_ember_spirit"
    },
    -- 沉默魔法（死亡先知二技能）
    skill_379 = {
        id = 379,
        rank = 4,
        name = "death_prophet_silence",
        hero = "npc_dota_hero_death_prophet"
    },
    -- 地穴虫群（死亡先知一技能）
    skill_380 = {
        id = 380,
        rank = 4,
        name = "death_prophet_carrion_swarm",
        hero = "npc_dota_hero_death_prophet"
    },
    -- 逃生技（百戏大王二技能）
    skill_381 = {
        id = 381,
        rank = 2,
        name = "ringmaster_the_box",
        hero = "npc_dota_hero_ringmaster"
    },
    -- 蛛网（育母蜘蛛二技能）
    skill_382 = {
        id = 382,
        rank = 2,
        name = "broodmother_spin_web",
        hero = "npc_dota_hero_broodmother"
    },
    -- 烈火精灵（凤凰二技能）
    skill_383 = {
        id = 383,
        rank = 4,
        name = "phoenix_fire_spirits",
        hero = "npc_dota_hero_phoenix",
        hide_ability = {"phoenix_launch_fire_spirit"}
    },
    -- 锯齿飞轮（伐木机大招）
    skill_384 = {
        id = 384,
        rank = 3,
        name = "shredder_chakram",
        hero = "npc_dota_hero_shredder",
        hide_ability = {"shredder_return_chakram"},
        busy_modifiers = {
            "modifier_shredder_chakram_disarm",
            "modifier_shredder_chakram",
        },
    },
    -- 地雷滚滚（滚滚大招）
    skill_385 = {
        id = 385,
        rank = 2,
        name = "pangolier_gyroshell",
        hero = "npc_dota_hero_pangolier",
        hide_ability = {"pangolier_gyroshell_stop"}
    },
    -- 炽烈火雨（小骷髅魔晶）
    skill_386 = {
        id = 386,
        rank = 4,
        name = "clinkz_burning_barrage",
        hero = ""
    },
    -- 树木连掷（小小A杖）
    skill_387 = {
        id = 387,
        rank = 4,
        name = "tiny_tree_channel",
        hero = ""
    },
    -- 海象飞踢（海民A杖）
    -- skill_388 = {
    --     id = 388,
    --     rank = 3,
    --     name = "tusk_walrus_kick",
    --     hero = ""
    -- },
    -- 狂魔（TB魔晶）
    -- skill_389 = {
    --     id = 389,
    --     rank = 3,
    --     name = "terrorblade_demon_zeal",
    --     hero = ""
    -- },
    -- 虚无主义（拉席克A杖）
    skill_390 = {
        id = 390,
        rank = 2,
        name = "leshrac_greater_lightning_storm",
        hero = ""
    },
    -- 青森诅咒（先知魔晶）
    -- skill_391 = {
    --     id = 391,
    --     rank = 4,
    --     name = "furion_curse_of_the_forest",
    --     hero = ""
    -- },
    -- 腾焰斗篷（火女A杖）
    skill_392 = {
        id = 392,
        rank = 2,
        name = "lina_flame_cloak",
        hero = ""
    },
    -- 跃动（小鹿魔晶）
    skill_393 = {
        id = 393,
        rank = 4,
        name = "enchantress_bunny_hop",
        hero = ""
    },
    -- 重如铁锚（潮汐魔晶）
    skill_394 = {
        id = 394,
        rank = 3,
        name = "tidehunter_dead_in_the_water",
        hero = ""
    },
    -- 狂暴药剂（炼金魔晶）
    -- skill_395 = {
    --     id = 395,
    --     rank = 3,
    --     name = "alchemist_berserk_potion",
    --     hero = ""
    -- },
    -- 震荡手雷（火枪魔晶）
    -- skill_396 = {
    --     id = 396,
    --     rank = 3,
    --     name = "sniper_concussive_grenade",
    --     hero = ""
    -- },
    -- -- 迅风斩（剑圣A杖）
    -- skill_397 = {
    --     id = 397,
    --     rank = 3,
    --     name = "juggernaut_swift_slash",
    --     hero = ""
    -- },
    -- 制敌勾爪（凯长刀二技能）
    skill_398 = {
        id = 398,
        rank = 3,
        name = "kez_grappling_claw",
        hero = "npc_dota_hero_kez"
    },
    -- 密友（小鹿A杖）
    skill_399 = {
        id = 399,
        rank = 3,
        name = "enchantress_little_friends",
        hero = ""
    },
    -- 超震声波（卡尔）
    skill_400 = {
        id = 400,
        rank = 3,
        name = "invoker_deafening_blast_ad",
        hero = "npc_dota_hero_invoker"
    },
    -- 弧形闪电（宙斯一技能）
    skill_401 = {
        id = 401,
        rank = 3,
        name = "zuus_arc_lightning",
        hero = "npc_dota_hero_zuus"
    },
    -- 毁灭（潮汐猎人大招）
    skill_402 = {
        id = 402,
        rank = 3,
        name = "tidehunter_ravage",
        hero = "npc_dota_hero_tidehunter"
    },
    -- 未精通的火焰轰爆（食人魔魔法师A杖技能）
    skill_403 = {
        id = 403,
        rank = 3,
        name = "ogre_magi_unrefined_fireblast",
        hero = "npc_dota_hero_ogre_magi"
    },
    -- 神圣一跃（宙斯三技能）
    skill_404 = {
        id = 404,
        rank = 4,
        name = "zuus_heavenly_jump",
        hero = "npc_dota_hero_zuus"
    },
    -- 蜥蜴绝吻（电炎绝手大招）
    skill_405 = {
        id = 405,
        rank = 2,
        name = "snapfire_mortimer_kisses",
        hero = "npc_dota_hero_snapfire",
        busy_modifiers = {
            "modifier_snapfire_mortimer_kisses",
        },
    },
    -- 剑气斩（自定义攻击触发剑气）
    skill_406 = {
        id = 406,
        rank = 2,
        name = "ability_hero_8",
    },
    -- 幽魂飞弹（琼英碧灵魔晶技能，不绑定英雄）
    skill_407 = {
        id = 407,
        rank = 3,
        name = "muerta_spectral_slug",
        hero = "",
    },

}

-- beidong 地图与旧纯被动模式共用：技能书随机池为下表索引 ∩ 各 Rank 池（Skill:GetRollSkillPool）
Skill.PassiveSkill = {
    1, 2, 3, 4, 7, 8, 9, 10, 11, 13, 14, 15, 20, 21, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 38, 39, 41, 42, 43, 44, 46, 47, 51, 53, 55, 56, 57, 58, 60, 61, 67, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 85, 86, 89, 92, 95, 97, 98, 99, 100, 101, 103, 106, 107, 108, 111, 112, 113, 115, 116, 118, 121, 122, 126, 127, 129, 135, 137, 140, 156, 159, 161, 164, 166, 170, 172, 178, 187, 192, 193, 194, 195, 196, 231, 245, 251, 266, 316, 321, 329, 332, 335, 337, 406
 }
