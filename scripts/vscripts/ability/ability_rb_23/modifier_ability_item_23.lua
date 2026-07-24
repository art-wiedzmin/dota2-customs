--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 攻击者modifier
modifier_ability_item_23 = class({})

function modifier_ability_item_23:IsHidden()
    return false
end

function modifier_ability_item_23:IsPurgable()
    return false
end

function modifier_ability_item_23:GetTexture()
    return "scroll/ability_item_23"
end

function modifier_ability_item_23:OnCreated()
    if not IsServer() then return end
    self:GetStackCount()
end

-- 声明修改函数
function modifier_ability_item_23:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_ability_item_23:GetModifierSpellAmplify_Percentage()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then return 0 end
    return ability:GetSpecialValueFor("num1")
end

function modifier_ability_item_23:OnDeath(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local unit = params.unit
    if not attacker then
        return
    end
    local ability = self:GetAbility()
    if not ability then
        return
    end
    local hero = self:GetParent()
    if not Util:IsPlayerHeroForData(hero) then return end
    local ID = Util:Hero2ID(hero)
    if not ID then return end
    local level = ability:GetLevel()
    if level == 10 and unit:IsHero() and unit ~= hero and attacker == hero and self:GetStackCount() < 30 then
        HeroData:AddSX(ID, "jnzq", 0.5)
        self:IncrementStackCount()
    end
end