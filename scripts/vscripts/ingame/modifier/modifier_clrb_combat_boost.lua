--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 15 秒内 +60 攻速、+30% 移速、+30% 状态抗性（可调 duration）

modifier_clrb_combat_boost = class({})

function modifier_clrb_combat_boost:IsHidden()
    return false
end

function modifier_clrb_combat_boost:IsDebuff()
    return false
end

function modifier_clrb_combat_boost:IsPurgable()
    return true
end

function modifier_clrb_combat_boost:RemoveOnDeath()
    return true
end

function modifier_clrb_combat_boost:OnCreated(kv)
    if not IsServer() then
        return
    end
    local gjsd = kv.gjsd or 60
    local ztkx = kv.ztkx or 30
    local ydsd = kv.ydsd or 30
    local d = 3
    if d < 0 then
        d = 15
    end
    self:SetDuration(d, true)
    self.gjsd = gjsd
    self.ztkx = ztkx
    self.ydsd = ydsd
end

function modifier_clrb_combat_boost:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    }
end

function modifier_clrb_combat_boost:GetModifierAttackSpeedBonus_Constant(kv)
    -- print(self)
    return self.gjsd
end

function modifier_clrb_combat_boost:GetModifierMoveSpeedBonus_Percentage(kv)
    return self.ydsd
end

function modifier_clrb_combat_boost:GetModifierStatusResistanceStacking(kv)
    return self.ztkx
end

function modifier_clrb_combat_boost:GetTexture()
    return "item_hyperstone"
end
