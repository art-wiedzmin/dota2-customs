--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 修仙飞行 / 踏云靴：筋斗云特效同步（modifier_clrb_fly_cloud）

ClrbFlyCloudXiuWeiUnlock = 24

function ClrbHeroHasFlyCloudSource(hero)
    if not hero or hero:IsNull() or not hero:IsHero() then
        return false
    end

    local t6 = hero:FindModifierByName("modifier_talent_skill_6")
    if t6 and (t6:GetStackCount() or 0) >= ClrbFlyCloudXiuWeiUnlock then
        return true
    end

    local tyx_item = hero:FindModifierByName("modifier_item_equip_4_buff")
    if tyx_item and tyx_item.IsEnabled and tyx_item:IsEnabled() then
        return true
    end

    if hero:HasModifier("modifier_clrb_tyx_terrain") then
        return true
    end

    return false
end

function ClrbHeroShouldShowFlyCloud(hero)
    if not hero or hero:IsNull() or not hero:IsAlive() then
        return false
    end
    return ClrbHeroHasFlyCloudSource(hero)
end

function ClrbFlyCloudSync(hero)
    if not IsServer() then
        return
    end
    if not hero or hero:IsNull() or not hero:IsHero() then
        return
    end

    local has_source = ClrbHeroHasFlyCloudSource(hero)
    local want = has_source and hero:IsAlive()
    local has_cloud = hero:HasModifier("modifier_clrb_fly_cloud")

    if want then
        if not has_cloud then
            hero:AddNewModifier(hero, nil, "modifier_clrb_fly_cloud", {})
        end
    elseif has_cloud then
        hero:RemoveModifierByName("modifier_clrb_fly_cloud")
    end
end

--- 复活瞬间 IsAlive 可能仍为 false；多次延迟补挂云朵
function ClrbFlyCloudScheduleSync(hero)
    if not IsServer() or not hero or hero:IsNull() or not hero:IsHero() then
        return
    end
    if not ClrbHeroHasFlyCloudSource(hero) then
        ClrbFlyCloudSync(hero)
        return
    end
    ClrbFlyCloudSync(hero)
    if not Timers then
        return
    end
    for _, delay in ipairs({ 0.05, 0.15, 0.35, 0.6, 1.0 }) do
        Timers(delay, function()
            if not hero or hero:IsNull() then
                return
            end
            if not ClrbHeroHasFlyCloudSource(hero) then
                ClrbFlyCloudSync(hero)
                return
            end
            ClrbFlyCloudSync(hero)
        end)
    end
end
