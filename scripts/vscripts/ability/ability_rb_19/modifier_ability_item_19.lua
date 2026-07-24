--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_19 = class({})

function modifier_ability_item_19:IsHidden()
    return true
end

function modifier_ability_item_19:IsPurgable()
    return false
end

function modifier_ability_item_19:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_19:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

-- 攻击命中时
function modifier_ability_item_19:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local target = params.target
    --造成的伤害
    local damage = params.damage
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    if not ability then
        return
    end
    local chance = 100
    local roll = math.random(1, 100)
    if roll > chance then
        return
    end
    local len = ability:GetSpecialValueFor("num1")
    local cleave_pct = ability:GetSpecialValueFor("num2")
    local dam = math.ceil(damage * cleave_pct / 100)
    -- 同帧 DoCleaveAttack 会与主目标普攻的 AttackRecord 收尾竞态，导致 RemoveRecord 告警；延后一瞬再劈砍
    local att_e = attacker:entindex()
    local tar_e = target and not target:IsNull() and target:entindex() or -1
    local ab_e = ability:entindex()
    local cleave_len = len
    Timers(0.03, function()
        local a = EntIndexToHScript(att_e)
        local t = tar_e >= 0 and EntIndexToHScript(tar_e) or nil
        local ab_ent = EntIndexToHScript(ab_e)
        if not a or a:IsNull() or not a:IsAlive() then
            return
        end
        -- 击杀后主目标 IsAlive 为 false，劈砍仍应生效；仅实体被移除时跳过
        if not t or t:IsNull() then
            return
        end
        if not ab_ent or ab_ent:IsNull() then
            return
        end
        EmitSoundOn("hengsaoqianjun", a)
        DoCleaveAttack(a, t, ab_ent, dam, 250, cleave_len, cleave_len, "particles/scrolls/hengsaoqianjun.vpcf")
    end)
end