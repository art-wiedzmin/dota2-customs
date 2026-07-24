--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 宝箱「极」：+60 主属性（绿字）；万能属性英雄三维各 +60
modifier_box_47 = class({})

local BONUS = 60

function modifier_box_47:IsHidden()
    return true
end

function modifier_box_47:IsDebuff()
    return false
end

function modifier_box_47:IsPurgable()
    return false
end

function modifier_box_47:RemoveOnDeath()
    return false
end

function modifier_box_47:AllowIllusionDuplicate()
    return false
end

function modifier_box_47:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:RefreshBonuses()
end

function modifier_box_47:RefreshBonuses()
    local hero = self:GetParent()
    self.bonus_str = 0
    self.bonus_agi = 0
    self.bonus_int = 0
    if not hero or hero:IsNull() then
        return
    end
    local pa = hero:GetPrimaryAttribute()
    if pa == DOTA_ATTRIBUTE_STRENGTH then
        self.bonus_str = BONUS
    elseif pa == DOTA_ATTRIBUTE_AGILITY then
        self.bonus_agi = BONUS
    elseif pa == DOTA_ATTRIBUTE_INTELLECT then
        self.bonus_int = BONUS
    else
        -- 万能属性：三维各 +60（与 apex 对万能英雄的处理一致）
        self.bonus_str = BONUS
        self.bonus_agi = BONUS
        self.bonus_int = BONUS
    end
end

function modifier_box_47:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_box_47:GetModifierBonusStats_Strength()
    return self.bonus_str or 0
end

function modifier_box_47:GetModifierBonusStats_Agility()
    return self.bonus_agi or 0
end

function modifier_box_47:GetModifierBonusStats_Intellect()
    return self.bonus_int or 0
end
