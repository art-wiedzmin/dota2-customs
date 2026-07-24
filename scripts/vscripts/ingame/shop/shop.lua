--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Shop == nil then
    Shop = class({})
    require("ingame.Shop.Config")
    require("ingame.Shop.Set")
    require("ingame.Shop.Get")
    require("ingame.Shop.Ui")
    require("ingame.Shop.CardReward")
    require("ingame.Shop.OutBag")
end

-- 金豆图标：addon 内 resource/flash3/images/shop/b_cost.png（与 Shop 内其它 shop 图相同引用方式）
local REDEEM_GOLD_ICON = "raw://resource/flash3/images/shop/b_cost.png"
local REDEEM_HERO_PICK_ICON = "raw://resource/flash3/images/card/herocard.png"
local REDEEM_PROPHECY_ICON = "raw://resource/flash3/images/achive/yyk.png"

function Shop:GoldRewardRows(count)
    local rows = {}
    local g = tonumber(count) or 0
    if g > 0 then
        rows[#rows + 1] = { img = REDEEM_GOLD_ICON, count = g, unit = "金豆" }
    end
    return rows
end

function Shop:BagItemRewardRows(hero_pick, prophecy_card)
    local rows = {}
    local hp = tonumber(hero_pick) or 0
    if hp > 0 then
        rows[#rows + 1] = {
            img = REDEEM_HERO_PICK_ICON,
            count = hp,
            unit = "英雄自选卡",
        }
    end
    local pc = tonumber(prophecy_card) or 0
    if pc > 0 then
        rows[#rows + 1] = {
            img = REDEEM_PROPHECY_ICON,
            count = pc,
            unit = "预言卡",
        }
    end
    return rows
end

function Shop:PopFreeSuccess(ID, title, data, fallbackGold)
    local gold = fallbackGold
    if data and data.goldAdded ~= nil then
        gold = tonumber(data.goldAdded) or fallbackGold
    end
    Msgs:PopRedeemSuccess(ID, title, self:GoldRewardRows(gold))
end

function Shop:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

--- 进游戏后 / 打开通行证：单独拉当前赛季（只靠 season_id，图本地读）
function Shop:FetchPassSeason(ID)
    if not ID or not self.Data[ID] then
        return
    end
    if self.Data[ID].pass_season_inflight then
        return
    end
    self.Data[ID].pass_season_inflight = true
    local prev_season = nil
    if self.PassCosmetics then
        prev_season = self.PassCosmetics.season_id or self.PassCosmetics.seasonId
    end
    Http:POST("/card/season", {}, ID, function(keys)
        if self.Data[ID] then
            self.Data[ID].pass_season_inflight = false
        end
        if keys.code == 200 and keys.data then
            local cosmetics = keys.data.pass_cosmetics or keys.data
            local next_season = cosmetics.season_id or cosmetics.seasonId
            Shop:ApplyPassCosmetics(ID, cosmetics)
            if self.PushPassSeasonToClient then
                self:PushPassSeasonToClient(ID)
            end
            -- 赛季未变则不整包 SendData，避免通行证页被重建闪一下
            if self.Data[ID] and self.Data[ID].page and tostring(prev_season) ~= tostring(next_season) then
                self:SendData(ID)
            end
        end
    end)
end

--- 从服务端拉取最新 card 表数据（打开通行证等场景；不重复走 /user/login）
function Shop:RefreshCard(ID)
    if not ID or not self.Data[ID] then
        return
    end
    -- 打开通行证时强制再拉一次赛季（登录可能早于面板、或 JWT 刚就绪）
    if self.FetchPassSeason then
        self:FetchPassSeason(ID)
    end
    if self.Data[ID].card_refresh_inflight then
        return
    end
    self.Data[ID].card_refresh_inflight = true
    Http:POST("/card/sync", {}, ID, function(keys)
        if self.Data[ID] then
            self.Data[ID].card_refresh_inflight = false
        end
        if keys.code == 200 and keys.data then
            local cosmetics = keys.data.pass_cosmetics
            if not cosmetics and keys.data.season_id then
                cosmetics = keys.data
            end
            if cosmetics then
                Shop:ApplyPassCosmetics(ID, cosmetics)
            end
            if keys.data.card then
                Shop:SetCardServerData(ID, keys.data.card)
            else
                self:SendData(ID)
            end
            if self.PushPassSeasonToClient then
                self:PushPassSeasonToClient(ID)
            end
        else
            if self.PushPassSeasonToClient then
                self:PushPassSeasonToClient(ID)
            end
        end
    end)
end

function Shop:LoadShop(ID)
    Http:POST("/user/login", {}, ID, function(keys)
        if keys.code == 200 then
            local data = keys.data
            --print(data)
            if data and data.accessToken then
                Http:SetPlayerAccessToken(ID, data.accessToken)
            else
                Http:SetPlayerAccessToken(ID, nil)
            end
            if data.user then
                local fo = data.first_recharge_double_open
                if fo == nil then
                    fo = true
                end
                Shop:SetShopServerData(ID, data.user, fo)
                if data.pass_cosmetics then
                    Shop:ApplyPassCosmetics(ID, data.pass_cosmetics)
                end
                if data.bag then
                    Shop:ApplyLoginBag(ID, data)
                end
                if data.card then
                    Shop:SetCardServerData(ID, data.card)
                else
                    self:SendData(ID)
                end
                if AchieveModule and AchieveModule.ApplyLoginPayload then
                    AchieveModule:ApplyLoginPayload(ID, data)
                end
                if HolidayPack and HolidayPack.LoadGiftPacks then
                    HolidayPack:LoadGiftPacks(ID)
                end
                if not data.bag then
                    self:SyncOutBag(ID)
                end            end
        end
    end)
end

function Shop:Refresh(ID)
    if not ID then
        return
    end
    if self.Data[ID].refresh == false then
        return
    end
    self.Data[ID].refresh = false
    self:LoadShop(ID)
    Timers(3, function()
        self.Data[ID].refresh = true
        self:SendData(ID)
    end)
end

function Shop:Free(ID, num)
    if not ID or not num then
        return
    end
    if num == 1 then
        if self.Data[ID].freeday == 0 then
            return
        end
        --每日领取
        Http:POST("/user/free", { type = 1 }, ID, function(keys)
            --print(keys)
            if keys.code == 200 then
                self:PopFreeSuccess(ID, "每日奖励领取成功", keys.data, 50)
                self:LoadShop(ID)
            else
                Msgs:Pop(ID, "网络异常")
            end
        end)
    end
    if num == 2 then
        if self.Data[ID].card1day == 0 then
            return
        end
        --每日领取
        Http:POST("/user/free", { type = 2 }, ID, function(keys)
            --print(keys)
            if keys.code == 200 then
                self:PopFreeSuccess(ID, "会员每日奖励领取成功", keys.data, 100)
                self:LoadShop(ID)
            else
                Msgs:Pop(ID, "网络异常")
            end
        end)
    end
    if num == 3 then
        if self.Data[ID].card2day == 0 then
            return
        end
        --每日领取
        Http:POST("/user/free", { type = 3 }, ID, function(keys)
            --print(keys)
            if keys.code == 200 then
                self:PopFreeSuccess(ID, "季卡每日奖励领取成功", keys.data, 100)
                self:LoadShop(ID)
            else
                Msgs:Pop(ID, "网络异常")
            end
        end)
    end
end

-- 扣豆后同步金币：2 秒内多次扣豆只打一次 /user/sync/gold（具名 Timer 覆盖 = 尾触发防抖）
local GOLD_SYNC_DEBOUNCE_SEC = 2

function Shop:ScheduleDebouncedGoldSync(ID)
    if not ID or not self.Data[ID] then
        return
    end
    local name = "clrb_shop_goldsyn_" .. tostring(ID)
    Timers:CreateTimer(name, {
        endTime = GOLD_SYNC_DEBOUNCE_SEC,
        callback = function()
            if not Shop.Data[ID] then
                return
            end
            Shop:SyncGold(ID)
        end,
    })
end

--- 兑换成功：展示 userReward 中的金豆 / 自选卡 / 预言卡
function Shop:RedeemRewardRows(data)
    if not data or type(data) ~= "table" then
        return {}
    end
    local ur = data.userReward
    if type(ur) ~= "table" then
        return {}
    end
    local rows = self:GoldRewardRows(ur.gold or ur.diamond)
    local bag_rows = self:BagItemRewardRows(ur.hero_pick, ur.prophecy_card)
    for i = 1, #bag_rows do
        rows[#rows + 1] = bag_rows[i]
    end
    return rows
end

function Shop:Code(ID, text)
    if not ID or not text then
        return
    end
    Http:POST("/redemption/redeem", { code = text }, ID, function(keys)
        -- print(keys)
        if keys.code == 200 then
            local data = keys.data
            if data and data.userReward and data.userReward.bag and Shop.SetBagServerData then
                Shop:SetBagServerData(ID, data.userReward.bag)
                if Shop.SendOutBagData then
                    Shop:SendOutBagData(ID)
                end
            end
            self:LoadShop(ID)
            Msgs:PopRedeemSuccess(ID, "兑换成功", self:RedeemRewardRows(data))
        else
            Msgs:PopRedeemFail(ID, "兑换失败")
        end
    end)
end

function Shop:CostGold(ID, num)
    if not ID or not num then
        return
    end
    local gold = self.Data[ID].gold
    if gold < num then
        return Util:BottomMsg2ID(ID, "金币不足", "yellow", 1)
    end
    if num == 0 then
        return true
    end
    if gold < 0 then
        return Util:BottomMsg2ID(ID, "金币不足", "yellow", 1)
    end
    self.Data[ID].cost = self.Data[ID].cost + num
    self.Data[ID].gold = self.Data[ID].gold - num
    self:ScheduleDebouncedGoldSync(ID)
    -- self:SendData(ID)
    return true
end

function Shop:SyncGold(ID)
    Http:POST("/user/sync/gold", { gold = self.Data[ID].gold }, ID, function(keys)
        --print(keys)
        if keys.code == 200 then
            local data = keys.data
            --print(data)
            self.Data[ID].gold = data.gold
            -- self:SendData(ID)
        end
    end)
end
