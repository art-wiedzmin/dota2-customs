--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_mfkx = class({})

function modifier_mfkx:IsDebuff()
    return false
end

function modifier_mfkx:IsPurgable()
    return false
end

function modifier_mfkx:IsHidden()
    return true
end

function modifier_mfkx:RemoveOnDeath()
    return false
end

function modifier_mfkx:OnCreated(kv)
    if not IsServer() then return end
    self.num = kv.num or 0
    self:SetStackCount(self.num * 100)
    self:ForceRefresh()
end

function modifier_mfkx:OnRefresh(kv)
    if not IsServer() then return end
    if kv.num then
        self.num = kv.num
        self:SetStackCount(self.num * 100)
    end
end

function modifier_mfkx:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_mfkx:GetModifierMagicalResistanceBonus()
    return self:GetStackCount() / 100
end

