--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_weather_4_buff = class({})

-- 是否在面板上显示
function modifier_weather_4_buff:IsHidden() return true end

function modifier_weather_4_buff:IsDebuff() return true end

function modifier_weather_4_buff:IsPurgable()
    return true -- 不可被驱散
end

function modifier_weather_4_buff:RemoveOnDeath() return true end

function modifier_weather_4_buff:GetTexture() return "scroll/weather_snow_png" end

-- 创建时设置
function modifier_weather_4_buff:OnCreated(kv)
    if not IsServer() then return end
    self:SetDuration(kv.dur, true)
end

function modifier_weather_4_buff:DeclareFunctions()
    return {
        -- MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE_UNIQUE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- 攻击速度
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE -- 移动速度加成
    }
end

-- 获取攻击速度常数增益
function modifier_weather_4_buff:GetModifierAttackSpeedBonus_Constant()
    return -60
end

function modifier_weather_4_buff:GetModifierMoveSpeedBonus_Percentage()
    return -25
end

-- 减少 30% 生命回复
-- function modifier_weather_4_buff:GetModifierHealthRegenPercentageUnique()
--     return -30
-- end
