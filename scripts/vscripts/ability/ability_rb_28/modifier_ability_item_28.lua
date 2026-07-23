--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_28 = class({})

function modifier_ability_item_28:IsHidden()
    return true
end

function modifier_ability_item_28:IsPurgable()
    return false
end

function modifier_ability_item_28:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_28:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- 攻击命中时
function modifier_ability_item_28:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local target = params.target
    if attacker ~= self:GetParent() then
        return
    end
    if target:IsHero() or Monster:IsPlunderExcluded(target:GetUnitName()) then
        return
    end
    local ID = Util:Hero2ID(attacker)
    local ability = self:GetAbility()
    if not ability then
        return
    end
    local chance = 100
    local roll = math.random(1, 100)
    if roll > chance then
        return
    end
    local num1 = ability:GetSpecialValueFor("num1")
    local num2 = ability:GetSpecialValueFor("num2")
    local gold = math.ceil(num1 + (num2 * target:GetMaxHealth() / 100))
    attacker:ModifyGold(gold, false, 0)
    if AchieveStat and AchieveStat.Add and ID then
        AchieveStat:Add(ID, "plunder_gold", gold)
    end
    local init_data = ID and InitPlayer:GetPlayerData(ID)
    local is_pseudo_bot = init_data and init_data.bot or false
    if not is_pseudo_bot then
        SendOverheadEventMessage(
            PlayerResource:GetPlayer(ID),
            OVERHEAD_ALERT_GOLD,
            attacker,
            gold,
            attacker:GetPlayerOwner()
        )
    end
end