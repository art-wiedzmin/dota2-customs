modifier_animation = class({})

local _CODE_TO_ANIMATION_TRANSLATE=require("util.animations.code2translate")

function modifier_animation:OnCreated(keys) 
  if not IsServer() then return end
  self.keys = keys
  if not IsServer() then
    local stack = keys.stack_count
    local activity = bit.band(stack, 0x07FF)
    local rate = bit.rshift(bit.band(stack, 0x7F800), 11)
    local rest = bit.rshift(bit.band(stack, 0xFFF80000), 19)
    self.activity = activity
    self.rate = rate / 20 
    self.rest = rest
    self.translate = _CODE_TO_ANIMATION_TRANSLATE[self.rest]
  else
    self.translate = keys.translate
  end
end

function modifier_animation:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_animation:IsHidden()
  return true
end

function modifier_animation:IsDebuff() 
  return false
end

function modifier_animation:IsPurgable() 
  return false
end

function modifier_animation:DeclareFunctions() 
  local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  }
 
  return funcs
end

function modifier_animation:GetOverrideAnimation()
  return self.activity
end

function modifier_animation:GetOverrideAnimationRate()
  return self.rate
end

function modifier_animation:GetOverrideAnimationWeight()
  return 1
end

function modifier_animation:GetActivityTranslationModifiers()
  return self.translate or 0
end