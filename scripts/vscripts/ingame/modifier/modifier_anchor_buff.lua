--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 减甲debuff modifier
modifier_anchor_buff = class({})

function modifier_anchor_buff:IsHidden()
    return false
end

function modifier_anchor_buff:IsDebuff()
    return true
end

function modifier_anchor_buff:IsPurgable()
    return true -- 可以被驱散
end

function modifier_anchor_buff:RemoveOnDeath()
    return true
end

function modifier_anchor_buff:OnCreated(params)
    if not IsServer() then return end
end

function modifier_anchor_buff:OnRefresh(params)
    if not IsServer() then return end
    -- 刷新时不需要做额外操作
end

-- 声明修改函数
function modifier_anchor_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
end

-- 计算总护甲降低值
function modifier_anchor_buff:GetModifierBaseDamageOutgoing_Percentage()
    local level = self:GetAbility():GetLevel()
    -- 返回负值表示降低护甲
    return -20 * level
end

function modifier_anchor_buff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

-- 状态图标
function modifier_anchor_buff:GetTexture()
    return "tidehunter_anchor_smash"
end
