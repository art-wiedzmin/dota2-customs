--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_magic_resist_from_int = class({})

function modifier_magic_resist_from_int:IsHidden()
    return true
end

function modifier_magic_resist_from_int:IsPurgable()
    return false
end

function modifier_magic_resist_from_int:RemoveOnDeath()
    return false
end


function modifier_magic_resist_from_int:DeclareFunctions()
    return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION}
end

function modifier_magic_resist_from_int:GetModifierMagicalResistanceDirectModification()

    local parent = self:GetParent()
    -- return 20
    return parent:GetIntellect(true) * (-0.05)
end


function modifier_magic_resist_from_int:OnCreated()
    if not IsServer() then
        return
    end
end