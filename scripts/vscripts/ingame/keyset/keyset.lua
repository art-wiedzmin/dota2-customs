--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if KeySet == nil then
    KeySet = class({})
    require("ingame.KeySet.Config")
    require("ingame.KeySet.Func")
end

require("ingame.KeySet.Ui")


function KeySet:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    self:SetPetData(ID)
    self:_EnsurePetPresets(ID)
    local row = self.Data[ID]
    for s = 1, 3 do
        row.pet_presets[s] = Util:DeepCopyTab(row.pet)
    end
    row.pet_preset_active = 1
end

--- 未设置或空串时使用模板默认（记分板与客户端 Tab 一致）
function KeySet:EnsureKeybindDefaults(ID)
    local row = self.Data[ID]
    if not row or not row.keybind then
        return
    end
    local sb = row.keybind.scoreboard
    if type(sb) ~= "string" or sb == "" then
        row.keybind.scoreboard = self.Template.keybind.scoreboard
    end
end

function KeySet:SetPetData(ID)
    if not ID then
        return
    end
    for _, name in ipairs(Item.Rb or {}) do
        self.Data[ID].pet[name] = false
    end
end

function KeySet:_EnsurePetPresets(ID)
    local row = self.Data[ID]
    if not row then
        return
    end
    if row.pet_presets == nil or type(row.pet_presets) ~= "table" then
        row.pet_presets = { [1] = {}, [2] = {}, [3] = {} }
    end
    for s = 1, 3 do
        if row.pet_presets[s] == nil or type(row.pet_presets[s]) ~= "table" then
            row.pet_presets[s] = {}
        end
    end
    local a = tonumber(row.pet_preset_active)
    if not a or a < 1 or a > 3 then
        row.pet_preset_active = 1
    else
        row.pet_preset_active = math.floor(a)
    end
end

--- 为 Item.Rb 中每一项补全键；三套预设与 row.pet 一并维护
function KeySet:EnsurePetKeys(ID)
    if not ID or not self.Data[ID] or not self.Data[ID].pet then
        return
    end
    self:_EnsurePetPresets(ID)
    local row = self.Data[ID]
    for s = 1, 3 do
        for _, name in ipairs(Item.Rb or {}) do
            if row.pet_presets[s][name] == nil then
                row.pet_presets[s][name] = false
            end
        end
    end
    for _, name in ipairs(Item.Rb or {}) do
        if row.pet[name] == nil then
            row.pet[name] = false
        end
    end
end

--- 将当前生效预设抄到 row.pet（宠物拾取读 row.pet）
function KeySet:SyncActivePetToRow(ID)
    local row = self.Data[ID]
    if not row or not row.pet then
        return
    end
    self:_EnsurePetPresets(ID)
    local a = row.pet_preset_active or 1
    if a < 1 or a > 3 then
        a = 1
    end
    row.pet_preset_active = a
    local src = row.pet_presets[a]
    for _, name in ipairs(Item.Rb or {}) do
        row.pet[name] = src[name] == true
    end
end

function KeySet:OpenPage(ID)
    if not ID then return end
    self.Data[ID].page = true
    self:SendData(ID)
end

function KeySet:ClosePage(ID)
    if not ID then return end
    self.Data[ID].page = false
    self:SendData(ID)
end

function KeySet:SendPublicData()
end

--- 将客户端某一预设表写入 pet_presets[slot]（仅 Item.Rb）
function KeySet:_ApplyPetMapToSlot(ID, slot, petClient)
    if not ID or not slot or slot < 1 or slot > 3 then
        return
    end
    if not petClient or type(petClient) ~= "table" then
        return
    end
    self:_EnsurePetPresets(ID)
    local row = self.Data[ID]
    local allow = {}
    for _, name in ipairs(Item.Rb or {}) do
        allow[name] = true
    end
    local dest = row.pet_presets[slot]
    for k, v in pairs(petClient) do
        if allow[k] then
            dest[k] = (v == true or v == 1 or v == "1")
        end
    end
end

function KeySet:_ApplyPetFromClient(ID, petClient)
    if not ID or not self.Data[ID] or not self.Data[ID].pet then
        return
    end
    if not petClient or type(petClient) ~= "table" then
        return
    end
    self:_EnsurePetPresets(ID)
    local allow = {}
    for _, name in ipairs(Item.Rb or {}) do
        allow[name] = true
    end
    for k, v in pairs(petClient) do
        if allow[k] then
            self.Data[ID].pet[k] = (v == true or v == 1 or v == "1")
        end
    end
end

--- clientBundle 可为 SaveKeyBind 的 data：含 pet_presets、pet_preset_active；兼容仅 pet
function KeySet:SaveKeyBind(ID, list, clientBundle)
    if not ID or not self.Data[ID] then
        return
    end
    local row = self.Data[ID]
    if list and type(list) == "table" then
        for _, v in ipairs(list) do
            if type(v) == "table" and v.id then
                row.keybind[v.id] = v.key
            end
        end
    end
    local bd = clientBundle
    if type(bd) ~= "table" then
        bd = {}
    end
    self:_EnsurePetPresets(ID)
    if bd.pet_presets and type(bd.pet_presets) == "table" then
        for s = 1, 3 do
            local slotMap = bd.pet_presets[s] or bd.pet_presets[tostring(s)]
            if type(slotMap) == "table" then
                self:_ApplyPetMapToSlot(ID, s, slotMap)
            end
        end
    elseif bd.pet and type(bd.pet) == "table" then
        self:_ApplyPetFromClient(ID, bd.pet)
        for s = 1, 3 do
            for k, v in pairs(row.pet) do
                row.pet_presets[s][k] = v
            end
        end
    end
    local a = tonumber(bd.pet_preset_active)
    if a and a >= 1 and a <= 3 then
        row.pet_preset_active = math.floor(a)
    end
    self:EnsurePetKeys(ID)
    self:SyncActivePetToRow(ID)
    self:SendData(ID)
    self:PersistToServer(ID)
end

--- 登录后从 user.keyset 合并（仅覆盖已有模板字段）
function KeySet:ApplyUserKeyset(ID, user)
    if not ID or not user then
        return
    end
    local raw = user.keyset
    if raw == nil then
        return
    end
    local tab = nil
    if type(raw) == "table" then
        tab = raw
    elseif type(raw) == "string" and raw ~= "" then
        local ok, decoded = pcall(function()
            return JSON.decode(raw)
        end)
        if ok and type(decoded) == "table" then
            tab = decoded
        end
    end
    if not tab then
        return
    end
    self:ApplyKeysetTable(ID, tab)
    self:EnsurePetKeys(ID)
end

function KeySet:ApplyKeysetTable(ID, tab)
    local row = self.Data[ID]
    if not row or type(tab) ~= "table" then
        return
    end
    self:_EnsurePetPresets(ID)
    if tab.keybind and type(tab.keybind) == "table" and row.keybind then
        for k, _ in pairs(row.keybind) do
            local sv = tab.keybind[k]
            if sv ~= nil then
                row.keybind[k] = sv
            end
        end
    end
    if tab.pet_presets and type(tab.pet_presets) == "table" then
        for s = 1, 3 do
            local slot = tab.pet_presets[s] or tab.pet_presets[tostring(s)]
            if type(slot) == "table" then
                for _, name in ipairs(Item.Rb or {}) do
                    local sv = slot[name]
                    if sv ~= nil then
                        row.pet_presets[s][name] = (sv == true or sv == 1 or sv == "1")
                    end
                end
            end
        end
    elseif tab.pet and type(tab.pet) == "table" and row.pet then
        for k, _ in pairs(row.pet) do
            local sv = tab.pet[k]
            if sv ~= nil then
                row.pet[k] = (sv == true or sv == 1 or sv == "1")
            end
        end
        for s = 1, 3 do
            for k, v in pairs(row.pet) do
                row.pet_presets[s][k] = v
            end
        end
    end
    local ap = tonumber(tab.pet_preset_active)
    if ap and ap >= 1 and ap <= 3 then
        row.pet_preset_active = math.floor(ap)
    end
    self:EnsureKeybindDefaults(ID)
    self:EnsurePetKeys(ID)
    self:SyncActivePetToRow(ID)
end

function KeySet:BuildPersistJson(ID)
    local row = self.Data[ID]
    if not row then
        return nil
    end
    self:_EnsurePetPresets(ID)
    local presetsOut = {}
    for s = 1, 3 do
        presetsOut[tostring(s)] = Util:DeepCopyTab(row.pet_presets[s])
    end
    local persist = {
        keybind = Util:DeepCopyTab(row.keybind),
        pet = Util:DeepCopyTab(row.pet),
        pet_presets = presetsOut,
        pet_preset_active = row.pet_preset_active or 1,
    }
    local ok, s = pcall(function()
        return JSON.encode(persist)
    end)
    if ok and type(s) == "string" then
        return s
    end
    return nil
end

function KeySet:PersistToServer(ID)
    if not ID or not PlayerResource:IsValidPlayer(ID) then
        return
    end
    local jsonStr = self:BuildPersistJson(ID)
    if not jsonStr or jsonStr == "" then
        return
    end
    Http:POST("/user/sync/keyset", { keyset = jsonStr }, ID, function(keys)
        if keys.code ~= 200 then
            -- print("[KeySet] sync keyset failed code=" .. tostring(keys.code))
        end
    end)
end

function KeySet:OnPlayerKeyDown(ID, data)
    if not ID or not data then
        return
    end
    local action = data.action
    local key = data.key
    -- print(data)
    if action == "scoreboard" then
        Stat:ChangePage(ID)
    end
    if action == "eazyshop" then
        EazyShop:ChangePage(ID)
    end
end
