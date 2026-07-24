--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_hero_5", "Ability/ability_hero_5/ability_hero_5",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe_battle_hunger_debuff", "Ability/ability_hero_5/ability_hero_5",
    LUA_MODIFIER_MOTION_NONE)

ability_hero_5 = class({})

function ability_hero_5:GetIntrinsicModifierName()
    return "modifier_hero_5"
end

modifier_hero_5 = class({})

-- 添加必要的modifier函数
function modifier_hero_5:IsHidden() return true end

function modifier_hero_5:IsPurgable() return false end

function modifier_hero_5:IsDebuff() return false end

function modifier_hero_5:OnCreated()
    if not IsServer() then return end
    -- 修正：使用GetParent()而不是GetCaster()
    local hero = self:GetParent()
end

function modifier_hero_5:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_hero_5:OnAttackLanded(keys)
    if not IsServer() then return end
    -- 检查攻击者是否是拥有此modifier的英雄
    if keys.target == self:GetParent() then
        local attacker = keys.attacker
        local target = self:GetParent()
        -- 检查目标是否有效
        if not attacker or attacker:IsNull() or not attacker:IsAlive() then
            return
        end
        if math.random(1, 100) <= 15 then
            -- print("触发被动")
            local hero = target
            local ab = hero:FindAbilityByName("ability_hero_5")
            local level = ab:GetLevel()
            local dam_list = { 12, 18, 24, 30 }
            local move_list = { 18, 22, 26, 30 }
            local dam1 = dam_list[level]
            local dam2 = math.floor(hero:GetPhysicalArmorValue(true))
            local dam = dam1 + dam2
            local move = move_list[level]
            EmitSoundOn("Hero_Axe.Battle_Hunger", attacker)
            attacker:AddNewModifier(attacker, ab, "modifier_axe_battle_hunger_debuff", {
                damage = dam,
                move = move,
            })
        end
    end
end

-- 文件名: modifier_axe_battle_hunger_debuff.lua
-- 战争饥渴的debuff效果

-- 文件名: ability_hero_5.lua

modifier_axe_battle_hunger_debuff = class({})

-- Modifier 属性
function modifier_axe_battle_hunger_debuff:IsHidden() return false end

function modifier_axe_battle_hunger_debuff:IsPurgable() return true end

function modifier_axe_battle_hunger_debuff:IsDebuff() return true end

-- 初始化
function modifier_axe_battle_hunger_debuff:OnCreated(kv)
    if not IsServer() then return end

    -- 获取技能数据
    local ability = self:GetAbility()
    if not ability then return end

    -- 基础伤害
    self.damage_per_second = kv.damage or 0

    -- 移动速度减少百分比
    self.move_speed_reduction = kv.move or 0

    -- 存储原始移动速度减少值
    self.original_slow = self.move_speed_reduction

    -- 设置初始状态：减速生效
    self.slow_active = true

    -- 每1秒造成伤害
    self:StartIntervalThink(1.0)

    -- 每0.1秒检查朝向（用于更新减速状态）
    self:StartIntervalThink(0.2)

    -- 设置持续时间
    self:SetDuration(kv.duration or 12, true)

    -- 监听死亡事件
    self:StartIntervalThink(0.2) -- 我们重用一个间隔计时器

    -- 获取施法者
    self.caster = self:GetCaster()

    -- 设置栈计数为移动减速值，用于客户端同步
    self:SetStackCount(self.move_speed_reduction)
end

function modifier_axe_battle_hunger_debuff:OnRefresh(kv)
    if not IsServer() then return end

    -- 刷新时重置持续时间
    self:SetDuration(12, true)

    -- 更新数值
    if kv.damage then self.damage_per_second = kv.damage end
    if kv.move then
        self.move_speed_reduction = kv.move
        self.original_slow = self.move_speed_reduction
        self:SetStackCount(self.move_speed_reduction)
    end
end

-- 定期执行
function modifier_axe_battle_hunger_debuff:OnIntervalThink()
    if not IsServer() then return end

    local target = self:GetParent()
    local caster = self.caster

    if not target or target:IsNull() or not target:IsAlive() then
        self:Destroy()
        return
    end

    -- 检查是否击杀单位
    if target:IsIllusion() then
        -- 幻象死亡也移除debuff
        self:Destroy()
        return
    end

    -- 每秒造成伤害
    if self.next_damage_time == nil or GameRules:GetGameTime() >= self.next_damage_time then
        self.next_damage_time = GameRules:GetGameTime() + 1.0

        -- 计算实际伤害（考虑魔法抗性等）
        local damage = self.damage_per_second

        -- 应用伤害
        local damage_table = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self:GetAbility(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE
        }
        ApplyDamage(damage_table)
    end

    -- 检查朝向
    if caster and not caster:IsNull() and caster:IsAlive() then
        local target_forward = target:GetForwardVector()
        local to_caster = caster:GetAbsOrigin() - target:GetAbsOrigin()
        to_caster = to_caster:Normalized()

        -- 计算点积（dot product）
        local dot = target_forward:Dot(to_caster)

        -- 如果dot < 0.17（约80度），表示面向施法者（不减速）
        -- 如果dot > -0.17，表示背对施法者（减速）
        local is_facing_caster = dot > 0.17
        local is_facing_away = dot < -0.17

        -- 默认：如果既不是完全面向也不是完全背对，则保持当前状态
        if is_facing_caster then
            -- 面向施法者，移除减速
            if self.slow_active then
                self.slow_active = false
                self.move_speed_reduction = 0
                self:SetStackCount(0)
                -- print("面向施法者，移除减速")
            end
        elseif is_facing_away then
            -- 背对施法者，应用减速
            if not self.slow_active then
                self.slow_active = true
                self.move_speed_reduction = self.original_slow
                self:SetStackCount(self.move_speed_reduction)
                -- print("背对施法者，应用减速: " .. self.move_speed_reduction)
            end
        end
        -- 如果dot在[-0.17, 0.17]之间，保持当前状态
    else
        -- 施法者死亡或不存在，移除debuff
        self:Destroy()
    end
end

-- 监听死亡事件（使用modifier事件）
function modifier_axe_battle_hunger_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH,
    }
end

-- 当目标死亡时
function modifier_axe_battle_hunger_debuff:OnDeath(params)
    if not IsServer() then return end

    local unit = params.unit
    local attacker = params.attacker
    local target = self:GetParent()

    -- 检查死亡的单位是否是当前debuff的目标
    if unit == target then
        -- 目标死亡，移除debuff
        self:Destroy()
        return
    end

    -- 检查是否是目标击杀了其他单位
    if attacker == target then
        -- 目标击杀了单位，移除debuff
        self:Destroy()
        -- print("目标击杀了单位，移除战斗饥渴debuff")
    end
end

-- 移动速度减少
function modifier_axe_battle_hunger_debuff:GetModifierMoveSpeedBonus_Percentage()
    -- 使用栈计数获取移动减速值
    return -self:GetStackCount()
end

-- 特效相关
function modifier_axe_battle_hunger_debuff:GetEffectName()
    return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf"
end

function modifier_axe_battle_hunger_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

-- 可选：显示状态图标
function modifier_axe_battle_hunger_debuff:GetTexture()
    return "scroll/ability_hero_5"
end

-- 可选：状态效果
function modifier_axe_battle_hunger_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_battle_hunger.vpcf"
end

function modifier_axe_battle_hunger_debuff:StatusEffectPriority()
    return 10
end

-- 修改器销毁时
function modifier_axe_battle_hunger_debuff:OnDestroy()
    if not IsServer() then return end
    -- 清理工作
end