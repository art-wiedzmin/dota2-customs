--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_ability_item_32", "Ability/ability_rb_32/modifier_ability_item_32",
    LUA_MODIFIER_MOTION_NONE)

ability_item_32 = class({})

function ability_item_32:GetIntrinsicModifierName()
    return "modifier_ability_item_32"
end

function ability_item_32:OnUpgrade()
    local hero = self:GetCaster()
    local ability = self
    if not hero or hero:IsNull() or not ability then
        return
    end

    if IsServer() then
        Timers(0, function()
            if hero:IsNull() then
                return
            end
            local mod = hero:FindModifierByName("modifier_ability_item_32")
            if mod then
                mod:ForceRefresh()
            end
        end)
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