--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 9：贪财
-- 每次攻击 +5 财富值（上限 50000，buff 层数显示）；财富值 + 当前金钱，每 1000 点 +16 攻击 +4 移速

require("ingame.modifier.modifier_clrb_talents")

modifier_talent_skill_9 = class({})

local WEALTH_PER_ATTACK = 5
local WEALTH_CAP = 50000
local ATK_PER_1000 = 16
local MS_PER_1000 = 4

function modifier_talent_skill_9:IsHidden()
    return false
end

function modifier_talent_skill_9:IsDebuff()
    return false
end

function modifier_talent_skill_9:IsPurgable()
    return false
end

function modifier_talent_skill_9:RemoveOnDeath()
    return false
end

function modifier_talent_skill_9:_PlayerId()
    local p = self:GetParent()
    if not p or p:IsNull() then
        return -1
    end
    return ClrbGetOwnerPlayerId(p)
end

function modifier_talent_skill_9:OnCreated()
    if not IsServer() then
        return
    end
    self._applied_k = 0
    self:StartIntervalThink(1)
    self:SetStackCount(0)
    self:RefreshBonusStats()
end

function modifier_talent_skill_9:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_talent_skill_9:OnIntervalThink()
    if IsServer() then
        self:RefreshBonusStats()
    end
end

function modifier_talent_skill_9:OnRefresh()
    if IsServer() then
        self:RefreshBonusStats()
    end
end

function modifier_talent_skill_9:RefreshBonusStats()
    if not IsServer() then
        return
    end
    local pid = self:_PlayerId()
    if pid < 0 or not PlayerResource then
        return
    end
    local wealth = self:GetStackCount()
    local gold = PlayerResource:GetGold(pid) or 0
    local k = math.floor((wealth + gold) / 1000)
    local old_k = self._applied_k or 0
    if k ~= old_k then
        local diff = k - old_k
        HeroData:AddSX(pid, "jcgj", diff * ATK_PER_1000)
        HeroData:AddSX(pid, "jcys", diff * MS_PER_1000)
        self._applied_k = k
    end
end

function modifier_talent_skill_9:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    local wealth = self:GetStackCount()
    if wealth < WEALTH_CAP then
        wealth = math.min(wealth + WEALTH_PER_ATTACK, WEALTH_CAP)
        self:SetStackCount(wealth)
    end
    self:RefreshBonusStats()
end

function modifier_talent_skill_9:OnTooltip()
    return self:GetStackCount()
end

function modifier_talent_skill_9:GetTexture()
    return "buff/talent_9"
end
