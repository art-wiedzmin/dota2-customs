--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if ability_m_2_3_plasma_ring == nil then
    ability_m_2_3_plasma_ring = class({})
end

LinkLuaModifier("modifier_m_2_3_plasma_ring",
    "ingame/Monster/ability_m_2_3_plasma_ring",
    LUA_MODIFIER_MOTION_NONE)

function ability_m_2_3_plasma_ring:TriggerPhaseTwo()
    if not IsServer() then
        return
    end
    if self.phase_triggered then
        return
    end
    local caster = self:GetCaster()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        return
    end
    self.phase_triggered = true
    local warning_time = self:GetSpecialValueFor("warning_time") or 1
    local invuln_channel = self:GetSpecialValueFor("invuln_duration") or 9
    caster:AddNewModifier(caster, self, "modifier_m_2_3_plasma_ring", {
        duration = warning_time + invuln_channel,
    })
end

if modifier_m_2_3_plasma_ring == nil then
    modifier_m_2_3_plasma_ring = class({})
end

function modifier_m_2_3_plasma_ring:IsHidden()
    return false
end

function modifier_m_2_3_plasma_ring:IsPurgable()
    return false
end

function modifier_m_2_3_plasma_ring:RefreshRadius()
    local ability = self:GetAbility()
    if ability and not ability:IsNull() then
        local r = ability:GetSpecialValueFor("radius")
        if r and r > 0 then
            self.radius = r
        end
        local interval = ability:GetSpecialValueFor("pulse_interval")
        if interval and interval > 0 then
            self.pulse_interval = interval
        end
    end
end

function modifier_m_2_3_plasma_ring:OnCreated(kv)
    local ability = self:GetAbility()
    self.radius = ability and ability:GetSpecialValueFor("radius") or 700
    self.damage_min = ability and ability:GetSpecialValueFor("damage_min") or 1000
    self.damage_max = ability and ability:GetSpecialValueFor("damage_max") or 3000
    self.slow_min = ability and ability:GetSpecialValueFor("slow_min") or 15
    self.slow_max = ability and ability:GetSpecialValueFor("slow_max") or 60
    self.pulse_interval = ability and ability:GetSpecialValueFor("pulse_interval") or 0.5
    self.pulse_count = ability and ability:GetSpecialValueFor("pulse_count") or 18
    self.warning_time = ability and ability:GetSpecialValueFor("warning_time") or 1
    self.think_tick = 0.1
    self.hit_pad = 50
    self.channel_started = false
    self.current_pulse = 0
    self.pulse_hit = {}
    self.active_ring_pfx = nil

    if not IsServer() then
        return
    end

    self:RefreshRadius()

    local invuln_channel = ability and ability:GetSpecialValueFor("invuln_duration") or 9
    local duration = kv.duration or (self.warning_time + invuln_channel)
    self:SetDuration(duration, false)

    local parent = self:GetParent()
    local pos = parent:GetAbsOrigin()
    RedTip:LifeCircle_add(pos, self.warning_time, self.radius)
    parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)

    Timers(self.warning_time, function()
        if not self or self:IsNull() then
            return
        end
        local caster = self:GetParent()
        if not caster or caster:IsNull() or not caster:IsAlive() then
            return
        end
        self:RefreshRadius()
        self.channel_started = true
        self.current_pulse = 1
        self.pulse_start_time = GameRules:GetGameTime()
        self.pulse_hit = {}
        self:PlayPulseVisuals(caster)
        self:SetStackCount(1)
        EmitSoundOn("Ability.PlasmaField", caster)
        self:StartIntervalThink(self.think_tick)
    end)
end

function modifier_m_2_3_plasma_ring:GetRingValues(dist)
    local t = math.min(dist / self.radius, 1)
    local damage = self.damage_min + (self.damage_max - self.damage_min) * t
    local slow_pct = self.slow_min + (self.slow_max - self.slow_min) * t
    return damage, slow_pct
end

-- 仅播放等离子电圈；警示圈在 OnCreated 中只放一次
function modifier_m_2_3_plasma_ring:ClearActiveRingPfx()
    if self.active_ring_pfx then
        ParticleManager:DestroyParticle(self.active_ring_pfx, false)
        ParticleManager:ReleaseParticleIndex(self.active_ring_pfx)
        self.active_ring_pfx = nil
    end
end

function modifier_m_2_3_plasma_ring:PlayPulseVisuals(caster)
    if not caster or caster:IsNull() then
        return
    end
    self:ClearActiveRingPfx()

    local origin = caster:GetAbsOrigin()
    local radius = self.radius
    local expand_time = self.pulse_interval

    local pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_razor/razor_plasmafield.vpcf",
        PATTACH_WORLDORIGIN,
        nil
    )
    ParticleManager:SetParticleControl(pfx, 0, origin)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
    ParticleManager:SetParticleControl(pfx, 2, Vector(expand_time, 0, 0))
    self.active_ring_pfx = pfx

    local mod = self
    Timers(expand_time, function()
        if not mod or mod:IsNull() then
            return
        end
        if mod.active_ring_pfx == pfx then
            ParticleManager:DestroyParticle(pfx, false)
            ParticleManager:ReleaseParticleIndex(pfx)
            mod.active_ring_pfx = nil
        end
    end)
end

function modifier_m_2_3_plasma_ring:ApplyRingTouchDamage(caster, ring_radius)
    local ability = self:GetAbility()
    local origin = caster:GetAbsOrigin()
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        origin,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    for _, enemy in ipairs(enemies) do
        if enemy and not enemy:IsNull() and enemy:IsAlive() then
            local eid = enemy:entindex()
            if not self.pulse_hit[eid] then
                local dist = (enemy:GetAbsOrigin() - origin):Length2D()
                if ring_radius + self.hit_pad >= dist then
                    self.pulse_hit[eid] = true
                    local damage, slow_pct = self:GetRingValues(dist)
                    local impact = ParticleManager:CreateParticle(
                        "particles/units/heroes/hero_razor/razor_plasmafield_glow.vpcf",
                        PATTACH_ABSORIGIN_FOLLOW,
                        enemy
                    )
                    ParticleManager:ReleaseParticleIndex(impact)
                    ApplyDamage({
                        victim = enemy,
                        attacker = caster,
                        damage = damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = ability,
                    })
                    enemy:AddNewModifier(caster, ability, "modifier_m_2_3_plasma_ring_slow", {
                        duration = 1.5,
                        slow_pct = slow_pct,
                    })
                end
            end
        end
    end
end

function modifier_m_2_3_plasma_ring:OnIntervalThink()
    if not IsServer() then
        return
    end
    if not self.channel_started then
        return
    end
    local caster = self:GetParent()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        self:Destroy()
        return
    end

    local elapsed = GameRules:GetGameTime() - self.pulse_start_time
    local ring_radius = self.radius * math.min(elapsed / self.pulse_interval, 1)
    self:ApplyRingTouchDamage(caster, ring_radius)

    if elapsed >= self.pulse_interval then
        self.current_pulse = self.current_pulse + 1
        if self.current_pulse > self.pulse_count then
            self:StartIntervalThink(-1)
            return
        end
        self:RefreshRadius()
        self.pulse_start_time = GameRules:GetGameTime()
        self.pulse_hit = {}
        self:PlayPulseVisuals(caster)
        self:SetStackCount(self.current_pulse)
        EmitSoundOn("Ability.PlasmaField", caster)
    end
end

function modifier_m_2_3_plasma_ring:OnDestroy()
    if not IsServer() then
        return
    end
    self:ClearActiveRingPfx()
end

function modifier_m_2_3_plasma_ring:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }
end

LinkLuaModifier("modifier_m_2_3_plasma_ring_slow",
    "ingame/Monster/ability_m_2_3_plasma_ring",
    LUA_MODIFIER_MOTION_NONE)

if modifier_m_2_3_plasma_ring_slow == nil then
    modifier_m_2_3_plasma_ring_slow = class({})
end

function modifier_m_2_3_plasma_ring_slow:IsHidden()
    return false
end

function modifier_m_2_3_plasma_ring_slow:IsDebuff()
    return true
end

function modifier_m_2_3_plasma_ring_slow:IsPurgable()
    return true
end

function modifier_m_2_3_plasma_ring_slow:OnCreated(kv)
    self.slow_pct = kv.slow_pct or 15
end

function modifier_m_2_3_plasma_ring_slow:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_m_2_3_plasma_ring_slow:GetModifierMoveSpeedBonus_Percentage()
    return -(self.slow_pct or 0)
end
