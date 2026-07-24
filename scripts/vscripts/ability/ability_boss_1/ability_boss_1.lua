LinkLuaModifier("modifier_boss_1", "Ability/ability_boss_1/modifier_boss_1",
    LUA_MODIFIER_MOTION_NONE)

-- 技能类
ability_boss_1 = class({})

function ability_boss_1:GetIntrinsicModifierName()
    return "modifier_boss_1"
end
