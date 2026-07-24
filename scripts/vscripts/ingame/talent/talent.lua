--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Talent == nil then
    Talent = class({})
    require("ingame.Talent.Config")
    require("ingame.Talent.Set")
    require("ingame.Talent.Get")
    require("ingame.Talent.Func")
    require("ingame.Talent.Ui")
end

local CLRB_TEAM_NEUTRALS = rawget(_G, "DOTA_TEAM_NEUTRALS") or 4

--- 天赋 8「猎人」：仅中立营地野怪（非兵线/建筑）
local function clrb_hunter_kill_victim_is_neutral(victim)
    if not victim or victim:IsNull() then
        return false
    end
    if type(victim.GetTeamNumber) ~= "function" then
        return false
    end
    if type(victim.IsHero) == "function" and victim:IsHero() then
        return false
    end
    return victim:GetTeamNumber() == CLRB_TEAM_NEUTRALS
end

function Talent:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    local need0 = self.Static.up_0
    if ClrbTalentGetEquipUpgradeKillsRequired then
        need0 = ClrbTalentGetEquipUpgradeKillsRequired(ID, 0)
    end
    self.Data[ID].sy = need0
end

-- 添加先天装备
function Talent:AddTalentOnce(ID)
    if not ID then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    if self.Data[ID].Init == false then return end
    -- Item:AddItem(ID, "item_goods_0")
    self.Data[ID].Init = false
end

-- 选择装备
function Talent:SelectTalent(ID, num)
    if not ID or not num then return end
    if self.Data[ID].page == false then return end
    local item_name
    if num == 1 then item_name = "item_goods_17" end
    if num == 2 then item_name = "item_goods_18" end
    if num == 3 then item_name = "item_goods_19" end
    if num == 4 then item_name = "item_goods_24" end
    self.Data[ID].item_name = item_name
    self.Data[ID].bag_page = true
    -- local item = Item:AddItem(ID, item_name)

    -- self.Data[ID].item_index = item:GetEntityIndex()
    self.Data[ID].item_name = item_name
    self.Data[ID].equip_attr.text = item_name .. "_text"
    -- 根据装备添加属性
    Talent:AddEquipAttr(ID)

    --已选择天赋装备
    self.Data[ID].select_talent = true
    self:ClosePage(ID)
    Talent:Drap(ID)
    self:SendKillData(ID)
end

-- 根据当前装备等级获得属性
function Talent:AddEquipAttr(ID)
    local item_name = self.Data[ID].item_name
    local level = self.Data[ID].level
    local rank = "rank" .. level
    local attrs = self.Equip[item_name][rank]
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        self.Data[ID].pending_equip_attr = true
        return
    end
    -- 死亡期间 AddNewModifier 往往无效；标记复活后由 TryApplyPendingEquipAttr 再应用
    if not hero:IsAlive() then
        self.Data[ID].pending_equip_attr = true
        return
    end
    self.Data[ID].pending_equip_attr = false
    if ClrbTalentPlayerHasBlacksmith and ClrbTalentPlayerHasBlacksmith(ID) then
        self.Data[ID].clrb_blacksmith_catchup_done = true
    end
    for k, v in pairs(attrs) do
        if item_name == "item_goods_24" and (k == "jcll" or k == "jcmj" or k == "jczl") then
            -- 全属性由 modifier_talent_4 绿字提供
        else
            local val = v
            if ClrbTalentBlacksmithScaledEquipAttr then
                val = ClrbTalentBlacksmithScaledEquipAttr(ID, item_name, k, v)
            end
            HeroData:AddSX(ID, k, val)
        end
    end
    if item_name == "item_goods_19" and utilex and utilex.BaseZyfw then
        utilex:BaseZyfw(ID)
    end
    -- 添加buff
    local buff_name = ""
    if item_name == "item_goods_17" then buff_name = "modifier_talent_1" end
    if item_name == "item_goods_18" then buff_name = "modifier_talent_2" end
    if item_name == "item_goods_19" then buff_name = "modifier_talent_3" end
    if item_name == "item_goods_24" then buff_name = "modifier_talent_4" end
    LinkLuaModifier("modifier_talent_1", "ingame/modifier/modifier_talent_1",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_1_damage_amp_debuff",
        "ingame/modifier/modifier_talent_1_damage_amp_debuff", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_2", "ingame/modifier/modifier_talent_2",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_2_aura_debuff", "ingame/modifier/modifier_talent_2",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_3", "ingame/modifier/modifier_talent_3",
        LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_talent_4", "ingame/modifier/modifier_talent_4",
        LUA_MODIFIER_MOTION_NONE)
    local modifier = hero:FindModifierByName(buff_name)
    if modifier then
        -- 如果 modifier 已存在，刷新它
        modifier:ForceRefresh()
    else
        -- 如果不存在，添加新的
        hero:AddNewModifier(hero, -- 施法者
            nil,                  -- 技能
            buff_name,            -- 修饰器名称
            {}                    -- 参数
        )
    end
end

--- 局内改选「铁匠」后，为已升级的天赋装备等级补算基础属性 +30%（不含 wlct 等其它词条）
function Talent:ApplyBlacksmithEquipBonusCatchup(ID)
    if not ID or not self.Data or not self.Data[ID] then
        return
    end
    if not ClrbTalentPlayerHasBlacksmith or not ClrbTalentPlayerHasBlacksmith(ID) then
        return
    end
    if self.Data[ID].select_talent ~= true then
        return
    end
    if self.Data[ID].clrb_blacksmith_catchup_done == true then
        return
    end
    local item_name = self.Data[ID].item_name
    if not item_name or item_name == "" or not self.Equip[item_name] then
        return
    end
    local level = self.Data[ID].level or 0
    local extra = {}
    for lv = 0, level do
        local rank = "rank" .. lv
        local attrs = self.Equip[item_name][rank]
        if attrs then
            for k, v in pairs(attrs) do
                if item_name == "item_goods_24" and (k == "jcll" or k == "jcmj" or k == "jczl") then
                    -- 绿字全属性不走 HeroData 白字
                else
                    local scaled = v
                    if ClrbTalentBlacksmithScaledEquipAttr then
                        scaled = ClrbTalentBlacksmithScaledEquipAttr(ID, item_name, k, v)
                    end
                    local delta = scaled - v
                    if delta > 0 then
                        extra[k] = (extra[k] or 0) + delta
                    end
                end
            end
        end
    end
    for k, delta in pairs(extra) do
        HeroData:AddSX(ID, k, delta)
    end
    self.Data[ID].clrb_blacksmith_catchup_done = true
    local hero = Util:ID2Hero(ID)
    if hero and not hero:IsNull() then
        hero:CalculateStatBonus(true)
        if item_name == "item_goods_24" then
            local m4 = hero:FindModifierByName("modifier_talent_4")
            if m4 then
                m4:ForceRefresh()
            end
        end
    end
end

--- 英雄已出生后：若选装早于出生，补应用装备属性与 talent modifier
function Talent:TryApplyPendingEquipAttr(ID)
    if not ID or not self.Data or not self.Data[ID] then return end
    if self.Data[ID].pending_equip_attr ~= true then return end
    if self.Data[ID].select_talent ~= true then return end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then return end
    if not hero:IsAlive() then return end
    self:AddEquipAttr(ID)
end

-- 获得当前装备属性

-- 物品拖动
function Talent:Drap(ID)
    if not ID then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    Timers(0.02, function()
        for i = 0, 5 do
            local item = hero:GetItemInSlot(i)
            if item then
                local item_index = item:GetEntityIndex()
                if item_index == self.Data[ID].item_index then
                    -- print(i)
                    self:SendBagData(ID, i)
                    return
                end
            end
        end
    end)
end

-- 击杀怪物（victim 可选：用于天赋 8 仅统计中立野怪）
function Talent:Kill(ID, victim)
    if not ID then return end
    if not self.Data[ID] then return end

    if ClrbGetTalentIndexForHero == nil then
        require("ingame.modifier.modifier_clrb_talents")
    end
    local hero_h = Util:ID2Hero(ID)
    if hero_h and not hero_h:IsNull() and ClrbGetTalentIndexForHero(hero_h) == 8 then
        if victim and clrb_hunter_kill_victim_is_neutral(victim) then
            if HeroData and HeroData.Data and HeroData.Data[ID] and HeroData.Data[ID].hero_attr then
                HeroData:AddSX(ID, "smjc", 3)
            end
        end
    end

    if self.Data[ID].item_name == "" then return end
    self.Data[ID].kill = self.Data[ID].kill + 1
    local gold = HeroData:GetSX(ID, "sdjb")
    if gold > 0 then
        local hero = Util:ID2Hero(ID)
        hero:ModifyGold(gold, false, 0)
        SendOverheadEventMessage(PlayerResource:GetPlayer(ID),
            OVERHEAD_ALERT_GOLD, hero, gold,
            hero:GetPlayerOwner())
    end

    Talent:Statkill(ID)
    self:SendKillData(ID)
end

-- 通过击杀计算当前剩余数量和等级
function Talent:Statkill(ID)
    if self.Data[ID].level >= 5 then return end
    local level = self.Data[ID].level
    local num = self.Static["up_" .. level]
    if ClrbTalentGetEquipUpgradeKillsRequired then
        num = ClrbTalentGetEquipUpgradeKillsRequired(ID, level)
    end
    local kill = self.Data[ID].kill
    local tier_base = self.Data[ID].kill_at_levelup or 0
    local tier_kills = kill - tier_base
    if tier_kills >= num then
        self.Data[ID].up = true
        self.Data[ID].sy = 0
        -- 自动升级
        if self.Data[ID].auto_levelup == true then
            Timers(1, function() self:AutoLevelUp(ID) end)
        end
    else
        self.Data[ID].sy = num - tier_kills
    end
    -- self:SendData(ID)
end

function Talent:AutoLevelUp(ID)
    -- print("自动升级")
    if self.Data[ID].up == false then return end
    if self.Data[ID].attr_page == true then return end
    if self.Data[ID].auto_levelup == false then return end
    self:LevelUp(ID)
    self.Data[ID].auto_levelup = false
end

-- 升级
function Talent:LevelUp(ID)
    -- print("1111")
    if not ID then return end
    if self.Data[ID].select_talent == false then
        Talent:OpenPage(ID)
        return
    end
    -- print("2222")
    if not self.Data[ID].up then return end
    -- print("5555")
    -- if self.Data[ID].attr_page == true then return end
    -- print("6666")
    if self.Data[ID].select_attr == true then
        -- print("7777")
        self.Data[ID].attr_page = true
        self:SendAttrData(ID)
        return
    end
    -- print("3333")
    self.Data[ID].attr_page = true
    self.Data[ID].refresh_state = true
    self.Data[ID].roll_num = 0
    self.Data[ID].select_attr = true
    -- roll词条
    if self.Data[ID].roll_num == 0 then self:RollAttr(ID) end
    self:SendAttrData(ID)
end

function Talent:IsSyjcExcludedForRoll(ID)
    if not ID or not self.Data[ID] then
        return false
    end
    local hero_name = self.Data[ID].hero_name
    if hero_name == "" or not hero_name then
        if HeroData and HeroData.GetHeroName then
            hero_name = HeroData:GetHeroName(ID)
        end
    end
    if not hero_name or hero_name == "" then
        return false
    end
    local ex = self.AttrRollExcludeSyjcHeroes
    return ex and ex[hero_name] == true
end

function Talent:RollAttr(ID)
    if not ID then return end
    if self.Data[ID].refresh_state == false then return end
    if self.Data[ID].roll_num > 0 then
        local cost = self.Data[ID].cost
        if not Shop:CostGold(ID, cost) then return end
    end
    self.Data[ID].roll_num = self.Data[ID].roll_num + 1
    local item_name = self.Data[ID].item_name
    local level = self.Data[ID].level + 1
    local rank_key = "rank_" .. level
    local roll_list = Util:DeepCopyTab(self.Item[item_name][rank_key])
    if self:IsSyjcExcludedForRoll(ID) then
        roll_list.syjc = nil
    end
    -- print(item_name)
    -- print(rank_key)
    -- print(roll_list)
    -- roll3条数据
    for k, v in pairs(self.Data[ID].attr_list) do
        -- roll属性名
        local attr_name = utilex:TabTrueKey(roll_list)
        if attr_name == "syjc" and self:IsSyjcExcludedForRoll(ID) then
            roll_list.syjc = nil
            attr_name = utilex:TabTrueKey(roll_list)
        end
        if attr_name then roll_list[attr_name] = false end
        -- roll属性值品质
        local rank = self:RollAttrRank(ID)
        -- 获取属性值
        local attr_value = self.Attr[attr_name][rank]
        if attr_name and attr_value then
            v.state = true
            v.name = attr_name
            v.value = attr_value
            v.rank = rank
        end
    end
    self:SetCost(ID)
    self:SendAttrData(ID)
end

function Talent:SetCost(ID)
    local roll_num = self.Data[ID].roll_num
    local key = "num" .. roll_num
    local cost = self.Cost[key]
    self.Data[ID].cost = cost
    if roll_num >= 5 then self.Data[ID].refresh_state = false end
end

function Talent:RollAttrRank(ID)
    local roll_num = self.Data[ID].roll_num
    if roll_num > 4 then roll_num = 4 end
    local num_key = "num_" .. roll_num
    local roll_list = self.RollNum[num_key]
    local rank = Util:Weight(roll_list)
    return rank
end

function Talent:CloseAttr(ID)
    if not ID then return end
    self.Data[ID].attr_page = false
    self:SendAttrData(ID)
end

function Talent:SelectAttr(ID, slot)
    if not ID or not slot then return end
    if slot == "" then return end
    -- 物品等级+1
    self.Data[ID].level = self.Data[ID].level + 1
    if self.Data[ID].level == 1 then Item:AddItem(ID, "item_goods_22") end
    if self.Data[ID].level == 2 then Item:AddItem(ID, "item_goods_15") end
    -- 根据装备添加属性
    Talent:AddEquipAttr(ID)
    local attr_name = self.Data[ID].attr_list[slot].name
    local attr_value = self.Data[ID].attr_list[slot].value
    local attr_rank = self.Data[ID].attr_list[slot].rank
    -- 添加数据到物品
    self:AddAttr(ID, attr_name, attr_value, attr_rank)
    -- 添加属性到英雄
    self:ApplyRolledAttrToHero(ID, attr_name, attr_value)
    -- 关闭属性页面
    self.Data[ID].attr_page = false
    -- 重置随机次数
    self.Data[ID].roll_num = 0
    -- 重置列表
    for k, v in pairs(self.Data[ID].attr_list) do
        v.state = false
        v.name = ""
        v.value = -1
        v.rank = -1
    end
    if self.Data[ID].level >= 5 then self.Data[ID].sy = -1 end
    -- 重置击杀
    self:ResetKill(ID)
    self:SendAttrData(ID)
    self:SendKillData(ID)
    -- 重置自动升级
    self.Data[ID].auto_levelup = true
    self.Data[ID].select_attr = false
    utilex:Sound(ID, "equipsuccess")
end

function Talent:AddAttr(ID, name, va, rank)
    local level = self.Data[ID].level
    local slot = "slot_" .. level
    self.Data[ID].equip_attr.attr[slot] = { name = name, value = va, rank = rank }
end

--- 升级词条写入英雄：全属性加成同时增加三维增幅
function Talent:ApplyRolledAttrToHero(ID, attr_name, attr_value)
    if not ID or not attr_name or not attr_value then
        return
    end
    if attr_name == "qsxjc" then
        HeroData:AddSX(ID, "lljc", attr_value)
        HeroData:AddSX(ID, "mjjc", attr_value)
        HeroData:AddSX(ID, "zljc", attr_value)
        return
    end
    HeroData:AddSX(ID, attr_name, attr_value)
end

function Talent:ResetKill(ID)
    if not ID then return end
    self.Data[ID].kill_at_levelup = self.Data[ID].kill or 0
    self.Data[ID].up = false
    Talent:Statkill(ID)
end

function Talent:ShowTip(ID)
    if not ID then return end
    self.Data[ID].tip_page = true
    self:SendTipData(ID)
end

function Talent:CloseTip(ID)
    self.Data[ID].tip_page = false
    self:SendTipData(ID)
end

--- 局内天赋技能：已改为回城卷轴栏 item_talent_skill_N 展示，保留空实现兼容旧 UI 事件
function Talent:CastTalentSkillItem(_ID)
end
