--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if ability_m_2_3_eye_of_storm == nil then
    ability_m_2_3_eye_of_storm = class({})
end

LinkLuaModifier("modifier_m_2_3_eye_of_storm_trigger",
    "ingame/Monster/ability_m_2_3_eye_of_storm",
    LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_m_2_3_eye_of_storm_active",
    "ingame/Monster/ability_m_2_3_eye_of_storm",
    LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_m_2_3_eye_of_storm_armor",
    "ingame/Monster/ability_m_2_3_eye_of_storm",
    LUA_MODIFIER_MOTION_NONE)

function ability_m_2_3_eye_of_storm:GetIntrinsicModifierName()
    return "modifier_m_2_3_eye_of_storm_trigger"
end

function ability_m_2_3_eye_of_storm:StartEyeOfStorm()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        return
    end
    if not self:IsCooldownReady() then
        return
    end
    if caster:HasModifier("modifier_m_2_3_eye_of_storm_active") then
        return
    end
    self:StartCooldown(self:GetCooldown(-1))
    local duration = self:GetSpecialValueFor("duration")
    EmitSoundOn("Hero_Razor.Storm.Cast", caster)
    caster:AddNewModifier(caster, self, "modifier_m_2_3_eye_of_storm_active", { duration = duration })
end

if modifier_m_2_3_eye_of_storm_trigger == nil then
    modifier_m_2_3_eye_of_storm_trigger = class({})
end

function modifier_m_2_3_eye_of_storm_trigger:IsHidden()
    return true
end

function modifier_m_2_3_eye_of_storm_trigger:IsPurgable()
    return false
end

function modifier_m_2_3_eye_of_storm_trigger:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACKED }
end

function modifier_m_2_3_eye_of_storm_trigger:OnAttacked(params)
    if not IsServer() then
        return
    end
    if params.target ~= self:GetParent() then
        return
    end
    local attacker = params.attacker
    if not attacker or attacker:IsNull() or not attacker:IsHero() then
        return
    end
    if attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
        return
    end
    local ability = self:GetAbility()
    if ability then
        ability:StartEyeOfStorm()
    end
end

if modifier_m_2_3_eye_of_storm_active == nil then
    modifier_m_2_3_eye_of_storm_active = class({})
end

function modifier_m_2_3_eye_of_storm_active:IsHidden()
    return false
end

function modifier_m_2_3_eye_of_storm_active:IsPurgable()
    return false
end

function modifier_m_2_3_eye_of_storm_active:OnCreated(kv)
    local ability = self:GetAbility()
    self.radius = ability and ability:GetSpecialValueFor("radius") or 600
    self.strike_damage = ability and ability:GetSpecialValueFor("strike_damage") or 1500
    self.armor_reduction = ability and ability:GetSpecialValueFor("armor_reduction") or 2
    self.strike_interval = ability and ability:GetSpecialValueFor("strike_interval") or 0.3

    if IsServer() then
        local duration = kv.duration or (ability and ability:GetSpecialValueFor("duration")) or 30
        self:SetDuration(duration, false)
        EmitSoundOn("Hero_Razor.Storm.Loop", self:GetParent())
        self:StartIntervalThink(self.strike_interval)
    end

    local parent = self:GetParent()
    local storm_pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_razor/razor_rain_storm.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        parent
    )
    ParticleManager:SetParticleControl(storm_pfx, 0, parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(storm_pfx, 1, Vector(self.radius, 0, 0))
    self:AddParticle(storm_pfx, false, false, -1, false, false)
end

function modifier_m_2_3_eye_of_storm_active:PlayStrikeEffects(caster, target, play_sound)
    local origin = caster:GetAbsOrigin()
    local cloud_pos = origin + Vector(0, 0, 500)
    local strike_pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf",
        PATTACH_CUSTOMORIGIN,
        caster
    )
    ParticleManager:SetParticleControl(strike_pfx, 0, cloud_pos)
    ParticleManager:SetParticleControlEnt(
        strike_pfx,
        1,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        target:GetAbsOrigin(),
        true
    )
    ParticleManager:ReleaseParticleIndex(strike_pfx)
    if play_sound then
        EmitSoundOn("Hero_Razor.Storm.Strike", target)
    end
end

function modifier_m_2_3_eye_of_storm_active:OnStackCountChanged()
    if IsServer() then
        return
    end
    local stack = self:GetStackCount()
    local target_index = math.floor(stack / 10000)
    if target_index <= 0 then
        return
    end
    local target = EntIndexToHScript(target_index)
    if not target or target:IsNull() then
        return
    end
    local caster = self:GetParent()
    if not caster or caster:IsNull() then
        return
    end
    self:PlayStrikeEffects(caster, target, false)
end

function modifier_m_2_3_eye_of_storm_active:OnIntervalThink()
    if not IsServer() then
        return
    end
    local caster = self:GetParent()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        self:Destroy()
        return
    end
    local ability = self:GetAbility()
    local team = caster:GetTeamNumber()
    local origin = caster:GetAbsOrigin()
    local enemies = FindUnitsInRadius(
        team,
        origin,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    if #enemies == 0 then
        return
    end
    local target = enemies[1]
    for _, unit in ipairs(enemies) do
        if unit:IsHero() then
            target = unit
            break
        end
    end
    if not target or target:IsNull() then
        return
    end

    self.strike_tick = (self.strike_tick or 0) + 1
    self:SetStackCount(target:entindex() * 10000 + self.strike_tick)
    EmitSoundOn("Hero_Razor.Storm.Strike", target)

    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = self.strike_damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = ability,
        damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
    })
    target:AddNewModifier(caster, ability, "modifier_m_2_3_eye_of_storm_armor", {
        duration = 5,
        armor_reduction = self.armor_reduction,
    })
end

function modifier_m_2_3_eye_of_storm_active:OnDestroy()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    if parent and not parent:IsNull() then
        StopSoundOn("Hero_Razor.Storm.Loop", parent)
        EmitSoundOn("Hero_Razor.StormEnd", parent)
    end
end

if modifier_m_2_3_eye_of_storm_armor == nil then
    modifier_m_2_3_eye_of_storm_armor = class({})
end

function modifier_m_2_3_eye_of_storm_armor:IsHidden()
    return false
end

function modifier_m_2_3_eye_of_storm_armor:IsDebuff()
    return true
end

function modifier_m_2_3_eye_of_storm_armor:IsPurgable()
    return true
end

function modifier_m_2_3_eye_of_storm_armor:OnCreated(kv)
    self.armor_reduction = kv.armor_reduction or 2
end

function modifier_m_2_3_eye_of_storm_armor:DeclareFunctions()
    return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_m_2_3_eye_of_storm_armor:GetModifierPhysicalArmorBonus()
    return -(self.armor_reduction or 0)
end
