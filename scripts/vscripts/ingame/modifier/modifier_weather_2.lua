--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_weather_2 = class({})

--是否在面板上显示
function modifier_weather_2:IsHidden()
    return false
end

function modifier_weather_2:IsDebuff()
    return false
end

function modifier_weather_2:IsPurgable()
    return false -- 不可被驱散
end

function modifier_weather_2:RemoveOnDeath()
    return false
end

function modifier_weather_2:GetTexture()
    return "scroll/weather_pestilence_png"
end

function modifier_weather_2:AllowIllusionDuplicate()
    return false
end

--狂风
--创建时设置
function modifier_weather_2:OnCreated(kv)
    if not IsServer() then return end
    self:SetDuration(kv.dur, true)
end

function modifier_weather_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --攻击速度
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, --移动速度加成
    }
end

-- 获取攻击速度常数增益
function modifier_weather_2:GetModifierAttackSpeedBonus_Constant()
    return 60
end

function modifier_weather_2:GetModifierMoveSpeedBonus_Percentage()
    return 10
end
