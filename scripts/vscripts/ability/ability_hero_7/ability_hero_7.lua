-- 文件名: ability_hero_7.lua
LinkLuaModifier("modifier_hero_7", "Ability/ability_hero_7/ability_hero_7", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_firestorm_burn", "Ability/ability_hero_7/ability_hero_7", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_firestorm_thinker", "Ability/ability_hero_7/ability_hero_7", LUA_MODIFIER_MOTION_NONE)

ability_hero_7 = class({})

function ability_hero_7:GetIntrinsicModifierName()
    return "modifier_hero_7"
end

function ability_hero_7:GetCastRange()
    return 0 -- 被动技能
end

function ability_hero_7:GetCooldown()
    return 0 -- 被动技能
end

function ability_hero_7:IsStealable()
    return false
end

function ability_hero_7:IsHiddenWhenStolen()
    return true
end

modifier_hero_7 = class({})

-- Modifier属性
function modifier_hero_7:IsHidden() return true end

function modifier_hero_7:IsPurgable() return false end

function modifier_hero_7:IsDebuff() return false end

-- 声明函数
function modifier_hero_7:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

-- 被攻击时触发
function modifier_hero_7:OnAttackLanded(keys)
    if not IsServer() then return end

    -- 检查被攻击者是否是拥有此modifier的英雄
    if keys.target == self:GetParent() then
        local attacker = keys.attacker
        local target = self:GetParent()

        -- 检查攻击者是否有效
        if not attacker or attacker:IsNull() or not attacker:IsAlive() then
            return
        end

        -- 检查自身是否有效
        if not target or target:IsNull() or not target:IsAlive() then
            return
        end

        -- 获取技能等级和触发概率
        local ability = self:GetAbility()
        if not ability then return end

        local level = ability:GetLevel()
        if level == 0 then return end -- 技能未学习
        --内置1秒CD
        if target.ability_hero_7 == true then
            return
        end
        target.ability_hero_7 = true
        Timers(1, function()
            target.ability_hero_7 = false
        end)
        -- 触发概率（15%）
        local trigger_chance = 15

        if math.random(1, 100) <= trigger_chance then
            -- 在攻击者位置释放火焰风暴
            self:CastFirestorm(attacker, ability, level)
        end
    end
end

-- 释放火焰风暴
function modifier_hero_7:CastFirestorm(target, ability, level)
    local caster = self:GetParent()

    --print("释放火焰风暴 - 目标: " .. target:GetUnitName())

    -- 技能等级数据
    local wave_damage_list = { 30, 60, 90, 120 } -- 每波直接伤害
    local burn_percent_list = { 2, 3, 4, 5 }     -- 烧灼最大生命值百分比
    local radius = 425                           -- 作用范围
    local wave_count = 6                         -- 风暴波数
    local wave_interval = 1.0                    -- 每波间隔
    local burn_duration = 2.0                    -- 烧灼持续时间

    local wave_damage = wave_damage_list[level] or 30
    local burn_percent = burn_percent_list[level] or 1.5

    -- 目标位置
    local target_location = target:GetAbsOrigin()

    -- 播放音效
    EmitSoundOn("Hero_AbyssalUnderlord.Firestorm.Cast", caster)

    -- 创建火焰风暴思考者
    local thinker = CreateModifierThinker(
        caster,                                          -- 施法者
        ability,                                         -- 技能
        "modifier_firestorm_thinker",                    -- modifier
        {                                                -- 参数
            duration = wave_count * wave_interval + 0.1, -- 稍微延长一点确保所有波完成
            wave_damage = wave_damage,
            burn_percent = burn_percent,
            wave_interval = wave_interval,
            radius = radius,
            burn_duration = burn_duration,
            wave_count = wave_count,
            level = level
        },
        target_location,        -- 位置
        caster:GetTeamNumber(), -- 队伍
        false                   -- 不可见
    )

    -- 播放粒子特效
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, target_location)
    ParticleManager:SetParticleControl(particle, 1, Vector(radius, wave_count, wave_interval))
    ParticleManager:SetParticleControl(particle, 2, Vector(wave_count * wave_interval, 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)



    -- 施法动画
    --caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

    --print("火焰风暴创建完成，位置: " .. tostring(target_location))
    --print("参数: 每波伤害=" .. wave_damage .. ", 烧灼百分比=" .. burn_percent .. "%, 半径=" .. radius)
end

-- 火焰风暴思考者（控制火焰风暴效果）
modifier_firestorm_thinker = class({})

function modifier_firestorm_thinker:IsHidden() return true end

function modifier_firestorm_thinker:IsPurgable() return false end

function modifier_firestorm_thinker:IsDebuff() return false end

function modifier_firestorm_thinker:OnCreated(kv)
    if not IsServer() then return end

    -- 获取参数
    self.wave_damage = kv.wave_damage or 30
    self.burn_percent = kv.burn_percent or 1.5
    self.wave_interval = kv.wave_interval or 1.0
    self.radius = kv.radius or 425
    self.burn_duration = kv.burn_duration or 2.0
    self.total_waves = kv.wave_count or 6
    self.level = kv.level or 1

    -- 当前波数
    self.current_wave = 0

    -- 获取父单位（思考者）
    self.thinker = self:GetParent()

    -- 获取施法者和技能
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    -- print("火焰风暴思考者创建")
    -- print("  半径: " .. self.radius)
    -- print("  总波数: " .. self.total_waves)
    -- print("  每波伤害: " .. self.wave_damage)
    -- print("  烧灼百分比: " .. self.burn_percent .. "%")
    -- print("  波间隔: " .. self.wave_interval)

    -- 开始定时造成伤害
    self:StartIntervalThink(self.wave_interval)
end

function modifier_firestorm_thinker:OnIntervalThink()
    if not IsServer() then return end

    -- 增加波数
    self.current_wave = self.current_wave + 1

    if self.current_wave > self.total_waves then
        -- 所有波数完成，移除思考者
        self:Destroy()
        return
    end

    --print("火焰风暴第 " .. self.current_wave .. " 波")

    -- 获取思考者位置
    local thinker_location = self.thinker:GetAbsOrigin()
    local tx2 = "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf"
    for i = 1, 5 do
        local pos = utilex:RandomPos(thinker_location, 0, 425)
        utilex:AddParticllesPos(tx2, pos, 1)
    end
    -- 播放一波火焰风暴的音效
    EmitSoundOnLocationWithCaster(thinker_location, "Hero_AbyssalUnderlord.Firestorm", self.caster)

    -- 查找范围内的敌人
    local enemies = FindUnitsInRadius(
        self.caster:GetTeamNumber(),                    -- 队伍
        thinker_location,                               -- 位置
        nil,                                            -- 缓存单位
        self.radius,                                    -- 半径
        DOTA_UNIT_TARGET_TEAM_ENEMY,                    -- 敌方单位
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- 英雄和普通单位
        DOTA_UNIT_TARGET_FLAG_NONE,                     -- 标志
        FIND_ANY_ORDER,                                 -- 查找顺序
        false                                           -- 是否可以成长
    )

    --print("找到 " .. #enemies .. " 个敌人")

    -- 对每个敌人造成伤害并添加烧灼debuff
    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and enemy:IsAlive() then
            -- 计算直接伤害
            local damage = self.wave_damage

            -- 造成直接伤害
            local damage_table = {
                victim = enemy,
                attacker = self.caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability,
                damage_flags = DOTA_DAMAGE_FLAG_NONE
            }
            ApplyDamage(damage_table)

            -- 显示伤害数字
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, enemy, damage, nil)

            -- 添加烧灼debuff（基于最大生命值的百分比伤害）
            enemy:AddNewModifier(
                self.caster,
                self.ability,
                "modifier_firestorm_burn",
                {
                    duration = self.burn_duration,
                    burn_percent = self.burn_percent,
                    level = self.level
                }
            )

            -- print("  对 " .. enemy:GetUnitName() .. " 造成 " .. damage .. " 直接伤害，添加烧灼效果")
        end
    end
end

function modifier_firestorm_thinker:OnDestroy()
    if not IsServer() then return end
    --print("火焰风暴结束")
    if self.thinker and not self.thinker:IsNull() then
        self.thinker:ForceKill(false) -- 移除思考者
    end
end

-- 烧灼debuff效果
modifier_firestorm_burn = class({})

function modifier_firestorm_burn:IsHidden() return false end

function modifier_firestorm_burn:IsPurgable() return true end

function modifier_firestorm_burn:IsDebuff() return true end

function modifier_firestorm_burn:OnCreated(kv)
    if not IsServer() then return end

    self.burn_percent = kv.burn_percent or 1.5
    self.level = kv.level or 1

    --print("烧灼debuff创建，百分比: " .. self.burn_percent .. "%")

    -- 设置每0.5秒造成一次伤害
    self:StartIntervalThink(0.5)
end

function modifier_firestorm_burn:OnRefresh(kv)
    if not IsServer() then return end

    -- 刷新时更新参数
    if kv.burn_percent then
        self.burn_percent = kv.burn_percent
    end

    if kv.level then
        self.level = kv.level
    end

    -- 刷新持续时间
    self:SetDuration(kv.duration or 2.0, true)

    --print("烧灼debuff刷新，百分比: " .. self.burn_percent .. "%")
end

function modifier_firestorm_burn:OnIntervalThink()
    if not IsServer() then return end

    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    if not parent or parent:IsNull() or not parent:IsAlive() then
        self:Destroy()
        return
    end

    -- 计算烧灼伤害（基于最大生命值的百分比）
    local max_hp = parent:GetMaxHealth()
    local burn_damage = max_hp * (self.burn_percent / 100)

    if burn_damage > 0 then
        -- 造成烧灼伤害
        local damage_table = {
            victim = parent,
            attacker = caster,
            damage = burn_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability,
            damage_flags = DOTA_DAMAGE_FLAG_NONE
        }
        ApplyDamage(damage_table)

        -- 显示较小的伤害数字（用不同的颜色）
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, parent, math.floor(burn_damage), nil)
    end
end

function modifier_firestorm_burn:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_firestorm_burn:OnTooltip()
    return self.burn_percent
end

function modifier_firestorm_burn:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_firestorm_burn:GetTexture()
    return "abyssal_underlord_firestorm"
end

function modifier_firestorm_burn:GetStatusEffectName()
    return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_firestorm_burn:StatusEffectPriority()
    return 10
end
