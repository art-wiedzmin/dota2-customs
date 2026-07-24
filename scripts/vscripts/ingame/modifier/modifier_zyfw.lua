--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 基础作用范围（hero_attr.zyfw）：引擎 AOE 加成（同裂隙之石 / Telescope 类 flat AOE）
modifier_zyfw = class({})

function modifier_zyfw:IsDebuff()
    return false
end

function modifier_zyfw:IsPurgable()
    return false
end

function modifier_zyfw:IsHidden()
    return true
end

function modifier_zyfw:RemoveOnDeath()
    return false
end

function modifier_zyfw:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

-- 数值由服务端 BaseZyfw / OnCreated 写入 stack；勿在回调里用 Util（客户端未加载会报错）
local function modifier_zyfw_bonus(self)
    return math.max(0, self:GetStackCount() or 0)
end

function modifier_zyfw:OnCreated(kv)
    if not IsServer() then return end
    local v = math.max(0, math.floor(tonumber(kv and kv.zyfw) or 0))
    self:SetStackCount(v)
    self:ForceRefresh()
    self:GetParent():CalculateStatBonus(true)
end

function modifier_zyfw:OnRefresh(kv)
    if not IsServer() then return end
    if kv and kv.zyfw ~= nil then
        local v = math.max(0, math.floor(tonumber(kv.zyfw) or 0))
        self:SetStackCount(v)
    end
    self:GetParent():CalculateStatBonus(true)
end

function modifier_zyfw:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_AOE_BONUS_CONSTANT,
        MODIFIER_PROPERTY_AOE_BONUS_CONSTANT_STACKING,
    }
end

function modifier_zyfw:GetModifierAOEBonusConstant()
    return modifier_zyfw_bonus(self)
end

function modifier_zyfw:GetModifierAoEBonusConstant()
    return modifier_zyfw_bonus(self)
end

function modifier_zyfw:GetModifierAOEBonusConstantStacking()
    return modifier_zyfw_bonus(self)
end

function modifier_zyfw:GetModifierAoEBonusConstantStacking()
    return modifier_zyfw_bonus(self)
end
