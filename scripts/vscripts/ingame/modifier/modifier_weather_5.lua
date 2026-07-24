--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_weather_5 = class({})
-- 合成后已移除 modifier_weather_4，须在本文件再次注册，否则寒霜 debuff 可能未 Link、OnAttackLanded 加不上
LinkLuaModifier("modifier_weather_4_buff",
    "ingame/modifier/modifier_weather_4_buff",
    LUA_MODIFIER_MOTION_NONE)

--是否在面板上显示
function modifier_weather_5:IsHidden()
    return false
end

function modifier_weather_5:IsDebuff()
    return false
end

function modifier_weather_5:IsPurgable()
    return false -- 不可被驱散
end

function modifier_weather_5:RemoveOnDeath()
    return false
end

function modifier_weather_5:GetTexture()
    return "scroll/weather_moonbeam_png"
end

function modifier_weather_5:AllowIllusionDuplicate()
    return false
end

--艳阳
--创建时设置
function modifier_weather_5:OnCreated(kv)
    if not IsServer() then return end
    self:SetDuration(kv.dur, true)
    local pa = self:GetParent()
    -- 全属性用绿字（bonus），移除 modifier 时由引擎收回；勿用 Modify*改白字
    pa:RemoveModifierByName("modifier_weather_1")
    pa:RemoveModifierByName("modifier_weather_2")
    pa:RemoveModifierByName("modifier_weather_3")
    pa:RemoveModifierByName("modifier_weather_4")
    pa:RemoveModifierByName("modifier_weather_6")
end

function modifier_weather_5:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --攻击速度
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, --移动速度加成
        -- 雨露（modifier_weather_3）：与原版一致用生命回复百分比，避免 Heal() 在治疗过滤/引擎路径下不生效
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        -- 艳阳（modifier_weather_1）被移除后需在本 modifier 内保留同等加成，否则合成后伤害/法强会“失效”
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,              -- 攻击命中时
    }
end

function modifier_weather_5:GetModifierBonusStats_Strength()
    return 30
end

function modifier_weather_5:GetModifierBonusStats_Agility()
    return 30
end

function modifier_weather_5:GetModifierBonusStats_Intellect()
    return 30
end

function modifier_weather_5:GetModifierHealthRegenPercentage()
    return 3
end

function modifier_weather_5:GetModifierBaseDamageOutgoing_Percentage()
    return 30
end

function modifier_weather_5:GetModifierSpellAmplify_Percentage()
    return 15
end

-- 获取攻击速度常数增益
function modifier_weather_5:GetModifierAttackSpeedBonus_Constant()
    return 60
end

function modifier_weather_5:GetModifierMoveSpeedBonus_Percentage()
    return 10
end

function modifier_weather_5:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.attacker ~= self:GetParent() then return end
    local ca = self:GetParent()
    local ta = keys.target
    if not ta or ta:IsNull() or not ta:IsBaseNPC() or not ta:IsAlive() then return end
    -- ability 传 nil：部分环境下用修饰器作 inflictor 会导致寒霜 debuff 加不上
    ta:AddNewModifier(ca, nil, "modifier_weather_4_buff", { dur = 2 })
end
