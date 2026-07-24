--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_ability_item_33", "Ability/ability_rb_33/modifier_ability_item_33", LUA_MODIFIER_MOTION_NONE)

-- 技能类
ability_item_33 = class({})

--- 引擎对被动 intrinsic 的属性刷新偶有滞后：升级后下一帧 ForceRefresh + 重算属性，确保冷却减免/法力回复立刻生效
local function abi33_defer_modifier_refresh(hero)
    if not IsServer() or not hero or hero:IsNull() then
        return
    end
    Timers(0, function()
        if hero:IsNull() then
            return
        end
        local mod = hero:FindModifierByName("modifier_ability_item_33")
        if mod then
            mod:ForceRefresh()
        end
        if hero.CalculateStatBonus then
            hero:CalculateStatBonus(true)
        end
    end)
end

function ability_item_33:GetIntrinsicModifierName()
    return "modifier_ability_item_33"
end

function ability_item_33:OnUpgrade()
    local hero = self:GetCaster()
    abi33_defer_modifier_refresh(hero)
    local ability = self

    if IsServer() and MainGame and MainGame.IsPassiveModeBannedPurchaseItem
        and MainGame:IsPassiveModeBannedPurchaseItem("item_skill_33") then
        local lv = ability:GetLevel()
        if lv > 1 then
            ability:SetLevel(1)
            hero:SetAbilityPoints(hero:GetAbilityPoints() + (lv - 1))
            local ID = Util:Hero2ID(hero)
            if ID then
                Util:BottomMsg2ID(ID, "被动模式下不可升级法力精研", "yellow", 1)
            end
            return
        end
    end

    if ability:GetLevel() <= 1 then
        return
    end

    if not hero:IsRealHero() then
        return
    end

    local hero_level = hero:GetLevel()
    local ability_level = ability:GetLevel()

    if ability_level > hero_level then
        local ID = Util:Hero2ID(hero)
        Util:BottomMsg2ID(ID, "技能等级不能超过英雄等级")
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
        ability:SetLevel(ability:GetLevel() - 1)
    end
end