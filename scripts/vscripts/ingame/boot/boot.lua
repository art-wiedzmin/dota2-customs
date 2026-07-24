--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Boot == nil then
    Boot = class({})
    require("ingame.Boot.Config")
    require("ingame.Boot.Set")
    require("ingame.Boot.Get")
    require("ingame.Boot.Func")
end

local TEAM_GOODGUYS = rawget(_G, "DOTA_TEAM_GOODGUYS") or 2
local TEAM_BADGUYS = rawget(_G, "DOTA_TEAM_BADGUYS") or 3
local TEAM_CUSTOM_1 = rawget(_G, "DOTA_TEAM_CUSTOM_1") or 6
local TEAM_CUSTOM_2 = rawget(_G, "DOTA_TEAM_CUSTOM_2") or 7
local TEAM_CUSTOM_3 = rawget(_G, "DOTA_TEAM_CUSTOM_3") or 8
local TEAM_CUSTOM_4 = rawget(_G, "DOTA_TEAM_CUSTOM_4") or 9
local TEAM_CUSTOM_5 = rawget(_G, "DOTA_TEAM_CUSTOM_5") or 10
local TEAM_CUSTOM_6 = rawget(_G, "DOTA_TEAM_CUSTOM_6") or 11
local TEAM_CUSTOM_7 = rawget(_G, "DOTA_TEAM_CUSTOM_7") or 12
local TEAM_CUSTOM_8 = rawget(_G, "DOTA_TEAM_CUSTOM_8") or 13
local CreateFakeClientFn = rawget(_G, "CreateFakeClient")

function Boot:AddBootPlayer()
    if self.Data.bot_added then
        return
    end
    self.Data.bot_added = true

    if self.Config.enable_bot_players == false then
        return
    end

    if BotAI and BotAI.ApplyConfigPreset then
        BotAI:ApplyConfigPreset()
    end

    local target_count = self.Config.auto_fill_player_count or 10
    if GetMapName() == "rank_3x4" then
        target_count = 12
    end
    local current_count = 0
    if PD and PD.IDs then
        current_count = #PD.IDs
    end
    local add_num = target_count - current_count
    if add_num <= 0 then
        return
    end

    for i = 1, add_num do
        self:AddOneFakePlayer(i)
    end
end

function Boot:GetBotTargetTeam()
    local map_name = GetMapName()
    if map_name == "rank_1v1" or map_name == "beidong" then
        local teams = {
            TEAM_GOODGUYS,
            TEAM_BADGUYS,
            TEAM_CUSTOM_1,
            TEAM_CUSTOM_2,
            TEAM_CUSTOM_3,
            TEAM_CUSTOM_4,
            TEAM_CUSTOM_5,
            TEAM_CUSTOM_6,
            TEAM_CUSTOM_7,
            TEAM_CUSTOM_8,
        }
        local team_counts = {}
        for _, team in pairs(teams) do
            team_counts[team] = 0
        end
        for _, ID in pairs(PD.IDs or {}) do
            local player_data = InitPlayer:GetPlayerData(ID)
            if player_data and player_data.state and team_counts[player_data.team] ~= nil then
                team_counts[player_data.team] = team_counts[player_data.team] + 1
            end
        end
        for _, team in pairs(teams) do
            if team_counts[team] == 0 then
                return team
            end
        end

        local target_team = teams[1]
        local min_count = team_counts[target_team]
        for _, team in pairs(teams) do
            if team_counts[team] < min_count then
                min_count = team_counts[team]
                target_team = team
            end
        end
        return target_team
    end

    if map_name == "rank_3x4" then
        local teams4 = { TEAM_GOODGUYS, TEAM_BADGUYS, TEAM_CUSTOM_1, TEAM_CUSTOM_2 }
        local team_counts = {}
        for _, t in ipairs(teams4) do
            team_counts[t] = 0
        end
        for _, ID in pairs(PD.IDs or {}) do
            local player_data = InitPlayer:GetPlayerData(ID)
            if player_data and player_data.state and team_counts[player_data.team] ~= nil then
                team_counts[player_data.team] = team_counts[player_data.team] + 1
            end
        end
        local cap = 3
        for _, t in ipairs(teams4) do
            if team_counts[t] < cap then
                return t
            end
        end
        local target_team = teams4[1]
        local min_count = team_counts[target_team]
        for _, t in ipairs(teams4) do
            if team_counts[t] < min_count then
                min_count = team_counts[t]
                target_team = t
            end
        end
        return target_team
    end

    local good_num = 0
    local bad_num = 0
    for _, ID in pairs(PD.IDs or {}) do
        local player_data = InitPlayer:GetPlayerData(ID)
        if player_data and player_data.state then
            if player_data.team == TEAM_GOODGUYS then
                good_num = good_num + 1
            elseif player_data.team == TEAM_BADGUYS then
                bad_num = bad_num + 1
            end
        end
    end
    if good_num <= bad_num then
        return TEAM_GOODGUYS
    end
    return TEAM_BADGUYS
end

function Boot:AddOneFakePlayer(index)
    if type(CreateFakeClientFn) ~= "function" then
        return self:AddOnePseudoPlayer(index)
    end

    local bot_name = "bot_player_" .. tostring(index or 1)
    local fake_player = CreateFakeClientFn(bot_name)
    if not fake_player then
        return self:AddOnePseudoPlayer(index)
    end

    local bot_id = fake_player:GetPlayerID()
    if bot_id == nil or bot_id < 0 then
        -- print("获取机器人 PlayerID 失败:", bot_name)
        return
    end

    local team = self:GetBotTargetTeam()
    PlayerResource:SetCustomTeamAssignment(bot_id, team)
    if fake_player.SetTeam then
        fake_player:SetTeam(team)
    end

    Util:AddPlayer(bot_id)
    local player_index = #PD.IDs
    if InitPlayer then
        if not InitPlayer:GetPlayerData(bot_id) then
            InitPlayer:InitPlayerData(bot_id, player_index)
        end
        local pk = "player_" .. bot_id
        local row = InitPlayer.Public.players[pk]
        if row then
            row.bot = true
            row.online = true
            row.state = true
            if not row.name or row.name == "" then
                row.name = "电脑" .. tostring(index or 1) .. "号"
            end
        end
    end
    --print("机器人玩家创建成功", bot_name, bot_id, team)
end

function Boot:AddOnePseudoPlayer(index)
    local bot_id = #PD.IDs + 1
    local player_key = "player_" .. bot_id
    if InitPlayer.Public.players[player_key] then
        return bot_id
    end

    local team = self:GetBotTargetTeam()
    PD[bot_id] = PD[bot_id] or {}
    PD[bot_id].pseudo_player = true
    table.insert(PD.IDs, bot_id)
    local player_index = #PD.IDs
    InitPlayer:InitPlayerData(bot_id, player_index)
    InitPlayer:Init_ID(bot_id)

    local data = InitPlayer.Public.players[player_key]
    if not data then
        return
    end

    data.bot = true
    data.online = true
    data.state = true
    data.team = team
    data.name = "电脑" .. tostring(index or 1) .. "号"

    --print("伪玩家机器人创建成功", bot_id, team)
    return bot_id
end
