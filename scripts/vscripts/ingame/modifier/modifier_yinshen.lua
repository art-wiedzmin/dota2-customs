--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 文件名：modifier_yinshen.lua
modifier_yinshen = class({})

-- 基础配置
function modifier_yinshen:IsHidden()
    return false -- 隐藏状态栏显示图标
end

function modifier_yinshen:IsDebuff()
    return false
end

function modifier_yinshen:IsPurgable()
    return false -- 不可被驱散
end

function modifier_yinshen:RemoveOnDeath()
    return false
end

function modifier_yinshen:AllowIllusionDuplicate()
    return false
end

function modifier_yinshen:OnCreated(kv)
    if IsServer() then

    end
end

-- 覆盖免疫属性
function modifier_yinshen:DeclareFunctions()
    return {

    }
end

function modifier_yinshen:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true, -- 隐身
    }
end
