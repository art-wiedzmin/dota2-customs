--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_item_11 = class({})

--是否在面板上显示
function modifier_item_11:IsHidden()
    return false
end

function modifier_item_11:IsDebuff()
    return false
end

function modifier_item_11:IsPurgable()
    return false -- 不可被驱散
end

function modifier_item_11:RemoveOnDeath()
    return false
end

function modifier_item_11:GetTexture()
    return "scroll/black_dragon_heart"
end

function modifier_item_11:AllowIllusionDuplicate()
    return true
end

--创建时设置
function modifier_item_11:OnCreated(kv)
    if not IsServer() then return end
    -- 强制属性刷新
    self:ForceRefresh()
end

function modifier_item_11:OnRefresh(kv)
    if not IsServer() then return end
    --self:ForceRefresh()
    -- self:GetParent():CalculateStatBonus(true)
end

function modifier_item_11:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
        -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE -- 技能冷却百分比减少
    }
end

function modifier_item_11:GetModifierSpellAmplify_Percentage()
    return 10
end
