--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_dragon_hp30_invuln = class({})

function modifier_dragon_hp30_invuln:IsHidden() return false end

function modifier_dragon_hp30_invuln:IsDebuff() return false end

function modifier_dragon_hp30_invuln:IsPurgable() return false end

function modifier_dragon_hp30_invuln:RemoveOnDeath() return true end

function modifier_dragon_hp30_invuln:IsPermanent() return false end

function modifier_dragon_hp30_invuln:OnCreated(kv)
    if not IsServer() then return end

    self.duration = 8
    self.tick = 0.5
    self.cast_delay = 1.5
    self.search_radius = 750
    self.impact_radius = 300
    self.damage_pct = 0.30
    self.pending_impact_timers = {}
    self.expire_timer_name = nil
    -- 落点相对面朝方向的随机偏角（度），左右各不超过该值
    self.aim_angle_max = 180
    self.cast_dist_min = nil
    self.cast_dist_max = nil

    if kv then
        if tonumber(kv.duration) then self.duration = tonumber(kv.duration) end
        if tonumber(kv.dur) then self.duration = tonumber(kv.dur) end
        if tonumber(kv.tick) then self.tick = tonumber(kv.tick) end
        if tonumber(kv.cast_delay) then self.cast_delay = tonumber(kv.cast_delay) end
        if tonumber(kv.aim_angle_max) then self.aim_angle_max = tonumber(kv.aim_angle_max) end
        if tonumber(kv.cast_dist_min) then self.cast_dist_min = tonumber(kv.cast_dist_min) end
        if tonumber(kv.cast_dist_max) then self.cast_dist_max = tonumber(kv.cast_dist_max) end
    end

    -- false：按绝对剩余时间计；部分版本下 true 会导致到期行为异常
    self:SetDuration(self.duration, false)
    local mod = self
    self.expire_timer_name = Timers:CreateTimer(self.duration, function()
        if mod then mod.expire_timer_name = nil end
        if mod and not mod:IsNull() then
            mod:Destroy()
        end
    end)

    self:StartIntervalThink(self.tick)
    self:OnIntervalThink()
end

local function modifier_dragon_hp30_invuln_DoSplitEarth(self, caster, pos)
    if not self or self:IsNull() then return end
    if not caster or caster:IsNull() or not caster:IsAlive() then return end
    if not pos then return end

    local pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf",
        PATTACH_WORLDORIGIN,
        nil
    )
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 1, Vector(self.impact_radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)
    EmitSoundOnLocationWithCaster(pos, "Hero_Leshrac.Split_Earth", caster)

    local victims = FindUnitsInRadius(
        caster:GetTeamNumber(),
        pos,
        nil,
        self.impact_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    for _, enemy in ipairs(victims) do
        if enemy and not enemy:IsNull() and enemy:IsAlive() then
            ApplyDamage({
                victim = enemy,
                attacker = caster,
                damage = enemy:GetMaxHealth() * self.damage_pct,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = nil,
                damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK
            })
            Util:AddStun(enemy, 1.5)
        end
    end
end

local function modifier_dragon_hp30_pick_aim_pos(self, caster)
    if not caster then return nil end
    local f = caster:GetForwardVector()
    f.z = 0
    if f:Length2D() < 0.01 then
        f = Vector(1, 0, 0)
    else
        f = f:Normalized()
    end
    local angle = RandomFloat(-self.aim_angle_max, self.aim_angle_max)
    local dir = RotatePosition(Vector(0, 0, 0), QAngle(0, angle, 0), f)
    dir.z = 0
    if dir:Length2D() < 0.01 then
        dir = f
    else
        dir = dir:Normalized()
    end
    local dmin = self.cast_dist_min or self.impact_radius
    local dmax = self.cast_dist_max or self.search_radius
    if dmax < dmin then dmax = dmin end
    local dist = RandomFloat(dmin, dmax)
    local raw = caster:GetAbsOrigin() + dir * dist
    return GetGroundPosition(raw, caster)
end

function modifier_dragon_hp30_invuln:OnIntervalThink()
    if not IsServer() then return end

    local caster = self:GetParent()
    if not caster or caster:IsNull() or not caster:IsAlive() then
        self:Destroy()
        return
    end

    local impact_pos = modifier_dragon_hp30_pick_aim_pos(self, caster)
    if not impact_pos then return end

    self:ForceRefresh()

    local face = impact_pos - caster:GetAbsOrigin()
    face.z = 0
    if face:Length2D() > 0.01 then
        caster:SetForwardVector(face:Normalized())
    end

    caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

    -- 用带提示圈的版本，避免额外外框粒子出现底图方块
    RedTip:LifeCircle_add(impact_pos, self.cast_delay, self.impact_radius)

    -- 每个红圈独立计时落地；勿用单计时器并在新圈时 Remove，否则 0.5s tick 会不断取消上一段，永远不出撕裂大地
    local pos_fixed = Vector(impact_pos.x, impact_pos.y, impact_pos.z)
    local delay = self.cast_delay
    local mod = self
    local tname = DoUniqueString("dragon_hp30_split_")
    self.pending_impact_timers[tname] = true
    Timers:CreateTimer(tname, {
        endTime = delay,
        callback = function()
            if mod.pending_impact_timers then
                mod.pending_impact_timers[tname] = nil
            end
            if not mod or mod:IsNull() then return end
            mod:ForceRefresh()
            local c = mod:GetParent()
            if not c or c:IsNull() or not c:IsAlive() then return end
            modifier_dragon_hp30_invuln_DoSplitEarth(mod, c, pos_fixed)
        end
    })
end

function modifier_dragon_hp30_invuln:OnDestroy()
    if not IsServer() then return end
    if self.pending_impact_timers then
        for name, _ in pairs(self.pending_impact_timers) do
            Timers:RemoveTimer(name)
        end
        self.pending_impact_timers = {}
    end
    if self.expire_timer_name then
        Timers:RemoveTimer(self.expire_timer_name)
        self.expire_timer_name = nil
    end
end

function modifier_dragon_hp30_invuln:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }
end
