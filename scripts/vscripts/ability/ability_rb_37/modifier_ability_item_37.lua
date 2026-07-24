-- 蓄力逻辑 modifier（隐藏）
modifier_ability_item_37 = class({})

--- 本次普攻用于蓄力额外伤害的基础攻击伤害（先判定暴击，再按暴击后攻击力计算）
local function m37_get_attack_damage_for_bonus(hero, params, pending_crit_pct)
    local original = tonumber(params.original_damage) or 0
    local dealt = tonumber(params.damage) or 0
    local base = original
    if base <= 0 then
        base = Util:GetAverageTrueAttackDamage(hero)
    end

    local crit_pct = tonumber(pending_crit_pct) or 0
    if crit_pct > 100 then
        return base * crit_pct / 100
    end

    -- 其它引擎暴击（如代达罗斯等）：命中伤害高于基础则视为暴击后攻击力
    if dealt > base * 1.05 then
        return dealt
    end
    return base
end

function modifier_ability_item_37:IsHidden()
    return true
end

function modifier_ability_item_37:IsPurgable()
    return false
end

function modifier_ability_item_37:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_ability_item_37:OnCreated()
    if not IsServer() then
        return
    end

    self:SetStackCount(0)
    self.needs_cc_damage = false
    self.pending_crit_pct = 0
    self.last_attack_time = GameRules:GetGameTime()

    self:StartIntervalThink(0.5)

    -- 创建视觉 buff
    local hero = self:GetParent()
    if hero and not hero:IsNull() then
        hero:AddNewModifier(hero, self:GetAbility(), "modifier_ability_item_37_buff", {})
    end
end

function modifier_ability_item_37:OnAttack(params)
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    if params.attacker ~= hero then
        return
    end

    

    local stacks = self:GetStackCount()


    local tgt = params.target
    if stacks > 0 and tgt and not tgt:IsNull() and tgt:IsAlive() then
        self.needs_cc_damage = true
        self.pending_crit_pct = 0
        local crit_mod = hero:FindModifierByName("modifier_ability_item_15_crit")
        if crit_mod and not crit_mod:IsNull() then
            self.pending_crit_pct = crit_mod:GetModifierPreAttack_CriticalStrike() or 0
        end
    else
        self.needs_cc_damage = false
        self.pending_crit_pct = 0
    end

    -- 最后再更新时间
    self.last_attack_time = GameRules:GetGameTime()
end

function modifier_ability_item_37:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    if params.attacker ~= hero then
        return
    end
    if not params.target then
        return
    end

    if not self.needs_cc_damage then
        return
    end
    self.needs_cc_damage = false

    -- 只有攻击英雄才释放蓄力
    if not params.target:IsHero() then
        self.pending_crit_pct = 0
        return
    end

    local stacks = self:GetStackCount()
    if stacks <= 0 then
        self.pending_crit_pct = 0
        return
    end

    local ability = self:GetAbility()
    if not ability then
        self.pending_crit_pct = 0
        return
    end

    local per_stack = ability:GetSpecialValueFor("num1")

    local total_coefficient = stacks * per_stack

    local base_attack = m37_get_attack_damage_for_bonus(hero, params, self.pending_crit_pct)
    self.pending_crit_pct = 0
    local extra_damage = base_attack * total_coefficient / 100
    local jnzq = hero:GetSpellAmplification(false)
    local num = math.floor(jnzq * 100)
    if num > 0 then
        extra_damage = extra_damage / (1 + (num / 100))
        -- print("extra_damage", extra_damage)
    end
    if extra_damage > 0 then
        utilex:UnitDam(hero, params.target, extra_damage, "wl")
        -- 金色伤害数字（与暴击效果一致）
        if stacks >= 4 then
            ShowMsg:ShowGoodDmageMsg(hero, params.target, extra_damage, "punch")
            local tx = "particles/units/heroes/hero_marci/marci_normal_punch_text.vpcf"
            local tx2 =
            "particles/units/heroes/hero_dark_seer/dark_seer_normal_punch_impact_model.vpcf"
            local tx3 =
            "particles/units/heroes/hero_dark_seer/dark_seer_normal_punch_rays1.vpcf"
            utilex:AddTx(tx, hero, 1)
            utilex:AddTx(tx2, hero, 1)
            utilex:AddTx(tx3, hero, 1)
        end
    end

    self:SetStackCount(0)
end

function modifier_ability_item_37:OnIntervalThink()
    if not IsServer() then
        return
    end

    local hero = self:GetParent()
    local ability = self:GetAbility()

    if not hero or hero:IsNull() or not hero:IsAlive() then
        self:Destroy()
        return
    end

    if not ability then
        self:Destroy()
        return
    end

    local now = GameRules:GetGameTime()
    if now - (self.last_attack_time or now) >= 1.0 then
        local max_stacks = 4
        local current_stacks = self:GetStackCount()

        if current_stacks < max_stacks then
            self:SetStackCount(current_stacks + 1)
            self.last_attack_time = now
        end
    end
end

function modifier_ability_item_37:OnDestroy()
    if not IsServer() then
        return
    end

    self.needs_cc_damage = false
    self.pending_crit_pct = 0
end
