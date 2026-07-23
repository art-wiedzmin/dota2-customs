modifier_item_equip_4_buff = class({})

require("ingame.modifier.clrb_fly_cloud_util")

function modifier_item_equip_4_buff:IsHidden() return true end
function modifier_item_equip_4_buff:IsDebuff() return false end
function modifier_item_equip_4_buff:IsPurgable() return false end
function modifier_item_equip_4_buff:RemoveOnDeath() return false end

local function is_item_in_active_inventory(item_ability)
    if not item_ability or item_ability:IsNull() then return false end
    if not item_ability.GetItemSlot then return true end

    -- 宝箱逻辑：物品挂在 map 上的 dummy 上，主栏满时会落到 6–8「背包」格；
    -- 若仍按英雄规则判不生效，CheckState 会为空，无视地形会间歇失效。
    if item_ability.GetParent then
        local holder = item_ability:GetParent()
        if holder and not holder:IsNull() and holder:GetUnitName() == "dummy" then
            return true
        end
    end

    local slot = item_ability:GetItemSlot()
    if slot == nil then return true end

    -- 0-5：主物品栏生效；6-8：备用栏(背包)不生效；9+：其他位置(如仓库)不生效
    -- 16：中立物品栏（保持生效）
    if slot == 16 then return true end
    return slot >= 0 and slot <= 5
end

function modifier_item_equip_4_buff:IsEnabled()
    return is_item_in_active_inventory(self:GetAbility())
end

function modifier_item_equip_4_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_RESPAWN,
    }
end

function modifier_item_equip_4_buff:GetModifierMoveSpeedBonus_Constant()
    if not self:IsEnabled() then return 0 end
    return 150
end

function modifier_item_equip_4_buff:CheckState()
    if not self:IsEnabled() then
        return {}
    end
    return {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end



function modifier_item_equip_4_buff:OnCreated()
    if not IsServer() then
        return
    end
    self._en_snap = self:IsEnabled()
    self:StartIntervalThink(0.75)
    ClrbFlyCloudScheduleSync(self:GetParent())
end

function modifier_item_equip_4_buff:OnDestroy()
    if not IsServer() then
        return
    end
    ClrbFlyCloudSync(self:GetParent())
end

function modifier_item_equip_4_buff:OnRespawn()
    if not IsServer() then
        return
    end
    ClrbFlyCloudScheduleSync(self:GetParent())
end

function modifier_item_equip_4_buff:OnIntervalThink()
    if not IsServer() then return end
    local en = self:IsEnabled()
    if en == self._en_snap then return end
    self._en_snap = en
    local p = self:GetParent()
    if p and not p:IsNull() and p:IsHero() then
        p:CalculateStatBonus(true)
    end
    ClrbFlyCloudSync(p)
end
