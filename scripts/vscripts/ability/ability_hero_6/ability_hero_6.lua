--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 文件名: ability_hero_6.lua (简化版本)
LinkLuaModifier("modifier_hero_6", "Ability/ability_hero_6/ability_hero_6", LUA_MODIFIER_MOTION_NONE)

ability_hero_6 = class({})

function ability_hero_6:GetIntrinsicModifierName()
    return "modifier_hero_6"
end

function ability_hero_6:OnProjectileHit(target, location)
    if not target then return true end

    local caster = self:GetCaster()

    if not caster or caster:IsNull() or not caster:IsAlive() then return true end
    if not target or target:IsNull() or not target:IsAlive() then return true end

    -- 获取技能等级
    local level = self:GetLevel()
    local damage_list = { 30, 45, 60, 75 }
    local damage = damage_list[level] or 30

    -- 应用伤害
    local damage_table = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self,
        damage_flags = DOTA_DAMAGE_FLAG_NONE
    }
    ApplyDamage(damage_table)

    -- 播放命中效果
    EmitSoundOn("Hero_Beastmaster.WildAxes.Impact", target)

    -- 显示伤害数字
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, damage, nil)

    return true
end

modifier_hero_6 = class({})

function modifier_hero_6:IsHidden() return true end

function modifier_hero_6:IsPurgable() return false end

function modifier_hero_6:IsDebuff() return false end

function modifier_hero_6:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_hero_6:OnAttackLanded(keys)
    if not IsServer() then return end

    -- 检查被攻击者是否是拥有此modifier的英雄
    if keys.target == self:GetParent() then
        local attacker = keys.attacker
        local target = self:GetParent()

        -- 检查攻击者是否有效
        if not attacker or attacker:IsNull() or not attacker:IsAlive() then return end

        -- 检查自身是否有效
        if not target or target:IsNull() or not target:IsAlive() then return end

        -- 获取技能
        local ability = self:GetAbility()
        if not ability then return end

        -- 15%触发概率
        if math.random(1, 100) <= 15 then
            -- 释放野性飞斧
            self:ThrowWildAxes(attacker, ability)
        end
    end
end

function modifier_hero_6:ThrowWildAxes(target, ability)
    local caster = self:GetParent()

    -- 技能等级
    local level = ability:GetLevel()
    local damage_list = { 30, 45, 60, 75 }
    local damage = damage_list[level] or 30

    -- 计算基础方向
    local caster_location = caster:GetAbsOrigin()
    local target_location = target:GetAbsOrigin()
    local direction = (target_location - caster_location):Normalized()

    -- 确保方向不是零向量
    if direction == Vector(0, 0, 0) then
        direction = caster:GetForwardVector()
    end

    -- 播放音效
    EmitSoundOn("Hero_Beastmaster.WildAxes", caster)

    -- 创建两把飞斧
    for i = 1, 2 do
        -- 角度偏移
        local angle_offset = (i == 1) and 15 or -15

        -- 计算旋转后的方向
        local rotated_direction = RotateVector2D(direction, angle_offset)

        -- 计算目标位置（沿着方向移动一定距离）
        local end_distance = 1300
        local target_pos = caster_location + rotated_direction * end_distance

        -- 创建投射物
        local projectile_info = {
            EffectName = "particles/units/heroes/hero_beastmaster/beastmaster_wildaxe.vpcf",
            Ability = ability,
            vSpawnOrigin = caster_location + Vector(0, 0, 100),
            vVelocity = rotated_direction * 1200, -- 增加速度
            fDistance = end_distance,
            fStartRadius = 50,                    -- 减小碰撞半径
            fEndRadius = 50,
            Source = caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            bDeleteOnHit = true,
            bProvidesVision = false,
            bDrawsOnMinimap = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            flExpireTime = GameRules:GetGameTime() + 10, -- 设置过期时间
            bIgnoreSource = true,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
            ExtraData = {
                damage = damage
            }
        }

        -- 创建投射物
        local projectile = ProjectileManager:CreateLinearProjectile(projectile_info)

        -- 调试信息
        DebugDrawLine(caster_location + Vector(0, 0, 100), target_pos, 255, 0, 0, false, 2)
        DebugDrawCircle(target_pos, Vector(0, 255, 0), 255, 50, false, 2)

        -- print("创建飞斧 #" .. i .. "，方向: " .. tostring(rotated_direction) .. "，速度: " .. tostring(rotated_direction * 1200))
    end
end

-- 辅助函数：在2D平面上旋转向量
function RotateVector2D(vector, angle_degrees)
    local angle_radians = math.rad(angle_degrees)
    local x = vector.x
    local y = vector.y
    local cos_theta = math.cos(angle_radians)
    local sin_theta = math.sin(angle_radians)

    local new_x = x * cos_theta - y * sin_theta
    local new_y = x * sin_theta + y * cos_theta

    return Vector(new_x, new_y, vector.z):Normalized()
end