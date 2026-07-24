--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 雷纹结晶（item_goods_25）累计食用加成：状态栏展示，图标同物品
modifier_goods_25 = class({})

local PER_APPLY_MFGJ = 15
local PER_APPLY_SMJC = 200
local MILESTONE_5_ALLSTAT = 15
local MILESTONE_10_JNZQ = 15
local MILESTONE_10_GJJC = 20

function modifier_goods_25:IsHidden()
    return false
end

function modifier_goods_25:IsDebuff()
    return false
end

function modifier_goods_25:IsPurgable()
    return false
end

function modifier_goods_25:RemoveOnDeath()
    return false
end

function modifier_goods_25:IsPermanent()
    return true
end

function modifier_goods_25:AllowIllusionDuplicate()
    return false
end

function modifier_goods_25:GetTexture()
    return "scroll/item_goods_25"
end

function modifier_goods_25:ResolvePlayerId()
    if self.player_id ~= nil then
        return tonumber(self.player_id)
    end
    return Util:Hero2ID(self:GetParent())
end

function modifier_goods_25:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.player_id = tonumber(kv and kv.player_id) or Util:Hero2ID(self:GetParent())
    local n = tonumber(kv and kv.stack_count) or 0
    if n > 0 then
        self:SetStackCount(n)
    else
        self:SyncFromHeroData()
    end
    self:SendBuffRefreshToClients()
end

function modifier_goods_25:OnRefresh(kv)
    if not IsServer() then
        return
    end
    self:SyncFromHeroData()
end

function modifier_goods_25:SyncFromHeroData()
    if not IsServer() then
        return
    end
    local pid = self:ResolvePlayerId()
    self.player_id = pid
    local n = 0
    if pid and HeroData and HeroData.Data then
        local row = HeroData.Data[pid]
        if row then
            n = tonumber(row.goods_25_applies) or 0
        end
    end
    if n <= 0 then
        return
    end
    self:SetStackCount(n)
    self:SendBuffRefreshToClients()
end

function modifier_goods_25:_ApplyCount()
    return self:GetStackCount() or 0
end

--- 以下属性 getter 仅在客户端用于 tooltip 展示；服务端恒为 0，实际加成由 HeroData 写入
function modifier_goods_25:_TooltipOnly(value)
    if IsServer() then
        return 0
    end
    return value
end

function modifier_goods_25:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_goods_25:OnTooltip()
    return self:_ApplyCount() * PER_APPLY_MFGJ
end

function modifier_goods_25:OnTooltip2()
    return self:_ApplyCount() * PER_APPLY_SMJC
end

function modifier_goods_25:GetModifierBonusStats_Strength()
    local n = self:_ApplyCount()
    return self:_TooltipOnly(n >= 5 and MILESTONE_5_ALLSTAT or 0)
end

function modifier_goods_25:GetModifierSpellAmplify_Percentage()
    local n = self:_ApplyCount()
    return self:_TooltipOnly(n >= 10 and MILESTONE_10_JNZQ or 0)
end

function modifier_goods_25:GetModifierBaseDamageOutgoing_Percentage()
    local n = self:_ApplyCount()
    return self:_TooltipOnly(n >= 10 and MILESTONE_10_GJJC or 0)
end
