--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 暴击单次 modifier：使用 Dota2 原生 MODIFIER_PREATTACK_CRITICALSTRIKE，由引擎计算伤害并显示默认暴击效果
modifier_ability_item_15_crit = class({})

function modifier_ability_item_15_crit:IsHidden() return true end

function modifier_ability_item_15_crit:IsPurgable() return false end

function modifier_ability_item_15_crit:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_ability_item_15_crit:OnCreated(kv)
    if not IsServer() then return end
    self.listkey = kv.listkey or "list1"
    self.level = kv.level or 1
end

-- 返回暴击总伤害倍率（百分比）。原设计为额外伤害 num1%，即总伤害 = 100% + num1%，这里返回 100+num1 与之一致
function modifier_ability_item_15_crit:GetModifierPreAttack_CriticalStrike()
    if not IsServer() then return 0 end
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    local level = math.min(math.max(1, tonumber(self.level) or 1), ability:GetMaxLevel())
    local key = (self.listkey == "list2" and "num2") or (self.listkey == "list3" and "num3") or "num1"
    return GetAbilitySpecialValueByLevel(ability, key, level)
end

-- 暴击只生效一次，命中后移除
function modifier_ability_item_15_crit:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() then self:Destroy() end
end