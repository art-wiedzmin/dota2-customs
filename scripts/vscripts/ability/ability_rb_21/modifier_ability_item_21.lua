-- 技能modifier
modifier_ability_item_21 = class({})

function modifier_ability_item_21:IsHidden()
    return true
end

function modifier_ability_item_21:IsPurgable()
    return false
end

function modifier_ability_item_21:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_21:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

--绿字 智力加成%+智力增幅%+智力常数（AbilityValues.num1）
function modifier_ability_item_21:GetModifierBonusStats_Intellect()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then return 0 end
    return ability:GetSpecialValueFor("num1")
end
