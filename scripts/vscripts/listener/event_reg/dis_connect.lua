--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local function _RunDisConnect(keys)
    if not keys then
        return
    end
    -- print("Dis_Connect")
    local ID = keys.PlayerID
    if type(ID) ~= "number" then
        ID = tonumber(ID)
    end
    if OverStat and OverStat.OnPlayerDisconnect then
        local ok_os, err_os = pcall(function()
            OverStat:OnPlayerDisconnect(ID)
        end)
        if not ok_os then
            -- print("[Dis_Connect] OverStat:OnPlayerDisconnect: " .. tostring(err_os))
        end
    end
    if ID == nil or ID < 0 then
        return
    end
    local gt = MainGame and MainGame.GetGameType and MainGame:GetGameType()
    local safe_topstat = (gt == 1 or gt == 2 or gt == 3)
    local ok_st, err_st = pcall(function()
        Stat:PlayerImgChange(ID, false, safe_topstat)
        -- 最后一名真人关服时不要向客户端推 TopStat，易与 Shutdown 竞态；仅在有其他在线真人时同步
        if safe_topstat and Util and Util:ClrbSafeToSendCustomGameEvents() and
            Util:ClrbHasOtherConnectedHumansExcept(ID) then
            Stat:SendPublicDataExcludePlayer(ID)
        end
    end)
    if not ok_st then
        -- print("[Dis_Connect] Stat: " .. tostring(err_st))
    end
    if HeroData and HeroData.TryApplyOfflinePetbuff then
        local ok_hd, err_hd = pcall(function()
            HeroData:TryApplyOfflinePetbuff(ID)
        end)
        if not ok_hd then
            -- print("[Dis_Connect] TryApplyOfflinePetbuff: " .. tostring(err_hd))
        end
    end
    if MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin() < 10 then
        local apply_escape = true
        if LeaveConfirm and LeaveConfirm.ShouldApplyEarlyLeavePenalty then
            apply_escape = LeaveConfirm:ShouldApplyEarlyLeavePenalty()
        end
        if apply_escape then
            local row = HeroData and HeroData.Data and HeroData.Data[ID]
            if row and row.tag then
                row.tag.tag7 = true
            end
        end
    end
    -- 断线后开始计时：持续离线满 5 分钟才惩罚（每局仅第一人）；中途重连取消
    if LeaveConfirm and LeaveConfirm.WatchAbandonAfterDisconnect then
        local ok_lc, err_lc = pcall(function()
            LeaveConfirm:WatchAbandonAfterDisconnect(ID)
        end)
        if not ok_lc then
            -- print("[Dis_Connect] LeaveConfirm:WatchAbandonAfterDisconnect: " .. tostring(err_lc))
        end
    end
end

function CustomSets:Dis_Connect(keys)
    local ok, err = pcall(function()
        _RunDisConnect(keys)
    end)
    if not ok then
        local msg = tostring(err) .. "\n" .. debug.traceback()
        -- print("[Dis_Connect] fatal: " .. msg)
        if Server and Server.SendError then
            Server:SendError(msg, "Dis_Connect")
        end
    end
    return true
end