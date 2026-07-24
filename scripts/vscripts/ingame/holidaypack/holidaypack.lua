--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if HolidayPack == nil then
    HolidayPack = class({})
    require("ingame.HolidayPack.Config")
    require("ingame.HolidayPack.Set")
    require("ingame.HolidayPack.Ui")
end

function HolidayPack:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    self:LoadGiftPacks(ID)
end

function HolidayPack:Free(ID)
    if not ID then
        return
    end
    -- 与端午免费礼包同一条链路：/user/free type=4
    -- 已取消活动时间窗；仅按 dw_free_day 每日 1 次
    if tonumber(self.Data[ID].dw_free_day) ~= 1 then
        Msgs:Pop(ID, "今日已领取节日礼包")
        return
    end
    Http:POST("/user/free", { type = 4 }, ID, function(keys)
        if keys.code == 200 and keys.data and keys.data.canClaim ~= false then
            local rows = {}
            if Shop and Shop.CardRedeemRowsFromServer and keys.data.redeem_rows then
                rows = Shop:CardRedeemRowsFromServer(keys.data.redeem_rows)
            elseif self.BuildRedeemRows then
                rows = self:BuildRedeemRows("dw_free")
            end
            Msgs:PopRedeemSuccess(ID, "节日礼包领取成功", rows)
            -- 本地标记今日已领，刷新 UI
            if self.Data[ID] then
                self.Data[ID].dw_free_day = 0
            end
            if Shop and Shop.Data and Shop.Data[ID] then
                Shop.Data[ID].dw_free_day = 0
            end
            if Shop and Shop.LoadShop then
                Shop:LoadShop(ID)
            end
            self:SendData(ID)
        elseif keys.code == 200 then
            local msg = "今日已领取节日礼包"
            if keys.data and keys.data.message and keys.data.message ~= "" then
                msg = keys.data.message
            elseif keys.data and keys.data.reason == "event_closed" then
                msg = "节日免费礼包活动已结束"
            elseif keys.data and keys.data.reason == "event_not_started" then
                msg = "节日免费礼包活动未开始"
            end
            Msgs:Pop(ID, msg)
            if self.Data[ID] then
                self.Data[ID].dw_free_day = 0
            end
            self:SendData(ID)
            if Shop and Shop.LoadShop then
                Shop:LoadShop(ID)
            end
        else
            local msg = nil
            if keys and keys.data and keys.data.message then
                msg = keys.data.message
            elseif keys and keys.message and keys.message ~= "" then
                msg = keys.message
            end
            Msgs:Pop(ID, msg or "网络异常")
        end
    end)
end

function HolidayPack:GetBuyCount(ID, key)
    if not ID or not self.Data[ID] or not key then
        return 0
    end
    return tonumber(self.Data[ID][key]) or 0
end

function HolidayPack:CanBuy(ID, key)
    return self:GetBuyCount(ID, key) < self.BUY_LIMIT
end

function HolidayPack:Pay(ID, goods_num)
    if not ID or not goods_num then
        return
    end
    local num = tonumber(goods_num)
    if num == 11 then
        if not self:CanBuy(ID, "dw_30_buy") then
            Msgs:Pop(ID, "该礼包已达购买上限")
            return
        end
    elseif num == 12 then
        if not self:CanBuy(ID, "dw_68_buy") then
            Msgs:Pop(ID, "该礼包已达购买上限")
            return
        end
    elseif num == 13 then
        if not self:CanBuy(ID, "dw_128_buy") then
            Msgs:Pop(ID, "该礼包已达购买上限")
            return
        end
    else
        return
    end
    if not Code or not Code.SetGoods or not Code.Pay then
        return
    end
    Code:SetGoods(ID, num)
    Code:Pay(ID, 1)
end

-- 动态礼包：按 pack_key 点击
function HolidayPack:ParseFreeFlag(p)
    if not p then
        return false
    end
    local f = p.is_free
    if f == true or f == 1 or f == "1" or f == "true" then
        return true
    end
    if tonumber(f) == 1 then
        return true
    end
    -- 布尔 true 在部分序列化下 tonumber 为 nil，上面已覆盖；再兜底字符串
    if tostring(f) == "true" then
        return true
    end
    if (tonumber(p.price_yuan) or -1) == 0 then
        return true
    end
    local pt = string.upper(tostring(p.product_type or ""))
    if string.sub(pt, 1, 5) == "FREE_" then
        return true
    end
    if string.find(string.lower(pt), "free", 1, true) then
        return true
    end
    local key = string.lower(tostring(p.pack_key or ""))
    if string.find(key, "free", 1, true) then
        return true
    end
    local img = string.lower(tostring(p.image_key or ""))
    if string.find(img, "free", 1, true) then
        return true
    end
    local name = tostring(p.name or "")
    if string.find(name, "免费", 1, true) then
        return true
    end
    return false
end

function HolidayPack:IsPackFree(pack)
    return self:ParseFreeFlag(pack)
end

-- 点击礼包：免费走端午 Free（/user/free）；付费才支付。
function HolidayPack:PayGift(ID, pack_key)
    if not ID or not pack_key then
        return
    end
    pack_key = tostring(pack_key)
    local pack = self:FindGiftPackByKey(ID, pack_key)
    if not pack then
        Msgs:Pop(ID, "礼包不存在或已下架")
        return
    end
    if self:IsPackFree(pack) then
        self:Free(ID)
        return
    end
    self:PayGiftPaidOnly(ID, pack_key, pack)
end

function HolidayPack:PayGiftPaidOnly(ID, pack_key, pack)
    if not pack then
        pack = self:FindGiftPackByKey(ID, pack_key)
    end
    if not pack then
        Msgs:Pop(ID, "礼包不存在或已下架")
        return
    end
    if self:IsPackFree(pack) then
        self:Free(ID)
        return
    end
    local product_type = tostring(pack.product_type or "")
    if product_type == "" then
        return
    end
    if string.sub(string.upper(product_type), 1, 5) == "FREE_" then
        self:Free(ID)
        return
    end
    if (tonumber(pack.price_yuan) or 0) <= 0 then
        self:Free(ID)
        return
    end
    if not self:CanBuyGift(ID, pack) then
        Msgs:Pop(ID, "该礼包已达购买上限")
        return
    end
    if not Code or not Code.SetProductType or not Code.Pay then
        return
    end
    Code:SetProductType(ID, product_type, pack.price_yuan, pack.pack_key)
    Code:Pay(ID, 1)
end

-- 开局 / 购买后：从服务端拉取动态礼包目录 + 购买次数
function HolidayPack:LoadGiftPacks(ID)
    if not ID or not self.Data[ID] then
        return
    end
    Http:POST("/giftPack/list", {}, ID, function(keys)
        if not self.Data[ID] then
            return
        end
        if keys and keys.code == 200 and keys.data then
            local packs = keys.data.packs or {}
            local buy_counts = keys.data.buy_counts or {}
            local list = {}
            if type(packs) == "table" then
                for _, p in pairs(packs) do
                    if p and p.pack_key and p.product_type then
                        list[#list + 1] = {
                            pack_key = tostring(p.pack_key),
                            product_type = tostring(p.product_type),
                            name = tostring(p.name or ""),
                            price_yuan = tonumber(p.price_yuan) or 0,
                            is_free = self:ParseFreeFlag(p) and 1 or 0,
                            is_limited = (p.is_limited == true or p.is_limited == 1 or p.is_limited == "1") and 1 or 0,
                            limit_count = tonumber(p.limit_count) or 0,
                            image_key = tostring(p.image_key or ""),
                            gold = tonumber(p.gold) or 0,
                            hero_pick = tonumber(p.hero_pick) or 0,
                            prophecy_card = tonumber(p.prophecy_card) or 0,
                            sort_order = tonumber(p.sort_order) or 0,
                        }
                    end
                end
                table.sort(list, function(a, b)
                    if a.sort_order == b.sort_order then
                        return tostring(a.pack_key) < tostring(b.pack_key)
                    end
                    return a.sort_order < b.sort_order
                end)
            end
            local counts = {}
            if type(buy_counts) == "table" then
                for k, v in pairs(buy_counts) do
                    counts[tostring(k)] = tonumber(v) or 0
                end
            end
            local free_claimed = {}
            local free_map = keys.data.free_claimed_today or {}
            if type(free_map) == "table" then
                for k, v in pairs(free_map) do
                    free_claimed[tostring(k)] = (v == true or v == 1 or v == "1") and 1 or 0
                end
            end
            self.Data[ID].gift_packs = list
            self.Data[ID].gift_buy_counts = counts
            self.Data[ID].gift_free_claimed = free_claimed
            -- 拉取成功后刷新 UI（打开页或已缓存打开状态）
            self:SendData(ID)
        end
    end)
end

-- 动态免费礼包：直接复用端午 Free（/user/free type=4），不走支付、不走 /giftPack/claim
function HolidayPack:ClaimFreeGift(ID, pack_key)
    self:Free(ID)
end
