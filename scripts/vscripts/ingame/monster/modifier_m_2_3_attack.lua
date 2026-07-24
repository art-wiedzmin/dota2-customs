--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_m_2_3_attack", "ingame/Monster/modifier_m_2_3_attack", LUA_MODIFIER_MOTION_NONE)

modifier_m_2_3_attack = class({})

local PROJECTILE = "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf"

function modifier_m_2_3_attack:IsHidden()
    return true
end

function modifier_m_2_3_attack:IsPurgable()
    return false
end

function modifier_m_2_3_attack:RemoveOnDeath()
    return false
end

function modifier_m_2_3_attack:DeclareFunctions()
    return { MODIFIER_PROPERTY_PROJECTILE_NAME }
end

function modifier_m_2_3_attack:GetModifierProjectileName()
    return PROJECTILE
end
