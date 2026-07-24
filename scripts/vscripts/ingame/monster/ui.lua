--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Monster:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    --暂停禁止传数据
    if GameRules:IsGamePaused() then
        return
    end
    --初始化数据
    if data.tp == "init" then
        self:SendData()
    end
    --打开页面
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    --关闭页面
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
end

function Monster:SendData()
    Util:Send2JsBotsSafe("UI_Monster", self.Data)
end
