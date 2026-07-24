--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function OverData:SetPlayerData(ID, data)
    if not ID or not data then
        return data
    end
    if not self.Data[ID] or not HeroData.Data[ID] then
        return data
    end
    self.Data[ID].tp = MainGame:GetGameType()
    data.id = ID
    local hero = HeroData:GetHero(ID)
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return data
    end
    data.team = Stat:GetTeam(init_data.team)
    if MainGame:GetGameType() == 3 then
        data.rank = OverData:GetFourTeamPlacementRank(data.team)
    else
        data.rank = Stat:GetTeamRank(ID)
    end
    if init_data.bot then
        data.pid = 0
    else
        local steam_id = PlayerResource:GetSteamAccountID(ID)
        data.pid = utilex:ConvertSteamID32To64_Safe(steam_id)
    end
    if MainGame:GetGameType() == 3 and data.team and data.team > 0 then
        local team_key = "team_" .. data.team
        local slot = Stat.Public.list[team_key]
        data.team_kill = slot and slot.kill or 0
    else
        data.team_kill = 0
    end
    data.hero = HeroData:GetHeroName(ID)
    if hero then
        data.level = hero:GetLevel()
    end
    if Talent.Data[ID] then
        data.weapon = Talent.Data[ID].item_name
    end
    data.gold = HeroData.Data[ID].gold
    if init_data.bot then
        data.kill = HeroData.Data[ID].kill or 0
        data.death = HeroData.Data[ID].death_num or 0
        data.assit = 0
    else
        data.kill = PlayerResource:GetKills(ID)
        data.death = PlayerResource:GetDeaths(ID)
        data.assit = PlayerResource:GetAssists(ID)
    end
    if Person.Data[ID] then
        data.point = Person.Data[ID].point
        data.point2 = Person.Data[ID].point2
    else
        data.point = 0
        data.point2 = 0
    end
    data.damage = HeroData.Data[ID].damage
    data.tank = HeroData.Data[ID].tank
    data.tag = HeroData.Data[ID].tag
    local kk = data.kill or 0
    local dd = data.death or 0
    local aa = data.assit or 0
    if dd <= 0 then
        dd = 1
    end
    local kda_num = ((kk + aa) / dd)
    data.kda = utilex:FloatSet(kda_num, 1)
    for i = 1, 10 do
        local skillkey = "skill_" .. i
        local skill_data = Util:DeepCopyTab(self.SkillTemplate)
        skill_data.slot = i
        data.skill[skillkey] = skill_data
    end
    if Skill.Data[ID] then
        if Skill.Data[ID].Skill1 then
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
        if Skill.Data[ID].Skill2 then
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
    end
    --计算分数
    local point_change = 0
    local game_tp = MainGame:GetGameType()
    local gamekey = "tp_" .. game_tp
    -- 1v1：先写名次 top/top3（含单人人机，便于上报 custom_data；天梯分在人机局为 0）
    if game_tp == 2 then
        local placement = data.rank
        if placement and placement > 0 then
            data.top = placement == 1
            data.top3 = placement <= 3
        end
    end
    --- 非满员真人排位、beidong 地图、纯被动模式：照常出结算面板，天梯分变动为 0
    if not OverData:IsLadderRankedLobby()
        or (MainGame and MainGame.GetPassiveMode and MainGame:GetPassiveMode())
        or GetMapName() == "beidong" then
        data.point_change = 0
        data.point2_change = 0
        return data
    end
    if game_tp == 1 and OverData:IsPointChange(ID) then
        local p_si = Stat:GetTeam(init_data.team)
        if p_si == MainGame.Data.win_team then
            point_change = self.Point[gamekey].win
        else
            point_change = self.Point[gamekey].fail
        end
        data.point2_change = point_change
        data.point_change = 0
    end
    if game_tp == 3 and OverData:IsPointChange(ID) then
        local p_si = Stat:GetTeam(init_data.team)
        if p_si then
            local place = OverData:GetFourTeamPlacementRank(p_si)
            if place and place >= 1 and place <= 4 then
                local rk = "team_" .. place
                local v = self.Point[gamekey] and self.Point[gamekey][rk]
                if v ~= nil then
                    point_change = v
                end
            end
        end
        data.point2_change = point_change
        data.point_change = 0
    end
    if game_tp == 2 and OverData:IsPointChange(ID) then
        local placement = data.rank
        if not placement then
            return data
        end
        local teamkey = "team_" .. placement
        point_change = self.Point[gamekey][teamkey]
        data.point2_change = point_change
    end
    -- 天梯分未从服务端成功加载时，禁止本局增减分
    if not init_data.bot and Person and Person.IsLadderScoreSynced
        and not Person:IsLadderScoreSynced(ID, game_tp) then
        data.point_change = 0
        data.point2_change = 0
        data.ladder_score_locked = true
    end
    return data
end
