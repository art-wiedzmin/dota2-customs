-- 攻击者modifier
modifier_ability_item_27 = class({})

function modifier_ability_item_27:IsHidden()
    return true
end

function modifier_ability_item_27:IsPurgable()
    return false
end

function modifier_ability_item_27:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_27:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- 攻击命中时
function modifier_ability_item_27:OnAttackLanded(params)
    if not IsServer() then return end

    local attacker = params.attacker
    local target = params.target

    if attacker ~= self:GetParent() then
        return
    end

    local ability = self:GetAbility()
    if not ability then
        return
    end
    local level = ability:GetLevel()
    local fixed_hj = -ability:GetSpecialValueFor("num1")

    LinkLuaModifier("modifier_ability_27_buff", "ingame/modifier/modifier_ability_27_buff",
        LUA_MODIFIER_MOTION_NONE)
    local buff_name = "modifier_ability_27_buff"
    local existing_buff = target:FindModifierByNameAndCaster(buff_name, attacker)
    if existing_buff then
        existing_buff.jchj = fixed_hj
        existing_buff:SetStackCount(fixed_hj * 100)
        existing_buff:SetDuration(7, true)
    else
        target:AddNewModifier(
            attacker,
            ability,
            buff_name,
            { dur = 7, hj = fixed_hj }
        )
    end

    -- 10 级前仅固定穿甲；10 级起每次攻击额外叠 1 层减甲（每层 1.5）
    local debuff_name = "modifier_ability_item_27_debuff"
    if level < 10 then
        target:RemoveModifierByNameAndCaster(debuff_name, attacker)
        return
    end

    local existing_debuff = target:FindModifierByNameAndCaster(debuff_name, attacker)

    if existing_debuff then
        local current_stacks = existing_debuff:GetStackCount()
        if current_stacks < 999 then
            existing_debuff:IncrementStackCount()
        end
        existing_debuff:SetDuration(7, true)
    else
        local debuff = target:AddNewModifier(
            attacker,
            ability,
            debuff_name,
            {
                duration = 7,
            }
        )
        if debuff then
            debuff:SetStackCount(1)
        end
    end
end

-- 减甲debuff modifier
modifier_ability_item_27_debuff = class({})

function modifier_ability_item_27_debuff:IsHidden()
    return false
end

function modifier_ability_item_27_debuff:IsDebuff()
    return true
end

function modifier_ability_item_27_debuff:IsPurgable()
    return false -- 可以被驱散
end

function modifier_ability_item_27_debuff:RemoveOnDeath()
    return true
end

function modifier_ability_item_27_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ability_item_27_debuff:GetModifierIgnoreDebuffImmunity()
    if DOTA_ABILITY_PIERCE_TYPE_MAGIC_IMMUNE ~= nil then
        return DOTA_ABILITY_PIERCE_TYPE_MAGIC_IMMUNE
    end
    return 1
end

function modifier_ability_item_27_debuff:OnCreated(params)
    if not IsServer() then return end

    -- 如果从现有modifier创建，获取堆叠信息
    if self:GetStackCount() == 0 then
        self:SetStackCount(1)
    end
end

function modifier_ability_item_27_debuff:OnRefresh(params)
    if not IsServer() then return end
    if params and params.duration then
        self:SetDuration(params.duration, true)
    end
end

-- 声明修改函数
function modifier_ability_item_27_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_IGNORE_DEBUFF_IMMUNITY,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

-- 计算总护甲降低值
function modifier_ability_item_27_debuff:GetModifierPhysicalArmorBonus()
    local stacks = self:GetStackCount()
    local extra_reduction = 1.5
    local total_reduction = stacks * extra_reduction
    return -total_reduction
end

-- 工具提示1：显示当前减甲值
function modifier_ability_item_27_debuff:OnTooltip()
    local stacks = self:GetStackCount()
    local extra_reduction = 1.5
    return stacks * extra_reduction
end

-- 工具提示2：显示层数
function modifier_ability_item_27_debuff:OnTooltip2()
    return self:GetStackCount()
end

function modifier_ability_item_27_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

-- 状态图标
function modifier_ability_item_27_debuff:GetTexture()
    return "scroll/ability_item_27"
end
