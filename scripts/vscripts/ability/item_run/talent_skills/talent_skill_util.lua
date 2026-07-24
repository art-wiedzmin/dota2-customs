--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local M = {}

function M.find_blink_target(caster, radius)
    local team = caster:GetTeamNumber()
    local pos = caster:GetAbsOrigin()
    local units = FindUnitsInRadius(
        team,
        pos,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_CLOSEST,
        false
    )
    for _, u in ipairs(units or {}) do
        if u and not u:IsNull() and u:IsAlive() and not u:IsInvulnerable() then
            return u
        end
    end
    return nil
end

--- 最近敌方英雄（含魔免），用于缚魂等
function M.find_nearest_enemy_hero(caster, radius)
    local team = caster:GetTeamNumber()
    local pos = caster:GetAbsOrigin()
    local units = FindUnitsInRadius(
        team,
        pos,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )
    for _, u in ipairs(units or {}) do
        if u and not u:IsNull() and u:IsAlive() and not u:IsInvulnerable() then
            return u
        end
    end
    return nil
end

function M.find_soul_snare_target(caster, radius)
    local team = caster:GetTeamNumber()
    local pos = caster:GetAbsOrigin()
    local units = FindUnitsInRadius(
        team,
        pos,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )
    for _, u in ipairs(units or {}) do
        if u and not u:IsNull() and u:IsAlive() and not u:IsMagicImmune() then
            return u
        end
    end
    return nil
end

return M