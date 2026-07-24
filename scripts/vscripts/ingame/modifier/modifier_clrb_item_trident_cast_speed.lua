--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 三元重戟：Valve 原生 modifier_item_trident 未实现 cast_speed_pct；魔法攻击跳字与金箍棒同款
if modifier_clrb_item_trident_cast_speed == nil then
    modifier_clrb_item_trident_cast_speed = class({})
end

local CAST_SPEED_PCT = 30
local MAGIC_ATTACK_DAMAGE = 30

function modifier_clrb_item_trident_cast_speed:IsHidden()
    return true
end

function modifier_clrb_item_trident_cast_speed:IsDebuff()
    return false
end

function modifier_clrb_item_trident_cast_speed:IsPurgable()
    return false
end

function modifier_clrb_item_trident_cast_speed:RemoveOnDeath()
    return false
end

function modifier_clrb_item_trident_cast_speed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_clrb_item_trident_cast_speed:GetModifierPercentageCasttime()
    return CAST_SPEED_PCT
end

function modifier_clrb_item_trident_cast_speed:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    local attacker = params.attacker
    if attacker ~= self:GetParent() then
        return
    end
    if not attacker:IsHero() then
        return
    end
    local target = params.target
    if not target or target:IsNull() or not target:IsAlive() then
        return
    end
    if target:GetTeamNumber() == attacker:GetTeamNumber() then
        return
    end
    if target:IsBuilding() or target:IsCourier() then
        return
    end
    utilex:UnitDam(attacker, target, MAGIC_ATTACK_DAMAGE, "mf", nil, true)
end
