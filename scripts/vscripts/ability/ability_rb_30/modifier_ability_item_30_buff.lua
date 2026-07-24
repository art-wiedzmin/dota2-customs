--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 血肉丰碑展示用 buff（层数 + 模型缩放走 MODIFIER_PROPERTY，避免 SetModelScale 闪烁）
modifier_ability_item_30_buff = class({})

function modifier_ability_item_30_buff:IsHidden()
    return false
end

function modifier_ability_item_30_buff:IsDebuff()
    return false
end

function modifier_ability_item_30_buff:IsPurgable()
    return false
end

function modifier_ability_item_30_buff:RemoveOnDeath()
    return false
end

-- 状态图标
function modifier_ability_item_30_buff:GetTexture()
    return "scroll/ability_item_30"
end

function modifier_ability_item_30_buff:OnCreated(params)
    if not IsServer() then return end
    local hero = self:GetParent()
    local num = hero.modifier_ability_item_30_buff
    self:SetStackCount(num)
end

function modifier_ability_item_30_buff:OnRefresh(params)
    if not IsServer() then return end
    -- 刷新时不需要做额外操作
    local hero = self:GetParent()
    local num = hero.modifier_ability_item_30_buff
    self:SetStackCount(num)
end

-- 声明修改函数
function modifier_ability_item_30_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP2,
        MODIFIER_PROPERTY_MODEL_SCALE,
    }
end

-- 每层 +5% 模型，与原 SetModelScale(1 + n*0.05) 一致，上限 1.5 倍即 +50%
function modifier_ability_item_30_buff:GetModifierModelScale()
    return math.min(self:GetStackCount() * 5, 50)
end

-- 工具提示2：显示层数
function modifier_ability_item_30_buff:OnTooltip2()
    return self:GetStackCount()
end