--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_dragon_magic_immune = class({})

function modifier_dragon_magic_immune:IsHidden()
    return true
end

function modifier_dragon_magic_immune:IsDebuff()
    return false
end

function modifier_dragon_magic_immune:IsPurgable()
    return false
end

function modifier_dragon_magic_immune:RemoveOnDeath()
    return true
end

function modifier_dragon_magic_immune:CheckState()
    return {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end
