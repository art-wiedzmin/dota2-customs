LinkLuaModifier("modifier_hero_4", "Ability/ability_hero_4/ability_hero_4",
    LUA_MODIFIER_MOTION_NONE)

ability_hero_4 = class({})

function ability_hero_4:GetIntrinsicModifierName()
    return "modifier_hero_4"
end

modifier_hero_4 = class({})

-- 添加必要的modifier函数
function modifier_hero_4:IsHidden() return true end

function modifier_hero_4:IsPurgable() return false end

function modifier_hero_4:IsDebuff() return false end

function modifier_hero_4:OnCreated()
    if not IsServer() then return end
    -- 修正：使用GetParent()而不是GetCaster()
    local hero = self:GetParent()
end

function modifier_hero_4:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_hero_4:OnAttackLanded(keys)
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
            local ab = hero:FindAbilityByName("ability_hero_4")
            local level = ab:GetLevel()
            local dam_list = { 600, 725, 800 }
            local dam = dam_list[level]
            local tx2 = "particles/events/crownfall/survivors/abilities/lina/lina_laguna_blade.vpcf"
            EmitSoundOn("Ability.LagunaBlade", attacker)
            local particle = ParticleManager:CreateParticle(tx2,
                PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(particle, 0, attacker:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle)
            utilex:UnitDam(attacker, target, dam, "mf")
        end
    end
end
