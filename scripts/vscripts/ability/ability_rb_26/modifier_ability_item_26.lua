-- 攻击升级（ability_item_26）：等级攻击力仅由此 modifier；满级击杀英雄叠加层数，每层 + attack_kill 绿字、+ pct_kill %% 攻击力加成（删除技能时 OnDestroy 回收）
modifier_ability_item_26 = class({})

local function atk_kill_per_stack(ability)
    if ability and ability.GetSpecialValueFor then
        return math.max(0, math.floor(ability:GetSpecialValueFor("attack_kill")))
    end
    return 5
end

local function pct_kill_per_stack(ability)
    if ability and ability.GetSpecialValueFor then
        return math.max(0, math.floor(ability:GetSpecialValueFor("attack_pct_kill")))
    end
    return 1
end

function modifier_ability_item_26:IsHidden()
    return false
end

function modifier_ability_item_26:IsPurgable()
    return false
end

function modifier_ability_item_26:GetTexture()
    return "scroll/ability_item_26"
end

function modifier_ability_item_26:OnCreated()
    if not IsServer() then
        return
    end
    self:_sync_kill_stack_from_hero_attr()
end

function modifier_ability_item_26:OnRefresh()
    if not IsServer() then
        return
    end
    self:_sync_kill_stack_from_hero_attr()
end

function modifier_ability_item_26:OnDestroy()
    if not IsServer() then
        return
    end
    local ID = self:_hero_id()
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return
    end
    local ha = HeroData.Data[ID].hero_attr
    if not ha then
        return
    end
    local stacks = math.max(0, math.floor(tonumber(ha.skill_26_kills) or 0))
    if stacks <= 0 then
        return
    end
    local ability = self:GetAbility()
    local ak = atk_kill_per_stack(ability)
    local pk = pct_kill_per_stack(ability)
    if ak > 0 then
        HeroData:AddSX(ID, "jcgj", -stacks * ak)
    end
    if pk > 0 then
        HeroData:AddSX(ID, "gjjc", -stacks * pk)
    end
    ha.skill_26_kills = 0
end

function modifier_ability_item_26:_hero_id()
    local hero = self:GetParent()
    if not hero or hero:IsNull() or not hero:IsHero() then
        return nil
    end
    local ID = Util:Hero2ID(hero)
    if not ID then
        return nil
    end
    return ID
end

function modifier_ability_item_26:_sync_kill_stack_from_hero_attr()
    local ID = self:_hero_id()
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return
    end
    local ha = HeroData.Data[ID].hero_attr
    if not ha then
        return
    end
    local n = math.max(0, math.floor(tonumber(ha.skill_26_kills) or 0))
    self:SetStackCount(n)
end

function modifier_ability_item_26:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
        MODIFIER_EVENT_ON_DEATH,
    }
end

--- 仅等级带来的固定攻击力（击杀成长走 jcgj / gjjc，避免与层数展示重复）
function modifier_ability_item_26:GetModifierPreAttack_BonusDamage()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    return math.floor(ability:GetSpecialValueFor("attack_bonus"))
end

function modifier_ability_item_26:OnTooltip()
    local ability = self:GetAbility()
    local stacks = math.max(0, self:GetStackCount())
    return stacks * atk_kill_per_stack(ability)
end

function modifier_ability_item_26:OnTooltip2()
    local ability = self:GetAbility()
    local stacks = math.max(0, self:GetStackCount())
    return stacks * pct_kill_per_stack(ability)
end

function modifier_ability_item_26:OnDeath(params)
    if not IsServer() then
        return
    end
    local unit = params.unit
    local attacker = params.attacker
    if not unit or unit:IsNull() or not attacker or attacker:IsNull() then
        return
    end
    if not unit:IsHero() or not unit:IsRealHero() or unit:IsIllusion() then
        return
    end
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return
    end
    local hero = self:GetParent()
    if not hero or hero:IsNull() or not Util:IsPlayerHeroForData(hero) then
        return
    end
    if attacker ~= hero then
        return
    end
    if not ability:GetLevel() or ability:GetLevel() < ability:GetMaxLevel() then
        return
    end

    local ID = Util:Hero2ID(hero)
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return
    end
    local ha = HeroData.Data[ID].hero_attr
    if not ha then
        return
    end

    local ak = atk_kill_per_stack(ability)
    local pk = pct_kill_per_stack(ability)
    if ak <= 0 and pk <= 0 then
        return
    end

    ha.skill_26_kills = math.max(0, math.floor(tonumber(ha.skill_26_kills) or 0)) + 1
    if ak > 0 then
        HeroData:AddSX(ID, "jcgj", ak)
    end
    if pk > 0 then
        HeroData:AddSX(ID, "gjjc", pk)
    end
    self:SetStackCount(ha.skill_26_kills)
end
