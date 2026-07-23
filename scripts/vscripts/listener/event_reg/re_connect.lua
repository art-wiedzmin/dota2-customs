function CustomSets:Re_Connect(keys)

    -- print("Re_Connect")

    local ID = keys.PlayerID

    if ID and HeroData.Data[ID] and HeroData.Data[ID].tag then

        if HeroData.Data[ID].tag.tag7 == true then

            HeroData.Data[ID].tag.tag7 = false

        end

        HeroData.Data[ID].tag.pending_disconnect_petbuff = false

    end

    if ID then

        Stat:PlayerImgChange(ID, true)

        -- 下一帧：引擎绑英雄、补 InitHero、本机全量数据、广播所有客户端

        Timers(0, function()

            if

                InitPlayer

                and InitPlayer.GetPlayerData

                and SelectHero

                and SelectHero.ApplyEnginePickForPlayer

            then

                local d = InitPlayer:GetPlayerData(ID)

                if d and (not d.bot) and d.hero_name and d.hero_name ~= "" then

                    SelectHero:ApplyEnginePickForPlayer(ID, d.hero_name, false)

                end

            end

            if InitPlayer and InitPlayer.ReconnectFullInitAndSync then

                InitPlayer:ReconnectFullInitAndSync(ID)

            end

        end)

        -- 客户端就绪常晚于 player_reconnected；多帧补绑英雄并推金币
        for _, delay in ipairs({ 0.5, 1, 2, 3 }) do

            Timers(delay, function()

                if not PlayerResource or not PlayerResource.IsValidPlayer or not PlayerResource:IsValidPlayer(ID) then

                    return

                end

                if InitPlayer and InitPlayer.GetPlayerData and SelectHero and SelectHero.ApplyEnginePickForPlayer then

                    local d = InitPlayer:GetPlayerData(ID)

                    if d and (not d.bot) and d.hero_name and d.hero_name ~= "" then

                        SelectHero:ApplyEnginePickForPlayer(ID, d.hero_name, false)

                    end

                end

            end)

        end

        -- 再晚一帧取实体：首帧尚无英雄时补 InitHero

        Timers(0.2, function()

            if not ID or not HeroData.Data[ID] or HeroData.Data[ID].init ~= false then

                return

            end

            local h2 = HeroData:GetHero(ID)

            if (not h2 or h2:IsNull()) and PlayerResource and PlayerResource.GetSelectedHeroEntity then

                h2 = PlayerResource:GetSelectedHeroEntity(ID)

            end

            if h2 and not h2:IsNull() and HeroData.InitHero then

                HeroData:InitHero(ID, h2)

            end

            if InitPlayer and InitPlayer.Init_Ui then

                InitPlayer:Init_Ui(ID)

            end

            pcall(function()

                if HeroData and HeroData.Data and HeroData.Data[ID] and HeroData.SendData then

                    HeroData:SendData(ID)

                end

            end)

            pcall(function()

                if SelectHero and SelectHero.Data and SelectHero.Data[ID] and SelectHero.SendData then

                    SelectHero:SendData(ID)

                end

            end)

            if Util and Util.ClrbSchedulePlayerGoldResync then

                Util:ClrbSchedulePlayerGoldResync(ID)

            end

        end)

        do

            local hero = HeroData:GetHero(ID)

            if

                (not hero or hero:IsNull())

                and PlayerResource

                and PlayerResource.GetSelectedHeroEntity

            then

                hero = PlayerResource:GetSelectedHeroEntity(ID)

            end

            if hero and not hero:IsNull() and hero:HasModifier("modifier_petbuff") then

                hero:RemoveModifierByName("modifier_petbuff")

                Stat:UpDataRank()

            end

        end

    end

    return true

end

