--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function CustomSets:SandRegister()
    if DevTools then
        DevTools:RegisterChat()
        DevTools:InitRegistry()
    end
end

--- 开发测试：所有 `InitPlayer` 标记为 bot 的玩家升至 30 级，肉搏金币设为 30000
function CustomSets:TestBoostBotsLevel30Gold30000()
    Timers(0.5, function()
        if not InitPlayer or not InitPlayer.Public or not InitPlayer.Public.players then
            return
        end
        for _, v in pairs(InitPlayer.Public.players) do
            if v and v.bot and v.id ~= nil and v.id >= 0 then
                local botID = v.id
                local hero = Util:ID2Hero(botID)
                if hero and not hero:IsNull() and hero:IsAlive() then
                    local data = BotAI.Data and BotAI.Data[botID]
                    if data then
                        data.last_level = hero:GetLevel() or 1
                    end
                    local target = 30
                    local guard = 0
                    while hero.GetLevel and hero:GetLevel() < target and guard < 80 do
                        guard = guard + 1
                        hero:AddExperience(250000, 0, false, false)
                    end
                    if HeroData.Data[botID] then
                        HeroData.Data[botID].gold = 30000
                        HeroData:SendData(botID)
                    end
                    if data then
                        BotAI:HandleLevelGrowth(hero, data)
                    end
                end
            end
        end
    end)
end

function CustomSets:TestFunc(ID, hero)
    if DevTools then
        print("1111")
        --打印玩家所有槽位
        for i = 0, 20 do
            local item = hero:GetItemInSlot(i)
            if item and not item:IsNull() then
                print("槽位" .. i .. "：" .. item:GetName())
            end
        end
        -- DevTools:RunCommand(ID, "fallstar")
    end
end