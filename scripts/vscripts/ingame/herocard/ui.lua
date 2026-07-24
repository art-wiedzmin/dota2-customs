--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function HeroCard:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    if GameRules:IsGamePaused() then
        return
    end
    if data.tp == "init" then
        self:SendData(ID)
        return
    end
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
        return
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
        return
    end
    -- Stat 顶部栏：tp peer；其它界面可发 tp HeroInfo，字段相同（side+gid 或 row）
    if data.tp == "peer" or data.tp == "HeroInfo" then
        self:HeroInfo(ID, data)
        return
    end
end

function HeroCard:SendData(ID)
    if not ID then
        return
    end
    self:EnsurePlayerData(ID)
    Util:Send2JsID("UI_HeroCard", self.Data[ID], ID)
end
