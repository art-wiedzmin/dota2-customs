--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--同步数据给玩家
function Stat:UpDataList(ID)
    if not ID then
        return
    end
    self.Data[ID].list = self.RankList.list
end

--- 清空榜槽，避免 Lite 更新或排名变动后残留上一玩家的英雄/技能/头像
function Stat:_ClearRankSlot(data)
    if not data then
        return
    end
    data.state = false
    data.id = -1
    data.pid = -1
    data.team = -1
    data.hero = ""
    data.weapon = ""
    data.level = 1
    data.gold = 0
    data.star = 0
    data.kill = 0
    data.death = 0
    data.assit = 0
    if data.skill then
        for j = 1, 10 do
            local sk = data.skill["skill_" .. j]
            if sk then
                sk.state = false
                sk.name = ""
            end
        end
    end
end

--- 收集可排序玩家 K/D（UpDataRank / UpDataRankLite 共用）
function Stat:_CollectRankPlayers()
    local rank_players = {}
    for _, ID in pairs(PD.IDs or {}) do
        local init_data = InitPlayer:GetPlayerData(ID)
        if init_data and init_data.state then
            local kill = 0
            local death = 0
            if init_data.bot then
                kill = HeroData.Data[ID] and HeroData.Data[ID].kill or 0
                death = HeroData.Data[ID] and HeroData.Data[ID].death_num or 0
            else
                kill = PlayerResource:GetKills(ID)
                death = PlayerResource:GetDeaths(ID)
            end
            table.insert(rank_players, {
                id = ID,
                kill = kill or 0,
                death = death or 0,
            })
        end
    end
    table.sort(rank_players, function(a, b)
        if a.kill ~= b.kill then
            return a.kill > b.kill
        end
        if a.death ~= b.death then
            return a.death < b.death
        end
        return a.id < b.id
    end)
    local cap = 10
    if MainGame:GetGameType() == 3 then
        cap = 12
    end
    return rank_players, cap
end

---@param lite boolean|nil 1v1 击杀热路径：只写 K/D/team/hero，不刷技能与左侧计分板重字段
function Stat:_RunRankUpdate(lite)
    self.RankList.updata = false
    Timers(0.3, function()
        self.RankList.updata = true
    end)
    for k, v in pairs(self.RankList.list) do
        self:_ClearRankSlot(v)
    end
    local rank_players, cap = self:_CollectRankPlayers()
    for i = 1, math.min(cap, #rank_players) do
        local rank = "rank_" .. i
        local row = rank_players[i]
        if lite then
            self:SetPlayerDataLite(row.id, rank, row)
        else
            self:SetPlayerData(row.id, rank)
        end
    end
    Stat:TopListUpData()
end

--- 防抖排队；lite 为 true 时走轻量榜，若期间有 full 请求则升级为 full
function Stat:_QueueRankUpdate(lite)
    if self._rankUpdatePending then
        if not lite then
            self._rankUpdateLite = false
        end
        return
    end
    self._rankUpdatePending = true
    self._rankUpdateLite = lite == true and MainGame:GetGameType() == 2
    Timers(0.3, function()
        self._rankUpdatePending = nil
        self.RankList.updata = true
        local use_lite = self._rankUpdateLite == true
        self._rankUpdateLite = false
        Stat:_RunRankUpdate(use_lite)
        Stat:SendPublicData()
    end)
end

function Stat:UpDataRank()
    if self.RankList.updata == false then
        self:_QueueRankUpdate(false)
        return
    end
    self:_RunRankUpdate(false)
end

--- 1v1 击杀链：只更新排名/K/D 与顶栏，技能等留给 OpenPage / InitSyS 全量刷新
function Stat:UpDataRankLite()
    if MainGame:GetGameType() ~= 2 then
        Stat:UpDataRank()
        return
    end
    if self.RankList.updata == false then
        self:_QueueRankUpdate(true)
        return
    end
    self:_RunRankUpdate(true)
end

--- 1v1 热路径：顶栏与 TopListUpData 所需字段；row 含 kill/death
function Stat:SetPlayerDataLite(ID, rank, row)
    local data = self.RankList.list[rank]
    local init_data = InitPlayer:GetPlayerData(ID)
    if not data or not init_data then
        return
    end
    data.state = true
    data.id = ID
    data.team = self:GetTeam(init_data.team)
    data.hero = init_data.hero_name or ""
    if row then
        data.kill = row.kill or 0
        data.death = row.death or 0
    end
end

function Stat:SetPlayerData(ID, rank)
    local hero = HeroData:GetHero(ID)
    local data = self.RankList.list[rank]
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return
    end
    data.state = true
    data.id = ID
    if init_data.bot then
        data.pid = nil
    else
        local steam_id = PlayerResource:GetSteamAccountID(ID)
        data.pid = utilex:ConvertSteamID32To64_Safe(steam_id)
    end
    data.team = self:GetTeam(init_data.team)
    data.hero = init_data.hero_name
    if hero then
        data.level = hero:GetLevel()
    end
    if Talent.Data[ID] then
        data.weapon = Talent.Data[ID].item_name
    end
    if not HeroData.Data[ID] then
        return
    end
    data.gold = HeroData.Data[ID].gold
    data.star = HeroData:GetStar(ID)
    if init_data.bot then
        data.kill = HeroData.Data[ID].kill or 0
        data.death = HeroData.Data[ID].death_num or 0
        data.assit = 0
    else
        data.kill = PlayerResource:GetKills(ID)
        data.death = PlayerResource:GetDeaths(ID)
        data.assit = PlayerResource:GetAssists(ID)
    end

    if Skill.Data[ID] and Skill.Data[ID].Skill1 then
        for k, v in pairs(Skill.Data[ID].Skill1) do
            if v then
                local skill_id = v.id
                local index = v.slot
                local skill_key = "skill_" .. index
                if skill_id == -1 then
                    data.skill[skill_key].state = false
                else
                    data.skill[skill_key].state = true
                    data.skill[skill_key].name = Skill:GetAbSkillName(v.name)
                end
            end
        end
    end
    if Skill.Data[ID] and Skill.Data[ID].Skill2 then
        for k, v in pairs(Skill.Data[ID].Skill2) do
            if v then
                local skill_state = v.state
                local index = v.slot
                local skill_key = "skill_" .. index
                if skill_state == false then
                    data.skill[skill_key].state = false
                else
                    data.skill[skill_key].state = true
                    data.skill[skill_key].name = v.name
                end
            end
        end
    end
    -- print("==================")
    -- print("当前排名" .. rank)
    -- print("加载后技能数据")
    -- print(data.skill)
end

function Stat:IsInRankList(ID)
    for k, v in pairs(self.RankList.list) do
        if v and v.state == true and v.id == ID then
            return true
        end
    end
end

function Stat:GetTopRankID()
    local list1 = {}
    for k, v in pairs(PD.IDs) do
        if v then
            local ID = v
            if not self:IsInRankList(ID) then
                local key = "p_" .. v
                local init_data = InitPlayer:GetPlayerData(ID)
                local kill = 0
                if init_data and init_data.bot then
                    kill = HeroData.Data[ID] and HeroData.Data[ID].kill or 0
                else
                    kill = PlayerResource:GetKills(ID)
                end
                list1[key] = kill
            end
        end
    end
    if Util:TabCount(list1) == 0 then
        return
    end
    local list2 = {}
    local topkey = utilex:GetMaxKeyInTab(list1)
    local max_kill = list1[topkey]
    for k, v in pairs(list1) do
        if v and v == max_kill then
            list2[k] = v
        end
    end
    --如果最高击杀者就一个
    if Util:TabCount(list2) == 1 then
        local ID = tonumber(utilex:splitIndex(topkey, "_", 2))
        return ID
    end
    -- print("===========")
    -- print(list2)
    --如果有多个
    local list3 = {}
    for k, v in pairs(list2) do
        if v then
            local ID = tonumber(utilex:splitIndex(k, "_", 2))
            local init_data = InitPlayer:GetPlayerData(ID)
            local death = 0
            if init_data and init_data.bot then
                death = HeroData.Data[ID] and HeroData.Data[ID].death_num or 0
            else
                death = PlayerResource:GetDeaths(ID)
            end
            list3[k] = death
        end
    end
    local minkey = utilex:GetMinKeyInTab(list3)
    -- print("===========")
    -- print(list3)
    local ID = tonumber(utilex:splitIndex(minkey, "_", 2))
    return ID
end

--顶部计分板排位变动
function Stat:TopListUpData()
    -- 5v5 / rank_3x4：顶部以阵营击杀为主，不把全局 K/D 名次写回 Public.list
    if MainGame:GetGameType() == 1 or MainGame:GetGameType() == 3 then
        return
    end
    local cap = 10
    if MainGame:GetGameType() == 3 then
        cap = 12
    end
    local lhzf_changed = {}
    for i = 1, cap do
        local rank = "rank_" .. i
        if self.RankList.list[rank].state then
            local ID = self.RankList.list[rank].id
            local team = self.RankList.list[rank].team
            if not team then
                goto continue
            end
            local team_key = "team_" .. team
            local team_data = self.Public.list[team_key]
            if not team_data or not team_data.list then
                goto continue
            end
            for k, v in pairs(team_data.list) do
                if v and v.state == true and v.id == ID then
                    local prev_rank = team_data.rank
                    self.Public.list[team_key].rank = i
                    if prev_rank ~= i and ClrbLhzfIsHumanPlayer and ClrbLhzfIsHumanPlayer(ID) then
                        lhzf_changed[#lhzf_changed + 1] = ID
                    end
                end
            end
        end
        ::continue::
    end
    if ClrbLhzfOnRankUpdated then
        ClrbLhzfOnRankUpdated(lhzf_changed)
    end
end
