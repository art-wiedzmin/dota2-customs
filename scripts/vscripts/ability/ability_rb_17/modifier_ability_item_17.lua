--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
local M17_NO_REFLECT_IF_SRC_ABILITY = require("Ability.ability_rb_17.m17_spiked_no_reflect")

modifier_ability_item_17 = class({})

--- 从 OnAttackLanded 解析伤害来源能力名；平 A 无附带的 ability 时返回 nil
local function m17_get_attack_source_ability_name(keys)
    if not keys then
        return nil
    end
    local h = keys.inflictor or keys.ability
    if h and not h:IsNull() and type(h.GetAbilityName) == "function" then
        local n = h:GetAbilityName()
        if n and n ~= "" then
            return n
        end
    end
    return nil
end

local function m17_is_no_reflect_source_ability(ability_name)
    if not ability_name or not M17_NO_REFLECT_IF_SRC_ABILITY then
        return false
    end
    return M17_NO_REFLECT_IF_SRC_ABILITY[ability_name] == true
end

local function m17_passives_disabled(parent)
    if not parent or parent:IsNull() or type(parent.PassivesDisabled) ~= "function" then
        return false
    end
    return parent:PassivesDisabled()
end

function modifier_ability_item_17:IsHidden()
    return true
end

function modifier_ability_item_17:IsPurgable()
    return false
end

function modifier_ability_item_17:OnCreated()
    if not IsServer() then return end
    -- 强制刷新属性
    self:ForceRefresh()
end

-- 刷新
function modifier_ability_item_17:OnRefresh()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_17:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

-- 攻击命中时
function modifier_ability_item_17:OnAttackLanded(keys)
    if not IsServer() then return end
    local parent = self:GetParent()
    if m17_passives_disabled(parent) then
        return
    end
    local attacker = keys.attacker
    local target   = keys.target
    -- 检查是否是被此单位攻击
    if target ~= parent then
        return
    end
    -- 检查攻击者是否有效
    if not attacker or attacker:IsNull() or not attacker:IsAlive() then
        return
    end
    -- 减益免疫下不反伤（不无视减益免疫）
    if attacker.IsDebuffImmune and attacker:IsDebuffImmune() then
        return
    end
    if attacker.IsMagicImmune and attacker:IsMagicImmune() then
        return
    end
    local src_ability_name = m17_get_attack_source_ability_name(keys)
    if m17_is_no_reflect_source_ability(src_ability_name) then
        return
    end
    local damage = keys.damage
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return
    end
    if parent:IsHero() then
        local ID = Util:Hero2ID(parent)
        if ID then
            local dam_num = ability:GetSpecialValueFor("num2")
            local dam = math.ceil(damage * dam_num / 100)
            local jnzq = target:GetSpellAmplification(false)
            local num = math.floor(jnzq * 100)
            if num > 0 then
                dam = dam / (1 + (num / 100))
            end
            utilex:UnitDam(parent, attacker, dam, "wl")
        end
    end
end

function modifier_ability_item_17:GetModifierPhysicalArmorBonus()
    if m17_passives_disabled(self:GetParent()) then
        return 0
    end
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 0
    end
    return ability:GetSpecialValueFor("num1")
end

-- function modifier_ability_item_17:GetEffectName()
--     return "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf"
-- end