--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 剑气斩：攻击 15% 概率触发直线剑气（猛犸金色震荡波特效）
LinkLuaModifier("modifier_hero_8", "Ability/ability_hero_8/ability_hero_8",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_8_wave_sound", "Ability/ability_hero_8/ability_hero_8",
    LUA_MODIFIER_MOTION_NONE)

ability_hero_8 = class({})

local PFX_WAVE =
    "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf"
local PFX_CAST =
    "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil_cast.vpcf"
local PFX_VERT =
    "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil_verttrail.vpcf"
local PFX_PULSE_CROSS =
    "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil_pulse_cross.vpcf"
local PFX_HIT =
    "particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil_hit.vpcf"
local SFX_WAVE = "Hero_Magnataur.ShockWave.Cast"
local SFX_WAVE_TAIL = 0.65

function ability_hero_8:Precache(context)
    PrecacheResource("soundfile",
        "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)
end

local function hero8_set_wave_cp(pfx, pos, direction, speed)
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 1, direction * speed)
    ParticleManager:SetParticleControl(pfx, 3, pos + direction * 100)
    ParticleManager:SetParticleControlForward(pfx, 3, direction)
end

local function hero8_play_travel_fx(attacker, ability, start_pos, direction, distance, speed)
    local travel_time = distance / speed
    local end_pos = start_pos + direction * distance

    if attacker and not attacker:IsNull() and ability and not ability:IsNull() then
        CreateModifierThinker(
            attacker,
            ability,
            "modifier_hero_8_wave_sound",
            {
                duration = travel_time + SFX_WAVE_TAIL,
                x = start_pos.x,
                y = start_pos.y,
                z = start_pos.z,
                dx = direction.x,
                dy = direction.y,
                speed = speed,
                distance = distance,
            },
            start_pos,
            attacker:GetTeamNumber(),
            false
        )
    end

    local cast_fx = ParticleManager:CreateParticle(PFX_CAST, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(cast_fx, 0, start_pos)
    ParticleManager:ReleaseParticleIndex(cast_fx)

    local wave_fx = ParticleManager:CreateParticle(PFX_WAVE, PATTACH_WORLDORIGIN, nil)
    hero8_set_wave_cp(wave_fx, start_pos, direction, speed)

    local vert_fx = ParticleManager:CreateParticle(PFX_VERT, PATTACH_WORLDORIGIN, nil)
    hero8_set_wave_cp(vert_fx, start_pos, direction, speed)

    local pulse_fx = ParticleManager:CreateParticle(PFX_PULSE_CROSS, PATTACH_WORLDORIGIN, nil)
    hero8_set_wave_cp(pulse_fx, start_pos, direction, speed)

    if Timers then
        local elapsed = 0
        Timers(0.03, function()
            elapsed = elapsed + 0.03
            local t = math.min(elapsed / travel_time, 1)
            local pos = start_pos + direction * (distance * t)
            hero8_set_wave_cp(wave_fx, pos, direction, speed)
            hero8_set_wave_cp(vert_fx, pos, direction, speed)
            hero8_set_wave_cp(pulse_fx, pos, direction, speed)
            if t >= 1 then
                ParticleManager:DestroyParticle(wave_fx, false)
                ParticleManager:DestroyParticle(vert_fx, false)
                ParticleManager:DestroyParticle(pulse_fx, false)
                ParticleManager:ReleaseParticleIndex(wave_fx)
                ParticleManager:ReleaseParticleIndex(vert_fx)
                ParticleManager:ReleaseParticleIndex(pulse_fx)
                return nil
            end
            return 0.03
        end)
    else
        ParticleManager:DestroyParticle(wave_fx, false)
        ParticleManager:DestroyParticle(vert_fx, false)
        ParticleManager:DestroyParticle(pulse_fx, false)
        ParticleManager:ReleaseParticleIndex(wave_fx)
        ParticleManager:ReleaseParticleIndex(vert_fx)
        ParticleManager:ReleaseParticleIndex(pulse_fx)
    end

    return end_pos, travel_time
end

modifier_hero_8_wave_sound = class({})

function modifier_hero_8_wave_sound:IsHidden()
    return true
end

function modifier_hero_8_wave_sound:IsPurgable()
    return false
end

function modifier_hero_8_wave_sound:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.start_pos = Vector(tonumber(kv.x) or 0, tonumber(kv.y) or 0, tonumber(kv.z) or 0)
    self.direction = Vector(tonumber(kv.dx) or 0, tonumber(kv.dy) or 0, 0)
    if self.direction:Length2D() < 0.01 then
        self.direction = Vector(1, 0, 0)
    else
        self.direction = self.direction:Normalized()
    end
    self.speed = tonumber(kv.speed) or 2400
    self.distance = tonumber(kv.distance) or 1200
    self.travel_time = self.distance / self.speed
    self.elapsed = 0

    local thinker = self:GetParent()
    if thinker and not thinker:IsNull() then
        thinker:SetAbsOrigin(self.start_pos)
        EmitSoundOn(SFX_WAVE, thinker)
    end
    self:StartIntervalThink(0.03)
end

function modifier_hero_8_wave_sound:OnIntervalThink()
    if not IsServer() then
        return
    end
    self.elapsed = self.elapsed + 0.03
    local thinker = self:GetParent()
    if not thinker or thinker:IsNull() then
        return
    end
    local t = math.min(self.elapsed / self.travel_time, 1)
    thinker:SetAbsOrigin(self.start_pos + self.direction * (self.distance * t))
    if t >= 1 then
        self:StartIntervalThink(-1)
    end
end

function ability_hero_8:GetIntrinsicModifierName()
    return "modifier_hero_8"
end

function ability_hero_8:OnProjectileHit(target, location)
    if not IsServer() then
        return false
    end
    if not target or target:IsNull() or not target:IsAlive() then
        return false
    end

    local caster = self:GetCaster()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        return false
    end
    if target:GetTeamNumber() == caster:GetTeamNumber() then
        return false
    end

    local base_dmg = self:GetSpecialValueFor("num1")
    local atk_coef = self:GetSpecialValueFor("num2")
    local atk = Util:GetAverageTrueAttackDamage(caster)
    local damage = math.floor(base_dmg + atk * atk_coef)

    utilex:UnitDam(caster, target, damage, "wl", self)

    local hit_fx = ParticleManager:CreateParticle(PFX_HIT, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(hit_fx, 0, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(hit_fx)

    return false
end

modifier_hero_8 = class({})

function modifier_hero_8:IsHidden()
    return true
end

function modifier_hero_8:IsPurgable()
    return false
end

function modifier_hero_8:IsDebuff()
    return false
end

function modifier_hero_8:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_hero_8:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end

    local attacker = self:GetParent()
    local target = keys.target
    if not target or target:IsNull() or not target:IsAlive() then
        return
    end

    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return
    end

    local chance = ability:GetSpecialValueFor("num3")
    if math.random(1, 100) > chance then
        return
    end

    self:LaunchSwordWave(attacker, target, ability)
end

function modifier_hero_8:LaunchSwordWave(attacker, target, ability)
    local origin = attacker:GetAbsOrigin()
    local direction = target:GetAbsOrigin() - origin
    direction.z = 0
    if direction:Length2D() < 1 then
        direction = attacker:GetForwardVector()
    else
        direction = direction:Normalized()
    end

    local distance = ability:GetSpecialValueFor("wave_distance")
    local width = ability:GetSpecialValueFor("wave_width")
    local speed = ability:GetSpecialValueFor("wave_speed")

    local start_pos = origin + Vector(0, 0, 75)
    hero8_play_travel_fx(attacker, ability, start_pos, direction, distance, speed)

    -- 伤害判定用隐形线性投射物（视觉由上方手动粒子负责）
    ProjectileManager:CreateLinearProjectile({
        Ability = ability,
        vSpawnOrigin = start_pos,
        vVelocity = direction * speed,
        fDistance = distance,
        fStartRadius = width * 0.5,
        fEndRadius = width * 0.5,
        Source = attacker,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        fExpireTime = GameRules:GetGameTime() + distance / speed + 0.5,
        bDeleteOnHit = false,
        bProvidesVision = false,
        bVisibleToEnemies = false,
    })
end