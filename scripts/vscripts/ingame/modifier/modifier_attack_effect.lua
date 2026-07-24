--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_attack_effect", "ingame/modifier/modifier_attack_effect", LUA_MODIFIER_MOTION_NONE)

modifier_attack_effect = class({})

ATTACK_EFFECT_PARTICLES = {
    atv4 = "particles/econ/events/diretide_2020/attack_modifier/attack_modifier_fall20.vpcf",
    atv1 = "particles/econ/events/diretide_2020/attack_modifier/attack_modifier_v1_fall20.vpcf",
    atv2 = "particles/econ/events/diretide_2020/attack_modifier/attack_modifier_v2_fall20.vpcf",
    atv3 = "particles/econ/events/diretide_2020/attack_modifier/attack_modifier_v3_fall20.vpcf",
}

function modifier_attack_effect:IsDebuff()
    return false
end

function modifier_attack_effect:IsPurgable()
    return false
end

function modifier_attack_effect:IsHidden()
    return true
end

function modifier_attack_effect:RemoveOnDeath()
    return false
end

function modifier_attack_effect:OnCreated(kv)
    if kv and kv.attack_effect then
        self.attack_effect_key = kv.attack_effect
    end
    if IsServer() then
        self:ForceRefresh()
    end
end

function modifier_attack_effect:OnRefresh(kv)
    if kv and kv.attack_effect then
        self.attack_effect_key = kv.attack_effect
    end
end

function modifier_attack_effect:GetParticlePath()
    if not self.attack_effect_key then
        return nil
    end
    return ATTACK_EFFECT_PARTICLES[self.attack_effect_key]
end

function modifier_attack_effect:IsRangedAttackerUnit(unit)
    return unit and not unit:IsNull() and unit.IsRangedAttacker and unit:IsRangedAttacker()
end

--- 远程：替换引擎普攻弹道；近战：无默认弹道，攻击开始时单独播放特效
function modifier_attack_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_attack_effect:GetModifierProjectileName()
    local parent = self:GetParent()
    if not self:IsRangedAttackerUnit(parent) then
        return
    end
    return self:GetParticlePath()
end

function modifier_attack_effect:OnAttackStart(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if not keys.target or keys.target:IsNull() then
        return
    end
    -- 远程英雄已由 GetModifierProjectileName 替换弹道，避免重复播放
    if self:IsRangedAttackerUnit(keys.attacker) then
        return
    end

    local particle_path = self:GetParticlePath()
    if not particle_path then
        return
    end

    local attacker = keys.attacker
    local target = keys.target
    local p = ParticleManager:CreateParticle(particle_path, PATTACH_CUSTOMORIGIN, attacker)
    if not p then
        return
    end

    local target_pos = target:GetAbsOrigin()
    ParticleManager:SetParticleControl(p, 1, target_pos)
    ParticleManager:SetParticleControl(p, 2, (attacker:GetAbsOrigin() + target_pos) / 2)
    ParticleManager:SetParticleControl(p, 4, attacker:GetAbsOrigin())

    Timers:CreateTimer(1.5, function()
        if p then
            ParticleManager:DestroyParticle(p, true)
        end
    end)
end
