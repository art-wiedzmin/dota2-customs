--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 宝箱获得踏云靴（item_box_91）时单独挂载，不依赖 dummy 上物品栏位；卸下/摧毁该箱位装备时移除
require("ingame.modifier.clrb_fly_cloud_util")

modifier_clrb_tyx_terrain = class({})

function modifier_clrb_tyx_terrain:IsHidden()
    return true
end

function modifier_clrb_tyx_terrain:IsDebuff()
    return false
end

function modifier_clrb_tyx_terrain:IsPurgable()
    return false
end

function modifier_clrb_tyx_terrain:RemoveOnDeath()
    return false
end

function modifier_clrb_tyx_terrain:CheckState()
    return {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end

function modifier_clrb_tyx_terrain:OnCreated()
    if IsServer() then
        ClrbFlyCloudSync(self:GetParent())
    end
end

function modifier_clrb_tyx_terrain:OnDestroy()
    if IsServer() then
        ClrbFlyCloudSync(self:GetParent())
    end
end

function modifier_clrb_tyx_terrain:DeclareFunctions()
    return { MODIFIER_EVENT_ON_RESPAWN }
end

function modifier_clrb_tyx_terrain:OnRespawn()
    if IsServer() then
        ClrbFlyCloudScheduleSync(self:GetParent())
    end
end
