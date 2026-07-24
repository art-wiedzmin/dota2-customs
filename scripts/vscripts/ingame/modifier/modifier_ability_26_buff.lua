--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_ability_26_buff = class({})

--是否在面板上显示
function modifier_ability_26_buff:IsHidden()
    return false
end

function modifier_ability_26_buff:IsDebuff()
    return false
end

function modifier_ability_26_buff:IsPurgable()
    return false -- 不可被驱散
end

function modifier_ability_26_buff:RemoveOnDeath()
    return false
end

function modifier_ability_26_buff:GetTexture()
    return "scroll/ability_item_26"
end

--创建时设置
function modifier_ability_26_buff:OnCreated(kv)
    if not IsServer() then return end
    -- 如果从现有modifier创建，获取堆叠信息
    if self:GetStackCount() == 0 then
        self:SetStackCount(1)
    end
end

function modifier_ability_26_buff:OnRefresh(kv)
    if not IsServer() then return end
    local count = self:GetParent()
    -- 更新栈计数
    -- self:SetStackCount(count * 10)
end

function modifier_ability_26_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

-- 工具提示2：显示层数
function modifier_ability_26_buff:OnTooltip()
    return self:GetStackCount() * 20
end
