--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 蓄力 buff 视觉效果
modifier_ability_item_37_buff = class({})

function modifier_ability_item_37_buff:IsHidden() return false end

function modifier_ability_item_37_buff:IsPurgable() return false end

function modifier_ability_item_37_buff:Isbuff() return true end

function modifier_ability_item_37_buff:GetTexture()
    return "scroll/ability_item_37"
end

function modifier_ability_item_37_buff:OnCreated(kv)
    if not IsServer() then return end

    local hero = self:GetParent()
    if not hero or hero:IsNull() then return end

    -- 先设置初始层数为 0
    self:SetStackCount(0)

    -- 同步层数为蓄力层数
    self:SyncStacks()

    self:StartIntervalThink(0.5)
end

function modifier_ability_item_37_buff:SyncStacks()
    local hero = self:GetParent()
    if not hero or hero:IsNull() then return end

    local charge_modifier = hero:FindModifierByName("modifier_ability_item_37")
    if charge_modifier then
        self:SetStackCount(charge_modifier:GetStackCount())
    end
end

function modifier_ability_item_37_buff:OnIntervalThink()
    if not IsServer() then return end

    local hero = self:GetParent()
    local ability = self:GetAbility()

    if not hero or hero:IsNull() or not hero:IsAlive() then
        self:Destroy()
        return
    end

    if not ability then
        self:Destroy()
        return
    end

    -- 同步层数
    self:SyncStacks()

    -- 检查是否有对应的蓄力 modifier
    local charge_modifier = hero:FindModifierByName("modifier_ability_item_37")
    if not charge_modifier then
        self:Destroy()
        return
    end

end