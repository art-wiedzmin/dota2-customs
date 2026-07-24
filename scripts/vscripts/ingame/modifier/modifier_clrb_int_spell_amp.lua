--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_clrb_int_spell_amp = class({})

-- 每 1 点智力 +0.05% 技能增强（100 智力 = 5%）
local INT_PER_SPELL_AMP_PERCENT = 0.05

function modifier_clrb_int_spell_amp:IsHidden()
    return true
end

function modifier_clrb_int_spell_amp:IsDebuff()
    return false
end

function modifier_clrb_int_spell_amp:IsPurgable()
    return false
end

function modifier_clrb_int_spell_amp:RemoveOnDeath()
    return false
end

function modifier_clrb_int_spell_amp:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_clrb_int_spell_amp:GetModifierSpellAmplify_Percentage()
    local parent = self:GetParent()
    if not parent or parent:IsNull() or not parent.GetIntellect then
        return 0
    end
    return parent:GetIntellect(true) * INT_PER_SPELL_AMP_PERCENT
end
