--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_weather_1 = class({})

--是否在面板上显示
function modifier_weather_1:IsHidden()
    return false
end

function modifier_weather_1:IsDebuff()
    return false
end

function modifier_weather_1:IsPurgable()
    return false -- 不可被驱散
end

function modifier_weather_1:RemoveOnDeath()
    return false
end

function modifier_weather_1:GetTexture()
    return "scroll/weather_fx_psd"
end

function modifier_weather_1:AllowIllusionDuplicate()
    return false
end

--艳阳
--创建时设置
function modifier_weather_1:OnCreated(kv)
    if not IsServer() then return end
    self:SetDuration(kv.dur, true)
end

-- 全图天气粒子由 MainGame:WeatherStar 单点挂载，此处不再叠英雄身上特效

-- 声明修改函数
function modifier_weather_1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
end

function modifier_weather_1:GetModifierBaseDamageOutgoing_Percentage()
    return 30
end

-- 获取技能增强百分比
function modifier_weather_1:GetModifierSpellAmplify_Percentage()
    return 15
end
