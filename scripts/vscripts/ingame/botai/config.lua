--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--[[人机难度配置（原 Config_easy / Config_hard / Config_insane 合并于此，勿再 require 分文件）。
    选取：`Boot.Config.bot_difficulty`，1=简单，2=困难，3=令人发狂；0 或未选时按困难档路径加载。
    运行时：`BotAI:ApplyConfigPreset()` 深拷贝某一档后，再写入一批「全难度共用默认值」（缩圈比例、复活相位、modifier 用数值等，见文件底部）。
]]

---------------------------------------------------------------------------
-- 公用表（按 tp1=力量 tp2=敏捷 tp3=智力，与 Boot.BootType 一致）
---------------------------------------------------------------------------

-- 人机定时学习的刀塔技能 ID 池（整局一套，按主属性分型；满 4 槽后不再从池学，仍定时加技能点）
local BOTAI_SHARED_DOTA_SKILL_IDS_BY_TP = {
    tp1 = { 2, 9, 17, 21, 22, 23, 29, 34, 35, 36, 37, 38, 39, 46, 47, 55, 61, 73, 77, 81, 83, 93, 98, 103, 105, 116, 145, 151, 152, 163, 164, 182, 194, 198, 199, 200, 207, 286, 313, 332 },
    tp2 = { 1, 2, 3, 4, 8, 11, 20, 24, 29, 33, 35, 37, 38, 39, 46, 47, 57, 61, 69, 95, 98, 103, 113, 116, 126, 145, 182, 193, 194, 198, 199, 200, 209, 214, 231, 251, 257, 267, 326, 332, },
    tp3 = { 2, 5, 7, 8, 19, 26, 28, 37, 39, 46, 47, 52, 69, 71, 78, 104, 105, 110, 120, 142, 162, 182, 183, 186, 194, 199, 202, 206, 207, 209, 214, 220, 226, 229, 246, 255, 257, 259, 267, 277, 281, 296, 299, 318, 327 },
}


-- 肉搏书全局黑名单；白名单由 `SelectHero:GetMeleeLearnWhitelistForHeroIndex`（BattleType + RMBList）生成
local BOTAI_SHARED_MELEE_BLOCKLIST = {
    ["item_skill_32"] = true,
    ["item_skill_28"] = true,
}

-- 购装随机池（买齐必买表后才会抽这里）
local BOTAI_SHARED_ITEM_BUY_POOL_BY_TP = {
    tp1 = {
        "item_heart",
        "item_assault",
        "item_shivas_guard",
        "item_abyssal_blade",
        "item_satanic",
    },
    tp2 = {
        "item_sphere",
        "item_butterfly",
        "item_monkey_king_bar",
        "item_greater_crit",
        "item_hydras_breath",
        "item_skadi",
        "item_silver_edge",
    },
    tp3 = {
        "item_sphere",
        "item_shivas_guard",
        "item_yasha_and_kaya",
        "item_ethereal_blade",
        "item_gungir",
        "item_devastator",
    },
}

-- 必买顺序（未买齐前不抽随机池）；远程敏、近战敏等特例插入见 Func.GetBotMandatoryItemBuyList
local BOTAI_SHARED_ITEM_BUY_REQUIRED_BY_TP = {
    tp1 = { "item_blade_mail", "item_black_king_bar", "item_sphere", },
    tp2 = { "item_satanic", "item_black_king_bar", "item_nullifier", },
    tp3 = { "item_sheepstick", "item_refresher", "item_bloodstone", },
}

---------------------------------------------------------------------------
-- 分档预设（仅下列字段因难度变化；其余逻辑依赖 ApplyConfigPreset 默认值）
---------------------------------------------------------------------------

local BOTAI_PRESET_EASY = {
    think_interval = 1,                                                    -- Think 主循环间隔（秒），略放宽以减卡顿
    patrol_reach_distance = 260,                                           -- 距巡逻点多近视为「到达」
    blade_mail_evade_duration = 2,                                         -- 对开刃甲敌人后撤状态持续（秒）
    blade_mail_evade_distance = 680,                                       -- 刃甲后撤目标点距离
    cast_delay_min = 0.35,                                                 -- 自动施法前随机等待下限（秒）
    cast_delay_max = 0.95,                                                 -- 自动施法前随机等待上限（秒）
    level_growth_all_attributes = 1,                                       -- 每升一级额外力量/敏捷/智力（各 +N）
    level_growth_bonus_hp = 1,                                             -- 每升一级额外生命
    level_growth_bonus_movespeed = 1,                                      -- 每升一级额外移速
    level_growth_ability_points = 3,                                       -- 每升一级额外技能点
    death_growth_all_attributes = 1,                                       -- 每次死亡三维各 +N
    neutral_kill_gold = 1,                                                 -- 人机击杀非英雄额外金钱（entity_killed）
    neutral_kill_experience = 1,                                           -- 人机击杀非英雄额外经验
    item_use_hp_dump_all_below_pct = 0.32,                                 -- 生命比例低于此：TryUseActiveItemsByHealth 错峰交齐主动道具
    item_use_hp_random_50_below_pct = 0.5,                                 -- 与 dump、random_30 分档：低于此用 random_chance_at_60 作随机交一件的概率上界
    item_use_hp_random_30_below_pct = 0.72,                                -- 生命比例 ≥ 此值则不进入低血道具逻辑；低于后才可能随机/全交
    item_use_random_chance_at_60 = 0.38,                                   -- 血线在 [dump, random_50) 时随机交一件的概率上限
    item_use_random_chance_at_80 = 0.22,                                   -- 血线在 [random_50, random_30) 时随机交一件的概率上限
    item_use_dump_all_stagger = 0.5,                                       -- 全交道具时每件间隔（秒）
    item_buy_min_gold = 10000,                                             -- 金币达到此值才开始尝试购物（简单档偏高，出装慢）
    item_buy_pool_by_hero_type = BOTAI_SHARED_ITEM_BUY_POOL_BY_TP,         -- 必买齐后的随机装备池（按 tp）
    item_buy_required_by_hero_type = BOTAI_SHARED_ITEM_BUY_REQUIRED_BY_TP, -- 必买顺序（按 tp）
    melee_skill_learn_blocklist = BOTAI_SHARED_MELEE_BLOCKLIST,            -- 肉搏书黑名单
    dota_skill_pool_grant_interval = 60,                                   -- 每 N 秒：技能点 + 从池学 1 个刀塔 Skill1（未满 4 槽时）
    dota_skill_pool_by_hero_type = BOTAI_SHARED_DOTA_SKILL_IDS_BY_TP,      -- 刀塔技能 ID 池（按 tp）
}

local BOTAI_PRESET_HARD = {
    think_interval = 0.82,                                                 -- Think 主循环间隔（秒）
    patrol_reach_distance = 220,                                           -- 巡逻到达判定距离
    blade_mail_evade_duration = 2,                                         -- 刃甲后撤持续（秒）
    blade_mail_evade_distance = 680,                                       -- 刃甲后撤距离
    cast_delay_min = 0.2,                                                  -- 施法前随机等待下限（秒）
    cast_delay_max = 0.7,                                                  -- 施法前随机等待上限（秒）
    level_growth_all_attributes = 6,                                       -- 每级额外三维
    level_growth_bonus_hp = 300,                                           -- 每级额外生命
    level_growth_bonus_movespeed = 5,                                      -- 每级额外移速
    level_growth_ability_points = 5,                                       -- 每级额外技能点
    death_growth_all_attributes = 6,                                       -- 每次死亡三维各 +N
    neutral_kill_gold = 20,                                                -- 非英雄击杀额外金
    neutral_kill_experience = 0,                                           -- 非英雄击杀额外经验
    item_use_hp_dump_all_below_pct = 0.4,                                  -- 低于此全交主动道具（TryUseActiveItemsByHealth）
    item_use_hp_random_50_below_pct = 0.6,                                 -- 分档：低于此用 random_chance_at_60，否则 at_80
    item_use_hp_random_30_below_pct = 0.8,                                 -- 生命比例 ≥ 此值则不进入低血道具逻辑
    item_use_random_chance_at_60 = 0.5,                                    -- 血线在 [dump, random_50) 时随机交一件概率上限
    item_use_random_chance_at_80 = 0.3,                                    -- 血线在 [random_50, random_30) 时随机交一件概率上限
    item_use_dump_all_stagger = 0.08,                                      -- 全交错峰间隔（秒）
    item_buy_min_gold = 6000,                                              -- 开始购物金钱下限
    item_buy_pool_by_hero_type = BOTAI_SHARED_ITEM_BUY_POOL_BY_TP,         -- 必买齐后的随机装备池（按 tp）
    item_buy_required_by_hero_type = BOTAI_SHARED_ITEM_BUY_REQUIRED_BY_TP, -- 必买顺序（按 tp）
    melee_skill_learn_blocklist = BOTAI_SHARED_MELEE_BLOCKLIST,            -- 肉搏书黑名单
    dota_skill_pool_grant_interval = 60,                                   -- 每 N 秒：技能点 + 池内学刀塔技能
    dota_skill_pool_by_hero_type = BOTAI_SHARED_DOTA_SKILL_IDS_BY_TP,      -- 刀塔技能 ID 池（按 tp）
}

local BOTAI_PRESET_INSANE = {
    think_interval = 0.72,                                                 -- Think 主循环间隔（秒）
    patrol_reach_distance = 190,                                           -- 巡逻到达判定距离
    blade_mail_evade_duration = 2,                                         -- 刃甲后撤持续（秒）
    blade_mail_evade_distance = 680,                                       -- 刃甲后撤距离
    cast_delay_min = 0.12,                                                 -- 施法前随机等待下限（秒）
    cast_delay_max = 0.42,                                                 -- 施法前随机等待上限（秒）
    level_growth_all_attributes = 20,                                      -- 每级额外三维
    level_growth_bonus_hp = 800,                                           -- 每级额外生命
    level_growth_bonus_movespeed = 6,                                      -- 每级额外移速
    level_growth_ability_points = 5,                                       -- 每级额外技能点
    death_growth_all_attributes = 15,                                      -- 每次死亡三维各 +N
    neutral_kill_gold = 28,                                                -- 非英雄击杀额外金
    neutral_kill_experience = 20,                                          -- 非英雄击杀额外经验
    item_use_hp_dump_all_below_pct = 0.48,                                 -- 低于此全交主动道具
    item_use_hp_random_50_below_pct = 0.68,                                -- 分档阈值（同简单/困难，见上）
    item_use_hp_random_30_below_pct = 0.88,                                -- 高于等于此不触发低血道具链
    item_use_random_chance_at_60 = 0.62,                                   -- 血线在 [dump, random_50) 时随机交一件概率上限
    item_use_random_chance_at_80 = 0.42,                                   -- 血线在 [random_50, random_30) 时随机交一件概率上限
    item_use_dump_all_stagger = 0.05,                                      -- 全交错峰间隔（秒）
    item_buy_min_gold = 4200,                                              -- 开始购物金钱下限（最低，出装最快）
    item_buy_pool_by_hero_type = BOTAI_SHARED_ITEM_BUY_POOL_BY_TP,         -- 必买齐后的随机装备池（按 tp）
    item_buy_required_by_hero_type = BOTAI_SHARED_ITEM_BUY_REQUIRED_BY_TP, -- 必买顺序（按 tp）
    melee_skill_learn_blocklist = BOTAI_SHARED_MELEE_BLOCKLIST,            -- 肉搏书黑名单
    dota_skill_pool_grant_interval = 60,                                   -- 每 N 秒：技能点 + 池内学刀塔技能
    dota_skill_pool_by_hero_type = BOTAI_SHARED_DOTA_SKILL_IDS_BY_TP,      -- 刀塔技能 ID 池（按 tp）
}

local BOTAI_PRESET_BY_PATH = {
    ["ingame.BotAI.Config_easy"] = BOTAI_PRESET_EASY,
    ["ingame.BotAI.Config_hard"] = BOTAI_PRESET_HARD,
    ["ingame.BotAI.Config_insane"] = BOTAI_PRESET_INSANE,
}

--[[ 可选：DeepCopy 后挂到 self.Config 覆盖默认行为（勿与 item_buy_*_by_hero_type 混用全局表）
    melee_skill_learn_whitelist、melee_skill_learn_whitelist_by_type
    item_buy_pool、item_buy_required（会覆盖按 tp 分表）
    dota_skill_book_pool（真人技能书 Roll 兜底 ID）
]]

function BotAI:ApplyConfigPreset()
    local d = 0
    if Boot and Boot.Config and Boot.Config.bot_difficulty ~= nil then
        d = tonumber(Boot.Config.bot_difficulty) or 0
    end
    local path = "ingame.BotAI.Config_hard"
    if d == 1 then
        path = "ingame.BotAI.Config_easy"
    elseif d == 3 then
        path = "ingame.BotAI.Config_insane"
    end

    local fallback_paths = { path }
    if path ~= "ingame.BotAI.Config_hard" then
        table.insert(fallback_paths, "ingame.BotAI.Config_hard")
    end
    if path ~= "ingame.BotAI.Config_easy" then
        table.insert(fallback_paths, "ingame.BotAI.Config_easy")
    end
    if path ~= "ingame.BotAI.Config_insane" then
        table.insert(fallback_paths, "ingame.BotAI.Config_insane")
    end

    local cfg, loaded_from = nil, nil
    for _, try_path in ipairs(fallback_paths) do
        cfg = BOTAI_PRESET_BY_PATH[try_path]
        if cfg then
            loaded_from = try_path
            break
        end
    end
    if not cfg then
        cfg = BOTAI_PRESET_HARD
        loaded_from = "ingame.BotAI.Config_hard"
    end
    if loaded_from ~= path then
        -- print("[BotAI] 配置 " .. tostring(path) .. " 未找到，已回退为 " .. tostring(loaded_from))
    end
    self.Config = Util:DeepCopyTab(cfg)

    --[[全难度共用（键可写进某一档预设覆盖；此处为默认）：
        poison_ring_offattr_to_primary_transfer_ratio力主：敏捷→力量比例（ApplyIntelRedistributeAfterPoisonRing）
        poison_ring_all_hero_intel_to_str_agi_ratio    敏/全才主：智力→力量比例
        bot_innate_mana_regen_per_second               modifier_bot_innate_mana_regen 固定回蓝/秒
        bot_hero_level_cap                             人机等级上限（HeroData / 经验）
        bot_base_attack_bonus_per_level                modifier_bot_innate_level_base_attack 每级基础攻击
        bot_post_ring_bonus_*                          首次缩圈后人机额外三维/攻击/生命（MapChange1 后）
        int_bot_refresher_combo_hp_threshold           智力人机低血刷新+血精+技能（生命比例）
        agi_ranged_hurricane_pike_*                    远程敏飓风：施放血线、用后仅普攻秒数
        bot_respawn_phased_seconds                     人机复活相位持续时间（HeroData）
        bot_blade_mail_after_damage_window             受敌方英雄伤后允许开刃甲的秒数窗口
    ]]
    self.Config.poison_ring_offattr_to_primary_transfer_ratio = tonumber(self.Config
        .poison_ring_offattr_to_primary_transfer_ratio) or 0.75
    self.Config.poison_ring_all_hero_intel_to_str_agi_ratio = tonumber(self.Config
        .poison_ring_all_hero_intel_to_str_agi_ratio) or 0.8
    self.Config.bot_innate_mana_regen_per_second = tonumber(self.Config.bot_innate_mana_regen_per_second) or 50
    self.Config.bot_hero_level_cap = tonumber(self.Config.bot_hero_level_cap) or 45
    self.Config.bot_base_attack_bonus_per_level = tonumber(self.Config.bot_base_attack_bonus_per_level) or 30
    self.Config.bot_post_ring_bonus_all_attributes = tonumber(self.Config.bot_post_ring_bonus_all_attributes) or 100
    self.Config.bot_post_ring_bonus_attack = tonumber(self.Config.bot_post_ring_bonus_attack) or 1000
    self.Config.bot_post_ring_bonus_health = tonumber(self.Config.bot_post_ring_bonus_health) or 3000
    self.Config.int_bot_refresher_combo_hp_threshold = tonumber(self.Config.int_bot_refresher_combo_hp_threshold) or 0.5
    self.Config.agi_ranged_hurricane_pike_hp_threshold = tonumber(self.Config.agi_ranged_hurricane_pike_hp_threshold) or
        0.5
    self.Config.agi_ranged_hurricane_pike_stand_seconds = tonumber(self.Config.agi_ranged_hurricane_pike_stand_seconds) or
        1.5
    self.Config.bot_respawn_phased_seconds = tonumber(self.Config.bot_respawn_phased_seconds) or 3
    self.Config.bot_blade_mail_after_damage_window = tonumber(self.Config.bot_blade_mail_after_damage_window) or 6

    -- 人机局：在预设基础上再拉长 Think，降低多 Bot 同帧叠 FindUnits 的概率（Boot 初始化 /改难度时会再跑一次）
    local bc = Boot and Boot.Config
    if bc and (bc.enable_bot_players == true or (tonumber(bc.bot_difficulty) or 0) > 0) then
        local ti = tonumber(self.Config.think_interval) or 0.8
        ti = ti + 0.1
        if ti > 1.18 then
            ti = 1.18
        end
        self.Config.think_interval = ti
    end
end

BotAI:ApplyConfigPreset()
