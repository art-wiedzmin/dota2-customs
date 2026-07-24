--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


HolidayPack.Data = {}
HolidayPack.Template = {
    page = false,
    dw_free_day = 1,
    dw_free_open = false,
    dw_free_event_status = "ended",
    dw_30_buy = 0,
    dw_68_buy = 0,
    dw_128_buy = 0,
    -- 服务端动态礼包（开局拉取）
    gift_packs = {},
    gift_buy_counts = {},
    gift_free_claimed = {},
}

HolidayPack.BUY_LIMIT = 3

HolidayPack.PayGoods = {
    dw_30 = 11,
    dw_68 = 12,
    dw_128 = 13,
}

-- 与服务端 HolidayPackService.HOLIDAY_PACK_REWARDS 一致
HolidayPack.Rewards = {
    dw_free = { gold = 200, hero_pick = 1, prophecy_card = 1 },
    HOLIDAY_DW_30 = { gold = 900, hero_pick = 1, prophecy_card = 1 },
    HOLIDAY_DW_68 = { gold = 2040, hero_pick = 2, prophecy_card = 2 },
    HOLIDAY_DW_128 = { gold = 3840, hero_pick = 4, prophecy_card = 4 },
}

local HOLIDAY_GOLD_ICON = "raw://resource/flash3/images/shop/b_cost.png"
local HOLIDAY_HERO_PICK_ICON = "raw://resource/flash3/images/card/herocard.png"
local HOLIDAY_PROPHECY_ICON = "raw://resource/flash3/images/achive/yyk.png"

function HolidayPack:BuildRedeemRows(packKey)
    return self:BuildRedeemRowsFromRewards(self.Rewards[packKey])
end

function HolidayPack:FindGiftPackByProductType(ID, product_type)
    if not ID or not product_type or not self.Data[ID] then
        return nil
    end
    local packs = self.Data[ID].gift_packs
    if type(packs) ~= "table" then
        return nil
    end
    for _, pack in pairs(packs) do
        if pack and tostring(pack.product_type) == tostring(product_type) then
            return pack
        end
    end
    return nil
end

function HolidayPack:FindGiftPackByKey(ID, pack_key)
    if not ID or not pack_key or not self.Data[ID] then
        return nil
    end
    local packs = self.Data[ID].gift_packs
    if type(packs) ~= "table" then
        return nil
    end
    for _, pack in pairs(packs) do
        if pack and tostring(pack.pack_key) == tostring(pack_key) then
            return pack
        end
    end
    return nil
end

function HolidayPack:BuildRedeemRowsForGift(ID, product_type)
    local pack = self:FindGiftPackByProductType(ID, product_type)
    if not pack then
        return {}
    end
    return self:BuildRedeemRowsFromRewards({
        gold = pack.gold,
        hero_pick = pack.hero_pick,
        prophecy_card = pack.prophecy_card,
    })
end

function HolidayPack:BuildRedeemRowsFromRewards(rewards)
    local rows = {}
    if not rewards then
        return rows
    end
    local gold = tonumber(rewards.gold) or 0
    if gold > 0 then
        rows[#rows + 1] = { img = HOLIDAY_GOLD_ICON, count = gold, unit = "金豆" }
    end
    local hero_pick = tonumber(rewards.hero_pick) or 0
    if hero_pick > 0 then
        rows[#rows + 1] = {
            img = HOLIDAY_HERO_PICK_ICON,
            count = hero_pick,
            unit = "英雄自选卡",
        }
    end
    local prophecy = tonumber(rewards.prophecy_card) or 0
    if prophecy > 0 then
        rows[#rows + 1] = {
            img = HOLIDAY_PROPHECY_ICON,
            count = prophecy,
            unit = "预言卡",
        }
    end
    return rows
end

function HolidayPack:IsDwFreeOpen(ID)
    -- 已取消活动时间窗：始终视为开放（每日次数仍由 dw_free_day 控制）
    return true
end

function HolidayPack:GetGiftBuyCount(ID, pack_key)
    if not ID or not pack_key or not self.Data[ID] then
        return 0
    end
    local counts = self.Data[ID].gift_buy_counts
    if type(counts) ~= "table" then
        return 0
    end
    return tonumber(counts[tostring(pack_key)]) or 0
end

function HolidayPack:CanBuyGift(ID, pack)
    if not pack then
        return false
    end
    local limited = pack.is_limited == true or pack.is_limited == 1
    if not limited then
        return true
    end
    local limit = tonumber(pack.limit_count) or 0
    if limit <= 0 then
        return true
    end
    return self:GetGiftBuyCount(ID, pack.pack_key) < limit
end
