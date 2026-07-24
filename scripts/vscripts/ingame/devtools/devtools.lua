--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if DevTools == nil then
    DevTools = class({})
    require("ingame.DevTools.Config")
    require("ingame.DevTools.Get")
    require("ingame.DevTools.Func")
    require("ingame.DevTools.Commands")
    require("ingame.DevTools.Custom")
    require("ingame.DevTools.Chat")
    require("ingame.DevTools.Ui")
end

function DevTools:Init(ID)
    if not ID then
        return
    end
end

function DevTools:GameReady()
    if not self:IsEnabled() then
        return
    end
    self:InitRegistry()
    if not PD or not PD.IDs then
        return
    end
    for _, ID in pairs(PD.IDs) do
        if ID and Util and Util.ID2IfOnline and Util:ID2IfOnline(ID) then
            self:SendData(ID)
        end
    end
end
