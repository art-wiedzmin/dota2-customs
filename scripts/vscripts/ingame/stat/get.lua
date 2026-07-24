--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 顶栏广播用精简玩家行（仅 Panorama Stat.js 读取的字段）
function Stat:_CopyTopStatPlayerRow(p, change)
    if not p or not p.state then
        return nil
    end
    -- 1v1：SetPlayer10 只用 id/hero/alive/time/online/team
    if change == 1 then
        return {
            id = p.id,
            hero = p.hero or "",
            alive = p.alive,
            time = p.time,
            online = p.online,
            team = p.team,
        }
    end
    return {
        state = p.state,
        id = p.id,
        gid = p.gid,
        hero = p.hero or "",
        alive = p.alive,
        time = p.time,
        online = p.online,
        team = p.team,
    }
end

--- 1v1 队伍行：SetPlayer10 用 state/kill/rank/team/list（不用 slot）
function Stat:_CopyTopStatTeamRow(team, change)
    if change == 1 then
        return {
            state = team.state,
            kill = team.kill or 0,
            team = team.team,
            rank = team.rank,
            list = {},
        }
    end
    return {
        state = team.state,
        kill = team.kill or 0,
        team = team.team,
        slot = team.slot,
        rank = team.rank,
        list = {},
    }
end

--- 顶栏缩包：5v5 固定双队必须保留，否则 Stat.js 读 team_2.kill 崩溃
function Stat:_ShouldIncludeTopStatTeam(change, team_key, team)
    if not team then
        return false
    end
    if team.state then
        return true
    end
    if change == 0 or change == false then
        return team_key == "team_1" or team_key == "team_2"
    end
    return false
end

--- 顶栏 UI_TopStat 广播包：去掉未激活队伍/玩家，不含 RankList 与左侧计分板大表
function Stat:BuildTopStatPayload()
    local src = self.Public
    if not src then
        return {}
    end
    local payload = {
        page = src.page,
        change = src.change,
        list = {},
    }
    if src.change == 2 and src.kill_target ~= nil then
        payload.kill_target = src.kill_target
    end
    for team_key, team in pairs(src.list or {}) do
        if self:_ShouldIncludeTopStatTeam(src.change, team_key, team) then
            local row = self:_CopyTopStatTeamRow(team, src.change)
            for pk, p in pairs(team.list or {}) do
                local pl = self:_CopyTopStatPlayerRow(p, src.change)
                if pl then
                    row.list[pk] = pl
                end
            end
            payload.list[team_key] = row
        end
    end
    return payload
end

--- 内容签名：节流窗口内数据未变则跳过序列化/广播
function Stat:BuildTopStatBroadcastSig(payload)
    if not payload then
        return ""
    end
    local parts = {
        tostring(payload.page),
        tostring(payload.change),
        tostring(payload.kill_target),
    }
    local team_keys = {}
    for k in pairs(payload.list or {}) do
        team_keys[#team_keys + 1] = k
    end
    table.sort(team_keys)
    for _, tk in ipairs(team_keys) do
        local team = payload.list[tk]
        parts[#parts + 1] = tk
            .. ":"
            .. tostring(team.kill)
            .. ":"
            .. tostring(team.rank)
            .. ":"
            .. tostring(team.state)
        local pk_list = {}
        for pk in pairs(team.list or {}) do
            pk_list[#pk_list + 1] = pk
        end
        table.sort(pk_list)
        for _, pk in ipairs(pk_list) do
            local p = team.list[pk]
            parts[#parts + 1] = pk
                .. ":"
                .. tostring(p.id)
                .. ":"
                .. tostring(p.alive)
                .. ":"
                .. tostring(p.time)
                .. ":"
                .. tostring(p.online)
                .. ":"
                .. tostring(p.hero)
        end
    end
    return table.concat(parts, "|")
end

function Stat:GetTeam(team)
    if team == nil then
        return nil
    end
    local team_key = "team_" .. team
    return self.Static.team_index[team_key]
end

function Stat:GetPlayerGid(ID, teamkey)
    local team_data = self.Public.list[teamkey]
    if not team_data or not team_data.list then
        return
    end
    for k, v in pairs(team_data.list) do
        if v and v.id == ID then
            return v.gid
        end
    end
end

--- rank_1v1 等：顶部计分板全局个人名次（1 为最高；优先 Public.rank，与顶栏 UI 一致）
function Stat:GetTopScoreboardRank(ID)
    if not ID then
        return nil
    end
    local init_data = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
    if init_data and self.Public and self.Public.list then
        local team_index = self:GetTeam(init_data.team)
        if team_index then
            local team_data = self.Public.list["team_" .. team_index]
            if team_data and team_data.rank and team_data.rank > 0 then
                return team_data.rank
            end
        end
    end
    if not self.RankList or not self.RankList.list then
        return nil
    end
    for i = 1, 10 do
        local data = self.RankList.list["rank_" .. i]
        if data and data.state and data.id == ID then
            return i
        end
    end
    return nil
end

--获取玩家所在队伍排名
function Stat:GetTeamRank(ID)
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return
    end
    local team = self:GetTeam(init_data.team)
    if not team then
        return
    end
    for k, v in pairs(self.RankList.list) do
        if v then
            local team_index = v.team
            if team == team_index then
                local rank = tonumber(utilex:splitIndex(k, "_", 2))
                if rank then
                    return rank
                end
            end
        end
    end
end

--获取第一名队伍
function Stat:GetTopTeam()
    for k, v in pairs(self.Public.list) do
        if v and v.state == true then
            local team = v.team
            local rank = v.rank
            if rank == 1 then
                return team
            end
        end
    end
end