--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if wd_nobar == nil then
    wd_nobar = class({})
end
function wd_nobar:IsDebuff()
    return false
end

function wd_nobar:IsHidden()
    return false
end

function wd_nobar:RemoveOnDeath()
    return true
end

function wd_nobar:OnCreated(kv)
    if not IsServer() then return end
end

function wd_nobar:OnIntervalThink()
    if not IsServer() then
        return
    end
end

function wd_nobar:OnDestroy()
end

function wd_nobar:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, -- 无视单位碰撞
    }
    return state
end

function wd_nobar:DeclareFunctions()
    local funcs = {
        --MODIFIER_PROPERTY_MIN_HEALTH
    }
    return funcs
end

function wd_nobar:GetStatusEffectName()
    return
end

