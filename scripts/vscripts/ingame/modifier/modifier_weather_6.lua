--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 雷霆降世：受伤 +15%（天气之子 modifier_weather_5 免疫，由 MainGame 施加时跳过）
modifier_weather_6 = class({})

local INCOMING_DMG_PCT = 15

function modifier_weather_6:IsHidden()
    return false
end

function modifier_weather_6:IsDebuff()
    return true
end

function modifier_weather_6:IsPurgable()
    return false
end

function modifier_weather_6:RemoveOnDeath()
    return false
end

function modifier_weather_6:GetTexture()
    return "scroll/weather_6"
end

function modifier_weather_6:AllowIllusionDuplicate()
    return false
end

function modifier_weather_6:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:SetDuration(kv.dur, true)
end

function modifier_weather_6:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_weather_6:GetModifierIncomingDamage_Percentage()
    return INCOMING_DMG_PCT
end

function modifier_weather_6:OnTooltip()
    return INCOMING_DMG_PCT
end
