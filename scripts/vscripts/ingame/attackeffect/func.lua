--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 局外背包佩戴攻击弹道特效 -> modifier_attack_effect

local MODIFIER_ATTACK_EFFECT = "modifier_attack_effect"
local ATTACK_EFFECT_SYNC_RETRY_PREFIX = "clrb_attack_effect_sync_retry_"
local ATTACK_EFFECT_SYNC_RETRY_SEC = 0.5

function AttackEffect:ResolveHero(ID)
    if not ID then
        return nil
    end
    local hero = Util and Util.ID2Hero and Util:ID2Hero(ID)
    if hero and not hero:IsNull() then
        return hero
    end
    if HeroData and HeroData.GetHero then
        hero = HeroData:GetHero(ID)
        if hero and not hero:IsNull() then
            return hero
        end
    end
    if PlayerResource and PlayerResource.GetSelectedHeroEntity then
        hero = PlayerResource:GetSelectedHeroEntity(ID)
        if hero and not hero:IsNull() then
            return hero
        end
    end
    return nil
end

function AttackEffect:ShouldShowForPlayer(ID)
    if not ID then
        return false
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return false
    end
    if Shop and Shop.ShouldShowInGameAttackEffect then
        return Shop:ShouldShowInGameAttackEffect(ID)
    end
    return false
end

function AttackEffect:IsRangedHero(hero)
    return hero and not hero:IsNull() and hero.IsRangedAttacker and hero:IsRangedAttacker()
end

function AttackEffect:RemoveAttackEffect(hero)
    if not hero or hero:IsNull() then
        return
    end
    if hero:HasModifier(MODIFIER_ATTACK_EFFECT) then
        hero:RemoveModifierByName(MODIFIER_ATTACK_EFFECT)
    end
end

function AttackEffect:ApplyAttackEffect(hero, item_key)
    if not hero or hero:IsNull() or not item_key then
        return
    end
    if not hero:IsHero() or not hero:IsRealHero() then
        return
    end
    if utilex and utilex.IsClrbCourierPet and utilex:IsClrbCourierPet(hero) then
        return
    end
    -- 背包攻击弹道（如流星火矢）仅远程英雄生效
    if not self:IsRangedHero(hero) then
        self:RemoveAttackEffect(hero)
        return
    end
    local effect_key = Shop and Shop.GetAttackEffectModifierKey and Shop:GetAttackEffectModifierKey(item_key)
    if not effect_key or effect_key == "" then
        return
    end
    local mod = hero:FindModifierByName(MODIFIER_ATTACK_EFFECT)
    if mod and mod.attack_effect_key == effect_key then
        return
    end
    self:RemoveAttackEffect(hero)
    hero:AddNewModifier(hero, nil, MODIFIER_ATTACK_EFFECT, {
        attack_effect = effect_key,
    })
end

function AttackEffect:SyncPlayer(ID)
    if not ID then
        return
    end
    local hero = self:ResolveHero(ID)
    if self:ShouldShowForPlayer(ID) then
        local key = Shop and Shop.GetEquippedAttackEffectKey and Shop:GetEquippedAttackEffectKey(ID)
        if key and hero then
            if self:IsRangedHero(hero) then
                self:ApplyAttackEffect(hero, key)
            else
                self:RemoveAttackEffect(hero)
            end
        end
        return
    end
    if hero then
        self:RemoveAttackEffect(hero)
    end
end

function AttackEffect:HasPendingAttackEffectWithoutHero()
    local seen = {}
    local function needs_retry(ID)
        if seen[ID] then
            return false
        end
        seen[ID] = true
        if not self:ShouldShowForPlayer(ID) then
            return false
        end
        return not self:ResolveHero(ID)
    end
    if PD and PD.IDs then
        for _, ID in pairs(PD.IDs) do
            if needs_retry(ID) then
                return true
            end
        end
    end
    if PlayerResource then
        for ID = 0, 23 do
            if PlayerResource:IsValidPlayer(ID) or PlayerResource:IsValidPlayerID(ID) then
                if needs_retry(ID) then
                    return true
                end
            end
        end
    end
    return false
end

function AttackEffect:SyncAll()
    local seen = {}
    local function try_sync(ID)
        if seen[ID] then
            return
        end
        seen[ID] = true
        self:SyncPlayer(ID)
    end
    if PD and PD.IDs then
        for _, ID in pairs(PD.IDs) do
            try_sync(ID)
        end
    end
    if PlayerResource then
        for ID = 0, 23 do
            if PlayerResource:IsValidPlayer(ID) or PlayerResource:IsValidPlayerID(ID) then
                try_sync(ID)
            end
        end
    end
end

function AttackEffect:ScheduleSyncRetry(_ID)
    local name = ATTACK_EFFECT_SYNC_RETRY_PREFIX .. "all"
    if Timers and Timers.timers and Timers.timers[name] then
        return
    end
    Timers:CreateTimer(name, {
        endTime = ATTACK_EFFECT_SYNC_RETRY_SEC,
        callback = function()
            if not AttackEffect then
                return
            end
            AttackEffect:SyncAll()
            if AttackEffect:HasPendingAttackEffectWithoutHero() then
                return ATTACK_EFFECT_SYNC_RETRY_SEC
            end
            return nil
        end,
        useGameTime = false,
    })
end

function AttackEffect:SyncFromOutBag(_ID)
    self:SyncAll()
    if self:HasPendingAttackEffectWithoutHero() then
        self:ScheduleSyncRetry(_ID or 0)
    end
end
