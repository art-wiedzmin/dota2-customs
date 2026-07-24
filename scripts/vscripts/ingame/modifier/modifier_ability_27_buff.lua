--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_ability_27_buff = class({})

--是否在面板上显示
function modifier_ability_27_buff:IsHidden()
    return true
end

function modifier_ability_27_buff:IsDebuff()
    return true
end

function modifier_ability_27_buff:IsPurgable()
    return false -- 不可被驱散
end

function modifier_ability_27_buff:RemoveOnDeath()
    return true
end

function modifier_ability_27_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ability_27_buff:GetModifierIgnoreDebuffImmunity()
    if DOTA_ABILITY_PIERCE_TYPE_MAGIC_IMMUNE ~= nil then
        return DOTA_ABILITY_PIERCE_TYPE_MAGIC_IMMUNE
    end
    return 1
end

function modifier_ability_27_buff:GetTexture()
    return "scroll/ability_item_27"
end

--创建时设置
function modifier_ability_27_buff:OnCreated(kv)
    if not IsServer() then return end
    self:SetDuration(kv.dur, true)
    -- 初始化变量
    self.jchj = kv.hj
    -- 使用栈计数同步数据到客户端
    -- 将移动速度值乘以100以保留小数精度，存储在栈计数中
    self:SetStackCount(self.jchj * 100)
    self:ForceRefresh()
end

function modifier_ability_27_buff:OnRefresh(kv)
    if not IsServer() then return end
    if kv and kv.dur then
        self:SetDuration(kv.dur, true)
    end
    if kv and kv.hj then
        self.jchj = kv.hj
        self:SetStackCount(self.jchj * 100)
    end
end

function modifier_ability_27_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_IGNORE_DEBUFF_IMMUNITY,
    }
end

--护甲降低
function modifier_ability_27_buff:GetModifierPhysicalArmorBonus()
    local stack_count = self:GetStackCount()
    local hj_bonus = stack_count / 100
    return hj_bonus
end
