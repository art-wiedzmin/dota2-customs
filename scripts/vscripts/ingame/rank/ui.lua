--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Rank:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    if GameRules:IsGamePaused() then
        return
    end
    if data.tp == "init" then
        self:SendData(ID)
    end
    if data.tp == "OpenPage" then
        local t = tonumber(data.task_page)
        if t == 1 or t == 2 then
            self.Data[ID].task_page_hint = t
        else
            self.Data[ID].task_page_hint = nil
        end
        self:OpenPage(ID)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    -- 切换 1v1 / 人机竞速（5v5 组队榜已停用）
    if data.tp == "SwitchMode" and (data.mode == "1v1" or data.mode == "bot_1v1") then
        self.Data[ID].view_mode = data.mode
        self:SendData(ID)
    end
    -- 切换当前赛季 / 历史赛季
    if data.tp == "SwitchSeason" then
        if data.view == "history" and data.season and data.season ~= "" then
            self:LoadSeasonHistory(data.season)
        else
            self:SwitchToLiveView(ID)
        end
    end
    if data.tp == "RefreshSeasonList" then
        self.Public.seasons_loaded = false
        self:LoadSeasonList()
    end
end

-- 给前端发数据（排行榜由 Task 面板展示，事件名仍为 UI_Rank）
function Rank:SendData(ID)
    if not ID then
        return
    end
    local vm = self.Data[ID].view_mode or "1v1"
    local list_cur = self.Data[ID].list_5v5 or self.Data[ID].list or {}
    if vm == "1v1" then
        list_cur = self.Data[ID].list_1v1 or {}
    elseif vm == "bot_1v1" then
        list_cur = self.Data[ID].list_bot_1v1 or {}
    end
    local hint = self.Data[ID].task_page_hint
    if hint ~= nil then
        self.Data[ID].task_page_hint = nil
    end
    local payload = {
        page = self.Data[ID].page,
        view_mode = vm,
        rank_view = self.Data[ID].rank_view or "live",
        history_season = self.Data[ID].history_season or "",
        seasons = self.Data[ID].seasons or {},
        current_season_label = self.Data[ID].current_season_label or "S0",
        list_5v5 = self.Data[ID].list_5v5 or {},
        list_1v1 = self.Data[ID].list_1v1 or {},
        list_bot_1v1 = self.Data[ID].list_bot_1v1 or {},
        list = list_cur,
        data = self.Data[ID].data,
        task_page = hint,
    }
    Util:Send2JsID("UI_Rank", payload, ID)
end
