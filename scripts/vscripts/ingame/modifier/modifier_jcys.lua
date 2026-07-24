--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_jcys = class({})

--该modifier是否是负面的
function modifier_jcys:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_jcys:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_jcys:IsHidden()
    return true
end

--死亡时是否移除
function modifier_jcys:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_jcys:OnCreated(kv)
    if not IsServer() then return end

    -- 初始化变量
    self.jcys = kv.jcys or 0
    -- 使用栈计数同步数据到客户端
    -- 将移动速度值乘以100以保留小数精度，存储在栈计数中
    self:SetStackCount(self.jcys * 100)
    -- 如果需要响应性更新，调用这个
    self:ForceRefresh()
end

-- 从数据表中读取默认值（可选）
function modifier_jcys:OnRefresh(kv)
    if not IsServer() then return end
    if kv.jcys then
        self.jcys = kv.jcys
        -- 更新栈计数
        self:SetStackCount(self.jcys * 100)
    end
    --self:ForceRefresh()
end

-- 声明要修改的函数
function modifier_jcys:DeclareFunctions()
    return {
        --MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

-- 动态返回移动速度加成
function modifier_jcys:GetModifierMoveSpeedBonus_Constant()
    -- 从栈计数获取移动速度值（除以100恢复原始值）
    local stack_count = self:GetStackCount()
    local speed_bonus = stack_count / 100
    return speed_bonus
end

-- 设置移动速度的方法
function modifier_jcys:SetSpeedBonus(value)
    if not IsServer() then return end
    self.jcys = value
    self:SetStackCount(value * 100) -- 同步到客户端
    self:ForceRefresh()
end
