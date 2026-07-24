--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


---纯被动模式：仅限制真人主动施放「英雄技能」；物品/道具（IsItem）不拦截；机器人不拦截。依赖 MainGame:GetPassiveMode()
local function ClrbPassiveModeIssuerIsBot(pid)
	if InitPlayer and InitPlayer.GetPlayerData then
		local d = InitPlayer:GetPlayerData(pid)
		if d and d.bot then
			return true
		end
	end
	local pr = PlayerResource
	if not pr then
		return false
	end
	local fn = rawget(pr, "IsPlayerBot")
	if type(fn) == "function" then
		local ok, isb = pcall(fn, pr, pid)
		if ok and isb then
			return true
		end
	end
	return false
end

local ORDER_PURCHASE_ITEM = tonumber(rawget(_G, "DOTA_UNIT_ORDER_PURCHASE_ITEM")) or 16
local ORDER_SELL_ITEM = tonumber(rawget(_G, "DOTA_UNIT_ORDER_SELL_ITEM")) or 17
local ORDER_DROP_ITEM = tonumber(rawget(_G, "DOTA_UNIT_ORDER_DROP_ITEM")) or 12
local ORDER_DISASSEMBLE_ITEM = tonumber(rawget(_G, "DOTA_UNIT_ORDER_DISASSEMBLE_ITEM")) or 26
--- 宝箱 item_cost_2：禁止卖店/丢弃/拆分（换位由 Ensure 纠正，不在此拦截以免误伤）
local function ClrbOrderFilterBlockChestItemOrder(keys)
	local ot = tonumber(keys.order_type)
	if ot ~= ORDER_SELL_ITEM and ot ~= ORDER_DROP_ITEM and ot ~= ORDER_DISASSEMBLE_ITEM then
		return false
	end
	local abid = tonumber(keys.entindex_ability)
	if not abid or abid <= 0 then
		return false
	end
	local ab = EntIndexToHScript(abid)
	if not ab or ab:IsNull() then
		return false
	end
	local name = (ab.GetAbilityName and ab:GetAbilityName()) or (ab.GetName and ab:GetName()) or ""
	return name == "item_cost_2"
end

local ORDER_PICKUP_ITEM = tonumber(rawget(_G, "DOTA_UNIT_ORDER_PICKUP_ITEM")) or 14
local ORDER_CONSUME_ITEM = tonumber(rawget(_G, "DOTA_UNIT_ORDER_CONSUME_ITEM")) or 41
local OC_POSITION = tonumber(rawget(_G, "DOTA_UNIT_ORDER_CAST_POSITION")) or 5
local OC_TARGET = tonumber(rawget(_G, "DOTA_UNIT_ORDER_CAST_TARGET")) or 6
local OC_TARGET_TREE = tonumber(rawget(_G, "DOTA_UNIT_ORDER_CAST_TARGET_TREE")) or 7
local OC_NO_TARGET = tonumber(rawget(_G, "DOTA_UNIT_ORDER_CAST_NO_TARGET")) or 8
local OC_TOGGLE = tonumber(rawget(_G, "DOTA_UNIT_ORDER_CAST_TOGGLE")) or 9
local OC_TOGGLE_AUTO = tonumber(rawget(_G, "DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO")) or 20

--- 购买指令里的物品名：优先 shop_item_name，其次 ability_name，再从 entindex_ability 取（部分环境 shop 字段为空）
local function ClrbOrderFilterResolvePurchaseItemName(keys)
	local n = keys.shop_item_name
	if type(n) == "string" and n ~= "" then
		return n
	end
	n = keys.ability_name
	if type(n) == "string" and n ~= "" then
		return n
	end
	local abid = keys.entindex_ability
	if abid and abid > 0 then
		local ab = EntIndexToHScript(abid)
		if ab and not ab:IsNull() and type(ab.GetAbilityName) == "function" then
			local an = ab:GetAbilityName()
			if type(an) == "string" and an ~= "" then
				return an
			end
		end
	end
	return nil
end

local function ClrbPassiveModeIssuerIsRealHuman(pid)
	if pid == nil or pid < 0 or Util:IsPseudoPlayerID(pid) then
		return false
	end
	if not PlayerResource:IsValidPlayer(pid) or ClrbPassiveModeIssuerIsBot(pid) then
		return false
	end
	return true
end

local function ClrbPassiveModeRulesActive()
	if MainGame and MainGame.GetPassiveMode and MainGame:GetPassiveMode() then
		return true
	end
	if Boot and Boot.Config and Boot.Config.bot_passive_mode == true then
		return true
	end
	return false
end

local function ClrbPassiveModeBlockBannedShopPurchase(keys)
	if not MainGame or not MainGame.IsPassiveModeBannedPurchaseItem then
		return false
	end
	if not ClrbPassiveModeRulesActive() then
		return false
	end
	local pid = keys.issuer_player_id_const
	if not ClrbPassiveModeIssuerIsRealHuman(pid) then
		return false
	end
	local ot = tonumber(keys.order_type)
	if ot ~= ORDER_PURCHASE_ITEM then
		return false
	end
	local name = ClrbOrderFilterResolvePurchaseItemName(keys)
	if not name or name == "" then
		return false
	end
	return MainGame:IsPassiveModeBannedPurchaseItem(name)
end

--- 被动模式：禁止对已禁用物品施放（如黑黄杖），与「禁购」共用同一张表
local function ClrbPassiveModeBlockBannedItemUseOrder(keys)
	if not MainGame or not MainGame.IsPassiveModeBannedPurchaseItem then
		return false
	end
	if not ClrbPassiveModeRulesActive() then
		return false
	end
	local pid = keys.issuer_player_id_const
	if not ClrbPassiveModeIssuerIsRealHuman(pid) then
		return false
	end
	local ot = tonumber(keys.order_type)
	if ot == nil then
		return false
	end
	local is_item_cast = false
	if ot == OC_POSITION or ot == OC_TARGET or ot == OC_TARGET_TREE or ot == OC_NO_TARGET
		or ot == OC_TOGGLE or ot == OC_TOGGLE_AUTO then
		is_item_cast = true
	end
	local vtp = tonumber(rawget(_G, "DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION"))
	if vtp and ot == vtp then
		is_item_cast = true
	end
	local tog_alt = tonumber(rawget(_G, "DOTA_UNIT_ORDER_CAST_TOGGLE_ALT"))
	if tog_alt and ot == tog_alt then
		is_item_cast = true
	end
	if ot == ORDER_CONSUME_ITEM then
		is_item_cast = true
	end
	if not is_item_cast then
		return false
	end
	local abid = keys.entindex_ability
	if not abid or abid <= 0 then
		return false
	end
	local ab = EntIndexToHScript(abid)
	if not ab or ab:IsNull() or type(ab.IsItem) ~= "function" or not ab:IsItem() then
		return false
	end
	local name = (ab.GetAbilityName and ab:GetAbilityName()) or ""
	if name == "" then
		return false
	end
	return MainGame:IsPassiveModeBannedPurchaseItem(name)
end

--- 被动模式：仍允许玩家手动使用「开关」与「法球/自动施法攻击修饰」类技能（发球类按引擎行为视为 AUTOCAST/ATTACK）
local function ClrbPassiveModeAllowToggleOrOrbStyleHeroAbility(ab)
	if not ab or ab:IsNull() or type(ab.GetBehavior) ~= "function" then
		return false
	end
	if not bit or type(bit.band) ~= "function" then
		return false
	end
	local ok, b = pcall(function()
		return ab:GetBehavior()
	end)
	if not ok or b == nil then
		return false
	end
	b = tonumber(b) or 0
	local TOGGLE = tonumber(rawget(_G, "DOTA_ABILITY_BEHAVIOR_TOGGLE")) or 512
	local AUTOCAST = tonumber(rawget(_G, "DOTA_ABILITY_BEHAVIOR_AUTOCAST")) or 4096
	local ATTACK = tonumber(rawget(_G, "DOTA_ABILITY_BEHAVIOR_ATTACK"))
	if bit.band(b, TOGGLE) ~= 0 then
		return true
	end
	if bit.band(b, AUTOCAST) ~= 0 then
		return true
	end
	if ATTACK and bit.band(b, ATTACK) ~= 0 then
		return true
	end
	return false
end

local function ClrbPassiveModeShouldBlockPlayerHeroCast(keys)
	if not MainGame or not MainGame.GetPassiveMode or not MainGame:GetPassiveMode() then
		return false
	end
	local pid = keys.issuer_player_id_const
	if pid == nil or pid < 0 or Util:IsPseudoPlayerID(pid) then
		return false
	end
	if not PlayerResource:IsValidPlayer(pid) or ClrbPassiveModeIssuerIsBot(pid) then
		return false
	end
	local abid = keys.entindex_ability
	if not abid or abid <= 0 then
		return false
	end
	local ab = EntIndexToHScript(abid)
	if not ab or ab:IsNull() then
		return false
	end
	-- 物品 / 技能书等：先 IsItem；无接口时用 item_ 前缀兜底（避免无 IsDOTABaseAbility 的实体报错）
	if type(ab.IsItem) == "function" and ab:IsItem() then
		return false
	end
	if type(ab.GetAbilityName) == "function" then
		local an = ab:GetAbilityName() or ""
		if string.sub(an, 1, 5) == "item_" then
			return false
		end
	end
	if ClrbPassiveModeAllowToggleOrOrbStyleHeroAbility(ab) then
		return false
	end
	-- 技能书等学到的技能可能无 IsDOTABaseAbility；只要不是物品，仍按施法指令拦截
	local ot = keys.order_type
	if ot == nil then
		return false
	end
	if ot == DOTA_UNIT_ORDER_CAST_POSITION
		or ot == DOTA_UNIT_ORDER_CAST_TARGET
		or ot == DOTA_UNIT_ORDER_CAST_TARGET_TREE
		or ot == DOTA_UNIT_ORDER_CAST_TOGGLE
		or ot == DOTA_UNIT_ORDER_CAST_NO_TARGET
		or ot == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then
		return true
	end
	local vtp = rawget(_G, "DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION")
	if vtp and ot == vtp then
		return true
	end
	local cr = rawget(_G, "DOTA_UNIT_ORDER_CAST_RUNE")
	if cr and ot == cr then
		return true
	end
	return false
end

--- 真人复活无敌：由 Util:TryClearRespawnProtectionWudi 处理（下单、背包等共用）
local function ClrbClearRespawnWudiOnPlayerOrder(hero)
	if Util and Util.TryClearRespawnProtectionWudi then
		Util:TryClearRespawnProtectionWudi(hero)
	end
end

--- 肉搏书：卖店时禁止宠物再捡同名；从商店新购时解除（与成功用书同一张 melee_pet_ban）
local function ClrbApplyMeleeBookPetBanFromOrder(keys, hero)
	local ot = tonumber(keys.order_type)
	if ot ~= ORDER_SELL_ITEM and ot ~= ORDER_PURCHASE_ITEM then
		return
	end
	if not Skill or not Skill.BanMeleeBookPetAfterSellToShop
		or not Skill.ClearMeleePetBanForBook
		or not Skill.IsMeleeSkillBookItemName then
		return
	end
	local ID = Util:Hero2ID(hero)
	if not ID or ID < 0 then
		return
	end
	if ot == ORDER_SELL_ITEM then
		local abid = tonumber(keys.entindex_ability)
		if not abid or abid <= 0 then
			return
		end
		local ent = EntIndexToHScript(abid)
		if not ent or ent:IsNull() or type(ent.IsItem) ~= "function" or not ent:IsItem() then
			return
		end
		local n = ent.GetName and ent:GetName()
		if (not n or n == "") and ent.GetAbilityName then
			n = ent:GetAbilityName()
		end
		if not n or not Skill:IsMeleeSkillBookItemName(n) then
			return
		end
		Skill:BanMeleeBookPetAfterSellToShop(ID, n)
		return
	end
	if ot == ORDER_PURCHASE_ITEM then
		local n = ClrbOrderFilterResolvePurchaseItemName(keys)
		if n and Skill:IsMeleeSkillBookItemName(n) then
			Skill:ClearMeleePetBanForBook(ID, n)
		end
	end
end

--[[
	entindex_ability  (string)= -1  (number)
	entindex_target  (string)= 0  (number)
	issuer_player_id_const  (string)= 0  (number)
	order_type  (string)= 1  (number)
	position_x  (string)= 88.870567321777  (number)
	position_y  (string)= -508.34545898438  (number)
	position_z  (string)= 128  (number)
	queue  (string)= 0  (number)
	sequence_number_const  (string)= 20  (number)
	shop_item_name  (string)=   (string)
	units  (string)=
        0  (string)= 442  (number)
	

	order_type指令
	1:移动
	2：跟随
	4：攻击
	14：拾取
]]

function CustomSets:Order_Filter(keys)
	local index = keys.units["0"]
	if not index then return end
	local hero = Util:Index2Entity(index)
	if not hero or hero:IsNull() then return end
	if ClrbOrderFilterBlockChestItemOrder(keys) then
		return false
	end
	local pid = keys.issuer_player_id_const
	ClrbApplyMeleeBookPetBanFromOrder(keys, hero)
	if pid and pid >= 0 and not Util:IsPseudoPlayerID(pid) and
		Skill.Data[pid] and Box.Data[pid] and Talent.Data[pid] then
		Skill:OpenChangeImg(pid)
		Box:Show(pid)
		Talent:OpenTextPage(pid)
	end
	return true
end