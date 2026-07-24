--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_hero_1", "Ability/ability_hero_1/ability_hero_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_finger_death_add", "Ability/ability_hero_1/ability_hero_1",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_1_buff", "Ability/ability_hero_1/ability_hero_1", LUA_MODIFIER_MOTION_NONE)

ability_hero_1 = class({})

function ability_hero_1:GetIntrinsicModifierName()
    return "modifier_hero_1"
end

modifier_hero_1 = class({})

-- 添加必要的modifier函数
function modifier_hero_1:IsHidden() return true end

function modifier_hero_1:IsPurgable() return false end

function modifier_hero_1:IsDebuff() return false end

function modifier_hero_1:OnDestroy()
    if not IsServer() then return end
    local hero = self:GetParent()
    if hero:HasModifier("modifier_hero_1_buff") then
        hero:RemoveModifierByName("modifier_hero_1_buff")
    end
end

function modifier_hero_1:OnCreated()
    if not IsServer() then return end
    -- 修正：使用GetParent()而不是GetCaster()
    local hero = self:GetParent()
end

function modifier_hero_1:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_hero_1:OnAttackLanded(keys)
    if not IsServer() then return end

    -- 检查攻击者是否是拥有此modifier的英雄
    if keys.attacker == self:GetParent() then
        local attacker = self:GetParent()
        local target = keys.target
        -- 检查目标是否有效
        if not target or target:IsNull() or not target:IsAlive() then
            return
        end
        if math.random(1, 100) <= 15 then
            local hero = attacker
            local ab = hero:FindAbilityByName("ability_hero_1")
            local level = ab:GetLevel()
            local add_damge = 0
            local modi = hero:FindModifierByName("modifier_hero_1_buff")
            if modi then
                local num = modi:GetStackCount()
                add_damge = num * 40
            end
            local tx2 = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
            EmitSoundOn("Hero_Lion.FingerOfDeath", attacker)
            if hero:HasModifier("modifier_item_ultimate_scepter") then
                --print("神杖大")
                local dam_list = { 700, 825, 950 }
                local dam = dam_list[level] + add_damge
                local range = 325
                local units = utilex:GetRadiusUnit(hero, target:GetAbsOrigin(), range, "bad")

                if units then
                    for k, v in pairs(units) do
                        if v then
                            local particle = ParticleManager:CreateParticle(tx2,
                                PATTACH_CUSTOMORIGIN, nil)
                            ParticleManager:SetParticleControl(particle, 0, attacker:GetAbsOrigin())
                            ParticleManager:SetParticleControl(particle, 1, v:GetAbsOrigin())
                            ParticleManager:SetParticleControl(particle, 2, v:GetAbsOrigin())
                            ParticleManager:ReleaseParticleIndex(particle)
                            utilex:UnitDam(attacker, v, dam, "mf")
                            if v:IsHero() then
                                local debuff = target:AddNewModifier(
                                    attacker,
                                    self:GetAbility(),
                                    "modifier_finger_death_add",
                                    {
                                        duration = 3,
                                        unit = attacker
                                    }
                                )
                            end
                        end
                    end
                end
            else
                local dam_list = { 600, 725, 800 }
                local dam = dam_list[level] + add_damge
                local particle = ParticleManager:CreateParticle(tx2,
                    PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(particle, 0, attacker:GetAbsOrigin())
                ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
                ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(particle)
                utilex:UnitDam(attacker, target, dam, "mf")
                if target:IsHero() then
                    local debuff = target:AddNewModifier(
                        attacker,
                        self:GetAbility(),
                        "modifier_finger_death_add",
                        {
                            duration = 3,
                            unit = attacker
                        }
                    )
                end
            end
        end
    end
end

modifier_finger_death_add = class({})

function modifier_finger_death_add:IsHidden()
    return false
end

function modifier_finger_death_add:IsDebuff()
    return true
end

function modifier_finger_death_add:IsPurgable()
    return false -- 可以被驱散
end

function modifier_finger_death_add:RemoveOnDeath()
    return false
end

function modifier_finger_death_add:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_finger_death_add:OnDeath(params)
    if not IsServer() then return end
    -- print("死亡触发")
    -- print(params)
    local unit = params.attacker
    -- print(unit:GetUnitName())
    if unit:HasAbility("ability_hero_1") then
        local ability = unit:FindAbilityByName("ability_hero_1")
        -- 给目标添加buff
        local buff_name = "modifier_hero_1_buff"
        -- 检查目标是否已经有debuff
        local existing_debuff = unit:FindModifierByName(buff_name)
        if existing_debuff then
            -- 如果已有debuff，增加层数（不超过最大层数）
            local current_stacks = existing_debuff:GetStackCount()
            if current_stacks < 1000 then
                existing_debuff:IncrementStackCount()
            end
            -- 刷新持续时间
            existing_debuff:ForceRefresh()
        else
            -- 如果没有debuff，创建新的
            local buff = unit:AddNewModifier(
                unit,
                ability,
                buff_name,
                {}
            )
            if buff then
                buff:SetStackCount(1)
            end
        end
    end
end

function modifier_finger_death_add:OnCreated(params)
    if not IsServer() then return end
end

function modifier_finger_death_add:OnRefresh(params)
    if not IsServer() then return end
    -- 刷新时不需要做额外操作
end

-- 状态图标
function modifier_finger_death_add:GetTexture()
    return "scroll/ability_hero_1"
end

-- 减甲debuff modifier
modifier_hero_1_buff = class({})

function modifier_hero_1_buff:IsHidden()
    return false
end

function modifier_hero_1_buff:IsDebuff()
    return false
end

function modifier_hero_1_buff:IsPurgable()
    return false -- 可以被驱散
end

function modifier_hero_1_buff:RemoveOnDeath()
    return false
end

function modifier_hero_1_buff:OnCreated(params)
    if not IsServer() then return end

    -- 如果从现有modifier创建，获取堆叠信息
    if self:GetStackCount() == 0 then
        self:SetStackCount(1)
    end
end

function modifier_hero_1_buff:OnRefresh(params)
    if not IsServer() then return end
    -- 刷新时不需要做额外操作
end

-- 声明修改函数
function modifier_hero_1_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

-- 工具提示2：显示层数
function modifier_hero_1_buff:OnTooltip2()
    return self:GetStackCount()
end

-- 状态图标
function modifier_hero_1_buff:GetTexture()
    return "scroll/ability_hero_1"
end