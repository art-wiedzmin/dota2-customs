---玩家数据
--key是玩家id，value是一个table，包括各个玩家的数据
local PlayerData = {}
---内部数据，为了避免和其他模块调用setAttribute时用的key冲突，再维护一个表，仅供内部使用
--key是玩家id，value是一个table
local InternalData = {}
---房主玩家id
local hostPlayerID = nil;

local m = {}

---内部设置指定key的玩家数据。value可以是nil，会覆盖。
--已用key：
--hero（英雄实体）,host_player(房主玩家id)
local SetKV = function(player,key,value)
	if player and key then
		if type(player) == "table" then
			player = m.GetOwnerID(player)
		end
		if type(player) == "number" and m.IsValidPlayer(player) then
			local data = InternalData[player]
			if not data then
				data = {}
				InternalData[player] = data
			end
			data[key] = value
		end
	end
end

---内部获取指定key的玩家数据
--可用key：
--hero（英雄实体）,host_player(房主玩家id)
local GetKV = function(player,key)
	if player and key then
		if type(player) == "table" then
			player = m.GetOwnerID(player)
		end
		if type(player) == "number" and m.IsValidPlayer(player) then
			local data = InternalData[player]
			if data then
				return data[key]
			end
		end
	end
end

local colors = {
	[0]={55,121,254},
	[1]={104,254,193},
	[2]={191,5,193},
	[3]={241,240,17}
}

---初始化玩家数据
function m.AddPlayer(PlayerID)
	if PlayerID and m.IsValidPlayer(PlayerID) then
		if PlayerData[PlayerID] == nil then
			PlayerData[PlayerID] = {}
			InternalData[PlayerID] = {}
			
			local player = m.GetPlayer(PlayerID,true)
			if GameRules:PlayerHasCustomGameHostPrivileges(player) then
				hostPlayerID = PlayerID;
			end
			
			local color = colors[PlayerID];
			if color then
				PlayerResource:SetCustomPlayerColor(PlayerID,color[1],color[2],color[3])
			end
		end
	end
end

---对每个玩家执行传入的方法
---@param func function 调用时候会传入参数：PlayerID
function m.DoFuncToEachPlayer(func)
    if type(func) ~= "function" then
		return;
	end

	--由于部分场景下，PlayerResource会失效，7.31版本的dota又特别严苛，遇到nil经常崩溃，所以这里使用内部缓存的玩家ID来处理
	for PlayerID, _ in pairs(InternalData) do
		pcallx(func, PlayerID)
	end
	
    -- for n = 1 , PlayerResource:GetPlayerCountForTeam(teamNum) , 1 do
    --     local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, n)
    --     if PlayerResource:IsValidPlayerID(playerID) then
    --         if func( n , playerID ) == true then
    --             break
    --         end
    --     end
    -- end
end

---设置一个玩家的英雄实体，同时根据英雄单位，初始化玩家的相应属性<br>
--当玩家断开连接后，通过玩家id将获取不到玩家，也就不能获取其控制的英雄，会出现各种bug，所以这里单独存储一下
function m.SetHero(PlayerID,hero)
	SetKV(PlayerID,"hero",hero)
end


---根据玩家信息获取对应的英雄实体。英雄实体有个函数：HasOwnerAbandoned，不知道是不是能获取玩家是否离开游戏这个状态
--@param #any player 玩家id或者玩家所拥有的单位实体
function m.GetHero(player)
	if player then
		--先尝试从缓存中读取英雄（玩家掉线以后貌似通过接口是获取不到英雄的），没有的话，在尝试返回玩家拥有的英雄
		local hero = GetKV(player,"hero")
		if hero then
			return hero
		end

		if type(player) == "number" and PlayerResource:IsValidPlayer(player) then
			local playerEntity = PlayerResource:GetPlayer(player)
			return playerEntity and playerEntity:GetAssignedHero() or nil
		end
	end
end

---获取所有的英雄单位，包括离线玩家的。返回一个数组
function m.GetAllHeroes()
	local result = {}
	for _, data in pairs(InternalData) do
		local hero = data.hero
		if hero then
			table.insert(result, hero)
		end
	end
	return result;
end

---根据玩家id或者玩家拥有的实体，获取玩家实体。
--@param #any PlayerID 玩家id或玩家拥有的实体
--@param #boolean allState 是否返回所有状态的玩家，默认只返回连入游戏的玩家
--<ul>
--	<li>DOTA_CONNECTION_STATE_UNKNOWN</li>
--	<li>DOTA_CONNECTION_STATE_NOT_YET_CONNECTED</li>
--	<li>DOTA_CONNECTION_STATE_CONNECTED</li>
--	<li>DOTA_CONNECTION_STATE_DISCONNECTED</li>
--	<li>DOTA_CONNECTION_STATE_ABANDONED</li>
--	<li>DOTA_CONNECTION_STATE_LOADING</li>
--	<li>DOTA_CONNECTION_STATE_FAILED</li>
--</ul>
function m.GetPlayer(PlayerID,allState)
	if type(PlayerID) == "table" then
		PlayerID = PlayerID:GetPlayerOwnerID()
	end
	if type(PlayerID) ~= "number" or not PlayerResource:IsValidPlayer(PlayerID) then
		return nil
	end
	if allState or PlayerResource:GetConnectionState(PlayerID) == DOTA_CONNECTION_STATE_CONNECTED then
		return PlayerResource:GetPlayer(PlayerID);
	end
end

function m.GetHostPlayerID()
	return hostPlayerID
end

---根据单位实体返回该单位所属的玩家id
function m.GetOwnerID(unit)
	if EntityNotNull(unit) then
		return unit:GetPlayerOwnerID()
	end
end

---获取拥有这个单位的玩家实体
function m.GetOwner(unit)
	if type(unit) == "table" and unit.GetPlayerOwner then
		return unit:GetPlayerOwner()
	end
end

---尝试获取玩家id。用于不确定player是玩家id还是玩家单位的情况。
--无法获取的时候，返回nil
function m.TryGetPlayerID(player)
	if type(player) == "number" and m.IsValidPlayer(player) then
		return player;
	end
	
	if type(player) == "table" and player.GetPlayerOwnerID then
		return player:GetPlayerOwnerID()
	end
end

---返回所有玩家的id数组
--@param #boolean noDisconnect 忽略不在线的玩家（无论是断开连接还是离开游戏）
--@param #boolean noAbandoned 忽略已经离开游戏的玩家
function m.GetAllPlayersID(noDisconnect,noAbandoned)
	local result = {}
	for playerID, data in pairs(PlayerData) do
		if type(playerID) == "number" and PlayerResource:IsValidPlayer(playerID) then
			if noDisconnect then
				if PlayerResource:GetConnectionState(playerID) == DOTA_CONNECTION_STATE_CONNECTED then
					table.insert(result,playerID)
				end
			elseif noAbandoned then
				if PlayerResource:GetConnectionState(playerID) ~= DOTA_CONNECTION_STATE_ABANDONED then
					table.insert(result,playerID)
				end
			else
				table.insert(result,playerID)
			end
		end
	end
	return result;
end

---判断一个玩家是否在线
function m.IsPlayerConnected(PlayerID)
	if not PlayerID or type(PlayerID) ~= "number" or not PlayerResource:IsValidPlayer(PlayerID) then
		return false
	end
	return PlayerResource:GetConnectionState(PlayerID) == DOTA_CONNECTION_STATE_CONNECTED
end

---判断一个玩家是否已经离开游戏了，彻底断开了
--@param #number PlayerID 玩家id，为空返回false
function m.IsPlayerLeaveGame(PlayerID)
	if not PlayerID then
		return false;
	end
	if type(PlayerID) ~= "number" or not PlayerResource:IsValidPlayer(PlayerID) then
		return false
	end
	return PlayerResource:GetConnectionState(PlayerID) == DOTA_CONNECTION_STATE_ABANDONED
end

---这个应该是判断是否是正在游戏的玩家的。可以用来区分观战玩家
function m.IsValidPlayer(PlayerID)
	--IsValidPlayer必须传入非空值
	return type(PlayerID) == "number" and PlayerResource:IsValidPlayer(PlayerID)
end

---获取当前进入游戏的玩家数量
--@param #boolean noDisconnect 忽略不在线的玩家
function m.GetPlayerCount(noDisconnect)
	local count = 0
	for playerID, data in pairs(PlayerData) do
		if type(playerID) == "number" and PlayerResource:IsValidPlayer(playerID) then
			if noDisconnect then
				if PlayerResource:GetConnectionState(playerID) == 2 then
					count = count + 1
				end
			else
				count = count + 1
			end
		end
	end
	
	return count
end


---获取玩家的某项属性。参数为空或者找不到，则返回nil
--@param #any player 玩家id或者单位实体
--@param #string attrName 属性标识，不可为空
function m.getAttrByPlayer(player,attrName)
	if player and attrName and PlayerData then
		if type(player) == "table" then
			player = m.GetOwnerID(player)
		end
		if type(player) == "number" then
			local data = PlayerData[player]
			if data then
				return data[attrName]
			end
		end
	end
end

---设置玩家的属性
--@param #any player 玩家id或者单位实体。默认只有初始化过英雄的玩家才会有缓存数据，如果不存在缓存数据，则不会存储当前数据。
--@param #string attrName 属性标识，不可为空
--@param #any value 属性值，可为空
function m.setAttrByPlayer(player,attrName,value)
	if player and attrName and PlayerData then
		if type(player) == "table" then
			player = m.GetOwnerID(player)
		end
		if type(player) == "number" and m.IsValidPlayer(player) then
			local data = PlayerData[player]
			if data then
				data[attrName] = value
			end
		end
	end
end

---获取指定玩家的SteamID
--@param #number PlayerID 玩家id
--@param #boolean returnNum 是否返回数值，默认返回的是字符串形式
function m.GetSteamID(PlayerID,returnNum)
	if returnNum then
		return PlayerResource:GetSteamID(PlayerID)
	else
		return tostring(PlayerResource:GetSteamID(PlayerID));
	end
end

---获取指定玩家的AccountID（玩家信息能看到的那一串数字）
--@param #number PlayerID 玩家id
--@param #boolean returnNum 是否返回数值，默认返回的是字符串形式
function m.GetAccountID(PlayerID,returnNum)
	if returnNum then
		return PlayerResource:GetSteamAccountID(PlayerID);
	else
		return tostring(PlayerResource:GetSteamAccountID(PlayerID));
	end
end

---获取所有玩家账号，并拼接成字符串。返回一个表，账号字符串作为表的aid属性
function m.GetAllAccount(onlyAid,noAbandoned)
	local aids = nil;
	local sids = nil;
	for _,PlayerID in ipairs(PlayerUtil.GetAllPlayersID(false,noAbandoned)) do
		local accountID = PlayerUtil.GetAccountID(PlayerID)
		if aids then
			aids = aids .. "," .. accountID
		else
			aids = accountID;
		end
		
		if not onlyAid then
			local steamID = PlayerUtil.GetSteamID(PlayerID)
			if not sids then
				sids = {}
			end
			
			sids[accountID] = steamID
		end
	end
	
	if onlyAid then
		return {dotaId=aids}
	else
		if sids then
			sids = JSON.encode(sids)
		end
		return {dotaId=aids,steamIdMap=sids}
	end
end

---锁定玩家操作，锁定后不可重复执行该操作。除非调用了UnlockAction清除锁定状态
function m.LockAction(PlayerID,actionName,handler)
	local attr = "action_"..actionName;
	if not m.getAttrByPlayer(PlayerID,attr) then
		m.setAttrByPlayer(PlayerID,attr,true)
		
		local status = pcallx(handler)
		if not status then
			m.UnlockAction(PlayerID,actionName)
		else
			return true;
		end
	end
end
---清除玩家某个操作的锁定状态
function m.UnlockAction(PlayerID,actionName)
	m.setAttrByPlayer(PlayerID,"action_"..actionName,false)
end

---修改某个玩家的金币数量
--@param #any player 玩家ID或者玩家拥有的单位
--@param #number gold 金币，可正可负
--@return #number 返回修改了多少
function m.ModifyGold(player,gold)
	if type(player) == "table" then
		player = m.GetOwnerID(player)
	end
	return PlayerResource:ModifyGold(player, gold, false, DOTA_ModifyGold_Unspecified)
end

--[[
  添加Modifier或者叠加Modifier层数
]]
function m.AddModifierStack(caster,ability,modifierName,maxStack,param,stacks)
	if not stacks then stacks = 1 end
	local modifier = caster:FindModifierByName(modifierName)
    if not modifier then
        modifier = caster:AddNewModifier(caster, ability, modifierName, param)
		if not modifier then  
			DebugPrint("PlayerUtil.AddModifierStack Failed",modifierName)
			return
		end
		modifier:SetStackCount(0)
    end

    if(maxStack and modifier:GetStackCount() >= maxStack) then
		NotifyUtil.ShowError(PlayerUtil.GetOwnerID(caster),"ui_error_message_max_stack",nil)
        return false
    end

    if modifier then modifier:SetStackCount(modifier:GetStackCount() + stacks) end
	return true
end

---消耗物品，对特定物品会记录消耗数量，如果拥有数量不足，直接移除物品
---* 仅对传入的物品进行处理。如果需要从所有位置减少道具，使用ConsumeGlobal
---@param hero CDOTA_BaseNPC_Hero
---@param item CDOTA_Item 
---@param num? number 要减少的数量，默认为1
function m.ConsumeItem(hero,item,num)
	if EntityIsNull(hero) or EntityIsNull(item) then
		return
	end
	if not num then num = 1 end  --默认消耗一个物品

	--这里没有直接更新背包数据，通过背包的定时器自动更新，最长有大概0.2秒的显示延迟，基本忽略
	local name = item:GetAbilityName()
	if item:IsStackable() then
		if item:GetCurrentCharges() > num then
			item:SetCurrentCharges(item:GetCurrentCharges() - num)
		else
			EntityHelper.remove(item)
		end
	else
		EntityHelper.remove(item)
	end

	if string.find(name, "item_game_consum_") or string.find(name, "item_fish_") or string.find(name, "item_herb_") then
		m.UpdateConsumeCount(hero,name)
		Statistic:UpdateConsumeItemsProgress(PlayerUtil.GetOwnerID(hero), name)
	end
end

---在某个玩家身上查找对应名称的物品，没有判定物品归属者
---@param unit CDOTA_BaseNPC_Hero
---@param itemName string
---@return CDOTA_Item
function m.FindItemGlobal(unit,itemName)
	local item = unit:FindItemInInventory(itemName)

	if not item then
		item = Backpack.FindItemByName(unit, itemName)
	end
	
	return item
end

---获得某个玩家拥有的某个道具的总数量，包括身上和背包中
---@param unit number|CDOTA_BaseNPC 玩家ID或者玩家英雄
---@param itemName string 物品名称
---@return number #没有该道具返回0
function m.GetItemCountGlobal(unit,itemName)
	return Backpack.GetItemCountEverywhere(unit, itemName)
end


---消耗道具数量，会先判断拥有数量是否足够，再进行消耗，避免出现判断数量和消耗异步，导致消耗道具的时候，数量不足
---@param unit any
---@param itemName any
---@param num any
---@return boolean
function m.ConsumeItemGlobal(unit,itemName,num)
	if Backpack.GetItemCountEverywhere(unit, itemName) >= num then
		local reduced = Backpack.ReduceItemEverywhere(unit, itemName, num)
		if reduced ~= num then
			DebugPrint("[ConsumeItemGlobal]没有减少足够数量的物品（物品名称，需求，实际）:",itemName,num,reduced)
		end
		return true
	end
	return false
end

--(倒序)消耗单位身上指定数量物品，成功返回true  失败返回false
function m.ConsumeItemGlobalReverse(unit,itemName,num)
	if Backpack.GetItemCountEverywhere(unit, itemName) >= num then
		local reduced = Backpack.ReduceItemEverywhere(unit, itemName, num, true)
		if reduced ~= num then
			DebugPrint("[ConsumeItemGlobal]没有减少足够数量的物品（物品名称，需求，实际）:",itemName,num,reduced)
		end
		return true
	end
	return false
end

local function GetItemType(itemName)
	local type = "wild"  --默认野区掉落消耗品  之后鱼、药也会加进来

	if string.find(itemName, "fish") then
		type = "fish"
	end

	if string.find(itemName, "herb") then
		type = "herb"
	end
	return type
end

return m;
