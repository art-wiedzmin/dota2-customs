--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_gjjc = class({})

--该modifier是否是负面的
function modifier_gjjc:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_gjjc:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_gjjc:IsHidden()
    return true
end

--死亡时是否移除
function modifier_gjjc:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_gjjc:OnCreated(kv)
    if not IsServer() then return end
    local ID = Util:Hero2ID(self:GetParent())
    self:SetStackCount(HeroData.Data[ID].hero_attr.gjjc)
    -- 初始化变量
    -- 如果需要响应性更新，调用这个
    self:ForceRefresh()
end

-- 从数据表中读取默认值（可选）
function modifier_gjjc:OnRefresh(kv)
    if not IsServer() then return end

    local ID = Util:Hero2ID(self:GetParent())
    self:SetStackCount(HeroData.Data[ID].hero_attr.gjjc)

    --self:ForceRefresh()
end

-- 声明要修改的函数
function modifier_gjjc:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end

-- 动态返回护甲
function modifier_gjjc:GetModifierBaseDamageOutgoing_Percentage()
    -- 从栈计数获取移动速度值（除以100恢复原始值）
    return self:GetStackCount()
end
