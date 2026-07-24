--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 天气 id：57 狂风 / 58 寒霜 / 59 雨露 / 60 艳阳
Box.WeatherIds = { 57, 58, 59, 60 }

function Box:IsWeatherGot(ID, item_id)
    if not ID or not item_id or not self.Data[ID] then return false end
    if self.Data[ID].weather_got and self.Data[ID].weather_got[item_id] then
        return true
    end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then return false end
    if item_id == 57 then return hero:HasModifier("modifier_weather_2") end
    if item_id == 58 then return hero:HasModifier("modifier_weather_4") end
    if item_id == 59 then return hero:HasModifier("modifier_weather_3") end
    if item_id == 60 then return hero:HasModifier("modifier_weather_1") end
    return false
end

function Box:HasAllWeathers(ID)
    for _, wid in ipairs(self.WeatherIds) do
        if not self:IsWeatherGot(ID, wid) then
            return false
        end
    end
    return true
end

function Box:HasWeatherPity(ID)
    if not ID or not self.Data[ID] then return false end
    if self:HasAllWeathers(ID) then
        self.Data[ID].weather_pity = false
        return false
    end
    if self.Data[ID].weather_pity then
        return true
    end
    -- 兼容：已有狂风但未记 flag
    return self:IsWeatherGot(ID, 57)
end

-- 当前应按顺序保底的下一件天气 z_key（狂风→寒霜→雨露→艳阳）
function Box:GetNextWeatherPityKey(ID, box_key)
    if not ID or not box_key or not self.Data[ID] or not self.Data[ID][box_key] then
        return nil
    end
    local pool = self.Data[ID][box_key]
    for _, wid in ipairs(self.WeatherIds) do
        if not self:IsWeatherGot(ID, wid) then
            local z_key = "z_" .. wid
            -- 顺序解锁：仅放开当前这一件
            if pool[z_key] == false then
                self:UnLock(ID, wid)
            end
            if pool[z_key] == true and not self:IsInBag(ID, z_key) then
                return z_key
            end
            -- 池中无此键（如 DelItem 后）则跳过找下一件
        end
    end
    return nil
end

-- 本轮宝箱锁定全部天气（已放入的那一件也不会再被摇第二次）
function Box:LockAllWeathers(ID)
    for _, wid in ipairs(self.WeatherIds) do
        self:Lock(ID, wid)
    end
end

-- roll宝箱
function Box:RollBox(ID)
    -- 清理宝箱内容
    self:ClearBox(ID)
    -- 抽取次数+1
    self.Data[ID].box_draw_num = self.Data[ID].box_draw_num + 1
    -- 高品质装备数量
    local hight_zb = 3
    -- 获取宝箱品质
    local box_key = self:GetBoxType(ID)
    -- print("箱子品质")
    -- print(box_key)
    -- roll宝箱十二件物品
    local roll_count = self.Static.box_slot_num
    -- 锁定天气效果
    local hero = Util:ID2Hero(ID)
    if hero then
        if hero:HasModifier("modifier_weather_1") then self:Lock(ID, 60) end
        if hero:HasModifier("modifier_weather_2") then self:Lock(ID, 57) end
        if hero:HasModifier("modifier_weather_3") then self:Lock(ID, 59) end
        if hero:HasModifier("modifier_weather_4") then self:Lock(ID, 58) end
    end
    -- 已记录获得的天气也锁定（人机无 modifier）
    if self.Data[ID].weather_got then
        for wid, got in pairs(self.Data[ID].weather_got) do
            if got then self:Lock(ID, wid) end
        end
    end
    -- 获取物品栏物品
    for k, v in pairs(self.Data[ID].bag) do
        if v ~= -1 then
            local item_key = "item_box_" .. v
            local item_data = self.Item[item_key]
            -- 锁定装备栏中的高级物品的配方必定不会出现
            if item_data.son then
                for i, j in pairs(item_data.son_list) do
                    local son_z_key = "z_" .. j
                    self:Lock(ID, son_z_key)
                end
            end
            -- 装备栏中的高级物品必定出现
            if item_data.fa == true then
                local high_item = item_data.fa_list
                local z_key = "z_" .. high_item
                if self.Data[ID][box_key][z_key] == true then
                    if self:IsHighZbInBox(box_key, z_key) then
                        hight_zb = hight_zb - 1
                    end
                    self:AddItemToBox(ID, z_key)
                    roll_count = roll_count - 1
                end
            end
            -- 背包中物品必定不会出现
            self:Lock(ID, v)
        end
    end
    -- 背包里已有夜叉/散华/慧光之一时，本池不能再摇出另外两件（仅靠 IsInBag 只挡当前 id）
    for _k, v in pairs(self.Data[ID].bag) do
        if v == 1 or v == 2 or v == 3 then
            self:LockYashaSangeKayaGroup(ID)
            break
        end
    end
    for _k, v in pairs(self.Data[ID].bag) do
        if v == 22 or v == 23 then
            self:LockDualOrbPairGroup(ID)
            break
        end
    end
    -- 狂风保底：后续每箱按顺序强制塞入下一件天气（寒霜→雨露→艳阳）；本轮只允许一种
    if self:HasWeatherPity(ID) then
        local pick = self:GetNextWeatherPityKey(ID, box_key)
        if pick then
            if self:IsHighZbInBox(box_key, pick) and hight_zb > 0 then
                hight_zb = hight_zb - 1
            end
            self:AddItemToBox(ID, pick)
            roll_count = roll_count - 1
        end
        -- 锁掉其余天气，避免同一次抽取出现多个天气
        self:LockAllWeathers(ID)
    end
    for i = 1, roll_count do
        local num = 0
        local flag = false
        repeat
            local item_key = utilex:TabTrueKey(self.Data[ID][box_key])
            -- 不能在背包中
            if not self:IsInBag(ID, item_key) then
                -- 是否是高阶装备，并且有剩余高阶装备的格子
                if self:IsHighZbInBox(box_key, item_key) then
                    -- 如果是高阶装备
                    if hight_zb > 0 then
                        self:AddItemToBox(ID, item_key)
                        hight_zb = hight_zb - 1
                        flag = true
                    end
                else
                    self:AddItemToBox(ID, item_key)
                    flag = true
                end
            end
            num = num + 1
            if num > 100 then
                -- 后期池子小、锁定多时容易 100 次都摇不到符合规则的，导致空槽；兜底：从当前池任选一个可用的填入
                local fallback_key = self:GetOneAvailableBoxKey(ID, box_key)
                if fallback_key then
                    self:AddItemToBox(ID, fallback_key)
                end
                flag = true
            end
        until flag
    end
    -- 根据宝箱内容分类
    for k, v in pairs(self.Data[ID].list) do
        for i, j in pairs(self.Roll[box_key].weight_1) do
            if v.item == j then
                local item_key = "z_" .. j
                local slot = "slot_" .. v.id
                self.Data[ID].weight_1[slot] = {
                    id = v.id,
                    item_key = item_key,
                    state = true
                }
            end
        end
    end
    for k, v in pairs(self.Data[ID].list) do
        for i, j in pairs(self.Roll[box_key].weight_2) do
            if v.item == j then
                local item_key = "z_" .. j
                local slot = "slot_" .. v.id
                self.Data[ID].weight_2[slot] = {
                    id = v.id,
                    item_key = item_key,
                    state = true
                }
            end
        end
    end
end

-- 夜叉(1)/散华(2)/慧光(3) 三选一：任一进入备选栏或已在背包时，池内三者同锁
function Box:LockYashaSangeKayaGroup(ID)
    self:Lock(ID, 1)
    self:Lock(ID, 2)
    self:Lock(ID, 3)
end

-- 散夜对剑/慧夜对剑等(22/23) 二选一，与 AddItemToBag 逻辑一致
function Box:LockDualOrbPairGroup(ID)
    self:Lock(ID, 22)
    self:Lock(ID, 23)
end

-- 添加物品到备选栏（同一道具不重复出现）
function Box:AddItemToBox(ID, item)
    if not ID or not item then return end
    local item_id = tonumber(utilex:splitIndex(item, "_", 2))
    -- 防止重复：若该道具已在备选栏中，只锁定不再占新格子
    for k, v in pairs(self.Data[ID].list) do
        if v.item == item_id then
            self:Lock(ID, item)
            if item_id == 1 or item_id == 2 or item_id == 3 then
                self:LockYashaSangeKayaGroup(ID)
            end
            if item_id == 22 or item_id == 23 then
                self:LockDualOrbPairGroup(ID)
            end
            return
        end
    end
    for k, v in pairs(self.Data[ID].list) do
        if v.item == -1 then
            self.Data[ID].list[k].item = item_id
            self:Lock(ID, item)
            -- 必须在 RollBox 阶段就互斥，不能只写在 AddItemToBag（否则同一轮 12 格会出多件）
            if item_id == 1 or item_id == 2 or item_id == 3 then
                self:LockYashaSangeKayaGroup(ID)
            end
            if item_id == 22 or item_id == 23 then
                self:LockDualOrbPairGroup(ID)
            end
            return
        end
    end
end

-- 使用消耗品
function Box:UseItem(ID, item_id)
    if not ID or not item_id then return end
    if item_id == 0 then Item:AddItem(ID, "item_goods_14") end
    if item_id == 61 then Item:AddItem(ID, "item_goods_15") end
    if item_id == 62 then
        Item:AddItem(ID, "item_goods_16")
        Box:DelItem(ID, item_id)
    end
    -- 粉碎之心
    if item_id == 54 then
        self.Data[ID].skill.item_54 = true
        Box:DelItem(ID, item_id)
        Item:AddItem(ID, "item_skill_14_up")
    end
    if item_id == 55 then
        self.Data[ID].skill.item_55 = true
        Box:DelItem(ID, item_id)
        Item:AddItem(ID, "item_skill_20_up")
    end
    if item_id == 56 then
        self.Data[ID].skill.item_56 = true
        Box:DelItem(ID, item_id)
        Item:AddItem(ID, "item_skill_24_up")
    end
    if item_id == 92 then
        self.Data[ID].skill.item_92 = true
        Box:DelItem(ID, item_id)
        Item:AddItem(ID, "item_skill_27_up")
    end
    if item_id == 57 or item_id == 58 or item_id == 59 or item_id == 60 then
        if not self.Data[ID].weather_got then
            self.Data[ID].weather_got = {}
        end
        self.Data[ID].weather_got[item_id] = true
    end
    -- 抽到狂风后开启保底，并按顺序只解锁下一件（寒霜→雨露→艳阳）
    if item_id == 57 then
        self.Data[ID].weather_pity = true
        self:UnLock(ID, 58)
    end
    if item_id == 58 then self:UnLock(ID, 59) end
    if item_id == 59 then self:UnLock(ID, 60) end
    if self:HasAllWeathers(ID) then
        self.Data[ID].weather_pity = false
    end
    if item_id == 57 or item_id == 58 or item_id == 59 or item_id == 60 then
        self:Lock(ID, item_id)
        Box:DelItem(ID, item_id)
        local hero = Util:ID2Hero(ID)
        -- 人机仅消耗宝箱解锁进度，不获得天气类 modifier
        if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
            return
        end
        if hero then
            LinkLuaModifier("modifier_weather_1",
                "ingame/modifier/modifier_weather_1",
                LUA_MODIFIER_MOTION_NONE)
            LinkLuaModifier("modifier_weather_2",
                "ingame/modifier/modifier_weather_2",
                LUA_MODIFIER_MOTION_NONE)
            LinkLuaModifier("modifier_weather_3",
                "ingame/modifier/modifier_weather_3",
                LUA_MODIFIER_MOTION_NONE)
            LinkLuaModifier("modifier_weather_4",
                "ingame/modifier/modifier_weather_4",
                LUA_MODIFIER_MOTION_NONE)
            local buff_name = ""
            if item_id == 57 then buff_name = "modifier_weather_2" end
            if item_id == 58 then buff_name = "modifier_weather_4" end
            if item_id == 59 then buff_name = "modifier_weather_3" end
            if item_id == 60 then buff_name = "modifier_weather_1" end
            if buff_name == "" then return end
            local function apply_box_weather_modifiers()
                if not hero or hero:IsNull() then
                    return
                end
                if not hero:HasModifier(buff_name) then
                    hero:AddNewModifier(hero, nil, buff_name, { dur = 999999 })
                end
                if hero:HasModifier("modifier_weather_1") and hero:HasModifier("modifier_weather_2") and
                    hero:HasModifier("modifier_weather_3") and hero:HasModifier("modifier_weather_4") and
                    not hero:HasModifier("modifier_weather_5") then
                    LinkLuaModifier("modifier_weather_5", "ingame/modifier/modifier_weather_5",
                        LUA_MODIFIER_MOTION_NONE)
                    hero:AddNewModifier(hero, nil, "modifier_weather_5", { dur = 999999 })
                end
            end
            if hero:IsAlive() then
                apply_box_weather_modifiers()
            elseif Timers then
                Timers(0, function()
                    if not hero or hero:IsNull() then
                        return
                    end
                    if not hero:IsAlive() then
                        return 0.25
                    end
                    apply_box_weather_modifiers()
                end)
            else
                apply_box_weather_modifiers()
            end
        end
    end
end

-- 添加物品到背包
function Box:AddItemToBag(ID, item_id)
    if not ID or not item_id then return end
    if self:IsInBag(ID, item_id) then
        return
    end
    -- Shop:SyncGold(ID)
    -- 锁上该物品
    self:Lock(ID, item_id)
    -- 获取高级物品时移除低级物品
    local item_key = "item_box_" .. item_id
    local item_data = Box.Item[item_key]
    -- 如果是散华/夜叉/慧光（与 AddItemToBox 共用互斥）
    if item_id == 1 or item_id == 2 or item_id == 3 then
        self:LockYashaSangeKayaGroup(ID)
    end
    if item_id == 22 or item_id == 23 then
        self:LockDualOrbPairGroup(ID)
    end
    if item_data.son then
        for k, v in pairs(item_data.son_list) do
            if v then
                local item_z = "z_" .. v
                -- 如果子物品在背包中就移除
                if self:IsInBag(ID, item_z) then
                    -- 移除背包中子件
                    self:RemoveItem(ID, v)
                    self:RemoveBuff(ID, v)
                end
            end
        end
    end
    -- 如果有父高级物品就解锁
    if item_data.fa_list and type(item_data.fa_list) == "number" then
        self:UnLock(ID, item_data.fa_list)
    end
    for i = 1, 6 do
        local slot = "slot_" .. i
        if self.Data[ID].bag[slot] == -1 then
            self.Data[ID].bag[slot] = item_id
            -- 添加物品效果
            self:AddItemBuff(ID, item_id)
            return
        end
    end
end

function Box:AddItemBuff(ID, item_id)
    if not ID or not item_id then return end
    local hero = HeroData:GetHero(ID)
    if not hero or hero:IsNull() then hero = Util:ID2Hero(ID) end
    if not hero or hero:IsNull() then return end
    if item_id == 24 and hero:GetUnitName() == "npc_dota_hero_medusa" then
        hero:ModifyStrength(10)
        return
    end
    if item_id == 11 then hero:ModifyAgility(6) end
    if item_id == 27 then utilex:AddModifier(hero, "modifier_box_27") end
    if item_id == 28 then
        HeroData:AddSX(ID, "gjsd", 45)
        utilex:AddModifier(hero, "modifier_box_27")
        return
    end

    if item_id == 36 then HeroData:AddSX(ID, "jcys", 40) end
    if item_id == 42 then
        LinkLuaModifier("modifier_mfxhjs", "ingame/modifier/modifier_mfxhjs",
            LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_mfxhjs", {})
    end
    if item_id == 47 then
        utilex:AddModifier(hero, "modifier_box_47")
        return
    end
    if item_id == 4 then
        HeroData:AddSX(ID, "gjsd", 20)
        HeroData:AddSX(ID, "gjjl", 100)
    end
    if item_id == 48 then HeroData:AddSX(ID, "jcgj", 100) end
    if item_id == 43 then
        HeroData:AddSX(ID, "jcgj", 350)
        HeroData:AddSX(ID, "jnzq", 25)
    end
    local ab_data = self:GetItemData(item_id)
    local buff = ab_data.buff
    if not buff or buff == "" then
        return
    end
    local dummy = self:GetDummy(ID)
    local item_name = buff
    local item = CreateItem(item_name, nil, nil)
    -- 踏云靴：死亡期间对英雄 AddNewModifier 移速不生效，须复活后再挂载（飞行 terrain 同理）
    if item_id == 91 then
        if dummy and not dummy:IsNull() then
            dummy:AddItem(item)
        end
        local buff_name = "modifier_item_equip_4_buff"
        local function apply_tyx_box_effects()
            if not hero or hero:IsNull() or not hero:IsAlive() then
                return false
            end
            if not dummy or dummy:IsNull() then
                return false
            end
            hero:RemoveModifierByName(buff_name)
            hero:AddNewModifier(dummy, item, buff_name, {})
            hero:RemoveModifierByName("modifier_clrb_tyx_terrain")
            hero:AddNewModifier(hero, nil, "modifier_clrb_tyx_terrain", {})
            hero:CalculateStatBonus(true)
            return true
        end
        if apply_tyx_box_effects() then
            return
        end
        if Timers then
            Timers(0, function()
                if not hero or hero:IsNull() then
                    return
                end
                if apply_tyx_box_effects() then
                    return
                end
                if hero:IsAlive() then
                    return
                end
                return 0.25
            end)
        end
        return
    end
    if self:IsNoDummy(item_id) then
        if ab_data.diff then item_name = ab_data.item_name end
        local buff_name = "modifier_" .. item_name
        hero:AddNewModifier(hero, item, buff_name, {})
    else
        dummy:AddItem(item)
        if ab_data.diff then item_name = ab_data.item_name end
        local buff_name = "modifier_" .. item_name
        hero:AddNewModifier(dummy, item, buff_name, {})
        if buff == "item_trident" then
            hero:RemoveModifierByName("modifier_clrb_item_trident_cast_speed")
            hero:AddNewModifier(hero, nil, "modifier_clrb_item_trident_cast_speed", {})
        end
    end
end

function Box:RemoveBuff(ID, item_id)
    local hero = HeroData:GetHero(ID)
    if not hero or hero:IsNull() then hero = Util:ID2Hero(ID) end
    if not hero or hero:IsNull() then return end
    self:UnLock(ID, item_id)
    if item_id == 91 then
        hero:RemoveModifierByName("modifier_clrb_tyx_terrain")
    end
    if item_id == 24 and hero:GetUnitName() == "npc_dota_hero_medusa" then
        hero:ModifyStrength(-10)
        return
    end
    if item_id == 4 then
        HeroData:AddSX(ID, "gjsd", -20)
        HeroData:AddSX(ID, "gjjl", -100)
    end
    if item_id == 11 then hero:ModifyAgility(-6) end
    if item_id == 27 then
        if hero:HasModifier("modifier_box_27") then
            hero:RemoveModifierByName("modifier_box_27")
        end
    end
    if item_id == 42 then hero:RemoveModifierByName("modifier_mfxhjs") end
    if item_id == 47 then
        hero:RemoveModifierByName("modifier_box_47")
        return
    end
    if item_id == 48 then HeroData:AddSX(ID, "jcgj", -100) end
    if item_id == 43 then
        HeroData:AddSX(ID, "jcgj", -350)
        HeroData:AddSX(ID, "jnzq", -25)
    end
    local ab_data = self:GetItemData(item_id)
    local dummy = self:GetDummy(ID)
    local buff = ab_data.buff
    local item_name = buff
    if self:IsNoDummy(item_id) then
        -- 与 AddItemBuff 一致：diff 时 modifier 名用 item_name 而非 buff（如远行鞋 modifier_item_boots_of_travel）
        if ab_data.diff then item_name = ab_data.item_name end
        local buff_name = "modifier_" .. item_name
        if hero:HasModifier(buff_name) then hero:RemoveModifierByName(buff_name) end
    else
        local item = dummy:FindItemInInventory(item_name)
        dummy:RemoveItem(item)
        if ab_data.diff then item_name = ab_data.item_name end
        local buff_name = "modifier_" .. item_name
        if hero:HasModifier(buff_name) then hero:RemoveModifierByName(buff_name) end
        if buff == "item_trident" then
            hero:RemoveModifierByName("modifier_clrb_item_trident_cast_speed")
        end
    end
end
