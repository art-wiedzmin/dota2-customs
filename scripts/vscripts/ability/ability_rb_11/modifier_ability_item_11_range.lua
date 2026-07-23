--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 光环提供者modifier
modifier_ability_item_11_range = class({})

-- 是否是光环
function modifier_ability_item_11_range:IsAura()
    return true
end

-- 获取光环半径
function modifier_ability_item_11_range:GetAuraRadius()
    local ab = self:GetAbility()
    if ab and not ab:IsNull() then
        return ab:GetSpecialValueFor("aura_radius")
    end
    return 900
end

-- 获取光环modifier名称 - 修复：使用正确的名称
function modifier_ability_item_11_range:GetModifierAura()
    return "modifier_ability_item_11_effect" -- 修正为正确的名称
end

-- 获取光环搜索标志
function modifier_ability_item_11_range:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

-- 获取光环搜索队伍
function modifier_ability_item_11_range:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

-- 获取光环搜索类型
function modifier_ability_item_11_range:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-- 是否隐藏
function modifier_ability_item_11_range:IsHidden()
    return true
end

-- 是否永久
function modifier_ability_item_11_range:IsPermanent()
    return true
end

-- 是否可驱散
function modifier_ability_item_11_range:IsPurgable()
    return false
end

-- 光环名称本地化
function modifier_ability_item_11_range:GetAuraName()
    return "modifier_ability_item_11_range"
end


function modifier_ability_item_11_range:OnCreated()
    if not IsServer() then
        return
    end
end