--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Prophecy:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    if GameRules:IsGamePaused() and data.tp ~= "init" then
        return
    end
    if not self.Data[ID] then
        self:Init(ID)
    end
    if data.tp == "init" then
        if self:HasFinishedWindow(ID) or self:IsPageOpen(ID) then
            self:SendData(ID)
        elseif not self:TryOpen(ID) then
            self:SendData(ID)
        end
    end
    if data.tp == "Announce" then
        self:Announce(ID)
    end
    if data.tp == "Close" then
        self:ClosePage(ID)
    end
end

function Prophecy:SendData(ID)
    if not ID or not self.Data[ID] then
        return
    end
    local state = self.Data[ID]
    local pageOpen = self:IsUiEnabled() and self:IsPageOpen(ID)
    Util:Send2JsID("UI_Prophecy", {
        page = pageOpen and 1 or 0,
        announced = state.announced == true and 1 or 0,
        announcing = state.announcing == true and 1 or 0,
        closed = state.closed == true and 1 or 0,
        window_end_time = tonumber(self.GlobalWindowEnd) or 0,
        remain_sec = self:WindowRemainSec(),
        prophecy_card_count = self:GetProphecyCardCount(ID),
        can_announce_match = self:CanAnnounceMatch() and 1 or 0,
        can_announce = self:CanAnnounce(ID) and 1 or 0,
    }, ID)
end
