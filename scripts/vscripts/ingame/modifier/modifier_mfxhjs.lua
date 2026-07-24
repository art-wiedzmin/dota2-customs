--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_mfxhjs = class({})

--该modifier是否是负面的
function modifier_mfxhjs:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_mfxhjs:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_mfxhjs:IsHidden()
    return true
end

--死亡时是否移除
function modifier_mfxhjs:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_mfxhjs:OnCreated(kv)
    if not IsServer() then return end
    -- 强制属性刷新
    self:ForceRefresh()
end

-- 刷新modifier
function modifier_mfxhjs:OnRefresh(kv)
    if not IsServer() then return end
end

-- 声明要修改的函数
function modifier_mfxhjs:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
    }
end

function modifier_mfxhjs:GetModifierPercentageManacostStacking()
    return 25 -- 减少25%魔法消耗
end
