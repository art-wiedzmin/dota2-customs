--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Title == nil then
    Title = class({})
    LinkLuaModifier("modifier_clrb_title", "ingame/modifier/modifier_clrb_title",
        LUA_MODIFIER_MOTION_NONE)
    require("ingame.Title.Func")
end

function Title:Init(ID)
    if not ID then
        return
    end
end
