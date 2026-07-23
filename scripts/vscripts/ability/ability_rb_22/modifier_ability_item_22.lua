--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_22 = class({})

local function m22_passives_disabled(parent)
    if not parent or parent:IsNull() or type(parent.PassivesDisabled) ~= "function" then
        return false
    end
    return parent:PassivesDisabled()
end

function modifier_ability_item_22:IsHidden()
    return true
end

function modifier_ability_item_22:IsPurgable()
    return false
end

function modifier_ability_item_22:OnCreated()
    if not IsServer() then return end
    -- 可以在这里预计算数值以提高性能
    self.magic_resist_bonus = self:CalculateMagicResistanceBonus()
end

-- 声明修改函数
function modifier_ability_item_22:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_ability_item_22:GetModifierMagicalResistanceBonus()
    if m22_passives_disabled(self:GetParent()) then
        return 0
    end
    -- 移除服务器检查，客户端也需要这个值
    if IsServer() then
        -- 服务器端使用预计算的值（如果存在）
        if self.magic_resist_bonus then
            return self.magic_resist_bonus
        end
    end

    return self:CalculateMagicResistanceBonus()
end

-- 计算魔法抗性加成
function modifier_ability_item_22:CalculateMagicResistanceBonus()
    if m22_passives_disabled(self:GetParent()) then
        return 0
    end
    local ability = self:GetAbility()
    if not ability then
        return 0 -- 必须返回默认值
    end

    return ability:GetSpecialValueFor("num1")
end

-- 可选：添加刷新时重新计算
function modifier_ability_item_22:OnRefresh()
    if not IsServer() then return end
    self.magic_resist_bonus = self:CalculateMagicResistanceBonus()
end