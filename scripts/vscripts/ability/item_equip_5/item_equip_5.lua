LinkLuaModifier("modifier_item_equip_5_buff",
                "Ability/item_equip_5/modifier_item_equip_5_buff",
                LUA_MODIFIER_MOTION_NONE)

if item_equip_5 == nil then item_equip_5 = class({}) end

function item_equip_5:GetIntrinsicModifierName()
    return "modifier_item_equip_5_buff"
end

function item_equip_5:OnChargeCountChanged(_kv)
end

function item_equip_5:OnSpellStart()
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

    local damage = self:GetSpecialValueFor("active_damage")
        + caster:GetIntellect(true) * self:GetSpecialValueFor("int_damage_mult")

    local particle = ParticleManager:CreateParticle(
        "particles/items_fx/dagon.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target)
    ParticleManager:SetParticleControlEnt(
        particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc",
        target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(
        particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1",
        caster:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)

    EmitSoundOn("DOTA_Item.Dagon.Activate", target)

    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self,
    })
end
