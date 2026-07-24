--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_item_equip_6_buff",
    "Ability/item_equip_6/modifier_item_equip_6_buff",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_equip_6_hex",
    "Ability/item_equip_6/modifier_item_equip_6_hex",
    LUA_MODIFIER_MOTION_NONE)

if item_equip_6 == nil then
    item_equip_6 = class({})
end

function item_equip_6:GetIntrinsicModifierName()
    return "modifier_item_equip_6_buff"
end

function item_equip_6:OnChargeCountChanged(_kv)
end

function item_equip_6:Precache(context)
    PrecacheResource("particle", "particles/items_fx/item_sheepstick.vpcf", context)
    PrecacheResource("particle", "particles/items_fx/phylactery.vpcf", context)
    PrecacheResource("particle", "particles/items_fx/phylactery_target.vpcf", context)
    PrecacheResource("particle", "particles/items_fx/phylactery_target_burst.vpcf", context)
end

local function clrb_equip_6_total_stats(unit)
    if not unit or unit:IsNull() then
        return 0
    end
    local str, agi, int = 0, 0, 0
    if unit.GetStrength then
        str = unit:GetStrength() or 0
    end
    if unit.GetAgility then
        agi = unit:GetAgility() or 0
    end
    if unit.GetIntellect then
        int = unit:GetIntellect(true) or 0
    end
    return str + agi + int
end

--- 绝刃同款命中特效：投射物飞向目标 + 目标爆发
local function clrb_equip_6_play_khanda_fx(caster, target)
    if not caster or caster:IsNull() or not target or target:IsNull() then
        return
    end
    local launch = ParticleManager:CreateParticle(
        "particles/items_fx/phylactery.vpcf",
        PATTACH_CUSTOMORIGIN,
        nil)
    ParticleManager:SetParticleControlEnt(
        launch, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1",
        caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(
        launch, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc",
        target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(launch)

    local burst = ParticleManager:CreateParticle(
        "particles/items_fx/phylactery_target.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target)
    ParticleManager:SetParticleControlEnt(
        burst, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc",
        target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(burst)

    local burst2 = ParticleManager:CreateParticle(
        "particles/items_fx/phylactery_target_burst.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target)
    ParticleManager:SetParticleControlEnt(
        burst2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc",
        target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(burst2)
end

function item_equip_6:OnSpellStart()
    if not IsServer() then
        return
    end

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if not caster or caster:IsNull() or not target or target:IsNull() then
        return
    end

    if target:TriggerSpellAbsorb(self) then
        return
    end

    local base_damage = self:GetSpecialValueFor("active_damage")
    local stat_mult = self:GetSpecialValueFor("stat_damage_mult")
    local total_stats = clrb_equip_6_total_stats(target)
    local damage = base_damage + total_stats * stat_mult

    local sheep_fx = ParticleManager:CreateParticle(
        "particles/items_fx/item_sheepstick.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target)
    ParticleManager:SetParticleControlEnt(
        sheep_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc",
        target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(sheep_fx)

    -- 绝刃命中特效 + 头顶伤害数字
    clrb_equip_6_play_khanda_fx(caster, target)
    EmitSoundOn("DOTA_Item.Sheepstick.Activate", target)

    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self,
    })

    local shown = math.floor(damage + 0.5)
    if shown > 0 then
        SendOverheadEventMessage(
            nil,
            OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
            target,
            shown,
            nil)
    end

    local duration = self:GetSpecialValueFor("sheep_duration")
    target:AddNewModifier(caster, self, "modifier_item_equip_6_hex", { duration = duration })
end