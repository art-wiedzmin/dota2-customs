--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function DevTools:InitBuiltinCommands()
    local function sx(id, key, val)
        HeroData:AddSX(id, key, val)
    end

    self:RegisterTool("yy", "预言界面", function(ID)
        if Prophecy and Prophecy.ForceTryOpen then
            if not Prophecy:ForceTryOpen(ID) then
                Util:BottomMsg2ID(ID, "预言界面打开失败（可能已宣布或时间已过）", "red", 3)
            end
        end
    end, { group = "预言" })

    self:RegisterTool("-yy", "预言界面", function(ID)
        DevTools:RunCommand(ID, "yy")
    end, { group = "预言", show_in_panel = false })

    self:RegisterTool("yyk", "预言卡x10", function(ID)
        if Shop and Shop.GrantBagItemServer then
            Shop:GrantBagItemServer(ID, "prophecy_card", 10, function(ok, keys)
                if ok then
                    local n = Shop:GetBagItemCount(ID, "prophecy_card")
                    Util:BottomMsg2ID(ID, "获得预言卡 x10（当前 " .. tostring(n) .. "）", "yellow", 3)
                    if Prophecy and Prophecy.OnBagReady then
                        Prophecy:OnBagReady(ID)
                    end
                elseif keys == "no_token" then
                    Util:BottomMsg2ID(ID, "请先登录账号后再使用 yyk", "red", 3)
                else
                    Util:BottomMsg2ID(ID, "预言卡发放失败", "red", 3)
                end
            end)
        end
    end, { group = "预言" })

    self:RegisterTool("-yyk", "预言卡x10", function(ID)
        DevTools:RunCommand(ID, "yyk")
    end, { group = "预言", show_in_panel = false })

    self:RegisterTool("xrsb", "跨纬度肉山宝宝", function(ID)
        local itemKey = "pet_ti10_rosh"
        local function onGranted()
            if Shop:OutBagOwnsItem(ID, itemKey) then
                Util:BottomMsg2ID(ID, "获得跨纬度肉山宝宝（可在背包佩戴）", "yellow", 3)
            else
                Util:BottomMsg2ID(ID, "获得跨纬度肉山宝宝", "yellow", 3)
            end
        end
        if Shop and Shop.GrantBagItemServer then
            Shop:GrantBagItemServer(ID, itemKey, 1, function(ok, keys)
                if ok then
                    onGranted()
                    return
                end
                if keys == "no_token" and IsInToolsMode() and Shop.AddBagItemLocal then
                    if not Shop.Data[ID] and Shop.Init then
                        Shop:Init(ID)
                    end
                    if Shop:AddBagItemLocal(ID, itemKey, 1) then
                        onGranted()
                        return
                    end
                    Util:BottomMsg2ID(ID, "请先登录账号后再使用 xrsb", "red", 3)
                    return
                end
                Util:BottomMsg2ID(ID, "跨纬度肉山宝宝发放失败", "red", 3)
            end)
        end
    end, { group = "背包" })

    self:RegisterTool("-xrsb", "跨纬度肉山宝宝", function(ID)
        DevTools:RunCommand(ID, "xrsb")
    end, { group = "背包", show_in_panel = false })

    self:RegisterTool("我是萌新", "我是萌新", function(ID)
        if MainGame:GetTime() <= 60 and Person:GetPoint(ID) < 1100 then
            Item:AddItem(ID, "item_goods_14")
        end
    end, { group = "福利", tools_only = false })

    self:RegisterTool("我是菜鸟", "我是菜鸟", function(ID)
        if MainGame:GetTime() <= 60 and Person:GetPoint(ID) < 500 then
            Item:AddItem(ID, "item_goods_14")
            Item:AddItem(ID, "item_goods_14")
        end
    end, { group = "福利", tools_only = false })

    self:RegisterTool("-zs", "自杀(限1次)", function(ID, hero)
        if not DevTools.ChatCmdZsUsed[ID] and hero:IsAlive() then
            DevTools.ChatCmdZsUsed[ID] = true
            local dam = hero:GetMaxHealth() * 10
            utilex:UnitDam(hero, hero, dam, "cc")
        end
    end, { group = "战斗", tools_only = false })

    self:RegisterTool("wz", "打印坐标", function(_, hero)
        print(hero:GetAbsOrigin())
    end, { group = "调试" })

    self:RegisterTool("wd", "无敌", function(_, hero)
        LinkLuaModifier("modifier_wd", "ingame/modifier/modifier_wd", LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_wd", {})
    end, { group = "调试" })

    self:RegisterTool("gb", "关闭无敌", function(_, hero)
        hero:RemoveModifierByName("modifier_wd")
    end, { group = "调试" })

    self:RegisterTool("fy", "无敌(修饰器)", function(_, hero)
        LinkLuaModifier("modifier_wudi", "ingame/modifier/modifier_wudi", LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_wudi", {})
    end, { group = "调试" })

    self:RegisterTool("jnlb", "打印技能槽", function(_, hero)
        local abilityCount = hero:GetAbilityCount()
        print("英雄技能槽总数:", abilityCount)
        for i = 0, abilityCount - 1 do
            local ability = hero:GetAbilityByIndex(i)
            if ability then
                print(string.format("天赋槽位[%d]：%s 等级=%d", i,
                    ability:GetAbilityName(), ability:GetLevel()))
            end
        end
    end, { group = "调试" })

    self:RegisterTool("map", "关闭战争迷雾", function()
        local mode = GameRules:GetGameModeEntity()
        mode:SetFogOfWarDisabled(true)
    end, { group = "调试" })

    self:RegisterTool("center", "传送地图中心", function(_, hero)
        hero:SetAbsOrigin(Monster.Static.map_center)
    end, { group = "调试" })

    self:RegisterTool("book", "百本技能书", function(_, hero)
        for _ = 1, 100 do
            hero:AddItem(CreateItem("item_goods_14", hero, hero))
        end
        for _ = 1, 100 do
            hero:AddItem(CreateItem("item_goods_15", hero, hero))
        end
        for _ = 1, 100 do
            hero:AddItem(CreateItem("item_goods_16", hero, hero))
        end
    end, { group = "物品" })

    self:RegisterTool("book1", "T2技能书", function(ID)
        Skill:UseBook(ID, "T2")
    end, { group = "物品" })

    self:RegisterTool("book2", "T1技能书", function(ID)
        Skill:UseBook(ID, "T1")
    end, { group = "物品" })

    self:RegisterTool("book3", "T0技能书", function(ID)
        Skill:UseBook(ID, "T0")
    end, { group = "物品" })

    self:RegisterTool("mj", "阿哈利姆魔晶", function(_, hero)
        hero:AddItem(CreateItem("item_aghanims_shard", hero, hero))
    end, { group = "物品" })

    self:RegisterTool("rb", "掉落全部肉搏", function(_, hero)
        local pos1 = hero:GetAbsOrigin()
        for _, v in pairs(Item.Rb) do
            local pos2 = utilex:RandomPos(pos1, 0, 800)
            local item = CreateItem(v, nil, nil)
            CreateItemOnPositionSync(pos1, item)
            item:LaunchLoot(false, 300, 0.5, pos2, nil)
        end
    end, { group = "物品" })

    self:RegisterTool("box", "宝箱抽奖x10", function(ID)
        for _ = 1, 10 do
            Box:AddDraw(ID)
        end
    end, { group = "物品" })

    self:RegisterTool("kill", "天赋击杀+80", function(ID)
        Talent.Data[ID].kill = Talent.Data[ID].kill + 80
        Talent:Statkill(ID)
        Talent:SendKillData(ID)
    end, { group = "物品" })

    self:RegisterTool("zb", "10级+9999999金", function(ID, hero)
        local target = 10
        local guard = 0
        while hero.GetLevel and hero:GetLevel() < target and guard < 80 do
            guard = guard + 1
            hero:AddExperience(250000, 0, false, false)
        end
        PlayerResource:ModifyGold(ID, 9999999, false, 0)
    end, { group = "属性" })

    self:RegisterTool("jbjc", "金币加成+100", function(ID) sx(ID, "jbjc", 100) end, { group = "属性" })
    self:RegisterTool("jyjc", "经验加成+100", function(ID) sx(ID, "jyjc", 100) end, { group = "属性" })
    self:RegisterTool("zzjs", "最终减伤+100", function(ID) sx(ID, "zzjs", 100) end, { group = "属性" })
    self:RegisterTool("zzsh", "最终伤害+100", function(ID) sx(ID, "zzsh", 100) end, { group = "属性" })
    self:RegisterTool("djsx", "等级属性+5", function(ID) sx(ID, "djsx", 5) end, { group = "属性" })
    self:RegisterTool("gjsd", "攻击速度+100", function(ID) sx(ID, "gjsd", 100) end, { group = "属性" })
    self:RegisterTool("smhf", "生命恢复+100", function(ID) sx(ID, "smhf", 100) end, { group = "属性" })
    self:RegisterTool("jnzq", "技能增强+100", function(ID) sx(ID, "jnzq", 100) end, { group = "属性" })
    self:RegisterTool("gjjg", "攻击间隔+0.1", function(ID) sx(ID, "gjjg", 0.1) end, { group = "属性" })

    self:RegisterTool("修仙", "修为至飞行(24)", function(ID, hero)
        require("ingame.modifier.clrb_fly_cloud_util")
        if ClrbGetTalentIndexForHero == nil then
            require("ingame.modifier.modifier_clrb_talents")
        end
        local mod = hero:FindModifierByName("modifier_talent_skill_6")
        if not mod and ClrbGetTalentIndexForHero(hero) == 6 and ClrbTalentApplyPassives then
            ClrbTalentApplyPassives(ID, hero)
            mod = hero:FindModifierByName("modifier_talent_skill_6")
        end
        if not mod then
            Util:BottomMsg2ID(ID, "当前英雄未选择修仙天赋", "red", 3)
            return
        end
        mod:SetStackCount(24)
        hero:CalculateStatBonus(true)
        if ClrbFlyCloudScheduleSync then
            ClrbFlyCloudScheduleSync(hero)
        elseif ClrbFlyCloudSync then
            ClrbFlyCloudSync(hero)
        end
        Util:BottomMsg2ID(ID, "修仙：修为已设为 24（飞行阶段）", "yellow", 3)
    end, { group = "属性" })

    self:RegisterTool("yj", "刷友方野怪", function(_, hero)
        local pos = utilex:RandomPos(hero:GetAbsOrigin(), 100, 200)
        utilex:CreateUnit("m_1_2", pos, nil, "good")
    end, { group = "刷怪" })

    self:RegisterTool("dr", "刷敌方野怪", function(_, hero)
        local pos = utilex:RandomPos(hero:GetAbsOrigin(), 100, 200)
        utilex:CreateUnit("m_1_2", pos, nil, "bad")
    end, { group = "刷怪" })

    self:RegisterTool("pack", "刷快递", function(_, hero)
        local pos = utilex:RandomPos(hero:GetAbsOrigin(), 100, 200)
        local unit = utilex:CreateUnit("Pack", pos, nil, "good")
        utilex:AddModifier(unit, "wd_nobar")
        Pack:AutoPage(unit)
    end, { group = "刷怪" })

    self:RegisterTool("ml", "刷魔龙", function()
        Monster:CreateDragon()
    end, { group = "刷怪" })

    self:RegisterTool("lw", "刷狼王", function()
        Monster:CreateWolf()
    end, { group = "刷怪" })

    self:RegisterTool("mx", "刷寰宇肉山", function()
        Monster:CreateBear()
    end, { group = "刷怪" })

    self:RegisterTool("ldxt", "刷雷电信徒", function(ID, hero)
        local pos = utilex:RandomPos(hero:GetAbsOrigin(), 100, 250)
        pos = Util:FindCanReachPos(pos) or pos
        Monster:SpawnLightningBelieverAt(pos, true, hero, function(unit)
            if unit then
                Util:BottomMsg2ID(ID, "已在附近召唤雷电信徒", "yellow", 3)
            else
                Util:BottomMsg2ID(ID, "雷电信徒召唤失败", "red", 3)
            end
        end)
    end, { group = "刷怪" })

    self:RegisterTool("tank", "刷木桩(坦)", function(_, hero)
        local pos = utilex:RandomPos(hero:GetAbsOrigin(), 100, 200)
        local unit = utilex:CreateUnit("hj_test", pos, nil, "bad")
        utilex:AddModifier(unit, "modifier_testtank")
    end, { group = "刷怪" })

    self:RegisterTool("attack", "刷木桩", function(_, hero)
        local pos = utilex:RandomPos(hero:GetAbsOrigin(), 100, 200)
        utilex:CreateUnit("hj_test", pos, nil, "bad")
    end, { group = "刷怪" })

    self:RegisterTool("axe", "刷可控斧王", function(ID, hero)
        local pos = utilex:RandomPos(hero:GetAbsOrigin(), 100, 300)
        CreateUnitByNameAsync("npc_dota_hero_axe", pos, true, hero, hero, 3, function(unit)
            unit:SetControllableByPlayer(ID, true)
        end)
    end, { group = "刷怪" })

    self:RegisterTool("bot", "刷测试Bot", function(_, hero)
        local botHero = CreateUnitByName("npc_dota_hero_axe", hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
        if botHero and not botHero:IsNull() then
            botHero.KillCount = 10
            botHero:AddNewModifier(botHero, nil, "modifier_ability_bf_1_buff", {})
            local mode = GameRules:GetGameModeEntity()
            mode:SetHeroChangeAllowed(true)
        end
    end, { group = "刷怪" })

    self:RegisterTool("du1", "毒圈阶段1", function()
        MainGame.Data.state = 2
        MainGame:MapChange1()
    end, { group = "地图" })

    self:RegisterTool("sq1", "缩圈1", function()
        MainGame.Data.state = 2
        MainGame:MapChange1()
    end, { group = "地图" })

    self:RegisterTool("sq2", "缩圈2", function()
        MainGame.Data.state = 3
        MainGame:MapChange2()
    end, { group = "地图" })

    self:RegisterTool("gg", "强制结算", function()
        MainGame.OverData.Team2.result = 1
        MainGame:GameOver()
    end, { group = "地图" })

    self:RegisterTool("zs", "自杀", function(_, hero)
        local dam = hero:GetMaxHealth() * 10
        utilex:UnitDam(hero, hero, dam, "cc")
    end, { group = "战斗" })

    self:RegisterTool("jzsg", "禁止刷怪", function()
        MainGame.Data.jzsg = true
    end, { group = "刷怪" })

    self:RegisterTool("ltfx", "雷霆天气", function(ID)
        if MainGame and MainGame.WeatherStartById then
            MainGame:WeatherStartById(6)
            Util:BottomMsg2ID(ID, "已触发雷霆降世天气", "yellow", 3)
        end
    end, { group = "调试" })
end
