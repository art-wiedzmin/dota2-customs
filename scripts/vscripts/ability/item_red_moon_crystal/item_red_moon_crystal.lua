LinkLuaModifier("modifier_item_red_moon_crystal_buff",
    "Ability/item_red_moon_crystal/modifier_item_red_moon_crystal_buff",
    LUA_MODIFIER_MOTION_NONE)

if item_red_moon_crystal == nil then
    item_red_moon_crystal = class({})
end

function item_red_moon_crystal:GetIntrinsicModifierName()
    return "modifier_item_red_moon_crystal_buff"
end

function item_red_moon_crystal:OnChargeCountChanged(_kv)
end
