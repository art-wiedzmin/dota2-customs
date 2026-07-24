--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_equip_1 = class({})

function modifier_equip_1:IsHidden()
    return false
end

function modifier_equip_1:IsPurgable()
    return false
end

function modifier_equip_1:GetTexture()
    return "item_black_king_bar" -- 使用黑黄杖的图标
end

function modifier_equip_1:GetStatusEffectName()
    return "particles/status_fx/status_effect_avatar.vpcf" -- 黑皇杖特效
end

function modifier_equip_1:GetStatusEffectPriority()
    -- 数值越高优先级越高，100通常是最高优先级
    return 100
end

function modifier_equip_1:GetEffectAttachType()
    return PATTACH_ROOTBONE_FOLLOW
end

function modifier_equip_1:OnCreated(keys)
    if IsServer() then
        local hero = self:GetParent()
        self:SetDuration(keys.duration, true)
        local tx = "particles/items_fx/black_king_bar_avatar.vpcf"
        utilex:AddTx(tx, hero, 5)
        -- 播放黑皇杖音效
        EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self:GetParent())
    end
end

function modifier_equip_1:OnDestroy()
    if IsServer() then
        -- 停止黑皇杖音效（如果有循环音效，这里需要停止）
        StopSoundOn("DOTA_Item.BlackKingBar.Activate", self:GetParent())
    end
end

function modifier_equip_1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_STATE_DEBUFF_IMMUNE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
    }
end

function modifier_equip_1:GetModifierMagicalResistanceBonus()
    return 75 -- 60%魔法抗性加成
end

function modifier_equip_1:GetModifierModelScale()
    -- 注意：这里返回的是额外缩放，不是总缩放
    -- 实际缩放 = 基础缩放 * (1 + 这里返回的值/100)
    return 20 -- 增加20%（变成1.2倍）
end

function modifier_equip_1:CheckState()
    return {
        [MODIFIER_STATE_DEBUFF_IMMUNE] = true
    }
end
