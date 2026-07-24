--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 局外背包佩戴称号 -> 头顶平面粒子（modifier + vpcf）

local MODIFIER_TITLE = "modifier_clrb_title"
local TITLE_ATTACH_TIMER_PREFIX = "clrb_title_attach_"
local TITLE_SYNC_RETRY_PREFIX = "clrb_title_sync_retry_"
local TITLE_SYNC_RETRY_SEC = 0.5

function Title:AttachTimerName(hero)
    if not hero or hero:IsNull() then
        return nil
    end
    return TITLE_ATTACH_TIMER_PREFIX .. tostring(hero:GetEntityIndex())
end

function Title:CancelPendingAttach(hero)
    if not hero or hero:IsNull() or not Timers then
        return
    end
    local name = self:AttachTimerName(hero)
    if name then
        Timers:RemoveTimer(name)
    end
end

function Title:ResolveHero(ID)
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

function Title:ShouldShowForPlayer(ID)
    if not ID then
        return false
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return false
    end
    if Shop and Shop.ShouldShowInGameTitle then
        return Shop:ShouldShowInGameTitle(ID)
    end
    return false
end

function Title:RemoveAllTitleModifiers(hero)
    if not hero or hero:IsNull() then
        return
    end
    local guard = 0
    while hero:HasModifier(MODIFIER_TITLE) and guard < 8 do
        hero:RemoveModifierByName(MODIFIER_TITLE)
        guard = guard + 1
    end
end

function Title:RemoveTitle(hero)
    if not hero or hero:IsNull() then
        return
    end
    self._appliedKey = self._appliedKey or {}
    self._forcePreview = self._forcePreview or {}
    local entIdx = hero:GetEntityIndex()
    self._appliedKey[entIdx] = nil
    self._forcePreview[entIdx] = nil
    self:CancelPendingAttach(hero)
    self:RemoveAllTitleModifiers(hero)
end

function Title:ApplyTitle(hero, item_key, playerID, force_preview)
    if not hero or hero:IsNull() or not item_key then
        return
    end
    if not IsServer() then
        return
    end
    local fx = Shop and Shop.GetTitleParticle and Shop:GetTitleParticle(item_key)
    if not fx or fx == "" then
        return
    end
    self._appliedKey = self._appliedKey or {}
    local entIdx = hero:GetEntityIndex()
    if not force_preview and self._appliedKey[entIdx] == item_key and hero:HasModifier(MODIFIER_TITLE) then
        return
    end

    self:RemoveTitle(hero)

    local function attach()
        if hero:IsNull() then
            return
        end
        if not force_preview and playerID and Shop and Shop.GetEquippedTitleKey then
            local currentKey = Shop:GetEquippedTitleKey(playerID)
            if currentKey ~= item_key then
                return
            end
        end
        Title:RemoveAllTitleModifiers(hero)
        hero:AddNewModifier(hero, nil, MODIFIER_TITLE, {
            title_fx = fx,
            item_key = item_key,
        })
        Title._appliedKey = Title._appliedKey or {}
        Title._appliedKey[entIdx] = item_key
        if force_preview then
            Title._forcePreview = Title._forcePreview or {}
            Title._forcePreview[entIdx] = item_key
        end
    end

    local timerName = self:AttachTimerName(hero)
    if Timers and timerName then
        Timers:CreateTimer(timerName, {
            endTime = 0,
            useGameTime = false,
            callback = attach,
        })
    else
        attach()
    end
end

function Title:SyncPlayer(ID)
    if not ID then
        return
    end
    local hero = self:ResolveHero(ID)
    if hero and not hero:IsNull() then
        local entIdx = hero:GetEntityIndex()
        if self._forcePreview and self._forcePreview[entIdx] then
            return
        end
    end
    if self:ShouldShowForPlayer(ID) then
        local key = Shop and Shop.GetEquippedTitleKey and Shop:GetEquippedTitleKey(ID)
        if key and hero then
            self:ApplyTitle(hero, key, ID)
        end
        return
    end
    if hero then
        self:RemoveTitle(hero)
    end
end

function Title:HasPendingTitleWithoutHero()
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

function Title:SyncAll()
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

function Title:ScheduleSyncRetry(_ID)
    local name = TITLE_SYNC_RETRY_PREFIX .. "all"
    if Timers and Timers.timers and Timers.timers[name] then
        return
    end
    Timers:CreateTimer(name, {
        endTime = TITLE_SYNC_RETRY_SEC,
        callback = function()
            if not Title then
                return
            end
            Title:SyncAll()
            if Title:HasPendingTitleWithoutHero() then
                return TITLE_SYNC_RETRY_SEC
            end
            return nil
        end,
        useGameTime = false,
    })
end

function Title:SyncFromOutBag(ID)
    if ID then
        self:SyncPlayer(ID)
    else
        self:SyncAll()
    end
    if self:HasPendingTitleWithoutHero() then
        self:ScheduleSyncRetry(ID or 0)
    end
end
