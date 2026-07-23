--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_29 = class({})

function modifier_ability_item_29:IsHidden()
    return true
end

function modifier_ability_item_29:IsPurgable()
    return false
end

function modifier_ability_item_29:OnCreated()
    if not IsServer() then return end
end