--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if BotAI == nil then
    BotAI = class({})

    -- 与 init.precache.modifier_all 重复注册无害；避免仅 rawget 失败时静默跳过导致 unknown modifier
    LinkLuaModifier("modifier_bot_innate_mana_regen", "ingame/modifier/modifier_bot_innate_mana_regen",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_bot_innate_level_base_attack",
        "ingame/modifier/modifier_bot_innate_level_base_attack", LUA_MODIFIER_MOTION_NONE)

    BotAI.Data = BotAI.Data or {}

    require("ingame.BotAI.Config")
    require("ingame.BotAI.Func")
end
