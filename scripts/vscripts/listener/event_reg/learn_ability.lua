--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function CustomSets:learn_ability(keys)
    -- print("learn_ability")
    -- print(keys)
    local ID = keys.PlayerID
    local ab_name = keys.abilityname
    if ID then
        local hero = HeroData:GetHero(ID)
        if hero then
            local name = hero:GetUnitName()
            if CustomSets.OnHeroLearnedAghSkill then
                CustomSets:OnHeroLearnedAghSkill(hero, ab_name)
            end
            if name == "npc_dota_hero_gyrocopter"
                and ab_name == "gyrocopter_side_gunner_spawn_ability"
                and HeroData and HeroData.SetupGyrocopterSideGunner then
                Timers(0, function()
                    if hero and not hero:IsNull() then
                        HeroData:SetupGyrocopterSideGunner(hero)
                    end
                end)
            end
            if name == "npc_dota_hero_tidehunter" and ab_name == "special_bonus_unique_tidehunter_smash_on_blubber" then
                utilex:AddModifier(hero, "modifier_anchor")
                -- 不 RemoveAbility：保留天赋槽位与技能实体，仅关闭等级加成与显示（下一帧再设，避免与引擎升1 级竞态）
                Timers(0.03, function()
                    if not hero or hero:IsNull() then return end
                    local ab = hero:FindAbilityByName(ab_name)
                    if ab and not ab:IsNull() then
                        ab:SetHidden(true)
                        ab:SetLevel(0)
                    end
                end)
            end
        end
    end
end