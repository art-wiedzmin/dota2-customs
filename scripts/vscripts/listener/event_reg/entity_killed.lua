--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


--[[
{
	damagebits  (string)= 0  (number)
	entindex_attacker  (string)= 135  (number)
	entindex_killed  (string)= 183  (number)
	game_event_listener  (string)= 486539276  (number)
	game_event_name  (string)= entity_killed  (string)
	splitscreenplayer  (string)= -1  (number)
}
]]

local function ek_is_unit_hero(ent)
	if not ent or ent:IsNull() or type(ent.IsHero) ~= "function" then
		return false
	end
	return ent:IsHero()
end

-- 非英雄被英雄击杀时的暴击血雾（路径只驻留一份，避免每次击杀重复 intern 字符串）
local EK_MONSTER_KILL_VFX = {
	"particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact_burst.vpcf",
	"particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact_bloodstain.vpcf",
	"particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact_bloodstain_b.vpcf",
	"particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact_mist.vpcf",
	"particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact_blood.vpcf",
}

local function ek_play_monster_kill_vfx(target)
	local origin = target:GetAbsOrigin()
	local forward = target:GetForwardVector()
	local attach = PATTACH_OVERHEAD_FOLLOW
	local n = #EK_MONSTER_KILL_VFX
	local pids = {}
	for i = 1, n do
		local pid = ParticleManager:CreateParticle(EK_MONSTER_KILL_VFX[i], attach, target)
		pids[i] = pid
		ParticleManager:SetParticleControl(pid, 0, origin)
		ParticleManager:SetParticleControl(pid, 1, origin)
		ParticleManager:SetParticleControlForward(pid, 1, forward)
	end
	Timers(2, function()
		for i = 1, n do
			local pid = pids[i]
			ParticleManager:DestroyParticle(pid, true)
			ParticleManager:ReleaseParticleIndex(pid)
		end
	end)
end

function CustomSets:entity_killed(keys)
	-- 结算后不再处理击杀
	if MainGame and MainGame.Data and MainGame.Data.over == true then
		return true
	end

	local at_index = keys.entindex_attacker
	local ta_index = keys.entindex_killed
	if not at_index or not ta_index then
		return
	end

	local attacker = Util:Index2Entity(at_index)
	local target = Util:Index2Entity(ta_index)
	if not attacker or not target or attacker:IsNull() or target:IsNull() then
		return
	end
	if not IsValidEntity(attacker) or not IsValidEntity(target) then
		return
	end

	if ek_is_unit_hero(target) then
		HeroData:HeroDeath(target, attacker)
	else
		Monster:Death(target)
		if ek_is_unit_hero(attacker) then
			local ID = Util:Hero2ID(attacker)
			Talent:Kill(ID, target)
			if AchieveStat and AchieveStat.OnNeutralKill and ID then
				AchieveStat:OnNeutralKill(ID)
			end

			local init_data = ID and InitPlayer:GetPlayerData(ID)
			if init_data and init_data.bot then
				local g, xp = 20, 0
				local cfg = BotAI and BotAI.Config
				if cfg then
					local gc = tonumber(cfg.neutral_kill_gold)
					if gc ~= nil then
						g = gc
					end
					xp = tonumber(cfg.neutral_kill_experience) or 0
				end
				if g ~= 0 then
					HeroData:AddGold(ID, g)
				end
				if xp > 0 and attacker.AddExperience then
					attacker:AddExperience(xp, 0, false, false)
				end
			end

			ek_play_monster_kill_vfx(target)
		end
	end
	-- if attacker:IsHero() and target:IsHero() then
	-- 	target.KillCount = 0
	-- 	if attacker.KillCount == nil then
	-- 		attacker.KillCount = 1
	-- 	else
	-- 		attacker.KillCount = attacker.KillCount + 1
	-- 		if attacker.KillCount >= 10 then
	-- 			local buff = "modifier_stillkill"
	-- 			if attacker:HasModifier(buff) then
	-- 				return
	-- 			else
	-- 				attacker:AddNewModifier(attacker, nil, buff, {})
	-- 			end
	-- 		end
	-- 	end
	-- end
	return true
end