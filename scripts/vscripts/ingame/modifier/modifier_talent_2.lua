--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- if modifier_talent_2 == nil then
--     modifier_talent_2 = class({})
-- end
-- function modifier_talent_2:IsDebuff()
--     return false
-- end

-- function modifier_talent_2:IsHidden()
--     return true
-- end

-- function modifier_talent_2:RemoveOnDeath()
--     return false
-- end

-- function modifier_talent_2:IsPermanent() return true end -- 确保客户端同步

-- function modifier_talent_2:OnCreated(kv)
--     if IsServer() then
--         self:ForceRefresh()
--     end
-- end

-- -- 刷新modifier
-- function modifier_talent_2:OnRefresh(kv)
--     if not IsServer() then return end
--     local hero = self:GetParent()
--     local ID = Util:Hero2ID(hero)
--     self.lqjs = HeroData.Data[ID].hero_attr.lqjs
--     self:SetStackCount(self.lqjs)
--     hero:CalculateStatBonus(true)
-- end

-- function modifier_talent_2:GetModifierPercentageCooldown()
--     local count = self:GetStackCount()
--     return count
-- end

-- -- 注册伤害监听事件
-- function modifier_talent_2:DeclareFunctions()
--     return {
--         MODIFIER_EVENT_ON_ATTACKED, -- 监听受到伤害事件
--         MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
--         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
--     }
-- end

-- -- 处理伤害事件
-- function modifier_talent_2:OnAttacked(keys)
--     if not IsServer() then return end
--     local parent   = self:GetParent()
--     local attacker = keys.attacker
--     local target   = keys.target
--     -- 检查是否是被此单位攻击
--     if target ~= parent then
--         return
--     end
--     -- 检查攻击者是否有效
--     if not attacker or attacker:IsNull() or not attacker:IsAlive() then
--         return
--     end
--     if parent:IsHero() then
--         --如果开了bkb就无伤
--         if attacker:HasModifier("modifier_equip_1") then
--             return
--         end
--         local ID = Util:Hero2ID(parent)
--         if ID then
--             local level = Talent.Data[ID].level
--             local dam = 0
--             local num = 0
--             if level == 0 then
--                 dam = 40
--                 num = 0.2
--             end
--             if level == 1 then
--                 dam = 60
--                 num = 0.25
--             end
--             if level == 2 then
--                 dam = 80
--                 num = 0.3
--             end
--             if level == 3 then
--                 dam = 100
--                 num = 0.35
--             end
--             if level == 4 then
--                 dam = 120
--                 num = 0.4
--             end
--             if level == 5 then
--                 dam = 150
--                 num = 0.5
--             end
--             local str_dam = parent:GetStrength() * num
--             local total_dam = dam + str_dam
--             local jnzq = target:GetSpellAmplification(false)
--             local num1 = math.floor(jnzq * 100)
--             if num1 > 0 then
--                 dam = dam / (1 + (num1 / 100))
--             end
--             local no_amp = rawget(_G, "DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION")
--             if not no_amp then no_amp = 1024 end
--             local damage_table = {
--                 attacker = parent,
--                 victim = attacker,
--                 damage = total_dam,
--                 damage_type = DAMAGE_TYPE_PURE,
--                 damage_flags = no_amp,
--             }
--             local fn_enter = rawget(_G, "ClrbDmg_Filter_Talent3AuraIsolation_Enter")
--             local fn_leave = rawget(_G, "ClrbDmg_Filter_Talent3AuraIsolation_Leave")
--             if fn_enter then fn_enter() end
--             local ok2, err2 = pcall(function()
--                 ApplyDamage(damage_table)
--             end)
--             if fn_leave then fn_leave() end
--             if not ok2 then
--                 print("[modifier_talent_2] ApplyDamage: " .. tostring(err2))
--             end
--         end
--     end
-- end

-- function modifier_talent_2:GetModifierMoveSpeedBonus_Constant()
--     return 50
-- end

-- -- 荆棘者之甲：600 码内降低敌人 30% 吸血与部分治疗效果（与引擎支持的增幅项一致）
-- -- 对齐冰眼 Cold Attack ：对「生命值恢复」类效果（HpRegen/攻击吸血/法术吸血）用负向 Amplify，
-- -- items.txt item_skadi 的 restoration_reduction 在引擎内同属此类堆叠路径。
-- function modifier_talent_2:IsAura()
--     return true
-- end

-- function modifier_talent_2:GetAuraRadius()
--     return 600
-- end

-- function modifier_talent_2:GetModifierAura()
--     return "modifier_talent_2_aura_debuff"
-- end

-- function modifier_talent_2:GetAuraSearchTeam()
--     return DOTA_UNIT_TARGET_TEAM_ENEMY
-- end

-- function modifier_talent_2:GetAuraSearchType()
--     return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
-- end

-- function modifier_talent_2:GetAuraSearchFlags()
--     return DOTA_UNIT_TARGET_FLAG_NONE
-- end

-- ----------------------------------------------------------------
-- -- 光环 debuff：降低吸血 / 技能吸血 / 生命恢复与受治疗相关增幅
-- ----------------------------------------------------------------
-- if modifier_talent_2_aura_debuff == nil then
--     modifier_talent_2_aura_debuff = class({})
-- end

-- function modifier_talent_2_aura_debuff:IsDebuff()
--     return true
-- end

-- function modifier_talent_2_aura_debuff:IsHidden()
--     return false
-- end

-- function modifier_talent_2_aura_debuff:IsPurgable()
--     return false
-- end

-- function modifier_talent_2_aura_debuff:RemoveOnDeath()
--     return true
-- end

-- function modifier_talent_2_aura_debuff:DeclareFunctions()
--     return {
--         MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
--         MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
--         MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
--     }
-- end

-- -- 必须使用 CDOTA_Modifier_Lua 约定名：
-- -- MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE → GetModifierLifestealAmplify_Percentage（勿写成 LifestealRegen…）
-- -- MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE → GetModifierSpellLifestealAmplify_Percentage
-- -- function modifier_talent_2_aura_debuff:GetModifierLifestealRegenAmplify_Percentage()
-- --     return -30
-- -- end

-- -- function modifier_talent_2_aura_debuff:GetModifierSpellLifestealRegenAmplify_Percentage_Unique()
-- --     return -30
-- -- end

-- function modifier_talent_2_aura_debuff:GetModifierHPRegenAmplify_Percentage()
--     return -30
-- end

-- function modifier_talent_2_aura_debuff:GetModifierLifestealAmplify_Percentage()
--     return -30
-- end

-- function modifier_talent_2_aura_debuff:GetModifierSpellLifestealAmplify_Percentage()
--     return -30
-- end
if modifier_talent_2 == nil then
    modifier_talent_2 = class({})
end

LinkLuaModifier("modifier_talent_2_lifesteal_aura_debuff", "ingame/modifier/modifier_talent_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_talent_2_lifesteal_hit_debuff", "ingame/modifier/modifier_talent_2", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------------------
-- 主 modifier
----------------------------------------------------------------
function modifier_talent_2:IsDebuff()
    return false
end

function modifier_talent_2:IsHidden()
    return true
end

function modifier_talent_2:RemoveOnDeath()
    return false
end

function modifier_talent_2:IsPermanent()
    return true
end

function modifier_talent_2:OnCreated(kv)
    if IsServer() then
        self:ForceRefresh()
    end
end

function modifier_talent_2:OnRefresh(kv)
    if not IsServer() then
        return
    end

    local hero = self:GetParent()
    local ID = Util:Hero2ID(hero)

    if not ID then
        return
    end

    if not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return
    end

    if not HeroData.Data[ID].hero_attr then
        return
    end

    self.lqjs = HeroData.Data[ID].hero_attr.lqjs or 0
    self:SetStackCount(self.lqjs)

    hero:CalculateStatBonus(true)
end

function modifier_talent_2:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACKED, MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE}
end

function modifier_talent_2:GetModifierPercentageCooldown()
    return self:GetStackCount()
end

----------------------------------------------------------------
-- 600 范围减吸血 / 减回血光环
----------------------------------------------------------------
function modifier_talent_2:IsAura()
    return true
end

function modifier_talent_2:GetAuraRadius()
    return 600
end

function modifier_talent_2:GetModifierAura()
    return "modifier_talent_2_lifesteal_aura_debuff"
end

function modifier_talent_2:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_talent_2:GetAuraSearchType()
    -- 只给敌方英雄，不给小兵 / 野怪 / 召唤物
    return DOTA_UNIT_TARGET_HERO
end

function modifier_talent_2:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

----------------------------------------------------------------
-- 被普通攻击时触发反伤
----------------------------------------------------------------
function modifier_talent_2:OnAttacked(keys)
    if not IsServer() then
        return
    end

    local parent = self:GetParent()
    local attacker = keys.attacker
    local target = keys.target

    -- 必须是自己被攻击
    if target ~= parent then
        return
    end

    -- 攻击者无效
    if not attacker or attacker:IsNull() or not attacker:IsAlive() then
        return
    end

    -- 自己攻击自己不处理
    if attacker == parent then
        return
    end

    -- 只有英雄持有该 modifier 时才反伤
    if not parent:IsHero() then
        return
    end

    -- 如果攻击者开了 bkb / modifier_equip_1，则不反伤
    if attacker:HasModifier("modifier_equip_1") then
        return
    end

    local ID = Util:Hero2ID(parent)

    if not ID then
        return
    end

    if not Talent or not Talent.Data or not Talent.Data[ID] then
        return
    end

    local level = Talent.Data[ID].level or 0
    local dam = 0
    local num = 0

    -- 固定伤害 + 力量 × 百分比（5%→30%，每级 +5%）
    if level == 0 then
        dam = 40
        num = 0.05
    elseif level == 1 then
        dam = 60
        num = 0.1
    elseif level == 2 then
        dam = 80
        num = 0.15
    elseif level == 3 then
        dam = 100
        num = 0.2
    elseif level == 4 then
        dam = 120
        num = 0.25
    elseif level == 5 then
        dam = 150
        num = 0.3
    else
        dam = 150
        num = 0.3
    end

    local str_dam = parent:GetStrength() * num
    local total_dam = dam + str_dam

    local no_amp = rawget(_G, "DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION")
    if not no_amp then
        no_amp = 1024
    end

    local reflection_flag = rawget(_G, "DOTA_DAMAGE_FLAG_REFLECTION")
    if not reflection_flag then
        reflection_flag = 16
    end

    local final_damage_flags = no_amp + reflection_flag

    local damage_table = {
        attacker = parent,
        victim = attacker,
        damage = total_dam,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = final_damage_flags
    }

    local fn_enter = rawget(_G, "ClrbDmg_Filter_Talent3AuraIsolation_Enter")
    local fn_leave = rawget(_G, "ClrbDmg_Filter_Talent3AuraIsolation_Leave")

    if fn_enter then
        fn_enter()
    end

    local ok2, err2 = pcall(function()
        ApplyDamage(damage_table)
    end)

    if fn_leave then
        fn_leave()
    end

    if not ok2 then
        -- print("[modifier_talent_2] ApplyDamage: " .. tostring(err2))
        if Server and Server.SendError then
            Server:SendError(tostring(err2), "modifier_talent_2:ApplyDamage")
        end
    end
end

----------------------------------------------------------------
-- 自己受到伤害时，给伤害来源英雄添加 1.5 秒 debuff
----------------------------------------------------------------
function modifier_talent_2:OnTakeDamage(keys)
    if not IsServer() then
        return
    end

    local parent = self:GetParent()
    local victim = keys.unit
    local attacker = keys.attacker
    local damage = keys.damage or 0
    local damage_flags = keys.damage_flags or 0

    -- 必须是自己受到伤害
    if victim ~= parent then
        return
    end

    -- 没有实际伤害不触发
    if damage <= 0 then
        return
    end

    -- 攻击者无效
    if not attacker or attacker:IsNull() or not attacker:IsAlive() then
        return
    end

    -- 自己造成的伤害不触发
    if attacker == parent then
        return
    end

    -- 过滤反伤伤害，避免反伤再次触发 OnTakeDamage
    local reflection_flag = rawget(_G, "DOTA_DAMAGE_FLAG_REFLECTION")
    if not reflection_flag then
        reflection_flag = 16
    end

    if bit and bit.band then
        if bit.band(damage_flags, reflection_flag) ~= 0 then
            return
        end
    end

    -- 如果攻击者开了 bkb / modifier_equip_1，则不给 debuff
    if attacker:HasModifier("modifier_equip_1") then
        return
    end

    -- 只给英雄添加 1.5 秒 debuff
    if attacker:IsHero() then
        if attacker:HasModifier("modifier_talent_2_lifesteal_aura_debuff") then
            return
        end

        local debuff = attacker:FindModifierByName("modifier_talent_2_lifesteal_hit_debuff")

        if debuff then
            debuff:SetDuration(1.5, true)
        else
            attacker:AddNewModifier(parent, self:GetAbility(), "modifier_talent_2_lifesteal_hit_debuff", {
                duration = 1.5
            })
        end
    end

end

----------------------------------------------------------------
-- 600 码光环 debuff
-- 负责范围内持续减吸血 / 减回血
----------------------------------------------------------------
if modifier_talent_2_lifesteal_aura_debuff == nil then
    modifier_talent_2_lifesteal_aura_debuff = class({})
end

function modifier_talent_2_lifesteal_aura_debuff:IsDebuff()
    return true
end

function modifier_talent_2_lifesteal_aura_debuff:IsHidden()
    return false
end

function modifier_talent_2_lifesteal_aura_debuff:GetTexture()
    return "item_spirit_vessel"
end

function modifier_talent_2_lifesteal_aura_debuff:IsPurgable()
    return false
end

function modifier_talent_2_lifesteal_aura_debuff:RemoveOnDeath()
    return true
end

function modifier_talent_2_lifesteal_aura_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE, MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
            MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE}
end

function modifier_talent_2_lifesteal_aura_debuff:GetModifierLifestealAmplify_Percentage()
    return -30
end

function modifier_talent_2_lifesteal_aura_debuff:GetModifierSpellLifestealAmplify_Percentage()
    return -30
end

function modifier_talent_2_lifesteal_aura_debuff:GetModifierHPRegenAmplify_Percentage()
    return -30
end

----------------------------------------------------------------
-- 被造成伤害时触发的 1.5 秒 debuff
-- 注意：
-- 如果目标身上已经有 600 码光环 debuff，
-- 这里返回 0，避免两个 debuff 叠加成 -60%
----------------------------------------------------------------
if modifier_talent_2_lifesteal_hit_debuff == nil then
    modifier_talent_2_lifesteal_hit_debuff = class({})
end

function modifier_talent_2_lifesteal_hit_debuff:IsDebuff()
    return true
end

function modifier_talent_2_lifesteal_hit_debuff:IsHidden()
    return false
end

function modifier_talent_2_lifesteal_hit_debuff:GetTexture()
    return "item_spirit_vessel"
end

function modifier_talent_2_lifesteal_hit_debuff:IsPurgable()
    return false
end

function modifier_talent_2_lifesteal_hit_debuff:RemoveOnDeath()
    return true
end

function modifier_talent_2_lifesteal_hit_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE, MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
            MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE}
end

function modifier_talent_2_lifesteal_hit_debuff:GetModifierLifestealAmplify_Percentage()
    if self:GetParent():HasModifier("modifier_talent_2_lifesteal_aura_debuff") then
        return 0
    end

    return -30
end

function modifier_talent_2_lifesteal_hit_debuff:GetModifierSpellLifestealAmplify_Percentage()
    if self:GetParent():HasModifier("modifier_talent_2_lifesteal_aura_debuff") then
        return 0
    end

    return -30
end

function modifier_talent_2_lifesteal_hit_debuff:GetModifierHPRegenAmplify_Percentage()
    if self:GetParent():HasModifier("modifier_talent_2_lifesteal_aura_debuff") then
        return 0
    end

    return -30
end
