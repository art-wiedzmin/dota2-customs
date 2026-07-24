--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 文件名：modifier_wd.lua
modifier_wd = class({})

-- 基础配置
function modifier_wd:IsHidden()
    return false -- 隐藏状态栏显示图标
end

function modifier_wd:IsDebuff()
    return false
end

function modifier_wd:IsPurgable()
    return false -- 不可被驱散
end

function modifier_wd:RemoveOnDeath()
    return false
end

function modifier_wd:AllowIllusionDuplicate()
    return false
end

function modifier_wd:OnCreated(kv)
    if IsServer() then

    end
end

-- 覆盖免疫属性
function modifier_wd:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING, -- 状态抗性
        MODIFIER_PROPERTY_HEALTH_BONUS,               -- 生命值增益
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,   --移动速度
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end

-- 获取状态抗性增益
function modifier_wd:GetModifierStatusResistanceStacking()
    return 100
end

-- 获取生命值增益
function modifier_wd:GetModifierHealthBonus()
    return 99999
end

function modifier_wd:GetModifierMoveSpeedBonus_Constant()
    return 9000
end

function modifier_wd:GetModifierBaseAttack_BonusDamage()
    return 99999
end

function modifier_wd:GetModifierAttackSpeedBonus_Constant()
    return 9999
end

function modifier_wd:GetModifierMoveSpeed_Limit()
    return 2000
end

function modifier_wd:GetModifierMoveSpeedMax_BonusConstant()
    return 9000
end

function modifier_wd:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_wd:GetModifierHealthRegenPercentage() return 10 end

function modifier_wd:CheckState()
    return {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end