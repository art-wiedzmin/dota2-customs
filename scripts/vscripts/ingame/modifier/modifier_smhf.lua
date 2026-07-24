--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_smhf = class({})

--该modifier是否是负面的
function modifier_smhf:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_smhf:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_smhf:IsHidden()
    return true
end

--死亡时是否移除
function modifier_smhf:RemoveOnDeath()
    return false
end

function modifier_smhf:OnCreated(kv)
    if not IsServer() then return end

    self.health_regen_bonus = kv.health_regen or 1
    self.unit_index = self:GetParent():GetEntityIndex()

    -- 使用栈计数同步基础数据
    self:SetStackCount(math.floor(self.health_regen_bonus * 100))

    -- 使用网络表同步详细数据
    self:UpdateNetTable()

    -- 强制刷新属性
    self:ForceRefresh()
    self:GetParent():CalculateStatBonus(true)
end

function modifier_smhf:OnRefresh(kv)
    if not IsServer() then return end

    if kv.health_regen then
        self.health_regen_bonus = kv.health_regen
        self:SetStackCount(math.floor(self.health_regen_bonus * 100))
        self:UpdateNetTable()
        --self:ForceRefresh()
        self:GetParent():CalculateStatBonus(true)
    end
end

-- 更新网络表数据
function modifier_smhf:UpdateNetTable()
    if not IsServer() then return end

    local parent = self:GetParent()
    local playerID = parent:GetPlayerOwnerID()

    -- 将数据存入网络表
    CustomNetTables:SetTableValue("health_regen_data", tostring(self.unit_index), {
        health_regen = self.health_regen_bonus,
        unit_name = parent:GetUnitName(),
        player_id = playerID
    })
    -- 客户端请订阅 CustomNetTables「health_regen_data」；勿再全体广播同名 CustomGameEvent，避免与 NetTable 重复同步
end

function modifier_smhf:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_smhf:GetModifierConstantHealthRegen()
    return self:GetStackCount() / 100.0
end

function modifier_smhf:SetHealthRegenBonus(value)
    if not IsServer() then return end

    self.health_regen_bonus = value
    self:SetStackCount(math.floor(value * 100))
    self:UpdateNetTable()
    self:ForceRefresh()
    self:GetParent():CalculateStatBonus(true)
end

-- 清理网络表数据
function modifier_smhf:OnDestroy()
    if not IsServer() then return end

    CustomNetTables:SetTableValue("health_regen_data", tostring(self.unit_index), nil)
end
