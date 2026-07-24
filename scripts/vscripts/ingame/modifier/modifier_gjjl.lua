--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_gjjl = class({})

function modifier_gjjl:IsDebuff()
    return false
end

function modifier_gjjl:IsPurgable()
    return false
end

function modifier_gjjl:IsHidden()
    return true
end

function modifier_gjjl:RemoveOnDeath()
    return false
end

function modifier_gjjl:AllowIllusionDuplicate()
    return false
end

function modifier_gjjl:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_gjjl:OnCreated(kv)
    if not IsServer() then return end
    local v = math.floor(tonumber(kv and kv.gjjl) or 0)
    if v < 0 then v = 0 end
    self:SetStackCount(v)
    self:ForceRefresh()
    local pa = self:GetParent()
    if pa then pa:CalculateStatBonus(true) end
end

function modifier_gjjl:OnRefresh(kv)
    if not IsServer() then return end
    if kv and kv.gjjl ~= nil then
        local v = math.floor(tonumber(kv.gjjl) or 0)
        if v < 0 then v = 0 end
        self:SetStackCount(v)
        local pa = self:GetParent()
        if pa then pa:CalculateStatBonus(true) end
    end
end

function modifier_gjjl:DeclareFunctions()
    return { MODIFIER_PROPERTY_ATTACK_RANGE_BONUS }
end

-- StackCount 同步到客户端，HUD 攻击距离正确
function modifier_gjjl:GetModifierAttackRangeBonus()
    return self:GetStackCount() or 0
end
