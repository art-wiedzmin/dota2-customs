--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


SelectHero.Data = {}
SelectHero.Template = {
    id = -1,
    -- 是否显示选人界面「全英雄自选」按钮（1=显示，需英雄自选卡）
    tool = 1,
    load = true,
    page = false,
    face = -1,
    -- 选人倒计时结束前：客户端已高亮但未点确定的槽位 1–3，0 表示未预选
    pending_slot = 0,
    -- 英雄选择倒计时
    time = 90,
    -- 选择属性
    attr_state = true,
    -- 属性类型
    attr_tp = -1,
    -- 是否已选择英雄
    hero_state = false,
    -- 英雄编号
    hero_name = "",
    hero_id = -1,
    -- 英雄索引
    hero_index = -1,
    -- 剩余可随机次数（金豆档位进度；三种免费均不扣此项，仅在扣金豆刷新时递减，见 RollHero）
    refresh = 10,
    -- 全服基础免费 1 次（不扣 refresh）
    base_free_left = 1,
    -- 月卡/季卡额外免费已用次数（资格随 Shop 实时变化，见 GetCardFreeLeft）
    card_bonus_used = 0,
    -- 全英雄自选失败提示（如英雄自选卡不足）
    hero_pick_hint = "",
    -- 本局自选卡：请求中 / 已成功使用（防连点重复扣卡）
    hero_pick_pending = false,
    hero_pick_used = false,
    -- 本局唯一消耗凭证（服务端同 token 只扣一次）
    hero_pick_once_key = "",
    free = false,
    -- 英雄列表
    list = {
        slot_1 = { state = true, index = -1, name = "", ab_list = {} },
        slot_2 = { state = true, index = -1, name = "", ab_list = {} },
        slot_3 = { state = true, index = -1, name = "", ab_list = {} }
    },
    exit = false,
    --天赋技能索引
    talent_index = 1,
    talent_cd_state = false,
    talent_cd_num = 0,
}
-- 暂时隐藏的天赋（选人不可选；服务端会回退为 DefaultTalentIndex）
SelectHero.HiddenTalentIndices = {}
SelectHero.DefaultTalentIndex = 1
-- beidong 地图可选英雄白名单：HeroList.index 编号；空表则不额外筛选（与其它地图一致）
SelectHero.PssiveHero = {
    2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 59, 60, 64, 65, 66, 68, 71, 72, 78, 80, 81, 83, 84, 89, 91, 94, 95, 96, 97, 99, 100, 101, 105, 107, 108, 109, 111
}
-- 英雄池子
SelectHero.HeroType = {
    -- 力量
    tp1 = {
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 36, 37, 38, 39, 40, 41, 42, 44, 45,
        46, 47, 68, 74, 75, 77, 78, 80, 83, 91, 92, 93, 98, 99, 105, 107, 111

    },
    -- 敏捷
    tp2 = {
        11, 13, 14, 15, 17, 18, 19, 20, 21, 22, 23, 31, 48, 49, 50, 51, 52, 53, 54,
        55, 56, 69, 71, 81, 16, 82, 72, 84, 89, 94, 97, 101, 102, 108, 109
    },
    -- 智力
    tp3 = {
        24, 25, 28, 29, 30, 32, 34, 35, 57, 59, 61, 62, 63, 64, 65, 67, 70,
        73, 26, 86, 88, 95, 96, 27, 103, 104, 106, 110, 33, 87
        --30
    }
}
-- 稀有度池子
SelectHero.Rareness = {
    -- 稀有
    rank_1 = {
        tp1 = {
            -- 力量
            1, 46, 5, 77, 98, 40, 91, 80, 42, 6, 4
        },
        tp2 = {
            -- 敏捷
            13, 18, 48, 31, 34
        },
        tp3 = {
            -- 智力
            62, 27, 33, 61, 67, 103, 87, 106, 59, 88, 24, 35, 32, 89
        }
    },
    -- 普通
    rank_2 = {
        tp1 = {
            -- 力量
            2, 3, 7, 8, 9, 10, 36, 37, 38, 39, 41, 44,
            47, 68, 74, 75, 78, 83, 92, 93, 99, 105, 107, 111, 45, 11
            --2
        },
        tp2 = {
            -- 敏捷
            14, 15, 17, 19, 21, 23, 49, 50, 51, 52, 53,
            55, 69, 71, 81, 82, 84, 94, 101, 102, 108, 97, 72, 56, 20, 22, 54, 16
            --20
        },
        tp3 = {
            -- 智力
            25, 28, 29, 30, 57, 63, 64, 65, 70,
            73, 26, 86, 95, 96, 104, 110,
            66
            -- 33
        }
    }
}
-- 池子概率
-- 先 Weight 选 rank，再在 Rareness 池内均匀抽英雄。
-- 单英雄：P(某稀有)/P(某普通) = (rank_1/R)/(rank_2/N) → rank_1:rank_2 = 2R : 5N（单英雄 P(稀):P(普)=1:2.5）
SelectHero.Probability = {
    tp1 = { rank_1 = 22, rank_2 = 135 }, -- 力量 R=11 N=27 → 2R:5N=22:135，单英雄 P(稀):P(普)=1:2.5
    tp2 = { rank_1 = 10, rank_2 = 189 }, -- 敏捷 R=5 N=27 → 2R:7N=10:189，单英雄 P(稀):P(普)=1:3.5
    tp3 = { rank_1 = 28, rank_2 = 85 }   -- 智力 R=14 N=17 → 2R:5N=28:85，单英雄 P(稀):P(普)=1:2.5
}
SelectHero.AghSkill = {
    hero = { "npc_dota_hero_centaur" },
    skill = { "ultimate_scepter" }
}
SelectHero.Cost = {
    num10 = 1,
    num9 = 9,
    num8 = 9,
    num7 = 19,
    num6 = 19,
    num5 = 29,
    num4 = 29,
    num3 = 39,
    num2 = 39,
    num1 = 39
}
--英雄战斗类型分类（编号同 HeroList.index）
SelectHero.BattleType = {
    -- 超级肉盾
    btp1 = {
        1, 2, 3, 4, 10, 39, 46, 56, 74, 93, 99, 105, 111,
    },
    -- 物理攻击
    btp2 = {
        5, 7, 8, 9, 11, 12, 13, 14, 15, 17, 18, 19, 20, 21, 22, 23, 36, 37, 38, 41, 42, 44, 45, 47,
        48, 49, 50, 51, 52, 53, 54, 55, 69, 71, 72, 75, 76, 77, 78, 80, 81, 82, 83, 84, 89, 91,
        94, 95, 96, 97, 101, 102, 107, 108, 109,
    },
    -- 法术技能
    btp3 = {
        6, 26, 27, 35, 40, 43, 58, 61, 62, 63, 68, 73, 79, 85, 87, 92, 98, 103, 104, 106, 110,
    },
    -- 法系攻击
    btp4 = {
        16, 24, 25, 28, 29, 30, 31, 32, 33, 34, 57, 59, 60, 64, 65, 66, 67, 70, 86, 88, 100,
    },
}
-- 战斗类型展示文案（选英雄界面「推荐技能」副标题）
SelectHero.BattleTypeLabel = {
    btp1 = "超级肉盾",
    btp2 = "物理攻击",
    btp3 = "魔法技能",
    btp4 = "魔法攻击",
}
-- 英雄对应推荐肉搏技能列表（数字为 ability_item 编号，与 item_skill_* 一致）
SelectHero.RMBList = {
    -- 超级肉盾：邪恶/弱化/专注/掠夺/生生不息/尖刺/魔皮/自爆/硬化/回到过去（专注光环去重；血肉丰碑暂时隐藏）
    btp1 = { 2, 9, 6, 28, 7, 17, 22, 31, 25, 29 },
    -- 物理攻击
    btp2 = { 1, 28, 27, 5, 15, 19, 26, 37, 13, 16, 24 },
    -- 魔法技能（无限火力对应 ability_item_37，与资源中「一拳超人」为同一技能位）
    btp3 = { 2, 11, 28, 21, 23, 33, 36, 16, 24 },
    -- 魔法攻击
    btp4 = { 1, 11, 28, 20, 14, 21, 23, 13, 16, 24 },
}
-- 英雄列表
SelectHero.HeroList = {
    -- 屠夫
    npc_dota_hero_pudge = {
        -- 英雄编号
        index = 1,
        -- 英雄类型（tp1:力量，tp2：敏捷，tp3：智力）
        tp = 1,
        -- 需要删除的技能名称
        list = {
            -- 钩子
            "pudge_meat_hook", -- 腐烂
            "pudge_rot", "pudge_flesh_heap", "pudge_dismember"
        }
    },
    -- 潮汐
    npc_dota_hero_tidehunter = {
        index = 2,
        tp = 1,
        list = {
            "tidehunter_ravage", "tidehunter_kraken_shell", "tidehunter_gush",
            "tidehunter_anchor_smash",
            -- "special_bonus_unique_tidehunter_smash_on_blubber"
        },
        -- 如果有神杖或者魔晶，就添加对应技能
        agh = "tidehunter_dead_in_the_water"
    },
    npc_dota_hero_abaddon = {
        index = 3,
        tp = 1,
        list = {
            "abaddon_borrowed_time", "abaddon_aphotic_shield",
            "abaddon_frostmourne", "abaddon_death_coil"
        },
        face = {
            face_1 = 1, -- 畅快淋漓
            face_2 = 3  -- 恶意迷雾
        }
    },
    npc_dota_hero_centaur = {
        index = 4,
        tp = 1,
        list = {
            "centaur_hoof_stomp", "centaur_double_edge", "centaur_return",
            "centaur_stampede"
        },
        agh = "centaur_work_horse",
        face = {
            face_1 = 1, -- 反击精英
            face_2 = 2  -- 开足马力
        }
    },
    npc_dota_hero_life_stealer = {
        index = 5,
        tp = 1,
        list = {
            "life_stealer_feast",
            "life_stealer_rage",
            "life_stealer_infest", "life_stealer_open_wounds",
        },
        agh = "centaur_work_horse",
        face = {
            face_1 = 4, -- 血肉盛宴
            face_2 = 5  -- 喋血风暴
        },
        hide = { "life_stealer_ghoul_frenzy" }
    },
    npc_dota_hero_huskar = {
        index = 6,
        tp = 1,
        list = {
            "huskar_inner_fire", "huskar_burning_spear",
            "huskar_berserkers_blood", "huskar_life_break"
        },
        face = {
            face_1 = 3, -- 炙疗
            face_2 = 4  -- 炙矛可热
        }
    },
    npc_dota_hero_slardar = {
        index = 7,
        tp = 1,
        list = {
            "slardar_bash", "slardar_slithereen_crush", "slardar_sprint",
            "slardar_amplify_damage"
        },
        face = {
            face_1 = 1, -- 腿部力量
            face_2 = 2  -- 沧洋守卫
        }
    },
    npc_dota_hero_tusk = {
        index = 8,
        tp = 1,
        list = {
            "tusk_ice_shards", "tusk_snowball", "tusk_tag_team",
            "tusk_walrus_punch", "tusk_drinking_buddies"
        },
        agh = "tusk_walrus_kick",
        face = {
            face_1 = 1, -- 摔角行家
            face_2 = 2  -- 酒友
        }
    },
    npc_dota_hero_legion_commander = {
        index = 9,
        tp = 1,
        list = {
            "legion_commander_duel", "legion_commander_moment_of_courage",
            "legion_commander_overwhelming_odds",
            "legion_commander_press_the_attack"
        },
        face = {
            face_1 = 1, -- 石堂城甲胄
            face_2 = 2  -- 战争恩赐
        }
    },
    npc_dota_hero_axe = {
        index = 10,
        tp = 1,
        list = {
            "axe_culling_blade", "axe_counter_helix", "axe_berserkers_call",
            "axe_battle_hunger"
        },
        face = {
            face_1 = 1, -- 一人之军
            face_2 = 2  -- 吼声震天
        }
    },
    npc_dota_hero_juggernaut = {
        index = 11,
        tp = 2,
        list = {
            "juggernaut_blade_dance", "juggernaut_healing_ward",
            "juggernaut_omni_slash", "juggernaut_blade_fury"

        },
        agh = "juggernaut_swift_slash",
        face = {
            face_1 = 1, -- 刀剑风暴
            face_2 = 2  -- 剑心犹在
        }
    },
    npc_dota_hero_kez = {
        index = 12,
        tp = 2,
        list = {
            "kez_echo_slash", "kez_falcon_rush", "kez_grappling_claw",
            "kez_kazurai_katana", "kez_raptor_dance", "kez_ravens_veil",
            "kez_talon_toss", "kez_shodo_sai", "kez_switch_weapons_katana",
            "kez_switch_weapons_katana_off", "kez_switch_weapons_sai",
            "kez_switch_weapons_sai_off", "kez_switch_weapons",
            "kez_shodo_sai_parry_cancel"
        },
        face = {
            face_1 = 1, -- 阵翼
            face_2 = 2  -- 隼影
        }
    },
    npc_dota_hero_drow_ranger = {
        index = 13,
        tp = 2,
        list = {
            "drow_ranger_silence", "drow_ranger_marksmanship",
            "drow_ranger_multishot", "drow_ranger_frost_arrows",
            "drow_ranger_wave_of_silence"
        },
        agh = "drow_ranger_glacier",
        face = {
            face_1 = 1, -- 制高点
            face_2 = 2  -- 侧身回避
        }
    },
    npc_dota_hero_phantom_assassin = {
        index = 14,
        tp = 2,
        list = {
            "phantom_assassin_coup_de_grace",
            "phantom_assassin_stifling_dagger",
            "phantom_assassin_phantom_strike", "phantom_assassin_immaterial"
        },
        agh = "phantom_assassin_fan_of_knives",
        hide = { "phantom_assassin_blur" },
        face = {
            face_1 = 2, -- 有条不紊
            face_2 = 3  -- 甜蜜释放
        }
    },
    npc_dota_hero_troll_warlord = {
        index = 15,
        tp = 2,
        list = {
            "troll_warlord_fervor", "troll_warlord_berserkers_rage",
            "troll_warlord_battle_trance",
            "troll_warlord_whirling_axes_melee",
            "troll_warlord_whirling_axes_ranged", "troll_warlord_rampage",
            "troll_warlord_berserkers_rage_active",
            -- "troll_warlord_switch_stance"
        },
        hide = { "troll_warlord_berserkers_rage_active", "troll_warlord_switch_stance" },
    },
    npc_dota_hero_medusa = {
        index = 16,
        tp = 2,
        list = {
            "medusa_mystic_snake", "medusa_split_shot", "medusa_gorgon_grasp",
            "medusa_stone_gaze"
        },
        agh = "medusa_cold_blooded",
        face = { face_1 = 3, face_2 = 4 }
    },
    npc_dota_hero_faceless_void = {
        index = 17,
        tp = 2,
        list = {
            "faceless_void_time_walk", "faceless_void_time_lock",
            "faceless_void_time_dilation", "faceless_void_chronosphere",
            "faceless_void_time_zone"
        },
        agh = "faceless_void_time_walk_reverse",
        face = {
            face_1 = 2, -- 时间结界
            face_2 = 3  -- 逆转时空
        }
    },
    npc_dota_hero_sniper = {
        index = 18,
        tp = 2,
        list = {
            "sniper_shrapnel", "sniper_headshot",
            "sniper_assassinate"
        },
        strip = { "sniper_take_aim", "sniper_take_aim_stop" },
        agh = "sniper_concussive_grenade",
        face = {
            face_1 = 1, -- 吉利服
            face_2 = 2  -- 散弹
        }
    },
    npc_dota_hero_broodmother = {
        index = 19,
        tp = 2,
        list = {
            "broodmother_insatiable_hunger", "broodmother_incapacitating_bite",
            "broodmother_spawn_spiderlings", "broodmother_spin_web"
        },
        agh = "broodmother_sticky_snare",
        face = {
            face_1 = 1, -- 坏死之网
            face_2 = 2  -- 疯狂喂食
        }
    },
    npc_dota_hero_gyrocopter = {
        index = 20,
        tp = 2,
        list = {
            "gyrocopter_rocket_barrage", "gyrocopter_flak_cannon",
            "gyrocopter_homing_missile", "gyrocopter_call_down"
        },
        agh = { "gyrocopter_side_gunner_spawn_ability" }
    },
    npc_dota_hero_ursa = {
        index = 21,
        tp = 2,
        list = {
            "ursa_overpower", "ursa_fury_swipes", "ursa_enrage",
            "ursa_earthshock"
        },
        face = {
            face_1 = 1, -- 熊心豹胆
            face_2 = 2  -- 熊心勃勃
        }
    },
    npc_dota_hero_luna = {
        index = 22,
        tp = 2,
        list = {
            "luna_lucent_beam", -- "luna_lunar_blessing",
            "luna_eclipse", "luna_moon_glaive", "luna_lunar_orbit"
        },
        face = {
            face_1 = 2, -- 月盾
            face_2 = 3  -- 明月风暴
        }
    },
    npc_dota_hero_techies = {
        index = 23,
        tp = 2,
        list = {
            "techies_suicide", "techies_remote_mines", "techies_land_mines",
            "techies_reactive_tazer", "techies_sticky_bomb",
            "techies_minefield_sign"
        },
        agh = "techies_squees_scope",
        face = {
            face_1 = 1, -- 斯奎的瞄准镜
            face_2 = 2, -- 司布林的秘密武器
            face_3 = 3  -- 司布恩的藏品
        }
    },
    npc_dota_hero_silencer = {
        index = 24,
        tp = 3,
        list = {
            "silencer_last_word", "silencer_global_silence",
            "silencer_glaives_of_wisdom", "silencer_curse_of_the_silent"
        },
        face = {
            face_1 = 3, -- 突触分裂
            face_2 = 4  -- 默默受苦
        }
    },
    npc_dota_hero_lina = {
        index = 25,
        tp = 3,
        list = {
            "lina_light_strike_array", "lina_laguna_blade", "lina_fiery_soul",
            "lina_dragon_slave"
        },
        agh = "lina_flame_cloak",
        face = {
            face_1 = 1, -- 热力失控
            face_2 = 2  -- 慢热
        }
    },
    npc_dota_hero_lion = {
        index = 26,
        tp = 3,
        list = {
            "lion_voodoo", "lion_mana_drain", "lion_impale",
            "lion_finger_of_death"
        },
        face = {
            face_1 = 1, -- 吞噬精华
            face_2 = 2  -- 死亡之拳
        }
    },
    npc_dota_hero_necrolyte = {
        index = 27,
        tp = 3,
        list = {
            "necrolyte_reapers_scythe", "necrolyte_death_pulse",
            "necrolyte_ghost_shroud", "necrolyte_heartstopper_aura"
        },
        agh = "necrolyte_death_seeker",
        face = {
            face_1 = 1, -- 亵渎之力
            face_2 = 2  -- 快速腐朽
        }
    },
    -- 宙斯
    npc_dota_hero_zuus = {
        index = 28,
        tp = 3,
        list = {
            "zuus_thundergods_wrath", -- "zuus_static_field",
            "zuus_lightning_bolt", "zuus_arc_lightning", "zuus_heavenly_jump"
        },
        agh = "zuus_cloud",
        face = {
            face_1 = 1, -- 欢声雷动
            face_2 = 2  -- 神圣之怒
        }
    },
    npc_dota_hero_enchantress = {
        index = 29,
        tp = 3,
        list = {
            "enchantress_untouchable", "enchantress_natures_attendants",
            "enchantress_impetus", "enchantress_enchant"
        },
        agh = { "enchantress_little_friends", "enchantress_bunny_hop" },
        face = {
            face_1 = 1, -- 过度保护的小精灵
            face_2 = 2  -- 着迷
        }
    },
    npc_dota_hero_shadow_demon = {
        index = 30,
        tp = 3,
        list = {
            "shadow_demon_disruption", "shadow_demon_disseminate",
            "shadow_demon_shadow_poison", "shadow_demon_shadow_poison_release",
            "shadow_demon_demonic_purge", "shadow_demon_soul_catcher"
        },
        agh = { "shadow_demon_demonic_cleanse" },
        face = {
            face_1 = 1, -- 传播
            face_2 = 2  -- 暗影仆从
        }
    },
    npc_dota_hero_muerta = {
        index = 31,
        tp = 2,
        list = {
            "muerta_dead_shot", "muerta_gunslinger", "muerta_pierce_the_veil",
            "muerta_the_calling", "muerta_ofrenda"
        },
        agh = { "muerta_spectral_slug" },
        face = {
            face_1 = 1, -- 亡灵之舞
            face_2 = 3  -- 快枪手
        }
    },
    npc_dota_hero_dark_willow = {
        index = 32,
        tp = 3,
        list = {
            "dark_willow_terrorize", "dark_willow_shadow_realm",
            "dark_willow_cursed_crown", "dark_willow_bramble_maze",
            "dark_willow_bedlam"
        },
        face = {
            face_1 = 1, -- 切肤之影
            face_2 = 3  -- 破碎之冠
        }
    },
    npc_dota_hero_obsidian_destroyer = {
        index = 33,
        tp = 3,
        list = {
            "obsidian_destroyer_sanity_eclipse",
            -- "obsidian_destroyer_equilibrium",
            "obsidian_destroyer_astral_imprisonment",
            "obsidian_destroyer_arcane_orb",
            "obsidian_destroyer_objurgation"
        },
        hide = { "obsidian_destroyer_equilibrium" }
    },
    npc_dota_hero_jakiro = {
        index = 34,
        tp = 3,
        list = {
            "jakiro_dual_breath", "jakiro_ice_path", "jakiro_liquid_fire",
            "jakiro_liquid_ice", "jakiro_macropyre"
        },
        face = {
            face_1 = 3, -- 双生恐怖
            face_2 = 4  -- 破冰行动
        }
    },
    npc_dota_hero_rubick = {
        index = 35,
        tp = 3,
        list = {
            "rubick_fade_bolt", "rubick_null_field", "rubick_telekinesis",
            "rubick_spell_steal", "rubick_arcane_supremacy", "rubick_empty1",
            "rubick_empty2"
        },
        face = {
            face_1 = 1, -- 节俭窃贼
            face_2 = 2  -- 奥数积累
        }
    },
    npc_dota_hero_sven = {
        index = 36,
        list = {
            "sven_storm_bolt", "sven_great_cleave", "sven_gods_strength",
            "sven_warcry"
        }
    },
    npc_dota_hero_magnataur = {
        index = 37,
        list = {
            "magnataur_shockwave", "magnataur_skewer",
            "magnataur_reverse_polarity", "magnataur_empower"
        },
        agh = "magnataur_horn_toss"
    },
    npc_dota_hero_brewmaster = {
        index = 38,
        list = {
            "brewmaster_primal_split", "brewmaster_thunder_clap",
            "brewmaster_cinder_brew", "brewmaster_drunken_brawler_active",
            "brewmaster_drunken_brawler_crit",
            "brewmaster_drunken_brawler_earth",
            "brewmaster_drunken_brawler_fire",
            "brewmaster_drunken_brawler_miss", "brewmaster_drunken_brawler",
            "brewmaster_drunken_brawler_storm",
            "brewmaster_drunken_brawler_void"
        },
        hide = { "brewmaster_liquid_courage" },
        -- agh = { "brewmaster_liquid_courage" }
    },
    npc_dota_hero_dragon_knight = {
        index = 39,
        list = {
            "dragon_knight_wyrms_wrath", "dragon_knight_dragon_tail",
            "dragon_knight_elder_dragon_form", "dragon_knight_breathe_fire"
        },
        agh = "dragon_knight_fireball"
    },
    npc_dota_hero_omniknight = {
        index = 40,
        list = {
            "omniknight_purification", "omniknight_martyr",
            "omniknight_angelic_flight", "omniknight_hammer_of_purity",
            "omniknight_guardian_angel"
        }
    },
    npc_dota_hero_abyssal_underlord = {
        index = 41,
        list = {
            "abyssal_underlord_firestorm", "abyssal_underlord_pit_of_malice",
            "abyssal_underlord_dark_rift", "abyssal_underlord_dark_portal",
            "abyssal_underlord_atrophy_aura"
        }
    },
    npc_dota_hero_kunkka = {
        index = 42,
        list = {
            "kunkka_ghostship", "kunkka_return", "kunkka_tidebringer",
            "kunkka_torrent", "kunkka_x_marks_the_spot"
        },
        agh = "kunkka_tidal_wave",
        hide = { "kunkka_admirals_rum" }

    },
    npc_dota_hero_spirit_breaker = {
        index = 43,
        list = {
            "spirit_breaker_bulldoze", "spirit_breaker_charge_of_darkness",
            "spirit_breaker_greater_bash", "spirit_breaker_nether_strike"
        },
        agh = "spirit_breaker_planar_pocket"
    },
    npc_dota_hero_treant = {
        index = 44,
        list = {
            "treant_natures_grasp", "treant_overgrowth",
            "treant_living_armor", "treant_leech_seed"
        },
        agh = "treant_eyes_in_the_forest",
        hide = { "treant_natures_guise" }
    },
    npc_dota_hero_ogre_magi = {
        index = 45,
        list = {
            "ogre_magi_ignite", "ogre_magi_multicast", "ogre_magi_fireblast",
            "ogre_magi_bloodlust"
        },
        agh = { "ogre_magi_smash", "ogre_magi_unrefined_fireblast" }
    },
    npc_dota_hero_rattletrap = {
        index = 46,
        list = {
            "rattletrap_power_cogs", "rattletrap_rocket_flare",
            "rattletrap_hookshot", "rattletrap_battery_assault"
        },
        agh = { "rattletrap_overclocking", "rattletrap_jetpack" }
    },
    npc_dota_hero_lycan = {
        index = 47,
        list = {
            "lycan_summon_wolves", "lycan_feral_impulse", "lycan_howl",
            "lycan_shapeshift"
        },
        agh = "lycan_summon_wolves_bash"
    },
    npc_dota_hero_snapfire = {
        index = 48,
        list = {
            "snapfire_mortimer_kisses", "snapfire_firesnap_cookie",
            "snapfire_lil_shredder", "snapfire_scatterblast"
        },
        agh = { "snapfire_gobble_up", "snapfire_spit_creep" }
    },
    npc_dota_hero_slark = {
        index = 49,
        list = {
            "slark_dark_pact", "slark_pounce", "slark_saltwater_shiv",
            "slark_shadow_dance"
        },
        agh = "slark_depth_shroud"
    },
    npc_dota_hero_bounty_hunter = {
        index = 50,
        list = {
            "bounty_hunter_shuriken_toss", "bounty_hunter_track",
            "bounty_hunter_jinada", "bounty_hunter_wind_walk"
        },
        agh = "bounty_hunter_wind_walk_ally"
    },
    npc_dota_hero_marci = {
        index = 51,
        list = {
            "marci_unleash", "marci_guardian", "marci_grapple",
            "marci_companion_run", "marci_bodyguard"
        },
        hide = { "marci_special_delivery" }
    },
    npc_dota_hero_vengefulspirit = {
        index = 52,
        list = {
            "vengefulspirit_command_aura", "vengefulspirit_magic_missile",
            "vengefulspirit_nether_swap", "vengefulspirit_wave_of_terror"
        }
    },
    npc_dota_hero_viper = {
        index = 53,
        list = {
            "viper_poison_attack", "viper_viper_strike", "viper_nethertoxin",
            "viper_corrosive_skin"
        },
        agh = "viper_nose_dive"
    },
    npc_dota_hero_bloodseeker = {
        index = 54,
        list = {
            "bloodseeker_blood_bath", "bloodseeker_bloodrage",
            "bloodseeker_thirst", "bloodseeker_rupture"
        }
    },
    npc_dota_hero_razor = {
        index = 55,
        list = {
            "razor_storm_surge", "razor_static_link", "razor_static_link_alt",
            "razor_plasma_field", "razor_eye_of_the_storm"
        }
    },
    npc_dota_hero_spectre = {
        index = 56,
        list = {
            "spectre_haunt", "spectre_haunt_single", "spectre_reality",
            "spectre_spectral_dagger", "spectre_dispersion",
            "spectre_shadow_step"
        }
    },
    npc_dota_hero_batrider = {
        index = 57,
        list = {
            "batrider_sticky_napalm", "batrider_flaming_lasso",
            "batrider_flamebreak", "batrider_firefly"
        }
    },
    npc_dota_hero_oracle = {
        index = 58,
        list = {
            "oracle_false_promise", "oracle_fates_edict", "oracle_fortunes_end",
            "oracle_purifying_flames"
        },
        agh = { "oracle_diviners_deck", "oracle_rain_of_destiny" }
    },
    npc_dota_hero_venomancer = {
        index = 59,
        list = {
            "venomancer_plague_ward",
            "venomancer_noxious_plague", "venomancer_venomous_gale",
            "venomancer_snakebite"
        },
        agh = "venomancer_latent_poison",
        hide = { "venomancer_poison_sting" }
    },
    npc_dota_hero_ancient_apparition = {
        index = 60,
        list = {
            "ancient_apparition_cold_feet", "ancient_apparition_chilling_touch",
            "ancient_apparition_ice_blast",
            "ancient_apparition_ice_blast_release",
            "ancient_apparition_ice_vortex"
        }
    },
    npc_dota_hero_tinker = {
        index = 61,
        list = {
            "tinker_laser", "tinker_keen_teleport",
            "tinker_march_of_the_machines", "tinker_rearm",
            "tinker_defense_matrix", "tinker_deploy_turrets"
        },
        agh = "tinker_warp_grenade"
    },
    npc_dota_hero_leshrac = {
        index = 62,
        list = {
            "leshrac_diabolic_edict", "leshrac_lightning_storm",
            "leshrac_pulse_nova", "leshrac_split_earth"
        },
        agh = "leshrac_greater_lightning_storm"
    },
    npc_dota_hero_death_prophet = {
        index = 63,
        list = {
            "death_prophet_spirit_siphon", "death_prophet_carrion_swarm",
            "death_prophet_silence", "death_prophet_exorcism"
        }
    },
    npc_dota_hero_furion = {
        index = 64,
        list = {
            "furion_teleportation", "furion_sprout", "furion_wrath_of_nature",
            "furion_force_of_nature"
        },
        agh = { "furion_curse_of_the_forest", "furion_summon_fey" }
    },
    npc_dota_hero_windrunner = {
        index = 65,
        list = {
            "windrunner_windrun", "windrunner_windrun_sylvan",
            "windrunner_shackleshot", "windrunner_powershot",
            "windrunner_focusfire"
        },
        agh = "windrunner_gale_force"
    },
    npc_dota_hero_chen = {
        index = 66,
        list = {
            "chen_penitence", "chen_holy_persuasion", "chen_hand_of_god",
            "chen_divine_favor", "chen_summon_convert_centaur",
            "chen_summon_convert_frog", "chen_summon_convert_hellbear",
            "chen_summon_convert_satyr", "chen_summon_convert_troll",
            "chen_summon_convert_wolf", "chen_test_of_faith",
            "chen_test_of_faith_teleport"
        },
        hide = { "chen_zealot" }
    },
    npc_dota_hero_dazzle = {
        index = 67,
        list = {
            "dazzle_shallow_grave", "dazzle_weave", "dazzle_shadow_wave",
            "dazzle_poison_touch", "dazzle_bad_juju", "dazzle_good_juju",
            "dazzle_nothl_projection_end", "dazzle_nothl_projection"
        }
    },
    npc_dota_hero_largo = {
        index = 68,
        list = {
            "largo_catchy_lick", "largo_croak_of_genius", "largo_frogstomp",
            "largo_amphibian_rhapsody_active", "largo_amphibian_rhapsody",
            "largo_song_double_time", "largo_song_double_time_rhythm",
            "largo_song_fight_song", "largo_song_fight_song_rhythm",
            "largo_song_good_vibrations", "largo_song_good_vibrations_rhythm"
        }
    },
    npc_dota_hero_riki = {
        index = 69,
        list = {
            "riki_smoke_screen", "riki_tricks_of_the_trade", "riki_backstab",
            "riki_blink_strike", "riki_permanent_invisibility"
        }
    },
    npc_dota_hero_queenofpain = {
        index = 70,
        list = {
            "queenofpain_blink", "queenofpain_shadow_strike",
            "queenofpain_sonic_wave", "queenofpain_scream_of_pain"
        }
    },
    npc_dota_hero_mirana = {
        index = 71,
        list = {
            "mirana_arrow", "mirana_invis", "mirana_leap", "mirana_starfall",
            "mirana_solar_flare"
        },
        hide = { "mirana_celestial_quiver" }
    },
    npc_dota_hero_morphling = {
        index = 72,
        list = {
            "morphling_adaptive_strike_agi", "morphling_waveform",
            "morphling_morph_agi", "morphling_morph_str",
            "morphling_morph_agi_secondary", "morphling_morph_replicate",
            "morphling_replicate"
        }
    },
    -- 天怒法师
    npc_dota_hero_skywrath_mage = {
        index = 73,
        list = {
            "skywrath_mage_arcane_bolt", "skywrath_mage_concussive_shot",
            "skywrath_mage_ancient_seal", "skywrath_mage_mystic_flare"
            -- "skywrath_mage_shield_of_the_scion",
            -- "skywrath_mage_staff_of_the_scion",
        },
        -- 要隐藏的技能
        hide = {
            "skywrath_mage_shield_of_the_scion",
            "skywrath_mage_staff_of_the_scion"
        }
    },
    npc_dota_hero_phoenix = {
        index = 74,
        list = {
            "phoenix_icarus_dive", "phoenix_fire_spirits", "phoenix_sun_ray",
            "phoenix_sun_ray_toggle_move", "phoenix_supernova"
        }
    },
    npc_dota_hero_earthshaker = {
        index = 75,
        list = {
            "earthshaker_fissure", "earthshaker_aftershock",
            "earthshaker_echo_slam", "earthshaker_enchant_totem"
        }
    },
    npc_dota_hero_mars = {
        index = 76,
        list = {
            "mars_spear", "mars_gods_rebuke", "mars_bulwark",
            "mars_arena_of_blood"
        }
    },
    npc_dota_hero_bristleback = {
        index = 77,
        list = {
            "bristleback_bristleback", "bristleback_quill_spray",
            "bristleback_viscous_nasal_goo", "bristleback_warpath"
        },
        agh = "bristleback_hairball"
    },
    npc_dota_hero_wisp = {
        index = 78,
        list = {
            "wisp_tether", "wisp_tether_break", "wisp_spirits",
            "wisp_spirits_in", "wisp_spirits_out", "wisp_overcharge",
            "wisp_relocate"
        }
    },
    npc_dota_hero_pugna = {
        index = 79,
        list = {
            "pugna_nether_blast", "pugna_decrepify", "pugna_nether_ward",
            "pugna_life_drain"
        }
    },
    npc_dota_hero_elder_titan = {
        index = 80,
        list = {
            "elder_titan_echo_stomp", "elder_titan_ancestral_spirit",
            "elder_titan_earth_splitter", "elder_titan_echo_stomp_secondary",
            "elder_titan_move_spirit", "elder_titan_natural_order",
            "elder_titan_natural_order_spirit", "elder_titan_return_spirit"
        }
    },
    npc_dota_hero_clinkz = {
        index = 81,
        list = {
            "clinkz_strafe", "clinkz_searing_arrows", "clinkz_death_pact",
            "clinkz_death_pact_secondary", "clinkz_wind_walk"
        },
        agh = { "clinkz_burning_army", "clinkz_burning_barrage" }
    },
    npc_dota_hero_pangolier = {
        index = 82,
        list = {
            "pangolier_swashbuckle", "pangolier_shield_crash",
            "pangolier_lucky_shot", "pangolier_gyroshell",
            "pangolier_gyroshell_stop", "pangolier_rollup_stop"
        },
        agh = "pangolier_rollup",
    },
    npc_dota_hero_night_stalker = {
        index = 83,
        list = {
            "night_stalker_void", "night_stalker_crippling_fear",
            "night_stalker_darkness",
            -- "night_stalker_hunter_in_the_night"
            "night_stalker_midnight_feast"
        },
        hide = { "night_stalker_hunter_in_the_night" }
    },
    npc_dota_hero_terrorblade = {
        index = 84,
        list = {
            "terrorblade_reflection", "terrorblade_conjure_image",
            "terrorblade_metamorphosis", "terrorblade_sunder"
        },
        agh = { "terrorblade_terror_wave", "terrorblade_demon_zeal" }
    },
    npc_dota_hero_crystal_maiden = {
        index = 85,
        list = {
            "crystal_maiden_crystal_nova", "crystal_maiden_frostbite",
            "crystal_maiden_brilliance_aura", "crystal_maiden_freezing_field",
            "crystal_maiden_freezing_field_alt1"
        },
        agh = { "crystal_maiden_crystal_clone" }
    },
    npc_dota_hero_dark_seer = {
        index = 86,
        list = {
            "dark_seer_vacuum", "dark_seer_surge", "dark_seer_ion_shell",
            "dark_seer_wall_of_replica"
        },
        agh = { "dark_seer_normal_punch" }
    },
    npc_dota_hero_shadow_shaman = {
        index = 87,
        list = {
            "shadow_shaman_ether_shock", "shadow_shaman_voodoo",
            "shadow_shaman_shackles", "shadow_shaman_mass_serpent_ward"
        },
        hide = { "shadow_shaman_fowl_play" },
        agh = { "shadow_shaman_urnaconda" }

    },
    npc_dota_hero_puck = {
        index = 88,
        list = {
            "puck_illusory_orb", "puck_waning_rift", "puck_ethereal_jaunt",
            "puck_dream_coil", "puck_phase_shift"
        }

    },
    npc_dota_hero_nevermore = {
        index = 89,
        list = {
            "nevermore_shadowraze1", "nevermore_shadowraze2",
            "nevermore_shadowraze3", "nevermore_frenzy", "nevermore_dark_lord",
            "nevermore_requiem"
        }

    },
    npc_dota_hero_alchemist = {
        index = 91,
        list = {
            "alchemist_acid_spray", "alchemist_unstable_concoction",
            "alchemist_unstable_concoction_throw",
            "alchemist_corrosive_weaponry", "alchemist_chemical_rage"
        },
        agh = { "alchemist_berserk_potion" }
    },
    npc_dota_hero_doom_bringer = {
        index = 92,
        list = {
            "doom_bringer_devour", "doom_bringer_scorched_earth",
            "doom_bringer_infernal_blade", "doom_bringer_empty2",
            "doom_bringer_empty1", "doom_bringer_doom",
            "doom_bringer_devour_secondary"
        }
    },
    npc_dota_hero_shredder = {
        index = 93,
        list = {
            "shredder_whirling_death", "shredder_timber_chain",
            "shredder_reactive_armor", "shredder_chakram",
            "shredder_twisted_chakram", "shredder_return_chakram",
            "shredder_return_chakram_2", "shredder_twisted_chakram"
        },
        agh = { "shredder_flamethrower" }
    },
    npc_dota_hero_antimage = {
        index = 94,
        list = {
            "antimage_mana_break", "antimage_blink", "antimage_spell_shield",
            "antimage_counterspell_ally", "antimage_mana_overload",
            "antimage_mana_void", "antimage_counterspell"
        }
    },
    npc_dota_hero_void_spirit = {
        index = 95,
        list = {
            "void_spirit_aether_remnant", "void_spirit_dissimilate",
            "void_spirit_resonant_pulse", "void_spirit_astral_step"
        }
    },
    npc_dota_hero_beastmaster = {
        index = 96,
        list = {
            "beastmaster_wild_axes", "beastmaster_call_of_the_wild",
            "beastmaster_call_of_the_wild_hawk", "beastmaster_primal_roar",
            "beastmaster_call_of_the_wild_boar",
            "beastmaster_summon_razorback", "beastmaster_summon_raptor"
        },
        agh = { "beastmaster_drums_of_slom", "beastmaster_drums_of_slom_stop" }
        -- hide = { "beastmaster_inner_beast" }
    },
    npc_dota_hero_monkey_king = {
        index = 97,
        list = {
            "monkey_king_boundless_strike", "monkey_king_jingu_mastery",
            "monkey_king_primal_spring", "monkey_king_tree_dance",
            "monkey_king_wukongs_command", "monkey_king_transfiguration"
        },
        hide = {
            "monkey_king_mischief",
            "monkey_king_untransform"
        }
    },
    -- 兽（魔晶：投掷岩石）
    npc_dota_hero_primal_beast = {
        index = 98,
        list = {
            "primal_beast_onslaught", "primal_beast_uproar",
            "primal_beast_trample", "primal_beast_pulverize"
        },
        agh = "primal_beast_rock_throw"
    },
    -- 土猫
    npc_dota_hero_earth_spirit = {
        index = 99,
        list = {
            "earth_spirit_boulder_smash", "earth_spirit_rolling_boulder",
            "earth_spirit_geomagnetic_grip", "earth_spirit_magnetize",
            "earth_spirit_petrify"
        },
        hide = {
            "earth_spirit_stone_caller"
        }
    },
    -- 冰龙
    npc_dota_hero_winter_wyvern = {
        index = 100,
        list = {
            "winter_wyvern_arctic_burn", "winter_wyvern_splinter_blast",
            "winter_wyvern_cold_embrace", "winter_wyvern_winters_curse"
        }
    },
    -- 蚂蚁
    npc_dota_hero_weaver = {
        index = 101,
        list = {
            "weaver_the_swarm", "weaver_shukuchi", "weaver_geminate_attack",
            "weaver_time_lapse"
        }
    },
    -- 火猫
    npc_dota_hero_ember_spirit = {
        index = 102,
        list = {
            "ember_spirit_searing_chains", "ember_spirit_sleight_of_fist",
            "ember_spirit_flame_guard", "ember_spirit_fire_remnant",
            "ember_spirit_activate_fire_remnant"
        }
    },
    -- 谜团
    npc_dota_hero_enigma = {
        index = 103,
        list = {
            "enigma_malefice", "enigma_demonic_conversion",
            "enigma_midnight_pulse", "enigma_black_hole"
        }
    },
    -- 蓝猫
    npc_dota_hero_storm_spirit = {
        index = 104,
        list = {
            "storm_spirit_static_remnant", "storm_spirit_electric_vortex",
            "storm_spirit_overload", "storm_spirit_ball_lightning"
        }
    },
    -- 不朽尸王
    npc_dota_hero_undying = {
        index = 105,
        tp = 1,
        list = {
            "undying_decay", "undying_soul_rip", "undying_tombstone",
            "undying_flesh_golem"
        },
        hide = { "undying_ceaseless_dirge" }
    },
    -- 巫医
    npc_dota_hero_witch_doctor = {
        index = 106,
        tp = 3,
        list = {
            "witch_doctor_paralyzing_cask", "witch_doctor_voodoo_restoration",
            "witch_doctor_maledict", "witch_doctor_death_ward"
        },
        agh = "witch_doctor_voodoo_switcheroo"
    },
    -- 混沌骑士
    npc_dota_hero_chaos_knight = {
        index = 107,
        tp = 1,
        list = {
            "chaos_knight_chaos_bolt", "chaos_knight_reality_rift",
            "chaos_knight_chaos_strike", "chaos_knight_phantasm"
        }
    },
    -- 圣堂刺客
    npc_dota_hero_templar_assassin = {
        index = 108,
        tp = 2,
        list = {
            "templar_assassin_refraction", "templar_assassin_meld",
            "templar_assassin_psi_blades", "templar_assassin_psionic_trap",
            "templar_assassin_trap", "templar_assassin_trap_teleport"
        },
        agh = "templar_assassin_trap_teleport"
    },
    -- 森海飞霞
    npc_dota_hero_hoodwink = {
        index = 109,
        tp = 2,
        list = {
            "hoodwink_acorn_shot", "hoodwink_bushwhack", "hoodwink_scurry",
            "hoodwink_sharpshooter", "hoodwink_sharpshooter_release"
        },
        agh = { "hoodwink_decoy", "hoodwink_hunters_boomerang" }
    },
    -- 巫妖
    npc_dota_hero_lich = {
        index = 110,
        tp = 3,
        list = {
            "lich_frost_nova", "lich_sinister_gaze",
            "lich_frost_shield", "lich_chain_frost",
        },
        hide = { "lich_ice_spire", "lich_death_charge" },
        agh = "lich_ice_spire"
    },
    -- 小小
    npc_dota_hero_tiny = {
        index = 111,
        tp = 1,
        list = {
            "tiny_avalanche", "tiny_toss", "tiny_tree_grab", "tiny_grow", "tiny_toss_tree"
        },
        agh = "tiny_tree_channel"
    }
}
