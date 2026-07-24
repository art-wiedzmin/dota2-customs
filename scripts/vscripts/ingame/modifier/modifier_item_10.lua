--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_item_10 = class({})

--是否在面板上显示
function modifier_item_10:IsHidden()
    return false
end

function modifier_item_10:IsDebuff()
    return false
end

function modifier_item_10:IsPurgable()
    return false -- 不可被驱散
end

function modifier_item_10:RemoveOnDeath()
    return false
end

function modifier_item_10:GetTexture()
    return "scroll/neizaiqianneng"
end

function modifier_item_10:AllowIllusionDuplicate()
    return true
end

--创建时设置
function modifier_item_10:OnCreated(kv)
    if not IsServer() then return end
    local caster = self:GetParent()
    caster:ModifyStrength(10)
    caster:ModifyAgility(10)
    caster:ModifyIntellect(10)
end

