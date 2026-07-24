--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Box == nil then
    Box = class({})
    require("ingame.Box.Config")
    require("ingame.Box.Set")
    require("ingame.Box.Get")
    require("ingame.Box.Func")
    require("ingame.Box.Ui")
end

function Box:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    -- 初始化宝箱列表
    local num = self.Static.box_slot_num
    for i = 1, num do
        local slot = "slot_" .. i
        self.Data[ID].list[slot] = Util:DeepCopyTab(self.SlotTemplate)
        self.Data[ID].list[slot].id = i
    end
end

function Box:InitDummy(ID)
    if not ID then return end
    -- local hero = Util:ID2Hero(ID)
    if self.Data[ID].dummy ~= -1 then return end
    self.Data[ID].dummy = -1
    local pos = Monster.Static.map_center
    CreateUnitByNameAsync("dummy", pos, true, nil, nil, PlayerResource:GetTeam(ID), function(dummy)
        -- dummy:SetControllableByPlayer(ID, true)
        utilex:AddModifier(dummy, "modifier_petbuff")
        if dummy then
            self.Data[ID].dummy = dummy:GetEntityIndex()
            -- print("虚拟体创建成功")
        end
    end)
    -- CreateUnitByNameAsync("dummy", pos, true, hero, hero, hero:GetTeam(), function(dummy)
    --     -- dummy:SetControllableByPlayer(ID, true)
    --     utilex:AddModifier(dummy, "modifier_petbuff")
    --     if dummy then
    --         self.Data[ID].dummy = dummy:GetEntityIndex()
    --         print("虚拟体创建成功")
    --     end
    -- end)
end

function Box:Show(ID)
    if not ID or not self.Data[ID] then return end
    self.Data[ID].show = true
    self:SendData(ID)
end

function Box:Hide(ID)
    if not ID or not self.Data[ID] then return end
    self.Data[ID].show = false
    self:SendData(ID)
end

function Box:OpenPage(ID)
    if not ID then return end
    self.Data[ID].page = true
    -- self:SendData(ID)
end

function Box:ClosePage(ID)
    if not ID then return end
    self.Data[ID].page = false
    self:SendData(ID)
end

-- 放弃本次装备选取：清空当前宝箱并扣除一次抽取次数
function Box:GiveUp(ID)
    if not ID or not self.Data[ID] then return end
    if self.Data[ID].draw_state == true then
        return Util:BottomMsg2ID(ID, "当前没有进行中的宝箱")
    end
    if self.Data[ID].page ~= true then
        return
    end
    self:ClearBox(ID)
    self.Data[ID].box_sy_draw = self.Data[ID].box_sy_draw - 1
    if self.Data[ID].box_sy_draw < 0 then
        self.Data[ID].box_sy_draw = 0
    end
    self.Data[ID].draw_state = true
    self.Data[ID].page = false
    self:RefreshNeutralChestItemCharges(ID)
    self:SendData(ID, false, true)
end

-- 抽取宝箱
function Box:Draw(ID)
    if not ID then return end
    local cap = self.Static.max_draw_per_game or 20
    if (self.Data[ID].box_draw_num or 0) >= cap then
        self:RefreshNeutralChestItemCharges(ID)
        return Util:BottomMsg2ID(ID, "本局宝箱抽取已达上限")
    end
    if self:GetDrawCount(ID) <= 0 then
        self:RefreshNeutralChestItemCharges(ID)
        return Util:BottomMsg2ID(ID, "次数不足")
    end
    if self.Data[ID].draw_state == false then
        return
    end
    if self.Data[ID].page == true then
        return
    end
    -- 补充重新随机次数
    self.Data[ID].roll_sy_draw = self.Static.sy_draw
    -- 打开页面
    self:OpenPage(ID)
    -- roll宝箱
    self:RollBox(ID)
    -- roll道具
    self:DrawRoll(ID)
    -- 动画显示但未点亮：DrawRoll 仅对「抽到的」次数调用 NightItem，后期池子小或 TabTrueKeySlot 常为 nil 时可能一个都没点亮，前端收到的 list 里 light 全为 false，导致没有格子可点。此处将所有有物品的格子均设为可选中。
    -- for k, v in pairs(self.Data[ID].list) do
    --     if v.item ~= -1 then v.light = true end
    -- end
    self.Data[ID].draw_state = false
    self:SendData(ID, true, true)
end

-- 重新随机
function Box:DrawRoll(ID)
    if not ID then return end
    if self.Data[ID].roll_sy_draw <= 0 then return end
    local cost = self.Data[ID].cost
    if self.Data[ID].roll_sy_draw < 4 then
        -- 支付
        if not Shop:CostGold(ID, cost) then return end
    end
    for i = 1, 3 do
        local time = 0.2 * i
        Timers(time, function() utilex:Sound(ID, "use_item") end)
    end
    -- 稀有装备
    local race_list = self.Data[ID].weight_1
    -- 普通装备
    local normal_list = self.Data[ID].weight_2
    -- 当前剩余重随次数
    local draw_num = self.Data[ID].roll_sy_draw
    -- 当前剩余装备抽取次数
    local draw_sy = self.Static.roll_num
    local race_zb = 0
    local race_roll = 0
    -- 第一次随机权重1装备概率为0
    if draw_num == 3 then
        race_zb = 1
        race_roll = 10
    end
    if draw_num == 2 then
        race_zb = 2
        race_roll = 20
    end
    if draw_num == 1 then
        race_zb = 3
        race_roll = 40
    end
    if race_zb > 0 then
        for i = 1, race_zb do
            local random = math.random(1, 100)
            if random <= race_roll then
                -- roll一件稀有装备
                local item_key = self:TabTrueKeySlot(race_list)
                if item_key then
                    -- 获取装备ID
                    local item_id =
                        tonumber(utilex:splitIndex(item_key, "_", 2))
                    -- 点亮宝箱装备
                    Box:NightItem(ID, item_id)
                    draw_sy = draw_sy - 1
                end
            end
        end
    end
    for i = 1, draw_sy do
        -- roll一件普通装备
        local item_key = self:TabTrueKeySlot(normal_list)
        if not item_key then item_key = self:TabTrueKeySlot(race_list) end
        if item_key then
            -- 获取装备ID
            local item_id = tonumber(utilex:splitIndex(item_key, "_", 2))
            -- 点亮宝箱装备
            Box:NightItem(ID, item_id)
        else
            -- print("最终都没有roll出可以用的装备")
        end
        -- normal_list[item_key] = false
    end
    self.Data[ID].roll_sy_draw = self.Data[ID].roll_sy_draw - 1
    self:SetRollCost(ID)
end

-- roll一件装备
function Box:TabTrueKeySlot(list)
    local num = 0
    local flag = false
    repeat
        local random_key = utilex:TabRandomKey(list)
        if random_key and list[random_key].state then
            list[random_key].state = false
            flag = true
            return list[random_key].item_key
        end
        num = num + 1
        if num > 300 then
            flag = true
            return
        end
    until flag
end

-- 点亮装备
function Box:NightItem(ID, item_id)
    for k, v in pairs(self.Data[ID].list) do
        if v.light == false and v.item == item_id then
            v.light = true
            local item_key = "z_" .. item_id
            self:ClearNight(ID, item_key)
            return
        end
    end
end

-- 清理点亮的物品
function Box:ClearNight(ID, item_key)
    self:ClearNight1(ID, item_key)
    self:ClearNight2(ID, item_key)
end

function Box:ClearNight1(ID, item_key)
    for k, v in pairs(self.Data[ID].weight_1) do
        if v.item_key == item_key then
            self.Data[ID].weight_1[k] = nil
            return
        end
    end
end

function Box:ClearNight2(ID, item_key)
    for k, v in pairs(self.Data[ID].weight_2) do
        if v.item_key == item_key then
            self.Data[ID].weight_2[k] = nil
            return
        end
    end
end

function Box:Select(ID, slot)
    if not ID or not slot then return end
    if self.Data[ID].draw_state == true then
        self:ClosePage(ID)
        return
    end
    -- 防止宝箱次数被扣成负数（如重复点击、网络延迟等）
    if self:GetDrawCount(ID) <= 0 then
        if self.Data[ID].box_sy_draw < 0 then
            self.Data[ID].box_sy_draw = 0
            self:SendData(ID)
        end
        self:RefreshNeutralChestItemCharges(ID)
        self:ClosePage(ID)
        return Util:BottomMsg2ID(ID, "次数不足")
    end
    local data = self.Data[ID].list[slot]
    if not data then
        self:ClosePage(ID)
        return
    end
    if data.light == false then return end
    utilex:Sound(ID, "select_page")
    local item_id = data.item
    local item_key = "item_box_" .. item_id
    local item_data = Box.Item[item_key]
    if not item_data then
        self:ClosePage(ID)
        return
    end
    -- 如果是消耗品直接使用
    if item_data.cost == true then
        if self.Data[ID].draw_state == true then
            return
        end
        self:UseItem(ID, item_id)
        -- 关闭抽奖
        self:SubDraw(ID)
        return
    end
    if self:BagIsFull(ID) then
        --如果有子道具在背包中就先移除，直接添加到背包
        if item_data.son then
            for k, v in pairs(item_data.son_list) do
                if v then
                    local item_z = "z_" .. v
                    -- 如果子物品在背包中就移除
                    if self:IsInBag(ID, item_z) then
                        -- 移除背包中子件
                        self:RemoveItem(ID, v)
                        self:RemoveBuff(ID, v)
                    end
                end
            end
            for i = 1, 6 do
                local slots = "slot_" .. i
                if self.Data[ID].bag[slots] == -1 then
                    self.Data[ID].bag[slots] = item_id
                    -- 添加物品效果
                    self:AddItemBuff(ID, item_id)
                    self:SubDraw(ID)
                    return
                end
            end
        end
        return Util:BottomMsg2ID(ID, "背包已满")
    end
    -- 直接添加物品到背包
    self:AddItemToBag(ID, item_id)
    self:SubDraw(ID)
end

function Box:BreakItem(ID, slot)
    if not ID or not slot then return end
    -- if not Shop:CostGold(ID, 2) then
    --     return Util:BottomMsg2ID(ID, "金币不足")
    -- end
    -- Shop:SyncGold(ID)
    local item_id = self.Data[ID].bag[slot]
    Box:RemoveBuff(ID, item_id)
    self.Data[ID].bag[slot] = -1
    self:SendData(ID)
end

function Box:Run(ID)
    if not ID then return end
    if self.Data[ID].run_state == false then return end
    local hero = Util:ID2Hero(ID)
    -- 英雄添加buff
    hero:AddNewModifier(hero, nil, "modifier_run", {})
    -- 进入CD
    self.Data[ID].run_state = false
    self.Data[ID].run_cd = self.Static.run_cd
    Timers(0, function()
        if self.Data[ID].run_state == true then return end
        self.Data[ID].run_cd = self.Data[ID].run_cd - 1
        if self.Data[ID].run_cd == 0 then
            self.Data[ID].run_state = true
            self:SendRunData(ID)
            return
        end
        self:SendRunData(ID)
        return 1
    end)
end

function Box:RunClearCd(ID)
    self.Data[ID].run_cd = 0
    self.Data[ID].run_state = true
    self:SendRunData(ID)
end
