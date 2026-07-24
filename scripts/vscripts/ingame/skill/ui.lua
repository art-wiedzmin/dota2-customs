--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Skill:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    --暂停禁止传数据
    if GameRules:IsGamePaused() then
        return
    end
    --初始化数据
    if data.tp == "init" then
        self:SendData(ID)
        Skill:SendDelData(ID)
        Skill:SendSlotData(ID)
        Skill:OpenChangeImg(ID)
    end
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    if data.tp == "CloseDelPage" then
        self:CloseDelPage(ID)
    end
    --选择技能
    if data.tp == "SelectSkill" then
        self:SelectSkill(ID, data.slot1, data.slot2)
    end
    --删除技能
    if data.tp == "DelSkill" then
        self:DelSkill(ID, data.text)
    end
    --修改技能槽位
    if data.tp == "ChangeSlot" then
        self:ChangeSlot(ID)
    end
    --选择修改槽位
    if data.tp == "SelectSlot" then
        self:SelectSlot(ID, data.text1, data.text2)
    end
    if data.tp == "CloseSlotPage" then
        self:CloseSlotPage(ID)
    end
end

--给前端发数据
function Skill:SendData(ID)
    if not ID then
        return
    end
    -- print(data)
    Util:Send2JsID("UI_Skill", self.Data[ID], ID)
end

--给前端发送数据
function Skill:SendDelData(ID)
    if not ID then
        return
    end
    local list = {
        page = self.Data[ID].del_page,
        skill = self.Data[ID].Skill2
    }
    Util:Send2JsID("UI_DelSkill", list, ID)
end

--给前端发送数据
function Skill:SendSlotData(ID)
    local hero = Util:ID2Hero(ID)
    if not hero then
        return
    end
    local list = {}
    for i = 0, 3 do
        local num = i + 1
        local slot = "slot_" .. num
        local index = i
        if i == 3 then
            index = 5
        end
        local ab_name = hero:GetAbilityByIndex(index):GetName()
        local ab_id = self:GetSkillID(ab_name)
        if ab_id then
            list[slot] = "skill_" .. ab_id
        else
            list[slot] = "ability_null_" .. num
        end
    end
    local data = {
        page = self.Data[ID].slot_page,
        list = list
    }
    Util:Send2JsID("UI_SlotSkill", data, ID)
end
