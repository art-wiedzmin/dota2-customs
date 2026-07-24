--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--公共仓库是否有同名道具
function Pack:IsHaveItem(team, item_name)
    local team_key = "Team" .. team
    for k, v in pairs(self[team_key]) do
        if v.state and v.name == item_name then
            return true
        end
    end
end

--获取玩家仓库状态
function Pack:GetPage(ID)
    return self.Data[ID].page
end
