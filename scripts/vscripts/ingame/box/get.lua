--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Box:GetCurrency(ID) return self.Data[ID].currency end

function Box:GetDrawCount(ID)
    local n = self.Data[ID].box_sy_draw
    return (n and n > 0) and n or 0
end

-- 本局是否仍可增加宝箱抽取次数（与 max_draw_per_game、box_draw_num 一致；发放处与 AddDraw 内均会判定）
function Box:CanAddDrawCharge(ID)
    if not ID or not self.Data[ID] then
        return false
    end
    local cap = self.Static.max_draw_per_game or 20
    return (self.Data[ID].box_draw_num or 0) < cap
end

function Box:GetBoxType(ID)
    local draw_num = self.Data[ID].box_draw_num
    if draw_num <= 4 then return "box_1" end
    if draw_num > 4 and draw_num <= 8 then return "box_2" end
    if draw_num > 8 then return "box_3" end
end

-- 从当前宝箱池中取一个「未锁定且不在背包」的 key，用于填槽兜底（避免后期空物品）
function Box:GetOneAvailableBoxKey(ID, box_key)
    if not ID or not box_key or not self.Data[ID][box_key] then return nil end
    local pool = self.Data[ID][box_key]
    local list = {}
    for k, v in pairs(pool) do
        if v == true and not self:IsInBag(ID, k) then
            table.insert(list, k)
        end
    end
    if #list == 0 then return nil end
    return list[math.random(1, #list)]
end

-- 装备是否在背包内
function Box:IsInBag(ID, item)
    if not ID or not item then return end
    local item_id
    if type(item) == "string" then
        item_id = tonumber(utilex:splitIndex(item, "_", 2))
    else
        item_id = item
    end
    for k, v in pairs(self.Data[ID].bag) do
        if item_id == v then return true end
    end
end

-- 移除背包中物品
function Box:RemoveItem(ID, item_id)
    for k, v in pairs(self.Data[ID].bag) do
        if v == item_id then
            self.Data[ID].bag[k] = -1
            return
        end
    end
end

function Box:BagIsFull(ID)
    for k, v in pairs(self.Data[ID].bag) do if v == -1 then return false end end
    return true
end

-- 在该宝箱中是否为高阶装备
function Box:IsHighZbInBox(box_key, high_item)
    if not box_key or not high_item then return false end
    local item_id = tonumber(utilex:splitIndex(high_item, "_", 2))
    if not item_id then return end
    for k, v in pairs(self.Roll[box_key].weight_1) do
        if v == item_id then return true end
    end
end

-- 获取物品信息
function Box:GetItemData(item_id)
    local item_key = "item_box_" .. item_id
    local data = Util:DeepCopyTab(self.Item[item_key])
    return data
end

-- 是否有特定技能增强
function Box:IsHaveSkill(ID, item_id)
    if not ID or not item_id then
        return false
    end
    local row = self.Data and self.Data[ID]
    if not row or not row.skill then
        return false
    end
    local item_key = "item_" .. item_id
    return row.skill[item_key]
end

--获取假人
function Box:GetDummy(ID)
    local dummy = EntIndexToHScript(self.Data[ID].dummy)
    if dummy then
        return dummy
    end
end

function Box:IsNoDummy(item_id)
    for k, v in pairs(Box.NoDummy) do
        if v == item_id then return true end
    end
    return false
end
