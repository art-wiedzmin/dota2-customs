--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_bot_innate_level_base_attack = class({})

function modifier_bot_innate_level_base_attack:IsHidden()
    return true
end

function modifier_bot_innate_level_base_attack:IsDebuff()
    return false
end

function modifier_bot_innate_level_base_attack:IsPurgable()
    return false
end

function modifier_bot_innate_level_base_attack:RemoveOnDeath()
    return false
end

function modifier_bot_innate_level_base_attack:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_EVENT_ON_LEVEL_UP,
    }
end

function modifier_bot_innate_level_base_attack:OnLevelUp(kv)
    if not IsServer() then
        return
    end
    if self.ForceRefresh then
        self:ForceRefresh()
    end
end

-- 每升一级 +bot_base_attack_bonus_per_level 点基础攻击力（1 级为 0，2 级起累计）
function modifier_bot_innate_level_base_attack:GetModifierBaseAttack_BonusDamage()
    local u = self:GetParent()
    if not u or u:IsNull() or not u.GetLevel then
        return 0
    end
    local lvl = u:GetLevel() or 1
    local per = 30
    if BotAI and BotAI.Config and type(BotAI.Config.bot_base_attack_bonus_per_level) == "number" then
        per = BotAI.Config.bot_base_attack_bonus_per_level
    end
    return math.max(0, lvl - 1) * per
end
