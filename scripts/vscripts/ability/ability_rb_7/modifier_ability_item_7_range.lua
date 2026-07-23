-- 光环提供者modifier
modifier_ability_item_7_range = class({})

-- 是否是光环
function modifier_ability_item_7_range:IsAura()
    return true
end

-- 获取光环半径
function modifier_ability_item_7_range:GetAuraRadius()
    local ab = self:GetAbility()
    if ab and not ab:IsNull() then
        return ab:GetSpecialValueFor("aura_radius")
    end
    return 600
end

-- 获取光环modifier名称 - 修复：使用正确的名称
function modifier_ability_item_7_range:GetModifierAura()
    return "modifier_ability_item_7_effect" -- 修正为正确的名称
end

-- 获取光环搜索标志
function modifier_ability_item_7_range:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

-- 获取光环搜索队伍
function modifier_ability_item_7_range:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

-- 获取光环搜索类型
function modifier_ability_item_7_range:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-- 是否隐藏
function modifier_ability_item_7_range:IsHidden()
    return true
end

-- 是否永久
function modifier_ability_item_7_range:IsPermanent()
    return true
end

-- 是否可驱散
function modifier_ability_item_7_range:IsPurgable()
    return false
end

-- 光环名称本地化
function modifier_ability_item_7_range:GetAuraName()
    return "modifier_ability_item_7_range"
end


function modifier_ability_item_7_range:OnCreated()
    if not IsServer() then
        return
    end
end
