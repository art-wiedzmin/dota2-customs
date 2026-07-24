--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 矮人直升机：侧翼机关枪始终隐藏，有 A 杖时维持 1 级以启用被动效果
modifier_side_gunner = class({})

function modifier_side_gunner:IsHidden()
    return true
end

function modifier_side_gunner:IsDebuff()
    return false
end

function modifier_side_gunner:IsPurgable()
    return false
end

function modifier_side_gunner:RemoveOnDeath()
    return false
end

function modifier_side_gunner:IsPermanent()
    return true
end

function modifier_side_gunner:OnCreated()
    if not IsServer() then
        return
    end
    self:RefreshSideGunner()
    self:StartIntervalThink(0.5)
end

function modifier_side_gunner:OnIntervalThink()
    self:RefreshSideGunner()
end

function modifier_side_gunner:RefreshSideGunner()
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    if not hero or hero:IsNull() then
        return
    end
    if HeroData and HeroData.ApplyGyrocopterSideGunnerPassiveState then
        HeroData:ApplyGyrocopterSideGunnerPassiveState(hero)
    end
end
