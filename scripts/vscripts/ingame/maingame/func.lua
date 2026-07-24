--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--游戏全局定时器（对局未结束时永不 return nil，避免缩圈/结算链断掉）
function MainGame:StartTime()
    Timers(0, function()
        if not MainGame or not MainGame.Data then
            return 1
        end
        if MainGame.Data.over == true then
            return
        end
        if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
            return
        end
        local ok, err = xpcall(function()
            MainGame:Event()
            MainGame:DayNightTick()
            MainGame:WeatherTrigger()
            Server:ReturnAllGold()
            InitPlayer:AllPlayerGetGold()
            Box:AllAddDraw()
            if MainGame.RecoverCriticalEvents then
                MainGame:RecoverCriticalEvents(MainGame:GetTime())
            end
        end, function(e)
            local msg = tostring(e) .. "\n" .. debug.traceback()
            -- print("[MainGame:StartTime] " .. msg)
            if Server and Server.SendError then
                Server:SendError(msg, "MainGame:StartTime")
            end
            return e
        end)
        if not ok and err ~= nil then
            local msg = tostring(err) .. "\n" .. debug.traceback()
            if Server and Server.SendError then
                Server:SendError(msg, "MainGame:StartTime")
            end
            pcall(function()
                if MainGame.RecoverCriticalEvents then
                    MainGame:RecoverCriticalEvents(MainGame:GetTime())
                end
            end)
        end
        return 1
    end)
end

--事件（同一秒内可能有多条到期；按 time 升序一次处理完，避免 pairs 顺序导致后段节点长期积压）
function MainGame:Event()
    local time = MainGame:GetTime()
    for k, v in pairs(self.EventList) do
        if v.state == true and time >= v.time then
            self:EventTrigger(v.id)
        end
    end
end

function MainGame:EventTrigger(event)
    local entry = self.EventList and self.EventList[event]
    if not entry or entry.state == false then
        return
    end
    local ok, err = pcall(function()
        MainGame:_EventTriggerImpl(event)
    end)
    if ok then
        entry.state = false
    else
        local msg =
            "event="
                .. tostring(event)
                .. "\n"
                .. tostring(err)
                .. "\n"
                .. debug.traceback()
        -- print("[MainGame] EventTrigger failed (will retry): " .. msg)
        if Server and Server.SendError then
            Server:SendError(msg, "MainGame:EventTrigger:" .. tostring(event))
        end
    end
end

function MainGame:_EventTriggerImpl(event)
    if event == "timeover1" then
        utilex:SoundAll("timeover1")
        return
    end
    if event == "timeover2" then
        utilex:SoundAll("timeover2")
        return
    end
    --结束
    if event == "game_over" then
        self:TimerOver()
        return
    end
    --决战
    if event == "lastfight" then
        self:LastFight()
        utilex:SoundAll("lastfight")
        Timers(2, function()
            for i = 1, 5 do
                local time = 0.2 * i
                Timers(time, function()
                    utilex:SoundAll("cost_glod")
                end)
            end
        end)
        return
    end
    --毒圈
    if event == "map1" then
        self.Data.state = 2
        self:MapChange1()
        return
    end
    if event == "map2" then
        self.Data.state = 3
        self:MapChange2()
        return
    end
    --毒圈倒计时
    if event == "map30_1" then
        utilex:SoundAll("map30")
        return
    end
    if event == "map30_2" then
        utilex:SoundAll("map30")
        return
    end
    --清理1
    if event == "clear1" then
        Util:TopMsg2All("瘟疫将在1分钟后开始蔓延！", "red", 5)
        --移除中立营地
        local spawners = Entities:FindAllByClassname("npc_dota_neutral_spawner")
        local rang1 = MainGame.Static.rang1
        for k, v in pairs(spawners) do
            if v then
                local pos1 = v:GetAbsOrigin()
                local center = Monster.Static.map_center
                local len = (center - pos1):Length2D()
                if len > rang1 then
                    UTIL_Remove(v)
                end
            end
        end
        return
    end
    --清理2
    if event == "clear2" then
        Util:TopMsg2All("瘟疫将在1分钟后开始蔓延！", "red", 5)
        --移除中立营地
        local spawners = Entities:FindAllByClassname("npc_dota_neutral_spawner")
        local rang2 = MainGame.Static.rang2
        for k, v in pairs(spawners) do
            if v and IsValidEntity(v) then
                local pos1 = v:GetAbsOrigin()
                local center = Monster.Static.map_center
                local len = (center - pos1):Length2D()
                if len > rang2 then
                    UTIL_Remove(v)
                end
            end
        end
        return
    end
    --刷怪
    if event == "wolf1" then
        self.Data.wolf_time = 120
        Monster.Data.wolf_state = 2
        Monster:CreateWolf()
        Monster:LeaderTime()
        return
    end
    if event == "wolf2" then
        self.Data.wolf_time = 120
        Monster:CreateWolf()
        Monster:LeaderTime()
        return
    end
    if event == "wolf3" then
        self.Data.wolf_time = -1
        Monster.Data.wolf_state = 3
        Monster:CreateWolf()
        Monster:LeaderTime()
        return
    end
    if event == "bear1" then
        self.Data.bear_time = 120
        Monster.Data.bear_state = 2
        Monster:CreateBear()
        Monster:LeaderTime()
        return
    end
    if event == "bear2" then
        self.Data.bear_time = 120
        Monster:CreateBear()
        Monster:LeaderTime()
        return
    end
    if event == "bear3" then
        self.Data.bear_time = -1
        Monster.Data.bear_state = 3
        Monster:CreateBear()
        Monster:LeaderTime()
        return
    end
    if event == "dragon1" then
        Monster.Data.dragon_time = (MainGame.Static.dragon3 or 1440) - (MainGame.Static.dragon1 or 1260)
        Monster.Data.dragon_state = 2
        Monster:CreateDragon()
        Monster:LeaderTime()
        return
    end
    if event == "dragon3" then
        Monster.Data.dragon_time = -1
        Monster.Data.dragon_state = 3
        Monster:CreateDragon()
        Monster:LeaderTime()
        return
    end
    if event == "fallstar1" or event == "fallstar2" then
        MainGame:DropFallenStars()
        return
    end
end

--- 全图屏幕震动（秒）
function MainGame:ShakeScreenAll(duration)
    duration = duration or 2
    if type(ScreenShake) ~= "function" then
        return
    end
    local center = Monster and Monster.Static and Monster.Static.map_center
    if not center then
        center = Vector(0, 0, 0)
    end
    pcall(function()
        ScreenShake(center, 10, 100, duration, 12000, 0, true)
    end)
end

--- 陨落星辰（item_goods_23）：随机地图落点（同复活点规则避树/障碍），每次 4 颗
function MainGame:DropFallenStars()
    utilex:SoundAll("xuanbu")
    Util:TopMsg2All("陨落星辰已散落在地图各处，请各位玩家探索获取", "#5ECFFF", 5)
    self:ShakeScreenAll(3)

    if not HeroData or not HeroData.HeroPos then
        return
    end

    local drop_count = 4
    local min_dist = 2500
    local item_name = "item_goods_23"
    local placed = {}

    for _ = 1, drop_count do
        local pos = nil
        for _try = 1, 50 do
            local candidate = HeroData:HeroPos(nil)
            if candidate then
                local ok = true
                for _, prev in ipairs(placed) do
                    if (candidate - prev):Length2D() < min_dist then
                        ok = false
                        break
                    end
                end
                if ok then
                    pos = candidate
                    break
                end
            end
        end
        if not pos then
            pos = HeroData:HeroPos(nil)
        end
        if not pos then
            break
        end
        placed[#placed + 1] = pos
        local loot_to = pos
        if utilex and utilex.RandomPos then
            loot_to = utilex:RandomPos(pos, 30, 200)
        end
        local item = CreateItem(item_name, nil, nil)
        if item then
            CreateItemOnPositionSync(pos, item)
            item:LaunchLoot(false, 300, 0.5, loot_to, nil)
            local box = item:GetContainer()
            Timers(1, function()
                if item and not item:IsNull() and box and not box:IsNull() then
                    utilex:AddParticles("particles/item_drop_beam_2_lvl3.vpcf", box, 60, 1)
                end
            end)
        end
    end
end

-- 强制提升机器人肉搏（Skill2）技能等级
-- level: 目标等级（例如 5 或 10）
function MainGame:ForceUpgradeRobotMeleeSkills(level)
    if not level or level <= 0 then
        return
    end
    if not PD or not PD.IDs then
        return
    end
    if not Skill or not Skill.Data then
        return
    end

    for _, ID in pairs(PD.IDs) do
        if ID and Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
            local hero = HeroData and HeroData.GetHero and HeroData:GetHero(ID) or nil
            if hero and not hero:IsNull() and Skill.Data[ID] and Skill.Data[ID].Skill2 then
                for i = 5, 10 do
                    local slot_key = "slot_" .. i
                    local data = Skill.Data[ID].Skill2[slot_key]
                    if data and data.state == true and data.name then
                        local ab = hero:FindAbilityByName(data.name)
                        if ab and not ab:IsNull() then
                            local cur = ab:GetLevel() or 0
                            if cur < level then
                                ab:SetHidden(false)
                                ab:SetLevel(level)
                            end
                        end
                    end
                end
            end
        end
    end
end

--设置玩家数据
function MainGame:SetPlayerData(ID, team_key, player_key, data)
    if not ID then
        return
    end
    local hero = HeroData:GetHero(ID)
    data.p_id = ID
    data.hero_name = HeroData:GetHeroName(ID)
    data.point = Person.Data[ID].point
    local k = PlayerResource:GetKills(ID)
    local d = PlayerResource:GetDeaths(ID)
    local a = PlayerResource:GetAssists(ID)
    data.KDA.kill = k
    data.KDA.death = d
    data.KDA.assist = a
    if d <= 0 then
        d = 1
    end
    local kda_num = ((k + a) / d)
    data.KDA.kda = utilex:FloatSet(kda_num, 1)
    for i = 0, 5 do
        local item = hero:GetItemInSlot(i)
        local slot_num = i + 1
        if item then
            local slot_key = "slot_" .. slot_num
            data.items[slot_key] = item:GetName()
            local item_name = item:GetName()
            if item_name == "item_goods_17" or item_name == "item_goods_18" or item_name == "item_goods_19"
                or item_name == "item_goods_24" then
                data.talent = item_name
            end
        end
    end
    for i = 1, 10 do
        local skill_key = "skill_" .. i
        local slot_key = "slot_" .. i
        local skill_tp = 1
        if i <= 4 then
            skill_tp = 1
        else
            skill_tp = 2
        end
        local owner_skill_key = "Skill" .. skill_tp
        data.skill[skill_key] = Skill.Data[ID][owner_skill_key][slot_key].name
    end
    local team = PlayerResource:GetTeam(ID)
    local team_key = "Team" .. team
    if MainGame.OverData[team_key].result == 1 then
        data.add_point = 15
    else
        data.add_point = -10
    end
    data.gold = HeroData.Data[ID].gold
    data.damage = HeroData.Data[ID].damage
    data.tank = HeroData.Data[ID].tank
    data.tag = HeroData.Data[ID].tag
    self.OverData[team_key].player[player_key].data = data
end

--终极时刻
function MainGame:LastFight()
    local grant_once = not self.Data.lastfight_gold_done
    if grant_once then
        self.Data.lastfight_gold_done = true
    end
    for k, v in pairs(PD.IDs) do
        if v then
            local ID = v
            local hero = HeroData:GetHero(ID)
            if grant_once then
                PlayerResource:ModifyGold(ID, 20000, false, 0)
            end
            if hero and not hero:IsNull() then
                hero.LastGameState = true
            end
        end
    end

    -- 乱斗时刻：强制提升机器人已学肉搏技能到 10 级
    -- self:ForceUpgradeRobotMeleeSkills(10)
end

--设置获胜队伍(5v5 / 四队模式；1v1 单独)
function MainGame:SetWinTeam()
    if self:GetGameType() == 2 then
        self.Data.win_team = Stat:GetTopTeam()
        return
    end
    if self:GetGameType() == 3 then
        if self.Data.win_team == 0 then
            self.Data.win_team = self:ResolveFourTeamWinByKills()
        end
        return
    end
    if self.Data.win_team == 0 then
        local kill1 = MainGame.Data.kill.Team2
        local kill2 = MainGame.Data.kill.Team3
        --如果人头数相等
        if kill1 == kill2 then
            local damage1 = 0
            local damage2 = 0
            if kill1 == kill2 and kill1 == 0 then
                local num1 = Util:TabCount(Stat.Public.list.team_1.list)
                local num2 = Util:TabCount(Stat.Public.list.team_2.list)
                if num1 >= num2 then
                    self.Data.win_team = 1
                    return
                else
                    self.Data.win_team = 2
                    return
                end
            end

            for k, v in pairs(Stat.Public.list.team_1.list) do
                if v then
                    local ID = v.id
                    local dam = HeroData.Data[ID].damage
                    damage1 = damage1 + dam
                end
            end
            for k, v in pairs(Stat.Public.list.team_2.list) do
                if v then
                    local ID = v.id
                    local dam = HeroData.Data[ID].damage
                    damage2 = damage2 + dam
                end
            end
            if damage1 >= damage2 then
                self.Data.win_team = 1
            else
                self.Data.win_team = 2
            end
        end
        if kill1 >= kill2 then
            self.Data.win_team = 1
        else
            self.Data.win_team = 2
        end
    end
end

-- 开局全屏载入：人机不参与判定；已放弃玩家不等待；真人需 HeroData 初始化、Box dummy、宠物就绪
function MainGame:SessionLoadGateShouldWaitPlayer(ID)
    if not ID then
        return false
    end
    if Util:IsPseudoPlayerID(ID) then
        return false
    end
    if not Util:ID2IfValid(ID) then
        return false
    end
    if Util:ID2IfLeave(ID) then
        return false
    end
    return true
end

function MainGame:IsPlayerVirtualSessionReady(ID)
    if not self:SessionLoadGateShouldWaitPlayer(ID) then
        return true
    end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() or not hero:IsHero() then
        return false
    end
    local hd = HeroData.Data[ID]
    if not hd or hd.init ~= true then
        return false
    end
    local bd = Box.Data[ID]
    if not bd then
        return false
    end
    local idx = bd.dummy
    if type(idx) ~= "number" or idx <= 0 then
        return false
    end
    local dum = EntIndexToHScript(idx)
    if not dum or dum:IsNull() or not utilex:IsTrueEntity(dum) then
        return false
    end
    local petd = Pet.Data[ID]
    if not petd or petd.session_pet_ready ~= true then
        return false
    end
    return true
end

function MainGame:AllPlayersVirtualLoadReady()
    if not MainGame:GetDummy() then
        return false
    end
    if not PD or not PD.IDs then
        return false
    end
    for _, ID in pairs(PD.IDs) do
        if not self:IsPlayerVirtualSessionReady(ID) then
            return false
        end
    end
    return true
end

function MainGame:FinishSessionLoadGate()
    if self.Data.session_load_gate_finished then
        return
    end
    self.Data.session_load_gate_finished = true
    Util:Send2JsBotsSafe("UI_Loding", { page = false })
    Monster.Data.page = true
    Monster:SendData()
    Util:Send2JsBotsSafe("UI_Point", { page = true })
    if Prophecy and Prophecy.OpenForAllPlayers then
        Prophecy:OpenForAllPlayers()
    end
end

function MainGame:StartSessionLoadGatePoll()
    local ticks = 0
    local max_ticks = 600
    Timers(0, function()
        ticks = ticks + 1
        if self.Data.session_load_gate_finished then
            return
        end
        if self:AllPlayersVirtualLoadReady() then
            self:FinishSessionLoadGate()
            return
        end
        if ticks >= max_ticks then
            -- print("[MainGame] SessionLoadGate: timeout, forcing HUD unlock")
            self:FinishSessionLoadGate()
            return
        end
        return 0.1
    end)
end
