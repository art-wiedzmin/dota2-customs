--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function InitPlayer:GetTeam(ID)
    if not ID then
        return
    end
    for k, v in pairs(self.Public.players) do
        if v and v.id == ID then
            local team = v.team
            return team
        end
    end
end
