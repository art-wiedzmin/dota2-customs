--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_13 = class({})

function modifier_ability_item_13:IsHidden()
    return true
end

function modifier_ability_item_13:IsPurgable()
    return false
end

function modifier_ability_item_13:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_13:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- 攻击命中时
function modifier_ability_item_13:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local target = params.target
    if not target or target:IsNull() or not target:IsAlive() then
        return
    end
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    if not ability then
        return
    end
    local chance = 10
    local roll = math.random(1, 100)
    if roll > chance then
        return
    end
    local num1 = ability:GetSpecialValueFor("num1")
    local dmg = math.floor(num1)
    local ID = Util:Hero2ID(attacker)
    if AchieveStat and AchieveStat.Add and ID and dmg > 0 then
        AchieveStat:Add(ID, "bash_enemy", dmg)
    end
    utilex:UnitDam(attacker, target, dmg, "cc", ability)
    EmitSoundOn('Roshan.Bash', attacker)
    Util:AddStun(target, 0.1)
    target:AddNewModifier(
        attacker,
        self,
        "modifier_addbreak",
        { duration = 0.8 } -- 关键：持续0.5秒
    )
end