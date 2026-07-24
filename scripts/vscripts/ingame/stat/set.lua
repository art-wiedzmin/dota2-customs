--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Stat:OpenTopPage()
    self.Public.page = true
    self:SendPublicData(true)
end

function Stat:CloseTopPage()
    self.Public.page = false
    self:SendPublicData(true)
end

-- 同一玩家反复打开计分板：短节流内只重算一次，打开时强制全量榜（不用 Lite）
local SCOREBOARD_REFRESH_INTERVAL = 0.35

function Stat:OpenPage(ID)
    if not ID then
        return
    end
    self.Data[ID].page = true
    self._scoreboardRankRefreshAt = self._scoreboardRankRefreshAt or {}
    local now = GameRules:GetGameTime()
    local prev = self._scoreboardRankRefreshAt[ID]
    if prev == nil or (now - prev) >= SCOREBOARD_REFRESH_INTERVAL then
        self._scoreboardRankRefreshAt[ID] = now
        self.RankList.updata = true
        self._rankUpdatePending = false
        self._rankUpdateLite = false
        self:_RunRankUpdate(false)
        self:UpDataList(ID)
    end
    self:SendData(ID)
end

function Stat:ClosePage(ID)
    self.Data[ID].page = false
    self:SendData(ID)
end

function Stat:ChangePage(ID)
    if not ID then
        return
    end
    if self.Data[ID].page == true then
        self:ClosePage(ID)
    else
        self:OpenPage(ID)
    end
end