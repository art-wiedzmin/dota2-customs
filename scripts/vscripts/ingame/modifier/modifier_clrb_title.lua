--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_clrb_title = class({})

function modifier_clrb_title:IsHidden()
    return true
end

function modifier_clrb_title:IsDebuff()
    return false
end

function modifier_clrb_title:IsPurgable()
    return false
end

function modifier_clrb_title:RemoveOnDeath()
    return true
end

function modifier_clrb_title:IsPermanent()
    return true
end

function modifier_clrb_title:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.title_fx = (kv and kv.title_fx) or "particles/clrb/clrb_equip_title_clxx_loop.vpcf"
    self.item_key = kv and kv.item_key
    self:_UpdateParticle()
end

function modifier_clrb_title:OnRefresh(kv)
    if not IsServer() then
        return
    end
    if kv and kv.title_fx then
        self.title_fx = kv.title_fx
    end
    if kv and kv.item_key then
        self.item_key = kv.item_key
    end
    self:_UpdateParticle()
end

function modifier_clrb_title:OnDestroy()
    if not IsServer() then
        return
    end
    self:_DestroyParticle()
end

function modifier_clrb_title:OnRemoved()
    if not IsServer() then
        return
    end
    self:_DestroyParticle()
end

function modifier_clrb_title:_DestroyParticle()
    if self.particle then
        ParticleManager:DestroyParticle(self.particle, true)
        ParticleManager:ReleaseParticleIndex(self.particle)
        self.particle = nil
    end
end

function modifier_clrb_title:_UpdateParticle()
    self:_DestroyParticle()
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return
    end
    self.particle = ParticleManager:CreateParticle(
        self.title_fx,
        PATTACH_OVERHEAD_FOLLOW,
        parent
    )
end

function modifier_clrb_title:GetStatusEffectPriority()
    return 10
end
