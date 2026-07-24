-- 技能modifier
modifier_ability_item_20 = class({})

function modifier_ability_item_20:IsHidden()
    return true
end

function modifier_ability_item_20:IsPurgable()
    return false
end

function modifier_ability_item_20:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_20:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- 攻击命中时
function modifier_ability_item_20:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local target = params.target
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    if not ability then
        return
    end
    local chance = 15
    local roll = math.random(1, 100)
    if roll > chance then
        return
    end
    local ID = Util:Hero2ID(attacker)
    if not ID then
        return
    end

    local num1 = ability:GetSpecialValueFor("num1")
    local num2 = ability:GetSpecialValueFor("num2")

    local agi = attacker:GetIntellect(false) * num2 / 100
    if HeroData:IsBot(ID) then
        agi = attacker:GetBaseIntellect() * num2 / 100
    end
    local dam = math.floor(num1 + agi)
    utilex:UnitDam(attacker, target, dam, "mf", ability)
    EmitSoundOn("Hero_Zuus.LightningBolt", attacker)
    local parent = self:GetParent()
    local vec = target:GetAbsOrigin() -- 或者您想要的其他位置
    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf",
        PATTACH_WORLDORIGIN, parent)
    ParticleManager:SetParticleControl(fx, 0, vec)
    ParticleManager:SetParticleControl(fx, 1, vec + Vector(0, 0, 1000))
    ParticleManager:SetParticleControl(fx, 2, vec)
    -- 记得释放粒子资源（如果需要）
    ParticleManager:ReleaseParticleIndex(fx)
end
