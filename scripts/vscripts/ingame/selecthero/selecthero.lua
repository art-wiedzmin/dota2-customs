--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if SelectHero == nil then
    SelectHero = class({})
    require("ingame.SelectHero.Config")
    require("ingame.SelectHero.Set")
    require("ingame.SelectHero.Get")
    require("ingame.SelectHero.Func")
    require("ingame.SelectHero.Ui")
end

function SelectHero:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    self.Data[ID].tool = 1
    self.Data[ID].hero_pick_once_key = string.format(
        "hp_%s_%s_%s",
        tostring(ID),
        tostring(math.floor(GameRules:GetGameTime() * 1000)),
        tostring(RandomInt(100000, 999999))
    )
    self:SetRefreshCost(ID)
end

-- 打开英雄选择页面
function SelectHero:HeroPage()
    -- local players = utilex:GetAllPlayer()
    for k, v in pairs(PD.IDs) do
        self:SetRefreshCost(v)
        self:AddHeroToList(v)
        self:OpenPage(v)
        self:TimeStar(v)
        self:SendData(v)
    end
    for _, player_data in pairs(InitPlayer.Public.players) do
        if player_data and player_data.bot and player_data.hero_state == false then
            self:AddHeroToList(player_data.id)
            self.Data[player_data.id].talent_index = self:RandomVisibleTalentIndex()
            local random_slot = math.random(1, 3)
            self:SelectHero(player_data.id, random_slot)
        end
    end
    SelectHero:SendPublicData()
end

--- 选人门禁：已放弃/无效玩家不参与「全员选完」
function SelectHero:CountsForHeroGate(player_row)
    if not player_row or not player_row.state then
        return false
    end
    local ID = player_row.id
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return true
    end
    if Util and Util.ID2IfLeave and Util:ID2IfLeave(ID) then
        return false
    end
    if Util and Util.ID2IfValid and not Util:ID2IfValid(ID) then
        return false
    end
    return true
end

function SelectHero:TryForceRandomHero(ID)
    if not ID or not self.Data or not self.Data[ID] or self.Data[ID].hero_state == true then
        return
    end
    if not self.Data[ID].list or not self.Data[ID].list.slot_1 then
        self:AddHeroToList(ID)
    end
    local slot = math.random(1, 3)
    self:SelectHero(ID, slot)
end

-- 开始倒计时
function SelectHero:TimeStar(ID)
    Timers(1, function()
        if not self.Data[ID] then
            return
        end
        if Util and Util.ID2IfLeave and Util:ID2IfLeave(ID) then
            if self.Data[ID].hero_state ~= true then
                SelectHero:TryForceRandomHero(ID)
            end
            return
        end
        if self.Data[ID].hero_id ~= -1 then return end
        if self.Data[ID].time == 0 then
            local ps = self.Data[ID].pending_slot
            local use_pending = ps and ps >= 1 and ps <= 3
            if use_pending then
                local sk = "slot_" .. ps
                local idx = self.Data[ID].list[sk] and self.Data[ID].list[sk].index
                if type(idx) == "number" and idx > 0 then
                    SelectHero:SelectHero(ID, ps)
                else
                    local random_slot = math.random(1, 3)
                    SelectHero:SelectHero(ID, random_slot)
                end
            else
                local random_slot = math.random(1, 3)
                SelectHero:SelectHero(ID, random_slot)
            end
            self:SendData(ID)
            return
        end
        self.Data[ID].time = self.Data[ID].time - 1
        return 1
    end)
end

--- beidong 地图且配置了 PssiveHero 时：按 HeroList.index 过滤随机池（与其它地图抽取流程相同，仅收窄候选）
function SelectHero:_PassiveMapHeroWhitelistActive()
    return GetMapName() == "beidong" and self.PssiveHero and next(self.PssiveHero) ~= nil
end

function SelectHero:_PassiveWhitelistAllows(index)
    if not index then return false end
    local n = tonumber(index)
    for _, x in ipairs(self.PssiveHero or {}) do
        if tonumber(x) == n then
            return true
        end
    end
    return false
end

function SelectHero:_FilterHeroPoolForPassiveMap(pool)
    if not self:_PassiveMapHeroWhitelistActive() then
        return pool
    end
    local out = {}
    if pool then
        for _, idx in ipairs(pool) do
            if self:_PassiveWhitelistAllows(idx) then
                out[#out + 1] = idx
            end
        end
    end
    return out
end

--- 稀有度池 / 属性池与白名单无交集时：先取「该属性大类 ∩ 白名单」，仍为空则用整条白名单兜底（避免 nil）
function SelectHero:_PassiveWhitelistFallbackPool(tp_key)
    local wl = self.PssiveHero or {}
    local base = self.HeroType and self.HeroType[tp_key]
    local out = {}
    if base then
        for _, idx in ipairs(base) do
            if self:_PassiveWhitelistAllows(idx) then
                out[#out + 1] = idx
            end
        end
    end
    if #out > 0 then
        return out
    end
    local all = {}
    for _, idx in ipairs(wl) do
        all[#all + 1] = tonumber(idx)
    end
    return all
end

function SelectHero:_RollHeroIndexForSlot(tp_key)
    local roll_rare = Util:Weight(self.Probability[tp_key])
    local pool = self:_FilterHeroPoolForPassiveMap(self.Rareness[roll_rare][tp_key])
    local index = pool and #pool > 0 and Util:TabRandom(pool)
    if not index then
        pool = self:_FilterHeroPoolForPassiveMap(self.HeroType[tp_key])
        index = pool and #pool > 0 and Util:TabRandom(pool)
    end
    if not index and self:_PassiveMapHeroWhitelistActive() then
        pool = self:_PassiveWhitelistFallbackPool(tp_key)
        index = pool and #pool > 0 and Util:TabRandom(pool)
    end
    if not index and self:_PassiveMapHeroWhitelistActive() and self.PssiveHero[1] then
        index = tonumber(self.PssiveHero[1])
    end
    return index
end

-- 随机英雄
function SelectHero:AddHeroToList(ID)
    if not ID then return end
    if self.Data[ID].attr_state == false then return end
    self.Data[ID].pending_slot = 0
    -- local tp = self.Data[ID].attr_tp
    -- local tp_key = "tp" .. tp
    -- local list = Util:DeepCopyTab(self.HeroType[tp_key])
    local num = Util:TabCount(self.Data[ID].list)
    for i = 1, 3 do
        local tp_key = "tp" .. i
        local index = self:_RollHeroIndexForSlot(tp_key)
        local slot = "slot_" .. i
        self.Data[ID].list[slot].index = index
        self.Data[ID].list[slot].name = SelectHero:GetHeroName(index)
        self.Data[ID].list[slot].ab_list = SelectHero:GetHeroAbList(index)
        local btp_key = SelectHero:GetBattleTypeKeyForHeroIndex(index)
        self.Data[ID].list[slot].rmb_battle = SelectHero.BattleTypeLabel[btp_key] or ""
        self.Data[ID].list[slot].rmb_abilities = SelectHero:GetRMBAbilityListForHeroIndex(index)
    end
    self:SendData(ID)
end

-- 重新随机
function SelectHero:RollHero(ID)
    if not ID then return end
    -- 先看月卡/季卡（顺延、不扣档位），再全服基础免费（亦不扣 refresh；仅消耗 base_free_left）
    local use_card_free = self:GetCardFreeLeft(ID) > 0
    local use_base_free = (not use_card_free) and (self.Data[ID].base_free_left or 0) > 0
    if not use_card_free and not use_base_free then
        local cost = self.Data[ID].cost
        if not Shop:CostGold(ID, cost) then return end
    end
    if use_card_free then
        self.Data[ID].card_bonus_used = (self.Data[ID].card_bonus_used or 0) + 1
    elseif use_base_free then
        self.Data[ID].base_free_left = self.Data[ID].base_free_left - 1
    else
        self.Data[ID].refresh = self.Data[ID].refresh - 1
    end
    self:SetRefreshCost(ID)
    self:AddHeroToList(ID)
end

-- 增加随机次数
function SelectHero:AddRefresh(ID)
    if not ID then return end
    self.Data[ID].refresh = self.Data[ID].refresh + 1
    self:SendData(ID)
end

-- 选英雄
function SelectHero:SelectHero(ID, slot)
    if not ID or not slot then return end
    if self.Data[ID].hero_state then return end
    -- Shop:SyncGold(ID)
    self.Data[ID].hero_state = true
    local slot_key = "slot_" .. slot
    -- self.Data[ID].face = face
    local index = self.Data[ID].list[slot_key].index
    self.Data[ID].hero_id = index
    local heroname = self:GetHeroName(index)
    -- heroname="npc_dota_hero_storm_spirit"
    self.Data[ID].hero_name = heroname
    InitPlayer:SetHeroState(ID, heroname, index)
    SelectHero:SendPublicData()
    -- 所有玩家是否全部选完英雄
    if self:IsAllSelectHero() then
        -- 所有玩家创建英雄进入游戏
        self:PlayerGetHero()
    end
end

-- 所有玩家是否全部选完英雄
function SelectHero:IsAllSelectHero()
    for k, v in pairs(InitPlayer.Public.players) do
        if self:CountsForHeroGate(v) and v.hero_state == false then
            return false
        end
    end
    return true
end

-- 所有玩家创建英雄进入游戏
function SelectHero:PlayerGetHero()
    --进入备战时间
    SelectHero:SendPublicData(true)
    --15秒后再进入游戏
    local time = 15
    if IsInToolsMode() then
        time = 0
    end
    Timers(time, function()
        for k, v in pairs(InitPlayer.Public.players) do
            local hero_name = v.hero_name
            local ID = v.id
            if v.bot then
                if v.hero_spawned then
                    goto continue
                end
                v.hero_spawned = true
                -- 与真人复活一致：HeroData:HeroPos()（随机 Rebron 点周围采样 + 地图中心毒圈/路径约束），不用 init* info_target
                local pos = HeroData:HeroPos()
                if not pos then
                    pos = HeroData:HeroInitPos(ID)
                end
                if not pos then
                    pos = Vector(0, 0, 0)
                end
                CreateUnitByNameAsync(hero_name, pos, true, nil, nil, v.team, function(bot_hero)
                    if not bot_hero or bot_hero:IsNull() then
                        v.hero_spawned = false
                        return
                    end
                    bot_hero.pseudo_player_id = ID
                    if PD[ID] then
                        PD[ID].pseudo_hero = bot_hero
                    end
                    InitPlayer:HeroInit(ID, bot_hero)
                end)
                goto continue
            end
            local player = Util:ID2Player(ID)
            if player then
                player:SetSelectedHero(hero_name)
                self:ClosePage(ID)
            else
                -- 掉线：无 HPlayer，不能 SetSelectedHero；异步出真后等重连绑实体（见 ApplyEnginePickForPlayer）
                if v.hero_spawned then
                    goto continue
                end
                v.hero_spawned = true
                v.clrb_defer_inithero_until_reconnect = true
                v.clrb_used_async_hero_spawn = true
                local pos = HeroData:HeroPos()
                if not pos then
                    pos = HeroData:HeroInitPos(ID)
                end
                if not pos then
                    pos = Vector(0, 0, 0)
                end
                CreateUnitByNameAsync(hero_name, pos, true, nil, nil, v.team, function(h)
                    if not h or h:IsNull() then
                        v.hero_spawned = false
                        return
                    end
                    -- 重连已用 CreateHeroForPlayer 注册过：丢弃迟到的异步实体，避免双英雄
                    if v.clrb_engine_reregister_done then
                        pcall(function()
                            if UTIL_Remove then
                                UTIL_Remove(h)
                            else
                                h:RemoveSelf()
                            end
                        end)
                        return
                    end
                    if HeroData and HeroData.SetHeroIndex then
                        HeroData:SetHeroIndex(ID, h)
                    end
                    h:SetControllableByPlayer(ID, true)
                    if h.SetPlayerID then
                        pcall(function()
                            h:SetPlayerID(ID)
                        end)
                    end
                    if PD[ID] == nil then
                        PD[ID] = {}
                    end
                    PD[ID].clrb_dc_hero = h
                    -- 异步出真完成时玩家已重连：立即绑 CPlayer，避免首连 HUD 金币仍为 0
                    if Util and Util.ID2Player and Util:ID2Player(ID) and
                        SelectHero and SelectHero.ApplyEnginePickForPlayer then
                        Timers(0, function()
                            if not PlayerResource or not PlayerResource.IsValidPlayer or
                                not PlayerResource:IsValidPlayer(ID) then
                                return
                            end
                            SelectHero:ApplyEnginePickForPlayer(ID, hero_name, false)
                        end)
                    end
                end)
            end
            ::continue::
        end
    end)
end

--- 断线异步出真后重连：用 CreateHeroForPlayer 走引擎正规注册（客户端 HUD 金币依赖此路径）
function SelectHero:ClrbRecreateHeroViaEngine(ID, hero_name)
    if not ID or not CreateHeroForPlayer then
        return false
    end
    local p = PlayerResource and PlayerResource.GetPlayer and PlayerResource:GetPlayer(ID)
    if not p or p:IsNull() then
        return false
    end
    local d = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
    local old
    if HeroData and HeroData.GetHero then
        old = HeroData:GetHero(ID)
    end
    if (not old or old:IsNull()) and PD and PD[ID] and PD[ID].clrb_dc_hero then
        old = PD[ID].clrb_dc_hero
    end

    local pick_name = hero_name
    if (not pick_name or pick_name == "") and d then
        pick_name = d.hero_name
    end
    if old and not old:IsNull() and old.GetUnitName then
        pick_name = old:GetUnitName()
    end
    if type(pick_name) ~= "string" or pick_name == "" then
        return false
    end

    local pos
    if old and not old:IsNull() then
        pos = old:GetAbsOrigin()
    end
    if not pos and HeroData and HeroData.HeroInitPos then
        pos = HeroData:HeroInitPos(ID)
    end

    local saved_gold = 0
    if PlayerResource and PlayerResource.GetGold then
        saved_gold = PlayerResource:GetGold(ID) or 0
    end

    if old and not old:IsNull() then
        pcall(function()
            old:ForceKill(false)
        end)
        pcall(function()
            if UTIL_Remove then
                UTIL_Remove(old)
            elseif old.RemoveSelf then
                old:RemoveSelf()
            end
        end)
    end

    if PD and PD[ID] then
        PD[ID].clrb_dc_hero = nil
    end
    if HeroData and HeroData.Data and HeroData.Data[ID] then
        HeroData.Data[ID].init = false
        HeroData.Data[ID].hero_index = -1
    end

    local new_hero = CreateHeroForPlayer(pick_name, p)
    if not new_hero or new_hero:IsNull() then
        return false
    end

    pcall(function()
        p:SetAssignedHeroEntity(new_hero)
    end)
    pcall(function()
        new_hero:SetControllableByPlayer(ID, true)
    end)
    pcall(function()
        if new_hero.SetPlayerID then
            new_hero:SetPlayerID(ID)
        end
    end)
    pcall(function()
        if new_hero.SetOwner then
            new_hero:SetOwner(p)
        end
    end)
    if HeroData and HeroData.SetHeroIndex then
        HeroData:SetHeroIndex(ID, new_hero)
    end
    if pos then
        pcall(function()
            FindClearSpaceForUnit(new_hero, pos, true)
            new_hero:SetAbsOrigin(pos)
        end)
    end

    if d then
        d.clrb_used_async_hero_spawn = false
        d.clrb_engine_reregister_done = true
        d.clrb_defer_inithero_until_reconnect = false
    end

    if Util and Util.ClrbForcePlayerGoldResync then
        Util:ClrbForcePlayerGoldResync(ID, saved_gold)
    elseif Util and Util.ClrbSchedulePlayerGoldResync then
        Util:ClrbSchedulePlayerGoldResync(ID)
    end

    Timers(0, function()
        if not HeroData or not HeroData.GetHero or not HeroData.InitHero then
            return
        end
        local hh = HeroData:GetHero(ID)
        if hh and not hh:IsNull() then
            HeroData:InitHero(ID, hh)
        end
    end)

    return true
end

--- 重连：把本局已生成实体绑回 CPlayer，引擎「当前英雄」与选人才一致（re_connect 里会调）
function SelectHero:ApplyEnginePickForPlayer(ID, hero_name, _)
    if not ID then
        return
    end
    local p = PlayerResource and PlayerResource.GetPlayer and PlayerResource:GetPlayer(ID)
    if not p or p:IsNull() then
        return
    end
    local d = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
    if d then
        d.clrb_defer_inithero_until_reconnect = false
    end

    -- 断线期间 CreateUnitByNameAsync 出的英雄客户端金币不同步，首连必须用 CreateHeroForPlayer 重建
    if d and d.clrb_used_async_hero_spawn and not d.clrb_engine_reregister_done then
        if self:ClrbRecreateHeroViaEngine(ID, hero_name) then
            self:ClosePage(ID)
            return
        end
    end

    local h = HeroData and HeroData.GetHero and HeroData:GetHero(ID)
    if (not h or h:IsNull()) and PD and PD[ID] and PD[ID].clrb_dc_hero then
        h = PD[ID].clrb_dc_hero
    end
    if (not h or h:IsNull()) and PlayerResource and PlayerResource.GetSelectedHeroEntity then
        h = PlayerResource:GetSelectedHeroEntity(ID)
    end

    local pick_name = hero_name
    if (not pick_name or pick_name == "") and d then
        pick_name = d.hero_name
    end
    if h and not h:IsNull() and h.GetUnitName then
        pick_name = h:GetUnitName()
    end

    if h and not h:IsNull() and p.SetAssignedHeroEntity then
        pcall(function()
            p:SetAssignedHeroEntity(h)
        end)
        pcall(function()
            h:SetControllableByPlayer(ID, true)
        end)
        if h.SetPlayerID then
            pcall(function()
                h:SetPlayerID(ID)
            end)
        end
        if PlayerResource and PlayerResource.SetOverrideSelectionEntity then
            pcall(function()
                PlayerResource:SetOverrideSelectionEntity(ID, h)
            end)
        end
    end

    if h and not h:IsNull() and HeroData and HeroData.Data and HeroData.Data[ID] and
        HeroData.Data[ID].init == false and HeroData.InitHero then
        Timers(0, function()
            if not HeroData or not HeroData.GetHero or not HeroData.InitHero then
                return
            end
            local hh = HeroData:GetHero(ID)
            if hh and not hh:IsNull() then
                HeroData:InitHero(ID, hh)
            end
        end)
    end

    self:ClosePage(ID)

    if Util and Util.ClrbSchedulePlayerGoldResync then
        Util:ClrbSchedulePlayerGoldResync(ID)
    end
end

-- 离开游戏
function SelectHero:ExitGame(ID)
    if not ID then return end
    self.Data[ID].exit = true
    self:SendData(ID)
end

SelectHero.HeroPickInsufficientMsg = "英雄自选卡数量不足"

-- 向客户端发送全英雄自选列表（仅 Rareness 池内英雄）
function SelectHero:SendDevHeroPickerList(ID)
    if not ID then return end
    local list = {}
    for hero_name, def in pairs(self.HeroList) do
        if type(def) == "table" and type(def.index) == "number" and type(hero_name) == "string" then
            if self:IsHeroPickableInRareness(def.index) then
                local hero_tp = self:GetHeroAttrTypeByIndex(def.index, def)
                list[#list + 1] = { index = def.index, name = hero_name, hero_tp = hero_tp }
            end
        end
    end
    table.sort(list, function(a, b) return a.index < b.index end)
    local count = Shop and Shop.GetBagItemCount and Shop:GetBagItemCount(ID, "hero_pick") or 0
    Util:Send2JsID("UI_SelectHeroDevHeroes", { heroes = list, hero_pick_count = count }, ID)
end

--- 仅更新自选提示（不 SendData，避免打断英雄列表渲染）
function SelectHero:PushHeroPickHint(ID, msg, show_notify)
    if not ID or not self.Data[ID] then
        return
    end
    local text = msg or ""
    self.Data[ID].hero_pick_hint = text
    Util:Send2JsID("UI_SelectHeroHeroPickHint", { hint = text }, ID)
    Util:Send2JsID("UI_SelectHeroDevHeroes", { pick_hint = text }, ID)
    if show_notify and text ~= "" and NotifyUtil and NotifyUtil.BottomUnique then
        NotifyUtil:BottomUnique(ID, text, 4, "#e8a050", NotifyUtil.STYLE_BlackBack_Alpha)
    end
end

function SelectHero:ClearHeroPickHint(ID)
    self:PushHeroPickHint(ID, "", false)
end

--- 选人阶段是否允许打开/使用全英雄自选（已开页、已选属性、尚未锁定英雄）
function SelectHero:CanUseHeroPickFlow(ID)
    if not ID or not self.Data[ID] then
        return false
    end
    if not self.Data[ID].page then
        return false
    end
    if self.Data[ID].hero_state then
        return false
    end
    if self.Data[ID].hero_pick_used then
        return false
    end
    if self.Data[ID].hero_pick_pending then
        return false
    end
    if self.Data[ID].attr_state == false then
        return false
    end
    return true
end

-- 消耗英雄自选卡后按 HeroList 编号直接选定英雄（不走三槽）
function SelectHero:ApplyPickHeroByIndex(ID, hero_index)
    if not ID or not hero_index then return end
    if not self.Data[ID] or self.Data[ID].hero_state then return end
    local idx = tonumber(hero_index)
    if not idx then return end
    if not self:IsHeroPickableInRareness(idx) then return end
    local heroname = self:GetHeroName(idx)
    if not heroname or heroname == "" then return end
    self.Data[ID].hero_state = true
    self.Data[ID].hero_pick_used = true
    self.Data[ID].hero_pick_pending = false
    self.Data[ID].hero_id = idx
    self.Data[ID].hero_name = heroname
    self:ClearHeroPickHint(ID)
    InitPlayer:SetHeroState(ID, heroname, idx)
    self:SendPublicData()
    self:SendData(ID)
    if self:IsAllSelectHero() then
        self:PlayerGetHero()
    end
end

function SelectHero:PickHeroWithCard(ID, hero_index)
    if not ID or not hero_index then return end
    if not self:CanUseHeroPickFlow(ID) then
        if self.Data[ID] and (self.Data[ID].hero_pick_pending or self.Data[ID].hero_pick_used) then
            self:PushHeroPickHint(ID, "本局已使用英雄自选卡", true)
        end
        return
    end
    if Util:IsPseudoPlayerID(ID) then return end

    local count = Shop and Shop.GetBagItemCount and Shop:GetBagItemCount(ID, "hero_pick") or 0
    if count < 1 then
        self:PushHeroPickHint(ID, self.HeroPickInsufficientMsg, true)
        return
    end

    if not Http or not Http.POST then
        self:PushHeroPickHint(ID, self.HeroPickInsufficientMsg, true)
        return
    end

    local once_key = self.Data[ID].hero_pick_once_key
    if not once_key or once_key == "" then
        once_key = string.format(
            "hp_%s_%s_%s",
            tostring(ID),
            tostring(math.floor(GameRules:GetGameTime() * 1000)),
            tostring(RandomInt(100000, 999999))
        )
        self.Data[ID].hero_pick_once_key = once_key
    end

    -- 先占位，避免 UI 卡顿连点发出多次 /bag/use
    self.Data[ID].hero_pick_pending = true
    self:SendData(ID)

    Http:POST("/bag/use", {
        item_key = "hero_pick",
        scene = "select_hero",
        once_key = once_key,
    }, ID, function(keys)
        if not SelectHero.Data[ID] then
            return
        end
        if keys.code == 200 and keys.data then
            SelectHero.Data[ID].hero_pick_used = true
            SelectHero.Data[ID].hero_pick_pending = false
            if Shop and Shop.SetBagServerData and keys.data.bag then
                Shop:SetBagServerData(ID, keys.data.bag)
            end
            SelectHero:ApplyPickHeroByIndex(ID, hero_index)
        else
            SelectHero.Data[ID].hero_pick_pending = false
            local msg = self.HeroPickInsufficientMsg
            if keys and keys.message and keys.message ~= "" then
                msg = keys.message
            end
            SelectHero:PushHeroPickHint(ID, msg, true)
            SelectHero:SendData(ID)
        end
    end)
end

-- 工具模式免卡自选；正式对局消耗英雄自选卡
function SelectHero:DevPickHeroByIndex(ID, hero_index)
    if IsInToolsMode() then
        self:ApplyPickHeroByIndex(ID, hero_index)
        return
    end
    self:PickHeroWithCard(ID, hero_index)
end
