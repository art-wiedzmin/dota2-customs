--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 天赋 5「开了」：在自身位置持续提供 2200 码高空 FOW 视野，随英雄移动
modifier_clrb_talent_5_vision = class({})

function modifier_clrb_talent_5_vision:IsHidden() return true end
function modifier_clrb_talent_5_vision:IsPurgable() return false end
function modifier_clrb_talent_5_vision:RemoveOnDeath() return true end

local RADIUS = 2200
local THINK = 0.25
local FOW_PULSE = 0.4

function modifier_clrb_talent_5_vision:OnCreated()
    if not IsServer() then
        return
    end
    self:PulseFow()
    self:StartIntervalThink(THINK)
end

function modifier_clrb_talent_5_vision:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:PulseFow()
end

function modifier_clrb_talent_5_vision:PulseFow()
    local p = self:GetParent()
    if not p or p:IsNull() or not p:IsAlive() then
        return
    end
    AddFOWViewer(p:GetTeamNumber(), p:GetAbsOrigin(), RADIUS, FOW_PULSE, false)
end
