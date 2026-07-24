--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_weather_3 = class({})

-- 是否在面板上显示
function modifier_weather_3:IsHidden() return false end

function modifier_weather_3:IsDebuff() return false end

function modifier_weather_3:IsPurgable()
    return false -- 不可被驱散
end

function modifier_weather_3:RemoveOnDeath() return false end

function modifier_weather_3:GetTexture() return "scroll/weather_fx_2_psd" end

function modifier_weather_3:AllowIllusionDuplicate() return false end

function modifier_weather_3:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end

-- 雨露：获得 3% 生命值回复（按最大生命值每秒回复）
function modifier_weather_3:GetModifierHealthRegenPercentage() return 3 end

-- 创建时设置
function modifier_weather_3:OnCreated(kv)
    if not IsServer() then return end
    self:SetDuration(kv.dur, true)
end
