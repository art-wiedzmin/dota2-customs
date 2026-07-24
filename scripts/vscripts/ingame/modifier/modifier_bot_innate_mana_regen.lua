--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_bot_innate_mana_regen = class({})

local MANA_REGEN_CONST = rawget(_G, "MODIFIER_PROPERTY_MANA_REGEN_CONSTANT")

function modifier_bot_innate_mana_regen:IsHidden()
    return true
end

function modifier_bot_innate_mana_regen:IsDebuff()
    return false
end

function modifier_bot_innate_mana_regen:IsPurgable()
    return false
end

function modifier_bot_innate_mana_regen:RemoveOnDeath()
    return false
end

function modifier_bot_innate_mana_regen:DeclareFunctions()
    return {
        MANA_REGEN_CONST or MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

-- 固定额外法力回复/秒；数值见 BotAI.Config.bot_innate_mana_regen_per_second（默认 50）
function modifier_bot_innate_mana_regen:GetModifierConstantManaRegen()
    local v = 50
    if BotAI and BotAI.Config and type(BotAI.Config.bot_innate_mana_regen_per_second) == "number" then
        v = BotAI.Config.bot_innate_mana_regen_per_second
    end
    return v
end
