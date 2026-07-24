--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- Generated from template
require("init.requireall")
if ClrbGame == nil then
	_G.ClrbGame = class({})
end

function Precache(context)
	Pre_Resource:StartLoad(context)
	PrecacheItemByNameSync("item_yasha", context)
	PrecacheItemByNameSync("item_null_talisman", context)
end

function ClrbGame:HealingFilter(keys)
    if not keys then
        return true
    end

    if not keys.entindex_target_const then
        return true
    end

    local target = EntIndexToHScript(keys.entindex_target_const)

    if not target or target:IsNull() then
        return true
    end

    if not keys.heal or keys.heal <= 0 then
        return true
    end

    if target:HasModifier("modifier_talent_2_lifesteal_aura_debuff") or
        target:HasModifier("modifier_talent_2_lifesteal_hit_debuff") then
        keys.heal = keys.heal * 0.7
    end

    return true
end


function Activate()
-- 部分环境下仅靠文件顶层 require 注册 modifier 不够；GameRules 激活后再链一次。客户端走 addon_game_mode_client.lua。
	if ClrbLinkAllLuaModifiers then
		ClrbLinkAllLuaModifiers()
	end
	GameRules.ClrbGame = ClrbGame()
	GameRules.ClrbGame:InitGameMode()
end

function ClrbGame:InitGameMode()
	self.CustomSets = CustomSets()
	self.CustomSets:GameSet()
	GameRules:GetGameModeEntity():SetHealingFilter(Dynamic_Wrap(ClrbGame, "HealingFilter"), self)

end


require("init.test")