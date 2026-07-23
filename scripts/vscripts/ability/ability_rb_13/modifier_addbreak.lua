--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_addbreak = class({})

function modifier_addbreak:IsHidden()
    return false
end

function modifier_addbreak:IsPurgable()
    return false
end

function modifier_addbreak:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_addbreak:CheckState()
    return { [MODIFIER_STATE_PASSIVES_DISABLED] = true }
end