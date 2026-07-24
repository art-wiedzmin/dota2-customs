--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Pet == nil then
    Pet = class({})
    -- 与 init.precache.modifier_all 重复注册无害；避免入口/重载顺序导致 unknown modifier_petbuff
    LinkLuaModifier("modifier_petbuff", "ingame/modifier/modifier_petbuff",
        LUA_MODIFIER_MOTION_NONE)
    require("ingame.Pet.Config")
    require("ingame.Pet.Set")
    require("ingame.Pet.Get")
    require("ingame.Pet.Ui")
    require("ingame.Pet.Func")
end

--- 与毒圈/批量删怪一致：识别 CardPet 单位名（见 utilex:IsClrbCourierPet）
function Pet:IsCourierPet(ent)
    if not utilex or not utilex.IsClrbCourierPet then
        return false
    end
    return utilex:IsClrbCourierPet(ent)
end

function Pet:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

-- 宠物初始化（需局外背包已佩戴宠物）
function Pet:InitPet(ID)
    if not ID then return end
    if Shop and Shop.ShouldShowInGamePet and not Shop:ShouldShowInGamePet(ID) then
        return
    end
    if self:GetLivePet(ID) then
        return
    end
    self:StopPetAi(ID)
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then return end
    local ve = utilex:GetRandomPoint(ID, hero:GetAbsOrigin(), 300)
    local team = PlayerResource:GetTeam(ID)
    local unitName = "CardPet"
    if Shop and Shop.GetEquippedPetUnitName then
        unitName = Shop:GetEquippedPetUnitName(ID) or unitName
    end
    local unit = CreateUnitByName(unitName, ve, true, hero, hero, team)
    local modelPath = Shop and Shop.GetEquippedPetModelPath and Shop:GetEquippedPetModelPath(ID)
    if modelPath and modelPath ~= "" then
        unit:SetModel(modelPath)
    end
    local index = unit:GetEntityIndex()
    self.Data[ID].index = index
    FindClearSpaceForUnit(unit, ve, true)
    unit:AddNewModifier(unit, nil, "modifier_phased", { duration = 0.1 })
    utilex:AddModifier(unit, "modifier_petbuff")
    self:ApplyPetAmbient(unit, ID)
    utilex:AnimationModifier(unit)
    self:PetAi(ID, hero, unit)
    unit:SetBaseMoveSpeed(550)
    if self.Data[ID] then
        self.Data[ID].pick_enabled = true
        self.Data[ID].session_pet_ready = true
        if Shop and Shop.GetEquippedPetKey then
            self.Data[ID].equipped_pet_key = Shop:GetEquippedPetKey(ID) or ""
        end
    end
    --宠物消失监听
    -- self:PetDisappear(ID)
end

-- function Pet:PetDisappear(ID)
--     if not ID then return end
--     local hero = Util:ID2Hero(ID)
--     if not hero then return end
--     local index = self.Data[ID].index
--     local pet = EntIndexToHScript(index)
--     Timers(2, function()
--         if not pet or pet:IsNull() or not pet:IsAlive() then
--             self:InitPet(ID)
--             return
--         end
--         return 2
--     end)
-- end

function Pet:PetAi(ID, hero, unit)
    if not unit or not hero then return end
    local timer_name = self:PetAiTimerName(ID)
    self:StopPetAi(ID)
    if self.Data[ID] then
        self.Data[ID].pet_ai_timer = timer_name
    end
    local unit_index = unit:entindex()
    Timers:CreateTimer(timer_name, {
        endTime = 1,
        callback = function()
        if not self:IsPickupEnabled(ID) then
            if Shop and Shop.ShouldShowInGamePet and Shop:ShouldShowInGamePet(ID) then
                return 0.5
            end
            return nil
        end
        local live = self:GetLivePet(ID)
        if live and live:entindex() ~= unit_index then
            return nil
        end
        -- 安全校验：单位被销毁时调用 IsAlive/IsNull 可能抛错，导致定时器停掉、宠物不再跟随
        local unit_ok, unit_alive = pcall(function()
            return unit and not unit:IsNull() and unit:IsAlive()
        end)
        if not unit_ok or not unit_alive then
            if self:GetLivePet(ID) then
                return nil
            end
            if Shop and Shop.ShouldShowInGamePet and Shop:ShouldShowInGamePet(ID) then
                self:InitPet(ID)
            end
            return 0.5
        end
        -- 每 tick 用 ID 取当前英雄，避免英雄重生/替换后句柄失效
        local hero_now = Util:ID2Hero(ID)
        if not hero_now or hero_now:IsNull() or not hero_now:IsHero() or not hero_now:IsRealHero() then return 0.5 end
        if self:GetPick(ID) then return 0.5 end
        local hero_pos = hero_now:GetAbsOrigin()
        Pet:PetBack(hero_pos, unit)

        -- FindAllByClassnameWithin 中心需 vectorws，GetAbsOrigin 为 vector，故用距离过滤
        local r_sq = self.Static.pick
        local tab = {}
        for _, ent in pairs(Entities:FindAllByClassname("dota_item_drop")) do
            if ent and not ent:IsNull() and
                (hero_pos - ent:GetAbsOrigin()):Length2D() <= r_sq then
                table.insert(tab, ent)
            end
        end
        if tab and hero_now:IsAlive() then self:PetPick(ID, unit, tab) end
        self:PetWalk(ID, hero_pos, unit)
        return 0.5
        end,
    })
end

function Pet:PetBack(hero_pos, unit)
    local pet_pos = unit:GetAbsOrigin()
    local len = (hero_pos - pet_pos):Length2D()
    if len >= self.Static.follow and len < self.Static.back then
        unit:MoveToPosition(hero_pos)
    end
    if len > self.Static.back then
        -- print("宠物返回")
        local random_pos = utilex:GetRandomPosMax(hero_pos, 150)
        unit:SetAbsOrigin(random_pos)
    end
end

function Pet:PetPick(ID, unit, item_list)
    if not unit or not item_list or not self:IsPickupEnabled(ID) then return end
    for k, v in pairs(item_list) do
        if v:GetContainedItem() then
            local item = v:GetContainedItem()
            if item and not item:IsNull() then
                local item_name = item:GetName()
                if not Pet:IsMeleeBookBannedAfterDelete(ID, item_name)
                    and not Pet:ShouldBlockPetMeleeBaseBookWhenHasUpVersion(ID, item_name)
                    and (Item:IsHaveItem(ID, item_name) or Pet:IsPickList(item_name) or
                        Pet:IsHaveRb(ID, item_name) or
                        Pet:IsKeySetPetPickupEnabled(ID, item_name))
                    and not Pet:IsMeleeSkillBookSkillMaxed(ID, item_name) then
                    self:PetRunToItem(ID, unit, v)
                    return
                end
            end
        end
    end
end

function Pet:PetRunToItem(ID, unit, item_box)
    if not ID or not unit or not item_box then return end
    if unit:IsNull() or item_box:IsNull() then return end
    if not self:IsPickupEnabled(ID) then return end
    local hero = Util:ID2Hero(ID)
    -- 开始拾取
    self:OpenPick(ID)
    Timers(0.1, function()
        if not self:IsPickupEnabled(ID) or not self:GetPick(ID) then
            self:ClosePick(ID)
            return
        end
        local unit_now = self:GetLivePet(ID)
        if not unit_now then
            self:ClosePick(ID)
            return
        end
        if not item_box or item_box:IsNull() then
            self:ClosePick(ID)
            return
        end
        local item = item_box:GetContainedItem()
        if not item or item:IsNull() then
            self:ClosePick(ID)
            return
        end
        local ok_item_pos, item_pos = pcall(function()
            return item_box:GetAbsOrigin()
        end)
        if not ok_item_pos or not item_pos then
            self:ClosePick(ID)
            return
        end
        local ok_unit_pos, unit_pos = pcall(function()
            return unit_now:GetAbsOrigin()
        end)
        if not ok_unit_pos or not unit_pos then
            self:ClosePick(ID)
            return
        end
        local len = (unit_pos - item_pos):Length2D()
        if len <= 100 then
            if item:IsItem() then
                local item_name = item:GetName()
                if Pet:IsMeleeBookBannedAfterDelete(ID, item_name) then
                    self:ClosePick(ID)
                    return
                end
                if Pet:ShouldBlockPetMeleeBaseBookWhenHasUpVersion(ID, item_name) then
                    self:ClosePick(ID)
                    return
                end
                if Pet:IsMeleeSkillBookSkillMaxed(ID, item_name) then
                    self:ClosePick(ID)
                    return
                end
                -- print("添加物品")
                if hero and not hero:IsNull() then
                    EmitSoundOn("n_mud_golem.Boulder.Cast", hero)
                end
                local consumed = self:TryAutoConsumeMeleeSkillBookOnPetPickup(ID, item,
                    item_name)
                if not consumed then
                    if item:IsStackable() and Item:IsHaveItem(ID, item_name) then
                        local bag_item = Item:FindItem(ID, item_name)
                        if bag_item then
                            bag_item:SetCurrentCharges(bag_item:GetCurrentCharges() + 1)
                        end
                    elseif hero and not hero:IsNull() then
                        hero:AddItem(item)
                    end
                    -- hero:AddItem(item)
                end
                if item_box and not item_box:IsNull() then
                    item_box:RemoveSelf()
                end
                self:ClosePick(ID)
                return
            else
                self:ClosePick(ID)
                return
            end
        end
        unit_now:MoveToPosition(item_pos)
        return 1
    end)
end

--- 英雄对地面 dota_item_drop 发「拾取」时，与 PetRunToItem 到手后逻辑一致（肉搏技能书走自动消耗，其余叠充能或 AddItem）。
--- 不拦截「已满级不需捡」等分支（英雄可捡回卖店）；仅肉搏技能书调用 TryAutoConsume。
--- @return boolean true 表示已处理，ExecuteOrderFilter 应 return false
function Pet:TryHeroGroundPickupLikePet(hero, item_box)
    if not hero or hero:IsNull() or not item_box or item_box:IsNull() then
        return false
    end
    if not hero:IsHero() or not hero:IsRealHero() then
        return false
    end
    if item_box.GetClassname and item_box:GetClassname() ~= "dota_item_drop" then
        return false
    end
    local HERO_GROUND_PICKUP_RANGE = 300
    local hpos = hero:GetAbsOrigin()
    local ipos = item_box:GetAbsOrigin()
    if (hpos - ipos):Length2D() > HERO_GROUND_PICKUP_RANGE then
        return false
    end
    local item = item_box.GetContainedItem and item_box:GetContainedItem()
    if not item or item:IsNull() or not item:IsItem() then
        return false
    end
    local item_name = item:GetName()
    local ID = Util:Hero2ID(hero)
    if not ID then
        return false
    end
    EmitSoundOn("n_mud_golem.Boulder.Cast", hero)
    local consumed = false
    if Item and Item.IsMeleeSkillBookItemName and Item:IsMeleeSkillBookItemName(item_name) then
        consumed = self:TryAutoConsumeMeleeSkillBookOnPetPickup(ID, item, item_name)
    end
    if not consumed then
        if item:IsStackable() and Item and Item:IsHaveItem(ID, item_name) then
            local bag_item = Item:FindItem(ID, item_name)
            if bag_item then
                bag_item:SetCurrentCharges(bag_item:GetCurrentCharges() + 1)
            else
                hero:AddItem(item)
            end
        else
            hero:AddItem(item)
        end
    end
    if item_box and not item_box:IsNull() then
        item_box:RemoveSelf()
    end
    return true
end

function Pet:PetWalk(ID, hero_pos, unit)
    if self:GetPick(ID) then return end
    local roll = math.random(1, 10)
    if roll <= 3 then
        -- print("闲逛")
        local ve = utilex:RandomPos(hero_pos, 100, 300)
        unit:MoveToPosition(ve)
    end
end

function Pet:IsPickList(item_name)
    for k, v in pairs(self.PickList) do
        if item_name == v then return true end
    end
end
