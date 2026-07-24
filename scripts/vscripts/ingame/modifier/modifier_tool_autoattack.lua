--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if modifier_tool_autoattack == nil then
    modifier_tool_autoattack = class({})
end

function modifier_tool_autoattack:IsHidden()
    return true
end

function modifier_tool_autoattack:IsDebuff()
    return false
end

function modifier_tool_autoattack:IsPurgable()
    return false
end

function modifier_tool_autoattack:RemoveOnDeath()
    return false
end

function modifier_tool_autoattack:AllowIllusionDuplicate()
    return false
end

function modifier_tool_autoattack:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT +
        MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_tool_autoattack:OnCreated()
    if not IsServer() then return end
    self.needattack = 1
    self:OnIntervalThink()
    self:StartIntervalThink(0.15)
end

function modifier_tool_autoattack:OnIntervalThink()
    if not IsServer() then return end
    local pa = self:GetParent()
    if not pa then return end
    if pa:IsNull() then return end
    if pa:IsMoving() then return end
    if not pa:IsAlive() then return end
    if pa:IsAttacking() then return end
    if pa:IsChanneling() then return end
    if GameRules:IsGamePaused() then return end
    if pa:GetCurrentActiveAbility() then return end
    if pa:GetAggroTarget() then return end
    if pa:IsDisarmed() then return end
    if pa:HasModifier("modifier_teleport_up_slow") then return end
    if pa:HasModifier("modifier_teleport_up_fast") then return end
    if pa:HasModifier("modifier_generic_arc") then return end
    if self.needattack == 0 then
        return
    end
    if pa.needautoattack ~= nil then
        if pa.needautoattack == 0 then
            return
        end
    end
    local range = pa:Script_GetAttackRange()
    if range < 300 then range = 300 end
    local enemy = Util:Radius2Enemy(pa, range)
    for i = 1, #enemy do
        if enemy[i] then
            if enemy[i]:IsAlive() then
                local tapos = enemy[i]:GetAbsOrigin()
                local papos = pa:GetAbsOrigin()
                local fx = (tapos - papos):Normalized()
                pa:SetForwardVector(Vector(fx.x, fx.y, 0))
                -- pa:MoveToPositionAggressive(enemy[i]:GetOrigin())
                local order = {
                    UnitIndex = pa:entindex(),
                    OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
                    TargetIndex = enemy[i]:entindex(),
                }
                ExecuteOrderFromTable(order)
                return
            end
        end
    end
end

function modifier_tool_autoattack:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ORDER, }
end

function modifier_tool_autoattack:OnOrder(keys)
    if not IsServer() then return end
    local pa = self:GetParent()
    local unit = keys.unit
    local order_type = keys.order_type
    if pa == pa and (order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or order_type == DOTA_UNIT_ORDER_CAST_POSITION or order_type == DOTA_UNIT_ORDER_NONE) then
        self.needattack = 0
        Timers(0.15, function()
            if not self then return end
            if self:IsNull() then return end
            self.needattack = 1
        end)
    end
end

--LinkLuaModifier("modifier_tool_autoattack","ingame/modifier/tools/modifier_tool_autoattack",LUA_MODIFIER_MOTION_NONE)
