--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_gjljc = class({})

--该modifier是否是负面的
function modifier_gjljc:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_gjljc:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_gjljc:IsHidden()
    return true
end

--死亡时是否移除
function modifier_gjljc:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_gjljc:OnCreated(kv)
    if not IsServer() then return end

    -- 初始化变量
    self.jcgjl = kv.jcgjl or 0
    -- 使用栈计数同步数据到客户端
    -- 将移动速度值乘以100以保留小数精度，存储在栈计数中
    self:SetStackCount(self.jcgjl * 100)
    -- 如果需要响应性更新，调用这个
    self:ForceRefresh()
end

-- 从数据表中读取默认值（可选）
function modifier_gjljc:OnRefresh(kv)
    if not IsServer() then return end
    if kv.jcgjl then
        self.jcgjl = kv.jcgjl
        -- 更新栈计数
        self:SetStackCount(self.jcgjl * 100)
    end
    --self:ForceRefresh()
end

-- 声明要修改的函数
function modifier_gjljc:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

-- 动态返回护甲
function modifier_gjljc:GetModifierPreAttack_BonusDamage()
    -- 从栈计数获取移动速度值（除以100恢复原始值）
    local stack_count = self:GetStackCount()
    local hj_bonus = stack_count / 100
    return hj_bonus
end
