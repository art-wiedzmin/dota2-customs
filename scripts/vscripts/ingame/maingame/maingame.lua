--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if MainGame == nil then
    MainGame = class({})
    require("ingame.MainGame.Config")
    require("ingame.MainGame.Set")
    require("ingame.MainGame.Get")
    require("ingame.MainGame.ProgressGuard")
    require("ingame.MainGame.Func")
end

function MainGame:GameReady()
    if self.Data.session_load_gate_started then
        return
    end
    self.Data.session_load_gate_started = true
    Util:Send2JsBotsSafe("UI_Loding", { page = true })
    -- 载入层最长3 秒，超时强制隐藏；全员就绪门控仍在后台跑（Monster / UI_Point 等）
    Timers(3, function()
        Util:Send2JsBotsSafe("UI_Loding", { page = false })
    end)
    self:StartSessionLoadGatePoll()
    if not IsInToolsMode() and GameRules:IsCheatMode() then
        Util:Send2JsBotsSafe("UI_OverGame", { state = true })
    end
end

-- 游戏开始
function MainGame:GameStart()
    self.Data.passive_mode = false
    if Boot and Boot.Config then
        Boot.Config.bot_passive_mode = false
    end
    self.Data.session_load_gate_started = false
    self.Data.session_load_gate_finished = false
    self.Data.bgm_music_guard_started = false
    if OverStat and OverStat.ResetSession then
        OverStat:ResetSession()
    end
    if Server and Server.ResetClientLogDedup then
        Server:ResetClientLogDedup()
    end

    -- 游戏时间初始化
    Stat:InitSyS()
    -- MainGame:ReadyTime()
    MainGame:WeatherInit()
    MainGame:DayNightInit()
    -- 游戏全局定时器 + 缩圈/结算看门狗
    MainGame:StartTime()
    MainGame:StartProgressWatchdog()
    -- 初始化怪物出生点（从地图 random_point 实体加载）
    Monster:ReadyPos()
    -- 召唤野怪
    Monster:Create()
    Monster:LeaderTime()
    -- 召唤宝箱
    --Pack:CreatePack()
    -- 召唤传送门
    self:CreateDoor()
    MainGame:CreateHide()
    if DevTools and DevTools.GameReady then
        DevTools:GameReady()
    end
end

function MainGame:CreateHide()
    local pos = Vector(32.632824, -479.938049, 128.000015)
    local unit = CreateUnitByName("dummy", pos, true, nil, nil,
        DOTA_TEAM_NEUTRALS)
    utilex:AddModifier(unit, "modifier_petbuff")
    unit:AddNewModifier(unit, nil, "modifier_phased", { duration = 0.1 })
    local index = unit:GetEntityIndex()
    self.Data.dummy = index
end

function MainGame:CreateDoor()
    for k, v in pairs(self.Data.door) do if v then self:OpenDoor(k) end end
end

-- 游戏时间初始化
function MainGame:ReadyTime()
    local num = #PD.IDs
    local max = 10
    local need = max - num
    local addtime = need * 60
    self.EventList.game_over.time = self.EventList.game_over.time + addtime
    self.EventList.timeover1.time = self.EventList.game_over.time - 60
    self.EventList.timeover2.time = self.EventList.game_over.time - 120
end

-- 自定义昼夜初始化（禁用引擎默认循环，由 DayNightTick 驱动）
function MainGame:DayNightInit()
    self.Data.daynight_is_day = true
    self.Data.daynight_elapsed = 0
    GameRules:SetTimeOfDay(0.25)
end

-- 每秒推进昼夜；白天 0.25→0.75，黑夜 0.75→1.0→0.25
function MainGame:DayNightTick()
    local is_day = self.Data.daynight_is_day ~= false
    local duration = is_day and self.Static.day_time or self.Static.night_time
    if not duration or duration <= 0 then
        return
    end

    self.Data.daynight_elapsed = (self.Data.daynight_elapsed or 0) + 1
    if self.Data.daynight_elapsed >= duration then
        self.Data.daynight_elapsed = 0
        self.Data.daynight_is_day = not is_day
        is_day = self.Data.daynight_is_day
        duration = is_day and self.Static.day_time or self.Static.night_time
        if self.Data.weather == -1 then
            self.Data.weather_time = self:GetWeatherDuration()
        end
    end

    local frac = self.Data.daynight_elapsed / duration
    local tod
    if is_day then
        tod = 0.25 + 0.5 * frac
    else
        tod = 0.75 + 0.5 * frac
        if tod >= 1.0 then
            tod = tod - 1.0
        end
    end
    GameRules:SetTimeOfDay(tod)
end

-- 天气初始化
function MainGame:WeatherInit()
    self.Data.weather = -1
    self.Data.weather_last_id = nil
    self.Data.weather_time = self:GetWeatherDuration()
end

-- 天气触发器（每秒调用）
function MainGame:WeatherTrigger()
    if self.Data.weather ~= -1 then
        return
    end
    if self.Data.weather_time < 0 then
        self.Data.weather_time = self:GetWeatherDuration()
    end
    self.Data.weather_time = self.Data.weather_time - 1
    if self.Data.weather_time <= 0 then
        self:WeatherStar()
    end
end

-- 天气触发
function MainGame:WeatherLinkModifiers()
    LinkLuaModifier("modifier_weather_1", "ingame/modifier/modifier_weather_1",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_weather_2", "ingame/modifier/modifier_weather_2",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_weather_3", "ingame/modifier/modifier_weather_3",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_weather_4", "ingame/modifier/modifier_weather_4",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_weather_6", "ingame/modifier/modifier_weather_6",
        LUA_MODIFIER_MOTION_NONE)
end

function MainGame:WeatherGetConfig()
    if not self._weather_cfg then
        self._weather_cfg = {
            [1] = {
                tip = "福星高照：天赐祝福，全体玩家基础攻击力增加30%，技能增强增加15%",
                color = "orange",
                tx = "particles/rain_fx/econ_weather_harvest.vpcf",
            },
            [2] = {
                tip = "其疾如风：全体玩家攻速增加 60，移速增加 10%",
                color = "skyblue",
                tx = "particles/rain_fx/econ_weather_sirocco.vpcf",
            },
            [3] = {
                tip = "天降甘霖：全体玩家获得 BUFF 每秒恢复生命 3%",
                color = "greenyellow",
                tx = "particles/rain_fx/econ_rain.vpcf",
            },
            [4] = {
                tip = "冰天雪地：全体玩家获得 BUFF 攻击敌人后减少目标 60 攻速与 25%移速",
                color = "lightblue",
                tx = "particles/rain_fx/econ_snow.vpcf",
            },
            [6] = {
                tip = "雷霆降世：天雷滚滚，全体英雄受伤增加15%",
                color = "yellow",
                tx = "",
            },
        }
    end
    return self._weather_cfg
end

function MainGame:WeatherPickFromPool(pool)
    local last = self.Data.weather_last_id
    local candidates = pool
    if last then
        local filtered = {}
        for _, id in ipairs(pool) do
            if id ~= last then
                filtered[#filtered + 1] = id
            end
        end
        if #filtered > 0 then
            candidates = filtered
        end
    end
    return candidates[math.random(1, #candidates)]
end

function MainGame:WeatherRollId()
    if self:IsDaytime() then
        return self:WeatherPickFromPool({ 1, 2, 3, 4 })
    end
    return self:WeatherPickFromPool({ 1, 2, 3, 4, 6 })
end

function MainGame:Weather6StopThunderStrikes()
    self.Data.weather_6_thunder_gen = (self.Data.weather_6_thunder_gen or 0) + 1
end

function MainGame:Weather6PlayThunderStrikeOnHero(hero)
    if not hero or hero:IsNull() or not hero:IsAlive() then
        return
    end
    local path = "particles/econ/items/zeus/arcana_chariot/zeus_tgw_screen_damage.vpcf"
    local fx = ParticleManager:CreateParticle(path, PATTACH_EYES_FOLLOW, hero)
    Timers(3, function()
        if fx then
            ParticleManager:DestroyParticle(fx, true)
            ParticleManager:ReleaseParticleIndex(fx)
        end
    end)
    EmitSoundOn("Hero_Zuus.GodsWrath", hero)
end

function MainGame:Weather6PlayThunderStrike()
    for k, v in pairs(utilex:GetAllPlayer()) do
        if v and not (Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(v)) then
            local hero = Util:ID2Hero(v)
            if hero then
                self:Weather6PlayThunderStrikeOnHero(hero)
            end
        end
    end
end

function MainGame:Weather6StartThunderStrikes()
    self:Weather6StopThunderStrikes()
    local gen = self.Data.weather_6_thunder_gen
    local function schedule_next()
        if not MainGame or MainGame.Data.weather ~= 6 then
            return
        end
        if MainGame.Data.weather_6_thunder_gen ~= gen then
            return
        end
        local delay = RandomFloat(40, 60)
        Timers(delay, function()
            if not MainGame or MainGame.Data.weather ~= 6 then
                return
            end
            if MainGame.Data.weather_6_thunder_gen ~= gen then
                return
            end
            MainGame:Weather6PlayThunderStrike()
            schedule_next()
        end)
    end
    schedule_next()
end

function MainGame:WeatherApplyBuffs(roll_weather, time, tx)
    local buff_name = "modifier_weather_" .. roll_weather
    for k, v in pairs(utilex:GetAllPlayer()) do
        if v and not (Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(v)) then
            local hero = Util:ID2Hero(v)
            if hero then
                if tx ~= "" and roll_weather ~= 4 then
                    utilex:AddTx(tx, hero, time)
                end
                if not hero:HasModifier("modifier_weather_5") then
                    hero:AddNewModifier(hero, self, buff_name, { dur = time })
                end
            end
        end
    end
    if roll_weather == 6 then
        self:Weather6StartThunderStrikes()
    end
end

function MainGame:WeatherEndTimer(time)
    Timers(time, function()
        if not MainGame or not MainGame.Data then
            return
        end
        MainGame:Weather6StopThunderStrikes()
        local ended = MainGame.Data.weather
        if ended and ended ~= -1 then
            MainGame.Data.weather_last_id = ended
        end
        MainGame.Data.weather = -1
        MainGame.Data.weather_time = MainGame:GetWeatherDuration()
    end)
end

function MainGame:WeatherStartById(weather_id, duration)
    if not weather_id then
        return
    end
    local cfg = self:WeatherGetConfig()[weather_id]
    if not cfg then
        return
    end
    self:WeatherLinkModifiers()
    self:Weather6StopThunderStrikes()
    duration = duration or self:GetWeatherDuration()
    self.Data.weather = weather_id
    Util:TopMsg2All(cfg.tip, cfg.color, 5)
    self:WeatherApplyBuffs(weather_id, duration, cfg.tx or "")
    self:WeatherEndTimer(duration)
end

function MainGame:WeatherStar(forced_id)
    self:WeatherLinkModifiers()
    local roll_weather = forced_id or self:WeatherRollId()
    self.Data.weather = roll_weather
    local cfg = self:WeatherGetConfig()[roll_weather]
    if not cfg then
        self.Data.weather = -1
        return
    end
    local time = self:GetWeatherDuration()
    Util:TopMsg2All(cfg.tip, cfg.color, 5)
    self:WeatherApplyBuffs(roll_weather, time, cfg.tx or "")
    self:WeatherEndTimer(time)
end

-- 第一次缩圈
function MainGame:MapChange1()
    Util:TopMsg2All("瘟疫开始蔓延！", "red", 5, "#000000cc")
    self.Data.state = 2
    local pos = Monster.Static.map_center
    local rang1 = self.Static.rang1
    local str = "particles/death_ring.vpcf"


    local all_pos = Entities:FindAllByClassname("info_target")
    for _, v in pairs(all_pos) do
        if v and not v:IsNull() and v:GetName() == "random_point" then
            UTIL_Remove(v)
        end
    end

    Monster.Data.stage = 1
    Monster:RefreshPosForRing(rang1)
    MainGame:ClearDoor()
    Monster:SendData()

    -- 释放毒圈
    Timers(0.5, function()
        local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(fx, 0,
            Vector(187.841660, -644.767456, 350))
        ParticleManager:SetParticleControl(fx, 2,
            Vector(187.841660, -644.767456, 350))
        ParticleManager:SetParticleShouldCheckFoW(fx, false)
        ParticleManager:SetParticleControl(fx, 11,
            Vector(rang1, -644.767456, 400));
        self.Data.tx = fx
    end)
    Timers(2, function()
        if self.Data.state ~= 2 then return end
        local search_radius = 14000
        local team_both = DOTA_UNIT_TARGET_TEAM_BOTH
        local basics = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_BOTH, pos, nil,
            search_radius, team_both, DOTA_UNIT_TARGET_BASIC, 0, 1, false)
        for _, v in pairs(basics) do
            if v and utilex:IsTrueEntity(v) and not v:IsHero() and not utilex:IsClrbCourierPet(v) then
                local len = (pos - v:GetAbsOrigin()):Length2D()
                if len >= rang1 then
                    v:AddNoDraw()
                    local time = math.random(1, 3)
                    Timers(time, function()
                        if v and IsValidEntity(v) and not v:IsNull() and not utilex:IsClrbCourierPet(v) then
                            UTIL_Remove(v)
                        end
                    end)
                end
            end
        end
    end)
end

-- 第二次缩圈
function MainGame:MapChange2()
    Util:TopMsg2All("瘟疫再次扩散！", "red", 5, "#000000cc")
    self.Data.state = 3
    Monster.Data.stage = 2
    Monster:RefreshPosForRing(MainGame.Static.rang2)
    local pos = Monster.Static.map_center
    local rang2 = self.Static.rang2
    local fx = self.Data.tx
    --毒圈收缩
    if fx then
        ParticleManager:SetParticleControl(fx, 11, Vector(rang2, -644.767456, 400))
    end
    Monster:SendData()
    local all_pos = Entities:FindAllByClassname("info_target")
    for _, v in pairs(all_pos) do
        if v and not v:IsNull() and v:GetName() == "random_point" then
            UTIL_Remove(v)
        end
    end

    Timers(2, function()
        if self.Data.state ~= 3 then return end
        local search_radius = 14000
        local team_both = DOTA_UNIT_TARGET_TEAM_BOTH

        local basics = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_BOTH, pos, nil,
            search_radius, team_both, DOTA_UNIT_TARGET_BASIC, 0, 1, false)
        for _, v in pairs(basics) do
            if v and utilex:IsTrueEntity(v) and not v:IsHero() and not utilex:IsClrbCourierPet(v) then
                local len = (pos - v:GetAbsOrigin()):Length2D()
                if len >= rang2 then
                    v:AddNoDraw()
                    local time = math.random(1, 3)
                    Timers(time, function()
                        if v and IsValidEntity(v) and not v:IsNull() and not utilex:IsClrbCourierPet(v) then
                            UTIL_Remove(v)
                        end
                    end)
                end
            end
        end
    end)
end

-- 英雄击杀计数
function MainGame:HeroKillAdd(hero)
    if not hero then return end
    local ID = Util:Hero2ID(hero)
    if not ID then return end
    if self.Data.over then return end
    -- HeroData.Data[ID].kill = HeroData.Data[ID].kill + 1
    local team = hero:GetTeam()
    -- local team_key = "Team" .. team
    -- self.OverData[team_key].kill = self.OverData[team_key].kill + 1
    if MainGame:GetGameType() == 2 then
        -- print("玩家" .. ID .. "击杀数量：" .. HeroData.Data[ID].kill)
        if HeroData.Data[ID].kill >= self:GetPersonKillTarget() then
            MainGame:TimerOver()
            return
        end
    end
    if MainGame:GetGameType() == 3 then
        local label = ({
            [2] = "天辉",
            [3] = "夜魇",
            [6] = "阵营三",
            [7] = "阵营四",
        })[team]
        local key = ({ [2] = "Team2", [3] = "Team3", [6] = "Team6", [7] = "Team7" })[team]
        if key and label then
            self.Data.kill[key] = self.Data.kill[key] + 1
            local k = self.Data.kill[key]
            local tk = self:GetTeamKillTarget()
            local remain = tk - k
            if remain == 20 or remain == 10 or remain == 5 then
                Util:TopMsg2All(label .. "距离游戏胜利还剩余" .. tostring(remain) .. "次击杀！", "red", 3)
                if remain == 20 or remain == 10 then
                    utilex:SoundAll(remain == 20 and "needkill20" or "needkill10")
                end
            end
            if k >= tk then
                MainGame:TimerOver()
            end
        end
        return
    end
    if MainGame:GetGameType() == 1 then
        if team == 2 then
            self.Data.kill.Team2 = self.Data.kill.Team2 + 1
            if self.Static.team_kill - self.Data.kill.Team2 == 20 then
                Util:TopMsg2All("天辉距离游戏胜利还剩余20次击杀！",
                    "red", 3)
                utilex:SoundAll("needkill20")
            end
            if self.Static.team_kill - self.Data.kill.Team2 == 10 then
                Util:TopMsg2All("天辉距离游戏胜利还剩余10次击杀！",
                    "red", 3)
                utilex:SoundAll("needkill10")
            end
            if self.Static.team_kill - self.Data.kill.Team2 == 5 then
                Util:TopMsg2All("天辉距离游戏胜利还剩余5次击杀！",
                    "red", 3)
            end
            if self.Data.kill.Team2 >= self.Static.team_kill then
                MainGame:TimerOver()
                return
            end
        end
        if team == 3 then
            self.Data.kill.Team3 = self.Data.kill.Team3 + 1
            if self.Static.team_kill - self.Data.kill.Team3 == 20 then
                Util:TopMsg2All("夜宴距离游戏胜利还剩余20次击杀！",
                    "red", 3)
                utilex:SoundAll("needkill20")
            end
            if self.Static.team_kill - self.Data.kill.Team3 == 10 then
                Util:TopMsg2All("夜宴距离游戏胜利还剩余10次击杀！",
                    "red", 3)
                utilex:SoundAll("needkill10")
            end
            if self.Static.team_kill - self.Data.kill.Team3 == 5 then
                Util:TopMsg2All("夜宴距离游戏胜利还剩余5次击杀！",
                    "red", 3)
            end
            if self.Data.kill.Team3 >= self.Static.team_kill then
                MainGame:TimerOver()
                return
            end
        end
    end
end

-- 时间结束
function MainGame:TimerOver()
    -- print("时间结束")
    if self.Data.over == true then return end
    utilex:SlowMotion()
    if Stat and Stat.SendPublicData then
        Stat:SendPublicData(true)
    end
    self.Data.over = true
    if self:GetGameType() == 3 then
        self.Data.win_team = self:ResolveFourTeamWinByKills()
    else
        local team2_num = self.Data.kill.Team2
        local team3_num = self.Data.kill.Team3
        if team2_num >= team3_num then
            self.Data.win_team = 1
        else
            self.Data.win_team = 2
        end
    end
    Timers(1, function()
        self:GameOver()
    end)
end

-- 游戏结束
function MainGame:GameOver()
    if Monster and Monster.OnSettlementUIStart then
        Monster:OnSettlementUIStart()
    end
    OverData:InitPublic()
    -- 设置获胜队伍
    self:SetWinTeam()
    -- 结算称号
    self:SetTag()
    -- 更新排名
    Stat:UpDataRank()
    Stat:TopListUpData()
    for k, v in pairs(PD.IDs) do
        if v then
            OverData:LoadData(v)
            OverData:OpenPage(v)
            OverData:SendData(v)
            local hero = Util:ID2Hero(v)
            if hero and not hero:IsNull() then
                utilex:AddModifier(hero, "modifier_petbuff")
            end
        end
    end
    if BotAI and BotAI.CleanupForSettlementUI then
        Timers(1, function()
            BotAI:CleanupForSettlementUI()
        end)
    end
    MainGame:ExitGame()
end

function MainGame:ExitGame()
    local tx = self.Data.tx
    utilex:ClearTx(tx)
    -- 记录对局
    OverData:LogGame()
end
