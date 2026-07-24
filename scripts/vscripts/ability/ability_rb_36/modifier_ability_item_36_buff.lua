-- 烧灼debuff效果
modifier_ability_item_36_buff = class({})

function modifier_ability_item_36_buff:IsHidden() return false end

function modifier_ability_item_36_buff:IsPurgable() return true end

function modifier_ability_item_36_buff:IsDebuff() return true end

function modifier_ability_item_36_buff:OnCreated(kv)
    if not IsServer() then return end
    self:StartIntervalThink(1)
    -- 设置持续时间
    self:SetDuration(4, true)
end

function modifier_ability_item_36_buff:OnRefresh()
    if not IsServer() then return end
    -- 刷新持续时间
    self:SetDuration(4, true)
end

function modifier_ability_item_36_buff:OnIntervalThink()
    if not IsServer() then return end

    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    if not parent or parent:IsNull() or not parent:IsAlive() then
        self:Destroy()
        return
    end
    if not ability or ability:IsNull() then
        self:Destroy()
        return
    end
    local hp_pct = ability:GetSpecialValueFor("num3")
    local base = ability:GetSpecialValueFor("num2")
    local max_hp = parent:GetMaxHealth()
    local burn_damage = max_hp * (hp_pct / 100) + base
    if burn_damage > 0 then
        -- 造成烧灼伤害
        local damage_table = {
            victim = parent,
            attacker = caster,
            damage = burn_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability,
            damage_flags = DOTA_DAMAGE_FLAG_NONE
        }
        ApplyDamage(damage_table)

        -- 显示较小的伤害数字（用不同的颜色）
        -- SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, parent, math.floor(burn_damage), nil)
    end
end

function modifier_ability_item_36_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
    }
end

function modifier_ability_item_36_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ability_item_36_buff:GetTexture()
    return "huskar_burning_spear"
end

function modifier_ability_item_36_buff:GetEffectName()
    return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff_gold.vpcf"
end

function modifier_ability_item_36_buff:StatusEffectPriority()
    return 10
end

function modifier_ability_item_36_buff:GetModifierStatusResistanceStacking()
    local ability = self:GetAbility()
    if not ability then return 0 end
    return -ability:GetSpecialValueFor("num1")
end
