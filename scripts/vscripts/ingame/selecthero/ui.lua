--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


require("ingame.modifier.modifier_clrb_talents")

function SelectHero:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    --暂停禁止传数据
    if GameRules:IsGamePaused() then
        return
    end
    --初始化数据
    if data.tp == "init" then
        self:SendData(ID)
        SelectHero:SendPublicData()
    end
    if data.tp == "ReconnectGoldSync" then
        local d = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
        if d and d.hero_name and d.hero_name ~= "" and SelectHero.ApplyEnginePickForPlayer then
            SelectHero:ApplyEnginePickForPlayer(ID, d.hero_name, false)
        end
        if Util and Util.ClrbForcePlayerGoldResync then
            Util:ClrbForcePlayerGoldResync(ID)
        end
        return
    end
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    --选属性
    if data.tp == "SelectAttr" then
        self:SelectAttr(ID, data.text)
    end
    --重新随机
    if data.tp == "RollHero" then
        self:RollHero(ID)
    end
    --增加随机次数
    if data.tp == "AddRefresh" then
        self:AddRefresh(ID)
    end
    --选英雄
    if data.tp == "SelectHero" then
        self:SelectHero(ID, data.text)
    end
    if data.tp == "PreviewSlot" then
        self:SetPreviewSlot(ID, data.text)
    end
    -- 选人天赋（仅存 SelectHero.Data[ID].talent_index）
    if data.tp == "SelectTalent" then
        local idx = tonumber(data.talent_index)
        if idx and self.Data[ID] then
            idx = self:SanitizeTalentIndex(idx)
            self.Data[ID].talent_index = idx
            ClrbSyncTalentNettable(ID, idx)
            if ClrbTalentSyncEquipTooltipNettable then
                ClrbTalentSyncEquipTooltipNettable(ID)
            end
            local pd = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
            if pd then
                pd.talent_index = idx
            end
            if IsServer() and ClrbTalentApplyPassives then
                local hero = Util:ID2Hero(ID)
                if hero and not hero:IsNull() then
                    ClrbTalentApplyPassives(ID, hero)
                elseif ClrbTalentScheduleApplyPassives then
                    ClrbTalentScheduleApplyPassives(ID)
                end
            end
            if IsServer() and Talent and Talent.Data and Talent.Data[ID] and Talent.Statkill then
                Talent:Statkill(ID)
                Talent:SendKillData(ID)
            end
            if IsServer() and idx == 3 and Talent and Talent.ApplyBlacksmithEquipBonusCatchup then
                Talent:ApplyBlacksmithEquipBonusCatchup(ID)
            end
        end
    end
    if data.tp == "DevRequestHeroList" then
        if not self:CanUseHeroPickFlow(ID) then
            return
        end
        if not IsInToolsMode() then
            local pick_count = Shop and Shop.GetBagItemCount and Shop:GetBagItemCount(ID, "hero_pick") or 0
            if pick_count < 1 then
                self:PushHeroPickHint(ID, self.HeroPickInsufficientMsg, true)
                return
            end
        end
        self:SendDevHeroPickerList(ID)
    end
    if data.tp == "DevPickHero" then
        if not self:CanUseHeroPickFlow(ID) then
            if not IsInToolsMode() then
                self:PushHeroPickHint(ID, self.HeroPickInsufficientMsg, true)
            end
            return
        end
        self:DevPickHeroByIndex(ID, data.hero_index)
    end
end

--给前端发数据
function SelectHero:SendData(ID)
    if not ID then
        return
    end
    local data = self.Data[ID]
    if not data then
        return
    end
    -- 前端只认 0/1，避免 boolean / nil 歧义
    data.tool = (tonumber(data.tool) == 1 or data.tool == true) and 1 or 0
    if Shop and Shop.GetBagItemCount then
        data.hero_pick_count = Shop:GetBagItemCount(ID, "hero_pick")
    else
        data.hero_pick_count = 0
    end
    if data.talent_index ~= nil then
        local sanitized = self:SanitizeTalentIndex(data.talent_index)
        if sanitized ~= tonumber(data.talent_index) then
            self.Data[ID].talent_index = sanitized
            ClrbSyncTalentNettable(ID, sanitized)
            local pd = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
            if pd then
                pd.talent_index = sanitized
            end
            if IsServer() and ClrbTalentApplyPassives then
                local hero = Util:ID2Hero(ID)
                if hero and not hero:IsNull() then
                    ClrbTalentApplyPassives(ID, hero)
                end
            end
        end
        data.talent_index = sanitized
    end
    data.hidden_talent_indices = self:GetHiddenTalentIndicesList()
    Util:Send2JsID("UI_SelectHero", data, ID)
end

function SelectHero:SendPublicData(ready)
    local data = {
        ready = ready,
        players = InitPlayer.Public.players,
        game_type = MainGame:GetGameType()
    }
    Util:Send2JsBotsSafe("UI_SelectHeroPlayer", data)
end

function SelectHero:UseTalentSkill(_ID)
end

function SelectHero:SendTalentData(_ID)
end
