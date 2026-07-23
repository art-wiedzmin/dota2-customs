--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_18 = class({})

function modifier_ability_item_18:IsHidden()
    return true
end

function modifier_ability_item_18:IsPurgable()
    return false
end

function modifier_ability_item_18:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_18:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- 攻击命中时
function modifier_ability_item_18:OnAttackLanded(params)
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
    local num1 = ability:GetSpecialValueFor("num1")
    target:AddNewModifier(attacker, ability, "modifier_ability_item_18_effect", { dam = 0, dam2 = num1 })
end