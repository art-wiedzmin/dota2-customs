--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 身上任意槽位的 item_cost_2（用于中立栏展示宝箱次数）
function Box:FindItemCost2(hero)
    if not hero or hero:IsNull() then return end
    for i = 0, 23 do
        local it = hero:GetItemInSlot(i)
        if it and not it:IsNull() and it:GetName() == "item_cost_2" then
            return it
        end
    end
end

function Box:GetNeutralChestSlot()
    local slot = tonumber(rawget(_G, "DOTA_ITEM_NEUTRAL_ACTIVE_SLOT"))
    if slot == nil then
        slot = 16
    end
    return slot
end

function Box:HasMisplacedItemCost2(hero)
    local item = self:FindItemCost2(hero)
    if not item or item:IsNull() then
        return false
    end
    local slot = item:GetItemSlot()
    return slot ~= nil and slot >= 0 and slot ~= self:GetNeutralChestSlot()
end

--- 单次尝试：将 item_cost_2 换至中立栏（仅此处与 Schedule 允许涉及中立宝箱槽）
function Box:EnsureItemCost2InNeutralSlot(hero, item)
    if not hero or hero:IsNull() then
        return false
    end
    item = item or self:FindItemCost2(hero)
    if not item or item:IsNull() or item:GetName() ~= "item_cost_2" then
        return false
    end
    local target = self:GetNeutralChestSlot()
    local cur = item:GetItemSlot()
    if not cur or cur < 0 then
        return false
    end
    if cur == target then
        return true
    end
    pcall(function()
        hero:SwapItems(cur, target)
    end)
    return item:GetItemSlot() == target
end

--- 开局/重连/背包变动后多次重试（引擎中立栏未就绪时 Swap 会失败）
function Box:ScheduleEnsureItemCost2InNeutralSlot(hero, item)
    if not hero or hero:IsNull() then
        return
    end
    local delays = { 0, 0.06, 0.15, 0.35, 0.75, 1.5 }
    for _, delay in ipairs(delays) do
        Timers(delay, function()
            if not hero or hero:IsNull() then
                return
            end
            local it = item
            if not it or it:IsNull() then
                it = Box:FindItemCost2(hero)
            end
            if not it or it:IsNull() then
                return
            end
            if it:GetItemSlot() ~= Box:GetNeutralChestSlot() then
                Box:EnsureItemCost2InNeutralSlot(hero, it)
            end
        end)
    end
end

-- 开局唯一入口：将 item_cost_2 放入中立栏（此后由 Ensure/Schedule 纠正错位）
function Box:TryPlaceItemCost2InNeutralSlot(hero, item)
    if not hero or hero:IsNull() or not item or item:IsNull() then
        return false
    end
    if item:GetName() ~= "item_cost_2" then
        return false
    end
    self:ScheduleEnsureItemCost2InNeutralSlot(hero, item)
    return self:EnsureItemCost2InNeutralSlot(hero, item)
end

-- 将 box_sy_draw 同步到 item_cost_2 右下角充能
function Box:RefreshNeutralChestItemCharges(ID)
    if not ID or not self.Data[ID] then return end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then return end
    if self:HasMisplacedItemCost2(hero) then
        self:EnsureItemCost2InNeutralSlot(hero)
    end
    local item = self:FindItemCost2(hero)
    if not item then return end
    local n = self.Data[ID].box_sy_draw or 0
    if n < 0 then n = 0 end
    item:SetCurrentCharges(n)
end

--清理宝箱
function Box:ClearBox(ID)
    local unlock_yasha_group = false
    local unlock_22_23 = false
    for k, v in pairs(self.Data[ID].list) do
        local item_id = v.item
        if item_id ~= -1 then
            if item_id == 1 or item_id == 2 or item_id == 3 then
                unlock_yasha_group = true
            end
            if item_id == 22 or item_id == 23 then
                unlock_22_23 = true
            end
            self:UnLock(ID, item_id)
        end
        v.item = -1
        v.light = false
    end
    -- AddItemToBox 对 1/2/3 会三键全 Lock，只 UnLock 列表里出现过的 id 会漏掉另两个 z_键
    if unlock_yasha_group then
        self:UnLock(ID, 1)
        self:UnLock(ID, 2)
        self:UnLock(ID, 3)
    end
    if unlock_22_23 then
        self:UnLock(ID, 22)
        self:UnLock(ID, 23)
    end
    self.Data[ID].weight_1 = {}
    self.Data[ID].weight_2 = {}
end

--锁定物品
function Box:Lock(ID, item_key)
    -- if item_key == "z_0" or item_key == "z_61" then
    --     return
    -- end
    if type(item_key) == "number" then
        item_key = "z_" .. item_key
    end
    for i = 1, 3 do
        local box = "box_" .. i
        for k, v in pairs(self.Data[ID][box]) do
            if k == item_key and v == true then
                self.Data[ID][box][item_key] = false
            end
        end
    end
end

--移除物品
function Box:DelItem(ID, item_key)
    if type(item_key) == "number" then
        item_key = "z_" .. item_key
    end
    for i = 1, 3 do
        local box = "box_" .. i
        for k, v in pairs(self.Data[ID][box]) do
            if k == item_key then
                self.Data[ID][box][item_key] = nil
            end
        end
    end
end

--解锁物品
function Box:UnLock(ID, item_id)
    local item_key = "z_" .. item_id
    for i = 1, 3 do
        local box = "box_" .. i
        for k, v in pairs(self.Data[ID][box]) do
            if k == item_key and v == false then
                self.Data[ID][box][item_key] = true
            end
        end
    end
end

--抽取次数+1
function Box:AddDraw(ID)
    -- print("抽取次数+1")
    if not self:CanAddDrawCharge(ID) then
        return
    end
    self.Data[ID].box_sy_draw = self.Data[ID].box_sy_draw + 1
    Timers(1, function()
        self:AutoDraw(ID)
    end)
    self:SendData(ID)
    self:RefreshNeutralChestItemCharges(ID)
end

--自动抽取宝箱
function Box:AutoDraw(ID)
    if self.Data[ID].page == true then
        return
    end
    if self.Data[ID].draw_state == false then
        return
    end
    Box:Draw(ID)
end

--所有玩家抽取次数+1
function Box:AllAddDraw()
    local min = MainGame:GetTimeMin()
    if not min then
        return
    end
    for k, v in pairs(self.Static.add_box) do
        local index = tonumber(utilex:splitIndex(k, "_", 2))
        if min >= index and v == false then
            for i, j in pairs(InitPlayer.Public.players) do
                if j.bot then
                    goto continue
                end
                local ID = j.id
                if self:CanAddDrawCharge(ID) then
                    self:AddDraw(ID)
                end
                ::continue::
            end
            self.Static.add_box[k] = true
            return
        end
    end
end

function Box:SetRollCost(ID)
    local num = self.Data[ID].roll_sy_draw
    local key = "num" .. num
    local cost = self.Static.roll_cost[key]
    self.Data[ID].cost = cost or 0
    if num == 0 then
        self.Data[ID].cost = 0
    end
    -- 有月卡或季卡时，第一次需要付费的重随免费
    local first_paid_roll = self.Static.sy_draw - 1
    if num == first_paid_roll then
        if Shop:IsHaveCard(ID) or Shop:IsHaveCard2(ID) then
            self.Data[ID].cost = 0
        end
    end
end

--扣除次数并且关闭抽奖页面
function Box:SubDraw(ID)
    self.Data[ID].box_sy_draw = self.Data[ID].box_sy_draw - 1
    self.Data[ID].draw_state = true
    self:ClosePage(ID)
    self:RefreshNeutralChestItemCharges(ID)
end
