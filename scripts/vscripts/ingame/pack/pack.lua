--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Pack == nil then
    Pack = class({})
    require("ingame.Pack.Config")
    require("ingame.Pack.Set")
    require("ingame.Pack.Get")
    require("ingame.Pack.Func")
    require("ingame.Pack.Ui")
end

function Pack:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    -- 初始化背包
    local slot_max = self.Static.slot_max
    for i = 1, slot_max do
        local slot = "slot_" .. i
        self.Team2[slot] = Util:DeepCopyTab(self.SlotTemplate)
        self.Team2[slot].slot = i
        self.Team3[slot] = Util:DeepCopyTab(self.SlotTemplate)
        self.Team3[slot].slot = i
    end
    local hero = Util:ID2Hero(ID)
    if hero then
        local team = hero:GetTeam()
        local team_key = "Team" .. team
        self.Data[ID].pack_tp = team_key
    end
end

-- 点击单位
function Pack:GetUnit(ID, data)
    if not ID or not data then return end
    if not data then return end
    if #data == 0 then return end
    local index = data[1].entityIndex
    if index then
        local unit = EntIndexToHScript(index)
        -- if unit:IsItem() then return end
        if not unit or unit:IsNull() then return end
        if unit == HeroData:GetHero(ID) then
            Skill:OpenChangeImg(ID)
            Box:Show(ID)
            Talent:OpenTextPage(ID)
        else
            Skill:CloseChangeImg(ID)
            Box:Hide(ID)
            Talent:CloseTextPage(ID)
        end
    end
end

-- 选中英雄
function Pack:SelectHero(ID, index)
    local unit = EntIndexToHScript(index)
    if not unit:IsHero() then
        Skill:CloseChangeImg(ID)
        Box:Hide(ID)
        Talent:CloseTextPage(ID)
    else
        Skill:OpenChangeImg(ID)
        Box:Show(ID)
        Talent:OpenTextPage(ID)
    end
end

function Pack:GetItem(hero, item_name)
    for i = 0, 9 do
        local item = hero:GetItemInSlot(i)
        if item and item:GetName() == item_name then return item end
    end
end

-- 存道具
function Pack:SaveItem(hero, item_name, team, num)
    local team_key = "Team" .. team
    -- 是否有同名道具
    if self:IsHaveItem(team, item_name) then
        for k, v in pairs(self[team_key]) do
            if v.state and v.item == item_name then
                v.num = v.num + num
                -- 更新公共背包
                self:SendPublicData(team)
                return
            end
        end
    else
        for i = 1, 20 do
            local slot = "slot_" .. i
            if Pack[team_key][slot].state == false then
                Pack[team_key][slot].state = true
                Pack[team_key][slot].item = item_name
                Pack[team_key][slot].num = num
                self:SendPublicData(team)
                return
            end
        end
    end
end

-- 取道具
function Pack:TackItem(ID, slot)
    if not ID or not slot then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    local team = hero:GetTeam()
    local team_key = "Team" .. team
    if self[team_key][slot].state == false then return end
    local num = self[team_key][slot].num
    local item_name = self[team_key][slot].item
    for i = 1, num do Item:AddItem(ID, item_name) end

    self[team_key][slot].state = false
    self[team_key][slot].item = ""
    self[team_key][slot].num = -1
    self:SendPublicData(team)
end

-- 给单位一个计时器
function Pack:AutoPage(unit)
    if not unit then return end
    local name = unit:GetUnitName()
    local st = unit:GetAbsOrigin()
    local team = 2
    if name == "Pack" then team = 2 end
    if name == "BadPack" then team = 3 end
    local list = {}
    Timers(0.5, function()
        local units = utilex:GetRadiusUnit(unit, unit:GetAbsOrigin(), 1000,
                                           "good")
        if units and #units > 0 then
            for k, v in pairs(units) do
                if v:IsHero() and v:GetTeam() == team then
                    local ed = v:GetAbsOrigin()
                    local len = (st - ed):Length2D()
                    local ID = Util:Hero2ID(v)
                    if len <= 500 and not Pack:GetPage(ID) then
                        Pack:OpenPage(ID)
                        local index = v:GetEntityIndex()
                        table.insert(list, index)
                    end
                end
            end
        end
        for k, v in pairs(list) do
            local hero = EntIndexToHScript(v)
            if hero then
                local ID = Util:Hero2ID(hero)
                local ed = hero:GetAbsOrigin()
                local len = (st - ed):Length2D()
                if len > 500 and Pack:GetPage(ID) then
                    Pack:ClosePage(ID)
                    list[k] = nil
                end
            end
        end
        return 0.5
    end)
end

function Pack:CreatePack()
    for k, v in pairs(self.Static.pos) do
        local name = v.name
        local pos = v.ve
        local turn = v.turn
        local team = v.team
        local unit = utilex:CreateUnit(name, pos, nil, team)
        utilex:AddModifier(unit, "wd_nobar")
        unit:SetAngles(0, turn, 0)
        Pack:AutoPage(unit)
    end
end
