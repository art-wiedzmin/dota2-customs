--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 筋斗云：修仙飞行 / 踏云靴共用；死亡移除，复活后由 ClrbFlyCloudSync 重建
-- 服务端 CreateParticle + AddParticle 同步到客户端；Thinker 锚点插值跟随，避免低频瞬移卡顿

require("ingame.modifier.clrb_fly_cloud_util")

modifier_clrb_fly_cloud = class({})

local FLY_CLOUD_FX = "particles/econ/items/monkey_king/arcana/monkey_arcana_cloud.vpcf"
local FLY_CLOUD_GROUND_OFFSET = 80
local FLY_CLOUD_POS_INTERVAL = 0.03
-- monkey_arcana_cloud 非循环粒子，到期前重建
local FLY_CLOUD_REFRESH_SEC = 5
local FLY_CLOUD_LERP = 0.55

function modifier_clrb_fly_cloud:IsHidden()
    return true
end

function modifier_clrb_fly_cloud:IsDebuff()
    return false
end

function modifier_clrb_fly_cloud:IsPurgable()
    return false
end

function modifier_clrb_fly_cloud:RemoveOnDeath()
    return true
end

function modifier_clrb_fly_cloud:_FootCloudPos()
    local p = self:GetParent()
    if not p or p:IsNull() then
        return nil
    end
    local pos = p:GetAbsOrigin()
    local ground = GetGroundPosition(Vector(pos.x, pos.y, pos.z + 2048), p)
    ground.z = ground.z + FLY_CLOUD_GROUND_OFFSET
    return ground
end

function modifier_clrb_fly_cloud:_DestroyFlyCloudAnchor()
    if self.fly_cloud_anchor and not self.fly_cloud_anchor:IsNull() then
        UTIL_Remove(self.fly_cloud_anchor)
    end
    self.fly_cloud_anchor = nil
end

function modifier_clrb_fly_cloud:_DestroyParticleOnly()
    if self.fly_cloud_pfx then
        ParticleManager:DestroyParticle(self.fly_cloud_pfx, false)
        ParticleManager:ReleaseParticleIndex(self.fly_cloud_pfx)
        self.fly_cloud_pfx = nil
    end
    self._fly_cloud_spawn_at = nil
end

function modifier_clrb_fly_cloud:_EnsureFlyCloudAnchor(target)
    local p = self:GetParent()
    if not p or p:IsNull() or not target then
        return nil
    end
    if not self.fly_cloud_anchor or self.fly_cloud_anchor:IsNull() then
        self.fly_cloud_anchor = CreateModifierThinker(
            p,
            nil,
            "modifier_phased",
            {},
            target,
            p:GetTeamNumber(),
            false
        )
        self._fly_cloud_pos = target
    end
    if not self.fly_cloud_anchor or self.fly_cloud_anchor:IsNull() then
        return nil
    end
    local cur = self._fly_cloud_pos or target
    local t = FLY_CLOUD_LERP
    local smooth = Vector(
        cur.x + (target.x - cur.x) * t,
        cur.y + (target.y - cur.y) * t,
        cur.z + (target.z - cur.z) * t
    )
    self._fly_cloud_pos = smooth
    self.fly_cloud_anchor:SetAbsOrigin(smooth)
    return self.fly_cloud_anchor
end

function modifier_clrb_fly_cloud:_SpawnParticle()
    if not IsServer() then
        return
    end
    local p = self:GetParent()
    if not p or p:IsNull() or not p:IsAlive() then
        return
    end
    local ground = self:_FootCloudPos()
    if not ground then
        return
    end
    local anchor = self:_EnsureFlyCloudAnchor(ground)
    if not anchor or anchor:IsNull() then
        return
    end
    self:_DestroyParticleOnly()
    self.fly_cloud_pfx = ParticleManager:CreateParticle(FLY_CLOUD_FX, PATTACH_ABSORIGIN_FOLLOW, anchor)
    ParticleManager:SetParticleControl(self.fly_cloud_pfx, 0, anchor:GetAbsOrigin())
    self:AddParticle(self.fly_cloud_pfx, false, false, 10, false, false)
    self._fly_cloud_spawn_at = GameRules:GetGameTime()
end

function modifier_clrb_fly_cloud:_TickFlyCloud()
    if not IsServer() then
        return
    end
    local p = self:GetParent()
    if not p or p:IsNull() or not p:IsAlive() then
        return
    end
    if not ClrbHeroShouldShowFlyCloud(p) then
        self:Destroy()
        return
    end

    local target = self:_FootCloudPos()
    if target then
        self:_EnsureFlyCloudAnchor(target)
    end

    if self.fly_cloud_pfx and self.fly_cloud_anchor and not self.fly_cloud_anchor:IsNull() then
        ParticleManager:SetParticleControl(self.fly_cloud_pfx, 0, self.fly_cloud_anchor:GetAbsOrigin())
    end

    local now = GameRules:GetGameTime()
    if not self.fly_cloud_pfx or not self._fly_cloud_spawn_at
        or (now - self._fly_cloud_spawn_at) >= FLY_CLOUD_REFRESH_SEC then
        self:_SpawnParticle()
    end
end

function modifier_clrb_fly_cloud:OnCreated()
    if not IsServer() then
        return
    end
    self._fly_cloud_pos = nil
    self:_SpawnParticle()
    self:StartIntervalThink(FLY_CLOUD_POS_INTERVAL)
end

function modifier_clrb_fly_cloud:OnIntervalThink()
    self:_TickFlyCloud()
end

function modifier_clrb_fly_cloud:OnDestroy()
    if not IsServer() then
        return
    end
    self:_DestroyParticleOnly()
    self:_DestroyFlyCloudAnchor()
    self._fly_cloud_pos = nil
end
