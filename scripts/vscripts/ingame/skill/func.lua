--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 英雄存活时才允许学习/替换技能
function Skill:CanLearnOrReplaceSkill(ID)
    local hero = Util:ID2Hero(ID)
    return hero and not hero:IsNull() and hero:IsAlive()
end

--- @return boolean 是否因死亡被拦截（true=已拦截）
function Skill:RejectLearnOrReplaceIfHeroDead(ID)
    if self:CanLearnOrReplaceSkill(ID) then
        return false
    end
    Util:BottomMsg2ID(ID, "英雄死亡期间无法学习或替换技能", "red", 1)
    return true
end

--向列表添加一个英雄技能
function Skill:AddSkill(ID, id, rank)
    if not ID or not id then
        return
    end
    local page_num = self.Static.page_num
    local skill_data = self:GetSkillData(id)
    if not skill_data then
        return Util:BottomMsg2ID(ID, "没有找到该技能")
    end
    if self:IsInList(ID, id) then
        return
    end
    --学过的技能就不再往里面添加
    local skill_name = skill_data.name
    local hero = Util:ID2Hero(ID)
    if hero:HasAbility(skill_name) then
        return
    end
    for i = 1, page_num do
        local slot = "slot_" .. i
        local data = self.Data[ID].list[slot]
        if data.state == false then
            data.skill = id
            data.state = true
            -- data.text = skill_data.name .. "text"
            data.text = skill_data.name

            data.rank = rank
            return
        end
    end
end

--获取一个随机英雄技能
function Skill:GetHeroSkill(ID, hero_name)
    if not hero_name then
        return
    end
    local hero = Util:ID2Hero(ID)
    local list = {}
    for k, v in pairs(self.Ability) do
        if v.hero == hero_name and not hero:HasAbility(v.name) then
            local skill_id = v.id
            if skill_id then
                table.insert(list, skill_id)
            end
        end
    end
    local roll_skill_id = Util:TabRandom(list)
    return roll_skill_id
end

--- beidong 地图或旧「纯被动模式」：技能书仅用 PassiveSkill 白名单随机（不走英雄本体预定槽）
function Skill:UsesPassiveSkillBookWhitelistOnly()
    return GetMapName() == "beidong"
        or (MainGame and MainGame.GetPassiveMode and MainGame:GetPassiveMode())
end

--- passive 地图或旧「纯被动模式」：候选池为 PassiveSkill ∩ 当前品阶表；交集为空时用 PassiveSkill 内同品阶技能兜底
function Skill:GetRollSkillPool(rank)
    if not self:UsesPassiveSkillBookWhitelistOnly() then
        return self[rank]
    end
    if not self._passive_skill_id_set then
        local set = {}
        for _, id in ipairs(self.PassiveSkill or {}) do
            set[id] = true
        end
        self._passive_skill_id_set = set
    end
    local passive_set = self._passive_skill_id_set
    local pool = {}
    local base = self[rank]
    if base then
        for _, id in ipairs(base) do
            if passive_set[id] then
                table.insert(pool, id)
            end
        end
    end
    if #pool == 0 and self.PassiveSkill then
        local rnum = tonumber(string.match(rank or "", "^Rank(%d+)$")) or 0
        for _, id in ipairs(self.PassiveSkill) do
            local d = self:GetSkillData(id)
            if d and d.rank == rnum then
                table.insert(pool, id)
            end
        end
    end
    return pool
end

--- 技能书品阶权重表：15 分钟前初级/高级书不含 Rank0、Rank1
function Skill:GetBookRollList(book)
    local base = self.Roll and self.Roll[book]
    if not base then
        return nil
    end
    local roll_list = Util:DeepCopyTab(base)
    if book ~= "T1" and book ~= "T2" then
        return roll_list
    end
    local unlock_min = (self.Static and self.Static.book_rank01_unlock_min) or 15
    local game_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
    if game_min < unlock_min then
        roll_list.Rank0 = nil
        roll_list.Rank1 = nil
    end
    return roll_list
end

--根据品阶roll技能；picked 为本开书已选 skill_id 表，避免重复
function Skill:RollSkill(ID, rank, picked)
    local pool = self:GetRollSkillPool(rank)
    if not pool or next(pool) == nil then
        return
    end
    local hero_roll = Util:ID2Hero(ID)
    if hero_roll and not hero_roll:IsNull() and hero_roll:GetUnitName() == "npc_dota_hero_huskar" then
        local filtered = {}
        for _, sid in ipairs(pool) do
            local sd = self:GetSkillData(sid)
            local nm = sd and sd.name
            -- 英雄哈斯卡用书：必不出球状闪电、脉冲新星
            if nm ~= "storm_spirit_ball_lightning" and nm ~= "leshrac_pulse_nova" then
                table.insert(filtered, sid)
            end
        end
        pool = filtered
        if next(pool) == nil then
            return
        end
    end
    local num = 0
    local flag = false
    repeat
        local id = Util:TabRandom(pool)
        if not self:IsInList(ID, id) and not self:IsHaveAb(ID, id) and not self:IsInPublic(id)
            and not (picked and picked[id]) then
            flag = true
            return id
        end
        num = num + 1
        if num > 100 then
            flag = true
        end
    until flag
end

--清理列表
function Skill:ClearList(ID)
    if not ID then
        return
    end
    for k, v in pairs(self.Data[ID].list) do
        -- local id = v.skill
        -- --如果没有学习该技能就直接解锁
        -- if not self:IsHaveAb(ID, id) then
        --     self:UnLock(id)
        -- end
        v.state = false
        v.skill = -1
        v.text = ""
        v.rank = -1
    end
end

Skill._deferTimerByKey = Skill._deferTimerByKey or {}

--- 主技能名 → 释放中需拦截替换/卸下的 modifier（持续态，不仅前摇/引导）
Skill.HideAbilityBusyModifiers = Skill.HideAbilityBusyModifiers or {
    phoenix_icarus_dive = { "modifier_phoenix_icarus_dive" },
    shredder_chakram = {
        "modifier_shredder_chakram_disarm",
        "modifier_shredder_chakram",
    },
    ancient_apparition_ice_blast = {
        "modifier_ancient_apparition_ice_blast",
        "modifier_ancient_apparition_ice_blast_slow",
    },
    tusk_snowball = { "modifier_tusk_snowball", "modifier_tusk_snowball_visible" },
    wisp_tether = { "modifier_wisp_tether", "modifier_wisp_tether_haste" },
    pangolier_gyroshell = { "modifier_pangolier_gyroshell", "modifier_pangolier_gyroshell_roll" },
    phoenix_fire_spirits = {
        "modifier_phoenix_fire_spirit_burn",
        "modifier_phoenix_fire_spirit_count",
    },
    snapfire_mortimer_kisses = { "modifier_snapfire_mortimer_kisses" },
}

--- 主技能名 → 提示文案（replace=换书学习，clear=清空槽位，move=调槽，open=打开换位界面）
Skill.HideAbilityBusyRemoveTips = Skill.HideAbilityBusyRemoveTips or {
    phoenix_icarus_dive = {
        replace = "凤凰冲击释放中，无法替换该技能",
        clear = "凤凰冲击释放中，无法卸下该技能",
        move = "凤凰冲击释放中，无法调整该技能槽位",
        open = "凤凰冲击释放中，无法打开技能换位界面",
    },
    tusk_snowball = {
        replace = "雪球释放中，无法替换该技能",
        clear = "雪球释放中，无法卸下该技能",
        move = "雪球释放中，无法调整该技能槽位",
        open = "雪球释放中，无法打开技能换位界面",
    },
    ancient_apparition_ice_blast = {
        replace = "冰晶爆轰释放中，无法替换该技能",
        clear = "冰晶爆轰释放中，无法卸下该技能",
        move = "冰晶爆轰释放中，无法调整该技能槽位",
        open = "冰晶爆轰释放中，无法打开技能换位界面",
    },
    wisp_tether = {
        replace = "羁绊使用中，无法替换该技能",
        clear = "羁绊使用中，无法卸下该技能",
        move = "羁绊使用中，无法调整该技能槽位",
        open = "羁绊使用中，无法打开技能换位界面",
    },
    phoenix_fire_spirits = {
        replace = "烈火精灵使用中，无法替换该技能",
        clear = "烈火精灵使用中，无法卸下该技能",
        move = "烈火精灵使用中，无法调整该技能槽位",
        open = "烈火精灵使用中，无法打开技能换位界面",
    },
    shredder_chakram = {
        replace = "锯齿飞轮使用中，无法替换该技能",
        clear = "锯齿飞轮使用中，无法卸下该技能",
        move = "锯齿飞轮使用中，无法调整该技能槽位",
        open = "锯齿飞轮使用中，无法打开技能换位界面",
    },
    pangolier_gyroshell = {
        replace = "地雷滚滚使用中，无法替换该技能",
        clear = "地雷滚滚使用中，无法卸下该技能",
        move = "地雷滚滚使用中，无法调整该技能槽位",
        open = "地雷滚滚使用中，无法打开技能换位界面",
    },
    snapfire_mortimer_kisses = {
        replace = "蜥蜴绝吻释放中，无法替换该技能",
        clear = "蜥蜴绝吻释放中，无法卸下该技能",
        move = "蜥蜴绝吻释放中，无法调整该技能槽位",
        open = "蜥蜴绝吻释放中，无法打开技能换位界面",
    },
}

function Skill:EnsureHideAbilityIndex()
    if self._hideAbilityMainNameToConfig and self._hideAbilitySubNameToMainName then
        return
    end
    self._hideAbilityMainNameToConfig = {}
    self._hideAbilitySubNameToMainName = {}
    for _, v in pairs(self.Ability or {}) do
        if v and v.name then
            local has_hide = v.hide_ability and type(v.hide_ability) == "table" and #v.hide_ability > 0
            local has_busy = v.busy_modifiers and type(v.busy_modifiers) == "table" and #v.busy_modifiers > 0
            if has_hide or has_busy then
                self._hideAbilityMainNameToConfig[v.name] = v
                if has_hide then
                    for _, hide_name in ipairs(v.hide_ability) do
                        self._hideAbilitySubNameToMainName[hide_name] = v.name
                    end
                end
            end
        end
    end
end

--- 二段子技能名 → 主技能名（槽位在放出后常显示 return/launch 等子技能）
function Skill:ResolveMainHideAbilityName(ability_name)
    if not ability_name then
        return ability_name
    end
    self:EnsureHideAbilityIndex()
    return self._hideAbilitySubNameToMainName[ability_name] or ability_name
end

function Skill:GetSkillBusyRemoveTip(ability_name, for_clear_slot)
    ability_name = self:ResolveMainHideAbilityName(ability_name)
    local tips = self.HideAbilityBusyRemoveTips and self.HideAbilityBusyRemoveTips[ability_name]
    if tips then
        if for_clear_slot then
            return tips.clear or tips.replace or "技能使用中，无法卸下该技能"
        end
        return tips.replace or tips.clear or "技能使用中，无法替换该技能"
    end
    if for_clear_slot then
        return "技能使用中，无法卸下该技能"
    end
    return "技能使用中，无法替换该技能"
end

function Skill:GetSkillBusyMoveTip(ability_name)
    ability_name = self:ResolveMainHideAbilityName(ability_name)
    local tips = self.HideAbilityBusyRemoveTips and self.HideAbilityBusyRemoveTips[ability_name]
    if tips and tips.move then
        return tips.move
    end
    if ability_name == "techies_reactive_tazer" then
        return "活性电击使用中，无法调整该技能槽位"
    end
    return "技能使用中，无法调整该技能槽位"
end

function Skill:GetSkillBusyOpenSlotTip(ability_name)
    ability_name = self:ResolveMainHideAbilityName(ability_name)
    local tips = self.HideAbilityBusyRemoveTips and self.HideAbilityBusyRemoveTips[ability_name]
    if tips and tips.open then
        return tips.open
    end
    if ability_name == "techies_reactive_tazer" then
        return "活性电击使用中，无法打开技能换位界面"
    end
    return "技能使用中，无法打开技能换位界面"
end

--- 技能释放/持续态期间：禁止替换、卸下、以及移动该技能槽位（允许打开换位面板）
function Skill:IsSkillBusyBlockingChange(hero, ability_name)
    if not hero or hero:IsNull() or not ability_name or self:IsNullSkill(ability_name) then
        return false
    end
    ability_name = self:ResolveMainHideAbilityName(ability_name)
    if self:IsHideAbilitySkillBusyCasting(hero, ability_name) then
        return true
    end
    if self:IsTechiesReactiveTazerBusyCasting(hero, ability_name) then
        return true
    end
    return false
end

--- 英雄身上是否存在二段/持续技能占用（扫全部技能槽，不只看 Skill1 索引）
function Skill:FindBusyHideAbilityOnHero(hero)
    if not hero or hero:IsNull() then
        return nil
    end
    self:EnsureHideAbilityIndex()

    -- 槽位已切成二段子技能（如 shredder_return_chakram、tusk_launch_snowball）
    for i = 0, 23 do
        local ab = hero:GetAbilityByIndex(i)
        if ab and not ab:IsNull() then
            local name = ab:GetName()
            local main_name = self._hideAbilitySubNameToMainName[name]
            if main_name and self:IsAbilityShownNotHidden(ab) then
                return main_name
            end
        end
    end

    for main_name, _ in pairs(self._hideAbilityMainNameToConfig) do
        if self:IsHideAbilitySkillBusyCasting(hero, main_name) then
            return main_name
        end
    end

    if self:IsTechiesReactiveTazerBusyCasting(hero, "techies_reactive_tazer") then
        return "techies_reactive_tazer"
    end

    return nil
end

--- Skill1 槽位：是否通过技能书学习/占用的英雄技能（与 agh 屏蔽魔晶原生技能区分）
function Skill:IsSkillBookSlotAbility(ID, ab_name)
    if not ID or not ab_name or not self.Data[ID] or not self.Data[ID].Skill1 then
        return false
    end
    for _, slot in pairs(self.Data[ID].Skill1) do
        if slot and slot.name == ab_name then
            if slot.book_pending == true then
                return true
            end
            if slot.id and slot.id ~= -1 then
                return true
            end
        end
    end
    return false
end

function Skill:Skill1SlotToAbilityIndex(slot_num)
    local index = (tonumber(slot_num) or 1) - 1
    if index == 3 then
        index = 5
    end
    return index
end

--- 英雄 Q/W/E/R 指定 Skill1 槽位（1–4）当前技能名
function Skill:GetHeroSkill1SlotAbilityName(hero, slot_num)
    if not hero or hero:IsNull() then
        return nil
    end
    local ab = hero:GetAbilityByIndex(self:Skill1SlotToAbilityIndex(slot_num))
    if not ab or ab:IsNull() then
        return nil
    end
    return ab.GetAbilityName and ab:GetAbilityName() or ab:GetName()
end

--- 以英雄实体槽位为准：该 Skill1 槽是否仍为 ability_null 占位
function Skill:IsHeroSkill1SlotEmpty(hero, slot_num)
    local name = self:GetHeroSkill1SlotAbilityName(hero, slot_num)
    if not name then
        return true
    end
    return self:IsNullSkill(name)
end

--- 四槽是否还有空位（读英雄 Q/W/E/R，不依赖可能过期的 Skill1 缓存）
function Skill:HasEmptySkill1Slot(ID)
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return true
    end
    for i = 1, 4 do
        if self:IsHeroSkill1SlotEmpty(hero, i) then
            return true
        end
    end
    return false
end

--- 打开技能书 / 确认选技能前：Skill1 数据与英雄四槽对齐
function Skill:RefreshSkill1FromHero(ID)
    if not ID then
        return
    end
    self:UpDataSlot(ID)
end

function Skill:IsSkill1AbilityIndex(index)
    return index == 0 or index == 1 or index == 2 or index == 5
end

--- 英雄 Skill1 四个槽位（0/1/2/5）上是否挂着指定技能
function Skill:FindSkill1SlotNumOnHero(hero, ab_name)
    if not hero or hero:IsNull() or not ab_name then
        return nil
    end
    for i = 1, 4 do
        local index = self:Skill1SlotToAbilityIndex(i)
        local ab = hero:GetAbilityByIndex(index)
        if ab and not ab:IsNull() then
            local nm = ab.GetAbilityName and ab:GetAbilityName() or ab:GetName()
            if nm == ab_name then
                return i
            end
        end
    end
    return nil
end

--- 数据或英雄槽位任一表明该 agh 技能来自技能书，则保留并只删魔晶副本
function Skill:ShouldPreserveAghSkillBookGrant(hero, ID, ab_name)
    if self:IsSkillBookSlotAbility(ID, ab_name) then
        return true
    end
    return self:FindSkill1SlotNumOnHero(hero, ab_name) ~= nil
end

function Skill:FindSkill1SlotNumForBookAbility(ID, ab_name, hero)
    if not ab_name then
        return nil
    end
    if ID and self.Data[ID] and self.Data[ID].Skill1 then
        for i = 1, 4 do
            local slot = self.Data[ID].Skill1["slot_" .. i]
            if slot and slot.name == ab_name
                and (slot.book_pending or (slot.id and slot.id ~= -1)) then
                return i
            end
        end
    end
    if not hero then
        hero = ID and Util and Util.ID2Hero and Util:ID2Hero(ID)
    end
    return self:FindSkill1SlotNumOnHero(hero, ab_name)
end

function Skill:CountHeroAbilitiesNamed(hero, ab_name)
    if not hero or hero:IsNull() or not ab_name then
        return 0
    end
    local n = 0
    for i = 0, hero:GetAbilityCount() - 1 do
        local ab = hero:GetAbilityByIndex(i)
        if ab and not ab:IsNull() then
            local nm = ab.GetAbilityName and ab:GetAbilityName() or ab:GetName()
            if nm == ab_name then
                n = n + 1
            end
        end
    end
    return n
end

--- 技能书已占用 agh 同名技能时：仅移除魔晶等多出来的副本，保留 Skill1 槽位上的那份
function Skill:RemoveExtraAbilityCopiesExceptSkill1Slot(hero, ID, ab_name)
    if not hero or hero:IsNull() or not ab_name then
        return
    end
    if self:CountHeroAbilitiesNamed(hero, ab_name) <= 1 then
        return
    end
    local slot_num = self:FindSkill1SlotNumForBookAbility(ID, ab_name, hero)
    if not slot_num then
        return
    end
    local keep_index = self:Skill1SlotToAbilityIndex(slot_num)
    local keep_ab = hero:GetAbilityByIndex(keep_index)
    local keep_nm = keep_ab and not keep_ab:IsNull()
        and (keep_ab.GetAbilityName and keep_ab:GetAbilityName() or keep_ab:GetName())
    if keep_nm ~= ab_name then
        return
    end
    local keep_ent = keep_ab:entindex()
    local guard = 0
    while guard < 16 do
        guard = guard + 1
        if self:CountHeroAbilitiesNamed(hero, ab_name) <= 1 then
            break
        end
        local remove_index = nil
        for i = 0, hero:GetAbilityCount() - 1 do
            if i ~= keep_index and not self:IsSkill1AbilityIndex(i) then
                local ab = hero:GetAbilityByIndex(i)
                if ab and not ab:IsNull() then
                    local nm = ab.GetAbilityName and ab:GetAbilityName() or ab:GetName()
                    if nm == ab_name then
                        remove_index = i
                        break
                    end
                end
            end
        end
        if remove_index == nil then
            for i = 0, hero:GetAbilityCount() - 1 do
                if i ~= keep_index then
                    local ab = hero:GetAbilityByIndex(i)
                    if ab and not ab:IsNull() then
                        local nm = ab.GetAbilityName and ab:GetAbilityName() or ab:GetName()
                        if nm == ab_name then
                            remove_index = i
                            break
                        end
                    end
                end
            end
        end
        if remove_index == nil then
            break
        end
        hero:RemoveAbility(ab_name)
        local check = keep_ent and EntIndexToHScript(keep_ent)
        local check_nm = check and not check:IsNull()
            and (check.GetAbilityName and check:GetAbilityName() or check:GetName())
        if not check or check:IsNull() or check_nm ~= ab_name then
            break
        end
    end
end

--- 隐藏 A 杖/魔晶授予的技能（保留实体以维持被动效果）；技能书占用的 Skill1 槽位除外
function Skill:SuppressHeroAghSkillGrant(hero, ID, ab_name)
    if not hero or hero:IsNull() or not ab_name then
        return
    end
    if self:IsNullSkill(ab_name) or self:IsSkill(ab_name) or self:IsMeleeBrawlSkill(ab_name)
        or ab_name == "ability_bf_1" then
        return
    end
    if self:ShouldPreserveAghSkillBookGrant(hero, ID, ab_name) then
        self:RemoveExtraAbilityCopiesExceptSkill1Slot(hero, ID, ab_name)
        local slot_num = self:FindSkill1SlotNumForBookAbility(ID, ab_name, hero)
        if slot_num then
            local ab = hero:GetAbilityByIndex(self:Skill1SlotToAbilityIndex(slot_num))
            if ab and not ab:IsNull() then
                ab:SetHidden(false)
            end
        end
        return
    end
    local ab = hero:FindAbilityByName(ab_name)
    if not ab or ab:IsNull() then
        return
    end
    if self:FindSkill1SlotNumOnHero(hero, ab_name) then
        hero:RemoveAbility(ab_name)
        return
    end
    ab:SetHidden(true)
    if ab:GetLevel() < 1 then
        ab:SetLevel(1)
    end
end

--- 恢复 10 个技能槽占位与已学肉搏/Dota 槽位技能的可见性（与 InitPlayer:HeroInit 一致）
function Skill:EnsureHeroSkillSlotPlaceholders(hero, ID)
    if not hero or hero:IsNull() then
        return
    end
    local always_hidden_null = { [11] = true, [12] = true }
    for i = 1, 12 do
        local name = "ability_null_" .. i
        local ab = hero:FindAbilityByName(name)
        if ab and not ab:IsNull() then
            ab:SetHidden(always_hidden_null[i] == true)
            if ab:GetLevel() < 1 then
                ab:SetLevel(1)
            end
        end
    end
    if not ID and Util and Util.Hero2ID then
        ID = Util:Hero2ID(hero)
    end
    if ID and self.Data[ID] then
        if self.Data[ID].Skill1 then
            for i = 1, 4 do
                local row = self.Data[ID].Skill1["slot_" .. i]
                if row and row.name and not self:IsNullSkill(row.name) then
                    local ab = hero:FindAbilityByName(row.name)
                    if ab and not ab:IsNull() then
                        ab:SetHidden(false)
                    end
                end
            end
        end
        if self.Data[ID].Skill2 then
            for i = 5, 10 do
                local row = self.Data[ID].Skill2["slot_" .. i]
                if row and row.name then
                    local ab = hero:FindAbilityByName(row.name)
                    if ab and not ab:IsNull() then
                        ab:SetHidden(false)
                    end
                end
            end
        end
    end
end

--- 扫描英雄全部技能，压制 A 杖/魔晶额外技能显示
function Skill:SuppressAllHeroAghShardGrants(hero, ID)
    if not hero or hero:IsNull() or not HeroData or not HeroData.ShouldSuppressAghShardSkillDisplay then
        return
    end
    if not ID and Util and Util.Hero2ID then
        ID = Util:Hero2ID(hero)
    end
    for i = 0, hero:GetAbilityCount() - 1 do
        local ab = hero:GetAbilityByIndex(i)
        if ab and not ab:IsNull() then
            local nm = ab.GetAbilityName and ab:GetAbilityName() or ab:GetName()
            if nm and HeroData:ShouldSuppressAghShardSkillDisplay(hero, ID, nm) then
                self:SuppressHeroAghSkillGrant(hero, ID, nm)
            end
        end
    end
    self:EnsureHeroSkillSlotPlaceholders(hero, ID)
end

--- @deprecated 兼容旧调用，改为隐藏而非删除
function Skill:RemoveHeroAghSkillGrant(hero, ID, ab_name)
    self:SuppressHeroAghSkillGrant(hero, ID, ab_name)
end

--- Skill1 相关：任意占用中的二段/持续技能
function Skill:FindBusySkillAmongSkill1Slots(hero)
    return self:FindBusyHideAbilityOnHero(hero)
end

function Skill:HeroHasAnyNamedModifier(hero, mod_list)
    if not hero or hero:IsNull() or not mod_list then
        return false
    end
    for _, mod_name in ipairs(mod_list) do
        local ok_m, has = pcall(function()
            return hero:HasModifier(mod_name)
        end)
        if ok_m and has then
            return true
        end
    end
    return false
end

function Skill:IsAbilityShownNotHidden(ab)
    if not ab or ab:IsNull() or not ab.IsHidden then
        return false
    end
    local ok, hidden = pcall(function()
        return ab:IsHidden()
    end)
    return ok and hidden == false
end

--- 子技能替换态：主技能被藏起或 Dependent 子技能已露出（飞轮在外、羁绊中等）
function Skill:IsHideAbilityInDeployedState(hero, ability_name, cfg, main_ab)
    if not hero or hero:IsNull() or not cfg then
        return false
    end
    if main_ab and not main_ab:IsNull() and main_ab.IsHidden then
        local ok_h, is_hidden = pcall(function()
            return main_ab:IsHidden()
        end)
        if ok_h and is_hidden then
            return true
        end
    end
    for _, hide_name in ipairs(cfg.hide_ability or {}) do
        local hide_ab = hero:FindAbilityByName(hide_name)
        if self:IsAbilityShownNotHidden(hide_ab) then
            return true
        end
    end
    local mods = {}
    if cfg.busy_modifiers and type(cfg.busy_modifiers) == "table" then
        for _, m in ipairs(cfg.busy_modifiers) do
            table.insert(mods, m)
        end
    end
    local extra = self.HideAbilityBusyModifiers and self.HideAbilityBusyModifiers[ability_name]
    if extra then
        for _, m in ipairs(extra) do
            table.insert(mods, m)
        end
    end
    if #mods > 0 and self:HeroHasAnyNamedModifier(hero, mods) then
        return true
    end
    return false
end

--- 单个 ability 是否处于前摇/引导/当前活动施法
function Skill:IsAbilityUnitBusy(hero, ab)
    if not hero or hero:IsNull() or not ab or ab:IsNull() then
        return false
    end
    if hero:IsAlive() and ab.IsInAbilityPhase then
        local ok_phase, in_phase = pcall(function()
            return ab:IsInAbilityPhase()
        end)
        if ok_phase and in_phase then
            return true
        end
    end
    if hero.IsChanneling and hero:IsChanneling() and hero.GetCurrentAbility then
        local cur = hero:GetCurrentAbility()
        if cur and not cur:IsNull() and cur == ab then
            return true
        end
    end
    if hero.GetCurrentActiveAbility then
        local act = hero:GetCurrentActiveAbility()
        if act and not act:IsNull() and act == ab then
            return true
        end
    end
    return false
end

--- Config 含 hide_ability 的主技能：主技能或子技能施法中、或 busy modifier 存续时不可替换/卸下/移动该槽
function Skill:IsHideAbilitySkillBusyCasting(hero, ability_name)
    if not hero or hero:IsNull() or not ability_name then
        return false
    end
    ability_name = self:ResolveMainHideAbilityName(ability_name)
    self:EnsureHideAbilityIndex()
    local cfg = self._hideAbilityMainNameToConfig[ability_name]
    if not cfg then
        return false
    end
    local main_ab = hero:FindAbilityByName(ability_name)
    if self:IsAbilityUnitBusy(hero, main_ab) then
        return true
    end
    for _, hide_name in ipairs(cfg.hide_ability or {}) do
        local hide_ab = hero:FindAbilityByName(hide_name)
        if self:IsAbilityUnitBusy(hero, hide_ab) then
            return true
        end
    end
    if self:IsHideAbilityInDeployedState(hero, ability_name, cfg, main_ab) then
        return true
    end
    return false
end

local function skill_remove_linked_hide_abilities(skill_self, hero, main_ability_name)
    if not skill_self or not hero or hero:IsNull() or not main_ability_name then
        return
    end
    skill_self:EnsureHideAbilityIndex()
    local cfg = skill_self._hideAbilityMainNameToConfig[main_ability_name]
    if not cfg or not cfg.hide_ability then
        return
    end
    for _, hide_name in ipairs(cfg.hide_ability) do
        skill_self:RemoveAbilityWhenSafe(hero, hide_name)
    end
end

--- 技能名 → true：卸下/替换时一律立刻 RemoveAbility（不走隐藏与冷却等待）
--- 形如 ["ability_item_5"] = true，按需自行增删
Skill.RemoveAbilityImmediateNames = Skill.RemoveAbilityImmediateNames or {
    "bristleback_bristleback",
    "tiny_tree_grab",
    "sandking_epicenter", -- skill_362 地震：替换/卸下时立刻 Remove
}

--- 球状闪电：移除前先隐藏，固定延迟后再 Remove（避免飞魂等状态下立刻删）
local BALL_LIGHTNING_ABILITY_NAME = "storm_spirit_ball_lightning"
local BALL_LIGHTNING_REMOVE_DELAY = 10

local function skill_is_placeholder_null(ab_name)
    if not ab_name then return false end
    return string.match(ab_name, "^ability_null_%d+$") ~= nil
end

--- 凤凰冲击（兼容旧调用，走 hide_ability 通用逻辑）
function Skill:IsPhoenixIcarusDiveBusyCasting(hero, ability_name)
    return self:IsHideAbilitySkillBusyCasting(hero, ability_name)
end

local TECHIES_REACTIVE_TAZER_ABILITY_NAME = "techies_reactive_tazer"

--- 反应装甲：前摇/吟唱/当前活动技能为该能力或 buff 存续期间视为使用中，用于禁止替换或卸下该槽位
function Skill:IsTechiesReactiveTazerBusyCasting(hero, ability_name)
    if not hero or hero:IsNull() or ability_name ~= TECHIES_REACTIVE_TAZER_ABILITY_NAME then
        return false
    end
    local ab = hero:FindAbilityByName(ability_name)
    if not ab or ab:IsNull() then
        return false
    end
    if hero:IsAlive() and ab.IsInAbilityPhase then
        local ok_phase, in_phase = pcall(function()
            return ab:IsInAbilityPhase()
        end)
        if ok_phase and in_phase then
            return true
        end
    end
    if hero.IsChanneling and hero:IsChanneling() and hero.GetCurrentAbility then
        local cur = hero:GetCurrentAbility()
        if cur and not cur:IsNull() and cur == ab then
            return true
        end
    end
    if hero.GetCurrentActiveAbility then
        local act = hero:GetCurrentActiveAbility()
        if act and not act:IsNull() and act == ab then
            return true
        end
    end
    if hero:IsAlive() then
        local ok_m, has = pcall(function()
            return hero:HasModifier("modifier_techies_reactive_tazer")
        end)
        if ok_m and has then
            return true
        end
    end
    return false
end

--- 无任何「可点击施法」类行为时立刻删不会踩施法帧；否则会走延后删除
--- 施法/引导/当前活动技能仍为该 ability 时一律不立即删，避免引擎在施法帧上 Remove 崩溃
local function can_remove_ability_immediately(ab)
    if not ab or ab:IsNull() then
        return true
    end
    for k, v in pairs(Skill.RemoveAbilityImmediateNames) do
        if ab:GetName() == v then
            return true
        end
    end
    local caster = ab.GetCaster and ab:GetCaster() or nil
    if caster and not caster:IsNull() and caster:IsAlive() then
        if ab.IsInAbilityPhase then
            local ok_phase, in_phase = pcall(function()
                return ab:IsInAbilityPhase()
            end)
            if ok_phase and in_phase then
                return false
            end
        end
        if caster.IsChanneling and caster:IsChanneling() and caster.GetCurrentAbility then
            local cur = caster:GetCurrentAbility()
            if cur and not cur:IsNull() and cur == ab then
                return false
            end
        end
        if caster.GetCurrentActiveAbility then
            local act = caster:GetCurrentActiveAbility()
            if act and not act:IsNull() and act == ab then
                return false
            end
        end
    end

    local b = ab:GetBehavior()
    if not b or not bit then return false end
    local active_bits = bit.bor(
        DOTA_ABILITY_BEHAVIOR_NO_TARGET,
        DOTA_ABILITY_BEHAVIOR_POINT,
        DOTA_ABILITY_BEHAVIOR_UNIT_TARGET,
        DOTA_ABILITY_BEHAVIOR_CHANNELLED,
        DOTA_ABILITY_BEHAVIOR_TOGGLE,
        DOTA_ABILITY_BEHAVIOR_IMMEDIATE
    )

    if bit.band(b, active_bits) ~= 0 then return false end
    return bit.band(b, DOTA_ABILITY_BEHAVIOR_PASSIVE) ~= 0
end

--- 替换技能时立刻 Remove 易导致施法中崩溃：占位/纯被动仍立即删；主动类先隐藏，等冷却结束且不在施法/吟唱再删
function Skill:RemoveAbilityWhenSafe(hero, ability_name, skip_hide_cleanup)
    if not hero or hero:IsNull() or not ability_name or ability_name == "" then return end
    if skill_is_placeholder_null(ability_name) or self:IsNullSkill(ability_name) then
        hero:RemoveAbility(ability_name)
        return
    end
    local ab = hero:FindAbilityByName(ability_name)
    if not ab or ab:IsNull() then
        if not skip_hide_cleanup then
            skill_remove_linked_hide_abilities(self, hero, ability_name)
        end
        return
    end
    if ability_name == BALL_LIGHTNING_ABILITY_NAME then
        ab:SetHidden(true)
        local ent = hero:entindex()
        local key = tostring(ent) .. "_" .. ability_name
        local old_timer = self._deferTimerByKey[key]
        if old_timer then
            Timers:RemoveTimer(old_timer)
            self._deferTimerByKey[key] = nil
        end
        local timer_name = Timers(BALL_LIGHTNING_REMOVE_DELAY, function()
            if not hero or hero:IsNull() then
                Skill._deferTimerByKey[key] = nil
                return nil
            end
            local a = hero:FindAbilityByName(ability_name)
            if a and not a:IsNull() then
                hero:RemoveAbility(ability_name)
            end
            if not skip_hide_cleanup then
                skill_remove_linked_hide_abilities(self, hero, ability_name)
            end
            Skill._deferTimerByKey[key] = nil
            return nil
        end)
        self._deferTimerByKey[key] = timer_name
        return
    end
    if self.RemoveAbilityImmediateNames and self.RemoveAbilityImmediateNames[ability_name] then
        hero:RemoveAbility(ability_name)
        if not skip_hide_cleanup then
            skill_remove_linked_hide_abilities(self, hero, ability_name)
        end
        return
    end
    if can_remove_ability_immediately(ab) then
        hero:RemoveAbility(ability_name)
        if not skip_hide_cleanup then
            skill_remove_linked_hide_abilities(self, hero, ability_name)
        end
        return
    end
    ab:SetHidden(true)
    local ent = hero:entindex()
    local key = tostring(ent) .. "_" .. ability_name
    local old_timer = self._deferTimerByKey[key]
    if old_timer then
        Timers:RemoveTimer(old_timer)
        self._deferTimerByKey[key] = nil
    end

    local deadline = GameRules:GetGameTime() + 120
    local timer_name = Timers(function()
        if not hero or hero:IsNull() or not hero:IsAlive() then
            Skill._deferTimerByKey[key] = nil
            return nil
        end
        local a = hero:FindAbilityByName(ability_name)
        if not a or a:IsNull() then
            Skill._deferTimerByKey[key] = nil
            return nil
        end
        if GameRules:GetGameTime() >= deadline then
            hero:RemoveAbility(ability_name)
            if not skip_hide_cleanup then
                skill_remove_linked_hide_abilities(Skill, hero, ability_name)
            end
            Skill._deferTimerByKey[key] = nil
            return nil
        end

        local busy = false
        if hero:IsChanneling() then
            if hero.GetCurrentAbility then
                local cur = hero:GetCurrentAbility()
                if cur and not cur:IsNull() and cur == a then busy = true end
            else
                busy = true
            end
        end
        if not busy and a.IsInAbilityPhase then
            local ok, ph = pcall(function()
                return a:IsInAbilityPhase()
            end)
            if ok and ph then busy = true end
        end

        local cd_left = 0
        if a.GetCooldownTimeRemaining then
            cd_left = a:GetCooldownTimeRemaining() or 0
        end

        if not busy and cd_left <= 0.05 then
            hero:RemoveAbility(ability_name)
            if not skip_hide_cleanup then
                skill_remove_linked_hide_abilities(Skill, hero, ability_name)
            end
            Skill._deferTimerByKey[key] = nil
            return nil
        end
        return 0.05
    end)
    self._deferTimerByKey[key] = timer_name
end
