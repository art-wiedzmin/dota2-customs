--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 4：守卫——初始 -20% 攻击力加成、+12% 生命增幅；每分钟额外 -2% / +1%；
-- 对局 15 分钟后获得 5% 最终减伤
-- Tooltip 键：DOTA_Tooltip_modifier_talent_skill_4

require("ingame.modifier.modifier_clrb_talents")

modifier_talent_skill_4 = class({})

local MINUTE_INTERVAL = 60
local BASE_GJJC = -20
local BASE_SMZF = 12
local GJJC_PER_MINUTE = -2
local SMZF_PER_MINUTE = 1
local ZZJS_UNLOCK_MIN = 15
local ZZJS_BONUS = 5

function modifier_talent_skill_4:IsHidden()
    return false
end

function modifier_talent_skill_4:IsDebuff()
    return false
end

function modifier_talent_skill_4:IsPurgable()
    return false
end

function modifier_talent_skill_4:RemoveOnDeath()
    return false
end

function modifier_talent_skill_4:IsPermanent()
    return true
end

function modifier_talent_skill_4:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
        MODIFIER_EVENT_ON_RESPAWN,
    }
end

function modifier_talent_skill_4:_PlayerId()
    if self._bound_player_id and self._bound_player_id >= 0 then
        return self._bound_player_id
    end
    local p = self:GetParent()
    if not p or p:IsNull() then
        return -1
    end
    return ClrbGetOwnerPlayerId(p)
end

function modifier_talent_skill_4:_CurrentGjjcBonus()
    return BASE_GJJC + (self:GetStackCount() or 0) * GJJC_PER_MINUTE
end

function modifier_talent_skill_4:_CurrentSmzfBonus()
    return BASE_SMZF + (self:GetStackCount() or 0) * SMZF_PER_MINUTE
end

function modifier_talent_skill_4:_ApplyStatDelta(gjjc_delta, smzf_delta)
    local pid = self:_PlayerId()
    if pid < 0 or not HeroData or not HeroData.AddSX then
        return
    end
    if gjjc_delta and gjjc_delta ~= 0 then
        HeroData:AddSX(pid, "gjjc", gjjc_delta)
        self.applied_gjjc = (self.applied_gjjc or 0) + gjjc_delta
    end
    if smzf_delta and smzf_delta ~= 0 then
        HeroData:AddSX(pid, "smzf", smzf_delta)
        self.applied_smzf = (self.applied_smzf or 0) + smzf_delta
    end
end

function modifier_talent_skill_4:_TryGrantZzjs()
    if self._zzjs_granted then
        return
    end
    local game_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
    if game_min < ZZJS_UNLOCK_MIN then
        return
    end
    local pid = self:_PlayerId()
    if pid < 0 or not HeroData or not HeroData.AddSX then
        return
    end
    self._zzjs_granted = true
    HeroData:AddSX(pid, "zzjs", ZZJS_BONUS)
    self.applied_zzjs = ZZJS_BONUS
end

function modifier_talent_skill_4:_RevertAllStats()
    if not IsServer() then
        return
    end
    local pid = self:_PlayerId()
    if pid < 0 or not HeroData or not HeroData.AddSX then
        return
    end
    local gjjc = self.applied_gjjc or 0
    local smzf = self.applied_smzf or 0
    local zzjs = self.applied_zzjs or 0
    if gjjc ~= 0 then
        HeroData:AddSX(pid, "gjjc", -gjjc)
    end
    if smzf ~= 0 then
        HeroData:AddSX(pid, "smzf", -smzf)
    end
    if zzjs ~= 0 then
        HeroData:AddSX(pid, "zzjs", -zzjs)
    end
    self.applied_gjjc = 0
    self.applied_smzf = 0
    self.applied_zzjs = 0
    self._zzjs_granted = false
end

function modifier_talent_skill_4:_TryAddMinuteStack()
    local p = self:GetParent()
    if not p or p:IsNull() then
        return
    end

    local now = GameRules:GetGameTime()
    if not self._last_minute_time then
        self._last_minute_time = now
        return
    end

    local gained = 0
    while (now - self._last_minute_time) >= MINUTE_INTERVAL do
        gained = gained + 1
        self._last_minute_time = self._last_minute_time + MINUTE_INTERVAL
    end

    if gained > 0 then
        self:SetStackCount(self:GetStackCount() + gained)
        self:_ApplyStatDelta(gained * GJJC_PER_MINUTE, gained * SMZF_PER_MINUTE)
        p:CalculateStatBonus(true)
    end
end

function modifier_talent_skill_4:OnRespawn()
    if not IsServer() then
        return
    end
    self:_TryAddMinuteStack()
    self:_TryGrantZzjs()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_4:OnCreated(kv)
    if not IsServer() then
        return
    end
    self._bound_player_id = kv and tonumber(kv.player_id) or -1
    self.applied_gjjc = 0
    self.applied_smzf = 0
    self.applied_zzjs = 0
    self._zzjs_granted = false
    self._last_minute_time = GameRules:GetGameTime()
    self:SetStackCount(0)
    self:_ApplyStatDelta(BASE_GJJC, BASE_SMZF)
    self:_TryGrantZzjs()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_4:OnDestroy()
    if not IsServer() then
        return
    end
    self:_RevertAllStats()
end

function modifier_talent_skill_4:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:_TryAddMinuteStack()
    self:_TryGrantZzjs()
end

function modifier_talent_skill_4:OnTooltip()
    return self:_CurrentSmzfBonus()
end

function modifier_talent_skill_4:OnTooltip2()
    return -self:_CurrentGjjcBonus()
end

function modifier_talent_skill_4:GetTexture()
    return "buff/talent_4"
end
