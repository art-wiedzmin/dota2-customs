--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function LeaveConfirm:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    if data.tp == "init" then
        self:SendData(ID)
    end
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    if data.tp == "ConfirmLeave" then
        self:ConfirmLeave(ID)
    end
end

function LeaveConfirm:SendData(ID)
    if not ID then
        return
    end
    local data = self.Data[ID]
    if not data then
        return
    end
    Util:Send2JsID("UI_LeaveConfirm", data, ID)
end

function LeaveConfirm:OpenPage(ID)
    if not ID then
        return
    end
    if not self.Data[ID] then
        self.Data[ID] = Util:DeepCopyTab(self.Template)
    end
    self.Data[ID].page = true
    self:SendData(ID)
end

function LeaveConfirm:ClosePage(ID)
    if not ID then
        return
    end
    if not self.Data[ID] then
        self.Data[ID] = Util:DeepCopyTab(self.Template)
    end
    self.Data[ID].page = false
    self:SendData(ID)
end

--- 对局进行中且未结算、且为满员真人对局时，中途离开才可能触发秒退惩罚
--- 仅游戏时间未满 15 分钟时惩罚；单机 / 人机填充局不惩罚
LeaveConfirm.EARLY_LEAVE_PENALTY_BEFORE_MIN = 15
--- 断开连接后需持续离线达到该秒数才惩罚（重连则清零）
LeaveConfirm.DISCONNECT_PENALTY_SEC = 5 * 60
--- TEMP：线上小局测秒退，暂不要求满员 10/12 真人；正式环境保持 false
LeaveConfirm.TEMP_RELAX_FULL_LOBBY = false
LeaveConfirm.TEMP_MIN_HUMANS_FOR_PENALTY = 2

function LeaveConfirm:IsWithinEarlyLeavePenaltyWindow(at_min)
    local limit = self.EARLY_LEAVE_PENALTY_BEFORE_MIN or 15
    if at_min == nil then
        at_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
    end
    at_min = tonumber(at_min) or 0
    return at_min < limit
end

--- 秒退惩罚适用的对局类型（TEMP 放宽满员人数）
function LeaveConfirm:IsEligibleLobbyForEarlyLeavePenalty()
    if not OverData then
        return false
    end
    if OverData.SoloHumanVsBots1v1 and OverData:SoloHumanVsBots1v1() then
        return false
    end
    -- 仍需是天梯模式（1v1/5v5/3x4），排除 beidong 等无排位模式
    local mode_need = OverData.GetLadderRankedHumanRequirement
        and OverData:GetLadderRankedHumanRequirement()
    if not mode_need then
        return false
    end
    if self.TEMP_RELAX_FULL_LOBBY then
        local n = (OverData.CountRealHumanPlayers and OverData:CountRealHumanPlayers()) or 0
        local min_humans = self.TEMP_MIN_HUMANS_FOR_PENALTY or 2
        return n >= min_humans
    end
    return OverData.IsLadderRankedLobby and OverData:IsLadderRankedLobby() == true
end

function LeaveConfirm:ShouldApplyEarlyLeavePenalty(at_min)
    if not MainGame or not MainGame.Data then
        return false
    end
    if MainGame.Data.over == true then
        return false
    end
    if not GameRules or not GameRules.State_Get then
        return false
    end
    local st = GameRules:State_Get()
    if st == nil or st < DOTA_GAMERULES_STATE_PRE_GAME then
        return false
    end
    if not self:IsWithinEarlyLeavePenaltyWindow(at_min) then
        return false
    end
    return self:IsEligibleLobbyForEarlyLeavePenalty() == true
end

function LeaveConfirm:EnsureMatchUid()
    if self.match_uid and self.match_uid ~= "" then
        return self.match_uid
    end
    local map = (GetMapName and GetMapName()) or "map"
    local t = math.floor((Time and Time()) or 0)
    local r = (RandomInt and RandomInt(100000, 999999)) or 0
    self.match_uid = string.format("%s_%d_%d", tostring(map), t, r)
    return self.match_uid
end

--- 本局仅惩罚第一个持续断线超时的玩家
--- @param at_min number|nil 断线时的游戏分钟（用于 <15 分窗口判定）
function LeaveConfirm:ClaimFirstEarlyLeavePenalty(ID, at_min)
    if not ID then
        return false
    end
    if not self:ShouldApplyEarlyLeavePenalty(at_min) then
        return false
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return false
    end
    if self.penalty_claimed == true then
        return false
    end
    self.penalty_claimed = true
    return true
end

local function LeaveConfirm_ApplyTpcfLocal(ID, tpcf)
    tpcf = tonumber(tpcf)
    if not tpcf or tpcf < 0 then
        tpcf = 0
    end
    tpcf = math.floor(tpcf)
    if Person and Person.Data and Person.Data[ID] then
        Person.Data[ID].tpcf = tpcf
    end
    if OverData and OverData.Data and OverData.Data[ID] then
        OverData.Data[ID].tpcf = tpcf
    end
end

--- 上报服务端：满员局 15 分钟前、持续断线超时 tpcf+3（每局仅第一人）
function LeaveConfirm:ReportEarlyLeave(ID, at_min)
    if not ID then
        return
    end
    if not self:ClaimFirstEarlyLeavePenalty(ID, at_min) then
        return
    end
    if not Http or not Http.POST then
        return
    end
    local body = {
        match_uid = self:EnsureMatchUid(),
    }
    Http:POST("/game/early_leave", body, ID, function(keys)
        if not keys or not keys.data then
            return
        end
        local tpcf = tonumber(keys.data.tpcf)
        if tpcf ~= nil then
            LeaveConfirm_ApplyTpcfLocal(ID, tpcf)
        end
    end)
end

--- 断线后开始计时：持续离线满 DISCONNECT_PENALTY_SEC（默认 5 分钟）才惩罚；中途重连取消
function LeaveConfirm:WatchAbandonAfterDisconnect(ID)
    if not ID then
        return
    end
    local disconnect_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
    if not self:ShouldApplyEarlyLeavePenalty(disconnect_min) then
        return
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return
    end
    if self.penalty_claimed == true then
        return
    end
    self._abandon_watch = self._abandon_watch or {}
    if self._abandon_watch[ID] then
        return
    end
    self._abandon_watch[ID] = true
    if not Timers then
        self._abandon_watch[ID] = nil
        return
    end

    local need_sec = tonumber(self.DISCONNECT_PENALTY_SEC) or (5 * 60)
    if need_sec < 1 then
        need_sec = 5 * 60
    end
    local start_t = (Time and Time()) or 0

    Timers(1, function()
        if not ID then
            return
        end
        if self.penalty_claimed == true
            or (MainGame and MainGame.Data and MainGame.Data.over == true) then
            self._abandon_watch[ID] = nil
            return
        end
        -- 已重连：不计时、不惩罚
        if Util and Util.ID2IfOnline and Util:ID2IfOnline(ID) then
            self._abandon_watch[ID] = nil
            return
        end
        local now = (Time and Time()) or 0
        local elapsed = now - start_t
        if elapsed >= need_sec then
            self._abandon_watch[ID] = nil
            -- 仍按断线当时是否 <15 分判定窗口
            self:ReportEarlyLeave(ID, disconnect_min)
            return
        end
        return 1
    end)
end

function LeaveConfirm:ConfirmLeave(ID)
    if not ID then
        return
    end
    self:ClosePage(ID)
    -- 确定离开会断开连接；惩罚由断线计时（满 5 分钟）统一处理，此处不立即上报
end
