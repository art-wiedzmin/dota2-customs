--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- rank_3x4：按阵营总击杀、总伤害排序得到名次 1～4（与 tp_3.team_1～team_4 对应）
function OverData:GetFourTeamPlacementRank(stat_team_index)
    if not stat_team_index or stat_team_index < 1 or stat_team_index > 4 then
        return nil
    end
    if not MainGame or not MainGame.Data or not MainGame.Data.kill then
        return nil
    end
    local kf = { "Team2", "Team3", "Team6", "Team7" }
    local rows = {}
    for si = 1, 4 do
        local key = kf[si]
        local k = MainGame.Data.kill[key] or 0
        local dsum = 0
        local tk = "team_" .. si
        local lst = Stat.Public.list[tk] and Stat.Public.list[tk].list
        if lst then
            for _, v in pairs(lst) do
                if v and v.id and HeroData.Data[v.id] then
                    dsum = dsum + (HeroData.Data[v.id].damage or 0)
                end
            end
        end
        rows[#rows + 1] = { si = si, k = k, d = dsum }
    end
    table.sort(rows, function(a, b)
        if a.k ~= b.k then
            return a.k > b.k
        end
        if a.d ~= b.d then
            return a.d > b.d
        end
        return a.si < b.si
    end)
    for place = 1, 4 do
        if rows[place].si == stat_team_index then
            return place
        end
    end
    return nil
end

--- 真实玩家数量（与 /game/submit 服务端 countRealHumanPlayers 一致：非 bot 即计入）
function OverData:CountRealHumanPlayers()
    local n = 0
    for _, ID in pairs(PD.IDs or {}) do
        local init_data = InitPlayer:GetPlayerData(ID)
        if init_data and not init_data.bot then
            n = n + 1
        end
    end
    return n
end

--- 当前模式天梯排位所需真人数量（3x4=12；5v5/1v1=10）
function OverData:GetLadderRankedHumanRequirement()
    if not MainGame or not MainGame.GetGameType then
        return nil
    end
    local gt = MainGame:GetGameType()
    if gt == 3 then
        return 12
    end
    if gt == 1 or gt == 2 then
        return 10
    end
    return nil
end

--- 是否为天梯排位局（满员真人、无单人人机填充；与 clrb_server isLadderRankedGame 对齐）
function OverData:IsLadderRankedLobby()
    if self:SoloHumanVsBots1v1() then
        return false
    end
    local need = self:GetLadderRankedHumanRequirement()
    if not need then
        return false
    end
    return self:CountRealHumanPlayers() >= need
end

-- 该玩家是否参与天梯分变动（真人 + 满员排位局）
function OverData:IsPointChange(ID)
    if not ID then
        return false
    end
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data or init_data.bot then
        return false
    end
    return self:IsLadderRankedLobby()
end

--- 本局是否需要向服务端 /game/submit 上报（与通行证/天梯统计口径一致；beidong、人机填充非竞速局等不上报）
function OverData:ShouldSubmitLogGame()
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

--- 是否可作为 HTTP 结算上报身份（真人、有效 Steam ID）
function OverData:IsHttpSubmitReporterID(ID)
    if ID == nil or not PlayerResource or not PlayerResource.IsValidPlayer then
        return false
    end
    if not PlayerResource:IsValidPlayer(ID) then
        return false
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return false
    end
    if InitPlayer and InitPlayer.GetPlayerData then
        local init_data = InitPlayer:GetPlayerData(ID)
        if init_data and init_data.bot then
            return false
        end
    end
    local aid = PlayerResource:GetSteamAccountID(ID)
    return aid ~= nil and aid > 0
end

--- 收集可用于 /game/submit 的玩家槽位（优先房主，其次在线且已登录，再其余真人）
function OverData:CollectHttpSubmitPlayerIDs(prefer_id)
    local conn = DOTA_CONNECTION_STATE_CONNECTED
    local with_token = {}
    local connected = {}
    local offline = {}
    local seen = {}

    local function bucket(id)
        if seen[id] or not self:IsHttpSubmitReporterID(id) then
            return
        end
        seen[id] = true
        local token = Http and Http.GetPlayerAccessToken and Http:GetPlayerAccessToken(id)
        local has_token = token ~= nil and token ~= ""
        local is_conn = PlayerResource:GetConnectionState(id) == conn
        if has_token and is_conn then
            with_token[#with_token + 1] = id
        elseif has_token then
            connected[#connected + 1] = id
        elseif is_conn then
            connected[#connected + 1] = id
        else
            offline[#offline + 1] = id
        end
    end

    if prefer_id ~= nil then
        bucket(prefer_id)
    end
    if PD and PD.IDs then
        for _, id in pairs(PD.IDs) do
            bucket(id)
        end
    end
    for id = 0, DOTA_MAX_PLAYERS do
        bucket(id)
    end

    local ordered = {}
    local function append(list)
        for _, id in ipairs(list) do
            ordered[#ordered + 1] = id
        end
    end
    append(with_token)
    append(connected)
    append(offline)

    if prefer_id ~= nil and self:IsHttpSubmitReporterID(prefer_id) then
        local out = { prefer_id }
        for _, id in ipairs(ordered) do
            if id ~= prefer_id then
                out[#out + 1] = id
            end
        end
        return out
    end
    return ordered
end
