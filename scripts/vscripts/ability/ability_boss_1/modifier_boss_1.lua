-- 技能modifier
modifier_boss_1 = class({})

function modifier_boss_1:IsHidden()
    return true
end

function modifier_boss_1:IsPurgable()
    return false
end

function modifier_boss_1:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_boss_1:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- 攻击命中时
function modifier_boss_1:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local target = params.target
    if attacker ~= self:GetParent() then
        return
    end
    if not target:IsHero() then
        return
    end
    local ability = self:GetAbility()
    local level = ability:GetLevel()
    if not ability then
        return
    end
    local chance = 5
    local roll = math.random(1, 100)
    if roll > chance then
        return
    end
    local player_id = Util:Hero2ID(target)
    local palyer_name = PlayerResource:GetPlayerName(player_id)
    local text = "不自量力的" .. palyer_name .. "被风暴领主一脚踢死！"
    Util:TopMsg2All(text, "red", 3)
    local dam = target:GetMaxHealth() * 2
    utilex:UnitDam(attacker, target, dam, "cc")
end
