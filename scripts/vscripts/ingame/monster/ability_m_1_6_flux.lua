--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if ability_m_1_6_flux == nil then
    ability_m_1_6_flux = class({})
end

LinkLuaModifier("modifier_m_1_6_flux",
    "ingame/Monster/ability_m_1_6_flux",
    LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_m_1_6_flux_attack",
    "ingame/Monster/ability_m_1_6_flux",
    LUA_MODIFIER_MOTION_NONE)

function ability_m_1_6_flux:GetCastRange(location, target)
    local range = self:GetSpecialValueFor("AbilityCastRange")
    if range <= 0 then
        range = 1000
    end
    return range
end

function ability_m_1_6_flux:CastFilterResultTarget(target)
    if not target or target:IsNull() then
        return UF_FAIL_CUSTOM
    end
    if target:IsInvulnerable() then
        return UF_FAIL_INVULNERABLE
    end
    if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        return UF_FAIL_FRIENDLY
    end
    if target:IsBuilding() or target:IsOther() then
        return UF_FAIL_CUSTOM
    end
    return UF_SUCCESS
end

function ability_m_1_6_flux:CanFluxTarget(caster, target)
    if not caster or caster:IsNull() or not caster:IsAlive() then
        return false
    end
    if caster:IsStunned() or caster:IsSilenced() then
        return false
    end
    if not target or target:IsNull() or not target:IsAlive() or target:IsInvulnerable() then
        return false
    end
    if target:GetTeamNumber() == caster:GetTeamNumber() then
        return false
    end
    if target:IsBuilding() or target:IsOther() then
        return false
    end
    return true
end

function ability_m_1_6_flux:ApplyFluxToTarget(target)
    if not IsServer() then
        return false
    end
    local caster = self:GetCaster()
    if not self:CanFluxTarget(caster, target) then
        return false
    end

    local duration = self:GetSpecialValueFor("duration")
    if duration <= 0 then
        duration = 3
    end

    EmitSoundOn("Hero_ArcWarden.Flux.Target", target)

    local slow_pct = self:GetSpecialValueFor("move_speed_slow_pct")
    if slow_pct <= 0 then
        slow_pct = 35
    end

    target:AddNewModifier(caster, self, "modifier_m_1_6_flux", {
        duration = duration,
        slow_pct = slow_pct,
    })
    return true
end

function ability_m_1_6_flux:OnSpellStart()
    if not IsServer() then
        return
    end
    self:ApplyFluxToTarget(self:GetCursorTarget())
end

if modifier_m_1_6_flux == nil then
    modifier_m_1_6_flux = class({})
end

function modifier_m_1_6_flux:IsHidden()
    return false
end

function modifier_m_1_6_flux:IsDebuff()
    return true
end

function modifier_m_1_6_flux:IsPurgable()
    return true
end

function modifier_m_1_6_flux:OnCreated(kv)
    self.slow_pct = kv and kv.slow_pct or 35
    if not IsServer() then
        return
    end
    local ability = self:GetAbility()
    if self.slow_pct <= 0 then
        self.slow_pct = ability and ability:GetSpecialValueFor("move_speed_slow_pct") or 35
        if self.slow_pct <= 0 then
            self.slow_pct = 35
        end
    end
    self.tick_interval = ability and ability:GetSpecialValueFor("tick_interval") or 0.25
    local dps = ability and ability:GetSpecialValueFor("damage_per_second") or 0
    self.damage_per_tick = ability and ability:GetSpecialValueFor("damage_per_tick") or 0
    if self.damage_per_tick <= 0 and dps > 0 and self.tick_interval > 0 then
        self.damage_per_tick = dps * self.tick_interval
    end
    if self.damage_per_tick <= 0 then
        self.damage_per_tick = 15
    end
    if self.tick_interval <= 0 then
        self.tick_interval = 0.25
    end
    self:StartIntervalThink(self.tick_interval)
end

function modifier_m_1_6_flux:OnIntervalThink()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    if not parent or parent:IsNull() or not parent:IsAlive() then
        return
    end
    if not caster or caster:IsNull() then
        return
    end
    ApplyDamage({
        victim = parent,
        attacker = caster,
        damage = self.damage_per_tick or 15,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    })
end

function modifier_m_1_6_flux:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_m_1_6_flux:GetModifierMoveSpeedBonus_Percentage()
    return -(self.slow_pct or 35)
end

function modifier_m_1_6_flux:GetEffectName()
    return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
end

function modifier_m_1_6_flux:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

-- 攻击命中且技能未冷却时自动对目标释放
if modifier_m_1_6_flux_attack == nil then
    modifier_m_1_6_flux_attack = class({})
end

function modifier_m_1_6_flux_attack:IsHidden()
    return true
end

function modifier_m_1_6_flux_attack:IsPurgable()
    return false
end

function modifier_m_1_6_flux_attack:RemoveOnDeath()
    return false
end

function modifier_m_1_6_flux_attack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_m_1_6_flux_attack:CanProcOnTarget(target)
    if not target or target:IsNull() or not target:IsAlive() or target:IsInvulnerable() then
        return false
    end
    if not target:IsHero() or not target:IsRealHero() then
        return false
    end
    return true
end

function modifier_m_1_6_flux_attack:TryProcFlux(caster, target)
    if not caster or caster:IsNull() or not self:CanProcOnTarget(target) then
        return
    end
    local now = GameRules:GetGameTime()
    if self.last_proc_time and (now - self.last_proc_time) < 0.15 then
        return
    end
    local ab = caster:FindAbilityByName("ability_m_1_6_flux")
    if not ab or ab:IsNull() or not ab:IsCooldownReady() then
        return
    end
    if ab.ApplyFluxToTarget and ab:ApplyFluxToTarget(target) then
        ab:StartCooldown(ab:GetCooldown(ab:GetLevel()))
        self.last_proc_time = now
    end
end

function modifier_m_1_6_flux_attack:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    local caster = self:GetParent()
    if not caster or caster:IsNull() or params.attacker ~= caster then
        return
    end
    local target = params.target
    if not self:CanProcOnTarget(target) then
        return
    end
    local caster_ref = caster
    local target_ref = target
    local mod = self
    Timers:CreateTimer(0, function()
        if not caster_ref or caster_ref:IsNull() or not caster_ref:IsAlive() then
            return
        end
        if not target_ref or target_ref:IsNull() or not target_ref:IsAlive() then
            return
        end
        mod:TryProcFlux(caster_ref, target_ref)
    end)
end
