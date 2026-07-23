LinkLuaModifier("modifier_ability_bf_1",
                "Ability/ability_bf_1/modifier_ability_bf_1",
                LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_bf_1_buff",
                "Ability/ability_bf_1/modifier_ability_bf_1_buff",
                LUA_MODIFIER_MOTION_NONE)
-- 技能类
ability_bf_1 = class({})

function ability_bf_1:GetIntrinsicModifierName() return "modifier_ability_bf_1" end
