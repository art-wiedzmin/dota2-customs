-- 技能modifier
modifier_ability_item_14 = class({})

function modifier_ability_item_14:IsHidden()
    return true
end

function modifier_ability_item_14:IsPurgable()
    return false
end

function modifier_ability_item_14:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_14:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- 攻击命中时
function modifier_ability_item_14:OnAttackLanded(params)
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
    local ID = Util:Hero2ID(attacker)
    if not ID then
        return
    end
    local chance = 15
    local range = 350
    -- if Box:IsHaveSkill(ID, 54) then
    --     chance = 20
    --     range = 525
    -- end
    local roll = math.random(1, 100)
    if roll > chance then
        return
    end
    local num = ability:GetSpecialValueFor("num1")
    local hp_bonus_pct = ability:GetSpecialValueFor("num2")
    local enemies = utilex:GetRadiusUnit(attacker, target:GetAbsOrigin(), range, "bad")
    local path = "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf"
    EmitSoundOn("Hero_Brewmaster.ThunderClap", attacker)
    utilex:AddTx(path, target, 2)
    if enemies then
        for k, v in pairs(enemies) do
            if v then
                local maxHealth = v:GetMaxHealth()
                local damage = maxHealth * hp_bonus_pct / 100 + num
                utilex:UnitDam(attacker, v, damage, "mf", ability)
                -- if utilex:GetHeroJnxx(attacker) > 0 then
                --     local jnxx = utilex:GetHeroJnxx(attacker)
                --     local jnxx_num = math.floor(damage * jnxx / 100)
                --     attacker:Heal(jnxx_num, nil)
                -- end
            end
        end
    end
end
