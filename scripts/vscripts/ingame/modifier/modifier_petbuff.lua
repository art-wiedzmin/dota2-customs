--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if modifier_petbuff == nil then
    modifier_petbuff = class({})
end
function modifier_petbuff:IsDebuff()
    return false
end

function modifier_petbuff:IsHidden()
    return false
end

function modifier_petbuff:RemoveOnDeath()
    return false
end

function modifier_petbuff:OnCreated(kv)
    if not IsServer() then return end
end

function modifier_petbuff:OnIntervalThink()
    if not IsServer() then
        return
    end
end

function modifier_petbuff:OnDestroy()
    if not IsServer() then return end
end

function modifier_petbuff:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,                -- 无视单位碰撞
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, -- 飞行
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] = true,     -- 允许通过悬崖峭壁
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,                    -- 普攻不能选中 不受到技能的物理伤害
        [MODIFIER_STATE_DISARMED] = true,                         -- 缴械 不能普攻
        [MODIFIER_STATE_SILENCED] = true,                         -- 沉默 不能施法
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,                     -- 魔免
        [MODIFIER_STATE_UNSELECTABLE] = true,                     -- 不可选中
        [MODIFIER_STATE_OUT_OF_GAME] = true,                      -- 游戏外
    }
    return state
end

function modifier_petbuff:DeclareFunctions()
    local funcs = {
        --MODIFIER_PROPERTY_MIN_HEALTH
    }
    return funcs
end
