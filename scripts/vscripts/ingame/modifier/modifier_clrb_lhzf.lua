--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- rank_1v1 / beidong 个人击杀模式（含人机填充局；仅真人可获得落后增幅）
-- 状态栏层数 = 计分板名次；tooltip 按名次 6~10 显示 8/16/24/32/40% 对英雄伤害（参考枪术 OnTooltip）

CLRB_LHZF_HERO_DMG_PCT = {
    [6] = 8,
    [7] = 16,
    [8] = 24,
    [9] = 32,
    [10] = 40,
}

ClrbLhzfLastRank = ClrbLhzfLastRank or {}

function ClrbLhzfDamagePctForRank(rank)
    rank = tonumber(rank) or 0
    return CLRB_LHZF_HERO_DMG_PCT[rank] or 0
end

--- 是否启用落后增幅（1v1 个人击杀，含人机对局）
function ClrbLhzfIsEnabledMode()
    if MainGame and MainGame.GetGameType then
        return MainGame:GetGameType() == 2
    end
    local map = GetMapName()
    return map == "rank_1v1" or map == "beidong"
end

function ClrbLhzfIsHumanPlayer(ID)
    if not ID then
        return false
    end
    if HeroData and HeroData.IsBot and HeroData:IsBot(ID) then
        return false
    end
    if InitPlayer and InitPlayer.GetPlayerData then
        local ip = InitPlayer:GetPlayerData(ID)
        if not ip or ip.bot then
            return false
        end
    end
    return true
end

function ClrbLhzfStripFromHero(hero)
    if not hero or hero:IsNull() then
        return
    end
    hero:RemoveModifierByName("modifier_clrb_lhzf_show")
    hero:RemoveModifierByName("modifier_clrb_lhzf_dysh")
    hero:RemoveModifierByName("modifier_clrb_lhzf")
end

function ClrbLhzfGetRankForPlayer(ID)
    if not ClrbLhzfIsEnabledMode() or not ClrbLhzfIsHumanPlayer(ID) then
        return 0
    end
    if not Stat or not Stat.GetTopScoreboardRank then
        return 0
    end
    return Stat:GetTopScoreboardRank(ID) or 0
end

function ClrbLhzfGetDamagePctForPlayer(ID)
    return ClrbLhzfDamagePctForRank(ClrbLhzfGetRankForPlayer(ID))
end

function ClrbLhzfEnsureOnHero(ID, hero)
    if not ClrbLhzfIsEnabledMode() then
        return
    end
    if not ID or not hero or hero:IsNull() then
        return
    end
    if not ClrbLhzfIsHumanPlayer(ID) then
        ClrbLhzfStripFromHero(hero)
        return
    end
    if not hero:HasModifier("modifier_clrb_lhzf") then
        hero:AddNewModifier(hero, nil, "modifier_clrb_lhzf", { player_id = ID })
    else
        local m = hero:FindModifierByName("modifier_clrb_lhzf")
        if m and m.RefreshFromRank then
            m:RefreshFromRank()
        end
    end
end

function ClrbLhzfRefreshPlayerIfRankChanged(ID, force)
    if not ID or not ClrbLhzfIsHumanPlayer(ID) then
        return
    end
    local rank = ClrbLhzfGetRankForPlayer(ID)
    if not force and ClrbLhzfLastRank[ID] == rank then
        return
    end
    ClrbLhzfLastRank[ID] = rank
    local hero = HeroData and HeroData.GetHero and HeroData:GetHero(ID)
    if hero and not hero:IsNull() then
        ClrbLhzfEnsureOnHero(ID, hero)
    end
end

---@param changed_ids number[]|nil nil=全量兜底（结算/重连）；空表=跳过
function ClrbLhzfOnRankUpdated(changed_ids)
    if not ClrbLhzfIsEnabledMode() or not PD or not PD.IDs then
        return
    end
    if changed_ids ~= nil then
        if #changed_ids == 0 then
            return
        end
        for _, ID in ipairs(changed_ids) do
            ClrbLhzfRefreshPlayerIfRankChanged(ID, true)
        end
        return
    end
    for _, ID in pairs(PD.IDs) do
        if ID then
            ClrbLhzfRefreshPlayerIfRankChanged(ID, false)
        end
    end
end

--- 伤害过滤器：仅英雄对英雄且攻击者持有落后增幅时读取
function ClrbLhzfApplyHeroVsHeroDamageAmp(attacker, damage)
    if not attacker or attacker:IsNull() or not damage or damage <= 0 then
        return damage
    end
    if type(attacker.FindModifierByName) ~= "function" then
        return damage
    end
    local m = attacker:FindModifierByName("modifier_clrb_lhzf")
    if not m or type(m.GetHeroDamageBonusPct) ~= "function" then
        return damage
    end
    local pct = m:GetHeroDamageBonusPct()
    if not pct or pct <= 0 then
        return damage
    end
    return damage * (100 + pct) / 100
end

modifier_clrb_lhzf = class({})

function modifier_clrb_lhzf:IsHidden()
    return false
end

function modifier_clrb_lhzf:IsDebuff()
    return false
end

function modifier_clrb_lhzf:IsPurgable()
    return false
end

function modifier_clrb_lhzf:RemoveOnDeath()
    return false
end

function modifier_clrb_lhzf:IsPermanent()
    return true
end

function modifier_clrb_lhzf:AllowIllusionDuplicate()
    return false
end

function modifier_clrb_lhzf:GetTexture()
    return "item_soul_ring"
end

function modifier_clrb_lhzf:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.player_id = kv and kv.player_id
    if not self.player_id then
        self.player_id = Util:Hero2ID(self:GetParent())
    end
    self:StartIntervalThink(1)
    self:RefreshFromRank()
end

function modifier_clrb_lhzf:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:RefreshFromRank()
end

function modifier_clrb_lhzf:RefreshFromRank()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return
    end
    if not self.player_id then
        self.player_id = Util:Hero2ID(parent)
    end
    local rank = ClrbLhzfGetRankForPlayer(self.player_id)
    self:SetStackCount(rank > 0 and rank or 0)
    self:SendBuffRefreshToClients()
end

function modifier_clrb_lhzf:GetHeroDamageBonusPct()
    return ClrbLhzfDamagePctForRank(self:GetStackCount())
end

function modifier_clrb_lhzf:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

--- 层数即当前名次 → tooltip 显示对应伤害加成（与枪术 OnTooltip 相同写法）
function modifier_clrb_lhzf:OnTooltip()
    return ClrbLhzfDamagePctForRank(self:GetStackCount() or 0)
end
