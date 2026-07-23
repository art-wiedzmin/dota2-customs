--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 光环效果modifier
modifier_ability_item_5_effect = class({})

-- 初始化
function modifier_ability_item_5_effect:OnCreated()
    if not IsServer() then return end
    -- 强制刷新属性
    self:ForceRefresh()
end

-- 刷新
function modifier_ability_item_5_effect:OnRefresh()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_5_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_ability_item_5_effect:GetModifierPhysicalArmorBonus()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    return -ability:GetSpecialValueFor("num1")
end

-- 是否隐藏
function modifier_ability_item_5_effect:IsHidden()
    return false
end

-- 是否可驱散
function modifier_ability_item_5_effect:IsPurgable()
    return false
end

function modifier_ability_item_5_effect:effectName()
    return "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf"
end