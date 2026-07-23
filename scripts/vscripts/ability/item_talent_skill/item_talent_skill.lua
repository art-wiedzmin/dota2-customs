--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 选人天赋展示物品 item_talent_skill_1 … _9：被动占位，固定回城卷轴栏；效果由 modifier_talent_skill_* 承担

local ITEM_DEFS = {
    { "item_talent_skill_1", "talent_1" },
    { "item_talent_skill_2", "talent_2" },
    { "item_talent_skill_3", "talent_3" },
    { "item_talent_skill_4", "talent_4" },
    { "item_talent_skill_5", "talent_5" },
    { "item_talent_skill_6", "talent_6" },
    { "item_talent_skill_7", "talent_7" },
    { "item_talent_skill_8", "talent_8" },
    { "item_talent_skill_9", "talent_9" },
}

local function define_passive_talent_item(class_name, texture)
    if _G[class_name] ~= nil then
        return
    end
    local item = class({})
    item._clrb_texture = texture

    function item:OnChargeCountChanged(_kv)
    end

    function item:GetAbilityTextureName()
        return self._clrb_texture or "talent_1"
    end

    function item:GetCooldown(_iLevel)
        return 0
    end

    function item:GetManaCost(_iLevel)
        return 0
    end

    function item:IsRefreshable()
        return false
    end

    function item:CastFilterResult()
        return UF_FAIL_CUSTOM
    end

    function item:GetCustomCastError()
        return "#clrb_talent_error_passive"
    end

    function item:OnSpellStart()
    end

    _G[class_name] = item
end

for _, row in ipairs(ITEM_DEFS) do
    define_passive_talent_item(row[1], row[2])
end