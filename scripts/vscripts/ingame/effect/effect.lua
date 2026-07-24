--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Effect == nil then
    Effect = class({})
    LinkLuaModifier("modifier_clrb_effect", "ingame/modifier/modifier_clrb_effect",
        LUA_MODIFIER_MOTION_NONE)
    require("ingame.Effect.Func")
end

function Effect:Init(ID)
    if not ID then
        return
    end
end
