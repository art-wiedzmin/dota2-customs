-- 光环效果modifier
modifier_ability_item_8_effect = class({})

-- 初始化
function modifier_ability_item_8_effect:OnCreated()
    if not IsServer() then return end
end

-- 刷新
function modifier_ability_item_8_effect:OnRefresh()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_8_effect:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACKED
    }
end

-- 处理伤害事件
function modifier_ability_item_8_effect:OnAttacked(keys)
    if not IsServer() then return end
    local parent   = self:GetParent()
    local attacker = keys.attacker
    local target   = keys.target
    -- 检查是否是被此单位攻击
    if target ~= parent then
        return
    end
    -- 检查攻击者是否有效
    if not attacker or attacker:IsNull() or not attacker:IsAlive() then
        return
    end
    local damage = keys.damage
    local ability = self:GetAbility()
    if not ability or ability:IsNull() then
        return
    end
    if parent:IsHero() then
        local ID = Util:Hero2ID(parent)
        if ID then
            local dam_num = ability:GetSpecialValueFor("num1")
            local dam = math.ceil(damage * dam_num / 100)
            utilex:UnitDam(parent, attacker, dam, "wl")
        end
    end
end

-- 是否隐藏
function modifier_ability_item_8_effect:IsHidden()
    return false
end

-- 是否可驱散
function modifier_ability_item_8_effect:IsPurgable()
    return false
end
