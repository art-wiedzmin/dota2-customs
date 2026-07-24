--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local TEAM_NEUTRALS = rawget(_G, "DOTA_TEAM_NEUTRALS") or 4
local ORDER_ATTACK = rawget(_G, "DOTA_UNIT_ORDER_ATTACK_TARGET") or 4
local ORDER_MOVE = rawget(_G, "DOTA_UNIT_ORDER_MOVE_TO_POSITION") or 1
local ORDER_CAST_TARGET = rawget(_G, "DOTA_UNIT_ORDER_CAST_TARGET") or 5
local ORDER_CAST_POSITION = rawget(_G, "DOTA_UNIT_ORDER_CAST_POSITION") or 6
local ORDER_CAST_NO_TARGET = rawget(_G, "DOTA_UNIT_ORDER_CAST_NO_TARGET") or 8
local TARGET_TEAM_ENEMY = rawget(_G, "DOTA_UNIT_TARGET_TEAM_ENEMY") or 2
local TARGET_TEAM_BOTH = rawget(_G, "DOTA_UNIT_TARGET_TEAM_BOTH") or 3
local TARGET_HERO = rawget(_G, "DOTA_UNIT_TARGET_HERO") or 1
local TARGET_BASIC = rawget(_G, "DOTA_UNIT_TARGET_BASIC") or 2
local TARGET_FLAG = rawget(_G, "DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES") or 16
local FIND_ANY_ORDER = rawget(_G, "FIND_ANY_ORDER") or 0
local BEHAVIOR_NO_TARGET = rawget(_G, "DOTA_ABILITY_BEHAVIOR_NO_TARGET") or 4
local BEHAVIOR_UNIT_TARGET = rawget(_G, "DOTA_ABILITY_BEHAVIOR_UNIT_TARGET") or 8
local BEHAVIOR_POINT = rawget(_G, "DOTA_ABILITY_BEHAVIOR_POINT") or 16
local BEHAVIOR_TOGGLE = rawget(_G, "DOTA_ABILITY_BEHAVIOR_TOGGLE") or 512
local BEHAVIOR_PASSIVE = rawget(_G, "DOTA_ABILITY_BEHAVIOR_PASSIVE") or 2
local BEHAVIOR_HIDDEN = rawget(_G, "DOTA_ABILITY_BEHAVIOR_HIDDEN") or 1
local bit_ref = rawget(_G, "bit")
local bit_band = bit_ref and bit_ref.band
local ExecuteOrderFromTableFn = rawget(_G, "ExecuteOrderFromTable")
local GameRulesRef = rawget(_G, "GameRules")
local STATE_POST_GAME = rawget(_G, "DOTA_GAMERULES_STATE_POST_GAME")
local UTIL_RemoveFn = rawget(_G, "UTIL_Remove")
local GetItemCostFn = rawget(_G, "GetItemCost")

-- 与 init.precache.modifier_all / BotAI.lua 重复注册无害；保证本文件内 AddNewModifier 前人机 modifier 已链接（工具重载/异常顺序）
do
    local link = rawget(_G, "LinkLuaModifier")
    local motion = rawget(_G, "LUA_MODIFIER_MOTION_NONE") or 0
    if link then
        link("modifier_bot_innate_mana_regen", "ingame/modifier/modifier_bot_innate_mana_regen", motion)
        link("modifier_bot_innate_level_base_attack",
            "ingame/modifier/modifier_bot_innate_level_base_attack", motion)
    end
end

-- 力量人机缩圈后必得其三之一：狂战士之吼(93)、决斗(81)、牺牲/生命撕裂(22)；施放前尝试刃甲
local STR_BOT_TAUNT_SKILL_IDS = { 93, 81, 22 }
local STR_BOT_TAUNT_ABILITY_NAMES = {
    axe_berserkers_call = true,
    legion_commander_duel = true,
    huskar_life_break = true,
}

-- 巡逻点来自 HeroData.Rebron1（缩圈前）/ Rebron2（MainGame.Data.state>=2），全 Bot 共用缓存；TTL 仅减少同阶段重复组表
local BOTAI_PATROL_CACHE_TTL = 9.0
-- 人机：不拾取肉搏书，按间隔自动从英雄类型白名单学习
local BOTAI_AUTO_MELEE_LEARN_INTERVAL = 60
-- Think 内战斗索敌：复用上次结果，减少连续 Think 重复 FindUnits
local BOTAI_COMBAT_TARGET_CACHE_TTL = 0.42
-- 无敌方英雄时 TARGET_BASIC（兵+野）极重：每人机最小间隔再扫，间隔内沿用仍存活的上次兵线目标
local BOTAI_BASIC_SCAN_MIN_INTERVAL = 0.55
-- 略低于旧值：多数英雄视野 < 2200，缩半径可减轻 FindUnitsInRadius 压力
local BOTAI_COMBAT_RADIUS_CAP = 2200
-- 巡逻候选范围：若与索敌共用视野半径，人机只会反复走向身边几个营地；单独上限可大于战斗索敌帽
local BOTAI_PATROL_RADIUS_CAP = 5600
local BOTAI_PATROL_RADIUS_MULT = 2.15
local BOTAI_PATROL_RADIUS_MIN = 3600
local botai_patrol_cache = { t = -1e9, ring_key = nil, positions = {} }
-- 与 HeroData/Get POISON_RING_RESPAWN_INSET 一致；毒伤按 len > rang 判圈外
local BOTAI_PATROL_RING_INSET = 450

local function botai_game_time()
    return GameRulesRef and GameRulesRef.GetGameTime and GameRulesRef:GetGameTime() or 0
end

--- 与 BotAI:IsMainGamePoisonRingShrunk 一致：首次缩圈后 state>=2 用 Rebron2
local function botai_patrol_ring_phase_key()
    if MainGame and MainGame.Data and type(MainGame.Data.state) == "number" and MainGame.Data.state >= 2 then
        return "post"
    end
    return "pre"
end

local function botai_rebron_table_to_positions(tab)
    local out = {}
    if type(tab) ~= "table" then
        return out
    end
    for i = 1, 64 do
        local p = tab["pos" .. i]
        if p then
            out[#out + 1] = p
        end
    end
    return out
end

local function botai_refresh_patrol_positions()
    local ring_key = botai_patrol_ring_phase_key()
    local now = botai_game_time()
    if botai_patrol_cache.ring_key == ring_key and (now - botai_patrol_cache.t) < BOTAI_PATROL_CACHE_TTL then
        return
    end
    botai_patrol_cache.t = now
    botai_patrol_cache.ring_key = ring_key
    local tab = (ring_key == "post") and (HeroData and HeroData.Rebron2) or (HeroData and HeroData.Rebron1)
    botai_patrol_cache.positions = botai_rebron_table_to_positions(tab)
end

--- state 2→一圈 rang1，state 3+→二圈 rang2；缩圈前不限
local function botai_patrol_allowed_radius_from_map_center()
    if not MainGame or not MainGame.Data or type(MainGame.Data.state) ~= "number" then
        return nil
    end
    local st = MainGame.Data.state
    if st < 2 then
        return nil
    end
    local static = MainGame.Static
    if not static then
        return nil
    end
    local r = (st >= 3) and static.rang2 or static.rang1
    if not r or r <= BOTAI_PATROL_RING_INSET then
        return nil
    end
    return r - BOTAI_PATROL_RING_INSET
end

--- 去掉毒圈外的 Rebron 点，避免二圈后仍走向一圈时代的巡逻目标（表现为往圈外跑）
local function botai_filter_patrol_positions_for_poison_ring(positions)
    if type(positions) ~= "table" or #positions == 0 then
        return positions
    end
    local cap = botai_patrol_allowed_radius_from_map_center()
    if not cap then
        return positions
    end
    local center = Monster and Monster.Static and Monster.Static.map_center
    if not center then
        return positions
    end
    local out = {}
    for _, pos in ipairs(positions) do
        if pos and (pos - center):Length2D() <= cap then
            out[#out + 1] = pos
        end
    end
    if #out > 0 then
        return out
    end
    local ggp = rawget(_G, "GetGroundPosition")
    local fp = center
    if ggp then
        local g = ggp(center, nil)
        if g then
            fp = g
        end
    end
    return { fp }
end

--- hero_index 未纳入 Boot.BootType 或分型表缺项时合并 tp1/tp2/tp3 技能 ID，避免某个人机定时池永远为空
local function botai_merge_skill_ids_by_tp(tab)
    if type(tab) ~= "table" then
        return
    end
    local seen = {}
    local merged = {}
    for _, tp in ipairs({ "tp1", "tp2", "tp3" }) do
        local sub = tab[tp]
        if type(sub) == "table" then
            for _, sid in ipairs(sub) do
                if not seen[sid] then
                    seen[sid] = true
                    merged[#merged + 1] = sid
                end
            end
        end
    end
    if #merged > 0 then
        return merged
    end
end

-- 对真实玩家优先使用的强控道具（羊刀先于深渊，先远后近；仅当目标无眩晕/沉默/妖术时再交）
local PRIORITY_CC_INVENTORY_ITEMS = {
    "item_sheepstick",
    "item_abyssal_blade",
}

local function safe_unit_bool(unit, method_name)
    if not unit or unit:IsNull() or not method_name then
        return false
    end
    local fn = unit[method_name]
    if type(fn) ~= "function" then
        return false
    end
    local ok, r = pcall(fn, unit)
    return ok and r
end

function BotAI:IsMeleeSkillBookBlocklisted(item_name)
    if not item_name then
        return false
    end
    local bl = self.Config.melee_skill_learn_blocklist
    if not bl then
        return false
    end
    if bl[item_name] then
        return true
    end
    local base = string.match(item_name, "^(item_skill_%d+)_up$")
    if base and bl[base] then
        return true
    end
    return false
end

function BotAI:GetMeleeSkillLearnWhitelist(ID)
    local init_data = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
    local hero_index = init_data and init_data.hero_index
    -- 与选英雄界面一致：SelectHero.BattleType → btp → SelectHero.RMBList（见 ingame/SelectHero/Config.lua）
    local index_for_btp = (hero_index and hero_index > 0) and hero_index or nil
    if SelectHero and SelectHero.GetMeleeLearnWhitelistForHeroIndex then
        local wl = SelectHero:GetMeleeLearnWhitelistForHeroIndex(index_for_btp)
        if wl and next(wl) then
            return wl
        end
    end
    if self.Config.melee_skill_learn_whitelist ~= nil then
        return self.Config.melee_skill_learn_whitelist
    end
    local tp = self:GetBotHeroType(ID)
    if not tp then
        return nil
    end
    return self.Config.melee_skill_learn_whitelist_by_type and self.Config.melee_skill_learn_whitelist_by_type[tp]
end

function BotAI:AbilityNameToMeleeItemName(ability_name)
    if not ability_name or type(ability_name) ~= "string" then
        return nil
    end
    local idx = string.match(ability_name, "^ability_item_(%d+)$")
    if idx then
        return "item_skill_" .. idx
    end
    local idx_up = string.match(ability_name, "^ability_item_(%d+)_up$")
    if idx_up then
        return "item_skill_" .. idx_up .. "_up"
    end
    return nil
end

function BotAI:GetBotHeroType(ID)
    local init_data = InitPlayer:GetPlayerData(ID)
    local hero_index = init_data and init_data.hero_index
    if not hero_index or hero_index == -1 or not Boot or not Boot.BootType then
        return
    end
    local data = self.Data and self.Data[ID]
    local cached = data and data._boot_tp_cache
    if cached and cached.idx == hero_index and cached.tp ~= nil then
        return cached.tp
    end
    for tp_key, hero_list in pairs(Boot.BootType) do
        for _, index in pairs(hero_list) do
            if index == hero_index then
                if data then
                    data._boot_tp_cache = { idx = hero_index, tp = tp_key }
                end
                return tp_key
            end
        end
    end
end

function BotAI:GetBotItemBuyPool(ID)
    local pool = self.Config.item_buy_pool
    if pool and #pool > 0 then
        return pool
    end
    local hero_type = self:GetBotHeroType(ID)
    if not hero_type then
        return
    end
    pool = self.Config.item_buy_pool_by_hero_type and self.Config.item_buy_pool_by_hero_type[hero_type]
    if pool and #pool > 0 then
        return pool
    end
end

--- 人机必买装备表（按数组顺序先买前者；公用 item_buy_required 时不区分 tp）
function BotAI:GetBotMandatoryItemBuyList(ID)
    local list = self.Config.item_buy_required
    if not list or #list == 0 then
        local hero_type = self:GetBotHeroType(ID)
        if hero_type then
            local tab = self.Config.item_buy_required_by_hero_type
            if tab then
                list = tab[hero_type]
            end
        end
    end
    if not list or #list == 0 then
        return
    end
    if self:IsRangedAgilityBotPlayer(ID) then
        local inject = "item_hurricane_pike"
        for _, n in ipairs(list) do
            if n == inject then
                return list
            end
        end
        local merged = { inject }
        for _, n in ipairs(list) do
            merged[#merged + 1] = n
        end
        return merged
    end
    if self:IsMeleeAgilityBotPlayer(ID) then
        local inject = "item_abyssal_blade"
        for _, n in ipairs(list) do
            if n == inject then
                return list
            end
        end
        local merged = { inject }
        for _, n in ipairs(list) do
            merged[#merged + 1] = n
        end
        return merged
    end
    return list
end

function BotAI:HeroHasItem(hero, item_name)
    if not hero or not item_name then
        return false
    end
    for slot = 0, 8 do
        local item = hero:GetItemInSlot(slot)
        if item and not item:IsNull() and item:GetName() == item_name then
            return true
        end
    end
    return false
end

function BotAI:GetBotGold(ID)
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return 0
    end
    return HeroData.Data[ID].gold or 0
end

function BotAI:SpendBotGold(ID, gold)
    if not ID or not gold or gold <= 0 then
        return false
    end
    if not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return false
    end
    local current_gold = HeroData.Data[ID].gold or 0
    if current_gold < gold then
        return false
    end
    HeroData.Data[ID].gold = current_gold - gold
    return true
end

--- 主栏 0-5 均有物品时视为满：不再尝试购装（背包 6-8 是否有空位不影响）。
function BotAI:IsInventoryFull(hero)
    if not hero or hero:IsNull() then
        return false
    end
    for slot = 0, 5 do
        local item = hero:GetItemInSlot(slot)
        if not item or item:IsNull() then
            return false
        end
    end
    return true
end

function BotAI:TryBuyHealthWithGold(ID, hero, data)
    if not ID or not hero or hero:IsNull() then
        return false
    end
    if not self:IsInventoryFull(hero) then
        return false
    end
    local gold_cost = 10000
    if self:GetBotGold(ID) <= gold_cost then
        return false
    end
    if not self:SpendBotGold(ID, gold_cost) then
        return false
    end
    HeroData:AddSX(ID, "smjc", 1000)
    data.last_order = "buy_hp"
    data.last_target_entindex = nil
    return true
end

function BotAI:TryBuyItems(ID, hero, data)
    if not ID or not hero or hero:IsNull() then
        return false
    end
    if self:IsInventoryFull(hero) then
        return false
    end
    local gold = self:GetBotGold(ID)
    local mandatory = self:GetBotMandatoryItemBuyList(ID)
    if mandatory then
        for _, item_name in ipairs(mandatory) do
            if item_name and not self:HeroHasItem(hero, item_name) then
                local cost = GetItemCostFn and GetItemCostFn(item_name)
                if cost and cost > 0 then
                    if gold >= cost and self:SpendBotGold(ID, cost) then
                        Item:AddItem(ID, item_name)
                        data.last_order = "buy_required"
                        data.last_target_entindex = nil
                        return true
                    end
                    -- 必买表未凑齐且当前顺位买不起：不抽随机池，攒钱
                    return false
                end
                -- 无效物价或未知物品：跳过该项，避免卡死
            end
        end
    end

    local pool = self:GetBotItemBuyPool(ID)
    if not pool or #pool == 0 then
        return false
    end
    local min_gold = self.Config.item_buy_min_gold or 6000
    if gold < min_gold then
        return false
    end
    local candidates = {}
    for _, item_name in ipairs(pool) do
        if item_name and not self:HeroHasItem(hero, item_name) then
            local cost = GetItemCostFn and GetItemCostFn(item_name)
            if cost and cost > 0 and gold >= cost then
                table.insert(candidates, item_name)
            end
        end
    end
    if #candidates == 0 then
        return false
    end
    local pick = candidates[RandomInt(1, #candidates)]
    local cost = GetItemCostFn and GetItemCostFn(pick)
    if not cost or cost <= 0 or not self:SpendBotGold(ID, cost) then
        return false
    end
    Item:AddItem(ID, pick)
    data.last_order = "buy"
    data.last_target_entindex = nil
    return true
end

function BotAI:GetPatrolPoints(hero)
    if not hero or hero:IsNull() then
        return {}
    end
    botai_refresh_patrol_positions()
    local all = botai_patrol_cache.positions
    if not all or #all == 0 then
        return {}
    end
    local pool = botai_filter_patrol_positions_for_poison_ring(all)
    local origin = hero:GetAbsOrigin()
    local vision_radius = self:GetBotThinkUnitSearchRadius(hero)
    local patrol_radius = math.min(BOTAI_PATROL_RADIUS_CAP,
        math.max(vision_radius * BOTAI_PATROL_RADIUS_MULT, BOTAI_PATROL_RADIUS_MIN))
    local cap = botai_patrol_allowed_radius_from_map_center()
    if cap and patrol_radius > cap * 2 + 400 then
        patrol_radius = cap * 2 + 400
    end
    local points = {}
    local used_far_fallback = false
    for _, pos in ipairs(pool) do
        local distance = (pos - origin):Length2D()
        if distance <= patrol_radius then
            points[#points + 1] = {
                index = distance,
                pos = pos,
            }
        end
    end
    -- 视野内无点时列表可能为空；改为走向若干最近的巡逻点（含 random_point / 中立 spawner 营地）
    if #points == 0 then
        used_far_fallback = true
        for _, pos in ipairs(pool) do
            local distance = (pos - origin):Length2D()
            points[#points + 1] = {
                index = distance,
                pos = pos,
            }
        end
    end
    table.sort(points, function(a, b)
        return a.index < b.index
    end)
    if used_far_fallback and #points > 6 then
        local t = {}
        for i = 1, 6 do
            t[i] = points[i]
        end
        points = t
    end
    return points
end

function BotAI:Attach(ID, hero)
    if not ID or not hero or hero:IsNull() then
        return
    end
    local init_data = InitPlayer:GetPlayerData(ID)
    if not init_data or not init_data.bot then
        return
    end

    local cap = tonumber(self.Config.bot_hero_level_cap) or 45
    if HeroData and HeroData.Data and HeroData.Data[ID] and HeroData.Data[ID].hero_attr then
        HeroData.Data[ID].hero_attr.djsx = cap
    end

    local data = self.Data[ID] or {}
    data.id = ID
    data.token = (data.token or 0) + 1
    data.patrol_index = data.patrol_index or 1
    data.last_target_entindex = nil
    data.last_order = nil
    data._boot_tp_cache = nil
    data._melee_auto_learn_stopped = false
    data.last_level = hero.GetLevel and hero:GetLevel() or data.last_level or 1
    data.bm_evade_until = nil
    data.bm_evade_foe = nil
    data.agi_ranged_hurricane_hold_until = nil
    data.agi_ranged_hurricane_hold_target_entindex = nil
    data._next_basic_scan_after = nil
    data._melee_auto_learn_next = botai_game_time() + BOTAI_AUTO_MELEE_LEARN_INTERVAL
    self.Data[ID] = data

    self:EnsureBotInnateManaRegenModifier(hero)
    self:EnsureBotInnateLevelBaseAttackModifier(hero)

    local token = data.token
    -- 错开首次 Think，避免多台人机在同一帧叠执行 FindUnits
    local iv = self.Config.think_interval
    local stagger = 0
    if type(ID) == "number" then
        stagger = (ID % 28) * (iv / 11)
    end
    Timers(iv + stagger, function()
        return self:Think(ID, token)
    end)
end

function BotAI:GetHero(ID)
    if not ID then
        return
    end
    return Util:ID2Hero(ID)
end

function BotAI:IsHeroValid(hero)
    return hero and not hero:IsNull() and hero:IsAlive()
end

function BotAI:HandleLevelGrowth(hero, data)
    if not hero or hero:IsNull() or not data or not hero.GetLevel then
        return false
    end
    local current_level = hero:GetLevel() or 1
    local last_level = data.last_level or current_level
    if current_level <= last_level then
        data.last_level = current_level
        return false
    end
    local level_diff = current_level - last_level
    local cfg = self.Config or {}
    local per_attr = tonumber(cfg.level_growth_all_attributes) or 10
    local add_attr = per_attr * level_diff
    hero:ModifyStrength(add_attr)
    hero:ModifyAgility(add_attr)
    hero:ModifyIntellect(add_attr)

    -- AI 升级：每级 +2 基础攻击力
    -- local add_dmg = 1 * level_diff
    -- if hero.GetBaseDamageMin and hero.SetBaseDamageMin and hero.GetBaseDamageMax and hero.SetBaseDamageMax then
    --     hero:SetBaseDamageMin((hero:GetBaseDamageMin() or 0) + add_dmg)
    --     hero:SetBaseDamageMax((hero:GetBaseDamageMax() or 0) + add_dmg)
    -- end

    local per_ms = tonumber(cfg.level_growth_bonus_movespeed) or 5
    local add_ms = per_ms * level_diff
    if hero.GetBaseMoveSpeed and hero.SetBaseMoveSpeed then
        hero:SetBaseMoveSpeed((hero:GetBaseMoveSpeed() or 0) + add_ms)
    end

    local per_hp = tonumber(cfg.level_growth_bonus_hp) or 400
    local add_hp = per_hp * level_diff

    -- 尽量保持当前血量百分比不突变
    local old_max = hero.GetMaxHealth and hero:GetMaxHealth() or 0
    local old_hp = hero.GetHealth and hero:GetHealth() or 0
    local hp_pct = 1
    if old_max and old_max > 0 then
        hp_pct = old_hp / old_max
    end

    if hero.GetBaseMaxHealth and hero.SetBaseMaxHealth then
        local base_max = hero:GetBaseMaxHealth() or 0
        hero:SetBaseMaxHealth(base_max + add_hp)
        if hero.SetMaxHealth and hero.GetMaxHealth then
            hero:SetMaxHealth(hero:GetMaxHealth())
        end
        if hero.SetHealth and hero.GetMaxHealth then
            local new_max = hero:GetMaxHealth() or old_max
            local new_hp = math.floor((new_max or 0) * hp_pct + 0.5)
            if new_hp < 1 then new_hp = 1 end
            if new_max and new_max > 0 and new_hp > new_max then new_hp = new_max end
            hero:SetHealth(new_hp)
        end
    end

    local ap_per_level = tonumber(cfg.level_growth_ability_points) or 5
    if ap_per_level > 0 and hero.GetAbilityPoints and hero.SetAbilityPoints then
        hero:SetAbilityPoints((hero:GetAbilityPoints() or 0) + ap_per_level * level_diff)
    end

    data.last_level = current_level
    return true
end

--- 人机死亡时按配置增加三维（与 level_growth 独立，见 Config death_growth_all_attributes）
function BotAI:HandleDeathAllAttributes(hero)
    if not hero or hero:IsNull() then
        return
    end
    local cfg = self.Config or {}
    local n = tonumber(cfg.death_growth_all_attributes) or 0
    if n <= 0 then
        return
    end
    local ID = Util and Util.Hero2ID and Util:Hero2ID(hero)
    if HeroData and HeroData.QueueRbzfDeathBonusAllStatsGreen and ID then
        HeroData:QueueRbzfDeathBonusAllStatsGreen(ID, n)
    elseif HeroData and HeroData.AddRbzfDeathBonusAllStatsGreen then
        HeroData:AddRbzfDeathBonusAllStatsGreen(hero, n)
    else
        hero:ModifyStrength(n)
        hero:ModifyAgility(n)
        hero:ModifyIntellect(n)
    end
end

--- 毒圈收缩后：力量主属性人机按比例将敏捷→力量；敏捷/全才主属性人机将智力的一定比例取下整后转至力量；智力主属性不处理
function BotAI:ApplyIntelRedistributeAfterPoisonRing()
    if not PD or not PD.IDs or not Util or not Util.IsPseudoPlayerID then
        return
    end
    local ratio_off = 0.75
    if self.Config and type(self.Config.poison_ring_offattr_to_primary_transfer_ratio) == "number" then
        ratio_off = self.Config.poison_ring_offattr_to_primary_transfer_ratio
    end
    local ratio_all = 0.8
    if self.Config and type(self.Config.poison_ring_all_hero_intel_to_str_agi_ratio) == "number" then
        ratio_all = self.Config.poison_ring_all_hero_intel_to_str_agi_ratio
    end
    local ATTR_ALL = rawget(_G, "DOTA_ATTRIBUTE_ALL") or 3
    for _, ID in pairs(PD.IDs) do
        if ID and Util:IsPseudoPlayerID(ID) then
            local hero = Util:ID2Hero(ID)
            if hero and not hero:IsNull() and hero.GetPrimaryAttribute then
                local pa = hero:GetPrimaryAttribute()
                if pa == DOTA_ATTRIBUTE_STRENGTH and ratio_off > 0 and hero.GetAgility then
                    local src = hero:GetAgility() or 0
                    local i_src = math.floor(src + 1e-6)
                    local removed = math.floor(i_src * ratio_off + 1e-6)
                    if removed > 0 then
                        hero:ModifyAgility(-removed)
                        hero:ModifyStrength(removed)
                    end
                elseif pa == DOTA_ATTRIBUTE_AGILITY and ratio_all > 0 and hero.GetIntellect then
                    local src = hero:GetIntellect(false) or 0
                    local i_src = math.floor(src + 1e-6)
                    local removed = math.floor(i_src * ratio_all + 1e-6)
                    if removed > 0 then
                        hero:ModifyIntellect(-removed)
                        hero:ModifyStrength(removed)
                    end
                elseif pa == ATTR_ALL and ratio_all > 0 and hero.GetIntellect then
                    local src = hero:GetIntellect(false) or 0
                    local i_src = math.floor(src + 1e-6)
                    local removed = math.floor(i_src * ratio_all + 1e-6)
                    if removed > 0 then
                        hero:ModifyIntellect(-removed)
                        hero:ModifyStrength(removed)
                    end
                end
            end
        end
    end
end

--- 毒圈收缩后：人机获得神杖与魔晶效果（原生 modifier，不占物品栏）
function BotAI:EnsureBotAghanimsBuffs(hero)
    if not hero or hero:IsNull() or not hero.AddNewModifier then
        return
    end
    if not hero:HasModifier("modifier_item_ultimate_scepter") then
        hero:AddNewModifier(hero, nil, "modifier_item_ultimate_scepter", { duration = -1 })
    end
    if not hero:HasModifier("modifier_item_aghanims_shard") then
        hero:AddNewModifier(hero, nil, "modifier_item_aghanims_shard", { duration = -1 })
    end
end

function BotAI:EnsureBotInnateManaRegenModifier(hero)
    if not hero or hero:IsNull() or not hero.AddNewModifier then
        return
    end
    if not hero:HasModifier("modifier_bot_innate_mana_regen") then
        hero:AddNewModifier(hero, nil, "modifier_bot_innate_mana_regen", { duration = -1 })
    end
end

function BotAI:EnsureBotInnateLevelBaseAttackModifier(hero)
    if not hero or hero:IsNull() or not hero.AddNewModifier then
        return
    end
    if not hero:HasModifier("modifier_bot_innate_level_base_attack") then
        hero:AddNewModifier(hero, nil, "modifier_bot_innate_level_base_attack", { duration = -1 })
    end
end

--- 结算界面已开启：停止所有人机 Think / 延迟下单，并移除伪玩家英雄实体；Stat / OverData 战绩已在 LoadData 中固化，不清理。
function BotAI:CleanupForSettlementUI()
    if not IsServer() or self._settlement_cleanup_done then
        return
    end
    self._settlement_cleanup_done = true
    self._settlement_stopped = true
    if not PD or not PD.IDs or not Util then
        return
    end
    for _, ID in pairs(PD.IDs) do
        if ID and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
            local hero = Util:ID2Hero(ID)
            if hero and not hero:IsNull() then
                if UTIL_RemoveFn then
                    UTIL_RemoveFn(hero)
                elseif hero.RemoveSelf then
                    hero:RemoveSelf()
                end
            end
            if PD[ID] then
                PD[ID].pseudo_hero = nil
            end
        end
    end
end

function BotAI:ApplyPostRingAghanimsToAllBots()
    if not PD or not PD.IDs or not Util or not Util.IsPseudoPlayerID then
        return
    end
    for _, ID in pairs(PD.IDs) do
        if ID and Util:IsPseudoPlayerID(ID) then
            local hero = Util:ID2Hero(ID)
            if hero and not hero:IsNull() then
                -- self:EnsureBotAghanimsBuffs(hero)
                -- self:EnsureBotInnateManaRegenModifier(hero)
                -- self:EnsureBotInnateLevelBaseAttackModifier(hero)
            end
        end
    end
end

--- 首次毒圈收缩后：人机立即获得配置的三维 / 攻击 / 生命（在 ApplyIntelRedistributeAfterPoisonRing 之后调用，见 MainGame.MapChange1）
function BotAI:ApplyPostRingInstantStatBuffsToAllBots()
    if not PD or not PD.IDs or not Util or not Util.IsPseudoPlayerID then
        return
    end
    if not HeroData or not HeroData.AddSX or not HeroData.Data then
        return
    end
    local cfg = self.Config or {}
    local n_attr = tonumber(cfg.bot_post_ring_bonus_all_attributes) or 100
    local n_atk = tonumber(cfg.bot_post_ring_bonus_attack) or 1000
    local n_hp = tonumber(cfg.bot_post_ring_bonus_health) or 3000
    if n_attr <= 0 and n_atk <= 0 and n_hp <= 0 then
        return
    end
    for _, ID in pairs(PD.IDs) do
        if ID and Util:IsPseudoPlayerID(ID) then
            local hero = Util:ID2Hero(ID)
            if hero and not hero:IsNull() and HeroData.Data[ID] then
                if n_attr > 0 then
                    HeroData:AddSX(ID, "jcll", n_attr)
                    HeroData:AddSX(ID, "jcmj", n_attr)
                    HeroData:AddSX(ID, "jczl", n_attr)
                end
                if n_atk > 0 then
                    HeroData:AddSX(ID, "jcgj", n_atk)
                end
                if n_hp > 0 then
                    HeroData:AddSX(ID, "smjc", n_hp)
                end
            end
        end
    end
end

function BotAI:IsVisibleTarget(hero, target)
    if not hero or not target then
        return false
    end
    if target:IsNull() or not target:IsAlive() then
        return false
    end
    if target == hero then
        return false
    end
    if hero.CanEntityBeSeenByMyTeam and not hero:CanEntityBeSeenByMyTeam(target) then
        return false
    end
    return true
end

--- 索敌与巡逻：以单位当前视野为主，并保证不小于攻击距离略有余量。
function BotAI:GetBotThinkUnitSearchRadius(hero)
    if not hero or hero:IsNull() then
        return 1200
    end
    local vr = hero.GetCurrentVisionRange and hero:GetCurrentVisionRange()
    if type(vr) ~= "number" or vr <= 200 then
        local gr = GameRulesRef
        local day = gr and gr.IsDaytime and gr:IsDaytime()
        if day and hero.GetDayTimeVisionRange then
            vr = hero:GetDayTimeVisionRange()
        elseif hero.GetNightTimeVisionRange then
            vr = hero:GetNightTimeVisionRange()
        end
    end
    if type(vr) ~= "number" or vr <= 200 then
        vr = 1800
    end
    local atk = hero.Script_GetAttackRange and hero:Script_GetAttackRange() or 150
    return math.min(math.max(vr, atk + 50), BOTAI_COMBAT_RADIUS_CAP)
end

function BotAI:GetHealthPct(unit)
    if not unit or unit:IsNull() then
        return 0
    end
    local max_health = unit:GetMaxHealth() or 0
    if max_health <= 0 then
        return 0
    end
    return (unit:GetHealth() or 0) / max_health
end

function BotAI:IsMeleeBook(item_name)
    if not item_name or not Item or not Item.Rb then
        return false
    end
    for _, name in pairs(Item.Rb) do
        if name == item_name then
            return true
        end
    end
    return false
end

function BotAI:IsDotaSkillBook(item_name)
    return item_name == "item_goods_14" or item_name == "item_goods_15" or item_name == "item_goods_16"
end

function BotAI:GetDotaSkillBookType(item_name)
    if item_name == "item_goods_14" then
        return "T2"
    end
    if item_name == "item_goods_15" then
        return "T1"
    end
    if item_name == "item_goods_16" then
        return "T0"
    end
end

function BotAI:GetDotaSkillRarityByName(skill_name)
    if not skill_name or not Skill or not Skill.GetSkillID or not Skill.GetSkillData then
        return
    end
    local skill_id = Skill:GetSkillID(skill_name)
    if not skill_id then
        return
    end
    local skill_data = Skill:GetSkillData(skill_id)
    return skill_data and skill_data.rank
end

function BotAI:GetPreferredDotaSkillSlot(ID, data, new_skill_id)
    if not ID or not Skill or not Skill.Data or not Skill.Data[ID] then
        return
    end
    for i = 1, 4 do
        local slot = Skill.Data[ID].Skill1 and Skill.Data[ID].Skill1["slot_" .. i]
        if slot and Skill.IsNullSkill and Skill:IsNullSkill(slot.name) then
            return i
        end
    end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    local new_skill_data = new_skill_id and Skill.GetSkillData and Skill:GetSkillData(new_skill_id)
    local new_skill_rank = new_skill_data and new_skill_data.rank
    if not new_skill_rank then
        return
    end
    local replace_slot = nil
    local lowest_rank = nil
    for i = 1, 4 do
        local slot = Skill.Data[ID].Skill1 and Skill.Data[ID].Skill1["slot_" .. i]
        if not slot or not slot.name or (Skill.IsNullSkill and Skill:IsNullSkill(slot.name)) then
            return
        end
        local ab = hero:FindAbilityByName(slot.name)
        if not ab or ab:IsNull() then
            return
        end
        local level = ab:GetLevel() or 0
        local max_level = ab.GetMaxLevel and ab:GetMaxLevel() or 0
        if max_level <= 0 or level < max_level then
            return
        end
        local old_rank = self:GetDotaSkillRarityByName(slot.name)
        if not old_rank then
            return
        end
        if lowest_rank == nil or old_rank < lowest_rank then
            lowest_rank = old_rank
            replace_slot = i
        end
    end
    if not replace_slot or not lowest_rank or new_skill_rank <= lowest_rank then
        return
    end
    return replace_slot
end

--- Skill1 四槽已学 Dota 技能数量（非 ability_null）
function BotAI:CountLearnedDotaSkill1Slots(ID)
    if not ID or not Skill or not Skill.Data or not Skill.Data[ID] or not Skill.IsNullSkill then
        return 0
    end
    local n = 0
    for i = 1, 4 do
        local slot = Skill.Data[ID].Skill1 and Skill.Data[ID].Skill1["slot_" .. i]
        if slot and slot.name and not Skill:IsNullSkill(slot.name) then
            n = n + 1
        end
    end
    return n
end

--- 第一个空 Skill1 槽（ability_null），无则 nil
function BotAI:GetFirstEmptyDotaSkill1Slot(ID)
    if not ID or not Skill or not Skill.Data or not Skill.Data[ID] or not Skill.IsNullSkill then
        return
    end
    for i = 1, 4 do
        local slot = Skill.Data[ID].Skill1 and Skill.Data[ID].Skill1["slot_" .. i]
        if slot and (not slot.name or Skill:IsNullSkill(slot.name)) then
            return i
        end
    end
end

function BotAI:TryGrantBotPeriodicAbilityPoint(hero)
    if not hero or hero:IsNull() then
        return
    end
    if hero.GetAbilityPoints and hero.SetAbilityPoints then
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
    end
end

function BotAI:CanUseDotaSkillBook(ID, item_name, data)
    if not ID or not item_name or not self:IsDotaSkillBook(item_name) then
        return false
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return false
    end
    local book_type = self:GetDotaSkillBookType(item_name)
    if not book_type then
        return false
    end
    -- 究极技能书：对局满 15 分钟后才能使用（与 Skill:UseBook / 枪术时间接口一致）
    if book_type == "T0" then
        local game_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
        if game_min < 15 then
            return false
        end
    end
    local skill_id = self:RollDotaSkillIdByBook(ID, book_type)
    if not skill_id then
        return false
    end
    local skill_slot = self:GetPreferredDotaSkillSlot(ID, data, skill_id)
    return skill_slot ~= nil
end

function BotAI:RollDotaSkillIdByBookFromConfig(ID)
    if not ID or not Skill or not Skill.GetSkillData then
        return
    end
    -- 与定时授予一致：dota_skill_pool_by_hero_type（GetDotaTimedSkillPoolList）
    local list = self:GetDotaTimedSkillPoolList(ID)
    if not list or #list == 0 then
        local pool = self.Config and self.Config.dota_skill_book_pool
        if type(pool) == "table" and #pool > 0 then
            list = pool
        else
            local hero_tp = self:GetBotHeroType(ID)
            if hero_tp and pool then
                list = pool[hero_tp]
            end
        end
    end
    if not list or #list == 0 then
        return
    end
    local try_num = 0
    while try_num < 100 do
        try_num = try_num + 1
        local pick = list[RandomInt(1, #list)]
        local skill_data = Skill:GetSkillData(pick)
        if skill_data
            and Skill.IsInList and not Skill:IsInList(ID, pick)
            and Skill.IsHaveAb and not Skill:IsHaveAb(ID, pick)
            and Skill.IsInPublic and not Skill:IsInPublic(pick) then
            return pick
        end
    end
end

--- 首次毒圈收缩后 MainGame.Data.state>=2，否则用缩圈前池
function BotAI:IsMainGamePoisonRingShrunk()
    if MainGame and MainGame.Data and type(MainGame.Data.state) == "number" and MainGame.Data.state >= 2 then
        return true
    end
    return false
end

function BotAI:IsStrengthTypeBotPlayer(ID)
    if not ID or not InitPlayer or not InitPlayer.GetPlayerData then
        return false
    end
    local d = InitPlayer:GetPlayerData(ID)
    if not d or not d.bot then
        return false
    end
    if self:GetBotHeroType(ID) == "tp1" then
        return true
    end
    local hero = Util and Util.ID2Hero and Util:ID2Hero(ID)
    if hero and not hero:IsNull() and hero.GetPrimaryAttribute then
        return hero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH
    end
    return false
end

function BotAI:IsIntelligenceTypeBotPlayer(ID)
    if not ID or not InitPlayer or not InitPlayer.GetPlayerData then
        return false
    end
    local d = InitPlayer:GetPlayerData(ID)
    if not d or not d.bot then
        return false
    end
    if self:GetBotHeroType(ID) == "tp3" then
        return true
    end
    local hero = Util and Util.ID2Hero and Util:ID2Hero(ID)
    if hero and not hero:IsNull() and hero.GetPrimaryAttribute then
        return hero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT
    end
    return false
end

--- 远程 + 敏捷类型人机（tp2 或主属性敏捷；人机且 IsRangedAttacker）
function BotAI:IsRangedAgilityBotPlayer(ID)
    if not ID or not InitPlayer or not InitPlayer.GetPlayerData then
        return false
    end
    local d = InitPlayer:GetPlayerData(ID)
    if not d or not d.bot then
        return false
    end
    local hero = Util and Util.ID2Hero and Util:ID2Hero(ID)
    if not hero or hero:IsNull() or not hero.IsRangedAttacker or not hero.GetPrimaryAttribute then
        return false
    end
    if not hero:IsRangedAttacker() then
        return false
    end
    if self:GetBotHeroType(ID) == "tp2" then
        return true
    end
    return hero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY
end

--- 近战 + 敏捷类型人机（tp2 或主属性敏捷；人机且非 IsRangedAttacker）
function BotAI:IsMeleeAgilityBotPlayer(ID)
    if not ID or not InitPlayer or not InitPlayer.GetPlayerData then
        return false
    end
    local d = InitPlayer:GetPlayerData(ID)
    if not d or not d.bot then
        return false
    end
    local hero = Util and Util.ID2Hero and Util:ID2Hero(ID)
    if not hero or hero:IsNull() or not hero.IsRangedAttacker or not hero.GetPrimaryAttribute then
        return false
    end
    if hero:IsRangedAttacker() then
        return false
    end
    if self:GetBotHeroType(ID) == "tp2" then
        return true
    end
    return hero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY
end

--- 近战敏捷人机：对指定敌方英雄在射程内立刻使用深渊之刃（不交低血随机链；先于羊刀/深渊的通用 CC 逻辑）
function BotAI:TryMeleeAgilityAbyssalBladeOnHero(hero, ID, data, t)
    if not hero or hero:IsNull() or not ID or not data or not ExecuteOrderFromTableFn then
        return false
    end
    if not self:IsMeleeAgilityBotPlayer(ID) then
        return false
    end
    if not t or t:IsNull() or not t:IsAlive() or not t:IsHero() then
        return false
    end
    if t:GetTeamNumber() == hero:GetTeamNumber() then
        return false
    end
    if not self:IsVisibleTarget(hero, t) then
        return false
    end
    if self:TargetHasActiveBladeMailReflect(t) and not self:ShouldSkipBladeMailEvade(hero, t) then
        return false
    end
    if t.IsMagicImmune and t:IsMagicImmune() then
        return false
    end
    if self:TargetHasStunSilenceOrHex(t) then
        return false
    end
    local it = self:FindHeroInventoryItemByName(hero, "item_abyssal_blade")
    if not it or not self:IsBotSelfUsableActiveItem(it) or not self:IsAbilityBehavior(it, BEHAVIOR_UNIT_TARGET) then
        return false
    end
    local target_pos = t:GetAbsOrigin()
    local hero_pos = hero:GetAbsOrigin()
    local cast_range = it.GetCastRange and it:GetCastRange(target_pos, t) or 0
    local distance = (hero_pos - target_pos):Length2D()
    if cast_range > 0 and distance > cast_range + 100 then
        return false
    end
    ExecuteOrderFromTableFn({
        UnitIndex = hero:entindex(),
        OrderType = ORDER_CAST_TARGET,
        TargetIndex = t:entindex(),
        AbilityIndex = it:entindex(),
    })
    data.pending_cast = nil
    data.last_order = "melee_agi_abyssal"
    data.last_target_entindex = t:entindex()
    return true
end

--- 远程敏捷人机：生命低于阈值、与敌方英雄交战且当前攻击目标为敌方英雄时，对其施放飓风长戟；用后进入短时间「只普攻该目标」状态（见 TryAgilityRangedHurricanePikeHoldAttack）
function BotAI:TryAgilityRangedHurricanePikeOnAttackTarget(hero, ID, data)
    if not hero or hero:IsNull() or not ID or not data or not ExecuteOrderFromTableFn then
        return false
    end
    if not self:IsRangedAgilityBotPlayer(ID) then
        return false
    end
    local thr = (self.Config and tonumber(self.Config.agi_ranged_hurricane_pike_hp_threshold)) or 0.5
    if self:GetHealthPct(hero) >= thr then
        return false
    end
    if not self:IsFightingEnemyHero(hero) then
        return false
    end
    local atk = hero.GetAttackTarget and hero:GetAttackTarget() or nil
    if not atk or atk:IsNull() or not atk:IsAlive() or not atk:IsHero() then
        return false
    end
    if atk:GetTeamNumber() == hero:GetTeamNumber() then
        return false
    end
    if not self:IsVisibleTarget(hero, atk) then
        return false
    end
    if self:TargetHasActiveBladeMailReflect(atk) and not self:ShouldSkipBladeMailEvade(hero, atk) then
        return false
    end
    local it = self:FindHeroInventoryItemByName(hero, "item_hurricane_pike")
    if not it or not self:IsBotSelfUsableActiveItem(it) or not self:IsAbilityBehavior(it, BEHAVIOR_UNIT_TARGET) then
        return false
    end
    local target_pos = atk:GetAbsOrigin()
    local hero_pos = hero:GetAbsOrigin()
    local cast_range = it.GetCastRange and it:GetCastRange(target_pos, atk) or 0
    local distance = (hero_pos - target_pos):Length2D()
    if cast_range > 0 and distance > cast_range + 100 then
        return false
    end
    ExecuteOrderFromTableFn({
        UnitIndex = hero:entindex(),
        OrderType = ORDER_CAST_TARGET,
        TargetIndex = atk:entindex(),
        AbilityIndex = it:entindex(),
    })
    data.pending_cast = nil
    local stand = (self.Config and tonumber(self.Config.agi_ranged_hurricane_pike_stand_seconds)) or 1.5
    data.agi_ranged_hurricane_hold_until = botai_game_time() + stand
    data.agi_ranged_hurricane_hold_target_entindex = atk:entindex()
    data.last_order = "hurricane_pike"
    return true
end

--- 飓风长戟用后：在配置时长内仅对锁定目标发普攻，不撤退/协助/巡逻
function BotAI:TryAgilityRangedHurricanePikeHoldAttack(hero, data)
    if not hero or hero:IsNull() or not data or not data.agi_ranged_hurricane_hold_until then
        return false
    end
    local now = botai_game_time()
    if now >= data.agi_ranged_hurricane_hold_until then
        data.agi_ranged_hurricane_hold_until = nil
        data.agi_ranged_hurricane_hold_target_entindex = nil
        return false
    end
    local te = data.agi_ranged_hurricane_hold_target_entindex
    local t = te and EntIndexToHScript(te)
    if t and not t:IsNull() and t:IsAlive() and t:GetTeamNumber() ~= hero:GetTeamNumber() and self:IsVisibleTarget(hero, t) then
        self:IssueAttack(hero, t, data)
    end
    return true
end

--- 智力人机：遇敌方英雄时若有邪恶镰刀且可施放，立即对其变羊（不限定真人玩家；与优先级 CC 中羊刀规则一致，但不交深渊）
-- function BotAI:TryIntBotSheepstickOnEnemyHero(hero, ID, data, target)
--     if not hero or hero:IsNull() or not ID or not data or not target or target:IsNull() or not ExecuteOrderFromTableFn then
--         return false
--     end
--     if not self:IsIntelligenceTypeBotPlayer(ID) then
--         return false
--     end
--     if not target:IsAlive() or not target:IsHero() then
--         return false
--     end
--     if target:GetTeamNumber() == hero:GetTeamNumber() then
--         return false
--     end
--     if not self:IsVisibleTarget(hero, target) then
--         return false
--     end
--     if self:TargetHasStunSilenceOrHex(target) then
--         return false
--     end
--     if self:TargetHasActiveBladeMailReflect(target) and not self:ShouldSkipBladeMailEvade(hero, target) then
--         return false
--     end
--     if target.IsMagicImmune and target:IsMagicImmune() then
--         return false
--     end
--     local it = self:FindHeroInventoryItemByName(hero, "item_sheepstick")
--     if not it or not self:IsBotSelfUsableActiveItem(it) or not self:IsAbilityBehavior(it, BEHAVIOR_UNIT_TARGET) then
--         return false
--     end
--     local target_pos = target:GetAbsOrigin()
--     local hero_pos = hero:GetAbsOrigin()
--     local cast_range = it.GetCastRange and it:GetCastRange(target_pos, target) or 0
--     local distance = (hero_pos - target_pos):Length2D()
--     if cast_range > 0 and distance > cast_range + 100 then
--         return false
--     end
--     ExecuteOrderFromTableFn({
--         UnitIndex = hero:entindex(),
--         OrderType = ORDER_CAST_TARGET,
--         TargetIndex = target:entindex(),
--         AbilityIndex = it:entindex(),
--     })
--     data.pending_cast = nil
--     data.last_order = "int_sheepstick"
--     data.last_target_entindex = target:entindex()
--     return true
-- end

--- 智力人机：低血量时先刷新球再血精石再排技能；刷新与血精间隔一帧以便刷新重置冷却后再用血精/技能
-- function BotAI:TryIntBotLowHpRefresherBloodstoneThenAbilities(hero, ID, data)
--     if not hero or hero:IsNull() or not ID or not data or not ExecuteOrderFromTableFn then
--         return false
--     end
--     if not self:IsIntelligenceTypeBotPlayer(ID) then
--         return false
--     end
--     local thr = (self.Config and tonumber(self.Config.int_bot_refresher_combo_hp_threshold)) or 0.5
--     if self:GetHealthPct(hero) >= thr then
--         return false
--     end
--     if not self:IsFightingEnemyHero(hero) then
--         return false
--     end
--     local cast_target = self:GetBotHostileAttackOrAggroTarget(hero)
--     if not cast_target or cast_target:IsNull() or not cast_target:IsAlive() or not cast_target:IsHero() then
--         return false
--     end
--     if cast_target:GetTeamNumber() == hero:GetTeamNumber() then
--         return false
--     end
--     if not self:IsVisibleTarget(hero, cast_target) then
--         return false
--     end
--     if self:TargetHasActiveBladeMailReflect(cast_target) and not self:ShouldSkipBladeMailEvade(hero, cast_target) then
--         return false
--     end

--     local ref = self:FindHeroInventoryItemByName(hero, "item_refresher")
--     local he = hero:entindex()
--     local te = cast_target:entindex()

--     if ref and self:IsBotSelfUsableActiveItem(ref) and self:TryCastInventoryItemOnSelf(hero, ref) then
--         if data then
--             data.pending_cast = nil
--             data.last_order = "int_refresher_combo"
--         end
--         Timers(0.06, function()
--             if BotAI and BotAI._settlement_stopped then
--                 return
--             end
--             local h = EntIndexToHScript(he)
--             local t = EntIndexToHScript(te)
--             if not h or h:IsNull() or not h:IsAlive() or not t or t:IsNull() or not t:IsAlive() then
--                 return
--             end
--             if not BotAI:IsIntelligenceTypeBotPlayer(ID) then
--                 return
--             end
--             local b = BotAI:FindHeroInventoryItemByName(h, "item_bloodstone")
--             if b and BotAI:IsBotSelfUsableActiveItem(b) then
--                 BotAI:TryCastInventoryItemOnSelf(h, b)
--             end
--             BotAI:TryCastActiveAbility(h, t, data)
--         end)
--         return true
--     end

--     local used = false
--     local blood = self:FindHeroInventoryItemByName(hero, "item_bloodstone")
--     if blood and self:IsBotSelfUsableActiveItem(blood) and self:TryCastInventoryItemOnSelf(hero, blood) then
--         used = true
--     end
--     if self:TryCastActiveAbility(hero, cast_target, data) then
--         used = true
--     end
--     return used
-- end

function BotAI:StrBotHeroHasMandatoryTauntDotaSkill(hero)
    if not hero or hero:IsNull() then
        return false
    end
    for ab_name, _ in pairs(STR_BOT_TAUNT_ABILITY_NAMES) do
        if hero:HasAbility(ab_name) then
            return true
        end
    end
    return false
end

--- 缩圈后：每名力量类型人机若未拥有「狂战士之吼 / 决斗 / 牺牲」之一，则随机授予其一（仅空 Skill1 槽，不替换已有刀塔技能）
-- function BotAI:EnsureStrBotMandatoryTauntSkillAfterRing()
--     if not self:IsMainGamePoisonRingShrunk() or not PD or not PD.IDs or not Util or not Util.IsPseudoPlayerID then
--         return
--     end
--     if not Skill or not Skill.GetSkillData then
--         return
--     end
--     for _, ID in pairs(PD.IDs) do
--         if ID and Util:IsPseudoPlayerID(ID) and self:IsStrengthTypeBotPlayer(ID) then
--             local hero = Util:ID2Hero(ID)
--             if hero and not hero:IsNull() and not self:StrBotHeroHasMandatoryTauntDotaSkill(hero) then
--                 local pick = STR_BOT_TAUNT_SKILL_IDS[RandomInt(1, #STR_BOT_TAUNT_SKILL_IDS)]
--                 local skill_data = Skill:GetSkillData(pick)
--                 if skill_data and skill_data.name and not hero:HasAbility(skill_data.name) then
--                     local empty = self:GetFirstEmptyDotaSkill1Slot(ID)
--                     if empty and self:LearnDotaSkillDirectly(ID, hero, pick, empty) then
--                         self:TryAutoUpgradeSkills(ID, hero)
--                     end
--                 end
--             end
--         end
--     end
-- end

--- 受敌方英雄伤害时由 Damage_Filter 调用：在窗口内允许人机使用刃甲主动
function BotAI:NotifyBotDamagedFromEnemy(victim_player_id)
    if not victim_player_id or not InitPlayer or not InitPlayer.GetPlayerData then
        return
    end
    local pd = InitPlayer:GetPlayerData(victim_player_id)
    if not pd or not pd.bot then
        return
    end
    self.Data[victim_player_id] = self.Data[victim_player_id] or {}
    local data = self.Data[victim_player_id]
    local w = (self.Config and tonumber(self.Config.bot_blade_mail_after_damage_window)) or 6
    data.bot_blade_mail_ok_until = botai_game_time() + w
end

--- 人机刃甲：仅在近期受过敌方英雄伤害时返回 true（非人机始终 true）
function BotAI:CanBotUseBladeMailAfterRecentDamage(victim_player_id)
    if not victim_player_id or not InitPlayer or not InitPlayer.GetPlayerData then
        return true
    end
    local pd = InitPlayer:GetPlayerData(victim_player_id)
    if not pd or not pd.bot then
        return true
    end
    local data = self.Data[victim_player_id]
    if not data or not data.bot_blade_mail_ok_until then
        return false
    end
    local now = botai_game_time()
    if now > data.bot_blade_mail_ok_until then
        data.bot_blade_mail_ok_until = nil
        return false
    end
    return true
end

--- 力量人机在施放狂战士之吼/决斗/牺牲前尝试开启刃甲（已反弹中、近期未受击或不可用则跳过）
function BotAI:TryStrBotBladeMailBeforeTauntAbility(hero, ab)
    if not hero or hero:IsNull() or not ab or ab:IsNull() then
        return
    end
    if not self:IsMainGamePoisonRingShrunk() then
        return
    end
    local ID = Util and Util.Hero2ID and Util:Hero2ID(hero)
    if not ID or not self:IsStrengthTypeBotPlayer(ID) then
        return
    end
    if not self:CanBotUseBladeMailAfterRecentDamage(ID) then
        return
    end
    local n = ab.GetAbilityName and ab:GetAbilityName()
    if not n or not STR_BOT_TAUNT_ABILITY_NAMES[n] then
        return
    end
    if hero:HasModifier("modifier_item_blade_mail_reflect") then
        return
    end
    local it = self:FindHeroInventoryItemByName(hero, "item_blade_mail")
    if it and not it:IsNull() and self:IsBotSelfUsableActiveItem(it) then
        self:TryCastInventoryItemOnSelf(hero, it)
    end
end

--- 当前人机 tp 对应的刀塔技能 ID 数组（整局一套池，与缩圈无关）
function BotAI:GetDotaTimedSkillPoolList(ID)
    local cfg = self.Config or {}
    if type(cfg.dota_skill_pool) == "table" and #cfg.dota_skill_pool > 0 then
        return cfg.dota_skill_pool
    end
    local tab = cfg.dota_skill_pool_by_hero_type
        or cfg.dota_skill_pool_pre_ring_by_hero_type
    if not tab then
        return
    end
    local hero_tp = self:GetBotHeroType(ID)
    if hero_tp then
        local list = tab[hero_tp]
        if list and #list > 0 then
            return list
        end
    end
    return botai_merge_skill_ids_by_tp(tab)
end

function BotAI:RollDotaSkillIdFromTimedPool(ID)
    if not ID or not Skill or not Skill.GetSkillData then
        return
    end
    local list = self:GetDotaTimedSkillPoolList(ID)
    if not list then
        return
    end
    local try_num = 0
    while try_num < 100 do
        try_num = try_num + 1
        local pick = list[RandomInt(1, #list)]
        local skill_data = Skill:GetSkillData(pick)
        if skill_data
            and Skill.IsInList and not Skill:IsInList(ID, pick)
            and Skill.IsHaveAb and not Skill:IsHaveAb(ID, pick)
            and Skill.IsInPublic and not Skill:IsInPublic(pick) then
            return pick
        end
    end
end

--- 人机每 dota_skill_pool_grant_interval 秒：+1 技能点；从 dota_skill_pool_by_hero_type 随机学 Skill1，仅填空格，满 4 个刀塔技能后不再从池学习。
function BotAI:TryTimerGrantDotaPoolSkill(ID, hero, data)
    if not ID or not hero or hero:IsNull() or not data then
        return
    end
    local pdata = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
    if not pdata or pdata.bot ~= true then
        return
    end
    local cfg = self.Config or {}
    local interval = tonumber(cfg.dota_skill_pool_grant_interval) or 0
    if interval <= 0 then
        return
    end
    local gr = rawget(_G, "GameRules")
    local now = gr and gr.GetGameTime and gr:GetGameTime() or 0
    if not data.dota_pool_next_grant then
        data.dota_pool_next_grant = now + interval
        return
    end
    if now < data.dota_pool_next_grant then
        return
    end
    data.dota_pool_next_grant = now + interval

    self:TryGrantBotPeriodicAbilityPoint(hero)

    if data.dota_pool_bot_four_skills_done then
        return
    end

    if self:CountLearnedDotaSkill1Slots(ID) >= 4 then
        data.dota_pool_bot_four_skills_done = true
        return
    end

    local skill_id = self:RollDotaSkillIdFromTimedPool(ID)
    if not skill_id then
        return
    end
    local skill_slot = self:GetFirstEmptyDotaSkill1Slot(ID)
    if not skill_slot then
        data.dota_pool_bot_four_skills_done = true
        return
    end
    if self:LearnDotaSkillDirectly(ID, hero, skill_id, skill_slot) then
        self:TryAutoUpgradeSkills(ID, hero)
        if self:CountLearnedDotaSkill1Slots(ID) >= 4 then
            data.dota_pool_bot_four_skills_done = true
        end
    end
end

function BotAI:RollDotaSkillIdByBook(ID, book_type)
    if not ID or not book_type or not Skill or not Skill.Roll or not Skill.Roll[book_type] then
        return
    end
    local from_config = self:RollDotaSkillIdByBookFromConfig(ID)
    if from_config then
        return from_config
    end
    local roll_list = Skill:GetBookRollList(book_type)
    if not roll_list then
        return
    end
    local try_num = 0
    while try_num < 100 do
        local rank = Util:Weight(roll_list)
        if not rank then
            return
        end
        local skill_id = Skill:RollSkill(ID, rank)
        if skill_id then
            return skill_id
        end
        try_num = try_num + 1
    end
end

function BotAI:LearnDotaSkillDirectly(ID, hero, skill_id, slot_num)
    if not ID or not hero or hero:IsNull() or not skill_id or not slot_num then
        return false
    end
    local skill_data = Skill.GetSkillData and Skill:GetSkillData(skill_id)
    if not skill_data or not skill_data.name then
        return false
    end
    local skill_name = skill_data.name
    if hero:HasAbility(skill_name) then
        return false
    end
    local slot = "slot_" .. slot_num
    local slot_data = Skill.Data[ID] and Skill.Data[ID].Skill1 and Skill.Data[ID].Skill1[slot]
    if not slot_data then
        return false
    end
    local old_skill = slot_data.name
    local ab = hero:AddAbility(skill_name)
    if not ab or ab:IsNull() then
        return false
    end
    ab:SetLevel(1)
    hero:SwapAbilities(skill_name, old_skill, true, true)
    local old_ab = hero:FindAbilityByName(old_skill)
    if old_ab and not old_ab:IsNull() then
        old_ab:SetHidden(true)
    end
    local new_id = Skill.GetSkillID and Skill:GetSkillID(skill_name) or -1
    slot_data.name = skill_name
    slot_data.id = new_id or -1
    return true
end

function BotAI:TryUseDotaSkillBook(ID, item_name, data)
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return false
    end
    local book_type = self:GetDotaSkillBookType(item_name)
    if not book_type or not Skill then
        return false
    end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return false
    end
    local skill_id = self:RollDotaSkillIdByBook(ID, book_type)
    if not skill_id then
        return false
    end
    local skill_slot = self:GetPreferredDotaSkillSlot(ID, data, skill_id)
    if not skill_slot then
        return false
    end
    return self:LearnDotaSkillDirectly(ID, hero, skill_id, skill_slot)
end

function BotAI:TryAutoUpgradeSkills(ID, hero)
    if not ID or not hero or hero:IsNull() then
        return false
    end
    local point = 0
    if hero.GetAbilityPoints then
        point = hero:GetAbilityPoints() or 0
    end
    if point <= 0 or not Skill or not Skill.Data or not Skill.Data[ID] then
        return false
    end

    local upgraded = false
    local function try_upgrade(ability_name)
        if not ability_name or (Skill.IsNullSkill and Skill:IsNullSkill(ability_name)) then
            return false
        end

        -- Skill2(肉搏)仅允许升级当前类型白名单内的技能
        local melee_item_name = self:AbilityNameToMeleeItemName(ability_name)
        if melee_item_name then
            if self:IsMeleeSkillBookBlocklisted(melee_item_name) then
                return false
            end
            local wl = self:GetMeleeSkillLearnWhitelist(ID)
            if not wl or not wl[melee_item_name] then
                return false
            end
        end

        local ab = hero:FindAbilityByName(ability_name)
        if not ab or ab:IsNull() then
            return false
        end
        local level = ab:GetLevel() or 0
        local max_level = ab.GetMaxLevel and ab:GetMaxLevel() or 0
        if max_level <= 0 or level >= max_level then
            return false
        end
        local can_upgrade = true
        if ab.CanAbilityBeUpgraded then
            local state = ab:CanAbilityBeUpgraded()
            if state ~= nil and state ~= 0 then
                can_upgrade = false
            end
        end
        if not can_upgrade then
            return false
        end
        local before_point = hero:GetAbilityPoints() or 0
        local before_level = ab:GetLevel() or 0
        hero:UpgradeAbility(ab)
        local after_point = hero:GetAbilityPoints() or 0
        local after_level = ab:GetLevel() or 0
        if after_level <= before_level and after_point >= before_point then
            return false
        end
        upgraded = true
        return true
    end

    for i = 1, 4 do
        local slot = Skill.Data[ID].Skill1 and Skill.Data[ID].Skill1["slot_" .. i]
        if slot and try_upgrade(slot.name) then
            return true
        end
    end
    for i = 5, 10 do
        local slot = Skill.Data[ID].Skill2 and Skill.Data[ID].Skill2["slot_" .. i]
        if slot and slot.state and try_upgrade(slot.name) then
            return true
        end
    end

    return upgraded
end

function BotAI:IsSkill2Full(ID)
    if not ID or not Skill or not Skill.Data or not Skill.Data[ID] then
        return true
    end
    for _, v in pairs(Skill.Data[ID].Skill2 or {}) do
        if v and v.state == false then
            return false
        end
    end
    return true
end

function BotAI:CanUseMeleeBook(ID, item_name)
    if not ID or not item_name or not self:IsMeleeBook(item_name) then
        return false
    end
    if self:IsMeleeSkillBookBlocklisted(item_name) then
        return false
    end

    local wl = self:GetMeleeSkillLearnWhitelist(ID)
    -- 只要白名单存在(或 tp 识别成功)，就严格按白名单学习；否则不学习肉搏
    if not wl or not wl[item_name] then
        return false
    end

    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return false
    end

    local index = utilex:splitIndex(item_name, "_", 3)
    local new_skill = "ability_item_" .. index
    local arr_len = utilex:split(item_name, "_")
    if hero:HasAbility(new_skill) and #arr_len == 3 then
        local ab = hero:FindAbilityByName(new_skill)
        if not ab then
            return false
        end
        local level = ab:GetLevel() or 0
        return level < 10 and hero:GetLevel() > level
    end

    if item_name == "item_skill_14_up" or item_name == "item_skill_20_up" or item_name == "item_skill_24_up" then
        local self_skill = nil
        if item_name == "item_skill_14_up" then
            self_skill = "ability_item_14"
        end
        if item_name == "item_skill_20_up" then
            self_skill = "ability_item_20"
        end
        if item_name == "item_skill_24_up" then
            self_skill = "ability_item_24"
        end
        local old_ab = self_skill and hero:FindAbilityByName(self_skill)
        return old_ab ~= nil and old_ab:GetLevel() == 10
    end

    return not self:IsSkill2Full(ID)
end

--- 每隔 BOTAI_AUTO_MELEE_LEARN_INTERVAL 秒自动学一条白名单内肉搏：优先未持有的技能，其次未满级的升级（不学 item_skill_*_up 进阶）。
function BotAI:TryPeriodicAutoMeleeSkillLearn(ID, hero, data)
    if not ID or not hero or hero:IsNull() or not data then
        return false
    end
    if data._melee_auto_learn_stopped then
        return false
    end
    if self:IsSkill2Full(ID) then
        data._melee_auto_learn_stopped = true
        return false
    end
    local now = botai_game_time()
    if data._melee_auto_learn_next == nil then
        data._melee_auto_learn_next = now + BOTAI_AUTO_MELEE_LEARN_INTERVAL
    end
    if now < data._melee_auto_learn_next then
        return false
    end
    data._melee_auto_learn_next = now + BOTAI_AUTO_MELEE_LEARN_INTERVAL

    local wl = self:GetMeleeSkillLearnWhitelist(ID)
    if not wl or not next(wl) then
        return false
    end

    local new_cands = {}
    local up_cands = {}

    for item_name, ok in pairs(wl) do
        if ok and type(item_name) == "string" and self:IsMeleeBook(item_name) and not self:IsMeleeSkillBookBlocklisted(item_name) then
            if not string.match(item_name, "_up$") and self:CanUseMeleeBook(ID, item_name) then
                local idx = utilex:splitIndex(item_name, "_", 3)
                if idx then
                    local new_skill = "ability_item_" .. idx
                    if not hero:HasAbility(new_skill) then
                        new_cands[#new_cands + 1] = item_name
                    else
                        local ab = hero:FindAbilityByName(new_skill)
                        if ab and not ab:IsNull() then
                            local level = ab:GetLevel() or 0
                            if level < 10 and hero:GetLevel() > level then
                                up_cands[#up_cands + 1] = item_name
                            end
                        end
                    end
                end
            end
        end
    end

    local pool = new_cands
    if #pool == 0 then
        pool = up_cands
    end
    if #pool == 0 then
        return false
    end
    local pick = pool[RandomInt(1, #pool)]
    if Skill and Skill.AddSkill2 and Skill:AddSkill2(ID, pick) then
        self:TryAutoUpgradeSkills(ID, hero)
        return true
    end
    return false
end

--- 是否存在敌对普攻/仇恨目标（有则本轮允许 FindUnits 扫英雄，否则仅打野巡逻减轻负载）
local function botai_unit_has_hostile_attack_or_aggro(unit)
    if not unit or unit:IsNull() or not unit:IsAlive() then
        return false
    end
    local team = unit:GetTeamNumber()
    local function hostile(u)
        return u and not u:IsNull() and u:IsAlive() and u:GetTeamNumber() ~= team
    end
    local at = unit.GetAttackTarget and unit:GetAttackTarget() or nil
    if hostile(at) then
        return true
    end
    local ag = unit.GetAggroTarget and unit:GetAggroTarget() or nil
    return hostile(ag)
end

-- 在自身当前视野（及略大于攻击距离）半径内，找可见的最近敌英雄；无则再查 BASIC（兵线/野怪）。
-- allow_hero_scan 为 false 时不做 TARGET_HERO 的 FindUnits（仅巡逻/打野路径）；为 true 或未传时先英雄后 BASIC。
-- data 传入时可复用约 BOTAI_COMBAT_TARGET_CACHE_TTL 秒内的上次结果（目标失效则自动重扫）。
function BotAI:FindVisibleEnemyHeroAndFarmTargetsInCombatRadius(hero, data, allow_hero_scan)
    if not hero or hero:IsNull() then
        return nil, nil
    end
    if allow_hero_scan == nil then
        allow_hero_scan = true
    end
    local now = botai_game_time()
    local origin = hero:GetAbsOrigin()
    local hero_team = hero:GetTeamNumber()
    local radius = self:GetBotThinkUnitSearchRadius(hero)
    local r_check = radius + 80
    -- 已锁定的敌英雄：只要仍存活、可见且在检查半径内，不再做 TARGET_HERO 的 FindUnits（死亡/出距/丢失再重扫）
    if data and allow_hero_scan then
        local ch = data._combat_tgt_cache_h
        if ch and not ch:IsNull() and ch:IsAlive() and ch:IsHero() and ch:GetTeamNumber() ~= hero_team and self:IsVisibleTarget(hero, ch) and
            (ch:GetAbsOrigin() - origin):Length2D() <= r_check then
            data._combat_tgt_cache_t = now
            return ch, nil
        end
        if ch then
            data._combat_tgt_cache_h = nil
        end
    end
    -- 兵线/野怪：短 TTL 复用，减轻 BASIC FindUnits
    if data then
        local t0 = data._combat_tgt_cache_t
        if t0 and (now - t0) < BOTAI_COMBAT_TARGET_CACHE_TTL then
            local cf = data._combat_tgt_cache_f
            if cf and not cf:IsNull() and cf:IsAlive() and not cf:IsHero() and cf:GetTeamNumber() ~= hero_team and self:IsVisibleTarget(hero, cf) then
                if (cf:GetAbsOrigin() - origin):Length2D() <= r_check then
                    return nil, cf
                end
            end
        end
    end
    if allow_hero_scan then
        local best_hero
        local best_hero_d
        local foes = FindUnitsInRadius(
            hero:GetTeamNumber(),
            origin,
            nil,
            radius,
            TARGET_TEAM_BOTH,
            TARGET_HERO,
            TARGET_FLAG,
            FIND_ANY_ORDER,
            false
        )
        for _, u in pairs(foes) do
            if u and not u:IsNull() and u:IsAlive() and u:IsHero() and u:GetTeamNumber() ~= hero_team and self:IsVisibleTarget(hero, u) then
                local d = (u:GetAbsOrigin() - origin):Length2D()
                if not best_hero_d or d < best_hero_d then
                    best_hero = u
                    best_hero_d = d
                end
            end
        end
        if best_hero then
            if data then
                data._combat_tgt_cache_t = now
                data._combat_tgt_cache_h = best_hero
                data._combat_tgt_cache_f = nil
                data._next_basic_scan_after = nil
            end
            return best_hero, nil
        end
    end
    -- BASIC 扫描节流：未到时间且上次兵线目标仍有效则沿用；否则立刻重扫（避免无目标空转）
    if data and data._next_basic_scan_after and now < data._next_basic_scan_after then
        local cf = data._combat_tgt_cache_f
        if cf and not cf:IsNull() and cf:IsAlive() and not cf:IsHero() and cf:GetTeamNumber() ~= hero_team and
            self:IsVisibleTarget(hero, cf) then
            if (cf:GetAbsOrigin() - origin):Length2D() <= r_check then
                return nil, cf
            end
        end
    end
    local best_basic
    local best_basic_d
    local creeps = FindUnitsInRadius(
        hero:GetTeamNumber(),
        origin,
        nil,
        radius,
        TARGET_TEAM_BOTH,
        TARGET_BASIC,
        TARGET_FLAG,
        FIND_ANY_ORDER,
        false
    )
    for _, u in pairs(creeps) do
        if u and not u:IsNull() and u:IsAlive() and self:IsVisibleTarget(hero, u) then
            local ut = u:GetTeamNumber()
            if ut ~= hero_team then
                local d = (u:GetAbsOrigin() - origin):Length2D()
                if not best_basic_d or d < best_basic_d then
                    best_basic = u
                    best_basic_d = d
                end
            end
        end
    end
    if data then
        data._combat_tgt_cache_t = now
        data._combat_tgt_cache_h = nil
        data._combat_tgt_cache_f = best_basic
        data._next_basic_scan_after = now + BOTAI_BASIC_SCAN_MIN_INTERVAL
    end
    return nil, best_basic
end

function BotAI:FindBestEnemyHeroTarget(hero)
    local h = select(1, self:FindVisibleEnemyHeroAndFarmTargetsInCombatRadius(hero, nil))
    return h
end

function BotAI:FindBestCreepOrNeutralTarget(hero)
    local _, f = self:FindVisibleEnemyHeroAndFarmTargetsInCombatRadius(hero, nil, false)
    return f
end

function BotAI:FindBestTarget(hero)
    local h, f = self:FindVisibleEnemyHeroAndFarmTargetsInCombatRadius(hero, nil)
    return h or f
end

function BotAI:GetNextPatrolPosition(hero, data, force_next)
    local patrol_points = self:GetPatrolPoints(hero)
    if not patrol_points or #patrol_points == 0 then
        return
    end

    local current_pos = data.patrol_target_pos
    if not force_next and current_pos and (hero:GetAbsOrigin() - current_pos):Length2D() > self.Config.patrol_reach_distance then
        return current_pos, data.patrol_index or 1
    end
    local reach = tonumber(self.Config.patrol_reach_distance) or 220
    -- 与上一巡逻目标至少拉开一定距离，避免在同一小片营地间来回抽中相同/邻近点
    local min_sep_from_last = math.max(reach * 2.1, 520)
    local prev_target = data.patrol_target_pos
    local candidates = {}
    for i, entry in ipairs(patrol_points) do
        if not prev_target or (entry.pos - prev_target):Length2D() >= min_sep_from_last then
            candidates[#candidates + 1] = i
        end
    end
    if #candidates == 0 then
        for i = 1, #patrol_points do
            candidates[i] = i
        end
    end
    local target_index = candidates[RandomInt(1, #candidates)]
    local target_pos = patrol_points[target_index].pos
    -- 在仍有更近点的情况下，略偏好较远营地（打乱顺序后取前若干再随机），减少「刚到新点又指向隔壁」
    if #patrol_points >= 3 then
        local far_pool = {}
        for _, i in ipairs(candidates) do
            local d = (patrol_points[i].pos - hero:GetAbsOrigin()):Length2D()
            far_pool[#far_pool + 1] = { i = i, d = d }
        end
        table.sort(far_pool, function(a, b)
            return a.d > b.d
        end)
        local take = math.min(4, #far_pool)
        if take >= 2 then
            local pick = far_pool[RandomInt(1, take)]
            target_index = pick.i
            target_pos = patrol_points[target_index].pos
        end
    end

    data.patrol_index = target_index
    data.patrol_target_pos = target_pos
    return target_pos, target_index
end

function BotAI:IssueAttack(hero, target, data)
    if not hero or not target or not ExecuteOrderFromTableFn then
        return
    end
    local target_index = target:entindex()
    -- 仅 GetAggroTarget 去重会在技能后摇/弹道/引擎短暂清空仇恨时失效，Think 周期内反复 ATTACK_TARGET 会打断普攻并易触发 AttackRecord 清理告警
    local focused_same = false
    if hero.GetAttackTarget then
        local at = hero:GetAttackTarget()
        if at and not at:IsNull() and at == target then
            focused_same = true
        end
    end
    if not focused_same and hero.GetAggroTarget then
        local ag = hero:GetAggroTarget()
        if ag and not ag:IsNull() and ag == target then
            focused_same = true
        end
    end
    if data.last_order == "attack" and data.last_target_entindex == target_index and focused_same then
        return
    end
    ExecuteOrderFromTableFn({
        UnitIndex = hero:entindex(),
        OrderType = ORDER_ATTACK,
        TargetIndex = target_index,
    })
    data.last_order = "attack"
    data.last_target_entindex = target_index
end

--- 目标是否开启刃甲主动（伤害反弹）
function BotAI:TargetHasActiveBladeMailReflect(target)
    if not target or target:IsNull() or not target.HasModifier then
        return false
    end
    return target:HasModifier("modifier_item_blade_mail_reflect")
end

--- 黑皇杖魔免（用于对开刃甲目标可继续输出）
function BotAI:BotHeroHasBlackKingBarImmunity(hero)
    if not hero or hero:IsNull() or not hero.HasModifier then
        return false
    end
    if hero:HasModifier("modifier_black_king_bar_immune") then
        return true
    end
    return hero:HasModifier("modifier_item_black_king_bar_active")
end

--- 刃甲目标：我方血线高于对方或已有 BKB 魔免时，不执行刃甲撤退并可对目标交技能/普攻
function BotAI:ShouldSkipBladeMailEvade(hero, target)
    if not hero or hero:IsNull() or not target or target:IsNull() or not target:IsAlive() then
        return false
    end
    if self:GetHealthPct(hero) > self:GetHealthPct(target) then
        return true
    end
    if self:BotHeroHasBlackKingBarImmunity(hero) then
        return true
    end
    return false
end

--- 目标开刃甲且我方血线不占优时：若有可用黑皇杖则先开启（不撤退）
function BotAI:TryBotCastBlackKingBarVsBladeMail(hero, target, data)
    if not hero or hero:IsNull() or not target or target:IsNull() or not ExecuteOrderFromTableFn then
        return false
    end
    if not self:TargetHasActiveBladeMailReflect(target) then
        return false
    end
    if self:GetHealthPct(hero) > self:GetHealthPct(target) then
        return false
    end
    if self:BotHeroHasBlackKingBarImmunity(hero) then
        return false
    end
    local it = self:FindHeroInventoryItemByName(hero, "item_black_king_bar")
    if not it or not self:IsBotSelfUsableActiveItem(it) then
        return false
    end
    if not self:TryCastInventoryItemOnSelf(hero, it) then
        return false
    end
    if data then
        data.pending_cast = nil
        data.last_order = "bkb_vs_blade_mail"
    end
    return true
end

function BotAI:IssueMoveAwayFromUnit(hero, from_unit, distance)
    if not hero or hero:IsNull() or not from_unit or from_unit:IsNull() or not ExecuteOrderFromTableFn then
        return false
    end
    local hp = hero:GetAbsOrigin()
    local fp = from_unit:GetAbsOrigin()
    local delta = hp - fp
    delta = Vector(delta.x, delta.y, 0)
    local len = delta:Length2D()
    if len < 1 then
        delta = Vector(1, 0, 0)
        len = 1
    end
    local pos = hp + delta:Normalized() * distance
    ExecuteOrderFromTableFn({
        UnitIndex = hero:entindex(),
        OrderType = ORDER_MOVE,
        Position = pos,
    })
    return true
end

function BotAI:TryContinueBladeMailEvade(hero, data)
    if not hero or hero:IsNull() or not data or not GameRulesRef or not GameRulesRef.GetGameTime then
        return false
    end
    local gt = GameRulesRef:GetGameTime() or 0
    if not data.bm_evade_until or data.bm_evade_until <= gt then
        if data.bm_evade_until then
            data.bm_evade_until = nil
            data.bm_evade_foe = nil
            data._bm_evade_last_issue_t = nil
        end
        return false
    end
    local foe = data.bm_evade_foe and EntIndexToHScript(data.bm_evade_foe) or nil
    if foe and not foe:IsNull() and foe:IsAlive() and self:TargetHasActiveBladeMailReflect(foe) and
        self:ShouldSkipBladeMailEvade(hero, foe) then
        data.bm_evade_until = nil
        data.bm_evade_foe = nil
        data._bm_evade_last_issue_t = nil
        return false
    end
    local dist = (self.Config and self.Config.blade_mail_evade_distance) or 680
    if foe and not foe:IsNull() and foe:IsAlive() then
        if data._bm_evade_last_issue_t and gt - data._bm_evade_last_issue_t < 0.32 and hero:IsMoving() then
            data.pending_cast = nil
            data.last_order = "blade_mail_evade"
            data.last_target_entindex = nil
            return true
        end
        self:IssueMoveAwayFromUnit(hero, foe, dist)
        data._bm_evade_last_issue_t = gt
    else
        self:IssuePatrol(hero, data)
    end
    data.pending_cast = nil
    data.last_order = "blade_mail_evade"
    data.last_target_entindex = nil
    return true
end

--- 攻击/仇恨目标开启刃甲时：停止追击输出，背向目标撤退一段时间（默认 2 秒）
function BotAI:TryStartBladeMailEvadeFromTarget(hero, target, data)
    if not hero or hero:IsNull() or not target or target:IsNull() or not data or not GameRulesRef or not GameRulesRef.GetGameTime then
        return false
    end
    if not self:TargetHasActiveBladeMailReflect(target) then
        return false
    end
    if self:ShouldSkipBladeMailEvade(hero, target) then
        return false
    end
    local gt = GameRulesRef:GetGameTime() or 0
    if data.bm_evade_until and data.bm_evade_until > gt then
        return false
    end
    local dur = (self.Config and tonumber(self.Config.blade_mail_evade_duration)) or 2
    if dur <= 0 then
        dur = 2
    end
    data.bm_evade_until = gt + dur
    data.bm_evade_foe = target:entindex()
    data.pending_cast = nil
    local dist = (self.Config and self.Config.blade_mail_evade_distance) or 680
    self:IssueMoveAwayFromUnit(hero, target, dist)
    data._bm_evade_last_issue_t = gt
    data.last_order = "blade_mail_evade"
    data.last_target_entindex = nil
    return true
end

function BotAI:IsAbilityBehavior(ab, flag)
    if not ab or ab:IsNull() or not flag or not bit_band or not ab.GetBehavior then
        return false
    end
    local ok, behavior = pcall(function()
        return ab:GetBehavior()
    end)
    if not ok then
        return false
    end
    if type(behavior) ~= "number" then
        behavior = tonumber(behavior) or 0
    end
    return bit_band(behavior, flag) ~= 0
end

function BotAI:CanAutoCastAbility(hero, ab)
    if not hero or not ab or ab:IsNull() then
        return false
    end
    if ab:IsHidden() or not ab:IsFullyCastable() then
        return false
    end
    if self:IsAbilityBehavior(ab, BEHAVIOR_PASSIVE) or self:IsAbilityBehavior(ab, BEHAVIOR_HIDDEN) then
        return false
    end
    if self:IsAbilityBehavior(ab, BEHAVIOR_TOGGLE) then
        return false
    end
    return self:IsAbilityBehavior(ab, BEHAVIOR_NO_TARGET)
        or self:IsAbilityBehavior(ab, BEHAVIOR_UNIT_TARGET)
        or self:IsAbilityBehavior(ab, BEHAVIOR_POINT)
end

function BotAI:QueueDelayedCast(hero, target, data, order_type, ability_index, target_index, position)
    if not hero or hero:IsNull() or not data or not ability_index then
        return false
    end
    local game_time = GameRulesRef and GameRulesRef.GetGameTime and GameRulesRef:GetGameTime() or 0
    if data.pending_cast and data.pending_cast.execute_at and data.pending_cast.execute_at > game_time then
        return true
    end
    local delay = self.Config.cast_delay_min +
        math.random() * (self.Config.cast_delay_max - self.Config.cast_delay_min)
    data.pending_cast = {
        execute_at = game_time + delay,
        hero_entindex = hero:entindex(),
        target_entindex = target_index,
        order_type = order_type,
        ability_index = ability_index,
        position = position,
    }
    data.last_order = "cast_pending"
    data.last_target_entindex = target_index
    return true
end

function BotAI:TryExecutePendingCast(hero, data)
    if not hero or hero:IsNull() or not data or not data.pending_cast or not ExecuteOrderFromTableFn then
        return false
    end
    local pending = data.pending_cast
    local game_time = GameRulesRef and GameRulesRef.GetGameTime and GameRulesRef:GetGameTime() or 0
    if pending.execute_at and pending.execute_at > game_time then
        return true
    end
    local ab = EntIndexToHScript(pending.ability_index or -1)
    if not ab or ab:IsNull() or not ab:IsFullyCastable() then
        data.pending_cast = nil
        return false
    end
    local order = {
        UnitIndex = hero:entindex(),
        OrderType = pending.order_type,
        AbilityIndex = pending.ability_index,
    }
    if pending.order_type == ORDER_CAST_TARGET then
        local target = EntIndexToHScript(pending.target_entindex or -1)
        if not target or target:IsNull() or not target:IsAlive() then
            data.pending_cast = nil
            return false
        end
        if not target:IsHero() then
            data.pending_cast = nil
            return false
        end
        order.TargetIndex = pending.target_entindex
        data.last_order = "cast_target"
        data.last_target_entindex = pending.target_entindex
    elseif pending.order_type == ORDER_CAST_POSITION then
        local ctx = EntIndexToHScript(pending.target_entindex or -1)
        if ctx and not ctx:IsNull() and not ctx:IsHero() then
            data.pending_cast = nil
            return false
        end
        order.Position = pending.position
        data.last_order = "cast_position"
        data.last_target_entindex = pending.target_entindex
    else
        data.last_order = "cast_no_target"
        data.last_target_entindex = pending.target_entindex
    end
    ExecuteOrderFromTableFn(order)
    data.pending_cast = nil
    return true
end

function BotAI:IsBotSelfUsableActiveItem(it)
    if not it or it:IsNull() or not it.GetBehavior then
        return false
    end
    if it:IsHidden() or not it:IsFullyCastable() then
        return false
    end
    if self:IsAbilityBehavior(it, BEHAVIOR_TOGGLE) then
        return false
    end
    return self:IsAbilityBehavior(it, BEHAVIOR_NO_TARGET)
        or self:IsAbilityBehavior(it, BEHAVIOR_UNIT_TARGET)
        or self:IsAbilityBehavior(it, BEHAVIOR_POINT)
end

function BotAI:CollectBotSelfUsableActiveItems(hero, bot_player_id)
    local list = {}
    if not hero or hero:IsNull() then
        return list
    end
    local skip_pike = bot_player_id and self:IsRangedAgilityBotPlayer(bot_player_id)
    local skip_abyssal_melee_agi = bot_player_id and self:IsMeleeAgilityBotPlayer(bot_player_id)
    for slot = 0, 5 do
        local it = hero:GetItemInSlot(slot)
        if it and not it:IsNull() and self:IsBotSelfUsableActiveItem(it) then
            local name = it.GetAbilityName and it:GetAbilityName()
            if skip_pike and name == "item_hurricane_pike" then
            elseif skip_abyssal_melee_agi and name == "item_abyssal_blade" then
            else
                table.insert(list, it)
            end
        end
    end
    return list
end

function BotAI:GetBotHostileAttackOrAggroTarget(hero)
    if not hero or hero:IsNull() then
        return
    end
    local function hostile_ok(u)
        return u and not u:IsNull() and u:IsAlive() and u:GetTeamNumber() ~= hero:GetTeamNumber()
    end
    local t = hero.GetAttackTarget and hero:GetAttackTarget() or nil
    if hostile_ok(t) then
        return t
    end
    t = hero.GetAggroTarget and hero:GetAggroTarget() or nil
    if hostile_ok(t) then
        return t
    end
end

--- 目标是否已有眩晕、沉默或妖术（羊）：此时不使用羊刀/深渊主动，等结束后再交
function BotAI:TargetHasStunSilenceOrHex(target)
    if not target or target:IsNull() then
        return true
    end
    if safe_unit_bool(target, "IsStunned") then
        return true
    end
    if safe_unit_bool(target, "IsSilenced") then
        return true
    end
    if safe_unit_bool(target, "IsHexed") then
        return true
    end
    return false
end

--- 敌方英雄是否为真实玩家操控（非人机、非幻象）
function BotAI:IsEnemyHeroRealPlayerUnit(target)
    if not target or target:IsNull() or not target:IsHero() then
        return false
    end
    if safe_unit_bool(target, "IsIllusion") then
        return false
    end
    if not target.GetPlayerOwnerID then
        return false
    end
    local pid = target:GetPlayerOwnerID()
    if type(pid) ~= "number" or pid < 0 then
        return false
    end
    if not Util or not Util.IsPseudoPlayerID then
        return false
    end
    return not Util:IsPseudoPlayerID(pid)
end

function BotAI:FindHeroInventoryItemByName(hero, item_name)
    if not hero or hero:IsNull() or not item_name then
        return
    end
    for slot = 0, 8 do
        local it = hero:GetItemInSlot(slot)
        if it and not it:IsNull() and it.GetAbilityName and it:GetAbilityName() == item_name then
            return it
        end
    end
end

--- 对真实玩家英雄立即使用羊刀/深渊（不占随机施法延迟）；目标已有眩晕/沉默/妖术时跳过
function BotAI:TryCastPriorityCcItemsOnRealPlayerHero(hero, target, data)
    if not hero or hero:IsNull() or not target or target:IsNull() or not ExecuteOrderFromTableFn then
        return false
    end
    if not self:IsEnemyHeroRealPlayerUnit(target) then
        return false
    end
    if not self:IsVisibleTarget(hero, target) then
        return false
    end
    if self:TargetHasStunSilenceOrHex(target) then
        return false
    end
    if self:TargetHasActiveBladeMailReflect(target) and not self:ShouldSkipBladeMailEvade(hero, target) then
        return false
    end

    local target_pos = target:GetAbsOrigin()
    local hero_pos = hero:GetAbsOrigin()
    local target_index = target:entindex()
    local hero_idx = hero:entindex()

    for _, item_name in ipairs(PRIORITY_CC_INVENTORY_ITEMS) do
        local it = self:FindHeroInventoryItemByName(hero, item_name)
        if it and not it:IsNull() and self:IsBotSelfUsableActiveItem(it) and self:IsAbilityBehavior(it, BEHAVIOR_UNIT_TARGET) then
            local skip_for_magic = item_name == "item_sheepstick" and target.IsMagicImmune and target:IsMagicImmune()
            if not skip_for_magic then
                local cast_range = it.GetCastRange and it:GetCastRange(target_pos, target) or 0
                local distance = (hero_pos - target_pos):Length2D()
                if cast_range <= 0 or distance <= cast_range + 100 then
                    ExecuteOrderFromTableFn({
                        UnitIndex = hero_idx,
                        OrderType = ORDER_CAST_TARGET,
                        TargetIndex = target_index,
                        AbilityIndex = it:entindex(),
                    })
                    if data then
                        data.pending_cast = nil
                        data.last_order = "priority_cc_item"
                        data.last_target_entindex = target_index
                    end
                    return true
                end
            end
        end
    end
    return false
end

function BotAI:TryCastInventoryItemOnSelf(hero, it)
    if not hero or hero:IsNull() or not it or it:IsNull() or not ExecuteOrderFromTableFn then
        return false
    end
    if not self:IsBotSelfUsableActiveItem(it) then
        return false
    end
    local iname = it.GetAbilityName and it:GetAbilityName()
    if iname == "item_blade_mail" then
        local ID = Util and Util.Hero2ID and Util:Hero2ID(hero)
        if ID and not self:CanBotUseBladeMailAfterRecentDamage(ID) then
            return false
        end
    end
    local ability_index = it:entindex()
    local hero_idx = hero:entindex()
    if self:IsAbilityBehavior(it, BEHAVIOR_UNIT_TARGET) then
        local tgt = self:GetBotHostileAttackOrAggroTarget(hero)
        if not tgt or not tgt:IsHero() then
            return false
        end
        ExecuteOrderFromTableFn({
            UnitIndex = hero_idx,
            OrderType = ORDER_CAST_TARGET,
            TargetIndex = tgt:entindex(),
            AbilityIndex = ability_index,
        })
        return true
    end
    if self:IsAbilityBehavior(it, BEHAVIOR_POINT) then
        ExecuteOrderFromTableFn({
            UnitIndex = hero_idx,
            OrderType = ORDER_CAST_POSITION,
            Position = hero:GetAbsOrigin(),
            AbilityIndex = ability_index,
        })
        return true
    end
    if self:IsAbilityBehavior(it, BEHAVIOR_NO_TARGET) then
        ExecuteOrderFromTableFn({
            UnitIndex = hero_idx,
            OrderType = ORDER_CAST_NO_TARGET,
            AbilityIndex = ability_index,
        })
        return true
    end
    return false
end

function BotAI:IsFightingEnemyHero(hero)
    if not hero or hero:IsNull() or not hero:IsAlive() then
        return false
    end
    local enemy = hero.GetAggroTarget and hero:GetAggroTarget() or nil
    if not enemy or enemy:IsNull() or not enemy:IsAlive() or not enemy:IsHero() then
        enemy = hero.GetAttackTarget and hero:GetAttackTarget() or nil
    end
    if not enemy or enemy:IsNull() or not enemy:IsAlive() or not enemy:IsHero() then
        return false
    end
    return enemy:GetTeamNumber() ~= hero:GetTeamNumber()
end

-- 低血量且与敌方英雄交战时自动用装备：无目标仍对自己；需选单位的道具仅对敌方英雄（攻击或仇恨目标），否则跳过该件。
function BotAI:TryUseActiveItemsByHealth(hero, data)
    if not hero or hero:IsNull() then
        return false
    end
    if not ExecuteOrderFromTableFn then
        return false
    end
    if not self:IsFightingEnemyHero(hero) then
        return false
    end

    local bm_foe = self:GetBotHostileAttackOrAggroTarget(hero)
    if bm_foe and self:TargetHasActiveBladeMailReflect(bm_foe) and not self:ShouldSkipBladeMailEvade(hero, bm_foe) then
        return false
    end

    local hp_pct = self:GetHealthPct(hero)
    local c = self.Config
    local p80 = c.item_use_hp_random_30_below_pct or 0.8
    local p60 = c.item_use_hp_random_50_below_pct or 0.6
    local p40 = c.item_use_hp_dump_all_below_pct or 0.4
    if hp_pct >= p80 then
        return false
    end

    local items = self:CollectBotSelfUsableActiveItems(hero, data and data.id)
    if #items == 0 then
        return false
    end

    if hp_pct < p40 then
        local stagger = c.item_use_dump_all_stagger or 0.08
        local used_any = false
        for i, it in ipairs(items) do
            if i == 1 then
                if self:TryCastInventoryItemOnSelf(hero, it) then
                    used_any = true
                end
            else
                local he = hero:entindex()
                local ie = it:entindex()
                local delay = stagger * (i - 1)
                Timers(delay, function()
                    if BotAI and BotAI._settlement_stopped then
                        return
                    end
                    local h = EntIndexToHScript(he)
                    local item = EntIndexToHScript(ie)
                    if not h or h:IsNull() or not h:IsAlive() then
                        return
                    end
                    if not item or item:IsNull() then
                        return
                    end
                    if not BotAI:IsFightingEnemyHero(h) then
                        return
                    end
                    BotAI:TryCastInventoryItemOnSelf(h, item)
                end)
                used_any = true
            end
        end
        return used_any
    end

    local roll_max = c.item_use_random_chance_at_80 or 0.3
    if hp_pct < p60 then
        roll_max = c.item_use_random_chance_at_60 or 0.5
    end
    local r = RandomFloat(0, 1)
    if r > roll_max then
        return false
    end
    local pick = items[RandomInt(1, #items)]
    return self:TryCastInventoryItemOnSelf(hero, pick)
end

function BotAI:TryCastActiveAbility(hero, target, data)
    if not hero or not target or target:IsNull() or not ExecuteOrderFromTableFn then
        return false
    end
    local target_pos = target:GetAbsOrigin()
    local target_index = target:entindex()
    local skip_vs_target = target:IsHero() and self:TargetHasActiveBladeMailReflect(target) and
        not self:ShouldSkipBladeMailEvade(hero, target)

    for i = 0, hero:GetAbilityCount() - 1 do
        local ab = hero:GetAbilityByIndex(i)
        if self:CanAutoCastAbility(hero, ab) then
            local ability_index = ab:entindex()
            local cast_range = ab.GetCastRange and ab:GetCastRange(target_pos, target) or 0
            local distance = (hero:GetAbsOrigin() - target_pos):Length2D()
            if self:IsAbilityBehavior(ab, BEHAVIOR_UNIT_TARGET) then
                if target:IsHero() and not skip_vs_target and (cast_range <= 0 or distance <= cast_range + 100) then
                    self:TryStrBotBladeMailBeforeTauntAbility(hero, ab)
                    return self:QueueDelayedCast(hero, target, data, ORDER_CAST_TARGET, ability_index, target_index, nil)
                end
            elseif self:IsAbilityBehavior(ab, BEHAVIOR_NO_TARGET) then
                self:TryStrBotBladeMailBeforeTauntAbility(hero, ab)
                return self:QueueDelayedCast(hero, target, data, ORDER_CAST_NO_TARGET, ability_index, target_index, nil)
            elseif self:IsAbilityBehavior(ab, BEHAVIOR_POINT) then
                if target:IsHero() and not skip_vs_target and (cast_range <= 0 or distance <= cast_range + 100) then
                    self:TryStrBotBladeMailBeforeTauntAbility(hero, ab)
                    return self:QueueDelayedCast(hero, target, data, ORDER_CAST_POSITION, ability_index, target_index,
                        target_pos)
                end
            end
        end
    end
    return false
end

function BotAI:IssuePatrol(hero, data)
    if not ExecuteOrderFromTableFn then
        return
    end

    local target_pos, patrol_index = self:GetNextPatrolPosition(hero, data, false)
    if not target_pos then
        return
    end
    if data.last_order == "move" and data.last_patrol_index == patrol_index and hero:IsMoving() then
        return
    end

    ExecuteOrderFromTableFn({
        UnitIndex = hero:entindex(),
        OrderType = ORDER_MOVE,
        Position = target_pos,
    })
    data.last_order = "move"
    data.last_patrol_index = patrol_index
    data.last_target_entindex = nil
end

function BotAI:Think(ID, token)
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_DISCONNECT then
        return
    end
    -- [1] 令牌与对局状态：非法令牌、结算、赛后态则停 Think（return nil 终止 Timers 循环）
    local data = self.Data[ID]
    if not data or data.token ~= token then
        return
    end
    if self._settlement_stopped then
        return nil
    end
    if MainGame.Data.over == true then
        return nil
    end
    if STATE_POST_GAME and GameRulesRef and GameRulesRef.State_Get and GameRulesRef:State_Get() >= STATE_POST_GAME then
        return nil
    end

    -- [2] 英雄可用性：无实体、死亡、暂停则本轮跳过
    local hero = self:GetHero(ID)
    if not hero or hero:IsNull() then
        return self.Config.think_interval
    end
    if not hero:IsAlive() or (GameRulesRef and GameRulesRef.IsGamePaused and GameRulesRef:IsGamePaused()) then
        return self.Config.think_interval
    end

    -- [3] 成长与刀塔池：等级成长、定时技能点与池内学 Skill1（满四槽后仅加点）
    self:HandleLevelGrowth(hero, data)
    self:TryTimerGrantDotaPoolSkill(ID, hero, data)

    -- [4] 索敌：无普攻/仇恨目标时不扫英雄（仅 BASIC+巡逻）；接战后再扫英雄以切换优先目标
    local scan_heroes = botai_unit_has_hostile_attack_or_aggro(hero)
    local hero_target, farm_target = self:FindVisibleEnemyHeroAndFarmTargetsInCombatRadius(hero, data, scan_heroes)

    -- [5] 周期肉搏白名单学习（地面书不拾取）
    self:TryPeriodicAutoMeleeSkillLearn(ID, hero, data)

    -- [6] 队列施法与施法帧：延迟指令、引导/当前技能中则不再下单
    if self:TryExecutePendingCast(hero, data) then
        return self.Config.think_interval
    end
    if hero:IsChanneling() or hero:GetCurrentActiveAbility() then
        return self.Config.think_interval
    end

    -- [7] 刃甲规避延续（上一 tick 已开始的后撤）
    if self:TryContinueBladeMailEvade(hero, data) then
        return self.Config.think_interval
    end

    -- [8] 远程敏捷飓风长戟：用后短窗内只普攻锁目标
    if self:TryAgilityRangedHurricanePikeHoldAttack(hero, data) then
        return self.Config.think_interval
    end

    -- [9] 对仇恨/普攻目标：开 BKB 或开始刃甲后撤（与可见索敌分离，覆盖刚出视野仍锁敌）
    local bm_hostile = self:GetBotHostileAttackOrAggroTarget(hero)
    if bm_hostile and bm_hostile:IsHero() and self:TargetHasActiveBladeMailReflect(bm_hostile) then
        if self:TryBotCastBlackKingBarVsBladeMail(hero, bm_hostile, data) then
            return self.Config.think_interval
        end
    end
    if bm_hostile and bm_hostile:IsHero() and self:TryStartBladeMailEvadeFromTarget(hero, bm_hostile, data) then
        return self.Config.think_interval
    end

    -- [10] 无可见敌英雄但已在接战：深渊/羊/对真人 CC（有 hero_target 时由下段视野内敌英雄逻辑处理，避免同轮重复）
    -- if not hero_target and self:IsFightingEnemyHero(hero) then
    --     local t = hero.GetAggroTarget and hero:GetAggroTarget() or nil
    --     if not t or t:IsNull() or not t:IsAlive() or not t:IsHero() then
    --         t = hero.GetAttackTarget and hero:GetAttackTarget() or nil
    --     end
    --     if t and not t:IsNull() and t:IsAlive() and t:IsHero() and t:GetTeamNumber() ~= hero:GetTeamNumber() then
    --         if self:TryMeleeAgilityAbyssalBladeOnHero(hero, ID, data, t) then
    --             return self.Config.think_interval
    --         end
    --         if self:TryIntBotSheepstickOnEnemyHero(hero, ID, data, t) then
    --             return self.Config.think_interval
    --         end
    --         if self:TryCastPriorityCcItemsOnRealPlayerHero(hero, t, data) then
    --             return self.Config.think_interval
    --         end
    --     end
    -- end

    -- [11] 远程敏捷飓风主动、智力低血刷新血精连招、低血随机道具链
    if self:TryAgilityRangedHurricanePikeOnAttackTarget(hero, ID, data) then
        return self.Config.think_interval
    end
    -- if self:TryIntBotLowHpRefresherBloodstoneThenAbilities(hero, ID, data) then
    --     return self.Config.think_interval
    -- end
    if self:TryUseActiveItemsByHealth(hero, data) then
        return self.Config.think_interval
    end

    -- [12] 视野内敌方英雄：刃甲对策、深渊/羊/CC、主动技能、普攻
    if hero_target then
        local aggro_target = hero.GetAggroTarget and hero:GetAggroTarget() or nil
        local cast_target = aggro_target
        if not cast_target or cast_target:IsNull() or not cast_target:IsAlive() then
            cast_target = hero_target
        end
        if self:TargetHasActiveBladeMailReflect(hero_target) then
            if self:TryBotCastBlackKingBarVsBladeMail(hero, hero_target, data) then
                return self.Config.think_interval
            end
        end
        if self:TryStartBladeMailEvadeFromTarget(hero, hero_target, data) then
            return self.Config.think_interval
        end
        if self:TryMeleeAgilityAbyssalBladeOnHero(hero, ID, data, hero_target) then
            return self.Config.think_interval
        end
        -- if self:TryIntBotSheepstickOnEnemyHero(hero, ID, data, hero_target) then
        --     return self.Config.think_interval
        -- end
        if cast_target and self:TryCastPriorityCcItemsOnRealPlayerHero(hero, cast_target, data) then
            return self.Config.think_interval
        end
        if self:TryCastActiveAbility(hero, hero_target, data) then
            return self.Config.think_interval
        end
        self:IssueAttack(hero, hero_target, data)
        return self.Config.think_interval
    end

    -- [13] 无视野内敌英雄：加点、买血、买装
    if self:TryAutoUpgradeSkills(ID, hero) then
        return self.Config.think_interval
    end
    if self:TryBuyHealthWithGold(ID, hero, data) then
        return self.Config.think_interval
    end
    if self:TryBuyItems(ID, hero, data) then
        return self.Config.think_interval
    end

    -- [14] 打野/兵线：先尝试对当前目标施法再普攻
    if farm_target then
        self:IssueAttack(hero, farm_target, data)
        return self.Config.think_interval
    end

    -- [15] 空闲：巡逻
    self:IssuePatrol(hero, data)
    return self.Config.think_interval
end
