--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Book:GetHeroState(name)
    if not name then
        return
    end
    for k, v in pairs(SelectHero.HeroList) do
        if name == k then
            return true
        end
    end
end

function Book:GetHeroID(name)
    if not name then
        return
    end
    for k, v in pairs(SelectHero.HeroList) do
        if name == k then
            return v.index
        end
    end
end

--- 按 slot_1、slot_2… 固定顺序遍历带 slot 前缀的表
function Book:ForEachSlotSorted(map, callback)
    if not map or not callback then
        return
    end
    local max_slot = 0
    for k in pairs(map) do
        local idx = tonumber(utilex:splitIndex(k, "_", 2)) or 0
        if idx > max_slot then
            max_slot = idx
        end
    end
    for i = 1, max_slot do
        local k = "slot_" .. i
        local v = map[k]
        if v ~= nil then
            callback(k, v)
        end
    end
end

local function clrb_book_skill_hero_bound(hero_field)
    if hero_field == nil then
        return false
    end
    if type(hero_field) ~= "string" then
        return false
    end
    return hero_field ~= ""
end

function Book:BuildSkillSlotList(skills)
    local list = {}
    if not skills then
        return list
    end
    for i, sk in ipairs(skills) do
        list["slot_" .. i] = {
            state = true,
            name = sk.name,
            img = sk.key,
            rank = sk.rank,
        }
    end
    return list
end

--- 收集 Skill.Ability 中绑定到指定英雄的全部技能（按 id 排序）
function Book:CollectSkillsByHero(hero_name)
    if not hero_name or hero_name == "" then
        return {}
    end
    local skills = {}
    if not Skill or not Skill.Ability then
        return skills
    end
    for key, row in pairs(Skill.Ability) do
        if row and row.name and row.name ~= "" and row.hero == hero_name then
            table.insert(skills, {
                key = key,
                name = row.name,
                rank = row.rank ~= nil and row.rank or -1,
                id = tonumber(row.id) or 0,
            })
        end
    end
    table.sort(skills, function(a, b)
        if a.id ~= b.id then
            return a.id < b.id
        end
        return (a.name or "") < (b.name or "")
    end)
    return skills
end

--- hero 字段为空 / 未绑定的公共技能
function Book:CollectPublicSkills()
    local skills = {}
    if not Skill or not Skill.Ability then
        return skills
    end
    for key, row in pairs(Skill.Ability) do
        if row and row.name and row.name ~= "" and not clrb_book_skill_hero_bound(row.hero) then
            table.insert(skills, {
                key = key,
                name = row.name,
                rank = row.rank ~= nil and row.rank or -1,
                id = tonumber(row.id) or 0,
            })
        end
    end
    table.sort(skills, function(a, b)
        if a.rank ~= b.rank then
            return a.rank < b.rank
        end
        if a.id ~= b.id then
            return a.id < b.id
        end
        return (a.name or "") < (b.name or "")
    end)
    return skills
end

function Book:GetHeroSkillList(name, list)
    if not name or not list then
        return list
    end
    local skills = self:CollectSkillsByHero(name)
    for i = 1, 5 do
        local slot_key = "slot_" .. i
        local slot = list[slot_key]
        if slot then
            local sk = skills[i]
            if sk then
                slot.state = true
                slot.name = sk.name
                slot.img = sk.key
                slot.rank = sk.rank
            else
                slot.state = false
                slot.name = ""
                slot.img = ""
                slot.rank = -1
            end
        end
    end
    return list
end

function Book:IsInList(list, name)
    if not list or not name then
        return
    end
    for k, v in pairs(list) do
        if v.name == name then
            return true
        end
    end
end
