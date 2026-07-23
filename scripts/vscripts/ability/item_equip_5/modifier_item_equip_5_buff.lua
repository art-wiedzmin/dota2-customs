modifier_item_equip_5_buff = class({})

function modifier_item_equip_5_buff:IsHidden() return true end
function modifier_item_equip_5_buff:IsDebuff() return false end
function modifier_item_equip_5_buff:IsPurgable() return false end
function modifier_item_equip_5_buff:RemoveOnDeath() return false end

local function is_item_in_active_inventory(item_ability)
    if not item_ability or item_ability:IsNull() then return false end
    if not item_ability.GetItemSlot then return true end

    if item_ability.GetParent then
        local holder = item_ability:GetParent()
        if holder and not holder:IsNull() and holder:GetUnitName() == "dummy" then
            return true
        end
    end

    local slot = item_ability:GetItemSlot()
    if slot == nil then return true end
    if slot == 16 then return true end
    return slot >= 0 and slot <= 5
end

function modifier_item_equip_5_buff:IsEnabled()
    return is_item_in_active_inventory(self:GetAbility())
end

function modifier_item_equip_5_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }
end

function modifier_item_equip_5_buff:GetModifierBonusStats_Strength()
    if not self:IsEnabled() then return 0 end
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_equip_5_buff:GetModifierBonusStats_Agility()
    if not self:IsEnabled() then return 0 end
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_equip_5_buff:GetModifierBonusStats_Intellect()
    if not self:IsEnabled() then return 0 end
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_equip_5_buff:GetModifierHealthBonus()
    if not self:IsEnabled() then return 0 end
    return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_equip_5_buff:GetModifierManaBonus()
    if not self:IsEnabled() then return 0 end
    return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_equip_5_buff:GetModifierCastRangeBonus()
    if not self:IsEnabled() then return 0 end
    return self:GetAbility():GetSpecialValueFor("cast_range_bonus")
end

function modifier_item_equip_5_buff:OnCreated()
    if not IsServer() then
        return
    end
    self._en_snap = self:IsEnabled()
    self:StartIntervalThink(0.75)
end

function modifier_item_equip_5_buff:OnIntervalThink()
    if not IsServer() then return end
    local en = self:IsEnabled()
    if en == self._en_snap then return end
    self._en_snap = en
    local p = self:GetParent()
    if p and not p:IsNull() and p:IsHero() then
        p:CalculateStatBonus(true)
    end
end
