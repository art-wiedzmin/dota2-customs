LinkLuaModifier("modifier_ability_item_36", "Ability/ability_rb_36/modifier_ability_item_36", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_item_36_buff", "Ability/ability_rb_36/modifier_ability_item_36_buff",
    LUA_MODIFIER_MOTION_NONE)

-- 技能类
ability_item_36 = class({})

function ability_item_36:GetIntrinsicModifierName()
    return "modifier_ability_item_36"
end

function ability_item_36:OnUpgrade()
    local hero = self:GetCaster()
    local ability = self

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
