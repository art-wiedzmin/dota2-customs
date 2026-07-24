--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 局外背包：同步、佩戴、卸下（佩戴/卸下本地即时生效，3 秒防抖后一次性同步服务端）

local LOADOUT_SYNC_DEBOUNCE_SEC = 3
local LOADOUT_TIMER_PREFIX = "clrb_outbag_loadout_"

function Shop:NormalizeLoadoutSlot(slot)
    if not slot then
        return nil
    end
    local s = string.lower(tostring(slot))
    if s == "title" or s == "effect" or s == "attack_effect" or s == "pet" then
        return s
    end
    return nil
end

function Shop:LoadoutFieldForSlot(slot)
    local slotNorm = self:NormalizeLoadoutSlot(slot)
    if not slotNorm then
        return nil
    end
    return "equipped_" .. slotNorm
end

function Shop:EnsureBagLoadoutMeta(ID)
    if not ID or not self.Data[ID] then
        return
    end
    ID = tonumber(ID) or ID
    if not self.Data[ID].bag then
        self.Data[ID].bag = {
            items = {},
            loadout = {
                equipped_title = nil,
                equipped_effect = nil,
                equipped_attack_effect = nil,
                equipped_pet = nil,
            },
        }
    end
    local bag = self.Data[ID].bag
    if not bag.loadout then
        bag.loadout = {
            equipped_title = nil,
            equipped_effect = nil,
            equipped_attack_effect = nil,
            equipped_pet = nil,
        }
    end
    if not self.Data[ID].bag_loadout_server then
        self.Data[ID].bag_loadout_server = Util:DeepCopyTab(bag.loadout)
    end
    if self.Data[ID].bag_loadout_dirty == nil then
        self.Data[ID].bag_loadout_dirty = false
    end
end

function Shop:ConfirmBagLoadoutFromServer(ID)
    if not ID or not self.Data[ID] or not self.Data[ID].bag then
        return
    end
    self:EnsureBagLoadoutMeta(ID)
    self.Data[ID].bag_loadout_server = Util:DeepCopyTab(self.Data[ID].bag.loadout)
    self.Data[ID].bag_loadout_dirty = false
end

function Shop:NormalizeBagItems(items)
    local out = {}
    if type(items) ~= "table" then
        return out
    end
    if #items > 0 then
        for i, row in ipairs(items) do
            out[i] = row
        end
        return out
    end
    local keys = {}
    for k, row in pairs(items) do
        if type(row) == "table" then
            keys[#keys + 1] = k
        end
    end
    table.sort(keys, function(a, b)
        return tonumber(a) < tonumber(b)
    end)
    for _, k in ipairs(keys) do
        out[#out + 1] = items[k]
    end
    return out
end

function Shop:OutBagOwnsItem(ID, item_key)
    return self:GetBagItemCount(ID, item_key) > 0
end

function Shop:GetBagItemCount(ID, item_key)
    if not ID or not item_key or not self.Data[ID] or not self.Data[ID].bag then
        return 0
    end
    local items = self:NormalizeBagItems(self.Data[ID].bag.items)
    for _, row in ipairs(items) do
        if row.item_key == item_key then
            return tonumber(row.count) or 0
        end
    end
    return 0
end

function Shop:EnsurePlayerData(ID)
    if ID == nil then
        return false
    end
    ID = tonumber(ID) or ID
    if not self.Data then
        self.Data = {}
    end
    if not self.Data[ID] and self.Init then
        self:Init(ID)
    end
    return self.Data[ID] ~= nil
end

function Shop:AddBagItemLocal(ID, item_key, amount)
    if not ID or not item_key or item_key == "" then
        return false
    end
    ID = tonumber(ID) or ID
    if not self:EnsurePlayerData(ID) then
        return false
    end
    local add = math.max(0, math.floor(tonumber(amount) or 0))
    if add < 1 then
        return false
    end
    if not self.Data[ID].bag then
        self.Data[ID].bag = {
            items = {},
            loadout = {
                equipped_title = nil,
                equipped_effect = nil,
                equipped_attack_effect = nil,
                equipped_pet = nil,
            },
        }
    end
    self:EnsureBagLoadoutMeta(ID)
    local meta = self.ItemList and self.ItemList[item_key]
    if not meta then
        return false
    end
    local items = self:NormalizeBagItems(self.Data[ID].bag.items)
    if meta.stack == false then
        for _, row in ipairs(items) do
            if row.item_key == item_key and (tonumber(row.count) or 0) > 0 then
                self.Data[ID].bag.items = items
                self:SendOutBagData(ID)
                return true
            end
        end
    end
    local maxStack = meta.maxStack or 9999
    local found = false
    for _, row in ipairs(items) do
        if row.item_key == item_key then
            row.count = math.min(maxStack, (tonumber(row.count) or 0) + add)
            found = true
            break
        end
    end
    if not found then
        items[#items + 1] = {
            item_key = item_key,
            count = math.min(maxStack, add),
            id = meta.id,
            type = meta.type,
            name = meta.name,
            stack = meta.stack,
        }
    end
    self.Data[ID].bag.items = items
    self:SendOutBagData(ID)
    return true
end

function Shop:GrantBagItemServer(ID, item_key, amount, callback)
    if not ID or not item_key or item_key == "" then
        if callback then
            callback(false, "invalid")
        end
        return
    end
    if not self.Data[ID] then
        self:Init(ID)
    end
    local token = Http:GetPlayerAccessToken(ID)
    if not token or token == "" then
        if callback then
            callback(false, "no_token")
        end
        return
    end
    local body = {
        item_key = item_key,
        amount = amount,
    }
    if IsInToolsMode() then
        body.tools_mode = 1
    end
    Http:POST("/bag/grant", body, ID, function(keys)
        if keys and keys.code == 200 and keys.data and keys.data.bag then
            self:ApplyBagAndNotify(ID, keys.data.bag)
            if callback then
                callback(true, keys)
            end
            return
        end
        if callback then
            callback(false, keys)
        end
    end)
end

function Shop:OutBagValidateEquip(ID, slot, item_key)
    local slotNorm = self:NormalizeLoadoutSlot(slot)
    if not slotNorm or not item_key or item_key == "" then
        return false, "无效的佩戴参数"
    end
    local meta = self.ItemList and self.ItemList[item_key]
    if not meta then
        return false, "未知道具"
    end
    if meta.type == 1 then
        return false, "消耗品不可佩戴"
    end
    if meta.slot ~= slotNorm then
        return false, "道具类型与槽位不匹配"
    end
    if not self:OutBagOwnsItem(ID, item_key) then
        return false, "未拥有该道具"
    end
    return true
end

function Shop:SetBagServerData(ID, bag)
    if not ID or not self.Data[ID] then
        return
    end
    if not bag or type(bag) ~= "table" then
        self.Data[ID].bag = {
            items = {},
            loadout = {
                equipped_title = nil,
                equipped_effect = nil,
                equipped_attack_effect = nil,
                equipped_pet = nil,
            },
        }
        self:ConfirmBagLoadoutFromServer(ID)
        return
    end
    self.Data[ID].bag = {
        items = self:NormalizeBagItems(bag.items),
        loadout = bag.loadout or {
            equipped_title = nil,
            equipped_effect = nil,
            equipped_attack_effect = nil,
            equipped_pet = nil,
        },
    }
    self:ConfirmBagLoadoutFromServer(ID)
    if Pet and Pet.SyncFromOutBag then
        Pet:SyncFromOutBag(ID)
    end
    if Title and Title.SyncFromOutBag then
        Title:SyncFromOutBag(ID)
    end
    if Effect and Effect.SyncFromOutBag then
        Effect:SyncFromOutBag(ID)
    end
    if AttackEffect and AttackEffect.SyncFromOutBag then
        AttackEffect:SyncFromOutBag(ID)
    end
    if Prophecy and Prophecy.OnBagReady then
        Prophecy:OnBagReady(ID)
    end
end

function Shop:SendOutBagData(ID)
    if not ID or not self.Data[ID] then
        return
    end
    self:EnsureBagLoadoutMeta(ID)
    local bag = self.Data[ID].bag or {}
    local items = self:NormalizeBagItems(bag.items)
    local loadout = bag.loadout or {
        equipped_title = nil,
        equipped_effect = nil,
        equipped_attack_effect = nil,
        equipped_pet = nil,
    }
    local payload = {
        page = self.Data[ID].page,
        bag_json = "",
        out_bag_n = #items,
    }
    local ok, enc = pcall(function()
        return JSON.encode({
            items = items,
            loadout = loadout,
        })
    end)
    if ok and enc then
        payload.bag_json = enc
    end
    for i, row in ipairs(items) do
        if type(row) == "table" then
            payload["obi_" .. i .. "_key"] = row.item_key or ""
            payload["obi_" .. i .. "_count"] = row.count or 0
            payload["obi_" .. i .. "_name"] = row.name or ""
            payload["obi_" .. i .. "_type"] = row.type or 0
        end
    end
    payload.loadout_title = loadout.equipped_title or ""
    payload.loadout_effect = loadout.equipped_effect or ""
    payload.loadout_attack_effect = loadout.equipped_attack_effect or ""
    payload.loadout_pet = loadout.equipped_pet or ""
    Util:Send2JsID("UI_OutBag", payload, ID)
end

function Shop:ApplyBagAndNotify(ID, bag)
    self:SetBagServerData(ID, bag)
    self:SendOutBagData(ID)
    self:SendData(ID)
end

function Shop:ApplyLoginBag(ID, data)
    if not ID or not data or not data.bag then
        return false
    end
    self:SetBagServerData(ID, data.bag)
    self:SendOutBagData(ID)
    return true
end

function Shop:ScheduleDebouncedLoadoutSync(ID)
    if not ID or not self.Data[ID] then
        return
    end
    local name = LOADOUT_TIMER_PREFIX .. tostring(ID)
    Timers:CreateTimer(name, {
        endTime = LOADOUT_SYNC_DEBOUNCE_SEC,
        callback = function()
            if not Shop.Data[ID] then
                return
            end
            Shop:FlushOutBagLoadoutToServer(ID)
        end,
    })
end

function Shop:RevertOutBagLoadout(ID)
    if not ID or not self.Data[ID] then
        return
    end
    self:EnsureBagLoadoutMeta(ID)
    local server = self.Data[ID].bag_loadout_server
    if server and self.Data[ID].bag then
        self.Data[ID].bag.loadout = Util:DeepCopyTab(server)
    end
    self.Data[ID].bag_loadout_dirty = false
    self:SendOutBagData(ID)
    if Pet and Pet.SyncFromOutBag then
        Pet:SyncFromOutBag(ID)
    end
    if Title and Title.SyncFromOutBag then
        Title:SyncFromOutBag(ID)
    end
    if Effect and Effect.SyncFromOutBag then
        Effect:SyncFromOutBag(ID)
    end
    if AttackEffect and AttackEffect.SyncFromOutBag then
        AttackEffect:SyncFromOutBag(ID)
    end
end

function Shop:FlushOutBagLoadoutToServer(ID)
    if not ID or not self.Data[ID] then
        return
    end
    self:EnsureBagLoadoutMeta(ID)
    if not self.Data[ID].bag_loadout_dirty then
        return
    end
    local loadout = self.Data[ID].bag.loadout
    if not loadout then
        self.Data[ID].bag_loadout_dirty = false
        return
    end
    Http:POST("/bag/loadout", { loadout = loadout }, ID, function(keys)
        if not Shop.Data[ID] then
            return
        end
        if keys.code == 200 and keys.data and keys.data.bag then
            Shop:SetBagServerData(ID, keys.data.bag)
            Shop:SendOutBagData(ID)
        else
            Shop:RevertOutBagLoadout(ID)
            local msg = "佩戴同步失败"
            if keys and keys.message and keys.message ~= "" then
                msg = keys.message
            end
            Msgs:Pop(ID, msg)
        end
    end)
end

function Shop:OutBagApplyLoadoutLocal(ID, slot, item_key)
    if not ID or not self.Data[ID] or not self.Data[ID].bag then
        return
    end
    local field = self:LoadoutFieldForSlot(slot)
    if not field then
        return
    end
    self:EnsureBagLoadoutMeta(ID)

    if not item_key or item_key == "" then
        self.Data[ID].bag.loadout[field] = nil
        self.Data[ID].bag_loadout_dirty = true
        self:SendOutBagData(ID)
        self:ScheduleDebouncedLoadoutSync(ID)
        if slot == "pet" and Pet and Pet.SyncFromOutBag then
            Pet:SyncFromOutBag(ID)
        end
        if slot == "title" and Title and Title.SyncFromOutBag then
            Title:SyncFromOutBag(ID)
        end
        if slot == "effect" and Effect and Effect.SyncFromOutBag then
            Effect:SyncFromOutBag(ID)
        end
        if slot == "attack_effect" and AttackEffect and AttackEffect.SyncFromOutBag then
            AttackEffect:SyncFromOutBag(ID)
        end
        return
    end

    local ok, errMsg = self:OutBagValidateEquip(ID, slot, item_key)
    if not ok then
        Msgs:Pop(ID, errMsg or "无法佩戴")
        return
    end
    -- 称号/特效/宠物同槽位仅能佩戴一个，直接覆盖旧佩戴
    self.Data[ID].bag.loadout[field] = item_key
    self.Data[ID].bag_loadout_dirty = true
    self:SendOutBagData(ID)
    self:ScheduleDebouncedLoadoutSync(ID)
    if slot == "pet" and Pet and Pet.SyncFromOutBag then
        Pet:SyncFromOutBag(ID)
    end
    if slot == "title" and Title and Title.SyncFromOutBag then
        Title:SyncFromOutBag(ID)
    end
    if slot == "effect" and Effect and Effect.SyncFromOutBag then
        Effect:SyncFromOutBag(ID)
    end
    if slot == "attack_effect" and AttackEffect and AttackEffect.SyncFromOutBag then
        AttackEffect:SyncFromOutBag(ID)
    end
end

function Shop:RequestOutBagSync(ID)
    if not ID then
        return
    end
    Http:POST("/bag/sync", {}, ID, function(keys)
        if keys.code == 200 and keys.data and keys.data.bag then
            self:ApplyBagAndNotify(ID, keys.data.bag)
        else
            local code = keys and keys.code or 0
            local msg = keys and keys.message or "unknown"
            -- print("[OutBag] sync failed code=" .. tostring(code) .. " msg=" .. tostring(msg))
            if code == 401 or code == 403 or code == 404 or code == 0 then
                self:SyncOutBagViaLogin(ID)
            end
        end
    end)
end

function Shop:SyncOutBagViaLogin(ID)
    if not ID then
        return
    end
    Http:POST("/user/login", {}, ID, function(keys)
        if keys.code ~= 200 or not keys.data then
            -- print("[OutBag] login failed before bag refresh")
            return
        end
        local data = keys.data
        if data.accessToken then
            Http:SetPlayerAccessToken(ID, data.accessToken)
        end
        if data.user then
            local fo = data.first_recharge_double_open
            if fo == nil then
                fo = true
            end
            Shop:SetShopServerData(ID, data.user, fo)
        end
        if data.card then
            Shop:SetCardServerData(ID, data.card)
        end
        if self:ApplyLoginBag(ID, data) then
            self:SendData(ID)
        else
            -- print("[OutBag] login ok but no bag field — deploy server user.js with bag snapshot")
        end
    end)
end

function Shop:SyncOutBag(ID)
    if not ID then
        return
    end
    local token = Http:GetPlayerAccessToken(ID)
    if token and token ~= "" then
        self:RequestOutBagSync(ID)
        return
    end
    self:SyncOutBagViaLogin(ID)
end

function Shop:OutBagEquip(ID, slot, item_key)
    self:OutBagApplyLoadoutLocal(ID, slot, item_key)
end

function Shop:OutBagUnequip(ID, slot)
    self:OutBagApplyLoadoutLocal(ID, slot, nil)
end

function Shop:FlushPendingOutBagLoadout(ID)
    if not ID then
        return
    end
    Timers:RemoveTimer(LOADOUT_TIMER_PREFIX .. tostring(ID))
    self:FlushOutBagLoadoutToServer(ID)
end
