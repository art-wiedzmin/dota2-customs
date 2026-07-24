--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_smzf = class({})

function modifier_smzf:IsDebuff()
    return false
end

function modifier_smzf:IsPurgable()
    return false
end

function modifier_smzf:IsHidden()
    return true
end

function modifier_smzf:RemoveOnDeath()
    return false
end

function modifier_smzf:OnCreated()
    if not IsServer() then
        return
    end
    self:_SyncStackFromHeroData()
    self:ForceRefresh()
end

function modifier_smzf:OnRefresh()
    if not IsServer() then
        return
    end
    self:_SyncStackFromHeroData()
end

function modifier_smzf:_SyncStackFromHeroData()
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        self:SetStackCount(0)
        return
    end
    local ID = Util:Hero2ID(parent)
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        self:SetStackCount(0)
        return
    end
    local pct = math.floor(tonumber(HeroData.Data[ID].hero_attr.smzf) or 0)
    self:SetStackCount(pct)
end

function modifier_smzf:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
    }
end

-- 生命增幅%：按英雄当前最大生命（含 smjc 等固定加血后）额外增加同比例最大生命
function modifier_smzf:GetModifierExtraHealthPercentage()
    return self:GetStackCount() or 0
end
