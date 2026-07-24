--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_jnzq = class({})

--该modifier是否是负面的
function modifier_jnzq:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_jnzq:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_jnzq:IsHidden()
    return true
end

--死亡时是否移除
function modifier_jnzq:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_jnzq:OnCreated(kv)
    if not IsServer() then return end

    -- 从参数获取技能增强值，如果没有则使用默认值
    self.spell_amp = kv.spell_amp or 1 -- 默认10%技能增强

    -- 使用栈计数同步数据到客户端
    self:SetStackCount(math.floor(self.spell_amp * 100))

    -- 强制属性刷新
    self:ForceRefresh()
    self:GetParent():CalculateStatBonus(true)
end

-- 刷新modifier
function modifier_jnzq:OnRefresh(kv)
    if not IsServer() then return end

    if kv.spell_amp then
        self.spell_amp = kv.spell_amp
        self:SetStackCount(math.floor(self.spell_amp * 100))
        --self:ForceRefresh()
        self:GetParent():CalculateStatBonus(true)
    end
end

-- 声明要修改的函数
function modifier_jnzq:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, -- 技能增强百分比
    }
end

-- 获取技能增强百分比
function modifier_jnzq:GetModifierSpellAmplify_Percentage()
    -- 从栈计数获取技能增强值
    local stack_count = self:GetStackCount()
    local spell_amp = stack_count / 100.0
    return spell_amp
end

-- 设置技能增强数值的方法
function modifier_jnzq:SetSpellAmplification(value)
    if not IsServer() then return end

    self.spell_amp = value
    self:SetStackCount(math.floor(value * 100))
    self:ForceRefresh()
    self:GetParent():CalculateStatBonus(true)
end

-- 获取当前技能增强数值
function modifier_jnzq:GetSpellAmplification()
    return self.spell_amp or 0
end
