--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Shop:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    --暂停禁止传数据
    -- if GameRules:IsGamePaused() then
    --     return
    -- end
    --初始化数据
    if data.tp == "init" then
        self:SendData(ID)
    end

    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    if data.tp == "OpenBattlePass" then
        self:OpenBattlePassPage(ID)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    --购买（2-7 金豆档 6/30/68/128/328/648 元，10=1280 元；8 季卡 9 通行证）
    if data.tp == "Pay" then
        self:Pay(ID, data.text)
    end
    if data.tp == "PayCardLevel" then
        self:PayCardLevel(ID, data.text)
    end
    --免费领取(1,每日金币礼包，2月卡每日礼包)
    if data.tp == "Free" then
        self:Free(ID, data.text)
    end
    if data.tp == "Refresh" then
        self:Refresh(ID)
    end

    if data.tp == "Code" then
        self:Code(ID, data.text)
    end
    if data.tp == "ClaimCardReward" then
        self:ClaimCardReward(ID, data.level, data.track)
    end
    if data.tp == "ClaimAllCardRewards" then
        self:ClaimAllCardRewards(ID)
    end
    if data.tp == "OutBagSync" then
        self:SyncOutBag(ID)
    end
    if data.tp == "OutBagEquip" then
        self:OutBagEquip(ID, data.slot, data.item_key)
    end
    if data.tp == "OutBagUnequip" then
        self:OutBagUnequip(ID, data.slot)
    end
end

--给前端发数据
function Shop:SendData(ID)
    if not ID then
        return
    end
    local data = self.Data[ID]
    data.itemList = self.ItemList
    local cosmetics = (self.Data[ID] and self.Data[ID].pass_cosmetics) or self.PassCosmetics
    data.pass_cosmetics = cosmetics
    data.pass_cosmetics_json = nil
    -- 扁平字段（与礼包 image_key 同理）：只传键，客户端本地取图
    data.pass_season_id = nil
    data.pass_deadline_text = nil
    data.pass_free_title_key = nil
    data.pass_premium_title_key = nil
    data.pass_premium_effect_key = nil
    data.pass_premium_effect_kind = nil
    if cosmetics and type(cosmetics) == "table" then
        data.pass_season_id = cosmetics.season_id or cosmetics.seasonId or cosmetics.seasonid
        data.pass_deadline_text = cosmetics.deadline_text or cosmetics.deadlineText or cosmetics.deadlinetext
        data.pass_free_title_key = cosmetics.free_title_key
            or (cosmetics.freeTitle and (cosmetics.freeTitle.itemKey or cosmetics.freeTitle.item_key))
        data.pass_premium_title_key = cosmetics.premium_title_key
            or (cosmetics.premiumTitle and (cosmetics.premiumTitle.itemKey or cosmetics.premiumTitle.item_key))
        data.pass_premium_effect_key = cosmetics.premium_effect_key
            or (cosmetics.premiumEffect and (cosmetics.premiumEffect.itemKey or cosmetics.premiumEffect.item_key))
        data.pass_premium_effect_kind = cosmetics.premium_effect_kind
            or (cosmetics.premiumEffect and cosmetics.premiumEffect.kind)
        if JSON and JSON.encode then
            local ok, encoded = pcall(function()
                return JSON.encode(cosmetics)
            end)
            if ok and type(encoded) == "string" and encoded ~= "" then
                data.pass_cosmetics_json = encoded
            end
        end
    end
    Util:Send2JsID("UI_Shop", data, ID)
end

function Shop:PayCardLevel(ID, level_count)
    if not ID then
        return
    end
    local max_n = self:GetRemainingBuyableLevels(ID)
    if max_n <= 0 then
        Msgs:Pop(ID, "通行证已满级")
        return
    end
    local n = tonumber(level_count) or 0
    if n < 1 then
        Msgs:Pop(ID, "请选择购买等级")
        return
    end
    if not Code:SetCardLevelGoods(ID, n) then
        Msgs:Pop(ID, "通行证已满级")
        return
    end
    Code:Pay(ID, 1)
end

function Shop:Pay(ID, num)
    if not ID or not num then
        return
    end
    local goods_num = tonumber(num)
    if goods_num == 9 then
        local card = self.Data[ID] and self.Data[ID].card
        if card and card.state == 1 then
            Msgs:Pop(ID, "通行证已激活，无法重复购买", {})
            return
        end
    end
    Code:SetGoods(ID, num)
    --发起订单
    Code:Pay(ID, 1)
end
