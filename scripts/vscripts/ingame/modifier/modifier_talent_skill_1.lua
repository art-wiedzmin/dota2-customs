--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 1：枪术——基础 +80 攻击距离；每分钟 +8（按对局时间，死亡期间同样累计）
-- 对局 15 分钟后获得分裂（同肉搏「分裂」特效，距离 650，伤害 60%）
-- Tooltip 键：DOTA_Tooltip_modifier_talent_skill_1

modifier_talent_skill_1 = class({})

local RANGE_INTERVAL = 60
local BASE_ATTACK_RANGE = 80
local RANGE_PER_MINUTE = 8

local CLEAVE_UNLOCK_MIN = 15
local CLEAVE_RANGE = 650
local CLEAVE_DAMAGE_PCT = 60
local CLEAVE_START_RADIUS = 250
local CLEAVE_PARTICLE = "particles/scrolls/hengsaoqianjun.vpcf"
local CLEAVE_SOUND = "hengsaoqianjun"

function modifier_talent_skill_1:IsHidden()
    return false
end

function modifier_talent_skill_1:IsDebuff()
    return false
end

function modifier_talent_skill_1:IsPurgable()
    return false
end

function modifier_talent_skill_1:RemoveOnDeath()
    return false
end

function modifier_talent_skill_1:IsPermanent()
    return true
end

function modifier_talent_skill_1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_RESPAWN,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_talent_skill_1:_MinuteStacks()
    return self:GetStackCount() or 0
end

function modifier_talent_skill_1:GetModifierAttackRangeBonus()
    return BASE_ATTACK_RANGE + self:_MinuteStacks() * RANGE_PER_MINUTE
end

function modifier_talent_skill_1:_IsCleaveUnlocked()
    return self.cleave_unlocked == true
end

function modifier_talent_skill_1:_TryUnlockCleave()
    if self.cleave_unlocked then
        return
    end
    local game_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
    if game_min < CLEAVE_UNLOCK_MIN then
        return
    end
    self.cleave_unlocked = true
    local p = self:GetParent()
    if not p or p:IsNull() then
        return
    end
    local pid = ClrbGetOwnerPlayerId and ClrbGetOwnerPlayerId(p) or -1
    if pid >= 0 and Util and Util.BottomMsg2ID then
        Util:BottomMsg2ID(pid, "枪术：获得分裂效果", "yellow", 3)
    end
end

function modifier_talent_skill_1:_TryAddMinuteStack()
    local p = self:GetParent()
    if not p or p:IsNull() then
        return
    end

    local now = GameRules:GetGameTime()
    if not self._last_range_time then
        self._last_range_time = now
        return
    end

    local gained = 0
    while (now - self._last_range_time) >= RANGE_INTERVAL do
        gained = gained + 1
        self._last_range_time = self._last_range_time + RANGE_INTERVAL
    end

    if gained > 0 then
        self:SetStackCount(self:GetStackCount() + gained)
        p:CalculateStatBonus(true)
    end
end

function modifier_talent_skill_1:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    if not self:_IsCleaveUnlocked() then
        return
    end
    local attacker = params.attacker
    local target = params.target
    if attacker ~= self:GetParent() then
        return
    end
    if not target or target:IsNull() then
        return
    end
    local damage = tonumber(params.damage) or 0
    if damage <= 0 then
        return
    end
    local dam = math.ceil(damage * CLEAVE_DAMAGE_PCT / 100)
    if dam <= 0 then
        return
    end

    local att_e = attacker:entindex()
    local tar_e = target:entindex()
    local ab = attacker:FindAbilityByName("ability_item_19")
    local ab_e = ab and not ab:IsNull() and ab:entindex() or -1

    Timers(0.03, function()
        local a = EntIndexToHScript(att_e)
        local t = tar_e >= 0 and EntIndexToHScript(tar_e) or nil
        if not a or a:IsNull() or not a:IsAlive() then
            return
        end
        if not t or t:IsNull() then
            return
        end
        local ab_ent = ab_e >= 0 and EntIndexToHScript(ab_e) or nil
        if ab_ent and ab_ent:IsNull() then
            ab_ent = nil
        end
        EmitSoundOn(CLEAVE_SOUND, a)
        DoCleaveAttack(a, t, ab_ent, dam, CLEAVE_START_RADIUS, CLEAVE_RANGE, CLEAVE_RANGE, CLEAVE_PARTICLE)
    end)
end

function modifier_talent_skill_1:OnRespawn()
    if not IsServer() then
        return
    end
    self:_TryUnlockCleave()
    self:_TryAddMinuteStack()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_1:OnCreated()
    if not IsServer() then
        return
    end
    self.cleave_unlocked = false
    self._last_range_time = GameRules:GetGameTime()
    self:_TryUnlockCleave()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_1:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:_TryUnlockCleave()
    self:_TryAddMinuteStack()
end

-- 当前攻击距离加成（基础 80 + 每分钟 8 × 层数）
function modifier_talent_skill_1:OnTooltip()
    return BASE_ATTACK_RANGE + self:_MinuteStacks() * RANGE_PER_MINUTE
end

function modifier_talent_skill_1:GetTexture()
    return "buff/talent_1"
end
