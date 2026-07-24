--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 英雄 index → 战斗类型键 btp1～btp4（未命中时默认物理）
function SelectHero:GetBattleTypeKeyForHeroIndex(index)
    if not index then
        return "btp2"
    end
    for btp_key, tab in pairs(self.BattleType) do
        if tab then
            for _, v in ipairs(tab) do
                if v == index then
                    return btp_key
                end
            end
        end
    end
    return "btp2"
end

-- 推荐肉搏技能 ability 名列表：ability_item_ + RMBList 中的索引
function SelectHero:GetRMBAbilityListForHeroIndex(index)
    local key = self:GetBattleTypeKeyForHeroIndex(index)
    local nums = self.RMBList[key]
    local out = {}
    if nums then
        for _, n in ipairs(nums) do
            out[#out + 1] = "ability_item_" .. tostring(n)
        end
    end
    return out
end

-- 人机肉搏学习白名单（item_skill_* / item_skill_*_up），与 BattleType + RMBList 单一数据源一致
function SelectHero:GetMeleeLearnWhitelistForHeroIndex(index)
    local abilities = self:GetRMBAbilityListForHeroIndex(index)
    local wl = {}
    for _, ab in ipairs(abilities) do
        local idx = string.match(ab, "^ability_item_(%d+)$")
        if idx then
            wl["item_skill_" .. idx] = true
            wl["item_skill_" .. idx .. "_up"] = true
        end
    end
    return wl
end

function SelectHero:GetHeroName(index)
    if not index then
        return
    end
    for k, v in pairs(self.HeroList) do
        if index == v.index then
            return k
        end
    end
end

--- 全英雄自选：仅 Rareness rank_1 + rank_2 池内英雄可选
function SelectHero:EnsureRarenessPickableHeroSet()
    if self._rareness_pickable_set then
        return self._rareness_pickable_set
    end
    local set = {}
    local rareness = self.Rareness
    if rareness then
        for _, rank in pairs(rareness) do
            if type(rank) == "table" then
                for _, pool in pairs(rank) do
                    if type(pool) == "table" then
                        for _, idx in ipairs(pool) do
                            local n = tonumber(idx)
                            if n then
                                set[n] = true
                            end
                        end
                    end
                end
            end
        end
    end
    self._rareness_pickable_set = set
    return set
end

function SelectHero:IsHeroPickableInRareness(index)
    if not index then
        return false
    end
    local n = tonumber(index)
    if not n then
        return false
    end
    return self:EnsureRarenessPickableHeroSet()[n] == true
end

function SelectHero:GetHeroAbList(index)
    if not index then
        return
    end
    local heroname = SelectHero:GetHeroName(index)
    local ab_list = {
        slot_1 = "",
        slot_2 = "",
        slot_3 = "",
        slot_4 = "",
    }
    local num = 1
    for k, v in pairs(Skill.Ability) do
        -- 选人面板技能图标：最多 4 个（与 Panorama slot_1～4 一致）
        if num <= 4 and heroname == v.hero then
            local num_key = "slot_" .. num
            local ab_name = v.name
            ab_list[num_key] = ab_name
            num = num + 1
        end
    end
    return ab_list
end

--- 英雄 index → 力量/敏捷/智力/全才（1/2/3/4），与 HeroType、图鉴 Book.HeroList 一致
function SelectHero:EnsureHeroAttrTypeMap()
    if self._hero_attr_type_map then
        return self._hero_attr_type_map
    end
    local map = {}
    local ht = self.HeroType
    if ht then
        for _, i in ipairs(ht.tp1 or {}) do
            map[i] = 1
        end
        for _, i in ipairs(ht.tp2 or {}) do
            map[i] = 2
        end
        for _, i in ipairs(ht.tp3 or {}) do
            map[i] = 3
        end
        for _, i in ipairs(ht.tp4 or {}) do
            map[i] = 4
        end
    end
    if Book and Book.HeroList then
        for tp_key, slots in pairs(Book.HeroList) do
            local tp_num = tonumber(string.match(tostring(tp_key), "^tp(%d)$"))
            if tp_num and tp_num >= 1 and tp_num <= 4 then
                for _, hero_name in pairs(slots) do
                    if type(hero_name) == "string" then
                        for name, def in pairs(self.HeroList) do
                            if name == hero_name and type(def.index) == "number" then
                                map[def.index] = tp_num
                            end
                        end
                    end
                end
            end
        end
    end
    self._hero_attr_type_map = map
    return map
end

function SelectHero:GetHeroAttrTypeByIndex(index, def)
    local idx = tonumber(index)
    if not idx then
        return 1
    end
    local map = self:EnsureHeroAttrTypeMap()
    local tp = map[idx]
    if tp then
        return tp
    end
    if def and type(def.tp) == "number" then
        return def.tp
    end
    return 1
end

function SelectHero:IsTalentHidden(talent_index)
    local t = tonumber(talent_index)
    if not t then
        return false
    end
    return self.HiddenTalentIndices and self.HiddenTalentIndices[t] == true
end

function SelectHero:SanitizeTalentIndex(talent_index)
    local t = tonumber(talent_index) or (self.DefaultTalentIndex or 1)
    if t < 1 then
        t = 1
    end
    if t > 9 then
        t = 9
    end
    if self:IsTalentHidden(t) then
        t = self.DefaultTalentIndex or 1
    end
    return t
end

function SelectHero:RandomVisibleTalentIndex()
    local hidden = self.HiddenTalentIndices or {}
    local candidates = {}
    for i = 1, 9 do
        if not hidden[i] then
            candidates[#candidates + 1] = i
        end
    end
    if #candidates == 0 then
        return self.DefaultTalentIndex or 1
    end
    return candidates[math.random(1, #candidates)]
end

function SelectHero:GetHiddenTalentIndicesList()
    local out = {}
    local hidden = self.HiddenTalentIndices or {}
    for i = 1, 9 do
        if hidden[i] then
            out[#out + 1] = i
        end
    end
    return out
end

function SelectHero:IsTalentHidden(talent_index)
    local t = tonumber(talent_index)
    if not t then
        return false
    end
    return self.HiddenTalentIndices and self.HiddenTalentIndices[t] == true
end

function SelectHero:SanitizeTalentIndex(talent_index)
    local t = tonumber(talent_index) or (self.DefaultTalentIndex or 1)
    if t < 1 then
        t = 1
    end
    if t > 9 then
        t = 9
    end
    if self:IsTalentHidden(t) then
        t = self.DefaultTalentIndex or 1
    end
    return t
end

function SelectHero:RandomVisibleTalentIndex()
    local hidden = self.HiddenTalentIndices or {}
    local candidates = {}
    for i = 1, 9 do
        if not hidden[i] then
            candidates[#candidates + 1] = i
        end
    end
    if #candidates == 0 then
        return self.DefaultTalentIndex or 1
    end
    return candidates[math.random(1, #candidates)]
end

function SelectHero:GetHiddenTalentIndicesList()
    local out = {}
    local hidden = self.HiddenTalentIndices or {}
    for i = 1, 9 do
        if hidden[i] then
            out[#out + 1] = i
        end
    end
    return out
end
