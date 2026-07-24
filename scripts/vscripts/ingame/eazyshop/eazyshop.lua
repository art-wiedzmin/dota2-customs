--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if EazyShop == nil then
    EazyShop = class({})

    require("ingame.EazyShop.Config")

    require("ingame.EazyShop.Set")

    require("ingame.EazyShop.Get")

    require("ingame.EazyShop.Func")

    require("ingame.EazyShop.Ui")
end



function EazyShop:Init(ID)
    if not ID then
        return
    end

    self.Data[ID] = Util:DeepCopyTab(self.Template)

    self.Data[ID].goods = Util:DeepCopyTab(EazyShop.Static.Goods)
end

function EazyShop:EazyShopChange(ID)
    if not ID then
        return
    end
    if self.Data[ID].page == true then
        self:ClosePage(ID)
    else
        self:OpenPage(ID)
    end
    self:SendData(ID)
end

local function EazyShopFindGood(key)
    for _, row in ipairs(EazyShop.Static.Goods) do
        if row.id == key then
            return row
        end
    end
end



function EazyShop:IsRbSkillItem(name)
    if not name then
        return false
    end

    for _, v in ipairs(Item.Rb) do
        if v == name then
            return true
        end
    end

    return false
end

function EazyShop:OpenTianShuPicker(ID)
    -- print("OpenTianShuPicker")
    if not ID then
        return
    end

    local parts = {}

    for _, skill_item in ipairs(Item.Rb) do
        table.insert(parts, skill_item)
    end
    -- print(1111)
    -- 数据来自 Item.Rb；字符串列表避免客户端事件里 table 序列化异常
    -- print(222)
    Util:Send2JsID("UI_FreeBook", {

        visible = true,

        skills = Item.Rb,

    }, ID)
end

--- 从背包使用天书：已消耗道具，取消则补回 item_goods_22

function EazyShop:OpenTianShuPickerFromItem(ID)
    if not ID or not self.Data[ID] then
        return
    end

    local d = self.Data[ID]

    d.tian_shu_pending = false

    d.tian_shu_item_refund = true

    self:OpenTianShuPicker(ID)
end

function EazyShop:TianShuPickSkill(ID, item_name)
    -- print(item_name)
    if not ID or not item_name or item_name == "" then
        return
    end

    if not self.Data[ID] then
        return
    end

    local d = self.Data[ID]

    if not d.tian_shu_pending and not d.tian_shu_item_refund then
        return
    end

    if not self:IsRbSkillItem(item_name) then
        return
    end

    d.tian_shu_pending = false

    d.tian_shu_item_refund = false

    Item:AddItem(ID, item_name)

    Util:Send2JsID("UI_FreeBook", { visible = false }, ID)
end

function EazyShop:TianShuCancel(ID)
    if not ID then
        Util:Send2JsID("UI_FreeBook", { visible = false }, ID)

        return
    end

    local d = self.Data[ID]

    if d then
        if d.tian_shu_pending then
            local r = tonumber(EazyShop.Static.TianShuPrice) or 1000

            PlayerResource:ModifyGold(ID, r, false, 0)

            d.tian_shu_pending = false
        end

        if d.tian_shu_item_refund then
            Item:AddItem(ID, "item_goods_22")

            d.tian_shu_item_refund = false
        end
    end

    Util:Send2JsID("UI_FreeBook", { visible = false }, ID)
end

--- 便捷购买：不发放实物（天书除外为弹窗选技能书）

function EazyShop:Buy(ID, text)
    if not ID or not text or text == "" then
        return
    end

    local row = EazyShopFindGood(text)

    if not row then
        return
    end

    if MainGame and MainGame.IsPassiveModeBannedPurchaseItem
        and MainGame:IsPassiveModeBannedPurchaseItem(row.item) then
        Util:BottomMsg2ID(ID, "被动模式下不可购买该物品", "red", 1)

        return
    end

    local cost = tonumber(row.price) or 0

    if PlayerResource:GetGold(ID) < cost then
        Util:BottomMsg2ID(ID, "金币不足", "red", 1)

        return
    end

    local hero = Util:ID2Hero(ID)

    if not hero or hero:IsNull() then
        return
    end

    if text == "tian_shu" then
        local gr = GameRules
        local game_t = (gr and gr.GetDOTATime and gr:GetDOTATime(true, true)) or 0
        local need_t = tonumber(EazyShop.Static.TianShuUnlockGameTime) or 1200
        if game_t < need_t then
            local need_min = math.max(1, math.ceil(need_t / 60))
            Util:BottomMsg2ID(
                ID,
                string.format("游戏时间满%d分钟后才可从便捷商店购买天书", need_min),
                "red",
                1
            )

            return
        end

        PlayerResource:SpendGold(ID, cost, 0)

        EmitSoundOn("General.Buy", hero)

        self.Data[ID].tian_shu_pending = true

        self.Data[ID].tian_shu_item_refund = false

        self:OpenTianShuPicker(ID)

        self:SendData(ID)

        return
    end

    if text == "goods_3" then
        if hero:GetBaseStrength() <= 10 then
            Util:BottomMsg2ID(ID, "力量不足", "red")

            return
        end

        hero:ModifyStrength(-10)

        hero:ModifyAgility(10)
    elseif text == "goods_4" then
        if hero:GetBaseStrength() <= 10 then
            Util:BottomMsg2ID(ID, "力量不足", "red")

            return
        end

        hero:ModifyStrength(-10)

        hero:ModifyIntellect(10)
    elseif text == "goods_5" then
        if hero:GetBaseAgility() <= 10 then
            Util:BottomMsg2ID(ID, "敏捷不足", "red")

            return
        end

        hero:ModifyStrength(10)

        hero:ModifyAgility(-10)
    elseif text == "goods_6" then
        if hero:GetBaseAgility() <= 10 then
            Util:BottomMsg2ID(ID, "敏捷不足", "red")

            return
        end

        hero:ModifyAgility(-10)

        hero:ModifyIntellect(10)
    elseif text == "goods_7" then
        if hero:GetBaseIntellect() <= 10 then
            Util:BottomMsg2ID(ID, "智力不足", "red")

            return
        end

        hero:ModifyStrength(10)

        hero:ModifyIntellect(-10)
    elseif text == "goods_8" then
        if hero:GetBaseIntellect() <= 10 then
            Util:BottomMsg2ID(ID, "智力不足", "red")

            return
        end

        hero:ModifyAgility(10)

        hero:ModifyIntellect(-10)
    elseif text == "skill_point" then
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
    elseif text == "del_skill" then
        if not Skill:OpenDelSkill(ID) then
            return
        end
    elseif text == "life_book" then
        if not HeroData:TryApplyLifeBookSmjc(ID) then
            Util:BottomMsg2ID(ID, "本局生命之书加成次数已达上限", "red", 2)

            return
        end
    else
        return
    end

    PlayerResource:SpendGold(ID, cost, 0)

    EmitSoundOn("General.Buy", hero)

    self:SendData(ID)
end
