--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function CustomSets:Gain_Level(keys)
	-- print("Gain_Level")
	-- print(keys)
	local ID = keys.PlayerID
	local index = keys.hero_entindex
	local lv = keys.level --升级后
	local hero = Util:Index2Entity(index)
	if ID and hero then
		HeroData:HeroGainAttr(ID, hero)
		return true
	end

	-- if not ID then return end
	-- local player = Util:ID2Player(ID)
	-- if not player then return end
	-- if not hero:IsRealHero() then return end
	-- if not PlayerResource:IsValidPlayer(ID) then return end
	-- return true
	--print(hero:GetAttributes())

	return true
end