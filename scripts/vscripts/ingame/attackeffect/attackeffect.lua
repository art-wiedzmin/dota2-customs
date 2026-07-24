--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if AttackEffect == nil then
    AttackEffect = class({})
    require("ingame.AttackEffect.Func")
end

function AttackEffect:Init(ID)
    if not ID then
        return
    end
end
