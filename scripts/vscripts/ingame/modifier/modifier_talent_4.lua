--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 雷电戟（item_goods_24）：攻击附带雷电伤害 + 20% 连锁闪电（漩涡式逐段弹跳）；全属性为绿字
if modifier_talent_4 == nil then
    modifier_talent_4 = class({})
end

LinkLuaModifier("modifier_talent_4_chain_slow",
    "ingame/modifier/modifier_talent_4",
    LUA_MODIFIER_MOTION_NONE)

local ON_HIT_MAGIC = { 25, 50, 75, 100, 125, 150 }
local ALLSTAT_PER_RANK = { 6, 6, 6, 6, 6, 6 }
local CHAIN_BASE = { 80, 120, 160, 200, 240, 300 }
local CHAIN_STAT_COEF = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6 }
local CHAIN_RADIUS = 650
local CHAIN_MAX_TARGETS = 5
local CHAIN_PROC_CHANCE = 20
local CHAIN_MAIN_SLOW = 0.3
local CHAIN_JUMP_DELAY = 0.12
-- 连锁闪电触发内置冷却（秒）
local CHAIN_ICD = 0.2

local PFX_CHAIN =
    "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_maelstrom_v2_item.vpcf"
local PFX_IMPACT =
    "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_maelstrom_v2_impact.vpcf"
local PFX_IMPACT_ENABLED = false -- 暂时隐藏命中冲击特效
local SFX_CHAIN = "Hero_Zuus.ArcLightning.Cast"

local function clrb_talent4_is_valid_enemy(attacker, unit, skip_set)
    if not unit or unit:IsNull() or not unit:IsAlive() then
        return false
    end
    if unit:IsBuilding() or unit:IsCourier() then
        return false
    end
    if unit:IsMagicImmune() then
        return false
    end
    if unit:GetTeamNumber() == attacker:GetTeamNumber() then
        return false
    end
    if skip_set and skip_set[unit] then
        return false
    end
    return true
end

function modifier_talent_4:IsDebuff()
    return false
end

function modifier_talent_4:IsPurgable()
    return false
end

function modifier_talent_4:IsHidden()
    return true
end

function modifier_talent_4:RemoveOnDeath()
    return false
end

function modifier_talent_4:AllowIllusionDuplicate()
    return false
end

function modifier_talent_4:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:ForceRefresh()
end

function modifier_talent_4:_AllstatBonus()
    local level = self:_EquipLevel()
    local sum = 0
    local ID = Util:Hero2ID(self:GetParent())
    for lv = 0, level do
        local v = ALLSTAT_PER_RANK[lv + 1] or 0
        if v > 0 and ID and ClrbTalentBlacksmithScaledEquipAttr then
            v = ClrbTalentBlacksmithScaledEquipAttr(ID, "item_goods_24", "jcll", v)
        end
        sum = sum + v
    end
    return sum
end

function modifier_talent_4:OnRefresh(kv)
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    local ID = Util:Hero2ID(hero)
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID]
        or not HeroData.Data[ID].hero_attr then
        self:SetStackCount(0)
        self.allstat_bonus = 0
        return
    end
    self.lqjs = HeroData.Data[ID].hero_attr.lqjs or 0
    self.allstat_bonus = self:_AllstatBonus()
    self:SetStackCount(self.lqjs)
    hero:CalculateStatBonus(true)
end

function modifier_talent_4:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_talent_4:GetModifierBonusStats_Strength()
    return self.allstat_bonus or 0
end

function modifier_talent_4:GetModifierBonusStats_Agility()
    return self.allstat_bonus or 0
end

function modifier_talent_4:GetModifierBonusStats_Intellect()
    return self.allstat_bonus or 0
end

function modifier_talent_4:GetModifierPercentageCooldown()
    return self:GetStackCount()
end

function modifier_talent_4:_EquipLevel()
    local ca = self:GetParent()
    local ID = Util:Hero2ID(ca)
    if not ID or not Talent or not Talent.Data or not Talent.Data[ID] then
        return 0
    end
    return Talent.Data[ID].level or 0
end

function modifier_talent_4:_LevelValue(list, level)
    local idx = (level or 0) + 1
    if idx < 1 then
        idx = 1
    end
    if idx > #list then
        idx = #list
    end
    return list[idx]
end

function modifier_talent_4:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    local ca = self:GetParent()
    local ta = keys.target
    if not clrb_talent4_is_valid_enemy(ca, ta, nil) then
        return
    end
    if not ca:IsHero() then
        return
    end

    local level = self:_EquipLevel()
    local on_hit = self:_LevelValue(ON_HIT_MAGIC, level)
    utilex:UnitDam(ca, ta, on_hit, "mf", nil, true)

    if math.random(1, 100) <= CHAIN_PROC_CHANCE then
        local now = (GameRules and GameRules.GetGameTime and GameRules:GetGameTime()) or 0
        if not self._chain_icd_until or now >= self._chain_icd_until then
            self._chain_icd_until = now + CHAIN_ICD
            self:_ProcChainLightning(ca, ta, level)
        end
    end
end

local function clrb_talent4_beam_pos(unit)
    if not unit or unit:IsNull() then
        return Vector(0, 0, 0)
    end
    local pos = unit:GetAbsOrigin()
    local minb = unit:GetBoundingMins()
    local maxb = unit:GetBoundingMaxs()
    if minb and maxb then
        return Vector(pos.x, pos.y, pos.z + (maxb.z - minb.z) * 0.5)
    end
    return pos
end

function modifier_talent_4:_PlayChainBeam(from_unit, to_unit)
    if not from_unit or from_unit:IsNull() or not to_unit or to_unit:IsNull() then
        return
    end
    local from_pos = clrb_talent4_beam_pos(from_unit)
    local to_pos = clrb_talent4_beam_pos(to_unit)
    local fx = ParticleManager:CreateParticle(PFX_CHAIN, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(fx, 0, from_pos)
    ParticleManager:SetParticleControl(fx, 1, to_pos)
    ParticleManager:SetParticleControl(fx, 2, Vector(1, 1, 1))
    Timers(0.55, function()
        if fx then
            ParticleManager:DestroyParticle(fx, false)
            ParticleManager:ReleaseParticleIndex(fx)
        end
    end)

    if PFX_IMPACT_ENABLED then
        local impact = ParticleManager:CreateParticle(PFX_IMPACT, PATTACH_ABSORIGIN_FOLLOW, to_unit)
        Util:ParticleSetControlEntHitlocOrAbsFollow(impact, 1, to_unit)
        Timers(0.6, function()
            if impact then
                ParticleManager:DestroyParticle(impact, false)
                ParticleManager:ReleaseParticleIndex(impact)
            end
        end)
    end
end

function modifier_talent_4:_PlayChainSound(from_unit, target)
    local unit = from_unit
    if not unit or unit:IsNull() then
        unit = target
    end
    if unit and not unit:IsNull() then
        EmitSoundOn(SFX_CHAIN, unit)
    end
end

function modifier_talent_4:_ApplyChainSlow(attacker, target, duration)
    if not target or target:IsNull() or not target:IsAlive() then
        return
    end
    if target:IsMagicImmune() then
        return
    end
    target:AddNewModifier(attacker, nil, "modifier_talent_4_chain_slow", { duration = duration })
end

function modifier_talent_4:_StrikeChainTarget(attacker, from_unit, target, damage, is_main)
    self:_PlayChainBeam(from_unit, target)
    self:_PlayChainSound(from_unit, target)
    utilex:UnitDam(attacker, target, damage, "mf", nil, true)
    if is_main then
        self:_ApplyChainSlow(attacker, target, CHAIN_MAIN_SLOW)
    end
end

--- 从当前落点寻找下一个弹跳目标（650 内最近且未命中）
function modifier_talent_4:_FindNextChainTarget(from_unit, attacker, hit)
    if not from_unit or from_unit:IsNull() then
        return nil
    end
    local origin = from_unit:GetAbsOrigin()
    local enemies = FindUnitsInRadius(
        attacker:GetTeamNumber(),
        origin,
        nil,
        CHAIN_RADIUS,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    local best = nil
    local best_dist = nil
    for _, enemy in pairs(enemies) do
        if clrb_talent4_is_valid_enemy(attacker, enemy, hit) then
            local dist = (enemy:GetAbsOrigin() - origin):Length2D()
            if not best or dist < best_dist then
                best = enemy
                best_dist = dist
            end
        end
    end
    return best
end

function modifier_talent_4:_ProcChainLightning(attacker, primary, level)
    if not attacker or attacker:IsNull() or not primary or primary:IsNull() then
        return
    end

    local base = self:_LevelValue(CHAIN_BASE, level)
    local stat_coef = self:_LevelValue(CHAIN_STAT_COEF, level)
    local stats = (attacker:GetStrength() or 0) + (attacker:GetAgility() or 0)
        + (attacker:GetIntellect(true) or 0)
    local damage = math.floor(base + stats * stat_coef)

    local hit = {}
    local strikes_left = CHAIN_MAX_TARGETS
    local from_unit = attacker
    local pending_target = primary
    local mod = self
    local gen = (self._chain_gen or 0) + 1
    self._chain_gen = gen

    local function bounce(delay)
        Timers(delay, function()
            if not mod then
                return
            end
            if mod._chain_gen ~= gen then
                return
            end
            if not attacker or attacker:IsNull() or not attacker:IsAlive() then
                return
            end
            if strikes_left <= 0 then
                return
            end

            local target = pending_target
            if not clrb_talent4_is_valid_enemy(attacker, target, hit) then
                target = mod:_FindNextChainTarget(from_unit, attacker, hit)
            end
            if not target then
                return
            end

            hit[target] = true
            strikes_left = strikes_left - 1
            local is_main = (CHAIN_MAX_TARGETS - strikes_left) == 1

            mod:_StrikeChainTarget(attacker, from_unit, target, damage, is_main)

            from_unit = target
            pending_target = mod:_FindNextChainTarget(from_unit, attacker, hit)

            if strikes_left > 0 and pending_target then
                bounce(CHAIN_JUMP_DELAY)
            end
        end)
    end

    bounce(0)
end

----------------------------------------------------------------
-- 连锁闪电麻痹：90% 减速，散失状态特效
----------------------------------------------------------------
if modifier_talent_4_chain_slow == nil then
    modifier_talent_4_chain_slow = class({})
end

function modifier_talent_4_chain_slow:IsHidden()
    return false
end

function modifier_talent_4_chain_slow:IsDebuff()
    return true
end

function modifier_talent_4_chain_slow:IsPurgable()
    return true
end

function modifier_talent_4_chain_slow:RemoveOnDeath()
    return true
end

function modifier_talent_4_chain_slow:GetTexture()
    return "item_diffusal_blade"
end

function modifier_talent_4_chain_slow:GetStatusEffectName()
    return "particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_maelstrom_v2_item.vpcf"
end

function modifier_talent_4_chain_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_talent_4_chain_slow:GetModifierMoveSpeedBonus_Percentage()
    return -90
end
