--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_lqjs = class({})

--该modifier是否是负面的
function modifier_lqjs:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_lqjs:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_lqjs:IsHidden()
    return true
end

--死亡时是否移除
function modifier_lqjs:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_lqjs:OnCreated(kv)
    if not IsServer() then return end
    local hero = self:GetParent()
    local ID = Util:Hero2ID(hero)
    self.num = HeroData.Data[ID].hero_attr.lqjs
    -- 使用栈计数同步数据到客户端
    -- 将移动速度值乘以100以保留小数精度，存储在栈计数中
    -- self:SetStackCount(self.num * 100)
    -- 如果需要响应性更新，调用这个
    self:ForceRefresh()
end

-- 刷新modifier
function modifier_lqjs:OnRefresh(kv)
    if not IsServer() then return end
    local hero = self:GetParent()
    local ID = Util:Hero2ID(hero)
    self.num = HeroData.Data[ID].hero_attr.lqjs
    hero:CalculateStatBonus(true)
    self:SetStackCount(self.num * 100)
end

-- 声明要修改的函数
function modifier_lqjs:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
end

function modifier_lqjs:GetModifierPercentageCooldown()
    local stack_count = self:GetStackCount()
    local hj_bonus = stack_count / 100
    return hj_bonus
end
