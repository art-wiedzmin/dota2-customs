--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 光环提供者modifier
modifier_ability_item_4_range = class({})

-- 是否是光环
function modifier_ability_item_4_range:IsAura()
    return true
end

-- 获取光环半径
function modifier_ability_item_4_range:GetAuraRadius()
    local ab = self:GetAbility()
    if ab and not ab:IsNull() then
        return ab:GetSpecialValueFor("aura_radius")
    end
    return 600
end

-- 获取光环modifier名称 - 修复：使用正确的名称
function modifier_ability_item_4_range:GetModifierAura()
    return "modifier_ability_item_4_effect" -- 修正为正确的名称
end

-- 获取光环搜索标志
function modifier_ability_item_4_range:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

-- 获取光环搜索队伍
function modifier_ability_item_4_range:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

-- 获取光环搜索类型
function modifier_ability_item_4_range:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-- 是否隐藏
function modifier_ability_item_4_range:IsHidden()
    return true
end

-- 是否永久
function modifier_ability_item_4_range:IsPermanent()
    return true
end

-- 是否可驱散
function modifier_ability_item_4_range:IsPurgable()
    return false
end


function modifier_ability_item_4_range:OnCreated()
    if not IsServer() then
        return
    end
end