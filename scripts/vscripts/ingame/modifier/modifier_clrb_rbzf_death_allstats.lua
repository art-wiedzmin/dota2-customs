--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 肉搏祝福：每次死亡补偿的额外全属性（绿字），用层数累计 STR/AGI/INT 各 +stack
modifier_clrb_rbzf_death_allstats = class({})

function modifier_clrb_rbzf_death_allstats:IsHidden()
    return true
end

function modifier_clrb_rbzf_death_allstats:IsDebuff()
    return false
end

function modifier_clrb_rbzf_death_allstats:IsPurgable()
    return false
end

function modifier_clrb_rbzf_death_allstats:RemoveOnDeath()
    return false
end

function modifier_clrb_rbzf_death_allstats:AllowIllusionDuplicate()
    return false
end

function modifier_clrb_rbzf_death_allstats:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_clrb_rbzf_death_allstats:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_clrb_rbzf_death_allstats:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end

function modifier_clrb_rbzf_death_allstats:GetModifierBonusStats_Intellect()
    return self:GetStackCount()
end
