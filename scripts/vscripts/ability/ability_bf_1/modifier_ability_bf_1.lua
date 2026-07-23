--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


modifier_ability_bf_1 = class({})

function modifier_ability_bf_1:IsHidden() return true end

function modifier_ability_bf_1:IsDebuff() return false end

function modifier_ability_bf_1:IsPurgable() return false end

function modifier_ability_bf_1:GetEffectAttachType()
    return PATTACH_ROOTBONE_FOLLOW
end

function modifier_ability_bf_1:OnCreated(keys)
    if not IsServer() then return end
    local hero = self:GetParent()
    if not hero or hero:IsNull() then return end
    local ID = Util:Hero2ID(hero) -- self:OnIntervalThink(1)
    hero.KillCount = 0
    -- Timers(10,function ()

    -- end)
end

-- 声明修改函数
function modifier_ability_bf_1:DeclareFunctions()
    return {MODIFIER_EVENT_ON_DEATH}
end

function modifier_ability_bf_1:OnDeath(params)
    if not IsServer() then return end
    -- print(params)
    -- print(params.attacker:GetUnitName())
    local attacker = params.attacker
    if not attacker then return end
    local ability = self:GetAbility()
    if not ability then return end
    local hero = self:GetParent()
    local unit = params.unit
    -- 自己死亡
    if unit == self:GetParent() then
        hero.KillCount = 0
        hero:RemoveModifierByName("modifier_ability_bf_1_buff")
        return
    end
    if unit:IsHero() and attacker == hero then
        hero.KillCount = hero.KillCount + 1
        if hero.KillCount >= 10 then
            hero:AddNewModifier(hero, nil, "modifier_ability_bf_1_buff", {})
        end
        return
    end
end
