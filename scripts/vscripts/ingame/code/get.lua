--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Code:GetGoods(ID)
    return self.Data[ID].goods
end

function Code:GetPayTp(ID)
    return self.Data[ID].pay_type
end

--- 充值成功弹窗：与兑换码 Msgs:PopRedeemSuccess 一致（可有图或无图纯文字）
function Code:PayRewardRows(ID)
    local rows = {}
    if not ID or not self.Data[ID] then
        return rows
    end
    local goods = self:GetGoods(ID)
    local goosd_name = self.Data[ID].goods_name
    local gold_icon = Code.PAY_REWARD_GOLD_ICON

    -- 月卡/季卡附赠金豆固定 300/900（与 gameRechargeDelivery 一致，不参与金豆档首充 ×3）
    if goosd_name == "card1" or goods == "MONTH_CARD" then
        rows[#rows + 1] = { count = 1, unit = "勇士月卡" }
        rows[#rows + 1] = { img = gold_icon, count = Code.MONTH_CARD_GOLD_BONUS or 300, unit = "金豆" }
    elseif goosd_name == "card2" or goods == "CARD2" then
        rows[#rows + 1] = { count = 1, unit = "荣耀季卡" }
        rows[#rows + 1] = { img = gold_icon, count = Code.CARD2_GOLD_BONUS or 900, unit = "金豆" }
    elseif goosd_name == "card3" then
        local bonus = 5000
        if Shop and Shop.CardStaticData and Shop.CardStaticData.purchase_xp_bonus then
            bonus = Shop.CardStaticData.purchase_xp_bonus
        end
        rows[#rows + 1] = {
            img = Code.PAY_REWARD_CARD_PREMIUM_ICON,
            count = 1,
            unit = "进阶战令已激活",
        }
        rows[#rows + 1] = {
            img = Code.PAY_REWARD_CARD_XP_ICON,
            count = bonus,
            unit = "通行证经验",
        }
    elseif goosd_name == "card_level" then
        local lv = self.Data[ID].card_level_count or 1
        local xp_each = Code.CardLevelXpPerLevel or 500
        if Shop and Shop.CardStaticData and Shop.CardStaticData.xp_per_level then
            xp_each = Shop.CardStaticData.xp_per_level
        end
        rows[#rows + 1] = {
            img = Code.PAY_REWARD_CARD_XP_ICON,
            count = lv * xp_each,
            unit = "通行证经验",
        }
    elseif goods == "HOLIDAY_DW_30" or goods == "HOLIDAY_DW_68" or goods == "HOLIDAY_DW_128" then
        if HolidayPack and HolidayPack.BuildRedeemRows then
            local pack_rows = HolidayPack:BuildRedeemRows(goods)
            for _, row in ipairs(pack_rows) do
                rows[#rows + 1] = row
            end
        end
    elseif type(goods) == "string" and string.sub(goods, 1, 5) == "GIFT_" then
        if HolidayPack and HolidayPack.BuildRedeemRowsForGift then
            local pack_rows = HolidayPack:BuildRedeemRowsForGift(ID, goods)
            for _, row in ipairs(pack_rows) do
                rows[#rows + 1] = row
            end
        end
    elseif goods ~= "MONTH_CARD" and goods ~= "CARD2" then
        local base_price = goods and Code.GoodsPrice[goods] or nil
        local item_num = 0
        if base_price then
            item_num = base_price * 10
            if Shop.Data[ID] and Shop.Data[ID].double then
                if Shop.Data[ID].double[goosd_name] == 0 then
                    item_num = item_num * Code.FIRST_CHARGE_GOLD_MULT
                else
                    item_num = item_num * (Code.RECHARGE_GOLD_MULT or 2)
                end
            end
        end
        if item_num > 0 then
            rows[#rows + 1] = { img = gold_icon, count = item_num, unit = "金豆" }
        end
    end
    return rows
end
