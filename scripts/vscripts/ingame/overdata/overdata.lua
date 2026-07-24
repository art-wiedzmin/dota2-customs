--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if OverData == nil then
    OverData = class({})
    require("ingame.OverData.Config")
    require("ingame.OverData.Ui")
    require("ingame.OverData.Set")
    require("ingame.OverData.Get")
end

OverData._submit_state = ""
OverData._submit_timeout_timer_name = nil
--- UI 等待上限：须小于 Http POST 60s；过短会在服务端仍处理中时过早结束 loading
OverData.SUBMIT_UI_TIMEOUT_SEC = 15

function OverData:_CancelSubmitTimeout()
    if self._submit_timeout_timer_name and Timers and Timers.RemoveTimer then
        Timers:RemoveTimer(self._submit_timeout_timer_name)
    end
    self._submit_timeout_timer_name = nil
end

function OverData:_StartSubmitTimeout()
    self:_CancelSubmitTimeout()
    local name = "clrb_overdata_submit_timeout"
    self._submit_timeout_timer_name = name
    Timers:CreateTimer(name, {
        endTime = self.SUBMIT_UI_TIMEOUT_SEC,
        callback = function()
            self._submit_timeout_timer_name = nil
            if self._submit_state == "loading" then
                self._submit_state = "fail"
                self:_SetSubmitStatusForAll("fail")
            end
        end,
    })
end

function OverData:_SetSubmitStatusForAll(status)
    if not status then
        return
    end
    self._submit_state = status
    if not PD or not PD.IDs then
        return
    end
    for _, ID in pairs(PD.IDs) do
        local init_data = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
        if init_data and not init_data.bot and self.Data[ID] then
            self.Data[ID].submit_status = status
            if self.Data[ID].page == 1 then
                self:SendData(ID)
            end
        end
    end
end

function OverData:_MarkSubmitStatusOnAll(status)
    if not status or not PD or not PD.IDs then
        return
    end
    for _, ID in pairs(PD.IDs) do
        local init_data = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
        if init_data and not init_data.bot and self.Data[ID] then
            self.Data[ID].submit_status = status
        end
    end
end

function OverData:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

function OverData:SyncDailyGameBonusFromPerson(ID)
    if not ID or not self.Data[ID] then
        return
    end
    local p = Person and Person.Data and Person.Data[ID]
    if not p then
        return
    end
    local n = p.daily_game_bonus_today
    if n ~= nil and n >= 0 then
        self.Data[ID].daily_game_bonus_today = n
    end
    local tpcf = tonumber(p.tpcf)
    if not tpcf or tpcf < 0 then
        tpcf = 0
    end
    self.Data[ID].tpcf = math.floor(tpcf)
end

function OverData:OpenPage(ID)
    if not ID then
        return
    end
    if not self.Data[ID] then
        self:Init(ID)
    end
    self.Data[ID].page = 1
    self.Data[ID].time = MainGame:GetTimeMin()
    self:SyncDailyGameBonusFromPerson(ID)
    if MainGame and MainGame.Data and MainGame.Data.over == true then
        if self:ShouldSubmitLogGame() then
            self.Data[ID].submit_status = self._submit_state ~= "" and self._submit_state or "loading"
        else
            self.Data[ID].submit_status = "skip"
        end
    else
        self.Data[ID].submit_status = ""
    end
    self:SendData(ID)
end

function OverData:ClosePage(ID)
    if not ID then
        return
    end
    self.Data[ID].page = 0
    self.Data[ID].submit_status = ""
    self:SendData(ID)
end

function OverData:InitPublic()
    local team_num = 2
    if MainGame:GetGameType() == 2 then
        team_num = 10
    elseif MainGame:GetGameType() == 3 then
        team_num = 4
    end
    --初始化队伍
    for i = 1, team_num do
        local team = "team_" .. i
        local data = Util:DeepCopyTab(self.TeamTemplate)
        data.slot = i
        data.win_team = MainGame.Data.win_team
        self.Public[team] = data
    end
end

function OverData:LoadData(ID)
    if not ID then
        return
    end
    if not self.Data[ID] then
        self:Init(ID)
    end
    local team_num = 2
    if MainGame:GetGameType() == 2 then
        team_num = 10
    elseif MainGame:GetGameType() == 3 then
        team_num = 4
    end
    for i = 1, team_num do
        local teamkey = "team_" .. i
        local stat_team = Stat.Public.list[teamkey]
        local pub_team = self.Public[teamkey]
        if stat_team and stat_team.list and pub_team then
            pub_team.kill = stat_team.kill
            for k, v in pairs(stat_team.list) do
                if v and v.state then
                    local p_data = Util:DeepCopyTab(self.PlayerTemplate)
                    p_data.state = true
                    local PID = v.id
                    p_data = self:SetPlayerData(PID, p_data)
                    pub_team.list[k] = p_data
                    pub_team.state = true
                end
            end
        end
    end
    -- self.Data[ID].data = MainGame.OverData
    self.Data[ID].data = self.Public
    -- print(self.Data[ID].data)
end

function OverData:HasBotPlayers()
    for _, ID in pairs(PD.IDs or {}) do
        local init_data = InitPlayer:GetPlayerData(ID)
        if init_data and init_data.bot then
            return true
        end
    end
    return false
end

--- 是否计入通行证任务进度：人机竞速（单人人机 1v1）或天梯满员局；本地工具模式放宽（含人机局）
function OverData:ShouldCountCardTaskStats(ID)
    if not ID then
        return false
    end
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data or init_data.bot then
        return false
    end
    if IsInToolsMode() then
        return true
    end
    if GetMapName() == "beidong" then
        return false
    end
    if MainGame and MainGame.GetPassiveMode and MainGame:GetPassiveMode() then
        return false
    end
    if self:SoloHumanVsBots1v1() then
        return true
    end
    return self:IsLadderRankedLobby()
end

--- /game/submit 返回 achieve_sync：结算成功后写入服务端的成就进度同步到本地，并清空局内会话缓存
function OverData:_ApplyAchieveSyncFromSubmit(keys)
    if not keys or keys.code ~= 200 then
        return
    end
    local payload = keys.data
    if type(payload) ~= "table" then
        return
    end
    local rows = payload.achieve_sync
    if type(rows) ~= "table" then
        return
    end
    if not PD or not PD.IDs then
        return
    end
    for _, slot_id in pairs(PD.IDs) do
        local init_data = InitPlayer:GetPlayerData(slot_id)
        if init_data and not init_data.bot then
            local aid = PlayerResource:GetSteamAccountID(slot_id)
            if aid and aid > 0 then
                for _, row in pairs(rows) do
                    if type(row) == "table" and row.pid and row.achieve then
                        if tonumber(row.pid) == aid then
                            if AchieveModule and AchieveModule.Data[slot_id] then
                                AchieveModule.Data[slot_id].achieve = row.achieve
                                if AchieveModule.SendData then
                                    AchieveModule:SendData(slot_id)
                                end
                            end
                            if AchieveStat and AchieveStat.ClearSession then
                                AchieveStat:ClearSession(slot_id)
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end

--- /game/submit 返回 card_task：同步服务端 card 表任务进度
function OverData:_ApplyCardTaskFromSubmit(keys)
    if not keys or keys.code ~= 200 then
        return
    end
    local payload = keys.data
    if type(payload) ~= "table" then
        return
    end
    local rows = payload.card_task
    if type(rows) ~= "table" then
        return
    end
    if not PD or not PD.IDs then
        return
    end
    for _, slot_id in pairs(PD.IDs) do
        local init_data = InitPlayer:GetPlayerData(slot_id)
        if init_data and not init_data.bot then
            local aid = PlayerResource:GetSteamAccountID(slot_id)
            if aid and aid > 0 then
                for _, row in pairs(rows) do
                    if type(row) == "table" and row.pid and row.card then
                        if tonumber(row.pid) == aid then
                            if Shop and Shop.SetCardServerData then
                                Shop:SetCardServerData(slot_id, row.card)
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end

--- /game/submit 返回的 prophecy_bonus：刷新本局预言奖励
function OverData:_ApplyProphecyBonusFromSubmit(keys)
    if not keys or keys.code ~= 200 then
        return
    end
    local payload = keys.data
    if type(payload) ~= "table" then
        return
    end
    local bonus = payload.prophecy_bonus
    local by_pid = {}
    if type(bonus) == "table" then
        for _, row in pairs(bonus) do
            if type(row) == "table" and row.pid and row.granted then
                local aid = tonumber(row.pid)
                local gold = tonumber(row.gold)
                if aid and aid > 0 and gold and gold > 0 then
                    by_pid[aid] = gold
                end
            end
        end
    end
    if not PD or not PD.IDs then
        return
    end
    for _, slot_id in pairs(PD.IDs) do
        local init_data = InitPlayer:GetPlayerData(slot_id)
        if init_data and not init_data.bot and self.Data[slot_id] then
            local aid = PlayerResource:GetSteamAccountID(slot_id)
            if aid and aid > 0 then
                local g = by_pid[aid]
                if g and g > 0 then
                    self.Data[slot_id].prophecy_bonus_gold = g
                    if self.Data[slot_id].page == 1 then
                        self:SendData(slot_id)
                    end
                end
            end
        end
    end
end

--- /game/submit 返回的 daily_game_bonus：刷新今日次数（含本局发放后）与 tpcf
function OverData:_ApplyDailyGameBonusFromSubmit(keys)
    if not keys or keys.code ~= 200 then
        return
    end
    local payload = keys.data
    if type(payload) ~= "table" then
        return
    end
    local bonus = payload.daily_game_bonus
    local by_pid = {}
    local tpcf_by_pid = {}
    if type(bonus) == "table" then
        for _, row in pairs(bonus) do
            if type(row) == "table" and row.pid then
                local aid = tonumber(row.pid)
                if aid and aid > 0 then
                    local ct = row.countToday
                    if ct == nil then
                        ct = row.count_today
                    end
                    ct = tonumber(ct)
                    if ct ~= nil and ct >= 0 then
                        if ct > 5 then
                            ct = 5
                        end
                        by_pid[aid] = ct
                    end
                    local tpcf = tonumber(row.tpcf)
                    if tpcf ~= nil then
                        if tpcf < 0 then
                            tpcf = 0
                        end
                        tpcf_by_pid[aid] = math.floor(tpcf)
                    end
                end
            end
        end
    end
    if not PD or not PD.IDs then
        return
    end
    for _, slot_id in pairs(PD.IDs) do
        local init_data = InitPlayer:GetPlayerData(slot_id)
        if init_data and not init_data.bot and self.Data[slot_id] then
            local aid = PlayerResource:GetSteamAccountID(slot_id)
            if aid and aid > 0 then
                local n = by_pid[aid]
                if n ~= nil then
                    self.Data[slot_id].daily_game_bonus_today = n
                    if Person and Person.Data and Person.Data[slot_id] then
                        Person.Data[slot_id].daily_game_bonus_today = n
                    end
                end
                local tpcf = tpcf_by_pid[aid]
                if tpcf ~= nil then
                    self.Data[slot_id].tpcf = tpcf
                    if Person and Person.Data and Person.Data[slot_id] then
                        Person.Data[slot_id].tpcf = tpcf
                    end
                end
                if (n ~= nil or tpcf ~= nil) and self.Data[slot_id].page == 1 then
                    self:SendData(slot_id)
                end
            end
        end
    end
end

--- 1v1 且仅 1 名人类玩家（单机人机），需上报服务端统计 bot_1v1_*；其余含机器人模式仍跳过
function OverData:SoloHumanVsBots1v1()
    if MainGame:GetGameType() ~= 2 then
        return false
    end
    local humans = 0
    for _, ID in pairs(PD.IDs or {}) do
        local init_data = InitPlayer:GetPlayerData(ID)
        if init_data and not init_data.bot then
            humans = humans + 1
        end
    end
    return humans == 1
end

--- 1v1 + 仅 1 名真人 + 已开机器人 + 最高难度（3=令人发狂），用于人机最短用时 bot_time
function OverData:IsSolo1v1MaxDifficultyBotLobby()
    if MainGame:GetGameType() ~= 2 then
        return false
    end
    if not self:SoloHumanVsBots1v1() or not self:HasBotPlayers() then
        return false
    end
    if not Boot or not Boot.Config then
        return false
    end
    if Boot.Config.enable_bot_players ~= true then
        return false
    end
    local d = tonumber(Boot.Config.bot_difficulty) or 0
    return d == 3
end

function OverData:LogGame()
    -- if self:HasBotPlayers() and not self:SoloHumanVsBots1v1() then
    --     print("机器人模式下跳过对局记录")
    --     return
    -- end
    if not self:ShouldSubmitLogGame() then
        self._submit_state = "skip"
        self:_SetSubmitStatusForAll("skip")
        return
    end
    -- print("记录对局")
    local game_name = "5v5"
    local tp = MainGame:GetGameType()
    if tp == 1 then
        game_name = "5v5"
    end
    if tp == 3 then
        game_name = "3x4"
    end
    if tp == 2 then
        game_name = "1v1"
    end
    local duration_ceil = math.ceil(GameRules:GetDOTATime(true, true))
    local duration_floor_sec = MainGame and MainGame.GetTime and MainGame:GetTime() or
        math.floor(GameRules:GetDOTATime(true, true))
    local solo_insane_bot = self:IsSolo1v1MaxDifficultyBotLobby()
    local log = {
        game_mode = game_name,
        duration = duration_ceil,
        win_team = MainGame.Data.win_team,
        tools_mode = IsInToolsMode() and true or false,
        prophecy_summary = {
            has_prophecy = false,
            players = {},
        },
        players = {

        }
    }
    for k, v in pairs(PD.IDs) do
        local ID = v
        local player_data = self:GetPlayerData(ID)
        if player_data then
            -- print(player_data)
            local point = 1000
            local point_change = 0
            if tp == 1 or tp == 3 then
                point = player_data.point2
                point_change = player_data.point2_change
            end
            if tp == 2 then
                point = player_data.point2
                point_change = player_data.point2_change
            end
            local init_row = InitPlayer:GetPlayerData(ID)
            if init_row and not init_row.bot and Person and Person.IsLadderScoreSynced
                and not Person:IsLadderScoreSynced(ID, tp) then
                point_change = 0
            end
            local custom_data = {
                win = self:IsWin(ID),
            }
            if self:ShouldCountCardTaskStats(ID) then
                custom_data.card_task_eligible = true
            else
                custom_data.card_task_eligible = false
            end
            if player_data.rank and player_data.rank > 0 then
                custom_data.placement = player_data.rank
            end
            if Prophecy and Prophecy.IsAnnounced and Prophecy:IsAnnounced(ID) then
                custom_data.prophecy_announced = true
                local placement = player_data.rank
                custom_data.prophecy_success = (placement ~= nil and placement == 1) and true or false
            end
            -- 日常成就数值：仅合格对局在结算时随 submit 上报（局内只缓存在 AchieveStat）
            if self:ShouldCountCardTaskStats(ID) and AchieveStat and AchieveStat.BuildForLog then
                local achieve_day_stat = AchieveStat:BuildForLog(ID)
                if achieve_day_stat then
                    custom_data.achieve_day_stat = achieve_day_stat
                end
            end
            -- 1v1：写入 custom_data 供服务端落库与统计（与 player.top3 顶层字段一致）
            if tp == 2 then
                local rk = player_data.rank
                local top_flag = player_data.top
                local top3_flag = player_data.top3
                if rk and rk > 0 then
                    if rk == 1 then
                        top_flag = true
                    end
                    if rk <= 3 then
                        top3_flag = true
                    end
                end
                custom_data.top = top_flag and true or false
                custom_data.top3 = top3_flag and true or false
                local init_row = InitPlayer:GetPlayerData(ID)
                if solo_insane_bot and init_row and not init_row.bot and Person and Person.Data then
                    if not Person.Data[ID] and Person.Init then
                        Person:Init(ID)
                    end
                    local rank1 = (rk == 1) or (top_flag == true)
                    if rank1 and Person.Data[ID] then
                        local bot_race_sec
                        if IsInToolsMode() then
                            -- 工具模式固定 1800s，避免刷人机竞速榜
                            bot_race_sec = 1800
                        else
                            local prev_bt = tonumber(Person.Data[ID].bot_time)
                            if not prev_bt or prev_bt < 0 then
                                prev_bt = 99999
                            end
                            bot_race_sec = duration_floor_sec
                            if bot_race_sec < prev_bt then
                                Person.Data[ID].bot_time = bot_race_sec
                            else
                                bot_race_sec = Person.Data[ID].bot_time
                            end
                        end
                        Person.Data[ID].bot_time = bot_race_sec
                        custom_data.bot_time = bot_race_sec
                        if Person.SendData then
                            Person:SendData(ID)
                        end
                    end
                end
            end
            local player = {
                --玩家ID
                pid = 0,
                --英雄名字
                hero_name = player_data.hero,
                team = player_data.team,
                game_gold = player_data.gold,
                damage_dealt = player_data.damage,
                damage_taken = player_data.tank,
                kills = player_data.kill,
                deaths = player_data.death,
                assists = player_data.assit,
                celestial_score_before = point,
                celestial_score_after = point + point_change,
                celestial_score_change = point_change,
                ladder_score_locked = (player_data.ladder_score_locked == true)
                    or (init_row and not init_row.bot and Person and Person.IsLadderScoreSynced
                        and not Person:IsLadderScoreSynced(ID, tp)),
                ladder_bucket = "unified",
                game_tags = player_data.tag,
                top = player_data.top,
                top3 = player_data.top3,
                custom_data = custom_data,
            }
            local init_data = InitPlayer:GetPlayerData(ID)
            if init_data and not init_data.bot then
                player.pid = PlayerResource:GetSteamAccountID(ID)
            end
            if custom_data.prophecy_announced and init_data and not init_data.bot and player.pid then
                log.prophecy_summary.has_prophecy = true
                table.insert(log.prophecy_summary.players, {
                    pid = player.pid,
                    hero_name = player_data.hero,
                    placement = player_data.rank or 0,
                    announced = true,
                    success = custom_data.prophecy_success == true,
                })
            end
            table.insert(log.players, player)
        end
    end
    if OverStat and OverStat.BuildAllForLog then
        log.player_stat_detail = OverStat:BuildAllForLog(tp, duration_ceil)
    end
    if OverStat and OverStat.BuildEconomyMilestonesSummary then
        log.economy_milestones = OverStat:BuildEconomyMilestonesSummary()
    end
    if log.prophecy_summary.has_prophecy then
        local ok_n = 0
        for _, row in ipairs(log.prophecy_summary.players) do
            if row.success then
                ok_n = ok_n + 1
            end
        end
        print(string.format(
            "[Prophecy] 本局 %d 人预言，%d 人预言成功",
            #log.prophecy_summary.players,
            ok_n
        ))
    else
        print("[Prophecy] 本局无玩家预言")
    end
    self:_SubmitLogGame(log)
end

--- 对局结算上报：不依赖房主在线，依次尝试任意真人玩家身份
function OverData:_SubmitLogGame(log)
    if type(log) ~= "table" then
        return
    end

    self._submit_state = "loading"
    self:_MarkSubmitStatusOnAll("loading")
    self:_SetSubmitStatusForAll("loading")
    self:_StartSubmitTimeout()

    local reporters = self:CollectHttpSubmitPlayerIDs(PD and PD.Host or nil)
    if not reporters or #reporters == 0 then
        print("[LogGame] /game/submit 跳过：无可用真人上报身份")
        self:_CancelSubmitTimeout()
        self:_SetSubmitStatusForAll("fail")
        return
    end

    local idx = 1
    local function onDone(keys)
        if keys and keys.code == 200 then
            self:_CancelSubmitTimeout()
            self._submit_state = "ok"
            self:_MarkSubmitStatusOnAll("ok")
            OverData:_ApplyDailyGameBonusFromSubmit(keys)
            OverData:_ApplyProphecyBonusFromSubmit(keys)
            OverData:_ApplyCardTaskFromSubmit(keys)
            OverData:_ApplyAchieveSyncFromSubmit(keys)
            self:_SetSubmitStatusForAll("ok")
            return
        end
        idx = idx + 1
        if idx > #reporters then
            print("[LogGame] /game/submit 失败：已尝试 " .. tostring(#reporters) .. " 名玩家身份")
            if keys then
                print("[LogGame] 最后一次回调 code=" .. tostring(keys.code) .. " msg=" .. tostring(keys.msg or keys.message or ""))
            end
            if self._submit_state == "loading" then
                self:_CancelSubmitTimeout()
                self:_SetSubmitStatusForAll("fail")
            end
            return
        end
        print("[LogGame] /game/submit 换下一名上报身份 idx=" .. tostring(idx))
        self:_SubmitLogGameOnce(log, reporters[idx], onDone)
    end

    self:_SubmitLogGameOnce(log, reporters[1], onDone)
end

function OverData:_SubmitLogGameOnce(log, reporter_id, callback)
    if not self:IsHttpSubmitReporterID(reporter_id) then
        if type(callback) == "function" then
            callback({ code = 0 })
        end
        return
    end
    Http:POST("/game/submit", log, reporter_id, function(keys)
        if type(callback) == "function" then
            callback(keys)
        end
    end)
end

function OverData:IsWin(ID)
    if not ID then
        return
    end
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return
    end
    local team = Stat:GetTeam(init_data.team)
    if team == MainGame.Data.win_team then
        return true
    end
end

function OverData:GetPlayerData(ID)
    if not ID then
        return
    end
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return
    end
    local team = Stat:GetTeam(init_data.team)
    local team_key = "team_" .. team
    local team_data = self.Data[ID].data[team_key]
    if not team_data then
        return
    end
    for k, v in pairs(team_data.list) do
        if v then
            local PID = v.id
            if PID == ID then
                return v
            end
        end
    end
end
