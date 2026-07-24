--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 3：铁匠——状态栏图标；杀敌升级减免与装备基础属性 +30% 见 Talent / modifier_clrb_talents
-- Tooltip 键：DOTA_Tooltip_modifier_talent_skill_3

modifier_talent_skill_3 = class({})

function modifier_talent_skill_3:IsHidden()
    return false
end

function modifier_talent_skill_3:IsDebuff()
    return false
end

function modifier_talent_skill_3:IsPurgable()
    return false
end

function modifier_talent_skill_3:RemoveOnDeath()
    return false
end

function modifier_talent_skill_3:IsPermanent()
    return true
end

function modifier_talent_skill_3:GetTexture()
    return "buff/talent_3"
end
