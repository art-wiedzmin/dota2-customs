--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Prophecy:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    self.Data[ID].prophecy_once_key = string.format(
        "yy_%s_%s_%s",
        tostring(ID),
        tostring(math.floor(GameRules:GetGameTime() * 1000)),
        tostring(RandomInt(100000, 999999))
    )
end

function Prophecy:IsHumanPlayer(ID)
    if not ID then
        return false
    end
    if self:IsLobbyBotID(ID) then
        return false
    end
    local init = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
    if init then
        return init.state ~= false
    end
    return PlayerResource and PlayerResource.IsValidPlayer and PlayerResource:IsValidPlayer(ID)
end

function Prophecy:IsLobbyBotID(ID)
    if type(ID) ~= "number" then
        return false
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return true
    end
    if PD and PD[ID] and PD[ID].pseudo_player then
        return true
    end
    if PlayerResource then
        if PlayerResource.IsFakeClient and PlayerResource:IsFakeClient(ID) then
            return true
        end
        if PlayerResource.GetPlayerName then
            local n = PlayerResource:GetPlayerName(ID)
            if n and string.match(n, "^bot_player_%d+$") then
                return true
            end
        end
    end
    local init = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
    if init and init.bot then
        return true
    end
    return false
end

function Prophecy:CountLobbyHumans()
    local count = 0
    for _, ID in pairs(PD.IDs or {}) do
        if self:IsHumanPlayer(ID) then
            count = count + 1
        end
    end
    return count
end

function Prophecy:HasLobbyBots()
    for _, ID in pairs(PD.IDs or {}) do
        if self:IsLobbyBotID(ID) then
            return true
        end
    end
    return false
end

function Prophecy:Is1v1Mode()
    if MainGame and MainGame.GetGameType then
        return MainGame:GetGameType() == 2
    end
    local map = GetMapName()
    return map == "rank_1v1" or map == "beidong"
end

function Prophecy:CountHumanPlayers()
    local count = 0
    if not InitPlayer or not InitPlayer.Public or not InitPlayer.Public.players then
        return 0
    end
    for _, v in pairs(InitPlayer.Public.players) do
        if v and v.state == true and not v.bot then
            count = count + 1
        end
    end
    return count
end

function Prophecy:CountBotPlayers()
    local count = 0
    if not InitPlayer or not InitPlayer.Public or not InitPlayer.Public.players then
        return 0
    end
    for _, v in pairs(InitPlayer.Public.players) do
        if v and v.state == true and v.bot then
            count = count + 1
        end
    end
    return count
end

function Prophecy:IsToolsMode()
    return IsInToolsMode() == true
end

function Prophecy:CanAnnounceMatch()
    if self._devtools_bypass_match then
        return true
    end
    -- 本地工具模式：无视 1v1/满员真人等限制，便于测试预言卡
    if self:IsToolsMode() then
        return true
    end
    if not self:Is1v1Mode() then
        return false
    end
    if GetMapName() == "beidong" then
        return false
    end
    if MainGame and MainGame.GetPassiveMode and MainGame:GetPassiveMode() then
        return false
    end
    if self:HasLobbyBots() then
        return false
    end
    if self:CountLobbyHumans() < 10 then
        return false
    end
    return true
end

function Prophecy:CanAnnounce(ID)
    if not self:IsHumanPlayer(ID) then
        return false
    end
    if not self:CanAnnounceMatch() then
        return false
    end
    if self.Data[ID] and self.Data[ID].announcing then
        return false
    end
    return self:HasProphecyCard(ID)
end

function Prophecy:HasProphecyCard(ID)
    return self:GetProphecyCardCount(ID) > 0
end

function Prophecy:GetProphecyCardCount(ID)
    if Shop and Shop.GetBagItemCount then
        return tonumber(Shop:GetBagItemCount(ID, "prophecy_card")) or 0
    end
    return 0
end

function Prophecy:IsAnnounced(ID)
    return self.Data[ID] and self.Data[ID].announced == true
end

function Prophecy:GetGameTime()
    if MainGame and MainGame.GetTime then
        return MainGame:GetTime()
    end
    return math.floor(GameRules:GetDOTATime(true, true) or 0)
end

function Prophecy:BeginWindow()
    self.GlobalWindowEnd = self:GetGameTime() + self.WINDOW_SEC
end

function Prophecy:IsWithinWindow()
    local end_t = tonumber(self.GlobalWindowEnd) or 0
    return end_t > 0 and self:GetGameTime() <= end_t
end

function Prophecy:WindowRemainSec()
    local end_t = tonumber(self.GlobalWindowEnd) or 0
    return math.max(0, end_t - self:GetGameTime())
end

function Prophecy:IsPageOpen(ID)
    return self.Data[ID] and self.Data[ID].page == true
end

function Prophecy:IsWindowOpen(ID)
    if not self:IsPageOpen(ID) then
        return false
    end
    return self:IsWithinWindow()
end

function Prophecy:HasFinishedWindow(ID)
    if not self.Data[ID] then
        return false
    end
    return self.Data[ID].announced == true or self.Data[ID].closed == true
end

function Prophecy:StopUiSync(ID)
    if not ID then
        return
    end
    Timers:RemoveTimer(self.TIMER_PREFIX .. "ui_sync_" .. tostring(ID))
end

function Prophecy:IsUiEnabled()
    return self.UI_ENABLED ~= false
end

function Prophecy:CanShow(ID)
    if not self:IsUiEnabled() then
        return false
    end
    if not self:IsHumanPlayer(ID) then
        return false
    end
    if not self:IsWithinWindow() then
        return false
    end
    if not self:CanAnnounceMatch() then
        return false
    end
    if not self.Data[ID] then
        self:Init(ID)
    end
    if self:HasFinishedWindow(ID) then
        return false
    end
    if self:IsPageOpen(ID) then
        return false
    end
    return true
end

function Prophecy:TryOpen(ID)
    if not self:CanShow(ID) then
        return false
    end
    self.Data[ID].page = true
    self.Data[ID].window_end_time = self.GlobalWindowEnd
    self:SendData(ID)
    self:ScheduleUiSync(ID)
    self:ScheduleAutoClose(ID)
    return true
end

function Prophecy:OnBagReady(ID)
    if not ID then
        return
    end
    if self:HasFinishedWindow(ID) then
        return
    end
    if (tonumber(self.GlobalWindowEnd) or 0) <= 0 then
        if MainGame and MainGame.Data and MainGame.Data.session_load_gate_finished then
            if not self:CanAnnounceMatch() then
                return
            end
            self:BeginWindow()
            self:ScheduleBagRetry()
        else
            return
        end
    end
    if self:IsPageOpen(ID) then
        self:SendData(ID)
        return
    end
    self:TryOpen(ID)
end

function Prophecy:ScheduleUiSync(ID)
    if not ID then
        return
    end
    local name = self.TIMER_PREFIX .. "ui_sync_" .. tostring(ID)
    Timers:RemoveTimer(name)
    local delays = { 0.5, 1.5, 3 }
    local step = 1
    Timers:CreateTimer(name, {
        endTime = delays[step],
        callback = function()
            if not Prophecy or not Prophecy.Data or not Prophecy.Data[ID] then
                return
            end
            if not Prophecy:IsPageOpen(ID) or Prophecy:HasFinishedWindow(ID) then
                Prophecy:StopUiSync(ID)
                return
            end
            Prophecy:SendData(ID)
            step = step + 1
            if step <= #delays then
                return delays[step] - delays[step - 1]
            end
        end,
    })
end

function Prophecy:SyncOpenPlayers()
    if not PD or not PD.IDs then
        return
    end
    for _, ID in pairs(PD.IDs) do
        if not self.Data[ID] then
            self:Init(ID)
        end
        if self:HasFinishedWindow(ID) then
            -- skip
        elseif self:IsPageOpen(ID) then
            self:SendData(ID)
        else
            self:TryOpen(ID)
        end
    end
end

function Prophecy:ScheduleAutoClose(ID)
    if not ID then
        return
    end
    if self:WindowRemainSec() <= 0 then
        self:AutoClose(ID)
        return
    end
    local name = self.TIMER_PREFIX .. tostring(ID)
    Timers:RemoveTimer(name)
    Timers:CreateTimer(name, {
        endTime = 1,
        callback = function()
            if not Prophecy or not Prophecy.Data or not Prophecy.Data[ID] then
                return
            end
            if not Prophecy:IsPageOpen(ID) or Prophecy:HasFinishedWindow(ID) then
                return
            end
            if not Prophecy:IsWithinWindow() then
                Prophecy:AutoClose(ID)
                return
            end
            return 1
        end,
    })
end

function Prophecy:ScheduleBagRetry()
    Timers:RemoveTimer(self.RETRY_TIMER)
    Timers:CreateTimer(self.RETRY_TIMER, {
        endTime = 2,
        callback = function()
            if not Prophecy or not Prophecy.IsWithinWindow or not Prophecy:IsWithinWindow() then
                return
            end
            if Prophecy.SyncOpenPlayers then
                Prophecy:SyncOpenPlayers()
            end
            if Prophecy:IsWithinWindow() then
                return 2
            end
        end,
    })
end

function Prophecy:AutoClose(ID)
    if not ID or not self.Data[ID] then
        return
    end
    if self.Data[ID].announced then
        return
    end
    self:ClosePage(ID)
end

function Prophecy:ClosePage(ID)
    if not ID or not self.Data[ID] then
        return
    end
    if not self:IsPageOpen(ID) then
        return
    end
    self.Data[ID].page = false
    self.Data[ID].closed = true
    local name = self.TIMER_PREFIX .. tostring(ID)
    Timers:RemoveTimer(name)
    self:StopUiSync(ID)
    self:SendData(ID)
end

function Prophecy:OpenForAllPlayers()
    if not self:CanAnnounceMatch() then
        return
    end
    if not PD or not PD.IDs then
        return
    end
    self:BeginWindow()
    for _, ID in pairs(PD.IDs) do
        self:TryOpen(ID)
    end
    self:ScheduleBagRetry()
end

function Prophecy:ForceTryOpen(ID)
    if not ID or not self:IsHumanPlayer(ID) then
        return false
    end
    if not self.Data[ID] then
        self:Init(ID)
    end
    if self.Data[ID].announced then
        return false
    end
    if (tonumber(self.GlobalWindowEnd) or 0) <= 0 then
        self._devtools_bypass_match = DevTools and DevTools.IsEnabled and DevTools:IsEnabled()
        self:BeginWindow()
        self:ScheduleBagRetry()
        self._devtools_bypass_match = nil
    end
    self.Data[ID].closed = false
    self._devtools_bypass_match = DevTools and DevTools.IsEnabled and DevTools:IsEnabled()
    local ok = self:TryOpen(ID)
    self._devtools_bypass_match = nil
    return ok
end

function Prophecy:RollAnnounceText(ID)
    local player_name = PlayerResource:GetPlayerName(ID) or "某玩家"
    local lines = self.ANNOUNCE_LINES
    if not lines or #lines == 0 then
        return player_name .. "宣布了会获得本场比赛的第一名"
    end
    local template = lines[RandomInt(1, #lines)]
    return string.gsub(template, "【玩家ID】", player_name, 1)
end

function Prophecy:TryPlayFirstAnnounceChiji()
    if self.FirstAnnounceChijiPlayed then
        return
    end
    self.FirstAnnounceChijiPlayed = true
    if utilex and utilex.SoundAll then
        utilex:SoundAll("chiji")
    end
end

function Prophecy:Announce(ID)
    if not ID or not self:IsHumanPlayer(ID) then
        return
    end
    if not self:IsPageOpen(ID) then
        return
    end
    if self.Data[ID].announced then
        Util:BottomMsg2ID(ID, "本局已使用预言卡", "yellow", 2)
        return
    end
    if self.Data[ID].announcing then
        return
    end
    if not self:IsWindowOpen(ID) then
        self:ClosePage(ID)
        Util:BottomMsg2ID(ID, "预言时间已过", "red", 3)
        return
    end
    if not self:CanAnnounceMatch() then
        Util:BottomMsg2ID(ID, "仅1v1满员真人对局可使用预言卡", "red", 3)
        return
    end
    if not self:HasProphecyCard(ID) then
        Util:BottomMsg2ID(ID, "预言卡不足", "red", 3)
        return
    end
    local token = Http:GetPlayerAccessToken(ID)
    if not token or token == "" then
        Util:BottomMsg2ID(ID, "请先登录账号", "red", 3)
        return
    end
    local once_key = self.Data[ID].prophecy_once_key
    if not once_key or once_key == "" then
        once_key = string.format(
            "yy_%s_%s_%s",
            tostring(ID),
            tostring(math.floor(GameRules:GetGameTime() * 1000)),
            tostring(RandomInt(100000, 999999))
        )
        self.Data[ID].prophecy_once_key = once_key
    end
    -- 先占位，避免连点发出多次 /bag/use
    self.Data[ID].announcing = true
    self:SendData(ID)
    Http:POST("/bag/use", {
        item_key = "prophecy_card",
        scene = "prophecy_announce",
        once_key = once_key,
    }, ID, function(keys)
        if not Prophecy.Data[ID] then
            return
        end
        if not keys or keys.code ~= 200 or not keys.data then
            Prophecy.Data[ID].announcing = false
            Prophecy:SendData(ID)
            local msg = "预言卡消耗失败"
            if keys and keys.message and keys.message ~= "" then
                msg = keys.message
            end
            Util:BottomMsg2ID(ID, msg, "red", 3)
            return
        end
        Prophecy.Data[ID].announcing = false
        Prophecy.Data[ID].announced = true
        Prophecy:TryPlayFirstAnnounceChiji()
        Prophecy:ClosePage(ID)
        if Shop and Shop.SetBagServerData and keys.data.bag then
            Shop:SetBagServerData(ID, keys.data.bag)
            if Shop.SendOutBagData then
                Shop:SendOutBagData(ID)
            end
        end
        local text = Prophecy:RollAnnounceText(ID)
        Util:TopMsg2All(text, "#FFD700", 3)
    end)
end
