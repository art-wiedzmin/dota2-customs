--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 迅捷之刃（item_goods_17 / modifier_talent_1）：普攻叠层易伤，可被驱散，不穿透魔免
if modifier_talent_1_damage_amp_debuff == nil then
    modifier_talent_1_damage_amp_debuff = class({})
end

local AMP_PER_STACK_PCT = 1
local MAX_STACKS = 999

function modifier_talent_1_damage_amp_debuff:IsHidden()
    return false
end

function modifier_talent_1_damage_amp_debuff:IsDebuff()
    return true
end

function modifier_talent_1_damage_amp_debuff:IsPurgable()
    return true
end

function modifier_talent_1_damage_amp_debuff:RemoveOnDeath()
    return true
end

function modifier_talent_1_damage_amp_debuff:GetTexture()
    return "scroll/modifier_talent_1_buff"
end

function modifier_talent_1_damage_amp_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

--- 每层 1%，与层数线性叠加（总加深 = 层数 × 1%）
function modifier_talent_1_damage_amp_debuff:GetModifierIncomingDamage_Percentage()
    local n = math.min(self:GetStackCount(), MAX_STACKS)
    return n * AMP_PER_STACK_PCT
end

function modifier_talent_1_damage_amp_debuff:OnTooltip()
    return self:GetModifierIncomingDamage_Percentage()
end

function modifier_talent_1_damage_amp_debuff:OnCreated()
    if not IsServer() then
        return
    end
    if self:GetStackCount() < 1 then
        self:SetStackCount(1)
    end
end
