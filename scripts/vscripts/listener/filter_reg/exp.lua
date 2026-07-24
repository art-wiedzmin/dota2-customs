--[[
    experience  (string)= 90  (number)
	hero_entindex_const  (string)= 1685  (number)
	player_id_const  (string)= 0  (number)
	reason_const  (string)= 2  (number)
    source_entindex_const  (string)= 1574  (number)
]]
function CustomSets:Exp_Filter(key)
	--print("Exp_Filter")
	local exp = key.experience
	local heroindex = key.hero_entindex_const
	local hero = Util:Index2Entity(heroindex)
	local ID = key.player_id_const
	if not hero or hero:IsNull() or not hero.GetLevel then
		return true
	end
	-- 击杀英雄经验：保留默认击杀经验的 40%
	local hero_kill_xp = DOTA_ModifyXP_HeroKill
	if hero_kill_xp == nil then hero_kill_xp = 1 end
	if key.reason_const == hero_kill_xp then
		exp = math.floor(exp * 40 / 100 + 0.5)
	end
	if ID then
		local jyjc = HeroData:GetSX(ID, "jyjc")
		exp = math.floor((100 + jyjc) * exp / 100)
		local djsx = HeroData:GetSX(ID, "djsx")
		if hero:GetLevel() >= djsx then
			exp = 0
		end
		-- 机器人经验：提高 60%
		local is_bot = false
		if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
			is_bot = true
		end
		if not is_bot and PlayerResource and PlayerResource.GetPlayerName then
			local n = PlayerResource:GetPlayerName(ID)
			if n and string.match(n, "^bot_player_%d+$") then
				is_bot = true
			end
		end
		if is_bot then
			exp = math.floor(exp * 1.6 + 0.5)
		end
	end
	key.experience = exp
	return true
end

--- 全英雄被动经验：每秒 = 基础 + 游戏内已进行分钟 * 0.5（含第一分钟），经 Exp_Filter 与 AddExperience
function CustomSets:ApplyHeroPassiveExpOnce()
	local st = HeroData and HeroData.Static
	if not st then
		return
	end
	local base = tonumber(st.hero_passive_exp_base_per_sec) or 3
	-- local gr = GameRules
	-- if not gr or not gr.GetDOTATime then
	-- 	return
	-- end
	-- local t = gr:GetDOTATime(true, true) or 0
	-- if t < 0 then
	-- 	t = 0
	-- end
	local minutes = MainGame:GetTimeMin()
	local per_sec = base + minutes * 0.5
	local xpi = math.max(0, math.floor(per_sec + 0.5))
	if xpi < 1 then
		return
	end
	local r = DOTA_ModifyXP_Unspecified
	if r == nil then
		r = 0
	end
	if not PlayerResource or not PlayerResource.GetSelectedHeroEntity then
		return
	end
	for pid = 0, DOTA_MAX_PLAYERS do
		if PlayerResource.IsValidPlayerID and PlayerResource:IsValidPlayerID(pid) then
			local skip_bot = false
			if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(pid) then
				skip_bot = true
			end
			if not skip_bot and PlayerResource.GetPlayerName then
				local n = PlayerResource:GetPlayerName(pid)
				if n and string.match(n, "^bot_player_%d+$") then
					skip_bot = true
				end
			end
			if not skip_bot and PlayerResource.IsFakeClient and PlayerResource:IsFakeClient(pid) then
				skip_bot = true
			end
			if not skip_bot then
				local h = PlayerResource:GetSelectedHeroEntity(pid)
				if
					h
					and not h:IsNull()
					and h.IsRealHero
					and h:IsRealHero()
					and h:IsAlive()
				then
					h:AddExperience(xpi, r, false, false)
				end
			end
		end
	end
end

function CustomSets:StartHeroPassiveExpTimer()
	if self._HeroPassiveExpTimerReg then
		return
	end
	self._HeroPassiveExpTimerReg = true
	Timers:CreateTimer(1, function()
		local state = GameRules:State_Get()
		if state >= DOTA_GAMERULES_STATE_POST_GAME then
			return nil
		end
		if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			CustomSets:ApplyHeroPassiveExpOnce()
		end
		return 1.0
	end)
end
