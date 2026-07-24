--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 天赋 5 缚魂：系带目标，无视减益免疫；可正常步行但不可距锚点超 700、禁用位移技能（墨客特效）

modifier_clrb_soul_chain_victim = class({})

local CHAIN_RADIUS = 700
local THINK = 1 / 30

function modifier_clrb_soul_chain_victim:IsHidden()
    return false
end

function modifier_clrb_soul_chain_victim:IsDebuff()
    return true
end

function modifier_clrb_soul_chain_victim:IsPurgable()
    return false
end

function modifier_clrb_soul_chain_victim:RemoveOnDeath()
    return true
end

function modifier_clrb_soul_chain_victim:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--- 与 grimstroke_soul_chain 一致：可对魔免enemy施加
function modifier_clrb_soul_chain_victim:GetModifierIgnoreDebuffImmunity()
    if DOTA_ABILITY_PIERCE_TYPE_MAGIC_IMMUNE ~= nil then
        return DOTA_ABILITY_PIERCE_TYPE_MAGIC_IMMUNE
    end
    return 1
end

function modifier_clrb_soul_chain_victim:GetTexture()
    return "grimstroke_soul_chain"
end

function modifier_clrb_soul_chain_victim:GetEffectName()
    return "particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf"
end

function modifier_clrb_soul_chain_victim:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_clrb_soul_chain_victim:OnCreated()
    if not IsServer() then
        return
    end
    self.pfx_chain = nil
    self.pfx_marker = nil
    local p = self:GetParent()
    local caster = self:GetCaster()
    if not p or p:IsNull() or not caster or caster:IsNull() then
        return
    end

    self.pfx_chain = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf",
        PATTACH_CUSTOMORIGIN,
        nil
    )
    Util:ParticleSetControlEntHitlocOrAbsFollow(self.pfx_chain, 0, caster)
    Util:ParticleSetControlEntHitlocOrAbsFollow(self.pfx_chain, 1, p)

    self.pfx_marker = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_grimstroke/grimstroke_soulchain_marker.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        p
    )

    self:StartIntervalThink(THINK)
    self:OnIntervalThink()
end

function modifier_clrb_soul_chain_victim:OnDestroy()
    if not IsServer() then
        return
    end
    if self.pfx_chain then
        ParticleManager:DestroyParticle(self.pfx_chain, false)
        ParticleManager:ReleaseParticleIndex(self.pfx_chain)
        self.pfx_chain = nil
    end
    if self.pfx_marker then
        ParticleManager:DestroyParticle(self.pfx_marker, false)
        ParticleManager:ReleaseParticleIndex(self.pfx_marker)
        self.pfx_marker = nil
    end
end

function modifier_clrb_soul_chain_victim:OnIntervalThink()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    local anchor = self:GetCaster()
    if not parent or parent:IsNull() or not parent:IsAlive() then
        self:Destroy()
        return
    end
    if not anchor or anchor:IsNull() or not anchor:IsAlive() then
        self:Destroy()
        return
    end

    local v1 = anchor:GetAbsOrigin()
    local v2 = parent:GetAbsOrigin()
    local dx = v2.x - v1.x
    local dy = v2.y - v1.y
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist > CHAIN_RADIUS and dist > 0.01 then
        local scale = CHAIN_RADIUS / dist
        local nx = v1.x + dx * scale
        local ny = v1.y + dy * scale
        local newpos = Vector(nx, ny, v2.z)
        newpos.z = GetGroundPosition(newpos, parent).z
        parent:SetAbsOrigin(newpos)
        FindClearSpaceForUnit(parent, newpos, true)
    end
end
