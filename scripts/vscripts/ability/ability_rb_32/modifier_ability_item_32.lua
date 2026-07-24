-- 万化冥想（ability_item_32）：每秒储存经验，移除技能时一次性获得
modifier_ability_item_32 = class({})

local SKILL_NAME = "ability_item_32"

local function resolve_ability(self)
    local ab = self:GetAbility()
    if ab and not ab:IsNull() then
        return ab
    end
    local hero = self:GetParent()
    if hero and not hero:IsNull() and hero.FindAbilityByName then
        return hero:FindAbilityByName(SKILL_NAME)
    end
    return nil
end

local function exp_rate_for_ability(ability)
    if not ability or ability:IsNull() or ability:GetLevel() < 1 then
        return 0
    end
    return math.max(0, math.floor(ability:GetSpecialValueFor("num1") or 0))
end

local function hero_player_id(hero)
    if not hero or hero:IsNull() then
        return nil
    end
    return Util:Hero2ID(hero)
end

local function is_bot_player(ID)
    if not ID then
        return false
    end
    if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return true
    end
    if PlayerResource and PlayerResource.GetPlayerName then
        local n = PlayerResource:GetPlayerName(ID)
        if n and string.match(n, "^bot_player_%d+$") then
            return true
        end
    end
    return false
end

function modifier_ability_item_32:IsHidden()
    return false
end

function modifier_ability_item_32:IsDebuff()
    return false
end

function modifier_ability_item_32:IsPurgable()
    return false
end

function modifier_ability_item_32:RemoveOnDeath()
    return false
end

function modifier_ability_item_32:GetTexture()
    return "scroll/ability_item_32"
end

function modifier_ability_item_32:OnCreated()
    if not IsServer() then
        return
    end
    self:_sync_stack_from_data()
    self:StartIntervalThink(1)
end

function modifier_ability_item_32:OnRefresh()
    if not IsServer() then
        return
    end
    self:_sync_stack_from_data()
end

function modifier_ability_item_32:_stored_exp(ID)
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return 0
    end
    local ha = HeroData.Data[ID].hero_attr
    if not ha then
        return 0
    end
    return math.max(0, math.floor(tonumber(ha.skill_32_stored_exp) or 0))
end

function modifier_ability_item_32:_set_stored_exp(ID, value)
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return
    end
    local ha = HeroData.Data[ID].hero_attr
    if not ha then
        return
    end
    ha.skill_32_stored_exp = math.max(0, math.floor(value or 0))
    self:SetStackCount(ha.skill_32_stored_exp)
end

function modifier_ability_item_32:_sync_stack_from_data()
    local hero = self:GetParent()
    local ID = hero_player_id(hero)
    self:SetStackCount(self:_stored_exp(ID))
end

function modifier_ability_item_32:OnIntervalThink()
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    if not hero or hero:IsNull() or not Util:IsPlayerHeroForData(hero) then
        return
    end
    local ability = resolve_ability(self)
    if not ability or ability:IsNull() then
        return
    end
    local rate = exp_rate_for_ability(ability)
    if rate <= 0 then
        return
    end
    local ID = hero_player_id(hero)
    local stored = self:_stored_exp(ID) + rate
    self:_set_stored_exp(ID, stored)
end

function modifier_ability_item_32:OnDestroy()
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    if not hero or hero:IsNull() then
        return
    end
    local ID = hero_player_id(hero)
    local stored = self:_stored_exp(ID)
    if ID and HeroData and HeroData.Data and HeroData.Data[ID] and HeroData.Data[ID].hero_attr then
        HeroData.Data[ID].hero_attr.skill_32_stored_exp = 0
    end
    if stored <= 0 then
        return
    end
    local grant = stored
    if is_bot_player(ID) then
        grant = math.floor(grant * 1.6 + 0.5)
    end
    hero:AddExperience(grant, DOTA_ModifyXP_Unspecified or 0, false, false)
    if ID then
        Util:BottomMsg2ID(ID, "冥想：获得储存经验 " .. tostring(grant), "yellow", 3)
    end
end

function modifier_ability_item_32:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_ability_item_32:OnTooltip()
    return self:GetStackCount()
end
