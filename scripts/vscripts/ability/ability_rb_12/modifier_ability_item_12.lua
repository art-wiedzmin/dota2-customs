--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_12 = class({})

function modifier_ability_item_12:IsHidden()
    return true
end

function modifier_ability_item_12:IsPurgable()
    return false
end

function modifier_ability_item_12:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_12:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EVASION_CONSTANT, -- 固定闪避
    }
end

-- 返回固定闪避百分比（npc_abilities_custom AbilityValues.evasion_bonus）
function modifier_ability_item_12:GetModifierEvasion_Constant()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then return 0 end
    return ability:GetSpecialValueFor("evasion_bonus")
end