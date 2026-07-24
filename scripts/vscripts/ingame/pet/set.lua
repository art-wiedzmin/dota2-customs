--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Pet:OpenPick(ID)
    self.Data[ID].pick = true
end

function Pet:ClosePick(ID)
    self.Data[ID].pick = false
end
