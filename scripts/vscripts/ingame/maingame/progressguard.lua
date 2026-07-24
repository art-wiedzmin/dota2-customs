--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 对局进程看门狗：保证缩圈(state 2/3)与结算(over)在到达配置时间后仍会执行
-- 不依赖 EventList 单次触发是否成功，也不因 DISCONNECT / 暂停 停掉主心跳

local function ProgressGuardReport(err, source)
    if not err or not Server or not Server.SendError then
        return
    end
    local msg = tostring(err)
    if debug and debug.traceback then
        msg = msg .. "\n" .. debug.traceback()
    end
    Server:SendError(msg, source)
end

--- 自定义暂停会冻结 GetDOTATime；到点仍未缩圈/结算时强制解除
function MainGame:TryReleasePauseForProgress(time)
    time = time or self:GetTime()
    if self.Data.over == true then
        return
    end
    local el = self.EventList
    if not el then
        return
    end
    local need_unpause = false
    if el.map1 and time >= (el.map1.time - 5) and self.Data.state < 2 then
        need_unpause = true
    end
    if el.map2 and time >= (el.map2.time - 5) and self.Data.state < 3 then
        need_unpause = true
    end
    if el.game_over and time >= (el.game_over.time - 5) and self.Data.over ~= true then
        need_unpause = true
    end
    if not need_unpause then
        return
    end
    if CustomSets and CustomSets.pause_state then
        -- print("[MainGame] TryReleasePauseForProgress: auto unpause (game_time=" .. tostring(time) .. ")")
        PauseGame(false)
        CustomSets.pause_state = false
    end
end

--- 按游戏时间与 Data.state / over 强制补缩圈、补结算（幂等：已执行则跳过）
function MainGame:RecoverCriticalEvents(time)
    if self.Data.over == true then
        return
    end
    time = time or self:GetTime()
    local el = self.EventList
    if not el then
        return
    end

    self:TryReleasePauseForProgress(time)

    if el.map1 and time >= el.map1.time and self.Data.state < 2 then
        -- print("[MainGame] RecoverCriticalEvents: MapChange1 (t=" .. tostring(time) .. ")")
        if el.map1 then
            el.map1.state = false
        end
        self.Data.state = 2
        local ok, err = pcall(function()
            self:MapChange1()
        end)
        if not ok then
            ProgressGuardReport(err, "MainGame:RecoverCriticalEvents:MapChange1")
        end
    end

    if el.map2 and time >= el.map2.time and self.Data.state < 3 then
        -- print("[MainGame] RecoverCriticalEvents: MapChange2 (t=" .. tostring(time) .. ")")
        if el.map2 then
            el.map2.state = false
        end
        self.Data.state = 3
        local ok, err = pcall(function()
            self:MapChange2()
        end)
        if not ok then
            ProgressGuardReport(err, "MainGame:RecoverCriticalEvents:MapChange2")
        end
    end

    if el.game_over and time >= el.game_over.time and self.Data.over ~= true then
        -- print("[MainGame] RecoverCriticalEvents: TimerOver (t=" .. tostring(time) .. ")")
        if el.game_over then
            el.game_over.state = false
        end
        local ok, err = pcall(function()
            self:TimerOver()
        end)
        if not ok then
            ProgressGuardReport(err, "MainGame:RecoverCriticalEvents:TimerOver")
        end
    end
end

--- 独立备份轮询（墙钟 5 秒），主 Timers 循环异常停止时仍能推进缩圈/结算
function MainGame:StartProgressWatchdog()
    if self.Data.progress_watchdog_started then
        return
    end
    self.Data.progress_watchdog_started = true
    Timers(5, function()
        if not MainGame or not MainGame.Data then
            return
        end
        if MainGame.Data.over == true then
            return
        end
        local ok, err = pcall(function()
            MainGame:RecoverCriticalEvents(MainGame:GetTime())
        end)
        if not ok then
            ProgressGuardReport(err, "MainGame:ProgressWatchdog")
        end
        return 5
    end)
end
