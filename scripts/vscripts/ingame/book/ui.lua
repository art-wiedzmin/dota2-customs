--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Book:GetUIData(ID, data)
    if not ID or not data then return end
    -- 暂停禁止传数据
    -- if GameRules:IsGamePaused() then return end
    -- 初始化数据
    if data.tp == "init" then self:SendData(ID) end
    if data.tp == "OpenPage" then self:OpenPage(ID) end
    if data.tp == "ClosePage" then self:ClosePage(ID) end
    if data.tp == "SelectPage" then self:SelectPage(ID, data.text) end
    if data.tp == "LearnAbility" then self:LearnAbility(ID, data.text) end
end

function Book:SendData(ID)
    if not ID then return end
    local data = self.Data[ID]
    Util:Send2JsID("UI_Book", data, ID)
end

function Book:OpenPage(ID)
    if not ID then return end
    if IsInToolsMode() and self.InitHeroList then
        self:InitHeroList(ID)
    end
    self.Data[ID].page = true
    self:SendData(ID)
end

function Book:ClosePage(ID)
    if not ID then return end
    self.Data[ID].page = false
    self:SendData(ID)
end

function Book:SelectPage(ID, text)
    if not ID or not text then return end
    self.Data[ID].page_type = text
    self:SendData(ID)
end

function Book:LearnAbility(ID, name)
    if not IsInToolsMode() then
        return
    end
    if not ID or not name then
        return
    end
    if Skill and Skill.ToolsLearnSkillBookCyclic then
        Skill:ToolsLearnSkillBookCyclic(ID, name)
    end
end
