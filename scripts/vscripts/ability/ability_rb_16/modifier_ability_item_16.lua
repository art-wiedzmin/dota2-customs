--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_16 = class({})

function modifier_ability_item_16:IsHidden()
    return true
end

function modifier_ability_item_16:IsPurgable()
    return false
end

function modifier_ability_item_16:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_16:DeclareFunctions()
    return {
        -- MODIFIER_EVENT_ON_ATTACK_LANDED,
        -- MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

-- 攻击命中时
-- function modifier_ability_item_16:OnAttackLanded(params)
--     if not IsServer() then return end
--     local attacker = params.attacker
--     local target = params.target
--     if attacker ~= self:GetParent() then
--         return
--     end
--     local ability = self:GetAbility()
--     local level = ability:GetLevel()
--     if not ability then
--         return
--     end
--     local chance = 100
--     local roll = math.random(1, 100)
--     if roll > chance then
--         return
--     end
--     -- local ab_va1 = {
--     --     level_1 = 8,
--     --     level_2 = 12,
--     --     level_3 = 16,
--     --     level_4 = 20,
--     --     level_5 = 24,
--     --     level_6 = 28,
--     --     level_7 = 32,
--     --     level_8 = 36,
--     --     level_9 = 40,
--     --     level_10 = 44,
--     -- }
--     -- local damage = params.damage
--     -- local level_key = "level_" .. level
--     -- local num1 = ab_va1[level_key]
--     -- local heal = math.floor((damage * num1 / 100))
--     -- attacker:Heal(heal, nil)
--     -- local pcf = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath_heal.vpcf"
--     -- utilex:AddTx(pcf, attacker, 0.2)
-- end

-- 伤害发生时（技能吸血）
-- function modifier_ability_item_16:OnTakeDamage(params)
--     if not IsServer() then return end

--     local attacker = params.attacker
--     local victim = params.unit
--     local damage = params.damage
--     local damage_flags = params.damage_flags or 0

--     -- 检查伤害来源是否是本Modifier的持有者
--     if attacker ~= self:GetParent() then
--         return
--     end

--     -- 排除普通攻击伤害（这部分已经在OnAttackLanded处理）
--     if params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
--         return
--     end

--     -- 检查是否为技能伤害（有inflictor且不是攻击）
--     if not params.inflictor then
--         return
--     end

--     -- 排除标记为不能技能吸血的伤害
--     if bit.band(damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= 0 then
--         return
--     end

--     local ability = self:GetAbility()
--     local level = ability:GetLevel()
--     if not ability then
--         return
--     end

--     -- 技能吸血配置表（你可以调整这些比例）
--     local spell_lifesteal_table = {
--         level_1 = 6, -- 5%技能吸血
--         level_2 = 9,
--         level_3 = 12,
--         level_4 = 15,
--         level_5 = 18,
--         level_6 = 21,
--         level_7 = 24,
--         level_8 = 27,
--         level_9 = 30,
--         level_10 = 33,
--     }

--     local chance = 100 -- 技能吸血触发概率（默认100%）
--     local roll = math.random(1, 100)
--     if roll > chance then
--         return
--     end

--     local level_key = "level_" .. level
--     local lifesteal_percent = spell_lifesteal_table[level_key] or 0

--     if lifesteal_percent <= 0 then
--         return
--     end

--     -- 计算技能吸血治疗量
--     local heal_amount = math.floor(damage * lifesteal_percent / 100)

--     -- 应用治疗
--     attacker:Heal(heal_amount, ability)

--     -- 显示治疗数字
--     SendOverheadEventMessage(
--         nil,
--         OVERHEAD_ALERT_HEAL,
--         attacker,
--         heal_amount,
--         nil
--     )

--     -- 使用不同的粒子特效区分技能吸血
--     local pcf = "particles/items3_fx/octarine_core_lifesteal.vpcf"
--     utilex:AddTx(pcf, attacker, 0.3)
-- end