--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 极速移动modifier
modifier_run = class({})

function modifier_run:IsHidden()
    return false
end

function modifier_run:IsPurgable()
    return true
end

function modifier_run:IsDebuff()
    return false
end

function modifier_run:GetTexture()
    return "item_phase_boots" -- 使用相位鞋图标
end

function modifier_run:OnCreated(kv)
    if IsServer() then
        -- 获取父单位（英雄）
        local parent = self:GetParent()

        -- 根据英雄类型设置持续时间
        if parent:IsRangedAttacker() then
            -- 远程英雄：2秒
            self:SetDuration(2.5, true)
        else
            -- 近战英雄：2.5秒
            self:SetDuration(2.5, true)
        end

        -- 播放特效
        self:PlayEffects()
    end
end

function modifier_run:OnRefresh(kv)
    if not IsServer() then return end
    self:OnCreated(kv)
end

function modifier_run:OnDestroy()
    if IsServer() then
        -- 移除特效
        if self.particle then
            ParticleManager:DestroyParticle(self.particle, false)
            ParticleManager:ReleaseParticleIndex(self.particle)
        end
    end
end

function modifier_run:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,  -- 固定移速加成
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,        -- 绝对移速（可选）
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,    -- 忽略移速上限
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,           -- 移速限制
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING -- 状态抗性（用于减速抗性）
    }
end

-- 设置固定移速加成到888
function modifier_run:GetModifierMoveSpeedBonus_Constant()
    return 888
end

-- 或者使用绝对移速（二选一）
function modifier_run:GetModifierMoveSpeed_Absolute()
    -- 如果使用绝对移速，取消上面的固定加成
    -- return 888
    return 888
end

-- 忽略移速上限
function modifier_run:GetModifierIgnoreMovespeedLimit()
    return 1
end

-- 设置移速限制（可选）
function modifier_run:GetModifierMoveSpeed_Limit()
    return 888
end

-- 100%减速抗性（通过状态抗性实现）
function modifier_run:GetModifierStatusResistanceStacking()
    return 100
end

-- 状态检查
function modifier_run:CheckState()
    return {
        -- 确保不会被减速效果影响
        [MODIFIER_STATE_NO_HEALTH_BAR] = false,
        -- 可以添加其他需要的状态
    }
end

-- 特效播放
function modifier_run:PlayEffects()
    local parent = self:GetParent()

    -- 创建移动特效
    self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", PATTACH_ABSORIGIN_FOLLOW,
        parent)
    ParticleManager:SetParticleControl(self.particle, 0, parent:GetAbsOrigin())

    -- 播放音效
    EmitSoundOn("Hero_Dark_Seer.Surge", parent)
end

-- 状态栏显示信息
function modifier_run:GetStatusLabel()
    return "super_speed"
end
