--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 人机专用：逻辑对齐 modifier_rbzf，智力对魔抗的 Direct 修正为每点 -0.03（真人为 -0.06）
modifier_rbzf_bot = class({})

function modifier_rbzf_bot:IsHidden()
    return false
end

function modifier_rbzf_bot:IsDebuff()
    return false
end

function modifier_rbzf_bot:IsPurgable()
    return false
end

function modifier_rbzf_bot:RemoveOnDeath()
    return false
end

function modifier_rbzf_bot:GetTexture()
    return "scroll/rbzf"
end

function modifier_rbzf_bot:AllowIllusionDuplicate()
    return false
end

function modifier_rbzf_bot:OnCreated(kv)
    if not IsServer() then return end
end

function modifier_rbzf_bot:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANACOST_REDUCTION_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
    }
end

function modifier_rbzf_bot:GetModifierStatusResistanceStacking()
    return 25
end

function modifier_rbzf_bot:GetModifierMoveSpeedBonus_Constant()
    return 30
end

function modifier_rbzf_bot:GetModifierConstantManaRegen()
    return 10
end

function modifier_rbzf_bot:OnAttackLanded(params)
    if not IsServer() then
        return
    end
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
        attacker:Heal(heal, nil)
    end
end

function modifier_rbzf_bot:GetModifierMagicalResistanceDirectModification()
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return 0
    end
    return parent:GetIntellect(true) * (-0.05)
end
