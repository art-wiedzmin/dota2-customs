--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if OverStat == nil then
    OverStat = class({})
    require("ingame.OverStat.Config")
    require("ingame.OverStat.Get")
end

local ITEM_SLOT_MAX = 23

local MILESTONE_SECS = { 300, 600, 900, 1200 }

function OverStat:ResetSession()
    self.Disconnects = {}
    self.MilestoneDone = {}
    self.MilestoneData = {}
    self.Star16At = {}
    self.ItemGainByPid = {}
end

--- 由 MainGame 每秒调用：在 5/10/15/20 分钟各打一次全人类玩家快照
function OverStat:TickSample()
    local t = self:GetGameTimeDota()
    if not self.MilestoneDone then
        self.MilestoneDone = {}
    end
    if not self.MilestoneData then
        self.MilestoneData = {}
    end
    for _, m in ipairs(MILESTONE_SECS) do
        if t >= m and not self.MilestoneDone[m] then
            self.MilestoneDone[m] = true
            local snap = { by_pid = {} }
            for _, ID in pairs(PD.IDs or {}) do
                local init = InitPlayer:GetPlayerData(ID)
                if init and not init.bot then
                    local pid = PlayerResource:GetSteamAccountID(ID)
                    local gold = (HeroData.Data[ID] and HeroData.Data[ID].gold) or 0
                    local lh = PlayerResource:GetLastHits(ID) or 0
                    snap.by_pid[pid] = {
                        gold = gold,
                        last_hits = lh,
                    }
                end
            end
            self.MilestoneData[m] = snap
        end
    end
end

--- 升星时调用，记录首次达到 16 星的游戏内秒数（与 IsStar16 判定一致）
function OverStat:OnStarUpdate(ID, star)
    if not ID or not star then
        return
    end
    local init = InitPlayer:GetPlayerData(ID)
    if not init or init.bot then
        return
    end
    local bonus = (HeroData.Static and HeroData.Static.star_display_bonus) or 3
    if star + bonus < 16 then
        return
    end
    if not self.Star16At then
        self.Star16At = {}
    end
    if self.Star16At[ID] then
        return
    end
    self.Star16At[ID] = math.ceil(self:GetGameTimeDota())
end

--- Item:AddItem 等路径调用：记录获得装备的时间点（用于后台「购买/获得时机」）
function OverStat:RecordItemGain(ID, item_name)
    if not ID or not item_name or item_name == "" then
        return
    end
    local init = InitPlayer:GetPlayerData(ID)
    if not init or init.bot then
        return
    end
    local pid = PlayerResource:GetSteamAccountID(ID)
    if not self.ItemGainByPid then
        self.ItemGainByPid = {}
    end
    if not self.ItemGainByPid[pid] then
        self.ItemGainByPid[pid] = {}
    end
    local list = self.ItemGainByPid[pid]
    local maxN = self.MAX_ITEM_GAIN_EVENTS or 400
    if #list >= maxN then
        return
    end
    table.insert(list, {
        name = item_name,
        game_time = self:GetGameTimeDota(),
        game_time_ceil = math.ceil(self:GetGameTimeDota()),
    })
end

function OverStat:BuildEconomyMilestonesSummary()
    local out = {}
    for _, m in ipairs(MILESTONE_SECS) do
        local data = self.MilestoneData and self.MilestoneData[m]
        if data and data.by_pid then
            local min_gold, max_gold = nil, nil
            local min_lh, max_lh = nil, nil
            local n = 0
            for _, row in pairs(data.by_pid) do
                n = n + 1
                local g = row.gold or 0
                local lh = row.last_hits or 0
                if min_gold == nil or g < min_gold then
                    min_gold = g
                end
                if max_gold == nil or g > max_gold then
                    max_gold = g
                end
                if min_lh == nil or lh < min_lh then
                    min_lh = lh
                end
                if max_lh == nil or lh > max_lh then
                    max_lh = lh
                end
            end
            out[tostring(m)] = {
                label_sec = m,
                players_sampled = n,
                min_gold = min_gold or 0,
                max_gold = max_gold or 0,
                min_last_hits = min_lh or 0,
                max_last_hits = max_lh or 0,
            }
        end
    end
    return out
end

function OverStat:CollectHeroAttrsEnd(ID, hero)
    local row = {}
    if not hero or hero:IsNull() then
        return row
    end
    row.star = (HeroData.Data[ID] and HeroData.Data[ID].star) or 0
    row.gold_custom = (HeroData.Data[ID] and HeroData.Data[ID].gold) or 0
    if hero.GetBaseDamage then
        row.base_damage = math.floor(hero:GetBaseDamage() + 0.5)
    end
    if hero.GetPhysicalArmorBase then
        row.armor_base = hero:GetPhysicalArmorBase()
    end
    if hero.GetIdealSpeed then
        row.move_speed = math.floor(hero:GetIdealSpeed() + 0.5)
    end
    -- 当前引擎：Str/Agi 仅 1 个形参；Intellect 需第二参数 includeModifiers（与项目内 GetIntellect(true) 一致）
    if hero.GetStrength then
        row.str = math.floor(hero:GetStrength() + 0.5)
    end
    if hero.GetAgility then
        row.agi = math.floor(hero:GetAgility() + 0.5)
    end
    if hero.GetIntellect then
        row.int = math.floor(hero:GetIntellect(true) + 0.5)
    end
    return row
end

function OverStat:CopyItemGainsForPid(steam32)
    local list = {}
    if not steam32 or not self.ItemGainByPid then
        return list
    end
    local src = self.ItemGainByPid[steam32]
    if not src then
        return list
    end
    return Util:DeepCopyTab(src)
end

function OverStat:Init(ID)
    if not ID then
        return
    end
    if not self.Data then
        self.Data = {}
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template or {})
end

---@param ID number PlayerID
function OverStat:OnPlayerDisconnect(ID)
    if ID == nil or ID < 0 then
        return
    end
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data or init_data.bot then
        return
    end
    if not self.Disconnects then
        self.Disconnects = {}
    end
    if not self.Disconnects[ID] then
        self.Disconnects[ID] = {}
    end
    local t = self:GetGameTimeDota()
    table.insert(self.Disconnects[ID], {
        game_time = t,
        game_time_ceil = math.ceil(t),
    })
end

function OverStat:CollectSkills(ID)
    local by_slot = {}
    for i = 1, 10 do
        by_slot[i] = {
            slot = i,
            ability_name = "",
            name_zh = "",
            active = false,
        }
    end
    if not ID or not Skill or not Skill.Data or not Skill.Data[ID] then
        local list = {}
        for i = 1, 10 do
            list[i] = by_slot[i]
        end
        return list
    end
    local data = Skill.Data[ID]
    if data.Skill1 then
        for _, v in pairs(data.Skill1) do
            if v and v.slot then
                local index = v.slot
                local row = by_slot[index]
                if row then
                    if v.id == -1 then
                        row.active = false
                        row.ability_name = ""
                        row.name_zh = ""
                    else
                        row.active = true
                        row.ability_name = v.name or ""
                        row.name_zh = Skill:GetAbSkillName(v.name) or ""
                    end
                end
            end
        end
    end
    if data.Skill2 then
        for _, v in pairs(data.Skill2) do
            if v and v.slot then
                local index = v.slot
                local row = by_slot[index]
                if row then
                    if v.state == false then
                        row.active = false
                        row.ability_name = ""
                        row.name_zh = ""
                    else
                        row.active = true
                        row.ability_name = ""
                        row.name_zh = v.name or ""
                    end
                end
            end
        end
    end
    local list = {}
    for i = 1, 10 do
        list[i] = by_slot[i]
    end
    return list
end

function OverStat:CollectHeroUnitAbilities(hero)
    local list = {}
    if not hero or hero:IsNull() then
        return list
    end
    local n = hero:GetAbilityCount() - 1
    if n < 0 then
        return list
    end
    for i = 0, n do
        local ab = hero:GetAbilityByIndex(i)
        if ab and not ab:IsNull() then
            local an = ab:GetAbilityName()
            if an and an ~= "" and an ~= "generic_hidden" then
                if string.sub(an, 1, 5) == "item_" then
                    -- 装备在 items 中单独列出
                else
                local title = self:AbilityTitleZh(an)
                if title == "" then
                    title = an
                end
                table.insert(list, {
                    ability_name = an,
                    name_zh = title,
                    level = ab:GetLevel(),
                })
                end
            end
        end
    end
    return list
end

function OverStat:CollectItems(ID, hero)
    local list = {}
    if not hero or hero:IsNull() then
        return list
    end
    for slot = 0, ITEM_SLOT_MAX do
        local it = hero:GetItemInSlot(slot)
        if it and not it:IsNull() then
            local n = it:GetName()
            local zh = self:ItemTitleZh(n)
            if zh == "" then
                zh = n
            end
            table.insert(list, {
                slot = slot,
                name = n,
                name_zh = zh,
            })
        end
    end
    return list
end

function OverStat:BuildOutcome(ID, game_tp)
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data then
        return {}
    end
    if game_tp == 1 then
        local team = Stat:GetTeam(init_data.team)
        local win = team and team == MainGame.Data.win_team
        return {
            mode = "5v5",
            win = win and true or false,
            result_zh = win and "胜" or "负",
        }
    end
    if game_tp == 3 then
        local team = Stat:GetTeam(init_data.team)
        local win = team and team == MainGame.Data.win_team
        return {
            mode = "3x4",
            win = win and true or false,
            result_zh = win and "胜" or "负",
        }
    end
    if game_tp == 2 then
        local rank = Stat:GetTeamRank(ID)
        if not rank then
            rank = -1
        end
        local rz = rank > 0 and ("第" .. tostring(rank) .. "名") or "名次未知"
        return {
            mode = "1v1",
            rank = rank,
            result_zh = rz,
        }
    end
    return { mode = "unknown" }
end

function OverStat:BuildPlayerSnapshot(ID, game_tp, duration_ceil)
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data or init_data.bot then
        return nil
    end
    local hero = HeroData:GetHero(ID)
    local hero_name_cn = HeroData:GetHeroName(ID) or ""
    local unit_name = ""
    if hero and not hero:IsNull() then
        unit_name = hero:GetUnitName() or ""
    end
    local steam32 = PlayerResource:GetSteamAccountID(ID)
    local pid64 = utilex:ConvertSteamID32To64_Safe(steam32)
    local dc = {}
    if self.Disconnects and self.Disconnects[ID] then
        dc = Util:DeepCopyTab(self.Disconnects[ID])
    end
    local s16 = nil
    if self.Star16At and self.Star16At[ID] then
        s16 = self.Star16At[ID]
    end
    return {
        -- pid：Steam 账号 ID（32 位），与 players[].pid / user.pid 一致
        pid = steam32,
        steam_id64 = pid64,
        player_id = ID,
        hero_name_cn = hero_name_cn,
        hero_unit_name = unit_name,
        outcome = self:BuildOutcome(ID, game_tp),
        skills_book = self:CollectSkills(ID),
        hero_abilities = self:CollectHeroUnitAbilities(hero),
        items = self:CollectItems(ID, hero),
        disconnect_count = #dc,
        disconnects = dc,
        match_duration_game = duration_ceil,
        hero_attrs_end = self:CollectHeroAttrsEnd(ID, hero),
        star_reach_16_at_sec = s16,
        item_gain_events = self:CopyItemGainsForPid(steam32),
    }
end

--- 与 OverData:LogGame 同条件（无机器人）；返回列表供写入上报 JSON
function OverStat:BuildAllForLog(game_tp, duration_ceil)
    local out = {}
    for _, ID in pairs(PD.IDs or {}) do
        local row = self:BuildPlayerSnapshot(ID, game_tp, duration_ceil)
        if row then
            table.insert(out, row)
        end
    end
    return out
end
