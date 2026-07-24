--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function CustomSets:TestFunc2(ID, hero)
    -- 测试命令：在聊天输入 bot 创建 bot，输入 staticbot 创建站着不动且有 goods18 的 bot
end

-- 创建站着不动的人机并拥有 goods18 物品
local function CreateStaticBot(ID)
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end

    print("=== 创建站着不动的 Bot (有 goods18) ===")

    local heroName = "npc_dota_hero_axe"
    local botTeam = DOTA_TEAM_BADGUYS
    local pos = hero:GetAbsOrigin()

    local botHero = CreateUnitByName(heroName, pos, true, nil, nil, botTeam)
    if botHero and not botHero:IsNull() then
        print("Bot 英雄创建成功：" .. botHero:GetUnitName())

        -- 设置等级为 30

        -- 初始化 Talent 数据结构
        local botID = botHero:GetPlayerOwnerID()
        if Talent.Data[botID] == nil then
            Talent.Data[botID] = Util:DeepCopyTab(Talent.Template)
        end
        Talent.Data[botID].level = 1
        Talent.Data[botID].select_talent = true
        Talent.Data[botID].item_name = "item_goods18"

        -- 直接添加 goods18 物品
        local item1 = CreateItem("item_goods18", botHero, botHero)
        botHero:AddItem(item1)
        print("已添加 item_goods18")

        -- 添加 goods18 对应的 buff
        LinkLuaModifier("modifier_talent_2", "ingame/modifier/modifier_talent_2", LUA_MODIFIER_MOTION_NONE)
        botHero:AddNewModifier(botHero, nil, "modifier_talent_2", {})
        print("已添加 goods18 效果")

        -- 添加撒旦
        local item2 = CreateItem("item_satanic", botHero, botHero)
        botHero:AddItem(item2)
        print("已添加撒旦")

        botHero.KillCount = 10
        botHero:AddNewModifier(botHero, nil, "modifier_ability_bf_1_buff", {})

        print("Bot 创建完成")
    else
        print("Bot 英雄创建失败")
    end
end

-- 创建站着不动的人机（没有 goods18）
local function CreateStaticBotNoItem(ID)
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end

    print("=== 创建站着不动的 Bot (无物品) ===")

    local heroName = "npc_dota_hero_axe"
    local botTeam = DOTA_TEAM_BADGUYS
    local pos = hero:GetAbsOrigin()

    local botHero = CreateUnitByName(heroName, pos, true, nil, nil, botTeam)
    if botHero and not botHero:IsNull() then
        print("Bot 英雄创建成功：" .. botHero:GetUnitName())
        local item2 = CreateItem("item_satanic", botHero, botHero)
        botHero:AddItem(item2)
        print("已添加撒旦")

        botHero.KillCount = 10
        botHero:AddNewModifier(botHero, nil, "modifier_ability_bf_1_buff", {})

        print("Bot 创建完成（无物品）")
    else
        print("Bot 英雄创建失败")
    end
end

-- 注册聊天命令监听
function CustomSets:SandRegister2()
    if CustomSets.Sand_Has_Reg2 == nil then
        CustomSets.Sand_Has_Reg2 = {}
    end
    local name = "TestFunc2"
    if not CustomSets.Sand_Has_Reg2[name] then
        CustomSets.Sand_Has_Reg2[name] = true
        ListenToGameEvent("player_chat", Dynamic_Wrap(CustomSets, "PlayerChat2"), CustomSets)
        -- print("sandbox2 聊天命令已注册")
    end
end

-- 立即执行注册
CustomSets:SandRegister2()

function CustomSets:PharseKeys(keys)
    local tab = {}
    local text = keys.text
    if text and text ~= "" then
        -- 去掉前缀 / 或 .
        if text:sub(1, 1) == "/" or text:sub(1, 1) == "." then
            text = text:sub(2)
        end
        for word in text:gmatch("([^%s]+)") do
            table.insert(tab, word:lower())
        end
    end
    return tab
end

-- 存储玩家的粒子效果引用
local txParticles = {}

function CustomSets:PlayerChat2(keys)
    if not IsInToolsMode() then
        return
    end
    local tab = self:PharseKeys(keys)
    if not tab then
        return
    end

    if tab[1] == "reset" then
        local pid = keys.playerid
        if not txParticles[pid] then
            return
        end
        for _, p in ipairs(txParticles[pid]) do
            if p then
                ParticleManager:DestroyParticle(p, true)
            end
        end
        txParticles[pid] = nil
        print("所有特效已重置")
        return
    end

    if tab[1] == "staticbot" then
        CreateStaticBot(keys.playerid)
    elseif tab[1] == "staticbotnoitem" then
        CreateStaticBotNoItem(keys.playerid)
    elseif tab[1] == "testlifesteal" then
        -- 添加 modifier_talent_2_lifesteal_debuff 到你的英雄，持续 10 秒
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        LinkLuaModifier("modifier_talent_2_lifesteal_debuff", "ingame/modifier/modifier_talent_2",
            LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_talent_2_lifesteal_debuff", {
            duration = 10
        })
        print("已添加 lifesteal_debuff，持续 10 秒")
    elseif tab[1] == "tx1" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle(
                "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW,
                hero))
        print("tx1 特效已经添加")
    elseif tab[1] == "tx2" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("tx2 特效已经添加")
    elseif tab[1] == "tx3" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("tx3 特效已经添加")
    elseif tab[1] == "tx4" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("tx4 特效已经添加")
    elseif tab[1] == "tx5" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/courier_shagbark/courier_shagbark_ambient.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("tx5 特效已经添加")
    elseif tab[1] == "tx6" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/courier_platinum_roshan/platinum_roshan_ambient.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("tx5 特效已经添加")
    elseif tab[1] == "v1" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/econ/events/diretide_2020/emblem/fall20_emblem_v1_effect.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("v1 徽章特效已经添加")
    elseif tab[1] == "v2" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("v2 徽章特效已经添加")
    elseif tab[1] == "v3" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("v3 徽章特效已经添加")
    elseif tab[1] == "v4" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        local pid = keys.playerid
        if not txParticles[pid] then
            txParticles[pid] = {}
        end
        table.insert(txParticles[pid],
            ParticleManager:CreateParticle("particles/econ/events/diretide_2020/emblem/fall20_emblem_effect.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, hero))
        print("v4 默认徽章特效已经添加")
    elseif tab[1] == "mmm" then
        local hero = Util:ID2Hero(keys.playerid)
        hero:AddItemByName("item_aghanims_shard")

        local ab = hero:GetAbilityByIndex(0)

        print(ab:GetAbilityName())
        print(ab:IsHidden())
        print(ab:GetLevel())
        ab:SetHidden(false)
    elseif tab[1] == "atv1" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        if hero:HasModifier("modifier_attack_effect") then
            hero:RemoveModifierByName("modifier_attack_effect")
        end
        hero:AddNewModifier(hero, nil, "modifier_attack_effect", {
            attack_effect = "atv1"
        })
        print("atv1 攻击特效已经添加")
    elseif tab[1] == "atv2" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        if hero:HasModifier("modifier_attack_effect") then
            hero:RemoveModifierByName("modifier_attack_effect")
        end
        hero:AddNewModifier(hero, nil, "modifier_attack_effect", {
            attack_effect = "atv2"
        })
        print("atv2 攻击特效已经添加")
    elseif tab[1] == "atv3" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        if hero:HasModifier("modifier_attack_effect") then
            hero:RemoveModifierByName("modifier_attack_effect")
        end
        hero:AddNewModifier(hero, nil, "modifier_attack_effect", {
            attack_effect = "atv3"
        })
        print("atv3 攻击特效已经添加")
    elseif tab[1] == "atv4" then
        local hero = Util:ID2Hero(keys.playerid)
        if not hero or hero:IsNull() then
            return
        end
        if hero:HasModifier("modifier_attack_effect") then
            hero:RemoveModifierByName("modifier_attack_effect")
        end
        hero:AddNewModifier(hero, nil, "modifier_attack_effect", {
            attack_effect = "atv4"
        })
        print("atv4 攻击特效已经添加")
    elseif tab[1] == "addgold" then
        -- 给自己添加 1000 豆子并同步到数据库
        local pid = keys.playerid
        print(pid)
        print(Shop.Data[pid])
        -- pid=137656512
        if Shop and Shop.Data[pid] then
            Shop.Data[pid].gold = Shop.Data[pid].gold + 20000
            Shop:SendData(pid)
            Shop:SyncGold(pid)
            print("已成功添加 1000 豆子，当前金币：" .. Shop.Data[pid].gold)
        else
            print("Shop 数据未就绪")
        end
    elseif tab[1] == "12345" then
        local hero = Util:ID2Hero(keys.playerid)
        hero:AddItemByName("item_aghanims_shard")

        if not hero or hero:IsNull() then
            return
        end

        local ability = hero:FindAbilityByName("gyrocopter_side_gunner_spawn_ability")
        if not ability then
            ability = hero:AddAbility("gyrocopter_side_gunner_spawn_ability")
        end

        if ability then
            ability:SetLevel(0)
            print("已将侧翼机枪等级设置为 0")
            ability:SetLevel(1)
            print("已将侧翼机枪等级设置为 1")

            -- Timers(2, function()

            --     -- 打印 1000 码内所有单位
            --     print("=== 200 码内所有单位 ===")
            --     local side_gunner = nil
            --     local units = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            --     for _, unit in ipairs(units) do
            --         local name = unit:GetUnitName()
            --         local pos = unit:GetAbsOrigin()
            --         print("单位：" .. name .. " | 位置：" .. pos.x .. ", " .. pos.y)
            --         if name == "npc_dota_side_gunner" then
            --             side_gunner = unit
            --         end
            --     end
            --     if #units == 0 then
            --         print("范围内无单位")
            --     end

            --     if side_gunner and not side_gunner:IsNull() then
            --         print("检测到 npc_dota_side_gunner 单位存在！")
            --         print("单位位置：" .. side_gunner:GetAbsOrigin().x .. ", " .. side_gunner:GetAbsOrigin().y)
            --     else
            --         print("未检测到 npc_dota_side_gunner 单位")
            --     end
            -- end)
        end
    end
end