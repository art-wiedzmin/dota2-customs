--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Pet:GetPick(ID)
    return self.Data[ID].pick
end

--- 改键/宠物设置里点亮的肉搏物品（Item.Rb 及对应 *_up 进阶书）也允许宠物拾取
--- 已删除该肉搏技、或已将该名肉搏书卖店时，不再拾取对应书（学回/商店新购会清禁）
function Pet:IsMeleeBookBannedAfterDelete(ID, item_name)
    if not ID or not item_name then
        return false
    end
    if not Skill or not Skill.Data or not Skill.Data[ID] then
        return false
    end
    local t = Skill.Data[ID].melee_pet_ban
    if not t or not t[item_name] then
        return false
    end
    return true
end

function Pet:IsKeySetPetPickupEnabled(ID, item_name)
    if not ID or not item_name then
        return false
    end
    if not KeySet or not KeySet.Data[ID] or not KeySet.Data[ID].pet then
        return false
    end
    local pet = KeySet.Data[ID].pet
    if pet[item_name] == true then
        return true
    end
    local base = string.match(item_name, "^(item_skill_%d+)_up$")
    if base and pet[base] == true then
        return true
    end
    return false
end

--- 已学会对应强化版肉搏技（ability_item_N_up）时，基础 item_skill_N 无意义，宠物不应去捡
function Pet:ShouldBlockPetMeleeBaseBookWhenHasUpVersion(ID, item_name)
    if not ID or not item_name then
        return false
    end
    local idx = string.match(item_name, "^item_skill_(%d+)$")
    if not idx then
        return false
    end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return false
    end
    if hero:HasAbility("ability_item_" .. idx .. "_up") then
        return true
    end
    return false
end

function Pet:IsHaveRb(ID, item_name)
    if not ID or not item_name then
        return
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return
    end
    self.Data[ID].pick_list = {}
    for k, v in pairs(Skill.Data[ID].Skill2) do
        if v.state then
            local name = v.name
            if hero:HasAbility(name) then
                -- print("拥有技能" .. name)
                local ab = hero:FindAbilityByName(name)
                local level = ab:GetLevel()
                -- print("技能等级" .. level)
                if level < 10 then
                    -- print("技能等级小于10")
                    local index = tonumber(utilex:splitIndex(name, "_", 3))
                    if not index then
                        -- skip
                    else
                        -- 强化版槽位为 ability_item_N_up，拾取目标应为 item_skill_N_up
                        local skill_name = (utilex:splitIndex(name, "_", 4) == "up")
                            and ("item_skill_" .. index .. "_up")
                            or ("item_skill_" .. index)
                        table.insert(Pet.Data[ID].pick_list, skill_name)
                    end
                end
            end
        end
    end
    for k, v in pairs(self.Data[ID].pick_list) do
        if item_name == v then
            return true
        end
    end
end

-- 宠物拾取时：仅当英雄已拥有对应肉搏技能（升级书 / 进阶书）才自动消耗书本，逻辑与手动 UseSkill 一致
function Pet:CanPetAutoConsumeMeleeSkillBook(ID, item_name)
    if not ID or not item_name then
        return false
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return false
    end
    local parts = utilex:split(item_name, "_")
    if parts[1] ~= "item" or parts[2] ~= "skill" then
        return false
    end
    local idx = tonumber(parts[3])
    if not idx then
        return false
    end
    local base = "ability_item_" .. idx
    if parts[4] == "up" then
        if not hero:HasAbility(base) then
            return false
        end
        local ab = hero:FindAbilityByName(base)
        return ab and ab:GetLevel() == 10
    end
    if #parts ~= 3 then
        return false
    end
    if not hero:HasAbility(base) then
        return false
    end
    local ab = hero:FindAbilityByName(base)
    if not ab or ab:GetLevel() >= 10 then
        return false
    end
    -- 与 Skill:AddSkill2 一致：当前技能等级已达/超过英雄等级时不能升级，书本应进背包而非自动消耗
    if hero:GetLevel() <= ab:GetLevel() then
        return false
    end
    return true
end

local MELEE_SKILL_BOOK_MAX_LEVEL = 10

local function pet_ability_melee_at_max_level(hero, ab_name)
    if not hero or not ab_name then
        return false
    end
    if not hero:HasAbility(ab_name) then
        return false
    end
    local ab = hero:FindAbilityByName(ab_name)
    if not ab or ab:IsNull() then
        return false
    end
    local lv = ab:GetLevel()
    local max_lv = ab.GetMaxLevel and ab:GetMaxLevel() or 0
    if max_lv and max_lv > 0 then
        return lv >= max_lv
    end
    return lv >= MELEE_SKILL_BOOK_MAX_LEVEL
end

--- 肉搏技能书：对应 ability已满级（基础书→ability_item_N；进阶书→ability_item_N_up）
function Pet:IsMeleeSkillBookSkillMaxed(ID, item_name)
    if not ID or not item_name then
        return false
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return false
    end
    local parts = utilex:split(item_name, "_")
    if parts[1] ~= "item" or parts[2] ~= "skill" then
        return false
    end
    local idx = tonumber(parts[3])
    if not idx then
        return false
    end
    if parts[4] == "up" then
        return pet_ability_melee_at_max_level(hero, "ability_item_" .. idx .. "_up")
    end
    if #parts ~= 3 then
        return false
    end
    return pet_ability_melee_at_max_level(hero, "ability_item_" .. idx)
end

function Pet:TryAutoConsumeMeleeSkillBookOnPetPickup(ID, item, item_name)
    if not ID or not item or not item_name then
        return false
    end
    if self:IsMeleeSkillBookSkillMaxed(ID, item_name) then
        return false
    end
    if not self:CanPetAutoConsumeMeleeSkillBook(ID, item_name) then
        return false
    end
    if not Skill:AddSkill2(ID, item_name) then
        return false
    end
    local hero = Util:ID2Hero(ID)
    if not hero then
        return false
    end
    if item:GetCurrentCharges() > 1 then
        item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        hero:AddItem(item)
    else
        UTIL_Remove(item)
    end
    return true
end
