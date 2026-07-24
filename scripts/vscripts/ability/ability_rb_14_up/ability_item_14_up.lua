LinkLuaModifier("modifier_ability_item_14_up", "Ability/ability_rb_14_up/modifier_ability_item_14_up",
    LUA_MODIFIER_MOTION_NONE)

-- 技能类
ability_item_14_up = class({})

function ability_item_14_up:GetIntrinsicModifierName()
    return "modifier_ability_item_14_up"
end

function ability_item_14_up:OnUpgrade()
    local hero = self:GetCaster()
    local ability = self
    if ability:GetLevel() <= 1 then
        return
    end

    if not hero:IsRealHero() then return end

    local hero_level = hero:GetLevel()
    local ability_level = ability:GetLevel()
end
