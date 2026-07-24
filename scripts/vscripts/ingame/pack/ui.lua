--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Pack:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    --暂停禁止传数据
    if GameRules:IsGamePaused() then
        return
    end
    --初始化数据
    if data.tp == "init" then
        self:SendData(ID)
    end
    if data.tp == "GetUnit" then
        self:GetUnit(ID, data.text)
    end
    if data.tp == "GetHero" then
        self:SelectHero(ID, data.text)
    end
    if data.tp == "TackItem" then
        self:TackItem(ID, data.text)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
end

--给前端发数据
function Pack:SendData(ID)
    if not ID then
        return
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return
    end
    local pack_tp = "Team" .. hero:GetTeam()
    self.Data[ID].pack = self[pack_tp]
    Util:Send2JsID("UI_Pack", self.Data[ID], ID)
end

--发送公共数据,同步到玩家个人仓库
function Pack:SendPublicData(team)
    for k, v in pairs(utilex:GetAllPlayer()) do
        local hero = Util:ID2Hero(v)
        if hero and hero:GetTeam() == team and self:GetPage(v) then
            Pack:SendData(v)
        end
    end
end
