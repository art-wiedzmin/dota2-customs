--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_animation_freeze = class({})

function modifier_animation_freeze:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT +
         MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_animation_freeze:IsHidden()
  return true
end

function modifier_animation_freeze:IsDebuff() 
  return false
end

function modifier_animation_freeze:IsPurgable() 
  return false
end

function modifier_animation_freeze:CheckState() 
  local state = {
    [MODIFIER_STATE_FROZEN] = true,
  }
  return state
end



function modifier_animation_freeze:OnCreated()
    if not IsServer() then
        return
    end
end