--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Rank == nil then
    Rank = class({})
    require("ingame.Rank.Config")
    require("ingame.Rank.Set")
    require("ingame.Rank.Get")
    require("ingame.Rank.Ui")
end

function Rank:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

function Rank:ResetPlayerRankLists(ID)
    if not self.Data[ID] then
        return
    end
    self.Data[ID].list_5v5 = {}
    self.Data[ID].list_1v1 = {}
    self.Data[ID].list_bot_1v1 = {}
    self.Data[ID].list = {}
    self.Data[ID].data.rank = -1
    self.Data[ID].data.point = -1
    self.Data[ID].data.rank2 = -1
    self.Data[ID].data.point2 = -1
    self.Data[ID].data.rank_bot = -1
    self.Data[ID].data.point_bot = -1
end

function Rank:ApplyLeaderboardsToAllPlayers(data1, data2, data3)
    if not data1 or not data2 then
        return
    end
    for k, v in pairs(PD.IDs) do
        if v then
            local ID = v
            if not self.Data[ID] then
                self:Init(ID)
            end
            local self_id = PlayerResource:GetSteamAccountID(ID)
            local self_id64 = utilex:ConvertSteamID32To64_Safe(self_id)
            self.Data[ID].data.pid = self_id
            self.Data[ID].data.sid = self_id64
            self.Data[ID].list_5v5 = {}
            self.Data[ID].list_1v1 = {}
            self.Data[ID].list_bot_1v1 = {}

            for i = 1, 100 do
                local rank_key = "rank" .. i
                local rank_data = data1[i]
                if rank_data then
                    self.Data[ID].list_5v5[rank_key] = {
                        id = rank_data.pid,
                        sid = utilex:ConvertSteamID32To64_Safe(rank_data.pid),
                        rank = rank_data.rank,
                        point = rank_data.score,
                    }
                    if rank_data.pid == self_id then
                        self.Data[ID].data.rank = rank_data.rank
                        self.Data[ID].data.point = rank_data.score
                    end
                end
            end

            for i = 1, 100 do
                local rank_key = "rank" .. i
                local rank_data = data2[i]
                if rank_data then
                    self.Data[ID].list_1v1[rank_key] = {
                        id = rank_data.pid,
                        sid = utilex:ConvertSteamID32To64_Safe(rank_data.pid),
                        rank = rank_data.rank,
                        point = rank_data.score,
                    }
                    if rank_data.pid == self_id then
                        self.Data[ID].data.rank2 = rank_data.rank
                        self.Data[ID].data.point2 = rank_data.score
                    end
                end
            end

            if data3 then
                for i = 1, 100 do
                    local rank_key = "rank" .. i
                    local rank_data = data3[i]
                    if rank_data then
                        self.Data[ID].list_bot_1v1[rank_key] = {
                            id = rank_data.pid,
                            sid = utilex:ConvertSteamID32To64_Safe(rank_data.pid),
                            rank = rank_data.rank,
                            point = rank_data.score,
                        }
                        if rank_data.pid == self_id then
                            self.Data[ID].data.rank_bot = rank_data.rank
                            self.Data[ID].data.point_bot = rank_data.score
                        end
                    end
                end
            end

            self.Data[ID].list = self.Data[ID].list_5v5
            if self.Data[ID].page then
                self:SendData(ID)
            end
        end
    end
end

function Rank:ApplySeasonMetaToAllPlayers(meta)
    if not meta then
        return
    end
    for k, v in pairs(PD.IDs) do
        if v and self.Data[v] then
            self.Data[v].seasons = meta.seasons or {}
            if meta.currentSeasonLabel then
                self.Data[v].current_season_label = meta.currentSeasonLabel
            end
        end
    end
end

--获取排行榜数据
function Rank:LoadServer()
    local count = 5
    self:LoadSeasonList()
    Timers(1, function()
        if self.Public.server == true then
            return
        end
        self:InitRank()
        count = count - 1
        if count == 0 then
            return
        end
        return 3
    end)
end

function Rank:LoadSeasonList()
    if self.Public.seasons_loaded == true then
        return
    end
    local host_id = PD.Host
    Http:POST("/ranking/season_list", {}, host_id, function(keys)
        if keys.code == 200 and keys.data then
            self.Public.seasons_loaded = true
            self:ApplySeasonMetaToAllPlayers(keys.data)
            for k, v in pairs(PD.IDs) do
                if v and self.Data[v] and self.Data[v].page then
                    self:SendData(v)
                end
            end
        end
    end)
end

function Rank:LoadSeasonHistory(season_label)
    if not season_label or season_label == "" then
        return
    end
    local host_id = PD.Host
    Http:POST("/ranking/season_leaderboard", { season_label = season_label }, host_id, function(keys)
        if keys.code ~= 200 or not keys.data then
            return
        end
        local leaderboards = keys.data.leaderboards
        if not leaderboards then
            return
        end
        for k, v in pairs(PD.IDs) do
            if v and self.Data[v] then
                self.Data[v].rank_view = "history"
                self.Data[v].history_season = season_label
            end
        end
        self:ApplyLeaderboardsToAllPlayers(
            leaderboards.data1,
            leaderboards.data2,
            leaderboards.data3
        )
    end)
end

function Rank:SwitchToLiveView(ID)
    if ID and self.Data[ID] then
        self.Data[ID].rank_view = "live"
        self.Data[ID].history_season = ""
    end
    if self.Public.live_data1 and self.Public.live_data2 then
        for k, v in pairs(PD.IDs) do
            if v and self.Data[v] then
                self.Data[v].rank_view = "live"
                self.Data[v].history_season = ""
            end
        end
        self:ApplyLeaderboardsToAllPlayers(
            self.Public.live_data1,
            self.Public.live_data2,
            self.Public.live_data3
        )
        return
    end
    if self.Public.server ~= true then
        self:InitRank()
        return
    end
    if ID then
        self:SendData(ID)
    end
end

function Rank:InitRank()
    if self.Public.server == true then
        return
    end
    local host_id = PD.Host
    local list = {
        limit = 100,
        min_games = 1,
        force_refresh = false,
        page = 1,
        page_size = 100,
    }
    Http:POST("/ranking/leaderboard", list, host_id, function(keys)
        if keys.code == 200 then
            if self.Public.server == true then
                return
            end
            local leaderboards = keys.data.leaderboards
            if not leaderboards or not leaderboards.data1 or not leaderboards.data2 then
                return
            end
            self.Public.server = true
            self.Public.live_data1 = leaderboards.data1
            self.Public.live_data2 = leaderboards.data2
            self.Public.live_data3 = leaderboards.data3
            for k, v in pairs(PD.IDs) do
                if v and self.Data[v] then
                    self.Data[v].rank_view = "live"
                    self.Data[v].history_season = ""
                end
            end
            self:ApplyLeaderboardsToAllPlayers(
                leaderboards.data1,
                leaderboards.data2,
                leaderboards.data3
            )
        end
    end)
end
