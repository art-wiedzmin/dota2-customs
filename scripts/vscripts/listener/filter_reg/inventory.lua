--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local function ClrbInventoryFilterIssuerIsBot(pid)
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

local function clrb_item_already_in_hero_inventory(hero, item)
	for i = 0, 20 do
		local slot_it = hero.GetItemInSlot and hero:GetItemInSlot(i)
		if slot_it and not slot_it:IsNull() and slot_it == item then
			return true
		end
	end
	return false
end

local function clrb_allow_inventory_add(hero, item)
	if hero and not hero:IsNull() and item and not item:IsNull()
		and type(hero.IsHero) == "function" and hero:IsHero()
		and not clrb_item_already_in_hero_inventory(hero, item)
		and Util and Util.ClrbFixPickupItemSellable then
		Util:ClrbFixPickupItemSellable(hero, item)
	end
	return true
end

local function ClrbInventoryFilterPassiveActive()
	if MainGame and MainGame.GetPassiveMode and MainGame:GetPassiveMode() then
		return true
	end
	if Boot and Boot.Config and Boot.Config.bot_passive_mode == true then
		return true
	end
	return false
end

local function clrb_schedule_chest_neutral_slot_fix(hero, item)
	if not hero or hero:IsNull() or type(hero.IsHero) ~= "function" or not hero:IsHero() then
		return
	end
	if not Box or not Box.ScheduleEnsureItemCost2InNeutralSlot or not Timers then
		return
	end
	local name = ""
	if item and not item:IsNull() then
		name = (item.GetAbilityName and item:GetAbilityName()) or (item.GetName and item:GetName()) or ""
	end
	if name == "item_cost_2" or Box:HasMisplacedItemCost2(hero) then
		Timers(0, function()
			if hero and not hero:IsNull() then
				Box:ScheduleEnsureItemCost2InNeutralSlot(hero, item)
			end
		end)
	end
end

--- 合成 / 快递 / 拾取等不经过 PURCHASE_ITEM 的路径：禁止禁表物品进入真人英雄背包
function CustomSets:Inventory_Filter(keys)
	local pidx = keys.inventory_parent_entindex_const
	local iidx = keys.item_entindex_const
	if not pidx or not iidx then
		return true
	end
	local hero = EntIndexToHScript(pidx)
	local item = EntIndexToHScript(iidx)
	if not hero or hero:IsNull() or not item or item:IsNull() then
		return true
	end
	local allow_add = function()
		clrb_schedule_chest_neutral_slot_fix(hero, item)
		return clrb_allow_inventory_add(hero, item)
	end
	-- if Util and Util.TryClearRespawnProtectionWudi and type(hero.IsHero) == "function" and hero:IsHero() then
	-- 	Util:TryClearRespawnProtectionWudi(hero)
	-- end
	local item_name = item:GetName()
	if Item:IsStackSkill(item_name) then
		-- print(88888)
		local item_box = item:GetContainer()
		-- print(1111)
		local ID = Util:Hero2ID(hero)
		if not ID then
			return allow_add()
		end
		-- print(2222)
		if Item:IsHaveItem(ID, item_name) then
			-- print(33333)
			local bag_item = Item:FindItem(ID, item_name)
			if bag_item then
				-- print(44444)
				bag_item:SetCurrentCharges(bag_item:GetCurrentCharges() + 1)
				if item_box and not item_box:IsNull() then
					item_box:RemoveSelf()
					UTIL_Remove(item)
				end
				return false
			end
		else
			return allow_add()
		end
	end
	if type(hero.IsHero) == "function" and not hero:IsHero() then
		return true
	end
	local incoming_name = (item.GetAbilityName and item:GetAbilityName())
		or (item.GetName and item:GetName())
		or ""
	if incoming_name == "item_tpscroll" then
		if item.RemoveSelf then
			pcall(function()
				item:RemoveSelf()
			end)
		end
		return false
	end
	if string.match(incoming_name, "^item_talent_skill_%d+$") and not clrb_item_already_in_hero_inventory(hero, item) then
		for slot = 0, 23 do
			local existing = hero.GetItemInSlot and hero:GetItemInSlot(slot)
			if existing and not existing:IsNull() and existing ~= item then
				local en = existing:GetName() or ""
				if en == incoming_name or string.match(en, "^item_talent_skill_%d+$") then
					if item.RemoveSelf then
						pcall(function()
							item:RemoveSelf()
						end)
					end
					return false
				end
			end
		end
	end
	local pid = hero.GetPlayerOwnerID and hero:GetPlayerOwnerID()
	if pid == nil or pid < 0 or Util:IsPseudoPlayerID(pid) then
		return allow_add()
	end
	if not PlayerResource:IsValidPlayer(pid) or ClrbInventoryFilterIssuerIsBot(pid) then
		return allow_add()
	end
	if not ClrbInventoryFilterPassiveActive() then
		return allow_add()
	end
	if not MainGame or not MainGame.IsPassiveModeBannedPurchaseItem then
		return allow_add()
	end
	local item_name = (item.GetAbilityName and item:GetAbilityName())
		or (item.GetName and item:GetName())
		or ""
	if item_name == "" or not MainGame:IsPassiveModeBannedPurchaseItem(item_name) then
		return allow_add()
	end

	-- 背包内换位/挪动同一实体不拦截，避免误删
	if clrb_item_already_in_hero_inventory(hero, item) then
		clrb_schedule_chest_neutral_slot_fix(hero, item)
		return true
	end
	Util:BottomMsg2ID(pid, "被动模式下不可获取该物品", "red", 1)
	if item.RemoveSelf then
		pcall(function()
			item:RemoveSelf()
		end)
	end

	return false
end