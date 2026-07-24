--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 文件名：modifier_boss_1_buff.lua
LinkLuaModifier("modifier_boss_1_buff_slow", "ingame/modifier/modifier_boss_1_buff", LUA_MODIFIER_MOTION_NONE)
modifier_boss_1_buff = class({})

function modifier_boss_1_buff:IsHidden()
    return false
end

function modifier_boss_1_buff:IsDebuff()
    return false
end

function modifier_boss_1_buff:IsPurgable()
    return false
end

function modifier_boss_1_buff:RemoveOnDeath()
    return false
end

function modifier_boss_1_buff:AllowIllusionDuplicate()
    return false
end

function modifier_boss_1_buff:OnCreated(kv)
    if not IsServer() then return end

    local parent = self:GetParent()

    -- 阶段持续 8 秒；支持外部传入 dur 覆盖
    self.phase_duration = tonumber(kv and kv.dur) or 8
    self.interval = 0.5
    self.fissure_length = 2400
    self.fissure_width = 315
    self.slow_pct = 50         -- 对齐大牛三级减速
    self.slow_duration = 5     -- 对齐大牛三级持续
    self.damage_pct = 1.0      -- 强化到目标最大生命值 100%
    self.splitter_delay = 2.75 -- 大牛裂地者延迟

    self:SetDuration(self.phase_duration, true)

    local path = "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal.vpcf"
    utilex:AddTx(path, parent, self.phase_duration)

    self:StartIntervalThink(self.interval)
    self:OnIntervalThink()
end

function modifier_boss_1_buff:OnIntervalThink()
    if not IsServer() then return end

    local caster = self:GetParent()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        self:Destroy()
        return
    end

    self:CastRandomFissure(caster)
end

function modifier_boss_1_buff:CastRandomFissure(caster)
    local start_pos = caster:GetAbsOrigin()
    local random_angle = math.rad(math.random(0, 359))
    local direction = Vector(math.cos(random_angle), math.sin(random_angle), 0):Normalized()
    local fissure_length = 2400
    local fissure_width = 315
    local splitter_delay = 2.75
    local damage_pct = 1.0
    local end_pos = start_pos + direction * fissure_length * 2
    local end_damgepos = start_pos + direction * fissure_length
    local splitter_pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf",
        PATTACH_WORLDORIGIN,
        nil
    )
    ParticleManager:SetParticleControl(splitter_pfx, 0, start_pos)
    ParticleManager:SetParticleControl(splitter_pfx, 1, end_pos)
    -- x=延迟(裂缝蔓延到爆发时间), y=宽度
    ParticleManager:SetParticleControl(splitter_pfx, 2, Vector(splitter_delay, fissure_width, 0))
    ParticleManager:ReleaseParticleIndex(splitter_pfx)
    EmitSoundOnLocationWithCaster(start_pos, "Hero_ElderTitan.EarthSplitter.Projectile", caster)

    Timers(1, function()
        if not hero or hero:IsNull() or not hero:IsAlive() then return end

        local enemies = FindUnitsInLine(
            hero:GetTeamNumber(),
            start_pos,
            end_damgepos,
            nil,
            fissure_width,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        )
        -- print("splitter hit count:", #enemies)
        EmitSoundOnLocationWithCaster(start_pos, "Hero_ElderTitan.EarthSplitter.Destroy", caster)

        for _, enemy in pairs(enemies) do
            if enemy and not enemy:IsNull() and enemy:IsAlive() then
                local damage = enemy:GetMaxHealth() * damage_pct
                ApplyDamage({
                    victim = enemy,
                    attacker = caster,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = nil,
                    damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK
                })
            end
        end
    end)
end

function modifier_boss_1_buff:DeclareFunctions()
    return {}
end

function modifier_boss_1_buff:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,  -- 无敌
        [MODIFIER_STATE_ATTACK_IMMUNE] = true, -- 不能被普攻选为目标
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,  -- 技能免疫
        [MODIFIER_STATE_NO_HEALTH_BAR] = false
    }
end

modifier_boss_1_buff_slow = class({})

function modifier_boss_1_buff_slow:IsHidden()
    return false
end

function modifier_boss_1_buff_slow:IsDebuff()
    return true
end

function modifier_boss_1_buff_slow:IsPurgable()
    return true
end

function modifier_boss_1_buff_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_boss_1_buff_slow:OnCreated(kv)
    if not IsServer() then return end
    self.slow_pct = tonumber(kv and kv.slow_pct) or 50
end

function modifier_boss_1_buff_slow:GetModifierMoveSpeedBonus_Percentage()
    return -math.abs(self.slow_pct or 50)
end
