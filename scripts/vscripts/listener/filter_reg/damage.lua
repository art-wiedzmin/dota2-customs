--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 伤害过滤
--[[
 damage=100,                  伤害值
 damagetype_const=1,          伤害类型
 entindex_attacker_const=146, 攻击索引
 entindex_victim_const=91     目标索引
 entindex_inflictor_const     技能索引

 DAMAGE_TYPE_MAGICAL
 DAMAGE_TYPE_PHYSICAL
 DAMAGE_TYPE_PURE

 过滤器里拿到攻击单位/被攻击单位
 DOTA原生的护甲/魔抗计算以后得到原始/税后伤害
 基于这个值来做自定义加成%属性

{
	damage  (string)= 118  (number)
	damagetype_const  (string)= 2  (number)
	entindex_attacker_const  (string)= 171  (number)
	entindex_inflictor_const  (string)= 172  (number)
	entindex_victim_const  (string)= 216  (number)
}

]]
local function dmg_is_unit_hero(ent)
    if not ent or ent:IsNull() or type(ent.IsHero) ~= "function" then
        return false
    end
    return ent:IsHero()
end

--- 破坏（被动失效，如 modifier_addbreak / 大隐刀等）：尖刺外壳、魔法皮肤等 Lua 被动需自行判断
local function dmg_unit_passives_disabled(ent)
    if not ent or ent:IsNull() or type(ent.PassivesDisabled) ~= "function" then
        return false
    end
    return ent:PassivesDisabled()
end

-- 热路径：避免每次伤害在过滤器内分配表
local ABIL_25_FLAT = { 16, 24, 32, 40, 48, 56, 64, 72, 80, 88 }
local ABIL_17_PHYS_PCT = { 1, 3, 4, 7, 10, 13, 16, 19, 22, 25 }
local ABIL_22_MAG_PCT = { 3, 6, 9, 12, 15, 18, 21, 24, 27, 30 }
local ABIL_29_BACKTRACK = { 8, 10, 12, 14, 16, 18, 20, 22, 24, 26 }
local ABIL_16_SPELLSTEAL_P = { 6, 10, 14, 18, 22, 27, 32, 37, 42, 48 }
local ABIL_16_SPELLSTEAL_M = { 6, 9, 12, 15, 18, 21, 24, 27, 30, 33 }

local function dmg_ability_level_clamped(ab)
    if not ab then
        return 1
    end
    return math.max(1, math.min(ab:GetLevel() or 1, 10))
end

--- 热路径：`FindAbilityByName` 一次即可，勿先 `HasAbility` 再 `Find`
local function dmg_find_ability(ent, name)
    if not ent or ent:IsNull() or type(ent.FindAbilityByName) ~= "function" then
        return nil
    end
    return ent:FindAbilityByName(name)
end

local function dmg_apply_monster_damage_cap(dm, ta)
    if ta:IsAlive() and ta:GetUnitName() == "m_2_3" then
        local cap = ta:GetMaxHealth() * 0.1
        if dm > cap then
            return cap
        end
    end
    return dm
end

-- modifier_talent_3 / modifier_talent_2 等先天伤害：仅引擎预处理后 dm，不参加本文件 zzsh/魔力波动/挨打词条等 Lua 叠算
local dmg_clrb_talent3_aura_iso = 0
function ClrbDmg_Filter_Talent3AuraIsolation_Enter()
    if dmg_clrb_talent3_aura_iso > 48 then
        dmg_clrb_talent3_aura_iso = 0
    end
    dmg_clrb_talent3_aura_iso = dmg_clrb_talent3_aura_iso + 1
end
function ClrbDmg_Filter_Talent3AuraIsolation_Leave()
    dmg_clrb_talent3_aura_iso = math.max(0, dmg_clrb_talent3_aura_iso - 1)
end
local function dmg_clrb_talent3_aura_isolated()
    return dmg_clrb_talent3_aura_iso > 0
end
--- 与 ClrbDmg_Filter_Talent3AuraIsolation_* 同义，便于阅读
ClrbDmg_Filter_SkipLuaStacking_Enter = ClrbDmg_Filter_Talent3AuraIsolation_Enter
ClrbDmg_Filter_SkipLuaStacking_Leave = ClrbDmg_Filter_Talent3AuraIsolation_Leave

-- function CustomSets:Damage_Filter(key)
--     --结算后不再计算伤害（过滤器极热路径；MainGame 未就绪时勿报错）
--     if MainGame and MainGame.Data and MainGame.Data.over == true then
--         return true
--     end
--     local ok, err = xpcall(function()
--         self:_Damage_FilterImpl(key)
--     end, function(e)
--         return tostring(e) .. "\n" .. debug.traceback()
--     end)
--     if not ok then
--         print("[CustomSets:Damage_Filter] " .. tostring(err))
--     end
--     return true
-- end

function CustomSets:Damage_Filter(key)
    local dm = key.damage
    local dmtp = key.damagetype_const
    local caindex = key.entindex_attacker_const
    local abindex = key.entindex_inflictor_const
    local taindex = key.entindex_victim_const
    if dm == 0 then return true end
    if not caindex then return true end
    dm = math.ceil(dm)
    if MainGame.Data and MainGame.Data.over == true then
        return true
    end
    local ca = Util:Index2Entity(caindex)
    local ta = Util:Index2Entity(taindex)
    if not ca or ca:IsNull() then return true end
    if not ta or ta:IsNull() then
        key.damage = math.max(0, dm)
        return true
    end

    local ca_is_hero = dmg_is_unit_hero(ca)
    local ta_is_hero = dmg_is_unit_hero(ta)

    if dmg_clrb_talent3_aura_isolated() then
        dm = dmg_apply_monster_damage_cap(dm, ta)
        if ca_is_hero and ta_is_hero and ca ~= ta and ca:GetTeamNumber() ~= ta:GetTeamNumber()
            and ClrbLhzfApplyHeroVsHeroDamageAmp then
            dm = ClrbLhzfApplyHeroVsHeroDamageAmp(ca, dm)
        end
        -- 英雄强度造成伤害改由 modifier_clrb_hero_balance TOTALDAMAGEOUTGOING 处理，避免与过滤器叠乘
        if dm < 0 then dm = 0 end
        dm = math.ceil(dm)
        key.damage = dm
        if dm > 0 and ca_is_hero and ta_is_hero and ca ~= ta then
            local ca_team = ca:GetTeamNumber()
            if ca_team ~= ta:GetTeamNumber() then
                local tid_iso = Util:Hero2ID(ta)
                if tid_iso and BotAI and BotAI.NotifyBotDamagedFromEnemy then
                    BotAI:NotifyBotDamagedFromEnemy(tid_iso)
                end
            end
        end
        if ca_is_hero and ta_is_hero then
            local cid_iso = Util:Hero2ID(ca)
            local tid_iso2 = Util:Hero2ID(ta)
            if cid_iso then HeroData:AddDam(cid_iso, dm) end
            if tid_iso2 then HeroData:AddTank(tid_iso2, dm) end
        end
        if dm > 0 and ca_is_hero and abindex and abindex > 0 then
            local inflictor = EntIndexToHScript(abindex)
            if AchieveStat and AchieveStat.OnDamageDealt then
                AchieveStat:OnDamageDealt(ca, inflictor, ta, dm)
            end
        end
        return true
    end

    -- 识破：仅格挡敌方英雄的物理普攻首击（野怪普攻不触发）
    if dmtp == 1 and ca_is_hero and ca ~= ta and ta:HasModifier("modifier_clrb_insight") then
        if abindex == nil or abindex <= 0 then
            local m = ta:FindModifierByName("modifier_clrb_insight")
            if m and m.ClrbTryParryPhysicalAttack and m:ClrbTryParryPhysicalAttack(ca) then
                key.damage = 0
                return true
            end
        end
    end

    -- ability_item_36：仅当持有该物品技能时才解析 inflictor
    if abindex and abindex > 0 and ca ~= ta and Skill and Skill.IsSkill36Filter then
        local ab36 = dmg_find_ability(ca, "ability_item_36")
        if ab36 then
            local cast_ab = EntIndexToHScript(abindex)
            if cast_ab and not cast_ab:IsNull() then
                local cast_ab_name
                if type(cast_ab.GetAbilityName) == "function" then
                    cast_ab_name = cast_ab:GetAbilityName()
                end
                if (not cast_ab_name or cast_ab_name == "") and type(cast_ab.GetName) == "function" then
                    cast_ab_name = cast_ab:GetName()
                end
                if cast_ab_name and cast_ab_name ~= "" and not Skill:IsSkill36Filter(cast_ab_name) then
                    ta:AddNewModifier(ca, ab36, "modifier_ability_item_36_buff", {})
                end
            end
        end
    end

    local ca_id, ta_id

    -- 双方均非英雄：无属性%/吸血/挨打词条，仅存伤害上限（野怪等单位互殴打）
    if not ca_is_hero and not ta_is_hero then
        dm = dmg_apply_monster_damage_cap(dm, ta)
        if dm < 0 then dm = 0 end
        dm = math.ceil(dm)
        key.damage = dm
        return true
    end

    -- 攻击者为英雄：物穿 / 魔力波动 / 最终伤害加成 / 狂战
    if ca_is_hero then
        if dmtp == 1 then
            local scale = HeroData:GetPhysicalArmorPenDamageScale(ca, ta)
            if scale and scale > 1 then
                dm = dm * scale
            end
        elseif dmtp == 2 and ca ~= ta then
            local ab21 = dmg_find_ability(ca, "ability_item_21")
            if ab21 then
                local lv = ab21:GetLevel()
                dm = dm * math.random(80, 115 + (lv - 1) * 5) / 100
            end
            -- 法神：魔法增伤（与魔法皮肤减伤反向，按层数 *6%）
            local t5_buff = ca:FindModifierByName("modifier_talent_skill_5_buff")
            if t5_buff and not t5_buff:IsNull() then
                local amp = 0
                if t5_buff.GetMagicAmpPercent then
                    amp = tonumber(t5_buff:GetMagicAmpPercent()) or 0
                else
                    amp = (t5_buff:GetStackCount() or 0) * 6
                end
                if amp > 0 then
                    dm = dm * (100 + amp) / 100
                end
            end
        end

        ca_id = Util:Hero2ID(ca)
        if ca_id then
            local zzsh = tonumber(HeroData:GetSX(ca_id, "zzsh")) or 0
            if zzsh ~= 0 then
                dm = (100 + zzsh) * dm / 100
            end
        end

        if ca_is_hero and ta_is_hero and ca ~= ta and ca:GetTeamNumber() ~= ta:GetTeamNumber()
            and ClrbLhzfApplyHeroVsHeroDamageAmp then
            dm = ClrbLhzfApplyHeroVsHeroDamageAmp(ca, dm)
        end

        if ca:HasModifier("modifier_ability_bf_1_buff") then
            dm = dm * 1.25
        end

        local ab16 = dmg_find_ability(ca, "ability_item_16")
        if ab16 then
            local level = dmg_ability_level_clamped(ab16)
            local xx = 0
            if dmtp == 1 then
                xx = ABIL_16_SPELLSTEAL_P[level] or 0
            elseif dmtp == 2 then
                xx = ABIL_16_SPELLSTEAL_M[level] or 0
            end
            if xx > 0 then
                local heal_amount = math.floor(dm * xx / 100)
                if heal_amount > 0 then
                    ca:Heal(heal_amount, ab16)
                end
            end
        end

        -- 法神：15 分钟后 15% 技能吸血（有施法来源或魔法伤害）
        local t5 = ca:FindModifierByName("modifier_talent_skill_5")
        if t5 and not t5:IsNull() and t5.IsSpellLifestealUnlocked and t5:IsSpellLifestealUnlocked() then
            local do_ls = false
            if dmtp == 2 then
                do_ls = true
            elseif abindex and abindex > 0 then
                do_ls = true
            end
            if do_ls then
                local heal_amount = math.floor(dm * 15 / 100)
                if heal_amount > 0 then
                    ca:Heal(heal_amount, nil)
                end
            end
        end
    end

    -- 受击者为英雄
    if ta_is_hero then
        local ta_pass_disabled = dmg_unit_passives_disabled(ta)

        -- 永世法衣+美杜莎
        -- if abindex == nil and dmtp == 2 and dm > 0 and ta:GetUnitName() == "npc_dota_hero_medusa" then
        --     local has_shroud = ta:HasModifier("modifier_item_eternal_shroud") or
        --         ta:HasItemInInventory("item_eternal_shroud")
        --     if has_shroud and ca ~= ta then
        --         local ca_team = ca:GetTeamNumber()
        --         local ta_team = ta:GetTeamNumber()
        --         if ca_team ~= ta_team then
        --             local mana_to_remove = math.floor(dm * 0.25)
        --             if mana_to_remove > 0 then
        --                 local victim_ref = ta
        --                 Timers(0, function()
        --                     if victim_ref and not victim_ref:IsNull() then
        --                         local cur = victim_ref:GetMana()
        --                         victim_ref:SetMana(math.max(0, cur - mana_to_remove))
        --                     end
        --                 end)
        --             end
        --         end
        --     end
        -- end

        ta_id = Util:Hero2ID(ta)
        if ta_id then
            --回到过去直接结束
            local ab29 = dmg_find_ability(ta, "ability_item_29")
            if ab29 then
                local sb = ABIL_29_BACKTRACK[dmg_ability_level_clamped(ab29)] or 0
                if sb > 0 and math.random(1, 100) <= sb then
                    utilex:AddTx(
                        "particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf",
                        ta,
                        1
                    )
                    dm = 0
                    key.damage = dm
                    return true
                end
            end
            if ta:HasModifier("modifier_clrb_invuln") then
                dm = 0
                key.damage = dm
                return true
            end
            local hdgq = tonumber(HeroData:GetSX(ta_id, "hdgq")) or 0
            if hdgq > 0 and math.random(1, 100) <= hdgq then
                dm = 0
                key.damage = dm
                return true
            end

            if ta:HasModifier("modifier_ability_bf_1_buff") then
                dm = dm * 1.5
            end

            local wlgd = tonumber(HeroData:GetSX(ta_id, "wlgd")) or 0
            if wlgd > 0 then
                dm = dm - wlgd
            end

            if dmtp == 1 then
                local ab25 = dmg_find_ability(ta, "ability_item_25")
                if ab25 then
                    local js = ABIL_25_FLAT[dmg_ability_level_clamped(ab25)] or 0
                    dm = dm - js
                    if dm <= 0 then dm = 1 end
                end
            end

            local zzjs = tonumber(HeroData:GetSX(ta_id, "zzjs")) or 0
            if zzjs >= 100 then zzjs = 99 end
            dm = dm * (100 - zzjs) / 100

            if dmtp == 1 and not ta_pass_disabled then
                local ab17 = dmg_find_ability(ta, "ability_item_17")
                if ab17 then
                    local wljs = ABIL_17_PHYS_PCT[dmg_ability_level_clamped(ab17)] or 0
                    dm = dm * (100 - wljs) / 100
                end
            end

            if dmtp == 2 and not ta_pass_disabled then
                local ab22 = dmg_find_ability(ta, "ability_item_22")
                if ab22 then
                    local mfjs = ABIL_22_MAG_PCT[dmg_ability_level_clamped(ab22)] or 0
                    dm = dm * (100 - mfjs) / 100
                end
            end
        end
        -- if ca:GetUnitName() == "hj_test" and IsInToolsMode() then
        --     Util:BottomMsg2ID(ta_id, "伤害：" .. dm)
        -- end
    end

    dm = dmg_apply_monster_damage_cap(dm, ta)

    if dm < 0 then dm = 0 end
    dm = math.ceil(dm)

    if dm > 0 and ca_is_hero and ta_is_hero and ca ~= ta then
        local ca_team = ca:GetTeamNumber()
        if ca_team ~= ta:GetTeamNumber() then
            if not ta_id then ta_id = Util:Hero2ID(ta) end
            if ta_id and BotAI and BotAI.NotifyBotDamagedFromEnemy then
                BotAI:NotifyBotDamagedFromEnemy(ta_id)
            end
        end
    end

    if ca_is_hero and ta:GetUnitName() == "hj_test" and IsInToolsMode() then
        if not ca_id then ca_id = Util:Hero2ID(ca) end
        if ca_id then
            Util:BottomMsg2ID(ca_id, "伤害：" .. dm)
        end
    end


    if ca_is_hero and ta_is_hero then
        if not ca_id then ca_id = Util:Hero2ID(ca) end
        if not ta_id then ta_id = Util:Hero2ID(ta) end
        if ca_id then HeroData:AddDam(ca_id, dm) end
        if ta_id then HeroData:AddTank(ta_id, dm) end
    end
    -- print("伤害：" .. dm)
    key.damage = dm

    if dm > 0 and ca_is_hero and abindex and abindex > 0 then
        local inflictor = EntIndexToHScript(abindex)
        if AchieveStat and AchieveStat.OnDamageDealt then
            AchieveStat:OnDamageDealt(ca, inflictor, ta, dm)
        end
    end

    return true
end