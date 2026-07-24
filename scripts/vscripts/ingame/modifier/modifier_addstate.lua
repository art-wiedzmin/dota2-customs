--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_addstate = class({})

function modifier_addstate:IsHidden() return true end

function modifier_addstate:IsPurgable() return false end

function modifier_addstate:OnCreated()
    if IsServer() then
        -- print("modifier 已创建")
    end
end

function modifier_addstate:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_AOE_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_AOE_BONUS_CONSTANT,
        MODIFIER_PROPERTY_AOE_BONUS_CONSTANT_STACKING,
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_PROPERTY_SLOW_RESISTANCE_UNIQUE
    }
end

--加状态抗性
function modifier_addstate:GetModifierStatusResistance()
    return 20
end

--减速抗性
function modifier_addstate:GetModifierSlowResistance_Unique()
    return 20
end

--加作用范围
function modifier_addstate:GetModifierAOEBonusPercentage()
    return 100
end

function modifier_addstate:GetModifierAOEBonusConstant()
    return 100
end

function modifier_addstate:GetModifierAOEBonusConstantStacking()
    return 100
end
