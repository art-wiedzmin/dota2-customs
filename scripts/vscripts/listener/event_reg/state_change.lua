--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function CustomSets:State_Change(keys)
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_INIT then
		--print("000")
	elseif state == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
	elseif state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		--加载游戏
		InitPlayer:Init_Public()
		--加载玩家
		InitPlayer:Init_Player()
	elseif state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		InitPlayer:Init_ID_And_Server()
		Boot:AddBootPlayer()
		--selecthero
		--print("选英雄")
		Timers(1, function()
			Server:LoadWhiteList()
			SelectHero:HeroPage()
		end)
	elseif state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		--print("111")
	elseif state == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
		--print("222")
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		--print("333")
		Timers(1, function()
			--加载英雄
			InitPlayer:Init_Hero()
			--进入游戏
			MainGame:GameStart()
		end)
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		CustomSets.PauseLimitUsed = {}
		CustomSets._PauseIncDebounce = {}
		CustomSets:StartHeroPassiveExpTimer()
		Timers(0.1, function()
			MainGame:GameReady()
		end)
		-- MainGame:GameReady()
	elseif state == DOTA_GAMERULES_STATE_POST_GAME then
		--print("555")
	elseif state == DOTA_GAMERULES_STATE_DISCONNECT then
		--print("666")
		BotAI:CleanupForSettlementUI()
	end
end