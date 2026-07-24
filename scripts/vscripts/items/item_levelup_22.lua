--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


item_levelup_22 = class({})

function item_levelup_22:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    if caster:ChangeStatsStoneActivate({ percent = self:GetSpecialValueFor("percent") }) then
        ConsumeLevelUpItemCharge(caster, ability)
    end
end