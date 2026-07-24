--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 宠物专用环境光效（ParticleManager + AddParticle，npc_dota_creature 上 GetEffectName 不可靠）

modifier_clrb_pet_ambient = class({})

function modifier_clrb_pet_ambient:IsHidden()
    return true
end

function modifier_clrb_pet_ambient:IsDebuff()
    return false
end

function modifier_clrb_pet_ambient:IsPurgable()
    return false
end

function modifier_clrb_pet_ambient:RemoveOnDeath()
    return false
end

function modifier_clrb_pet_ambient:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.ambient_fx = kv and kv.ambient_fx
    self:_ScheduleSpawn()
end

function modifier_clrb_pet_ambient:OnRefresh(kv)
    if not IsServer() then
        return
    end
    if kv and kv.ambient_fx then
        self.ambient_fx = kv.ambient_fx
    end
    self:_DestroyParticle()
    self:_ScheduleSpawn()
end

function modifier_clrb_pet_ambient:OnDestroy()
    if not IsServer() then
        return
    end
    self:_DestroyParticle()
end

function modifier_clrb_pet_ambient:_ScheduleSpawn()
    if not Timers then
        self:_SpawnParticle()
        return
    end
    Timers(0, function()
        if not self or self:IsNull() then
            return
        end
        self:_SpawnParticle()
    end)
end

function modifier_clrb_pet_ambient:_DestroyParticle()
    if self.particle then
        ParticleManager:DestroyParticle(self.particle, false)
        ParticleManager:ReleaseParticleIndex(self.particle)
        self.particle = nil
    end
end

function modifier_clrb_pet_ambient:_SpawnParticle()
    local fx = self.ambient_fx
    if not fx or fx == "" then
        return
    end
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return
    end
    self:_DestroyParticle()
    self.particle = ParticleManager:CreateParticle(fx, PATTACH_ABSORIGIN_FOLLOW, parent)
    self:AddParticle(self.particle, false, false, 10, false, false)
end
