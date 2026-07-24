--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if ability_m_2_3_storm_surge == nil then
    ability_m_2_3_storm_surge = class({})
end

LinkLuaModifier("modifier_m_2_3_storm_surge",
    "ingame/Monster/ability_m_2_3_storm_surge",
    LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_m_2_3_storm_surge_slow",
    "ingame/Monster/ability_m_2_3_storm_surge",
    LUA_MODIFIER_MOTION_NONE)

function ability_m_2_3_storm_surge:GetIntrinsicModifierName()
    return "modifier_m_2_3_storm_surge"
end

if modifier_m_2_3_storm_surge == nil then
    modifier_m_2_3_storm_surge = class({})
end

function modifier_m_2_3_storm_surge:IsHidden()
    return true
end

function modifier_m_2_3_storm_surge:IsPurgable()
    return false
end

function modifier_m_2_3_storm_surge:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_m_2_3_storm_surge:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end
    if params.damage <= 0 then
        return
    end
    local ability = self:GetAbility()
    if not ability then
        return
    end
    local now = GameRules:GetGameTime()
    local internal_cd = ability:GetSpecialValueFor("strike_internal_cd") or 0.3
    if self.last_strike_time and (now - self.last_strike_time) < internal_cd then
        return
    end
    local chance = ability:GetSpecialValueFor("strike_pct_chance") or 30
    if RandomInt(1, 100) > chance then
        return
    end
    self.last_strike_time = now
    self:ProcStormSurge(ability)
end

function modifier_m_2_3_storm_surge:ProcStormSurge(ability)
    local caster = self:GetParent()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        return
    end
    local radius = ability:GetSpecialValueFor("strike_search_radius") or 600
    local max_targets = ability:GetSpecialValueFor("strike_target_count") or 3
    local damage = ability:GetSpecialValueFor("strike_damage") or 1000
    local slow_duration = ability:GetSpecialValueFor("strike_slow_duration") or 2

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )
    local hit = 0
    for _, enemy in ipairs(enemies) do
        if hit >= max_targets then
            break
        end
        if enemy and not enemy:IsNull() and enemy:IsAlive() then
            hit = hit + 1
            local pfx = ParticleManager:CreateParticle(
                "particles/units/heroes/hero_razor/razor_storm_secondary_arc_a.vpcf",
                PATTACH_ABSORIGIN_FOLLOW,
                caster
            )
            ParticleManager:SetParticleControlEnt(
                pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true
            )
            ParticleManager:SetParticleControlEnt(
                pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true
            )
            ParticleManager:ReleaseParticleIndex(pfx)
            EmitSoundOn("Hero_Razor.UnstableCurrent.Target", enemy)

            ApplyDamage({
                victim = enemy,
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability,
            })
            enemy:AddNewModifier(caster, ability, "modifier_m_2_3_storm_surge_slow", {
                duration = slow_duration,
            })
        end
    end
end

if modifier_m_2_3_storm_surge_slow == nil then
    modifier_m_2_3_storm_surge_slow = class({})
end

function modifier_m_2_3_storm_surge_slow:IsHidden()
    return false
end

function modifier_m_2_3_storm_surge_slow:IsDebuff()
    return true
end

function modifier_m_2_3_storm_surge_slow:IsPurgable()
    return true
end

function modifier_m_2_3_storm_surge_slow:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_m_2_3_storm_surge_slow:GetModifierMoveSpeedBonus_Percentage()
    return -50
end

function modifier_m_2_3_storm_surge_slow:GetEffectName()
    return "particles/units/heroes/hero_razor/razor_unstable_current.vpcf"
end

function modifier_m_2_3_storm_surge_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
