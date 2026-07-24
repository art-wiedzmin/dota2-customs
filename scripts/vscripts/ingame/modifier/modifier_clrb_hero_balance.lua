--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 英雄强度：开局从服务端拉取的造成/受到伤害调整（仅玩家英雄）
-- damage_dealt_pct：造成伤害提高%（可为负）
-- damage_taken_reduce_pct：受到伤害减少%（可为负；正数=少受伤）

modifier_clrb_hero_balance = class({})

function ClrbHeroBalanceGetConfig(hero_index)
    if not hero_index or not Server or not Server.HeroBalanceById then
        return nil
    end
    return Server.HeroBalanceById[tonumber(hero_index)]
end

function ClrbHeroBalanceResolveHeroIndex(ID, hero)
    -- 优先用单位名反查 SelectHero.index（比 InitPlayer 缓存更稳）
    if hero and not hero:IsNull() and Book and Book.GetHeroID then
        local idx = Book:GetHeroID(hero:GetUnitName())
        if idx and tonumber(idx) and tonumber(idx) > 0 then
            return tonumber(idx)
        end
    end
    if InitPlayer and InitPlayer.GetPlayerData then
        local ip = InitPlayer:GetPlayerData(ID)
        if ip and ip.hero_index and tonumber(ip.hero_index) and tonumber(ip.hero_index) > 0 then
            return tonumber(ip.hero_index)
        end
    end
    return nil
end

--- 伤害过滤器遗留接口（造成伤害已改由 TOTALDAMAGEOUTGOING；保留避免旧调用报错）
function ClrbHeroBalanceApplyOutgoingDamage(_attacker, damage)
    return damage
end

function ClrbHeroBalanceEnsureOnHero(ID, hero)
    if not IsServer() then
        return
    end
    if not ID or not hero or hero:IsNull() then
        return
    end
    if not hero.IsRealHero or not hero:IsRealHero() then
        return
    end
    -- 仅真人玩家英雄（不含人机）
    if HeroData and HeroData.IsBot and HeroData:IsBot(ID) then
        return
    end
    if InitPlayer and InitPlayer.GetPlayerData then
        local ip = InitPlayer:GetPlayerData(ID)
        if ip and ip.bot then
            return
        end
    end

    -- 配置尚未返回时短延迟重试
    if not Server or (not Server.HeroBalanceLoaded and Server._heroBalanceRequesting) then
        if Timers then
            Timers(1, function()
                if hero and not hero:IsNull() then
                    ClrbHeroBalanceEnsureOnHero(ID, hero)
                end
                return nil
            end)
        end
        return
    end
    if not Server.HeroBalanceLoaded then
        -- 尚未发起拉取时也等一下（极端时序）
        if Timers then
            Timers(1, function()
                if hero and not hero:IsNull() then
                    ClrbHeroBalanceEnsureOnHero(ID, hero)
                end
                return nil
            end)
        end
        return
    end

    local hero_index = ClrbHeroBalanceResolveHeroIndex(ID, hero)
    local cfg = ClrbHeroBalanceGetConfig(hero_index)
    if not cfg then
        if hero:HasModifier("modifier_clrb_hero_balance") then
            hero:RemoveModifierByName("modifier_clrb_hero_balance")
        end
        return
    end

    local dealt = tonumber(cfg.damage_dealt_pct) or 0
    local taken_reduce = tonumber(cfg.damage_taken_reduce_pct) or 0
    if dealt == 0 and taken_reduce == 0 then
        if hero:HasModifier("modifier_clrb_hero_balance") then
            hero:RemoveModifierByName("modifier_clrb_hero_balance")
        end
        return
    end

    local m = hero:FindModifierByName("modifier_clrb_hero_balance")
    if not m then
        hero:AddNewModifier(hero, nil, "modifier_clrb_hero_balance", {
            damage_dealt_pct = dealt,
            damage_taken_reduce_pct = taken_reduce,
            hero_index = hero_index,
        })
    elseif m.RefreshFromConfig then
        m:RefreshFromConfig(dealt, taken_reduce, hero_index)
    end
    if IsInToolsMode() then
        print(string.format(
            "[HeroBalance] ID=%s hero_index=%s dealt=%s%% taken_reduce=%s%%",
            tostring(ID), tostring(hero_index), tostring(dealt), tostring(taken_reduce)
        ))
    end
end

function ClrbHeroBalanceApplyAllPlayers()
    if not IsServer() then
        return
    end
    if not PD or not PD.IDs then
        return
    end
    for _, ID in pairs(PD.IDs) do
        if ID then
            local hero = HeroData and HeroData.GetHero and HeroData:GetHero(ID)
            if (not hero or hero:IsNull()) and Util and Util.ID2Hero then
                hero = Util:ID2Hero(ID)
            end
            if hero and not hero:IsNull() then
                ClrbHeroBalanceEnsureOnHero(ID, hero)
            end
        end
    end
end

function modifier_clrb_hero_balance:IsHidden()
    return true
end

function modifier_clrb_hero_balance:IsDebuff()
    return false
end

function modifier_clrb_hero_balance:IsPurgable()
    return false
end

function modifier_clrb_hero_balance:RemoveOnDeath()
    return false
end

function modifier_clrb_hero_balance:IsPermanent()
    return true
end

function modifier_clrb_hero_balance:AllowIllusionDuplicate()
    return false
end

function modifier_clrb_hero_balance:GetTexture()
    return "modifier_magicimmune"
end

function modifier_clrb_hero_balance:OnCreated(kv)
    self.damage_dealt_pct = tonumber(kv.damage_dealt_pct) or 0
    self.damage_taken_reduce_pct = tonumber(kv.damage_taken_reduce_pct) or 0
    self.hero_index = tonumber(kv.hero_index) or 0
    if IsServer() then
        self:SetStackCount(self.hero_index)
    end
end

function modifier_clrb_hero_balance:OnRefresh(kv)
    self:OnCreated(kv)
end

function modifier_clrb_hero_balance:RefreshFromConfig(dealt, taken_reduce, hero_index)
    self.damage_dealt_pct = tonumber(dealt) or 0
    self.damage_taken_reduce_pct = tonumber(taken_reduce) or 0
    self.hero_index = tonumber(hero_index) or 0
    if IsServer() then
        self:SetStackCount(self.hero_index)
    end
end

function modifier_clrb_hero_balance:GetDamageDealtPct()
    return self.damage_dealt_pct or 0
end

function modifier_clrb_hero_balance:DeclareFunctions()
    return {
        -- 造成伤害提高：走引擎属性，比仅依赖 DamageFilter 更稳
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

function modifier_clrb_hero_balance:GetModifierTotalDamageOutgoing_Percentage()
    return self.damage_dealt_pct or 0
end

-- 引擎：正数=多受伤；配置「受到伤害减少」为正时少受伤，故取负
function modifier_clrb_hero_balance:GetModifierIncomingDamage_Percentage()
    return -(self.damage_taken_reduce_pct or 0)
end

function modifier_clrb_hero_balance:OnTooltip()
    return self.damage_dealt_pct or 0
end

function modifier_clrb_hero_balance:OnTooltip2()
    return self.damage_taken_reduce_pct or 0
end
