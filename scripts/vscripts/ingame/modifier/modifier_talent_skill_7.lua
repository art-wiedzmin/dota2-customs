--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 7：死战（被动，复活时间-2秒，每次复活后15秒内增加60攻速、30%移速、30%状态抗性

modifier_talent_skill_7 = class({})

function modifier_talent_skill_7:IsHidden()
    return true
end

function modifier_talent_skill_7:IsDebuff()
    return false
end

function modifier_talent_skill_7:IsPurgable()
    return false
end

function modifier_talent_skill_7:RemoveOnDeath()
    return false
end

function modifier_talent_skill_7:OnCreated()
    if IsServer() then

    end
end
