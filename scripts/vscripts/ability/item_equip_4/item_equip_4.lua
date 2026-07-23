LinkLuaModifier("modifier_item_equip_4_buff",
                "Ability/item_equip_4/modifier_item_equip_4_buff",
                LUA_MODIFIER_MOTION_NONE)

if item_equip_4 == nil then item_equip_4 = class({}) end

function item_equip_4:GetIntrinsicModifierName()
    return "modifier_item_equip_4_buff"
end

function item_equip_4:OnChargeCountChanged(_kv)
end