--[[

{

	duration  (string)= -1  (number)

	entindex_ability_const  (string)= 889  (number)

	entindex_caster_const  (string)= 894  (number)

	entindex_parent_const  (string)= 894  (number)

	name_const  (string)= modifier_monkey_king_transform  (string)

}

]]

--- 获得 A 杖 / 魔晶 buff 时，引擎可能随后才挂上对应额外技能
local AGH_ITEM_MODIFIERS = {
    modifier_item_ultimate_scepter = true,
    modifier_item_aghanims_shard = true,
}

local function clrb_schedule_suppress_hero_agh_skills(hero)
    if not hero or hero:IsNull() or not Skill or not Skill.SuppressAllHeroAghShardGrants then
        return
    end
    local ID = Util and Util.Hero2ID and Util:Hero2ID(hero)
    Skill:SuppressAllHeroAghShardGrants(hero, ID)

    if not Timers then
        return
    end

    Timers(0.03, function()
        if not hero or hero:IsNull() then
            return
        end
        Skill:SuppressAllHeroAghShardGrants(hero, ID)
    end)

    Timers(0.25, function()
        if not hero or hero:IsNull() then
            return
        end
        Skill:SuppressAllHeroAghShardGrants(hero, ID)
    end)
end

--- 全英雄：隐藏 A 杖 / 魔晶额外技能（可重复调用）
function CustomSets:TryRemoveHeroAghSkills(hero)
    clrb_schedule_suppress_hero_agh_skills(hero)
end

--- 学习技能事件：隐藏 A 杖 / 魔晶新增技能（技能书 Skill1 槽位除外）
function CustomSets:OnHeroLearnedAghSkill(hero, ab_name)
    if not hero or hero:IsNull() or not ab_name then
        return
    end
    if not HeroData or not HeroData.ShouldSuppressAghShardSkillDisplay then
        return
    end
    local ID = Util and Util.Hero2ID and Util:Hero2ID(hero)
    if not HeroData:ShouldSuppressAghShardSkillDisplay(hero, ID, ab_name) then
        return
    end
    if Skill and Skill.SuppressHeroAghSkillGrant then
        Skill:SuppressHeroAghSkillGrant(hero, ID, ab_name)
        if Timers then
            Timers(0.03, function()
                if hero and not hero:IsNull() and Skill.SuppressHeroAghSkillGrant then
                    Skill:SuppressHeroAghSkillGrant(hero, ID, ab_name)
                    if Skill.EnsureHeroSkillSlotPlaceholders then
                        Skill:EnsureHeroSkillSlotPlaceholders(hero, ID)
                    end
                end
            end)
        end
    end
end

function CustomSets:Modifier_Filter(keys)
    if not IsServer() then
        return true
    end

    if keys.entindex_caster_const then
        local ent = EntIndexToHScript(keys.entindex_caster_const)

        if not ent or ent:IsNull() or not ent.IsHero or not ent:IsHero() then
            return true
        end

        local heroname = ent:GetUnitName()
        local mod_name = keys.name_const

        if mod_name and AGH_ITEM_MODIFIERS[mod_name] then
            if heroname == "npc_dota_hero_gyrocopter"
                and HeroData and HeroData.ForceRefreshGyrocopterSideGunner then
                -- 只刷一次；短时间内重复 ForceRefresh 会拆掉刚生成的侧翼单位
                HeroData:ForceRefreshGyrocopterSideGunner(ent)
                if Timers then
                    Timers(0.35, function()
                        if ent and not ent:IsNull() then
                            HeroData:ForceRefreshGyrocopterSideGunner(ent)
                        end
                    end)
                end
            end
            clrb_schedule_suppress_hero_agh_skills(ent)
        end
    end

    return true
end
