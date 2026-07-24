--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Skill == nil then
    Skill = class({})
    require("ingame.Skill.Config")
    require("ingame.Skill.Set")
    require("ingame.Skill.Get")
    require("ingame.Skill.Func")
    require("ingame.Skill.Ui")
end

function Skill:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    --初始化技能品阶
    for k, v in pairs(self.Ability) do
        local id = v.id
        if v.rank == 1 then
            table.insert(self.Rank1, id)
        end
        if v.rank == 2 then
            table.insert(self.Rank2, id)
        end
        if v.rank == 3 then
            table.insert(self.Rank3, id)
        end
        if v.rank == 4 then
            table.insert(self.Rank4, id)
        end
        if v.rank == 0 then
            table.insert(self.Rank0, id)
        end
    end
    self:EnsureHideAbilityIndex()
end

function Skill:OpenPage(ID)
    if not ID then
        return
    end
    self:RefreshSkill1FromHero(ID)
    self.Data[ID].skill_book_replace = not self:HasEmptySkill1Slot(ID)
    self.Data[ID].page = true
    self:SendData(ID)
end

function Skill:ClosePage(ID)
    if not ID then
        return
    end
    self:ClearList(ID)
    self.Data[ID].page = false
    self:SendData(ID)
end

function Skill:LoadHeroSkill(ID)
    if not ID then
        return
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return
    end
    local hero_name = HeroData:GetHeroName(ID)
    for k, v in pairs(self.Ability) do
        if v.hero and v.hero == hero_name then
            local list = {
                state = true,
                name = v.name,
                rank = v.rank,
                index = v.id
            }
            table.insert(self.Data[ID].HeroSkill, list)
        end
    end
end

function Skill:ParseRankNum(rank_key)
    return tonumber(string.match(rank_key or "", "^Rank(%d+)$"))
end

function Skill:ConsumeOwnerSkillGuarantee(ID, skill_id)
    if not ID or not skill_id then
        return
    end
    for _, v in pairs(self.Data[ID].HeroSkill or {}) do
        if v and v.index == skill_id then
            v.state = false
            return
        end
    end
end

function Skill:BuildRankLookup(ranks)
    local set = {}
    if not ranks then
        return set
    end
    for _, r in ipairs(ranks) do
        local n = tonumber(r)
        if n ~= nil then
            set[n] = true
        end
    end
    return set
end

function Skill:IsBookOverrideRollRank(book, rank_num)
    local cfg = self.BookGuarantee and self.BookGuarantee[book]
    if not cfg or not cfg.override_ranks or rank_num == nil then
        return false
    end
    for _, r in ipairs(cfg.override_ranks) do
        if r == rank_num then
            return true
        end
    end
    return false
end

--- 在指定品阶集合中选取未学、未消耗过保底的英雄绑定技能（id 最小）
function Skill:GetBestOwnerBoundSkillInRanks(ID, ranks, picked)
    local rank_set = self:BuildRankLookup(ranks)
    if not next(rank_set) then
        return
    end
    local best_id, best_rank_str, best_index = nil, nil, math.huge
    for _, v in pairs(self.Data[ID].HeroSkill or {}) do
        if v and v.state == true and rank_set[v.rank] then
            if not (picked and picked[v.index]) then
                local skill_name = v.name
                if not self:IsHaveSkill(ID, skill_name) then
                    local idx = tonumber(v.index) or math.huge
                    if idx < best_index then
                        best_index = idx
                        best_id = v.index
                        best_rank_str = "Rank" .. v.rank
                    end
                end
            end
        end
    end
    if best_id then
        return best_id, best_rank_str
    end
end

function Skill:CanOfferSkillInBookList(ID, skill_id, picked)
    if not ID or not skill_id then
        return false
    end
    if picked and picked[skill_id] then
        return false
    end
    local skill_data = self:GetSkillData(skill_id)
    if not skill_data then
        return false
    end
    local hero = Util:ID2Hero(ID)
    if hero and not hero:IsNull() and hero:HasAbility(skill_data.name) then
        return false
    end
    if self:IsHaveSkill(ID, skill_data.name) then
        return false
    end
    local page_num = self.Static.page_num
    for i = 1, page_num do
        local data = self.Data[ID].list["slot_" .. i]
        if data and data.state == false then
            return true
        end
    end
    return false
end

--- 尝试占用本书唯一一次英雄绑定保底名额
function Skill:TryApplyOwnerBoundGuarantee(ID, skill_id, rank_str, guarantee_used, picked)
    if guarantee_used or not skill_id or not self:CanOfferSkillInBookList(ID, skill_id, picked) then
        return nil, nil, guarantee_used
    end
    self:ConsumeOwnerSkillGuarantee(ID, skill_id)
    return skill_id, rank_str, true
end

function Skill:MarkBookPickedSkill(picked, skill_id)
    if picked and skill_id then
        picked[skill_id] = true
    end
end

function Skill:IsHaveSkill(ID, skill_name)
    if not ID or not skill_name then
        return
    end
    for k, v in pairs(self.Data[ID].Skill1) do
        if skill_name == v.name then
            return true
        end
    end
end

--使用技能书
function Skill:UseBook(ID, book)
    if not ID or not book then
        return false
    end
    if self:RejectLearnOrReplaceIfHeroDead(ID) then
        return false
    end
    -- 究极技能书：对局满 15 分钟后才能使用（与枪术分裂解锁同一时间接口）
    if book == "T0" then
        local game_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
        if game_min < 15 then
            Util:BottomMsg2ID(ID, "究极技能书需对局 15 分钟后才能使用", "yellow", 2)
            return false
        end
    end
    local hero = Util:ID2Hero(ID)
    EmitSoundOn("Item.DropRecipeWorld", hero)
    self:ClearList(ID)
    local roll_list = self:GetBookRollList(book)
    if not roll_list then
        return false
    end
    local skill_num = self.Static.page_num
    local use_guarantee = not self:UsesPassiveSkillBookWhitelistOnly()
    local book_guarantee = use_guarantee and self.BookGuarantee and self.BookGuarantee[book]
    local guarantee_used = false
    local results = {}
    local picked = {}

    -- 规则一：按技能书品阶，第一个候选必定尝试放入对应 primary 品阶的英雄绑定技能
    if book_guarantee and book_guarantee.primary_ranks then
        local skill_id, rank_str = self:GetBestOwnerBoundSkillInRanks(
            ID, book_guarantee.primary_ranks, picked
        )
        skill_id, rank_str, guarantee_used = self:TryApplyOwnerBoundGuarantee(
            ID, skill_id, rank_str, guarantee_used, picked
        )
        if skill_id then
            table.insert(results, { skill = skill_id, rank = rank_str })
            self:MarkBookPickedSkill(picked, skill_id)
        end
    end

    local fill_attempts = 0
    while #results < skill_num do
        fill_attempts = fill_attempts + 1
        if fill_attempts > skill_num * 120 then
            break
        end
        local rank = Util:Weight(roll_list)
        local roll_skill = self:RollSkill(ID, rank, picked)
        local rolled_rank = self:ParseRankNum(rank)

        -- 规则二：roll 到「越级」品阶时，优先替换为同品阶英雄绑定技能（本书尚未用过保底名额时）
        if book_guarantee and not guarantee_used and rolled_rank ~= nil
            and self:IsBookOverrideRollRank(book, rolled_rank) then
            local owner_id, owner_rank = self:GetBestOwnerBoundSkillInRanks(ID, { rolled_rank }, picked)
            local applied_id, applied_rank
            applied_id, applied_rank, guarantee_used = self:TryApplyOwnerBoundGuarantee(
                ID, owner_id, owner_rank, guarantee_used, picked
            )
            if applied_id then
                roll_skill = applied_id
                rank = applied_rank
            end
        end

        if roll_skill and not picked[roll_skill] then
            table.insert(results, { skill = roll_skill, rank = rank })
            self:MarkBookPickedSkill(picked, roll_skill)
        end

        if book == "T0" then
            roll_list.Rank1 = nil
            roll_list.Rank0 = nil
        end
    end

    for _, row in ipairs(results) do
        self:AddSkill(ID, row.skill, row.rank)
    end
    self:OpenPage(ID)
    if ClrbTalentScholarOnBookTier then
        ClrbTalentScholarOnBookTier(ID, book)
    end
    return true
end

--- 技能书选中技能后写入 Skill1 槽位（与 SelectSkill 共用，num2 为 1–4）
--- @return boolean 是否成功
function Skill:ApplySkillBookToSlot(ID, skill_id, slot_num)
    if not ID or not skill_id or not slot_num then
        return false
    end
    if self:RejectLearnOrReplaceIfHeroDead(ID) then
        return false
    end
    local data = self:GetSkillData(skill_id)
    if not data then
        return false
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return false
    end
    local slot_key = "slot_" .. slot_num
    local old_slot = self.Data[ID].Skill1[slot_key]
    if not old_slot then
        return false
    end
    local new_skill = data.name
    if hero:FindAbilityByName(new_skill) == true then
        return false
    end
    -- 以英雄实体槽位为准，避免 Skill1 缓存与 Q/W/E/R 不一致时误换 ability_null
    local old_skill = self:GetHeroSkill1SlotAbilityName(hero, slot_num) or old_slot.name
    if old_skill == "medusa_split_shot" and hero:HasModifier("modifier_medusa_split_shot") then
        hero:RemoveModifierByName("modifier_medusa_split_shot")
    end
    if old_skill == "mars_bulwark" and hero:HasModifier("modifier_mars_bulwark_active") then
        hero:RemoveModifierByName("modifier_mars_bulwark_active")
    end
    if old_skill == "death_prophet_exorcism" and hero:HasModifier("modifier_death_prophet_exorcism") then
        hero:RemoveModifierByName("modifier_death_prophet_exorcism")
    end
    if old_skill == "pudge_rot" and hero:HasModifier("modifier_pudge_rot") then
        hero:RemoveModifierByName("modifier_pudge_rot")
    end
    if old_skill == "muerta_gunslinger" and hero:HasModifier("modifier_muerta_gunslinger") then
        hero:RemoveModifierByName("modifier_muerta_gunslinger")
    end
    if old_skill == "winter_wyvern_arctic_burn" and hero:HasModifier("modifier_winter_wyvern_arctic_burn_flight") then
        hero:RemoveModifierByName("modifier_winter_wyvern_arctic_burn_flight")
    end
    if old_skill == "leshrac_pulse_nova" and hero:HasModifier("modifier_leshrac_pulse_nova") then
        hero:RemoveModifierByName("modifier_leshrac_pulse_nova")
    end
    if old_skill == "witch_doctor_voodoo_restoration" then
        if hero:HasModifier("modifier_voodoo_restoration_heal") then
            hero:RemoveModifierByName("modifier_voodoo_restoration_heal")
        end
        if hero:HasModifier("modifier_voodoo_restoration_aura") then
            hero:RemoveModifierByName("modifier_voodoo_restoration_aura")
        end
    end
    if new_skill ~= old_skill then
        local slot_index = slot_num - 1
        if slot_index == 3 then
            slot_index = 5
        end
        local slot_ab = hero:GetAbilityByIndex(slot_index)
        local slot_skill = slot_ab and not slot_ab:IsNull() and slot_ab:GetName() or old_skill
        if self:IsSkillBusyBlockingChange(hero, old_skill)
            or self:IsSkillBusyBlockingChange(hero, slot_skill) then
            Util:BottomMsg2ID(
                ID,
                self:GetSkillBusyRemoveTip(self:ResolveMainHideAbilityName(slot_skill) or old_skill, false),
                "yellow",
                2
            )
            return false
        end
    end
    local init_point = hero:GetAbilityPoints()
    local add_point = 0
    if new_skill == old_skill then
        local ab = hero:FindAbilityByName(old_skill)
        local hero_name = HeroData:GetHeroName(ID)
        if self:IsExcludeKeepAbility(hero_name, new_skill) then
            ab:SetHidden(false)
        end
        hero:UpgradeAbility(ab)
        local skill_config = self.Ability["skill_" .. skill_id]
        if skill_config and skill_config.hide_ability then
            for _, hide_ab_name in ipairs(skill_config.hide_ability) do
                if not hero:HasAbility(hide_ab_name) then
                    hero:AddAbility(hide_ab_name)
                end
            end
        end
    else
        self.Data[ID].Skill1[slot_key].name = new_skill
        self.Data[ID].Skill1[slot_key].id = skill_id
        self.Data[ID].Skill1[slot_key].book_pending = true
        hero:AddAbility(new_skill)
        local old_ab = hero:FindAbilityByName(old_skill)
        if not self:IsNullSkill(old_skill) then
            add_point = old_ab:GetLevel()
        end
        hero:SwapAbilities(new_skill, old_skill, true, true)
        self:RemoveAbilityWhenSafe(hero, old_skill)
        self.Data[ID].Skill1[slot_key].book_pending = nil
        self:UpDataSlot(ID)
        local skill_config = self.Ability["skill_" .. skill_id]
        if skill_config and skill_config.hide_ability then
            for _, hide_ab_name in ipairs(skill_config.hide_ability) do
                if not hero:HasAbility(hide_ab_name) then
                    hero:AddAbility(hide_ab_name)
                end
            end
        end
    end
    hero:SetAbilityPoints(init_point + add_point)
    return true
end

--- 工具模式图鉴：按 1→2→3→4 循环替换 Skill1，逻辑与使用技能书一致
function Skill:ToolsLearnSkillBookCyclic(ID, ability_name)
    if not IsInToolsMode() then
        return false
    end
    if not ID or not ability_name or not self.Data[ID] then
        return false
    end
    local skill_id = self:GetSkillID(ability_name)
    if not skill_id then
        Util:BottomMsg2ID(ID, "未找到技能配置", "red", 1)
        return false
    end
    local rot = tonumber(self.Data[ID].tools_skill_rot) or 1
    if rot < 1 or rot > 4 then
        rot = 1
    end
    if not self:ApplySkillBookToSlot(ID, skill_id, rot) then
        return false
    end
    self.Data[ID].tools_skill_rot = (rot % 4) + 1
    self:SendData(ID)
    return true
end

--选取技能
function Skill:SelectSkill(ID, num1, num2)
    if not ID or not num1 or not num2 then
        return
    end
    local slot1 = "slot_" .. num1
    if self.Data[ID].list[slot1].state == false then
        return
    end
    self:RefreshSkill1FromHero(ID)
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    local slot_num = tonumber(num2)
    if not slot_num or slot_num < 1 or slot_num > 4 then
        return
    end
    if self:HasEmptySkill1Slot(ID) then
        if not self:IsHeroSkill1SlotEmpty(hero, slot_num) then
            for i = 1, 4 do
                if self:IsHeroSkill1SlotEmpty(hero, i) then
                    slot_num = i
                    break
                end
            end
        end
        if not self:IsHeroSkill1SlotEmpty(hero, slot_num) then
            return
        end
    else
        if self:IsHeroSkill1SlotEmpty(hero, slot_num) then
            Util:BottomMsg2ID(ID, "请选择要替换的技能槽位", "yellow", 1)
            return
        end
    end
    local id = self.Data[ID].list[slot1].skill
    if self:ApplySkillBookToSlot(ID, id, slot_num) then
        self:ClosePage(ID)
    end
end

function Skill:IsMeleeSkillBookItemName(item_name)
    if not item_name or type(item_name) ~= "string" then
        return false
    end
    if string.match(item_name, "^item_skill_%d+_up$") then
        return true
    end
    if string.match(item_name, "^item_skill_%d+$") then
        return true
    end
    return false
end

--- 向商店出售肉搏技能书：与「删除后禁止拾取」同表，宠物不再捡该名书本
function Skill:BanMeleeBookPetAfterSellToShop(ID, item_name)
    if not ID or not self:IsMeleeSkillBookItemName(item_name) or not self.Data[ID] then
        return
    end
    if not self.Data[ID].melee_pet_ban then
        self.Data[ID].melee_pet_ban = {}
    end
    self.Data[ID].melee_pet_ban[item_name] = true
end

--- 成功用书学/升肉搏技后、或从商店新购该名书本的下单时，解除「删除/出售后禁止宠物拾取」
function Skill:ClearMeleePetBanForBook(ID, item_name)
    if not ID or not item_name or not self.Data[ID] then
        return
    end
    local t = self.Data[ID].melee_pet_ban
    if not t then
        return
    end
    t[item_name] = nil
end

--添加肉搏技能
function Skill:AddSkill2(ID, item_name)
    if not ID or not item_name then
        return
    end
    if MainGame and MainGame.IsPassiveModeBannedPurchaseItem
        and MainGame:IsPassiveModeBannedPurchaseItem(item_name) then
        Util:BottomMsg2ID(ID, "被动模式下不可学习该技能", "red", 1)
        return false
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return false
    end
    local index = utilex:splitIndex(item_name, "_", 3)
    local new_skill = "ability_item_" .. index
    local arr_len = utilex:split(item_name, "_")
    if hero:HasAbility(new_skill) and #arr_len == 3 then
        local ab = hero:FindAbilityByName(new_skill)
        --获取技能等级
        local level = ab:GetLevel()
        --获取技能最大等级
        local max_skill_level = 10
        if level >= max_skill_level then
            return false
        end
        -- ab:SetLevel(level + 1)
        -- return true
        if hero:GetLevel() > level then
            ab:SetLevel(level + 1)
            self:ClearMeleePetBanForBook(ID, item_name)
            return true
        else
            Util:BottomMsg2ID(ID, "技能等级不能超过英雄等级")
            return false
        end
    end
    if item_name == "item_skill_14_up" or item_name == "item_skill_20_up" or item_name == "item_skill_24_up" or item_name == "item_skill_27_up" then
        local up_skill
        local self_skill
        if item_name == "item_skill_14_up" then
            up_skill = "ability_item_14_up"
            self_skill = "ability_item_14"
        end
        if item_name == "item_skill_20_up" then
            up_skill = "ability_item_20_up"
            self_skill = "ability_item_20"
        end
        if item_name == "item_skill_24_up" then
            up_skill = "ability_item_24_up"
            self_skill = "ability_item_24"
        end
        if item_name == "item_skill_27_up" then
            up_skill = "ability_item_27_up"
            self_skill = "ability_item_27"
        end
        local old_ab = hero:FindAbilityByName(self_skill)
        if not old_ab then
            Util:BottomMsg2ID(ID, "请先学习指定技能")
            return false
        end
        local level = old_ab:GetLevel()
        if level ~= 10 then
            Util:BottomMsg2ID(ID, "技能等级未满足指定要求")
            return false
        end
        local ab = hero:AddAbility(up_skill)
        hero:SwapAbilities(up_skill, self_skill, true, true)
        ab:SetHidden(false)
        ab:SetLevel(1)
        hero:RemoveAbility(self_skill)
        for j = 5, 10 do
            local sk = "slot_" .. j
            local row = self.Data[ID].Skill2[sk]
            if row and row.state and row.name == self_skill then
                self.Data[ID].Skill2[sk].name = up_skill
                break
            end
        end
        self:ClearMeleePetBanForBook(ID, item_name)
        return true
    end
    if self:Skill2IsFull(ID) then
        return false
    end
    for i = 5, 10 do
        local slot = "slot_" .. i
        local data = self.Data[ID].Skill2[slot]
        if data.state == false then
            local old_skill = data.name
            local ab = hero:AddAbility(new_skill)
            hero:SwapAbilities(new_skill, old_skill, true, true)
            ab:SetHidden(false)
            ab:SetLevel(1)
            hero:RemoveAbility(old_skill)
            self.Data[ID].Skill2[slot].state = true
            self.Data[ID].Skill2[slot].name = new_skill
            self:ClearMeleePetBanForBook(ID, item_name)
            return true
        end
    end
end

--删除肉搏技能
--- @return boolean 是否成功打开删除页
function Skill:OpenDelSkill(ID)
    if not ID then
        return false
    end
    self.Data[ID].del_page = true
    self:SendDelData(ID)
    return true
end

function Skill:CloseDelPage(ID)
    self.Data[ID].del_page = false
    self:SendDelData(ID)
end

--删除指定肉搏技能
function Skill:DelSkill(ID, num)
    if not ID or not num then
        return
    end
    local slot = "slot_" .. num
    local data = self.Data[ID].Skill2[slot]
    if data.state == false then
        return
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return
    end
    local ab_slot = data.slot
    local name = data.name
    local old_ab = hero:FindAbilityByName(name)
    if not old_ab or old_ab:IsNull() then
        local only_base_idx = string.match(name or "", "^ability_item_(%d+)$")
        if only_base_idx and hero:HasAbility("ability_item_" .. only_base_idx .. "_up") then
            name = "ability_item_" .. only_base_idx .. "_up"
            self.Data[ID].Skill2[slot].name = name
            old_ab = hero:FindAbilityByName(name)
        end
    end
    if not old_ab or old_ab:IsNull() then
        return
    end
    if not self.Data[ID].melee_pet_ban then
        self.Data[ID].melee_pet_ban = {}
    end
    local idx_base = string.match(name, "^ability_item_(%d+)$")
    if idx_base then
        self.Data[ID].melee_pet_ban["item_skill_" .. idx_base] = true
    end
    local idx_up = string.match(name, "^ability_item_(%d+)_up$")
    if idx_up then
        self.Data[ID].melee_pet_ban["item_skill_" .. idx_up .. "_up"] = true
        self.Data[ID].melee_pet_ban["item_skill_" .. idx_up] = true
    end
    local ab_level = old_ab:GetLevel()
    PlayerResource:ModifyGold(ID, ab_level * 100, false, 0)
    local new_skill = "ability_null_" .. ab_slot
    local old_skill = name
    local ab = hero:AddAbility(new_skill)
    hero:SwapAbilities(new_skill, old_skill, true, true)
    ab:SetHidden(false)
    ab:SetLevel(1)
    hero:RemoveAbility(old_skill)
    self.Data[ID].Skill2[slot].state = false
    self.Data[ID].Skill2[slot].name = new_skill
    Skill:CloseDelPage(ID)
end

--修改技能槽位（释放中也可打开面板；具体换位在 SelectSlot 中拦截忙碌技能）
function Skill:ChangeSlot(ID)
    if not ID then
        return
    end
    self.Data[ID].slot_page = true
    self:SendSlotData(ID)
end

--选择修改槽位
function Skill:SelectSlot(ID, change_slot, target_slot)
    if not ID then
        return
    end
    if self:RejectLearnOrReplaceIfHeroDead(ID) then
        return
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return
    end
    local change_index = change_slot - 1
    local target_index = target_slot - 1
    if change_index == 3 then
        change_index = 5
    end
    if target_index == 3 then
        target_index = 5
    end
    local ability_1_name = hero:GetAbilityByIndex(change_index):GetName()
    local ability_2_name = hero:GetAbilityByIndex(target_index):GetName()
    if self:IsNullSkill(ability_1_name) and self:IsNullSkill(ability_2_name) then
        self.Data[ID].slot_page = false
        self:SendSlotData(ID)
        Skill:SendData(ID)
        return
    end
    if self:IsSkillBusyBlockingChange(hero, ability_1_name) then
        Util:BottomMsg2ID(ID, self:GetSkillBusyMoveTip(ability_1_name), "yellow", 2)
        return
    end
    if self:IsSkillBusyBlockingChange(hero, ability_2_name) then
        Util:BottomMsg2ID(ID, self:GetSkillBusyMoveTip(ability_2_name), "yellow", 2)
        return
    end
    hero:SwapAbilities(ability_1_name, ability_2_name, true, true)
    self:UpDataSlot(ID)
    self.Data[ID].slot_page = false
    self:SendSlotData(ID)
    Skill:SendData(ID)
end

--将当前英雄实际槽位的技能对应到数据Skill1中
function Skill:UpDataSlot(ID)
    if not ID then
        return
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return
    end
    for i = 1, 4 do
        local slot = "slot_" .. i
        local index = i - 1
        if index == 3 then
            index = 5
        end
        local ab = hero:GetAbilityByIndex(index)
        if ab then
            local ab_name = ab:GetName()
            local ab_id = -1
            if not self:IsNullSkill(ab_name) then
                ab_id = self:GetSkillID(ab_name) or -1
            end
            self.Data[ID].Skill1[slot].name = ab_name
            self.Data[ID].Skill1[slot].id = ab_id
        end
    end
end

--把一个槽技能换成空技能
function Skill:ClearSlot(ID, num)
    if not ID or not num then
        return
    end
    local hero = Util:ID2Hero(ID)
    local slot = "slot_" .. num
    if self.Data[ID].Skill1[slot].id == -1 then
        return
    end
    local new_skill = "ability_null_" .. num
    local old_skill = self.Data[ID].Skill1[slot].name
    if self:IsSkillBusyBlockingChange(hero, old_skill) then
        Util:BottomMsg2ID(ID, self:GetSkillBusyRemoveTip(old_skill, true), "yellow", 2)
        return
    end
    local ab = hero:AddAbility(new_skill)
    ab:SetLevel(1)
    hero:SwapAbilities(new_skill, old_skill, true, true)
    self:RemoveAbilityWhenSafe(hero, old_skill)
    self.Data[ID].Skill1[slot].name = new_skill
    self.Data[ID].Skill1[slot].id = -1
end

--添加一个技能到空槽
function Skill:AddSkillToSlot(ID, num, new_skill, level)
    local hero = Util:ID2Hero(ID)
    local slot = "slot_" .. num
    if self.Data[ID].Skill1[slot].id ~= -1 then
        return
    end
    local old_skill = self.Data[ID].Skill1[slot].name
    local ab = hero:AddAbility(new_skill)
    ab:SetLevel(level)
    hero:SwapAbilities(new_skill, old_skill, true, true)
    -- hero:RemoveAbility(old_skill)
    local old_ab = hero:FindAbilityByName(old_skill)
    old_ab:SetHidden(true)
    local id = self:GetSkillID(new_skill)
    self.Data[ID].Skill1[slot].name = new_skill
    self.Data[ID].Skill1[slot].id = id
end

function Skill:CloseSlotPage(ID)
    self.Data[ID].slot_page = false
    self:SendSlotData(ID)
end
