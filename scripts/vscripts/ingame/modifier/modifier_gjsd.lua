--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_gjsd = class({})

--该modifier是否是负面的
function modifier_gjsd:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_gjsd:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_gjsd:IsHidden()
    return true
end

--死亡时是否移除
function modifier_gjsd:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_gjsd:OnCreated(kv)
    if not IsServer() then return end

    -- 从参数获取攻击速度加成，如果没有则使用默认值
    self.attack_speed_bonus = kv.attack_speed or 1 -- 默认30点攻击速度
    -- 使用栈计数同步数据到客户端
    self:SetStackCount(math.floor(self.attack_speed_bonus * 100))
    -- 强制属性刷新
    self:ForceRefresh()
    self:GetParent():CalculateStatBonus(true)
end

-- 刷新modifier
function modifier_gjsd:OnRefresh(kv)
    if not IsServer() then return end

    if kv.attack_speed then
        self.attack_speed_bonus = kv.attack_speed
        self:SetStackCount(math.floor(self.attack_speed_bonus * 100))
        self:GetParent():CalculateStatBonus(true)
    end
end

-- 声明要修改的函数
function modifier_gjsd:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- 固定攻击速度加成
    }
end

-- 获取攻击速度加成
function modifier_gjsd:GetModifierAttackSpeedBonus_Constant()
    -- 从栈计数获取攻击速度值
    local stack_count = self:GetStackCount()
    local attack_speed = stack_count / 100.0
    return attack_speed
end
