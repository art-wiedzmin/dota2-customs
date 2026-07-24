--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if modifier_pet == nil then
    modifier_pet = class({})
end
function modifier_pet:IsDebuff()
    return false
end

function modifier_pet:IsHidden()
    return false
end

function modifier_pet:RemoveOnDeath()
    return true
end

function modifier_pet:OnCreated(kv)
    if not IsServer() then return end
end

function modifier_pet:OnIntervalThink()
    if not IsServer() then
        return
    end
end

function modifier_pet:OnDestroy()
    if not IsServer() then return end
end

function modifier_pet:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,                     --无敌
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,                    --没有血条
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,                -- 无视单位碰撞
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, -- 飞行
        [MODIFIER_STATE_OUT_OF_GAME] = true,                      -- 游戏外
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,       -- 不在地图向敌军显示
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] = true,     -- 允许通过悬崖峭壁
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_FISSURE] = true,    -- 允许通过裂缝路径
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,                    -- 普攻不能选中 不受到技能的物理伤害
        [MODIFIER_STATE_DISARMED] = true,                         -- 缴械 不能普攻
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,                     -- 魔免
        [MODIFIER_STATE_UNSELECTABLE] = true,                     -- 不可选中
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        -- 小地图不显示
    }
    return state
end

function modifier_pet:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    }
    return funcs
end

-- 设置固定移速加成到888
function modifier_pet:GetModifierMoveSpeedBonus_Constant()
    return 666
end

-- 或者使用绝对移速（二选一）
function modifier_pet:GetModifierMoveSpeed_Absolute()
    -- 如果使用绝对移速，取消上面的固定加成
    -- return 888
    return 666
end

-- 忽略移速上限
function modifier_pet:GetModifierIgnoreMovespeedLimit()
    return 1
end

-- 设置移速限制（可选）
function modifier_pet:GetModifierMoveSpeed_Limit()
    return 666
end
