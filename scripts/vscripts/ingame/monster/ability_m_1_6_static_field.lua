--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if ability_m_1_6_static_field == nil then
    ability_m_1_6_static_field = class({})
end

LinkLuaModifier("modifier_m_1_6_static_field",
    "ingame/Monster/ability_m_1_6_static_field",
    LUA_MODIFIER_MOTION_NONE)

function ability_m_1_6_static_field:GetIntrinsicModifierName()
    return "modifier_m_1_6_static_field"
end

if modifier_m_1_6_static_field == nil then
    modifier_m_1_6_static_field = class({})
end

function modifier_m_1_6_static_field:IsHidden()
    return true
end

function modifier_m_1_6_static_field:IsPurgable()
    return false
end

function modifier_m_1_6_static_field:RemoveOnDeath()
    return false
end

function modifier_m_1_6_static_field:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_m_1_6_static_field:CanShockTarget(target)
    local parent = self:GetParent()
    if not parent or parent:IsNull() or not parent:IsAlive() then
        return false
    end
    if parent:PassivesDisabled() then
        return false
    end
    if not target or target:IsNull() or not target:IsAlive() or target == parent then
        return false
    end
    if target:GetTeamNumber() == parent:GetTeamNumber() then
        return false
    end
    if target:IsBuilding() or target:IsOther() then
        return false
    end
    return true
end

function modifier_m_1_6_static_field:OnCreated()
    if IsServer() then
        self.shock_cd = {}
    end
end

function modifier_m_1_6_static_field:ApplyStaticFieldDamage(target)
    if not IsServer() or not self:CanShockTarget(target) then
        return
    end
    local ability = self:GetAbility()
    if not ability then
        return
    end
    local eid = target:entindex()
    local now = GameRules:GetGameTime()
    if self.shock_cd[eid] and (now - self.shock_cd[eid]) < 0.5 then
        return
    end
    self.shock_cd[eid] = now
    local pct = ability:GetSpecialValueFor("damage_health_pct")
    local damage = target:GetHealth() * pct * 0.01
    if damage <= 0 then
        return
    end
    ApplyDamage({
        victim = target,
        attacker = self:GetParent(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    })
    EmitSoundOn("Hero_Disruptor.ThunderStrike.Target", target)
end

function modifier_m_1_6_static_field:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    if params.attacker ~= parent then
        return
    end
    if params.damage <= 0 then
        return
    end
    local ability = self:GetAbility()
    if ability and params.inflictor == ability then
        return
    end
    self:ApplyStaticFieldDamage(params.unit)
end
