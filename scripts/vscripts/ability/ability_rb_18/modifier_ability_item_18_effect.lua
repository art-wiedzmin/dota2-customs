--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 腐尸毒效果modifier
modifier_ability_item_18_effect = class({})

function modifier_ability_item_18_effect:IsHidden()
    return false
end

function modifier_ability_item_18_effect:IsDebuff()
    return true
end

function modifier_ability_item_18_effect:IsPurgable()
    return true
end

-- function modifier_ability_item_18_effect:GetAttributes()
--     return MODIFIER_ATTRIBUTE_MULTIPLE
-- end

function modifier_ability_item_18_effect:OnCreated(kv)
    if not IsServer() then return end
    local parent = self:GetParent()
    local base_dam = kv.dam or 0
    local add_dam = kv.dam2 or 0
    local ability = self:GetAbility()
    local hp_frac_pct = ability and ability.GetSpecialValueFor and ability:GetSpecialValueFor("num2") or 10
    local exp_dam = (parent:GetMaxHealth() * hp_frac_pct / 100) + add_dam
    -- 参数设置
    self.damage_per_second = base_dam
    self.explosion_radius = 400
    self.explosion_damage = exp_dam
    self.duration = 5

    -- 如果没有从ability获取到值，使用默认值
    if not self.damage_per_second then
        self.damage_per_second = 0
    end
    if not self.explosion_radius then
        self.explosion_radius = 0
    end
    if not self.explosion_damage then
        self.explosion_damage = 0
    end
    if not self.duration then
        self.duration = 5
    end

    -- 创建周期伤害
    if IsServer() then
        -- 立即造成第一次伤害
        self:OnIntervalThink()

        -- 设置周期伤害
        self:StartIntervalThink(1.0)

        -- 设置5秒后自动移除
        self:SetDuration(self.duration, true)
    end
end

function modifier_ability_item_18_effect:OnRefresh(kv)
    if not IsServer() then return end
    -- 刷新时重置持续时间
    if IsServer() then
        self:SetDuration(self.duration, true)
    end
end

function modifier_ability_item_18_effect:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local ability = self:GetAbility()
        local caster = self:GetCaster()

        -- 造成周期伤害
        local damageTable = {
            victim = parent,
            attacker = caster,
            damage = self.damage_per_second,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
        }

        ApplyDamage(damageTable)
    end
end

function modifier_ability_item_18_effect:OnDestroy()
    if IsServer() then
        -- 停止周期伤害
        self:StartIntervalThink(-1)
    end
end

function modifier_ability_item_18_effect:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_ability_item_18_effect:OnDeath(params)
    if IsServer() then
        local unit = params.unit

        -- 检查死亡的单位是否是携带此modifier的单位
        if unit == self:GetParent() then
            self:CreateDeathExplosion()
        end
    end
end

function modifier_ability_item_18_effect:CreateDeathExplosion()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local team = parent:GetTeamNumber()

    -- 查找范围内的同阵营单位
    local units = FindUnitsInRadius(
        team,
        parent:GetAbsOrigin(),
        nil,
        self.explosion_radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    -- 对每个单位造成伤害
    for _, target in pairs(units) do
        if target ~= parent then -- 不对自己造成伤害
            local damageTable = {
                victim = target,
                attacker = caster,
                damage = self.explosion_damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability
            }

            ApplyDamage(damageTable)
        end
    end

    -- 播放爆炸特效
    self:PlayExplosionEffect()
end

function modifier_ability_item_18_effect:PlayExplosionEffect()
    local parent = self:GetParent()

    -- 爆炸特效
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(self.explosion_radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)

    -- 爆炸音效
    EmitSoundOn("Ability.SandKing_CausticFinale", parent)
end