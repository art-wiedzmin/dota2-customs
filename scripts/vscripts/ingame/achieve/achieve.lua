--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if AchieveModule == nil then
    AchieveModule = class({})
    require("ingame.Achieve.Config")
    require("ingame.Achieve.Set")
    require("ingame.Achieve.Get")
    require("ingame.Achieve.Ui")
    require("ingame.Achieve.Claim")
    require("ingame.Achieve.AchieveStat")
end

AchieveModule.Data = AchieveModule.Data or {}

function AchieveModule:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end
