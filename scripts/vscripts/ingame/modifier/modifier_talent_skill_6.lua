--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 6：修仙——修为堆叠每分钟 +1（按对局时间，死亡期间同样累计）；绿字三维/生命等由 DeclareFunctions 提供
-- Tooltip 本地化键必须为 DOTA_Tooltip_modifier_talent_skill_6（Lua 类名 modifier_talent_skill_6 去掉一个 modifier_），勿写成 modifier_modifier_talent_skill_6
-- 死亡不移除 modifier；复活后重启 IntervalThink；筋斗云见 modifier_clrb_fly_cloud

require("ingame.modifier.clrb_fly_cloud_util")

modifier_talent_skill_6 = class({})

local XIUWEI_INTERVAL = 60
local FLYING_UNLOCK = ClrbFlyCloudXiuWeiUnlock or 24

function modifier_talent_skill_6:IsHidden()
    return false
end

function modifier_talent_skill_6:IsDebuff()
    return false
end

function modifier_talent_skill_6:IsPurgable()
    return false
end

function modifier_talent_skill_6:RemoveOnDeath()
    return false
end

function modifier_talent_skill_6:IsPermanent()
    return true
end

function modifier_talent_skill_6:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_RESPAWN,
    }
end

function modifier_talent_skill_6:_XiuWei()
    return self:GetStackCount() or 0
end

function modifier_talent_skill_6:GetModifierBonusStats_Strength()
    return self:_XiuWei()
end

function modifier_talent_skill_6:GetModifierBonusStats_Agility()
    return self:_XiuWei()
end

function modifier_talent_skill_6:GetModifierBonusStats_Intellect()
    return self:_XiuWei()
end

function modifier_talent_skill_6:GetModifierHealthBonus()
    return self:_XiuWei() * 50
end

function modifier_talent_skill_6:GetModifierPhysicalArmorBonus()
    return self:_XiuWei() >= 16 and 10 or 0
end

function modifier_talent_skill_6:GetModifierMagicalResistanceBonus()
    return self:_XiuWei() >= 16 and 15 or 0
end

function modifier_talent_skill_6:GetModifierMoveSpeedBonus_Constant()
    return self:_XiuWei() >= FLYING_UNLOCK and 90 or 0
end

function modifier_talent_skill_6:CheckState()
    if self:_XiuWei() < FLYING_UNLOCK then
        return {}
    end
    return {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end

function modifier_talent_skill_6:_SyncFlyCloud()
    if not IsServer() then
        return
    end
    local p = self:GetParent()
    if p and not p:IsNull() then
        ClrbFlyCloudScheduleSync(p)
    end
end

function modifier_talent_skill_6:_TryAddXiuWei()
    local p = self:GetParent()
    if not p or p:IsNull() then
        return
    end

    local now = GameRules:GetGameTime()
    if not self._last_xiuwei_time then
        self._last_xiuwei_time = now
        return
    end

    local gained = 0
    while (now - self._last_xiuwei_time) >= XIUWEI_INTERVAL do
        gained = gained + 1
        self._last_xiuwei_time = self._last_xiuwei_time + XIUWEI_INTERVAL
    end

    if gained > 0 then
        self:SetStackCount(self:GetStackCount() + gained)
        p:CalculateStatBonus(true)
        self:_SyncFlyCloud()
    end
end

function modifier_talent_skill_6:OnDestroy()
    if IsServer() then
        self:_SyncFlyCloud()
    end
end

function modifier_talent_skill_6:OnRespawn()
    if not IsServer() then
        return
    end
    self:_TryAddXiuWei()
    self:_SyncFlyCloud()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_6:OnCreated()
    if IsServer() then
        self._last_xiuwei_time = GameRules:GetGameTime()
        self:StartIntervalThink(1)
        Timers(0, function()
            if not self or self:IsNull() then
                return
            end
            self:_TryAddXiuWei()
            self:_SyncFlyCloud()
        end)
    end
end

function modifier_talent_skill_6:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:_TryAddXiuWei()
end

function modifier_talent_skill_6:OnTooltip()
    return self:_XiuWei()
end

function modifier_talent_skill_6:GetTexture()
    return "buff/talent_6"
end
