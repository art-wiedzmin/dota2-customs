--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Pack:OpenPage(ID)
    if not ID then
        return
    end
    self.Data[ID].page = true
    self:SendData(ID)
end

function Pack:ClosePage(ID)
    if not ID then
        return
    end
    self.Data[ID].page = false
    self:SendData(ID)
end
