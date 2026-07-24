--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function CustomSets:GameRulesSet()
    local mode = GameRules:GetGameModeEntity()
    -- mode:SetCustomAttributeDerivedStatValue(9, 0.5)
    -- if not mode then return end
    -- mode:ClearModifyGoldFilter()
    mode:SetUseCustomHeroLevels(true)
    mode:SetCustomHeroMaxLevel(45)
    mode:SetCustomXPRequiredToReachNextLevel(CustomSets.Xptab)
    -- 中立储藏室视角；英雄身上「中立道具栏」需引擎允许中立物品系统，否则自定义 item 放不进中立格、HUD 也不显示
    mode:SetNeutralStashTeamViewOnlyEnabled(true)
    -- 禁用引擎默认昼夜循环，由 MainGame:DayNightTick 按自定义时长驱动
    mode:SetDaynightCycleDisabled(true)
    -- 是否禁用死亡遮罩（灰色的遮罩）
    mode:SetDeathOverlayDisabled(true)
    -- 是否允许买活
    mode:SetBuybackEnabled(false)
    -- 是否在英雄死亡时扣除金钱
    mode:SetLoseGoldOnDeath(false)
    -- 是否在英雄死亡的时候移除幻象
    mode:SetRemoveIllusionsOnDeath(true)
    -- 是否启用选择英雄时的金钱惩罚（超时每秒扣钱）
    mode:SetSelectionGoldPenaltyEnabled(false)
    -- 是否禁用战斗事件（左下角的战斗消息）
    -- mode:SetHudCombatEventsDisabled(true)
    -- 强制默认 HUD，忽略玩家装备的界面皮肤（防第三方 HUD 小地图装饰点击卡键）
    mode:SetForcedHUDSkin("default")
    -- 允许将物品发送到中立储藏室。
    mode:SetNeutralStashEnabled(true)
    -- 是否允许野怪掉中立物品
    mode:SetAllowNeutralItemDrops(false)
    -- 关闭/打开获得金币时的声音
    -- mode:SetGoldSoundDisabled(false)
    -- 关闭/打开「购买物品到储藏室」。true=禁买到储藏室；false=允许买到储藏室（是否算「不站店」以引擎对自定义图表现为准，勿与 Universal 混为一谈）
    mode:SetStashPurchasingDisabled(false)

    -- mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE, 0.1)
    -- 全才：每点力量/敏捷/智力转化为攻击力（官方默认 0.45，本图 0.6）
    mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_ALL_DAMAGE, 0.6)
    mode:SetBotThinkingEnabled(true)

    mode:SetPauseEnabled(false)
    -- 关闭战争迷雾 就改这个
    -- mode:SetFogOfWarDisabled(true)

    SendToServerConsole('dota_max_physical_items_purchase_limit 999');

    -- GameRules:RemoveItemFromWhiteList("")
    -- 初始金钱
    GameRules:SetStartingGold(500)
    -- 关闭队伍选择时间
    local ReadyTime = 10
    if IsInToolsMode() then ReadyTime = 300 end
    GameRules:SetCustomGameSetupAutoLaunchDelay(ReadyTime)
    -- 选择英雄阶段的持续时间
    GameRules:SetHeroSelectionTime(300)
    -- 设置英雄选择后的决策时间
    GameRules:SetStrategyTime(0)
    -- 设置 天辉vs夜魇 界面的显示时间
    GameRules:SetShowcaseTime(0)
    -- 进入游戏后号角吹响前的准备时间
    GameRules:SetPreGameTime(0)
    -- 设置在结束游戏后服务器与玩家断线前的时间
    GameRules:SetPostGameTime(600)
    -- 勿开启 SetCustomGameAllowBattleMusic / HeroPickMusic(false)：会导致本图战斗音效、语音等全部失效。
    -- GameRules:SetCustomGameAllowBattleMusic(false)
    -- GameRules:SetCustomGameAllowHeroPickMusic(false)
    -- GameRules:SetCustomGameAllowMusicAtGameStart(false)
    -- 是否隐藏顶部的英雄击杀信息
    -- GameRules:SetHideKillMessageHeaders(true);
    -- true：站在任意一种「商店范围」内时，主店/边店/神秘商店货单合并可买，不必再跑到神秘商店；不是「全地图任意位置都能买」
    GameRules:SetUseUniversalShopMode(true)
    -- 是否允许英雄重生
    GameRules:SetHeroRespawnEnabled(false)
    -- 是否允许选择相同英雄
    GameRules:SetSameHeroSelectionEnabled(true)

    GameRules:SpawnNeutralCreeps()

    if GetMapName() == "rank_5v5" then
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 5)
    end
    if GetMapName() == "rank_1v1" or GetMapName() == "beidong" then
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_3, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_4, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_5, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_6, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_7, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_8, 1)
    end
    if GetMapName() == "rank_3x4" then
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 3)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 3)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 3)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 3)
    end
    -- 永远白天
    -- GameRules:SetTimeOfDay(0.5)
end