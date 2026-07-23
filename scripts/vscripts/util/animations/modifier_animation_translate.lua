--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


modifier_animation_translate = class({})
local _CODE_TO_ANIMATION_TRANSLATE=require("util.animations.code2translate")

function modifier_animation_translate:OnCreated(keys) 
  if not IsServer() then
    self.translate = _CODE_TO_ANIMATION_TRANSLATE[keys.stack_count]
  else
    self.translate = keys.translate
  end
end

function modifier_animation_translate:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_animation_translate:IsHidden()
  return true
end

function modifier_animation_translate:IsDebuff() 
  return false
end

function modifier_animation_translate:IsPurgable() 
  return false
end

function modifier_animation_translate:DeclareFunctions() 
  local funcs = {
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  }
 
  return funcs
end

function modifier_animation_translate:GetActivityTranslationModifiers(...)
  return self.translate or 0
end
