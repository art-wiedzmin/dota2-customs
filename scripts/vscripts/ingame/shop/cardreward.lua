--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 通行证等级奖励领取

local CARD_REWARD_GOLD_ICON = "raw://resource/flash3/images/shop/b_cost.png"
local CARD_REWARD_HERO_PICK_ICON = "raw://resource/flash3/images/card/herocard.png"
local CARD_REWARD_TITLE_FREE_ICON = "raw://resource/flash3/images/card/ch_clxz.png"
local CARD_REWARD_TITLE_PREMIUM_ICON = "raw://resource/flash3/images/card/ch_hsbh.png"
local CARD_REWARD_ATTACK_PREMIUM_ICON = "raw://resource/flash3/images/card/txz_lxhs.png"
local CARD_REWARD_EFFECT_PREMIUM_ICON = "raw://resource/flash3/images/card/tx1.png"
local CARD_REWARD_PET_TI10_ROSH_ICON = "raw://resource/flash3/images/achive/pet.png"
local CARD_REWARD_PROPHECY_ICON = "raw://resource/flash3/images/achive/yyk.png"

function Shop:GetPassCosmeticIcon(kind)
    local c = self.PassCosmetics
    if not c then
        return nil
    end
    if kind == "free_title" and c.freeTitle then
        return c.freeTitle.icon
            or (c.freeTitle.itemKey and self.ItemList and self.ItemList[c.freeTitle.itemKey] and self.ItemList[c.freeTitle.itemKey].icon)
    end
    if kind == "premium_title" and c.premiumTitle then
        return c.premiumTitle.icon
            or (c.premiumTitle.itemKey and self.ItemList and self.ItemList[c.premiumTitle.itemKey] and self.ItemList[c.premiumTitle.itemKey].icon)
    end
    if kind == "premium_effect" and c.premiumEffect then
        return c.premiumEffect.icon
            or (c.premiumEffect.itemKey and self.ItemList and self.ItemList[c.premiumEffect.itemKey] and self.ItemList[c.premiumEffect.itemKey].icon)
    end
    return nil
end

--- 称号奖励弹窗行（图标取自 ItemList.icon -> resource/flash3/images/card）
function Shop:BuildTitleRedeemRow(item_key)
    if not item_key or item_key == "" then
        return nil
    end
    local meta = self.ItemList and self.ItemList[item_key]
    if not meta or not meta.icon or meta.icon == "" then
        return nil
    end
    return {
        img = meta.icon,
        count = meta.name or item_key,
        unit = "称号",
    }
end

function Shop:CardRedeemRowsFromServer(rows)
    local out = {}
    if not rows or type(rows) ~= "table" then
        return out
    end
    for _, row in ipairs(rows) do
        if type(row) == "table" then
            local item = {}
            local resolveKey = row.itemKey or row.imgKey
            local meta = resolveKey and self.ItemList and self.ItemList[resolveKey]
            local titleKey = nil
            if row.itemKey and string.sub(tostring(row.itemKey), 1, 6) == "title_" then
                titleKey = row.itemKey
            elseif row.imgKey and string.sub(tostring(row.imgKey), 1, 6) == "title_" then
                titleKey = row.imgKey
            end
            if titleKey then
                local titleRow = self:BuildTitleRedeemRow(titleKey)
                if titleRow then
                    item.img = titleRow.img
                end
            elseif meta and meta.icon and meta.icon ~= "" then
                item.img = meta.icon
            elseif row.imgKey == "gold" then
                item.img = CARD_REWARD_GOLD_ICON
            elseif row.imgKey == "hero_pick" then
                item.img = CARD_REWARD_HERO_PICK_ICON
            elseif row.imgKey == "prophecy_card" then
                item.img = CARD_REWARD_PROPHECY_ICON
            elseif row.imgKey == "title_free" then
                item.img = self:GetPassCosmeticIcon("free_title") or CARD_REWARD_TITLE_FREE_ICON
            elseif row.imgKey == "title_premium" or row.imgKey == "title_hsbh" or row.imgKey == "title_wrnd" then
                item.img = self:GetPassCosmeticIcon("premium_title") or CARD_REWARD_TITLE_PREMIUM_ICON
            elseif row.imgKey == "attack_premium" or row.imgKey == "attack_lxhs" or row.imgKey == "attack_atv3" then
                item.img = self:GetPassCosmeticIcon("premium_effect") or CARD_REWARD_ATTACK_PREMIUM_ICON
            elseif row.imgKey == "effect_premium" or row.imgKey == "effect_tx1"
                or row.imgKey == "effect_lzqz" or row.imgKey == "effect_txhb" then
                item.img = self:GetPassCosmeticIcon("premium_effect") or CARD_REWARD_EFFECT_PREMIUM_ICON
            elseif row.imgKey == "pet_ti10_rosh" then
                item.img = CARD_REWARD_PET_TI10_ROSH_ICON
            end
            if row.count ~= nil then
                item.count = row.count
            end
            if row.unit ~= nil and row.unit ~= "" then
                item.unit = row.unit
            end
            if item.img or item.count then
                out[#out + 1] = item
            end
        end
    end
    return out
end

function Shop:ApplyCardRewardClaimResult(ID, data, title)
    if not ID or not data then
        return
    end
    if data.user and data.user.gold ~= nil then
        self.Data[ID].gold = data.user.gold
    end
    if data.bag then
        self:SetBagServerData(ID, data.bag)
        self:SendOutBagData(ID)
    end
    if data.card then
        Shop:SetCardServerData(ID, data.card)
    else
        self:SendData(ID)
    end
    local rows = self:CardRedeemRowsFromServer(data.redeem_rows)
    Msgs:PopRedeemSuccess(ID, title or "领取成功", rows)
end

function Shop:OnCardRewardClaimFailed(ID, keys)
    local msg = "领取失败"
    if keys and keys.message and keys.message ~= "" then
        msg = keys.message
    end
    Msgs:Pop(ID, msg)
end

function Shop:ClaimCardReward(ID, level, track)
    if not ID then
        return
    end
    local lv = tonumber(level)
    if not lv or lv < 1 then
        return
    end
    if track ~= "free" and track ~= "premium" then
        return
    end
    Http:POST("/card/claim", { level = lv, track = track }, ID, function(keys)
        if keys.code == 200 and keys.data then
            self:ApplyCardRewardClaimResult(ID, keys.data, "领取成功")
        else
            self:OnCardRewardClaimFailed(ID, keys)
        end
    end)
end

function Shop:ClaimAllCardRewards(ID)
    if not ID then
        return
    end
    Http:POST("/card/claim_all", {}, ID, function(keys)
        if keys.code == 200 and keys.data then
            self:ApplyCardRewardClaimResult(ID, keys.data, "领取成功")
        else
            self:OnCardRewardClaimFailed(ID, keys)
        end
    end)
end
