-- 攻击者modifier
modifier_ability_item_35 = class({})

-- 满级（10 级）才突破移速上限；突破后 MODIFIER_PROPERTY_MOVESPEED_LIMIT 生效值
local M35_MS_BREAK_LEVEL = 10
local M35_MS_CAP = 750

local function m35_passives_disabled(parent)
    if not parent or parent:IsNull() or type(parent.PassivesDisabled) ~= "function" then
        return false
    end
    return parent:PassivesDisabled()
end

function modifier_ability_item_35:IsHidden()
    return true
end

function modifier_ability_item_35:IsPurgable()
    return false
end

function modifier_ability_item_35:OnCreated()
    if not IsServer() then return end
    local hero = self:GetParent()
    local ability = self:GetAbility()
end

-- 声明修改函数
function modifier_ability_item_35:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_SLOW_RESISTANCE_UNIQUE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT
    }
end

function modifier_ability_item_35:GetModifierStatusResistanceStacking()
    if m35_passives_disabled(self:GetParent()) then
        return 0
    end
    local ability = self:GetAbility()
    if not ability then return 0 end
    return ability:GetSpecialValueFor("num1")
end

function modifier_ability_item_35:GetModifierSlowResistance_Unique()
    if m35_passives_disabled(self:GetParent()) then
        return 0
    end
    local ability = self:GetAbility()
    if not ability then return 0 end -- 先判断 ability 是否存在
    return ability:GetSpecialValueFor("num2")
end

-- 仅 10 级后突破默认移速上限
function modifier_ability_item_35:GetModifierIgnoreMovespeedLimit()
    if m35_passives_disabled(self:GetParent()) then
        return 0
    end
    local ability = self:GetAbility()
    if not ability or ability:GetLevel() < M35_MS_BREAK_LEVEL then
        return 0
    end
    return 1
end

function modifier_ability_item_35:GetModifierMoveSpeed_Limit()
    if m35_passives_disabled(self:GetParent()) then
        return 550
    end
    local ability = self:GetAbility()
    if not ability or ability:GetLevel() < M35_MS_BREAK_LEVEL then
        return 550
    end
    return M35_MS_CAP
end
