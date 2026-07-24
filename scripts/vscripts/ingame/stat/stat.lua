--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Stat == nil then
    Stat = class({})
    require("ingame.Stat.Config")
    require("ingame.Stat.Set")
    require("ingame.Stat.Get")
    require("ingame.Stat.Ui")
    require("ingame.Stat.Func")
end

function Stat:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

--初始化顶部计分板
function Stat:InitSyS()
    self:InitTeam()
    Timers(2, function()
        self:InitPlayer()
        Stat:UpDataRank()
        -- 只推一次；玩家打开计分板 init / 击杀链仍会经 SendPublicData 节流补推
        self:SendPublicData()
    end)
end

--初始化队伍
function Stat:InitTeam()
    self.Public.change = false
    if MainGame:GetGameType() == 2 then
        self.Public.change = 1
        self.Public.kill_target = MainGame:GetPersonKillTarget()
    elseif MainGame:GetGameType() == 3 then
        self.Public.change = 2
        -- rank_3x4：阵营总击杀胜利线（MainGame.Static.team_kill_3x4）
        self.Public.kill_target = MainGame:GetTeamKillTarget()
    end
    local map_name = GetMapName()
    local team_num = self.Static.team_num[map_name]
    for i = 1, team_num do
        local teamkey = "team_" .. i
        local team_data = Util:DeepCopyTab(self.SlotTemplate)
        team_data.slot = i
        team_data.team = i
        -- team_data.state = true
        self.Public.list[teamkey] = team_data
    end
    local rank_max = 10
    if map_name == "rank_3x4" then
        rank_max = 12
    end
    for i = 1, rank_max do
        local rank_key = "rank_" .. i
        local rank_data = Util:DeepCopyTab(self.PlayerDetail)
        rank_data.rank = i
        for j = 1, 10 do
            local skillkey = "skill_" .. j
            local skill_data = Util:DeepCopyTab(self.SkillTemplate)
            skill_data.slot = j
            rank_data.skill[skillkey] = skill_data
        end
        self.RankList.list[rank_key] = rank_data
    end
end

--初始化所有玩家
function Stat:InitPlayer()
    self:OpenTopPage()
    -- 按 PD.IDs 的稳定顺序初始化，避免 pairs 导致顶部头像顺序混乱
    for _, ID in pairs(PD.IDs or {}) do
        local v = InitPlayer:GetPlayerData(ID)
        if v and v.state then
            local team_index = self:GetTeam(v.team)
            if team_index then
                self:AddPlayerToTeam(ID, team_index)
            end
        end
    end
end

--按顺序添加玩到到队伍
function Stat:AddPlayerToTeam(ID, team_index)
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return
    end
    if not team_index then
        return
    end
    local team_key = "team_" .. team_index
    local old_gid = self:GetPlayerGid(ID, team_key)
    if old_gid then
        return
    end
    for k, v in pairs(self.Public.list) do
        if v and k == team_key then
            self.Public.list[team_key].state = true
            local num = Util:TabCount(self.Public.list[team_key].list)
            local rank_num = num
            --双人阵营天梯（5v5）：team_2 的全局 rank 紧接 team_1 槽位数
            if MainGame:GetGameType() == 1 then
                num = num + 1
                local cap1 = MainGame:GetDualTeamSlotCapRadiant()
                if team_key == "team_1" then
                    rank_num = num
                else
                    rank_num = num + cap1
                end
            end
            --四队×三人：全局 rank 按队间3 槽一段
            if MainGame:GetGameType() == 3 then
                num = num + 1
                rank_num = (team_index - 1) * 3 + num
            end
            if MainGame:GetGameType() == 2 then
                num = v.slot
                rank_num = num
            end
            local player_key = "player_" .. num
            local player_data = Util:DeepCopyTab(self.PlayerTemplate)
            player_data.id = ID
            player_data.state = true
            player_data.team = team_index
            player_data.gid = num
            player_data.hero = init_data.hero_name
            if init_data.bot then
                player_data.online = true
            else
                player_data.online = Util:ID2IfOnline(ID)
            end
            self.Public.list[team_key].list[player_key] = player_data
            --初始化玩家队伍编号
            self:InitPersonData(rank_num, ID)
        end
    end
end

function Stat:InitPersonData(num, ID)
    if not num or not ID then
        return
    end
    local rank_key = "rank_" .. num
    local data = self.RankList.list[rank_key]
    if not data then
        return
    end
    if ID then
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
        if Talent.Data[ID] then
            data.weapon = Talent.Data[ID].item_name
        end
    end
    self.RankList.list[rank_key] = data
end

--英雄死亡
function Stat:TeamKill(ID, tid, time)
    if ID and time then
        --被击杀玩家进入死亡倒计时
        self:DeathTime(ID, time)
    end
    if tid and tid ~= ID then
        -- 击杀队伍加分（含击杀人机）；真人击杀人机另见 HeroData IncrementKills 同步 PlayerResource
        local atk_data = InitPlayer:GetPlayerData(tid)
        local team = atk_data and atk_data.team or PlayerResource:GetTeam(tid)
        local team_index = self:GetTeam(team)
        if team_index then
            local team_key = "team_" .. team_index
            if self.Public.list[team_key] then
                self.Public.list[team_key].kill = self.Public.list[team_key].kill + 1
            end
        end
    end
    -- rank_3x4：热路径不刷个人榜；1v1 击杀走 Lite；5v5 全量 UpDataRank
    local gt = MainGame:GetGameType()
    if gt == 2 then
        Stat:UpDataRankLite()
    elseif gt ~= 3 then
        Stat:UpDataRank()
    end
    -- 1v1 击杀热路径走节流（UpDataRank 防抖回调同理），5v5/3x4 仍立即推送
    if MainGame:GetGameType() == 2 then
        self:SendPublicData()
    else
        self:SendPublicData(true)
    end
end

function Stat:DeathTime(ID, time)
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return
    end
    local team = init_data.team
    local team_index = self:GetTeam(team)
    if not team_index then
        return
    end
    local team_key = "team_" .. team_index
    if not self.Public.list[team_key] then
        return
    end
    local gid = self:GetPlayerGid(ID, team_key)
    if not gid then
        self:AddPlayerToTeam(ID, team_index)
        gid = self:GetPlayerGid(ID, team_key)
        if not gid then
            return
        end
    end
    local player_key = "player_" .. gid
    if not self.Public.list[team_key].list[player_key] then
        return
    end
    self.Public.list[team_key].list[player_key].alive = false
    if init_data.bot then
        self.Public.list[team_key].list[player_key].online = true
    else
        self.Public.list[team_key].list[player_key].online = Util:ID2IfOnline(ID)
    end
    self.Public.list[team_key].list[player_key].time = time
    Timers(time, function()
        self.Public.list[team_key].list[player_key].alive = true
        self:SendPublicData()
    end)
end

---@param skip_send boolean|nil 为 true 时不调用 SendPublicData（仅改内存）。5v5/1v1/3x4+人机断线时 dis_connect 会改走 SendPublicDataExcludePlayer。
function Stat:PlayerImgChange(ID, online, skip_send)
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return
    end
    local team_index = self:GetTeam(init_data.team)
    if not team_index then
        return
    end
    local team_key = "team_" .. team_index
    if not self.Public.list[team_key] then
        return
    end
    local gid = self:GetPlayerGid(ID, team_key)
    if not gid then
        return
    end
    local player_key = "player_" .. gid
    local player_data = self.Public.list[team_key].list[player_key]
    if player_data then
        player_data.online = online
        if not skip_send then
            self:SendPublicData(true)
        end
    end
end
