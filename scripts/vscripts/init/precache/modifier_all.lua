--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 本文件仅为 LinkLuaModifier / require 注册，非 modifier 类脚本，不需要 IsServer。
function ClrbLinkAllLuaModifiers()
    -- 人机 modifier最先注册，避免后续 require 失败或未跑完时 AddNewModifier 报 unknown（与 ingame.BotAI.BotAI / BotAI.Func 一致）
    LinkLuaModifier("modifier_bot_innate_mana_regen", "ingame/modifier/modifier_bot_innate_mana_regen",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_bot_innate_level_base_attack",
        "ingame/modifier/modifier_bot_innate_level_base_attack", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("wd_nobar", "ingame/modifier/wd_nobar", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_anchor", "ingame/modifier/modifier_anchor",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_petbuff", "ingame/modifier/modifier_petbuff",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_title", "ingame/modifier/modifier_clrb_title",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_effect", "ingame/modifier/modifier_clrb_effect",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_m_1_6_flux_attack",
        "ingame/Monster/ability_m_1_6_flux",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_m_1_6_flux",
        "ingame/Monster/ability_m_1_6_flux",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_pet_ambient", "ingame/modifier/modifier_clrb_pet_ambient",
        LUA_MODIFIER_MOTION_NONE)
    require("ingame.modifier.clrb_fly_cloud_util")
    LinkLuaModifier("modifier_clrb_fly_cloud", "ingame/modifier/modifier_clrb_fly_cloud",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_wudi", "ingame/modifier/modifier_wudi",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_run", "ingame/modifier/modifier_run",
        LUA_MODIFIER_MOTION_NONE)
    require("ingame.modifier.modifier_clrb_talents")
    LinkLuaModifier("modifier_clrb_stun", "ingame/modifier/modifier_clrb_talents",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_insight_parry_stun", "ingame/modifier/modifier_clrb_talents",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_invuln", "ingame/modifier/modifier_clrb_talents",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_door_teleport_invuln", "ingame/modifier/modifier_clrb_talents",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_ethereal_root", "ingame/modifier/modifier_clrb_talents",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_soul_chain_victim", "ingame/modifier/modifier_clrb_soul_chain",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_insight", "ingame/modifier/modifier_clrb_insight",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_talent_5_vision", "ingame/modifier/modifier_clrb_talent_5_vision",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_rbzf_death_allstats",
        "ingame/modifier/modifier_clrb_rbzf_death_allstats",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_1", "ingame/modifier/modifier_talent_skill_1",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_2", "ingame/modifier/modifier_talent_skill_2",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_3", "ingame/modifier/modifier_talent_skill_3",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_4", "ingame/modifier/modifier_talent_skill_4",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_5", "ingame/modifier/modifier_talent_skill_5",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_5_buff", "ingame/modifier/modifier_talent_skill_5",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_6", "ingame/modifier/modifier_talent_skill_6",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_7", "ingame/modifier/modifier_talent_skill_7",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_8", "ingame/modifier/modifier_talent_skill_8",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_9", "ingame/modifier/modifier_talent_skill_9",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_skill_3_slide", "ingame/modifier/modifier_talent_skill_3_slide",
        LUA_MODIFIER_MOTION_NONE)
    require("ingame.modifier.modifier_clrb_lhzf")
    LinkLuaModifier("modifier_clrb_lhzf", "ingame/modifier/modifier_clrb_lhzf",
        LUA_MODIFIER_MOTION_NONE)
    require("ingame.modifier.modifier_clrb_hero_balance")
    LinkLuaModifier("modifier_clrb_hero_balance", "ingame/modifier/modifier_clrb_hero_balance",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_combat_boost", "ingame/modifier/modifier_clrb_combat_boost",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_int_spell_amp", "ingame/modifier/modifier_clrb_int_spell_amp",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_yinshen", "ingame/modifier/modifier_yinshen",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_tool_autoattack",
        "ingame/modifier/modifier_tool_autoattack",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_equip_2", "ingame/modifier/modifier_equip_2",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_init_buff", "ingame/modifier/modifier_init_buff",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_stillkill", "ingame/modifier/modifier_stillkill",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_killten", "ingame/modifier/modifier_killten",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_lqjs", "ingame/modifier/modifier_lqjs",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_box_27", "ingame/modifier/modifier_box_27",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_box_28", "ingame/modifier/modifier_box_28",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_box_36", "ingame/modifier/modifier_box_36",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_box_42", "ingame/modifier/modifier_box_42",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_box_47", "ingame/modifier/modifier_box_47",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_box_48", "ingame/modifier/modifier_box_48",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_item_spell_prism",
        "ingame/modifier/modifier_item_spell_prism",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_custom_armor_speed_buff",
        "ingame/modifier/modifier_custom_armor_speed_buff",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_goods_25", "ingame/modifier/modifier_goods_25",
        LUA_MODIFIER_MOTION_NONE)

    LinkLuaModifier("modifier_ability_26_buff",
        "ingame/modifier/modifier_ability_26_buff",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_addstate", "ingame/modifier/modifier_addstate",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_zyfw", "ingame/modifier/modifier_zyfw",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_armor_pierce_test",
        "ingame/modifier/modifier_armor_pierce_test",
        LUA_MODIFIER_MOTION_NONE)

    LinkLuaModifier("modifier_boss_1_buff",
        "ingame/modifier/modifier_boss_1_buff",
        LUA_MODIFIER_MOTION_NONE)

    LinkLuaModifier("modifier_dragon_hp30_invuln",
        "ingame/modifier/modifier_dragon_hp30_invuln",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_dragon_magic_immune",
        "ingame/modifier/modifier_dragon_magic_immune",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_tyx_terrain",
        "ingame/modifier/modifier_clrb_tyx_terrain",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_clrb_item_trident_cast_speed",
        "ingame/modifier/modifier_clrb_item_trident_cast_speed",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_testtank", "ingame/modifier/modifier_testtank",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_generic_arc", "ingame/modifier/modifier_generic_arc",
        LUA_MODIFIER_MOTION_BOTH)
    LinkLuaModifier("modifier_attack_effect", "ingame/modifier/modifier_attack_effect", LUA_MODIFIER_MOTION_NONE)

end

ClrbLinkAllLuaModifiers()