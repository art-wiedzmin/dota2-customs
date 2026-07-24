--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--技能是否在列表中
function Skill:IsInList(ID, id)
    for k, v in pairs(self.Data[ID].list) do
        if v.skill == id then
            return true
        end
    end
end

--技能是否在公共池子中
function Skill:IsInPublic(id)
    for k, v in pairs(self.Public) do
        if v and v == id then
            return true
        end
    end
end

--是否有该技能
function Skill:IsHaveAb(ID, id)
    local data = self:GetSkillData(id)
    if data then
        local ab_name = data.name
        local hero = Util:ID2Hero(ID)
        if hero and hero:HasAbility(ab_name) then
            return true
        end
    end
end

--获取技能信息
function Skill:GetSkillData(id)
    if not id then
        return
    end
    local skill_key = "skill_" .. id
    return Skill.Ability[skill_key]
end

function Skill:Skill2IsFull(ID)
    if not ID then
        return
    end
    for k, v in pairs(self.Data[ID].Skill2) do
        if v.state == false then
            return false
        end
    end
    Util:BottomMsg2ID(ID, "技能栏已满", "red", 1)
    return true
end

function Skill:GetSkillID(name)
    for k, v in pairs(Skill.Ability) do
        if name == v.name then
            return v.id
        end
    end
    
end

--是否是空技能（Skill1 的 1–4 + Skill2 肉搏槽 5–10 占位）
function Skill:IsNullSkill(ab_name)
    if not ab_name then
        return false
    end
    return string.match(ab_name, "^ability_null_%d+$") ~= nil
end

--- 肉搏技能（Skill2 槽位 5–10，含 _up 进阶版）
function Skill:IsMeleeBrawlSkill(ab_name)
    if not ab_name then
        return false
    end
    return string.match(ab_name, "^ability_item_%d+") ~= nil
end

function Skill:IsSkill(ab_name)
    for k, v in pairs(Skill.Ability) do
        if ab_name == v.name then
            return true
        end
    end
end

function Skill:GetAbSkillName(ab_name)
    for k, v in pairs(self.Ability) do
        if v and v.name == ab_name then
            return k
        end
    end
end

function Skill:IsSkill36Filter(name)
    if not name or name == "" then
        return false
    end
    local list = self.Skill36Filter
    if not list then
        return false
    end
    for _, v in pairs(list) do
        if v == name then
            return true
        end
    end
    return false
end

function Skill:IsRangedAttacker(name)
    if not name then
        return false
    end
    for k, v in pairs(self.RangedAttacker) do
        if v == name then
            return true
        end
    end
    return false
end
