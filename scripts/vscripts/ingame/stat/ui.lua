--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Stat:GetUIData(ID, data)
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
        self:SendPublicData()
    end
    --打开顶部计分板
    if data.tp == "OpenTopPage" then
        self:OpenTopPage()
    end
    --关闭顶部计分板
    if data.tp == "CloseTopPage" then
        self:CloseTopPage()
    end
    --打开左侧计分板
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    --关闭左侧计分板
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
end

function Stat:SendData(ID)
    if not ID then
        return
    end
    local payload = self.Data[ID]
    if not payload then
        return
    end
    payload.change = self.Public and self.Public.change or false
    Util:Send2JsID("UI_Stat", payload, ID)
end

--给前端发数据（节流：减轻后期卡顿）
-- 5v5/3x4：10 分前 top_stat_early_interval；10 分~缩圈 top_stat_pre_ring_interval
-- 1v1：top_stat_1v1_* 独立配置（默认 1.5s / 0.8s）；缩圈后 1.2s；决战 2.5s；force 立即推送
-- 人机局断线时用 dis_connect + SendPublicDataExcludePlayer 规避大包；此处热路径仍用 Send2Js 全体广播以免每 tick 多路序列化
local STAT_PUBLIC_SEND_MAX_INTERVAL = 2.5

local function Stat_GetPublicSendInterval()
    local mg = MainGame
    if not mg or not mg.Data then
        return 1.2
    end
    -- 决战时刻（lastfight 事件已触发，EventOver 将 state 置 false）
    if mg.EventList and mg.EventList.lastfight and mg.EventList.lastfight.state == false then
        return STAT_PUBLIC_SEND_MAX_INTERVAL
    end
    -- 首次缩圈后（map1 将 Data.state 置为 2）
    if mg.Data.state >= 2 then
        return 1.2
    end
    local st = Stat.Static or {}
    local cutoff = st.top_stat_early_cutoff_sec or 600
    local gt = mg.GetGameType and mg:GetGameType()
    if gt == 2 then
        local early_iv = st.top_stat_1v1_early_interval or st.top_stat_early_interval or 1.5
        local pre_ring_iv = st.top_stat_1v1_pre_ring_interval or st.top_stat_pre_ring_interval or 0.8
        if mg.GetTime and mg:GetTime() < cutoff then
            return early_iv
        end
        return pre_ring_iv
    end
    local early_iv = st.top_stat_early_interval or 2.0
    local pre_ring_iv = st.top_stat_pre_ring_interval or 0.6
    if mg.GetTime and mg:GetTime() < cutoff then
        return early_iv
    end
    return pre_ring_iv
end

local function Stat_BroadcastTopStat(payload)
    if not payload then
        return
    end
    Util:Send2Js("UI_TopStat", payload)
end

---@param force_immediate boolean|nil 为 true 时取消排队并立刻广播（击杀/页面/游戏结束等）
function Stat:SendPublicData(force_immediate)
    local t = GameRules:GetGameTime()
    local last = Stat.PublicLastSendTime or 0
    local mg = MainGame
    local payload = self:BuildTopStatPayload()
    if force_immediate or (mg and mg.Data and mg.Data.over) then
        Stat.PublicSendPending = nil
        Stat.PublicLastSendTime = t
        self._topStatLastSig = self:BuildTopStatBroadcastSig(payload)
        Stat_BroadcastTopStat(payload)
        return
    end
    local sig = self:BuildTopStatBroadcastSig(payload)
    if sig == self._topStatLastSig then
        return
    end
    local interval = Stat_GetPublicSendInterval()
    if t - last < interval then
        if Stat.PublicSendPending then
            return
        end
        Stat.PublicSendPending = true
        local delay = interval - (t - last)
        if delay > STAT_PUBLIC_SEND_MAX_INTERVAL then
            delay = STAT_PUBLIC_SEND_MAX_INTERVAL
        end
        Timers(delay, function()
            Stat.PublicSendPending = nil
            if not Util.ClrbSafeToSendCustomGameEvents or not Util:ClrbSafeToSendCustomGameEvents() then
                return
            end
            local pending = Stat:BuildTopStatPayload()
            local pending_sig = Stat:BuildTopStatBroadcastSig(pending)
            if pending_sig == Stat._topStatLastSig then
                return
            end
            Stat.PublicLastSendTime = GameRules:GetGameTime()
            Stat._topStatLastSig = pending_sig
            Stat_BroadcastTopStat(pending)
        end)
        return
    end
    Stat.PublicLastSendTime = t
    self._topStatLastSig = sig
    Stat_BroadcastTopStat(payload)
end

--- 5v5 / 1v1 / rank_3x4 + 伪玩家人机断线：不向断线槽广播；由 Util:Send2JsToConnectedHumansExcept 实现
function Stat:SendPublicDataExcludePlayer(except_id)
    if except_id == nil then
        return
    end
    local data = self:BuildTopStatPayload()
    if not data then
        return
    end
    local ok, err = pcall(function()
        Util:Send2JsToConnectedHumansExcept("UI_TopStat", data, except_id)
    end)
    if not ok then
        -- print("[Stat:SendPublicDataExcludePlayer] " .. tostring(err))
        if Server and Server.SendError then
            Server:SendError(tostring(err), "Stat:SendPublicDataExcludePlayer")
        end
    end
end
