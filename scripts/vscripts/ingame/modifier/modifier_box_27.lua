--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_box_27 = class({})

--该modifier是否是负面的
function modifier_box_27:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_box_27:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_box_27:IsHidden()
    return true
end

--死亡时是否移除
function modifier_box_27:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_box_27:OnCreated(kv)
    if not IsServer() then return end
end

-- 声明要修改的函数
function modifier_box_27:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS, -- 固定攻击速度加成
    }
end

function modifier_box_27:GetModifierHealthBonus()
    return 500
end
