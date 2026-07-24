--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Shop:OpenPage(ID)
    self.Data[ID].page = true
    self:SendData(ID)
end

--- 打开通行证：先推本地缓存，再向服务端同步 card
function Shop:OpenBattlePassPage(ID)
    if not ID or not self.Data[ID] then
        return
    end
    self.Data[ID].page = true
    self:SendData(ID)
    if self.PushPassSeasonToClient then
        self:PushPassSeasonToClient(ID)
    end
    self:RefreshCard(ID)
end

function Shop:ClosePage(ID)
    self.Data[ID].page = false
    if self.FlushPendingOutBagLoadout then
        self:FlushPendingOutBagLoadout(ID)
    end
    self:SendData(ID)
end

function Shop:SetShopServerData(ID, data, first_recharge_double_open)
    if not ID or not data then
        return
    end
    --print(data)
    self.Data[ID].gold = data.gold
    self.Data[ID].card1 = data.card1
    self.Data[ID].card2 = data.card2
    self.Data[ID].card1day = data.gold_day
    self.Data[ID].card2day = data.card2_day
    self.Data[ID].freeday = data.free_day
    self.Data[ID].dw_free_day = data.dw_free_day ~= nil and data.dw_free_day or 1
    self.Data[ID].dw_free_open = data.dw_free_open == true or data.dw_free_open == 1
    if data.dw_free_event_status ~= nil then
        self.Data[ID].dw_free_event_status = data.dw_free_event_status
    end
    self.Data[ID].dw_30_buy = data.dw_30_buy or 0
    self.Data[ID].dw_68_buy = data.dw_68_buy or 0
    self.Data[ID].dw_128_buy = data.dw_128_buy or 0
    if HolidayPack and HolidayPack.OnShopDataUpdated then
        HolidayPack:OnShopDataUpdated(ID)
    end

    if first_recharge_double_open == nil then
        first_recharge_double_open = true
    end
    self.Data[ID].first_recharge_double_open = first_recharge_double_open

    -- 全服无限首充开：各档按首充仍在展示(3倍图)；关闭：用库内 gold6… 标记(0=首充在,1=已用走2倍)
    if first_recharge_double_open then
        self.Data[ID].double.gold6 = 0
        self.Data[ID].double.gold30 = 0
        self.Data[ID].double.gold68 = 0
        self.Data[ID].double.gold128 = 0
        self.Data[ID].double.gold328 = 0
        self.Data[ID].double.gold648 = 0
        self.Data[ID].double.gold1280 = 0
    else
        self.Data[ID].double.gold6 = data.gold6
        self.Data[ID].double.gold30 = data.gold30
        self.Data[ID].double.gold68 = data.gold68
        self.Data[ID].double.gold128 = data.gold128
        self.Data[ID].double.gold328 = data.gold328
        self.Data[ID].double.gold648 = data.gold648
        self.Data[ID].double.gold1280 = data.gold1280
    end
    if Person and Person.ApplyDailyGameBonusFromUser then
        Person:ApplyDailyGameBonusFromUser(ID, data)
    end
    -- 选人 UI 可能比 /user/login 早开：到账后刷新月卡/季卡免费档位
    if SelectHero and SelectHero.OnShopDataUpdated then
        SelectHero:OnShopDataUpdated(ID)
    end
end

-- 同步服务端 card 表数据到局内 Shop.Data[ID].card
function Shop:SetCardServerData(ID, data)
    if not ID or not data then
        return
    end
    local card = self.Data[ID] and self.Data[ID].card
    if not card then
        return
    end
    if data.state ~= nil then card.state = data.state end
    if data.exp ~= nil then card.exp = data.exp end
    if data.get_level ~= nil then card.get_level = data.get_level end
    if data.get_level_premium ~= nil then card.get_level_premium = data.get_level_premium end
    if data.daygamecount ~= nil then card.daygamecount = data.daygamecount end
    if data.daykillcount ~= nil then card.daykillcount = data.daykillcount end
    if data.daytop1count ~= nil then card.daytop1count = data.daytop1count end
    if data.weektop1count ~= nil then card.weektop1count = data.weektop1count end
    if data.weekkillcount ~= nil then card.weekkillcount = data.weekkillcount end
    if data.weekmap1top1 ~= nil then card.weekmap1top1 = data.weekmap1top1 end
    if data.weekmap2top1 ~= nil then card.weekmap2top1 = data.weekmap2top1 end
    if data.weekmap3top1 ~= nil then card.weekmap3top1 = data.weekmap3top1 end
    if data.taskday1 ~= nil then card.taskday1 = data.taskday1 end
    if data.taskday2 ~= nil then card.taskday2 = data.taskday2 end
    if data.taskday3 ~= nil then card.taskday3 = data.taskday3 end
    if data.taskday4 ~= nil then card.taskday4 = data.taskday4 end
    if data.taskday5 ~= nil then card.taskday5 = data.taskday5 end
    if data.taskday6 ~= nil then card.taskday6 = data.taskday6 end
    if data.taskweed1 ~= nil then card.taskweed1 = data.taskweed1 end
    if data.taskweed2 ~= nil then card.taskweed2 = data.taskweed2 end
    if data.taskweed3 ~= nil then card.taskweed3 = data.taskweed3 end
    if data.taskweed4 ~= nil then card.taskweed4 = data.taskweed4 end
    if data.taskweed5 ~= nil then card.taskweed5 = data.taskweed5 end
    if data.taskweed6 ~= nil then card.taskweed6 = data.taskweed6 end
    self:SendData(ID)
end

--- 应用服务端通行证赛季热更新的称号/特效展示（金豆规则不变）
--- 服务端只下发 itemKey；图标走本地 ItemList（与礼包 image_key 同理）
function Shop:ApplyPassCosmetics(ID, cosmetics)
    if not cosmetics or type(cosmetics) ~= "table" then
        return
    end
    local function pick(t, a, b, c)
        if not t then
            return nil
        end
        return t[a] or t[b] or t[c]
    end
    local LOCAL_SEASON = {
        legacy = {
            free = "title_clxz",
            prem = "title_hsbh",
            fx = "attack_lxhs",
            kind = "attack",
            deadline = "截止日期：2026.08.07",
        },
        ["2026-08"] = {
            free = "title_clls",
            prem = "title_hdlm",
            fx = "effect_lzqz",
            kind = "effect",
            deadline = "截止日期：2026.09.07",
        },
        ["2026-09"] = {
            free = "title_clmy",
            prem = "title_xxqc",
            fx = "attack_atv3",
            kind = "attack",
            deadline = "截止日期：2026.10.07",
        },
        ["2026-10"] = {
            free = "title_clzw",
            prem = "title_rzzl",
            fx = "effect_txhb",
            kind = "effect",
            deadline = "截止日期：2026.11.07",
        },
    }
    local seasonId = pick(cosmetics, "seasonId", "season_id", "seasonid")
    local localRow = seasonId and LOCAL_SEASON[tostring(seasonId)] or nil
    -- 扁平键优先；缺省时用本地赛季表补全（与礼包 image_key 同理）
    local freeKey = cosmetics.free_title_key or cosmetics.pass_free_title_key
        or (localRow and localRow.free)
    local premKey = cosmetics.premium_title_key or cosmetics.pass_premium_title_key
        or (localRow and localRow.prem)
    local fxKey = cosmetics.premium_effect_key or cosmetics.pass_premium_effect_key
        or (localRow and localRow.fx)
    local freeTitle = pick(cosmetics, "freeTitle", "free_title", "freetitle")
    local premTitle = pick(cosmetics, "premiumTitle", "premium_title", "premiumtitle")
    local premFx = pick(cosmetics, "premiumEffect", "premium_effect", "premiumeffect")
    if freeKey then
        freeTitle = freeTitle or {}
        freeTitle.itemKey = freeKey
        freeTitle.level = tonumber(cosmetics.free_title_level) or freeTitle.level or 30
        freeTitle.name = cosmetics.free_title_name or freeTitle.name
    end
    if premKey then
        premTitle = premTitle or {}
        premTitle.itemKey = premKey
        premTitle.level = tonumber(cosmetics.premium_title_level) or premTitle.level or 30
        premTitle.name = cosmetics.premium_title_name or premTitle.name
    end
    if fxKey then
        premFx = premFx or {}
        premFx.itemKey = fxKey
        premFx.level = tonumber(cosmetics.premium_effect_level) or premFx.level or 1
        premFx.name = cosmetics.premium_effect_name or premFx.name
        premFx.kind = cosmetics.premium_effect_kind or premFx.kind
            or (localRow and localRow.kind) or "attack"
    end
    -- 从本地 ItemList 补名称（不依赖服务端 icon）
    local function fill_from_itemlist(entry)
        if not entry then
            return
        end
        local itemKey = entry.itemKey or entry.item_key
        if not itemKey then
            return
        end
        entry.itemKey = itemKey
        local meta = self.ItemList and self.ItemList[itemKey]
        if meta then
            if (not entry.name or entry.name == "") and meta.name then
                entry.name = meta.name
            end
        end
    end
    fill_from_itemlist(freeTitle)
    fill_from_itemlist(premTitle)
    fill_from_itemlist(premFx)

    cosmetics.freeTitle = freeTitle
    cosmetics.premiumTitle = premTitle
    cosmetics.premiumEffect = premFx
    cosmetics.seasonId = seasonId or cosmetics.seasonId
    cosmetics.season_id = cosmetics.seasonId
    cosmetics.deadlineText = pick(cosmetics, "deadlineText", "deadline_text", "deadlinetext")
        or (localRow and localRow.deadline)
        or cosmetics.deadlineText
    cosmetics.deadline_text = cosmetics.deadlineText
    cosmetics.free_title_key = freeTitle and freeTitle.itemKey
    cosmetics.premium_title_key = premTitle and premTitle.itemKey
    cosmetics.premium_effect_key = premFx and premFx.itemKey
    cosmetics.premium_effect_kind = premFx and premFx.kind

    self.PassCosmetics = cosmetics
    if self.Data[ID] then
        self.Data[ID].pass_cosmetics = cosmetics
    end

    local static = self.CardStaticData
    if static and static.free and static.premium then
        if freeTitle and freeTitle.name and freeTitle.level then
            static.free.title_by_level = {
                [tonumber(freeTitle.level) or 30] = freeTitle.name,
            }
        end
        if premTitle and premTitle.name and premTitle.level then
            static.premium.title_by_level = {
                [tonumber(premTitle.level) or 30] = premTitle.name,
            }
        end
        if premFx and premFx.name and premFx.level then
            static.premium.effect_by_level = {
                [tonumber(premFx.level) or 1] = premFx.name,
            }
        end
    end

    -- 独立小包推送（避免塞进超大 UI_Shop 被截断）
    if self.PushPassSeasonToClient then
        self:PushPassSeasonToClient(ID)
    end
end

--- 仅推送赛季键给通行证 UI（小 payload + NetTable）
function Shop:PushPassSeasonToClient(ID)
    if not ID then
        return
    end
    local cosmetics = self.PassCosmetics
        or (self.Data[ID] and self.Data[ID].pass_cosmetics)
    if not cosmetics or type(cosmetics) ~= "table" then
        return
    end
    local season_id = tostring(
        cosmetics.season_id or cosmetics.seasonId or cosmetics.seasonid or "legacy"
    )
    local free_key = tostring(
        cosmetics.free_title_key
            or (cosmetics.freeTitle and cosmetics.freeTitle.itemKey)
            or ""
    )
    local prem_key = tostring(
        cosmetics.premium_title_key
            or (cosmetics.premiumTitle and cosmetics.premiumTitle.itemKey)
            or ""
    )
    local fx_key = tostring(
        cosmetics.premium_effect_key
            or (cosmetics.premiumEffect and cosmetics.premiumEffect.itemKey)
            or ""
    )
    local fx_kind = tostring(
        cosmetics.premium_effect_kind
            or (cosmetics.premiumEffect and cosmetics.premiumEffect.kind)
            or "attack"
    )
    local deadline_text = tostring(
        cosmetics.deadline_text or cosmetics.deadlineText or ""
    )
    local payload = {
        season_id = season_id,
        free_title_key = free_key,
        premium_title_key = prem_key,
        premium_effect_key = fx_key,
        premium_effect_kind = fx_kind,
        deadline_text = deadline_text,
    }
    Util:Send2JsID("UI_PassSeason", payload, ID)
    if CustomNetTables then
        CustomNetTables:SetTableValue("clrb_pass_season", tostring(ID), payload)
    end
end
