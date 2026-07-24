--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--关闭槽位图标
function Skill:CloseChangeImg(ID)
    self.Data[ID].slot_img_page = false
    self:SendData(ID)
end

--打开槽位图标
function Skill:OpenChangeImg(ID)
    if not self.Data[ID] then
        return
    end
    if self.Data[ID].slot_img_page == true then
        return
    end
    self.Data[ID].slot_img_page = true
    self:SendData(ID)
end

--解锁
function Skill:UnLock(id)
    -- for k, v in pairs(self.Public) do
    --     if v and v == id then
    --         self.Public[k] = nil
    --     end
    -- end
end
