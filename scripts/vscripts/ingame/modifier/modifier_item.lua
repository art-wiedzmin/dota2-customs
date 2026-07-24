--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 文件名：modifier_item.lua
modifier_item = class({})

-- 基础配置
function modifier_item:IsHidden()
    return false -- 隐藏状态栏显示图标
end

function modifier_item:IsDebuff()
    return false
end

function modifier_item:IsPurgable()
    return true -- 不可被驱散
end

function modifier_item:RemoveOnDeath()
    return false
end

function modifier_item:AllowIllusionDuplicate()
    return false
end

function modifier_item:OnCreated(kv)
    if IsServer() then

    end
end

function modifier_item:CheckState()
    local state = {
        [MODIFIER_STATE_CAN_USE_BACKPACK_ITEMS] = true
    }
    return state
end
