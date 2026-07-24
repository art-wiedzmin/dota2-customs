--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 光环效果modifier
modifier_ability_item_11_effect = class({})

-- 初始化
function modifier_ability_item_11_effect:OnCreated()
    if not IsServer() then return end
    -- 强制刷新属性
    self:ForceRefresh()
end

-- 刷新
function modifier_ability_item_11_effect:OnRefresh()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_11_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_ability_item_11_effect:GetModifierMagicalResistanceBonus()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    return -ability:GetSpecialValueFor("num1")
end

-- 是否隐藏
function modifier_ability_item_11_effect:IsHidden()
    return false
end

-- 是否可驱散
function modifier_ability_item_11_effect:IsPurgable()
    return false
end