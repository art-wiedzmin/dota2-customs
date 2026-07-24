--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--加载玩家系统
function InitPlayer:Init_ID(ID)
    if not ID then
        return
    end
    SelectHero:Init(ID)
    HeroData:Init(ID)
    Item:Init(ID)
    Box:Init(ID)
    Talent:Init(ID)
    Skill:Init(ID)
    Pack:Init(ID)
    OverData:Init(ID)
    if Prophecy and Prophecy.Init then
        Prophecy:Init(ID)
    end
    Person:Init(ID)
    Shop:Init(ID)
    if HolidayPack and HolidayPack.Init then
        HolidayPack:Init(ID)
    end
    Rank:Init(ID)
    Point:Init(ID)
    Code:Init(ID)
    Server:InitID(ID)
    Msgs:Init(ID)
    Pet:Init(ID)
    Stat:Init(ID)
    Invite:Init(ID)
    Book:Init(ID)
    HeroCard:Init(ID)
    EazyShop:Init(ID)
    KeySet:Init(ID)
    AchieveModule:Init(ID)
    LeaveConfirm:Init(ID)
    if AchieveStat and AchieveStat.Init then
        AchieveStat:Init(ID)
    end
    if DevTools and DevTools.Init then
        DevTools:Init(ID)
    end
end

function InitPlayer:Init_Ui(ID)
    Box:SendData(ID)
    Box:RefreshNeutralChestItemCharges(ID)
    Talent:SendData(ID)
    Skill:SendData(ID)
    Stat:SendData(ID)
    if DevTools and DevTools.IsEnabled and DevTools:IsEnabled() and DevTools.SendData then
        DevTools:SendData(ID)
    end
end

local function clrb_reconnect_send_if(mod, id)
    if not mod or not id or not mod.Data or not mod.Data[id] or not mod.SendData then
        return
    end
    mod:SendData(id)
end

--- 重连后下一帧：补 InitHero（若未做过）+ 本机全量 UI 数据 + 向所有客户端广播公共状态
function InitPlayer:ReconnectFullInitAndSync(ID)
    if not ID or not self.GetPlayerData then
        return
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return
    end
    local d = self:GetPlayerData(ID)
    if not d or d.bot then
        return
    end
    d.clrb_defer_inithero_until_reconnect = false
    local hero
    if Util and Util.GetHeroForPlayerData then
        hero = Util:GetHeroForPlayerData(ID)
    end
    if (not hero or hero:IsNull()) and HeroData and HeroData.GetHero then
        hero = HeroData:GetHero(ID)
    end
    if (not hero or hero:IsNull()) and PlayerResource and PlayerResource.GetSelectedHeroEntity then
        hero = PlayerResource:GetSelectedHeroEntity(ID)
    end
    if hero and not hero:IsNull() and HeroData and HeroData.Data and HeroData.Data[ID] and
        HeroData.Data[ID].init == false and HeroData.InitHero then
        HeroData:InitHero(ID, hero)
    end
    self:Init_Ui(ID)
    pcall(function() clrb_reconnect_send_if(HeroData, ID) end)
    pcall(function()
        if SelectHero and SelectHero.Data and SelectHero.Data[ID] then
            if SelectHero.SendData then
                SelectHero:SendData(ID)
            end
            if ClrbEnsureTalentItemInTpSlot then
                local hero = Util:ID2Hero(ID)
                if hero and not hero:IsNull() then
                    ClrbEnsureTalentItemInTpSlot(hero)
                end
            end
        end
    end)
    pcall(function() clrb_reconnect_send_if(Shop, ID) end)
    pcall(function() clrb_reconnect_send_if(Pack, ID) end)
    pcall(function() clrb_reconnect_send_if(OverData, ID) end)
    pcall(function() clrb_reconnect_send_if(KeySet, ID) end)
    pcall(function() clrb_reconnect_send_if(Person, ID) end)
    pcall(function() clrb_reconnect_send_if(Rank, ID) end)
    pcall(function() clrb_reconnect_send_if(Code, ID) end)
    pcall(function() clrb_reconnect_send_if(Point, ID) end)
    pcall(function() clrb_reconnect_send_if(Msgs, ID) end)
    pcall(function() clrb_reconnect_send_if(EazyShop, ID) end)
    pcall(function() clrb_reconnect_send_if(Book, ID) end)
    pcall(function() clrb_reconnect_send_if(LeaveConfirm, ID) end)
    pcall(function() clrb_reconnect_send_if(Invite, ID) end)
    pcall(function() clrb_reconnect_send_if(HeroCard, ID) end)
    pcall(function()
        if SelectHero and SelectHero.SendPublicData then
            SelectHero:SendPublicData()
        end
    end)
    pcall(function()
        if Stat and Stat.SendPublicData then
            Stat:SendPublicData(true)
        end
    end)
    pcall(function()
        if Monster and Monster.SendData then
            Monster:SendData()
        end
    end)
    if Util and Util.ClrbSchedulePlayerGoldResync then
        Util:ClrbSchedulePlayerGoldResync(ID)
    end
end

--所有玩家获得金币
function InitPlayer:AllPlayerGetGold()
    for k, v in pairs(self.Public.players) do
        local ID = v.id
        if not ID or not HeroData.Data[ID] then
            goto continue
        end
        local gold = 10
        if v.bot then
            gold = 10
        else
            local jbjc = HeroData:GetSX(ID, "jbjc") or 0
            gold = math.floor((100 + jbjc) * gold / 100)
        end
        HeroData:AddGold(ID, gold)
        if not v.bot and PlayerResource:IsValidPlayerID(ID) then
            PlayerResource:ModifyGold(ID, gold, false, 0)
        end
        ::continue::
    end
end

--英雄初始化
function InitPlayer:HeroInit(ID, hero)
    local hero_name = HeroData:GetHeroName(ID)
    -- 大圣：移除猴子猴孙相关技能，避免饰品/至宝在地图产生幻象导致宝宝跟随bug
    if hero_name == "npc_dota_hero_monkey_king" then
        for _, ab_name in ipairs({ "monkey_king_wukongs_command", "monkey_king_untransform", "monkey_king_transfiguration" }) do
            if hero:HasAbility(ab_name) then
                hero:RemoveAbility(ab_name)
            end
        end
    end
    --加载英雄初始成长
    HeroData:SetHeroCostGain(ID, hero)
    --添加先天装备（只加一次）
    Talent:AddTalentOnce(ID)
    local keep_abilities = {}
    local all_abilities = {}

    local abilityCount = hero:GetAbilityCount()
    -- print("英雄技能槽总数:", abilityCount)

    -- 1. 先记录当前所有技能名
    for i = 0, abilityCount - 1 do
        local ability = hero:GetAbilityByIndex(i)
        if ability then
            local abilityName = ability:GetAbilityName()
            local abilityLevel = ability:GetLevel()

            -- print(string.format("原始槽位[%d]：%s 等级=%d", i, abilityName, abilityLevel))

            table.insert(all_abilities, abilityName)

            if HeroData:IsGyrocopterSideGunnerAbility(hero_name, abilityName) then
                table.insert(keep_abilities, {
                    name = abilityName,
                    level = 0,
                    hidden = true,
                })
            elseif not HeroData:IsHeroSkill(hero_name, abilityName)
                and not HeroData:IsHeroBlockedAghSkill(hero_name, abilityName)
                and not HeroData:IsHeroStripSkill(hero_name, abilityName) then
                table.insert(keep_abilities, {
                    name = abilityName,
                    level = abilityLevel,
                    hidden = HeroData:IsHeroHide(hero_name, abilityName)
                })
            end
        end
    end


    -- print("保留技能：")
    -- DeepPrintTable(keep_abilities)

    -- print("删除全部技能：")
    -- DeepPrintTable(all_abilities)

    -- -- 2. 删除全部技能
    for _, abilityName in ipairs(all_abilities) do
        if hero:HasAbility(abilityName) then
            hero:RemoveAbility(abilityName)
        end
    end

    -- 3. 下一帧再重新添加，避免引擎本帧槽位未刷新
    Timers:CreateTimer(0, function()
        local null_list = {}

        -- 3.1 先添加 10 个空技能
        local slot_map = {
            [1] = 0, -- null1 -> 槽位0
            [2] = 1, -- null2 -> 槽位1
            [3] = 2, -- null3 -> 槽位2
            [4] = 3, -- null4 -> 槽位5
            [5] = 4, -- null5 -> 槽位3
            [6] = 5, -- null6 -> 槽位4
            [7] = 6, -- null7 -> 槽位6
            [8] = 7, -- null8 -> 槽位7
            [9] = 8, -- null9 -> 槽位8
            [10] = 9 -- null10 -> 槽位9
        }

        for i = 1, 3 do
            local new_ab_name = "ability_null_" .. (slot_map[i] + 1)
            local new_ab = hero:AddAbility(new_ab_name)
            if new_ab then
                new_ab:SetLevel(1)
                new_ab:SetHidden(false)
            else
                -- print("添加技能失败:", new_ab_name)
            end
        end
        for i = 1, 2 do
            local new_ab_name = "ability_null_" .. (10 + i)
            local new_ab = hero:AddAbility(new_ab_name)
            if new_ab then
                new_ab:SetLevel(1)
                -- print("添加null")

                new_ab:SetHidden(true)
            else
                -- print("添加技能失败:", new_ab_name)
            end
        end
        for i = 4, 10 do
            local new_ab_name = "ability_null_" .. (slot_map[i] + 1)
            local new_ab = hero:AddAbility(new_ab_name)
            if new_ab then
                new_ab:SetLevel(1)
                new_ab:SetHidden(false)
            else
                -- print("添加技能失败:", new_ab_name)
            end
        end

        -- 3.3 再把保留技能重新加回来
        for _, info in ipairs(keep_abilities) do
            if info.name and not hero:HasAbility(info.name) then
                local ab = hero:AddAbility(info.name)
                if ab then
                    ab:SetLevel(info.level or 0)

                    if info.hidden then
                        ab:SetHidden(true)
                    end
                else
                    -- print("重新添加保留技能失败:", info.name)
                end
            end
        end

        -- 4. 打印最终结果
        local newAbilityCount = hero:GetAbilityCount()
        -- print("--------------------")
        -- print("重排后英雄技能槽总数:", newAbilityCount)

        for i = 0, newAbilityCount - 1 do
            local ability = hero:GetAbilityByIndex(i)
            if ability then
                -- print(string.format("最终槽位[%d]：%s 等级=%d hidden=%s", i, ability:GetAbilityName(),
                --     ability:GetLevel(), tostring(ability:IsHidden())))
            end
        end
        local stillkill = hero:AddAbility("ability_bf_1")
        stillkill:SetLevel(1)
        stillkill:SetHidden(true)

        if hero_name == "npc_dota_hero_gyrocopter" and HeroData.SetupGyrocopterSideGunner then
            HeroData:SetupGyrocopterSideGunner(hero)
        end
    end)

    -- 英雄添加buff
    LinkLuaModifier("modifier_attr_buff", "ingame/modifier/modifier_attr_buff", LUA_MODIFIER_MOTION_NONE)
    hero:AddNewModifier(hero, -- 施法者
        nil,                  -- 技能
        "modifier_attr_buff", -- 修饰器名称
        {}                    -- 参数
    )

    if not Util:IsPseudoPlayerID(ID) then
        -- 设置镜头
        PlayerResource:SetCameraTarget(ID, hero)

        -- 移除镜头
        Timers(1, function()
            PlayerResource:SetCameraTarget(ID, nil)
        end)
    end

    local init_data = self:GetPlayerData(ID)
    if init_data and init_data.bot then
        Timers(0.3, function()
            if hero and not hero:IsNull() then
                BotAI:Attach(ID, hero)
            end
        end)
    end

    -- 人机只走 HeroInit、不走 HeroData:InitHero，须在此挂上选人被动（学者每分钟技能书等）
    if ClrbTalentApplyPassives then
        ClrbTalentApplyPassives(ID, hero)
    end
    if utilex and utilex.BaseSmzf and HeroData and HeroData.Data and HeroData.Data[ID] then
        utilex:BaseSmzf(ID)
    end
    if ClrbLhzfEnsureOnHero then
        ClrbLhzfEnsureOnHero(ID, hero)
    end
    if ClrbHeroBalanceEnsureOnHero then
        ClrbHeroBalanceEnsureOnHero(ID, hero)
    end
end
