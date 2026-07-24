--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 局外背包佩戴周身特效 -> modifier + vpcf

local MODIFIER_EFFECT = "modifier_clrb_effect"
local EFFECT_SYNC_RETRY_PREFIX = "clrb_effect_sync_retry_"
local EFFECT_SYNC_RETRY_SEC = 0.5

function Effect:ResolveHero(ID)
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

function Effect:ShouldShowForPlayer(ID)
    if not ID then
        return false
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return false
    end
    if Shop and Shop.ShouldShowInGameEffect then
        return Shop:ShouldShowInGameEffect(ID)
    end
    return false
end

function Effect:RemoveEffect(hero)
    if not hero or hero:IsNull() then
        return
    end
    if hero:HasModifier(MODIFIER_EFFECT) then
        hero:RemoveModifierByName(MODIFIER_EFFECT)
    end
end

--- 工具预览路径：背包未佩戴时 Sync 不应清掉预览
Effect.PreviewFxByID = Effect.PreviewFxByID or {}

function Effect:SetToolsPreview(ID, fx)
    if not ID then
        return
    end
    if fx and fx ~= "" then
        self.PreviewFxByID[ID] = fx
    else
        self.PreviewFxByID[ID] = nil
    end
end

function Effect:ClearToolsPreview(ID)
    if ID then
        self.PreviewFxByID[ID] = nil
    end
end

--- 直接按粒子路径挂周身特效；先清旧 modifier，避免叠加
function Effect:ApplyEffectFx(hero, fx)
    if not hero or hero:IsNull() or not fx or fx == "" then
        return
    end
    if not hero:IsHero() or not hero:IsRealHero() then
        return
    end
    if utilex and utilex.IsClrbCourierPet and utilex:IsClrbCourierPet(hero) then
        return
    end
    local mod = hero:FindModifierByName(MODIFIER_EFFECT)
    if mod and mod.effect_fx == fx then
        return
    end
    self:RemoveEffect(hero)
    hero:AddNewModifier(hero, nil, MODIFIER_EFFECT, { effect_fx = fx })
end

function Effect:ApplyEffect(hero, item_key)
    if not hero or hero:IsNull() or not item_key then
        return
    end
    local fx = Shop and Shop.GetEffectParticle and Shop:GetEffectParticle(item_key)
    if not fx or fx == "" then
        return
    end
    self:ApplyEffectFx(hero, fx)
end

function Effect:SyncPlayer(ID)
    if not ID then
        return
    end
    local hero = self:ResolveHero(ID)
    if self:ShouldShowForPlayer(ID) then
        -- 背包佩戴优先，清掉工具预览标记
        self:ClearToolsPreview(ID)
        local key = Shop and Shop.GetEquippedEffectKey and Shop:GetEquippedEffectKey(ID)
        if key and hero then
            self:ApplyEffect(hero, key)
        end
        return
    end
    -- 工具预览：没有背包佩戴时保留/重挂预览粒子，避免 Unequip/Sync 把预览清掉
    local preview = self.PreviewFxByID and self.PreviewFxByID[ID]
    if preview and preview ~= "" and hero and not hero:IsNull() then
        self:ApplyEffectFx(hero, preview)
        return
    end
    if hero then
        self:RemoveEffect(hero)
    end
end

function Effect:HasPendingEffectWithoutHero()
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

function Effect:SyncAll()
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

function Effect:ScheduleSyncRetry(_ID)
    local name = EFFECT_SYNC_RETRY_PREFIX .. "all"
    if Timers and Timers.timers and Timers.timers[name] then
        return
    end
    Timers:CreateTimer(name, {
        endTime = EFFECT_SYNC_RETRY_SEC,
        callback = function()
            if not Effect then
                return
            end
            Effect:SyncAll()
            if Effect:HasPendingEffectWithoutHero() then
                return EFFECT_SYNC_RETRY_SEC
            end
            return nil
        end,
        useGameTime = false,
    })
end

function Effect:SyncFromOutBag(_ID)
    self:SyncAll()
    if self:HasPendingEffectWithoutHero() then
        self:ScheduleSyncRetry(_ID or 0)
    end
end
