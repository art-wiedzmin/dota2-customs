modifier_ability_item_33 = class({})

local SKILL_NAME = "ability_item_33"

local function abi33_resolve(self)
    local ab = self:GetAbility()
    if ab and not ab:IsNull() then return ab end
    local u = self:GetParent()
    if u and not u:IsNull() and u.FindAbilityByName then
        return u:FindAbilityByName(SKILL_NAME)
    end
    return nil
end

--- 取值用等级：必须与 AbilityValues 档位一致（与 stack 复制无关）
local function abi33_value_level(ab)
    if not ab or ab:IsNull() then return 0 end
    local lv = ab:GetLevel()
    if lv < 1 then return 0 end
    local mx = (ab.GetMaxLevel and ab:GetMaxLevel()) or 10
    if lv > mx then lv = mx end
    return lv
end

local function abi33_read(ab, key, lv)
    if not ab or ab:IsNull() or lv < 1 then return 0 end
    if type(GetAbilitySpecialValueByLevel) == "function" then
        return GetAbilitySpecialValueByLevel(ab, key, lv)
    end
    if ab.GetLevelSpecialValueFor then
        return ab:GetLevelSpecialValueFor(key, lv - 1) or 0
    end
    return 0
end

function modifier_ability_item_33:IsHidden()
    return true
end

function modifier_ability_item_33:IsPurgable()
    return false
end

function modifier_ability_item_33:OnCreated()
    -- 须在客户端也可用技能等级读出 KV，不能只靠服务端 Refresh 写 stack（否则预览/生效易为 0）
    self:ForceRefresh()
end

function modifier_ability_item_33:OnRefresh(kv)
    local ability = abi33_resolve(self)
    if ability and not ability:IsNull() then
        self:SetStackCount(ability:GetLevel())
    end
end

function modifier_ability_item_33:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_ability_item_33:GetModifierPercentageCooldown()
    local ab = abi33_resolve(self)
    local lv = abi33_value_level(ab)
    return abi33_read(ab, "num1", lv)
end

function modifier_ability_item_33:GetModifierPercentageManacostStacking()
    local ab = abi33_resolve(self)
    local lv = abi33_value_level(ab)
    return abi33_read(ab, "num2", lv)
end

function modifier_ability_item_33:GetModifierConstantManaRegen()
    local ab = abi33_resolve(self)
    local lv = abi33_value_level(ab)
    return abi33_read(ab, "num3", lv)
end
