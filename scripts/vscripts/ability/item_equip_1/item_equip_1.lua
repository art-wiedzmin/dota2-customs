--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 如果是addon_game_mode.lua，在合适位置添加以下代码

if item_equip_1 == nil then
    item_equip_1 = class({})
end

-- 链接KV定义
LinkLuaModifier("modifier_speed_boost_buff", "items/item_equip_1", LUA_MODIFIER_MOTION_NONE)

function item_equip_1:GetIntrinsicModifierName()
    return nil -- 不需要常驻修饰器
end

function item_equip_1:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    -- 为施法者添加移动速度加成buff
    caster:AddNewModifier(
        caster,                      -- 施法者
        self,                        -- 技能来源
        "modifier_speed_boost_buff", -- 修饰器名称
        { duration = duration }      -- 持续时间
    )

    -- 播放音效（可选）
    EmitSoundOn("DOTA_Item.PhaseBoots.Activate", caster)

    -- 粒子特效（可选）
    local particle = ParticleManager:CreateParticle("particles/items_fx/phase_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW,
        caster)
    ParticleManager:ReleaseParticleIndex(particle)
end

-- 修饰器定义
modifier_speed_boost_buff = class({})

function modifier_speed_boost_buff:IsHidden()
    return false -- 显示buff图标
end

function modifier_speed_boost_buff:IsPurgable()
    return true -- 可以被驱散
end

function modifier_speed_boost_buff:IsDebuff()
    return false -- 是增益效果
end

function modifier_speed_boost_buff:GetTexture()
    return "item_phase_boots" -- buff图标
end

function modifier_speed_boost_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_speed_boost_buff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("speed_bonus_pct")
end

-- 可选：添加视觉特效到英雄
function modifier_speed_boost_buff:GetEffectName()
    return "particles/items_fx/phase_boots_recipient.vpcf"
end

function modifier_speed_boost_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end