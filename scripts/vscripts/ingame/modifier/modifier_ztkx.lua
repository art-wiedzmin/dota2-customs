--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_ztkx = class({})

--该modifier是否是负面的
function modifier_ztkx:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_ztkx:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_ztkx:IsHidden()
    return true
end

--死亡时是否移除
function modifier_ztkx:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_ztkx:OnCreated(kv)
    if not IsServer() then return end

    -- 初始化变量
    self.num = kv.num or 0
    -- 使用栈计数同步数据到客户端
    -- 将移动速度值乘以100以保留小数精度，存储在栈计数中
    self:SetStackCount(self.num * 100)
    -- 如果需要响应性更新，调用这个
    self:ForceRefresh()
end

-- 从数据表中读取默认值（可选）
function modifier_ztkx:OnRefresh(kv)
    if not IsServer() then return end
    if kv.num then
        self.num = kv.num
        -- 更新栈计数
        self:SetStackCount(self.num * 100)
    end
    --self:ForceRefresh()
end

-- 声明要修改的函数
function modifier_ztkx:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        --MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

-- 动态返回护甲
function modifier_ztkx:GetModifierStatusResistanceStacking()
    -- 从栈计数获取移动速度值（除以100恢复原始值）
    local stack_count = self:GetStackCount()
    local hj_bonus = stack_count / 100
    return hj_bonus
end