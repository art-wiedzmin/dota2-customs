--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Point == nil then
    Point = class({})
    require("ingame.Point.Config")
    require("ingame.Point.Set")
    require("ingame.Point.Get")
    require("ingame.Point.Ui")
end

function Point:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end
