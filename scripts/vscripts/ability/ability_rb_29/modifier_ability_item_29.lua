-- 技能modifier
modifier_ability_item_29 = class({})

function modifier_ability_item_29:IsHidden()
    return true
end

function modifier_ability_item_29:IsPurgable()
    return false
end

function modifier_ability_item_29:OnCreated()
    if not IsServer() then return end
end
