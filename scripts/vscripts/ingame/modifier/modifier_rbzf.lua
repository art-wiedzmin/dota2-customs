--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_rbzf = class({})

function modifier_rbzf:IsHidden()
    return false
end

function modifier_rbzf:IsDebuff()
    return false
end

function modifier_rbzf:IsPurgable()
    return false
end

--死亡时是否移除
function modifier_rbzf:RemoveOnDeath()
    return false
end

function modifier_rbzf:GetTexture()
    return "scroll/rbzf"
end

function modifier_rbzf:AllowIllusionDuplicate()
    return false
end

function modifier_rbzf:OnCreated(kv)
    if not IsServer() then return end
    -- print("buff添加成功")
end

function modifier_rbzf:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANACOST_REDUCTION_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        -- MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION
    }
end

function modifier_rbzf:GetModifierMagicalResistanceDirectModification()
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return 0
    end
    return parent:GetIntellect(true) * (-0.06)
end

function modifier_rbzf:GetModifierStatusResistanceStacking()
    return 25
end

function modifier_rbzf:GetModifierMoveSpeedBonus_Constant()
    return 30
end

function modifier_rbzf:GetModifierConstantManaRegen()
    return 10
end

function modifier_rbzf:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local target = params.target
    if attacker ~= self:GetParent() then
        return
    end
    if not attacker:IsHero() then
        return
    end
    local ID = Util:Hero2ID(attacker)
    if ID then
        local mfgj = HeroData:GetSX(ID, "mfgj")
        if mfgj > 0 then
            utilex:UnitDam(attacker, target, mfgj, "mf", nil, true)
        end

        local damage = params.damage
        local num1 = HeroData:GetSX(ID, "gjxx")
        if num1 <= 0 then
            return
        end
        local heal = math.floor((damage * num1 / 100))
        -- print("吸血" .. heal)
        attacker:Heal(heal, nil)
    end
end


