--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 检测人物的等级是否满足技能升级的需求
function CheckLevelRequirement(keys)
	--print("检测技能等级是否满足条件")
	local hero = keys.caster
	local ability = keys.ability
	local ability_name = ability:GetAbilityName()

	if ability:GetLevel() <= 1 then
		return
	end

	if not hero:IsRealHero() then return end

	local hero_level = hero:GetLevel()
	local ability_level = ability:GetLevel()

	if ability_level > hero_level then
		local ID = Util:Hero2ID(hero)
        Util:BottomMsg2ID(ID, "技能等级不能超过英雄等级")
		hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
		ability:SetLevel(ability:GetLevel() - 1)
	end
end