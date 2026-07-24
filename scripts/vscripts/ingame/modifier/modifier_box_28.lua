--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_box_28 = class({})

--该modifier是否是负面的
function modifier_box_28:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_box_28:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_box_28:IsHidden()
    return true
end

--死亡时是否移除
function modifier_box_28:RemoveOnDeath()
    return false
end

-- 初始化modifier
function modifier_box_28:OnCreated(kv)
    if not IsServer() then return end
end

-- 声明要修改的函数
function modifier_box_28:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED, -- 固定攻击速度加成
    }
end

-- 攻击命中时
function modifier_box_28:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local target = params.target
    if attacker ~= self:GetParent() then
        return
    end
    utilex:UnitDam(attacker, target, 50, "mf")
end
