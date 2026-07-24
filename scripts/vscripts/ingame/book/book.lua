--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Book == nil then
    Book = class({})
    require("ingame.Book.Config")
    require("ingame.Book.Set")
    require("ingame.Book.Get")
    require("ingame.Book.Func")
    require("ingame.Book.Ui")
end

function Book:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    Book:InitHeroList(ID)
end

function Book:InitHeroList(ID)
    for i = 1, 4 do
        local tp_key = "tp" .. i
        self:ForEachSlotSorted(self.HeroList[tp_key], function(k, v)
            local index = tonumber(utilex:splitIndex(k, "_", 2))
            local hero_data = Util:DeepCopyTab(self.HeroType)
            hero_data.index = index
            hero_data.tp = i
            hero_data.name = v
            if self:GetHeroState(v) then
                hero_data.state = true
            else
                hero_data.state = false
            end
            if self:GetHeroID(v) then
                hero_data.id = self:GetHeroID(v)
            else
                hero_data.id = -1
            end
            self.Data[ID].list1[tp_key][k] = hero_data
        end)
    end
    local book_hero_set = {}
    local row_cfg = self.UnassignedSkillRow or {}
    self.Data[ID].list_public = {
        display_name = row_cfg.display_name or "clrb_book_unassigned_skills",
        list = self:BuildSkillSlotList(self:CollectPublicSkills()),
    }
    local num = 1
    for i = 1, 4 do
        local tp_key = "tp" .. i
        self:ForEachSlotSorted(self.Data[ID].list1[tp_key], function(_, v)
            if v.name and v.name ~= "" then
                book_hero_set[v.name] = true
            end
            local num_key = "num" .. num
            local skill_data = Util:DeepCopyTab(self.HeroSkill)
            skill_data.index = num
            skill_data.name = v.name
            skill_data.list = self:GetHeroSkillList(v.name, skill_data.list)
            self.Data[ID].list2[num_key] = skill_data
            num = num + 1
        end)
    end
    -- Skill.Ability 中已绑定英雄、但未列入 Book.HeroList 的，补一行展示其全部技能
    local extra_heroes = {}
    if Skill and Skill.Ability then
        for _, row in pairs(Skill.Ability) do
            local hn = row and row.hero
            if hn and hn ~= "" and not book_hero_set[hn] and not extra_heroes[hn] then
                extra_heroes[hn] = true
            end
        end
    end
    local extra_list = {}
    for hn in pairs(extra_heroes) do
        table.insert(extra_list, hn)
    end
    table.sort(extra_list)
    for _, hn in ipairs(extra_list) do
        book_hero_set[hn] = true
        local num_key = "num" .. num
        local skill_data = Util:DeepCopyTab(self.HeroSkill)
        skill_data.index = num
        skill_data.name = hn
        skill_data.list = self:GetHeroSkillList(hn, skill_data.list)
        self.Data[ID].list2[num_key] = skill_data
        num = num + 1
    end
    local num2 = 1
    for k, v in pairs(self.BattleSort) do
        if v ~= -1 then
            local tp_key = "tp" .. v
            local battle_data = Util:DeepCopyTab(self.BattleSkill)
            local num_key = "num" .. num2
            battle_data.index = num2
            battle_data.name = k
            battle_data.text = "DOTA_Tooltip_ability_" .. k .. "_Description"
            self.Data[ID].list3[tp_key][num_key] = battle_data
            num2 = num2 + 1
        end
    end
end
