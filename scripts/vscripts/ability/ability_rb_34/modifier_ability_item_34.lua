--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 死者为大（ability_item_34）：每次死亡至多获得一种奖励；轮空概率 = 100% - 各物品概率之和
modifier_ability_item_34 = class({})

local SKILL_NAME = "死者为大"

local REWARD_POOL = {
    {
        key = "item_goods_9",
        label = "技能点",
        is_item = true,
        pct = { 30, 32, 34, 36, 38, 40, 42, 46, 50, 55 },
    },
    {
        key = "item_goods_10",
        label = "狼王内丹",
        is_item = true,
        pct = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 },
    },
    {
        key = "item_goods_23",
        label = "陨落星辰",
        is_item = true,
        pct = { 0, 0, 0, 0, 2, 4, 6, 8, 10, 12 },
    },
    {
        key = "item_goods_11",
        label = "肉山心脏",
        is_item = true,
        pct = { 0, 0, 0, 0, 0, 0, 0, 2, 3, 5 },
    },
    {
        key = "item_goods_26",
        label = "风暴核心",
        is_item = true,
        pct = { 0, 0, 0, 0, 0, 0, 0, 0, 1.5, 3 },
    },
    {
        key = "item_goods_16",
        label = "究极技能书",
        is_item = true,
        pct = { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1.5 },
    },
}

local function roll_death_reward(level)
    local total = 0
    local entries = {}
    for _, row in ipairs(REWARD_POOL) do
        local pct = row.pct[level] or 0
        if pct > 0 then
            total = total + pct
            table.insert(entries, { row = row, pct = pct })
        end
    end
    if total <= 0 then
        return nil
    end

    local roll = Script_RandomFloat(0, 100)
    if roll >= total then
        return nil
    end

    local cumulative = 0
    for _, entry in ipairs(entries) do
        cumulative = cumulative + entry.pct
        if roll < cumulative then
            return entry.row
        end
    end
    return nil
end

function modifier_ability_item_34:IsHidden()
    return true
end

function modifier_ability_item_34:IsDebuff()
    return false
end

function modifier_ability_item_34:IsPurgable()
    return false
end

function modifier_ability_item_34:RemoveOnDeath()
    return false
end

function modifier_ability_item_34:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_ability_item_34:OnDeath(params)
    if not IsServer() then
        return
    end
    local unit = params.unit
    if unit ~= self:GetParent() then
        return
    end
    if not Util:IsPlayerHeroForData(unit) then
        return
    end

    local ability = self:GetAbility()
    if not ability then
        return
    end

    local ID = Util:Hero2ID(unit)
    if not ID then
        return
    end

    local level = ability:GetLevel()
    if level < 1 then
        level = 1
    elseif level > 10 then
        level = 10
    end

    local row = roll_death_reward(level)
    if not row then
        return
    end

    if row.is_item and utilex:IsInventoryAndPersonalBagFull(unit) then
        Util:BottomMsg2ID(ID, SKILL_NAME .. "：背包已满，无法获得" .. row.label, "orange", 2)
        return
    end

    utilex:Sound(ID, "treasure_drop")
    Item:AddItem(ID, row.key)
    Util:BottomMsg2ID(ID, SKILL_NAME .. "：获得" .. row.label, "yellow", 3)
end