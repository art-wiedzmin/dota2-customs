--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--获取当前游戏进程
function MainGame:GetState()
    return self.Data.state
end

--获取当前游戏分钟
function MainGame:GetTimeMin()
    local time = GameRules:GetDOTATime(true, true)
    local min = math.floor(time / 60)
    return min
end

--获取当前游戏秒数
function MainGame:GetTime()
    local time = GameRules:GetDOTATime(true, true)
    return math.floor(time)
end

--获取对象传送
function MainGame:GetDoorTarget(name)
    if name == "door1" then
        return self.Data.door.doors1.door2.pos
    end
    if name == "door2" then
        return self.Data.door.doors1.door1.pos
    end
    if name == "door3" then
        return self.Data.door.doors2.door4.pos
    end
    if name == "door4" then
        return self.Data.door.doors2.door3.pos
    end
end

--- 当前地图阵营总击杀胜利线（5v5 用 team_kill；rank_3x4 用 team_kill_3x4）
function MainGame:GetTeamKillTarget()
    if self:GetGameType() == 3 then
        local n = self.Static.team_kill_3x4
        if type(n) == "number" and n > 0 then
            return n
        end
    end
    return self.Static.team_kill
end

--- 个人击杀胜利线（rank_1v1 / beidong，game_type==2）
function MainGame:GetPersonKillTarget()
    local map = GetMapName()
    if map == "rank_1v1" or map == "beidong" then
        local n = self.Static.person_kill_rank_1v1
        if type(n) == "number" and n > 0 then
            return n
        end
    end
    return self.Static.person_kill
end

--获取游戏模式（1=5v5；2=rank_1v1 / beidong（个人击杀）；3=rank_3x4）
function MainGame:GetGameType()
    local map = GetMapName()
    if map == "rank_5v5" then
        return 1
    end
    if map == "rank_3x4" then
        return 3
    end
    -- beidong：与 rank_1v1 相同（个人击杀决胜、计分板十队等）
    if map == "rank_1v1" or map == "beidong" then
        return 2
    end
end

--- 天辉侧（team_1）在计分板 / rank 编号中的最大人数（仅 5v5）
function MainGame:GetDualTeamSlotCapRadiant()
    return 5
end

--- 夜魇侧（team_2）最大人数（仅 5v5）
function MainGame:GetDualTeamSlotCapDire()
    return 5
end

--- 四队模式：按阵营人头与伤害决出 1~4 胜队索引（与 Stat team_1..4 一致）
function MainGame:ResolveFourTeamWinByKills()
    local rows = {
        { si = 1, k = self.Data.kill.Team2 },
        { si = 2, k = self.Data.kill.Team3 },
        { si = 3, k = self.Data.kill.Team6 },
        { si = 4, k = self.Data.kill.Team7 },
    }
    local best_k = -1
    for _, row in ipairs(rows) do
        if row.k > best_k then
            best_k = row.k
        end
    end
    local cands = {}
    for _, row in ipairs(rows) do
        if row.k == best_k then
            cands[#cands + 1] = row.si
        end
    end
    if #cands == 1 then
        return cands[1]
    end
    local best_d = -1
    local winner = cands[1]
    for _, si in ipairs(cands) do
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
        if dsum > best_d then
            best_d = dsum
            winner = si
        end
    end
    return winner
end

function MainGame:GetDummy()
    local index = self.Data.dummy
    local unit = EntIndexToHScript(index)
    if unit then
        return unit
    end
end

function MainGame:GetLastFight()
    return self.EventList.lastfight.state
end

function MainGame:GetPassiveMode()
    return self.Data.passive_mode
end

--- 当前是否为白天（自定义昼夜循环）
function MainGame:IsDaytime()
    if self.Data and self.Data.daynight_is_day ~= nil then
        return self.Data.daynight_is_day == true
    end
    local gr = GameRules
    if gr and gr.IsDaytime then
        return gr:IsDaytime()
    end
    return true
end

--- 当前时段天气效果持续时间（秒）
function MainGame:GetWeatherDuration()
    if self:IsDaytime() then
        return self.Static.weather_time_day or 120
    end
    return self.Static.weather_time_night or 180
end

--- 被动模式下是否禁用该物品（购买、合成入库、使用）。与 Boot.Config 双源，避免 Data 未同步时漏拦。
--- 列表里写成品时，自动视为同时禁用对应配方 item_recipe_*（商店买配方不走成品名）。
function MainGame:IsPassiveModeBannedPurchaseItem(item_name)
    if not item_name or item_name == "" then
        return false
    end
    local passive = self:GetPassiveMode()
    if not passive and Boot and Boot.Config and Boot.Config.bot_passive_mode == true then
        passive = true
    end
    if not passive then
        return false
    end
    local t = self.Static.PassiveModeBannedShopItems
    if t == nil then
        return false
    end
    if t[item_name] == true then
        return true
    end
    if string.sub(item_name, 1, 12) == "item_recipe_" then
        local implied = string.gsub(item_name, "^item_recipe_", "item_", 1)
        if t[implied] == true then
            return true
        end
    end
    return false
end
