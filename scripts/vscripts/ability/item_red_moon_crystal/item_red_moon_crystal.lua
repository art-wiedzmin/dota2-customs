--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_item_red_moon_crystal_buff",
    "Ability/item_red_moon_crystal/modifier_item_red_moon_crystal_buff",
    LUA_MODIFIER_MOTION_NONE)

if item_red_moon_crystal == nil then
    item_red_moon_crystal = class({})
end

function item_red_moon_crystal:GetIntrinsicModifierName()
    return "modifier_item_red_moon_crystal_buff"
end

function item_red_moon_crystal:OnChargeCountChanged(_kv)
end