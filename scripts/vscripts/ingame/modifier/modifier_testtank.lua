--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if modifier_testtank == nil then
    modifier_testtank = class({})
end
function modifier_testtank:IsDebuff()
    return false
end

function modifier_testtank:IsHidden()
    return false
end

function modifier_testtank:RemoveOnDeath()
    return false
end

function modifier_testtank:OnCreated(kv)
    if not IsServer() then return end
end

function modifier_testtank:OnDestroy()
    if not IsServer() then return end
end

function modifier_testtank:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true, -- 缴械 不能普攻
    }
    return state
end

function modifier_testtank:DeclareFunctions()
    local funcs = {
        --MODIFIER_PROPERTY_MIN_HEALTH
    }
    return funcs
end
