--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 局外背包佩戴宠物 -> 局内显示与自动拾取

function Pet:PetAiTimerName(ID)
    return "clrb_pet_ai_" .. tostring(ID)
end

function Pet:StopPetAi(ID)
    if not ID then
        return
    end
    Timers:RemoveTimer(self:PetAiTimerName(ID))
    if self.Data[ID] then
        self.Data[ID].pet_ai_timer = nil
    end
end

function Pet:IsPickupEnabled(ID)
    if not ID or not self.Data[ID] then
        return false
    end
    if Util and Util.ID2IfOnline and not Util:ID2IfOnline(ID) then
        return false
    end
    return self.Data[ID].pick_enabled == true
end

--- 宠物仅挂配置的环境光效；剥离误挂的英雄周身特效（燃烧末日等）
function Pet:ApplyPetAmbient(unit, ID)
    if not unit or unit:IsNull() then
        return
    end
    if unit:HasModifier("modifier_clrb_effect") then
        unit:RemoveModifierByName("modifier_clrb_effect")
    end
    if unit:HasModifier("modifier_clrb_pet_ambient") then
        unit:RemoveModifierByName("modifier_clrb_pet_ambient")
    end
    local petFx = Shop and Shop.GetEquippedPetParticle and Shop:GetEquippedPetParticle(ID)
    if petFx and petFx ~= "" then
        unit:AddNewModifier(unit, nil, "modifier_clrb_pet_ambient", { ambient_fx = petFx })
    end
end

function Pet:GetLivePet(ID)
    if not ID or not self.Data[ID] then
        return nil
    end
    local index = self.Data[ID].index
    if not index or index < 0 then
        return nil
    end
    local pet = EntIndexToHScript(index)
    if not pet or pet:IsNull() or not pet:IsAlive() then
        return nil
    end
    return pet
end

function Pet:RemovePet(ID)
    if not ID or not self.Data[ID] then
        return
    end
    self:StopPetAi(ID)
    self:ClosePick(ID)
    self.Data[ID].pick_enabled = false
    self.Data[ID].session_pet_ready = true
    local pet = self:GetLivePet(ID)
    if pet then
        if Util and Util.Entity2Kill then
            Util:Entity2Kill(pet)
        else
            pet:ForceKill(false)
            if pet.IsAlive and not pet:IsAlive() then
                pet:RemoveSelf()
            end
        end
    end
    self.Data[ID].index = -1
end

function Pet:SyncFromOutBag(ID)
    if not ID or not self.Data[ID] then
        return
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return
    end
    local should_show = Shop and Shop.ShouldShowInGamePet and Shop:ShouldShowInGamePet(ID)
    local pet_key = ""
    if Shop and Shop.GetEquippedPetKey then
        pet_key = Shop:GetEquippedPetKey(ID) or ""
    end
    local prev_key = self.Data[ID].equipped_pet_key or ""
    if pet_key ~= prev_key then
        self.Data[ID].equipped_pet_key = pet_key
        if self:GetLivePet(ID) then
            self:RemovePet(ID)
        end
    end
    if not should_show then
        self:RemovePet(ID)
        return
    end

    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() or not hero:IsAlive() then
        if should_show then
            self.Data[ID].pick_enabled = true
        end
        return
    end

    if self:GetLivePet(ID) then
        self:ApplyPetAmbient(self:GetLivePet(ID), ID)
        self.Data[ID].pick_enabled = true
        self.Data[ID].session_pet_ready = true
        return
    end

    self:StopPetAi(ID)
    self:InitPet(ID)
end
