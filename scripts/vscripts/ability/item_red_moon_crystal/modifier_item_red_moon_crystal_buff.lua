--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_item_red_moon_crystal_buff = class({})

local MOON_SHARD_NV = 240
local MOON_CONSUMED_NV = 240
local RED_MOON_ITEM = "item_red_moon_crystal"

function modifier_item_red_moon_crystal_buff:IsHidden()
    return true
end

function modifier_item_red_moon_crystal_buff:IsDebuff()
    return false
end

function modifier_item_red_moon_crystal_buff:IsPurgable()
    return false
end

function modifier_item_red_moon_crystal_buff:RemoveOnDeath()
    return false
end

function modifier_item_red_moon_crystal_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

local function is_item_in_active_inventory(item_ability)
    if not item_ability or item_ability:IsNull() then
        return false
    end
    if not item_ability.GetItemSlot then
        return true
    end

    if item_ability.GetParent then
        local holder = item_ability:GetParent()
        if holder and not holder:IsNull() and holder:GetUnitName() == "dummy" then
            return true
        end
    end

    local slot = item_ability:GetItemSlot()
    if slot == nil then
        return true
    end
    if slot == 16 then
        return true
    end
    return slot >= 0 and slot <= 5
end

local function get_lowest_active_red_moon_slot(parent)
    if not parent or parent:IsNull() or not parent.GetItemInSlot then
        return nil
    end
    local best = nil
    for slot = 0, 5 do
        local item = parent:GetItemInSlot(slot)
        if item and not item:IsNull() and item:GetAbilityName() == RED_MOON_ITEM then
            if best == nil or slot < best then
                best = slot
            end
        end
    end
    return best
end

local function is_primary_red_moon_night_vision_source(modifier)
    if not modifier:IsEnabled() then
        return false
    end
    local ability = modifier:GetAbility()
    if not ability or ability:IsNull() or not ability.GetItemSlot then
        return true
    end
    local parent = modifier:GetParent()
    if not parent or parent:IsNull() or not parent.GetItemInSlot then
        return true
    end
    local lowest = get_lowest_active_red_moon_slot(parent)
    if lowest == nil then
        return true
    end
    return ability:GetItemSlot() == lowest
end

local function get_moon_night_vision_penalty(parent)
    local nv_pen = 0
    if not parent or parent:IsNull() then
        return nv_pen
    end
    if parent:HasModifier("modifier_item_moon_shard") then
        nv_pen = nv_pen + MOON_SHARD_NV
    end
    if parent:HasModifier("modifier_item_moon_shard_consumed") then
        nv_pen = nv_pen + MOON_CONSUMED_NV
    end
    return nv_pen
end

function modifier_item_red_moon_crystal_buff:IsEnabled()
    return is_item_in_active_inventory(self:GetAbility())
end

function modifier_item_red_moon_crystal_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION_UNIQUE,
    }
end

function modifier_item_red_moon_crystal_buff:GetModifierAttackSpeedBonus_Constant()
    if not self:IsEnabled() then
        return 0
    end
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    local base = ability:GetSpecialValueFor("num1")
    return base
end

function modifier_item_red_moon_crystal_buff:GetBonusNightVisionUnique()
    if not self:IsEnabled() then
        return 0
    end
    if not is_primary_red_moon_night_vision_source(self) then
        return 0
    end
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    local base = ability:GetSpecialValueFor("num2")
    local nv_pen = get_moon_night_vision_penalty(self:GetParent())
    return math.max(0, base - nv_pen)
end

function modifier_item_red_moon_crystal_buff:OnCreated()
    if not IsServer() then
        return
    end
    self._en_snap = self:IsEnabled()
    self:StartIntervalThink(0.75)
    local parent = self:GetParent()
    if parent and not parent:IsNull() and parent:IsHero() then
        parent:CalculateStatBonus(true)
    end
end

function modifier_item_red_moon_crystal_buff:OnDestroy()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    if parent and not parent:IsNull() and parent:IsHero() then
        parent:CalculateStatBonus(true)
    end
end

function modifier_item_red_moon_crystal_buff:OnIntervalThink()
    if not IsServer() then
        return
    end
    local en = self:IsEnabled()
    if en == self._en_snap then
        return
    end
    self._en_snap = en
    local parent = self:GetParent()
    if parent and not parent:IsNull() and parent:IsHero() then
        parent:CalculateStatBonus(true)
    end
end