--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 血刃：当前生命不超过最大生命的一定比例；普攻附加基于「无法填满的生命池」的魔法伤害

modifier_ability_item_38 = class({})



function modifier_ability_item_38:IsHidden()
    return true
end

function modifier_ability_item_38:IsPurgable()
    return false
end

function modifier_ability_item_38:GetStatusEffectName()
    return "particles/items_fx/armlet.vpcf"
end

-- 提高状态特效优先级，避免被其他特效盖住或不显示
function modifier_ability_item_38:GetStatusEffectPriority() return 10 end

function modifier_ability_item_38:GetEffectAttachType()
    return PATTACH_ROOTBONE_FOLLOW
end

function modifier_ability_item_38:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.3)
        self:ForceRefresh()
    end
end

function modifier_ability_item_38:OnRefresh()
    if not IsServer() then
        return
    end

    self:ClampHealthToCap()
end

function modifier_ability_item_38:OnIntervalThink()
    if not IsServer() then return end
    self:ClampHealthToCap()
end

function modifier_ability_item_38:ClampHealthToCap()
    local parent = self:GetParent()

    if not parent or parent:IsNull() or not parent:IsAlive() then
        return
    end

    local ab = self:GetAbility()

    if not ab or ab:IsNull() or ab:GetLevel() < 1 then
        return
    end

    local cap_pct = ab:GetSpecialValueFor("health_cap_pct")

    if not cap_pct or cap_pct <= 0 then
        cap_pct = 70
    end

    if cap_pct > 100 then
        cap_pct = 100
    end

    local max_hp = parent:GetMaxHealth()

    if max_hp <= 0 then
        return
    end

    local cap = max_hp * (cap_pct / 100)

    if parent:GetHealth() > cap then
        parent:SetHealth(cap)
    end
end

function modifier_ability_item_38:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_ATTACK_LANDED,

    }
end

function modifier_ability_item_38:OnAttackLanded(keys)
    if not IsServer() then
        return
    end

    local parent = self:GetParent()

    if keys.attacker ~= parent then
        return
    end

    local target = keys.target

    if not target or target:IsNull() or not target:IsAlive() then
        return
    end

    if target:IsBuilding() then
        return
    end

    if parent:IsIllusion() then
        return
    end



    local ab = self:GetAbility()

    if not ab or ab:IsNull() or ab:GetLevel() < 1 then
        return
    end



    local max_hp = parent:GetMaxHealth()

    if max_hp <= 0 then
        return
    end



    local cap_pct = ab:GetSpecialValueFor("health_cap_pct")

    if not cap_pct or cap_pct <= 0 then
        cap_pct = 70
    end

    if cap_pct > 100 then
        cap_pct = 100
    end

    -- 相对满血而言无法保留在上方的生命池，用于与旧版「削减最大生命」体量对齐（例：70% 上限 → 30%×最大生命）
    local bonus_pct = ab:GetSpecialValueFor("bonus_hit_pct")

    local pool_pct = math.max(0, 100 - cap_pct)
    local sacrificed = max_hp * (pool_pct / 100)

    local damage = math.floor(sacrificed * (bonus_pct / 100))
    if damage < 1 then
        damage = 1
    end
    -- print("生命最大百分比", sacrificed)
    -- print("伤害系数", bonus_pct)
    -- print("血刃伤害", damage)
    utilex:UnitDam(parent, target, damage, "mf")
end