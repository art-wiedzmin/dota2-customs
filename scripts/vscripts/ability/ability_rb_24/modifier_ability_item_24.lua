--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_24 = class({})

function modifier_ability_item_24:IsHidden()
    return true
end

function modifier_ability_item_24:IsPurgable()
    return false
end

function modifier_ability_item_24:OnCreated()
    if not IsServer() then return end
    self:OnRefresh()
end

-- 可选：添加刷新时重新计算
function modifier_ability_item_24:OnRefresh()
    if not IsServer() then return end
    local ability = self:GetAbility()
    if not ability then
        self.attr_data = 0
        return 0 -- 必须返回默认值
    end
    local level = ability:GetLevel()
    local num = ability:GetSpecialValueFor("num1")
    local ID = Util:Hero2ID(self:GetParent())
    if ID then
        if Box:IsHaveSkill(ID, 56) and level == 10 then
            num = 80
        end
    end
    self.attr_data = num
end

-- 声明修改函数
function modifier_ability_item_24:DeclareFunctions()
    return {
        --绿字 力量加成%+力量增幅%
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        --绿字 敏捷加成%+敏捷增幅%+敏捷常数
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        --绿字 智力加成%+智力增幅%+智力常数
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

--绿字 力量加成%/力量增幅% 血量超21E有问题
function modifier_ability_item_24:GetModifierBonusStats_Strength()
    return self.attr_data
end

--绿字 敏捷加成%+敏捷增幅%+敏捷常数
function modifier_ability_item_24:GetModifierBonusStats_Agility()
    return self.attr_data
end

--绿字 智力加成%+智力增幅%+智力常数
function modifier_ability_item_24:GetModifierBonusStats_Intellect()
    return self.attr_data
end