--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 成就系统配置（与服务端 achieveConfig.js / achieve 表字段一致）

Achieve = Achieve or {}

Achieve.Status = {
    CLAIMABLE = 1,   -- 已完成可领取
    INCOMPLETE = 2,  -- 未完成
    CLAIMED = 3,     -- 已领取
}

Achieve.HeroRewardGold = 50

Achieve.PayTierAmounts = { 30, 98, 198, 328, 648, 1280, 3280 }

-- 累计充值档位奖励（与服务端 PAY_TIER_REWARDS 一致）
Achieve.PayTierRewards = {
    [30] = { gold = 100, hero_pick = 1 },
    [98] = { gold = 300, hero_pick = 2 },
    [198] = { gold = 600, hero_pick = 3 },
    [328] = { gold = 1000, hero_pick = 5 },
    [648] = { gold = 2000, hero_pick = 5, pet = "pet_ti10_rosh" },
    [1280] = { gold = 4000, hero_pick = 10, prophecy_card = 2 },
    [3280] = { gold = 10000, hero_pick = 15, title = "title_whcl" },
}

-- 日常成就索引名（与服务端 DAY_ACHIEVE_INDEX_NAMES 一致）
Achieve.DayIndexNames = {
    "games_hero_pick_repeat",
    "time_prophecy_repeat",
    "team_first_3",
    "title_shen_3",
    "title_bao_3",
    "title_ying_3",
    "title_famu_3",
    "title_li_3",
    "title_min_3",
    "title_zhi_3",
    "title_hang_3",
    "title_kuang_3",
    "title_wushuang_1",
    "dmg_suicide_5m",
    "dmg_lightning_5m",
    "dmg_crush_5m",
    "bash_enemy_500",
    "dmg_flame_5m",
    "plunder_gold_200k",
    "kill_neutral_5000",
    "kill_hero_500",
}

-- 成就条目模板（运行时由玩家进度填充 current / status）
AchieveModule.Template = {
    page = 0,
    tab = "hero",
    enabled = false,
    achieve = nil,
    recharge_total = 0,
    claim_inflight = false,
    claim_queue = {},
    claim_cooldown_until = 0,
}

--- 服务端 status 1/2/3 -> UI locked / claimable / claimed
function Achieve:StatusToUi(status)
    local n = tonumber(status)
    if n == self.Status.CLAIMABLE then
        return "claimable"
    end
    if n == self.Status.CLAIMED then
        return "claimed"
    end
    return "locked"
end

--- 英雄成就进度：完成 1/1，未完成 0/1
function Achieve:HeroProgressFromStatus(status)
    local n = tonumber(status)
    if n == self.Status.CLAIMABLE or n == self.Status.CLAIMED then
        return 1, 1
    end
    return 0, 1
end

--- 日常成就进度：current 来自 daystat[statKey]，target 为档位目标
function Achieve:DayProgressFromStat(daystat, statKey, target, status)
    local tar = math.max(0, tonumber(target) or 0)
    local cur = 0
    if daystat and statKey then
        cur = math.max(0, math.floor(tonumber(daystat[statKey]) or 0))
    end
    local n = tonumber(status)
    if n == self.Status.CLAIMED then
        return tar, tar
    end
    if n == self.Status.CLAIMABLE and cur < tar then
        cur = tar
    end
    return cur, tar
end

--- 累计充值进度：current 为玩家累计充值总额，target 为档位金额
function Achieve:PayProgressFromStatus(status, rechargeTotal, tierAmount)
    local target = tonumber(tierAmount) or 0
    local total = math.max(0, tonumber(rechargeTotal) or 0)
    return total, target
end
