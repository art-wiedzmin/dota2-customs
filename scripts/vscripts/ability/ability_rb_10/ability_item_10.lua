LinkLuaModifier("modifier_ability_item_10_range", "Ability/ability_rb_10/modifier_ability_item_10_range",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_item_10_effect", "Ability/ability_rb_10/modifier_ability_item_10_effect",
    LUA_MODIFIER_MOTION_NONE)

-- 光环技能类
ability_item_10 = class({})

-- 获取固有modifier名称
function ability_item_10:GetIntrinsicModifierName()
    return "modifier_ability_item_10_range"
end

-- 预加载资源
function ability_item_10:Precache(context)

end

function ability_item_10:OnUpgrade()
    local hero = self:GetCaster()
    local ability = self
    if ability:GetLevel() <= 1 then
    	return
    end

    if not hero:IsRealHero() then return end

    local hero_level = hero:GetLevel()
    local ability_level = ability:GetLevel()

    if ability_level > hero_level then
        local ID = Util:Hero2ID(hero)
        Util:BottomMsg2ID(ID, "技能等级不能超过英雄等级")
    	hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
    	ability:SetLevel(ability:GetLevel() - 1)
    end
end