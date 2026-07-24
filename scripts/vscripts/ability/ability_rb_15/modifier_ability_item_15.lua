--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 技能 modifier：攻击前按权重判定是否暴击，若暴击则挂上单次暴击 modifier，由 Dota2 原生暴击处理伤害与表现
modifier_ability_item_15 = class({})

function modifier_ability_item_15:IsHidden()
    return true
end

function modifier_ability_item_15:IsPurgable()
    return false
end

function modifier_ability_item_15:OnCreated()
    if not IsServer() then return end
end

function modifier_ability_item_15:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

-- 攻击开始时判定是否暴击，若中则挂上原生暴击 modifier（单次）
function modifier_ability_item_15:OnAttackStart(params)
    if not IsServer() then return end
    local attacker = params.attacker
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    if not ability then return end
    local level = ability:GetLevel()

    attacker:RemoveModifierByName("modifier_ability_item_15_crit")

    local bj_list = {
        list0 = 73,
        list1 = 20,
        list2 = 5,
        list3 = 2,
    }
    local listkey = Util:Weight(bj_list)
    if listkey == "list0" then
        return
    end
    attacker:AddNewModifier(attacker, ability, "modifier_ability_item_15_crit", {
        listkey = listkey,
        level = level,
    })
end