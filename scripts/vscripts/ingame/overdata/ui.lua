--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function OverData:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    --暂停禁止传数据
    -- if GameRules:IsGamePaused() then
    --     return
    -- end
    --初始化数据
    if data.tp == "init" then
        self:SendData(ID)
    end
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
end

--给前端发数据
function OverData:SendData(ID)
    if not ID then
        return
    end
    local data = self.Data[ID]
    -- print(data)
    Util:Send2JsID("UI_OverData", data, ID)
end
