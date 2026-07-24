-- 光环效果modifier
modifier_ability_item_7_effect = class({})

-- 初始化
function modifier_ability_item_7_effect:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(1.0)
    -- 强制刷新属性
    self:ForceRefresh()
end

function modifier_ability_item_7_effect:OnIntervalThink()
    if not IsServer() then return end
    local hero = self:GetParent()
    local ability = self:GetAbility()
    if not hero or hero:IsNull() or not hero:IsAlive() then return end
    if not ability or ability:IsNull() then return end
    local pct = ability:GetSpecialValueFor("num3")
    hero:Heal(hero:GetMaxHealth() * pct * 0.01, nil)
end

-- 刷新
function modifier_ability_item_7_effect:OnRefresh()
    if not IsServer() then return end
end

--MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
-- 声明修改函数
function modifier_ability_item_7_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT

    }
end

function modifier_ability_item_7_effect:GetModifierConstantHealthRegen()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    return ability:GetSpecialValueFor("num1")
end

-- MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE → 必须此名（勿写成 LifestealRegen…）
function modifier_ability_item_7_effect:GetModifierLifestealAmplify_Percentage()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    return ability:GetSpecialValueFor("num2")
end

-- 是否隐藏
function modifier_ability_item_7_effect:IsHidden()
    return false
end

-- 是否可驱散
function modifier_ability_item_7_effect:IsPurgable()
    return false
end
