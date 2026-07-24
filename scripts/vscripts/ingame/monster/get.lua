--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Monster:MonsterPos()
    local max_count = self.Data.pos_num
    if max_count <= 0 then
        local center = self.Static.map_center
        return utilex:RandomPos(center, 0, 300) or center
    end
    if self.Data.pos_index > max_count then self.Data.pos_index = 1 end
    local index = self.Data.pos_index
    self.Data.pos_index = self.Data.pos_index + 1
    local pos_key = "pos" .. index
    local pos = self.Pos[pos_key]
    if not pos then
        local center = self.Static.map_center
        return utilex:RandomPos(center, 0, 300) or center
    end
    local max_len = 1000
    if MainGame:GetState() == 2 then max_len = 300 end
    if MainGame:GetState() == 3 then max_len = 200 end
    local ve = utilex:RandomPos(pos, 50, max_len)
    return ve or pos
end

-- 是否是精英
function Monster:IsLeader(name)
    if not name then return end
    for k, v in pairs(self.leader) do if name == k then return true end end
end

-- 掠夺（ability_item_28）不可偷取金币的单位：英雄、三王、雷电信徒等
function Monster:IsPlunderExcluded(name)
    if not name then return end
    if self:IsLeader(name) then return true end
    if Monster.LightningBeliever and name == Monster.LightningBeliever.unit_name then
        return true
    end
end

function Monster:GetMonsterLimit()
    local st = MainGame:GetState()
    if st == 1 then return 230 end
    if st == 2 then return 160 end
    if st == 3 then return 30 end
    return st
end
