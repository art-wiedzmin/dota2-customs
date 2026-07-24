modifier_item_equip_6_hex = class({})

local FROG_MODEL = "models/props_gameplay/frog.vmdl"
-- 与绝刃破坏相同的头顶红色裂开标识
local BREAK_OVERHEAD_FX = "particles/generic_gameplay/generic_break.vpcf"

function modifier_item_equip_6_hex:IsHidden()
    return false
end

function modifier_item_equip_6_hex:IsDebuff()
    return true
end

function modifier_item_equip_6_hex:IsPurgable()
    return true
end

function modifier_item_equip_6_hex:IsStrongDispellable()
    return true
end

function modifier_item_equip_6_hex:RemoveOnDeath()
    return true
end

function modifier_item_equip_6_hex:CheckState()
    return {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end

function modifier_item_equip_6_hex:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
end

function modifier_item_equip_6_hex:GetModifierModelChange()
    return FROG_MODEL
end

function modifier_item_equip_6_hex:GetModifierMoveSpeed_Absolute()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 140
    end
    return ability:GetSpecialValueFor("sheep_movement_speed")
end

function modifier_item_equip_6_hex:GetModifierMoveSpeed_Limit()
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return 140
    end
    return ability:GetSpecialValueFor("sheep_movement_speed")
end

function modifier_item_equip_6_hex:GetTexture()
    return "item_angels_demise"
end

function modifier_item_equip_6_hex:OnCreated()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return
    end
    self._orig_model = parent:GetModelName()
    parent:SetModel(FROG_MODEL)

    -- 头顶破坏标识（与绝刃 Break 相同的红色裂开图标）
    self._break_fx = ParticleManager:CreateParticle(
        BREAK_OVERHEAD_FX,
        PATTACH_OVERHEAD_FOLLOW,
        parent)
    ParticleManager:SetParticleControlEnt(
        self._break_fx, 0, parent, PATTACH_OVERHEAD_FOLLOW, nil,
        parent:GetAbsOrigin(), true)
end

function modifier_item_equip_6_hex:OnDestroy()
    if not IsServer() then
        return
    end
    if self._break_fx then
        ParticleManager:DestroyParticle(self._break_fx, false)
        ParticleManager:ReleaseParticleIndex(self._break_fx)
        self._break_fx = nil
    end
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return
    end
    if self._orig_model and self._orig_model ~= "" then
        parent:SetModel(self._orig_model)
    end
end
