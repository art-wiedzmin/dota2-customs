--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 天赋 2「识破」：凯招架窗口（锁朝向 + 1 技能施法动作 + 格挡正面半区首次普攻）→ 力丸闪袭绕后眩晕

modifier_clrb_insight = class({})

local PARRY_VFX = "particles/units/heroes/hero_kez/kez_parry.vpcf"
local BLINK_VFX = "particles/units/heroes/hero_riki/riki_blink_strike.vpcf"
local MAX_BLINK = 2000
local BEHIND_DIST = 56
--- 一技能动作较短，定时补播以免识破持续窗口内收招
local GESTURE_INTERVAL = 0.45
local THINK = 1 / 30
local INSIGHT_GESTURE = ACT_DOTA_CAST_ABILITY_1
--- kez_parry 朝向多依赖 CP0→CP1；优先挂 attach_attack1 与一技能朝向一致
local PARRY_VFX_FORWARD = 95
local PARRY_VFX_Z_FALLBACK = 82
local PARRY_VFX_CP1_DIST = 220

local function ClrbParryFwd3(fwd_xy)
    return Vector(fwd_xy.x, fwd_xy.y, 0):Normalized()
end

local function ClrbParryVfxWorldPos(hero, fwd_xy)
    local att = hero:ScriptLookupAttachment("attach_hitloc")
    if att and att > 0 then
        return hero:GetAttachmentOrigin(att) + fwd_xy * PARRY_VFX_FORWARD
    end
    local o = hero:GetAbsOrigin()
    return o + fwd_xy * PARRY_VFX_FORWARD + Vector(0, 0, PARRY_VFX_Z_FALLBACK)
end

--- 识破仅招架「正面 180°」：水平面内，指向攻击者 与 lock_fwd 点积 ≥ 0；背面半区返回 false。
local function InsightAttackerInFrontArc(defender, attacker, lock_fwd_xy)
    if not defender or defender:IsNull() or not attacker or attacker:IsNull() then
        return false
    end
    local fwd = lock_fwd_xy
    if not fwd then
        fwd = defender:GetForwardVector()
        fwd = Vector(fwd.x, fwd.y, 0)
        if fwd:Length2D() < 1e-4 then
            return true
        end
        fwd = fwd:Normalized()
    end
    local to_a = attacker:GetAbsOrigin() - defender:GetAbsOrigin()
    to_a = Vector(to_a.x, to_a.y, 0)
    local len = to_a:Length2D()
    if len < 1e-4 then
        return true
    end
    to_a = to_a / len
    return fwd:Dot(to_a) >= 0
end

--- 结束识破时清 1 技能施法手势，否则易导致普攻/转身卡住
function modifier_clrb_insight.ClearInsightGestures(unit)
    if not unit or unit:IsNull() then
        return
    end
    if unit.FadeGesture then
        unit:FadeGesture(INSIGHT_GESTURE)
    elseif unit.RemoveGesture then
        unit:RemoveGesture(INSIGHT_GESTURE)
    end
    if unit.ForcePlayActivityOnce then
        unit:ForcePlayActivityOnce(ACT_DOTA_IDLE)
    end
end

---@param self modifier_clrb_insight
local function ClrbParryPfxRefreshControls(self, hero, fwd_xy)
    local pfx = self.pfx
    if not pfx or not hero or hero:IsNull() then
        return
    end
    local f3 = ClrbParryFwd3(fwd_xy)
    if self.parry_pfx_on_attack1 then
        ParticleManager:SetParticleControlForward(pfx, 1, f3)
        local o = hero:GetAbsOrigin()
        ParticleManager:SetParticleControl(pfx, 1, o + fwd_xy * PARRY_VFX_CP1_DIST)
        return
    end
    local pos = ClrbParryVfxWorldPos(hero, fwd_xy)
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 1, pos + fwd_xy * PARRY_VFX_CP1_DIST)
    ParticleManager:SetParticleControlForward(pfx, 1, f3)
end

function modifier_clrb_insight:IsHidden()
    return false
end

function modifier_clrb_insight:IsDebuff()
    return false
end

function modifier_clrb_insight:IsPurgable()
    return false
end

function modifier_clrb_insight:RemoveOnDeath()
    return true
end

function modifier_clrb_insight:GetTexture()
    return "kez_shodo_sai"
end

function modifier_clrb_insight:CheckState()
    return {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true,
    }
end

function modifier_clrb_insight:OnCreated()
    if not IsServer() then
        return
    end
    self.parry_spent = false
    local p = self:GetParent()
    if not p or p:IsNull() then
        return
    end
    self.lock_fwd = p:GetForwardVector()
    self.lock_fwd = Vector(self.lock_fwd.x, self.lock_fwd.y, 0)
    if self.lock_fwd:Length2D() < 0.01 then
        self.lock_fwd = Vector(1, 0, 0)
    else
        self.lock_fwd = self.lock_fwd:Normalized()
    end

    self.pfx = ParticleManager:CreateParticle(PARRY_VFX, PATTACH_CUSTOMORIGIN, p)
    self.parry_pfx_on_attack1 = false
    local a1 = p:ScriptLookupAttachment("attach_attack1")
    if a1 and a1 > 0 then
        ParticleManager:SetParticleControlEnt(self.pfx, 0, p, PATTACH_POINT_FOLLOW, "attach_attack1",
            p:GetAbsOrigin(), false)
        self.parry_pfx_on_attack1 = true
    end
    ClrbParryPfxRefreshControls(self, p, self.lock_fwd)
    EmitSoundOn("Hero_Kez.Sai.Proc", p)

    self.gesture_accum = 0
    if p.StartGesture then
        p:StartGesture(INSIGHT_GESTURE)
    end
    self:StartIntervalThink(THINK)
end

function modifier_clrb_insight:OnIntervalThink()
    if not IsServer() then
        return
    end
    local p = self:GetParent()
    if not p or p:IsNull() then
        return
    end
    p:SetForwardVector(self.lock_fwd)
    ClrbParryPfxRefreshControls(self, p, self.lock_fwd)
    self.gesture_accum = (self.gesture_accum or 0) + THINK
    if self.gesture_accum >= GESTURE_INTERVAL then
        self.gesture_accum = 0
        if p.StartGesture then
            p:StartGesture(INSIGHT_GESTURE)
        end
    end
end

function modifier_clrb_insight:OnDestroy()
    if not IsServer() then
        return
    end
    local p = self:GetParent()
    if p and not p:IsNull() then
        modifier_clrb_insight.ClearInsightGestures(p)
    end
    if self.pfx then
        ParticleManager:DestroyParticle(self.pfx, false)
        ParticleManager:ReleaseParticleIndex(self.pfx)
        self.pfx = nil
    end
end

--- 由 Damage_Filter 调用：抵消本次普攻伤害并下一帧绕后
---@return boolean true 表示已完全格挡此次物理普攻
function modifier_clrb_insight:ClrbTryParryPhysicalAttack(attacker)
    if not IsServer() then return end
    if self.parry_spent then
        return false
    end
    if not attacker or attacker:IsNull() or not attacker:IsAlive() or not attacker:IsHero() then
        return false
    end
    local hero = self:GetParent()
    if not hero or hero:IsNull() then
        return false
    end
    if attacker == hero then
        return false
    end
    if not InsightAttackerInFrontArc(hero, attacker, self.lock_fwd) then
        return false
    end

    self.parry_spent = true

    Timers(0, function()
        if hero:IsNull() or not hero:IsAlive() then
            return
        end
        if attacker:IsNull() or not attacker:IsAlive() then
            return
        end
        modifier_clrb_insight.ParryBlinkAndStun(hero, attacker)
        local m = hero:FindModifierByName("modifier_clrb_insight")
        if m then
            m:Destroy()
        end
    end)

    return true
end

---@param hero CDOTA_BaseNPC_Hero
---@param target CDOTA_BaseNPC
function modifier_clrb_insight.ParryBlinkAndStun(hero, target)
    local fwd = target:GetForwardVector()
    fwd = Vector(fwd.x, fwd.y, 0)
    if fwd:Length2D() < 0.01 then
        fwd = hero:GetForwardVector()
        fwd = Vector(fwd.x, fwd.y, 0):Normalized()
    else
        fwd = fwd:Normalized()
    end

    local dest = target:GetAbsOrigin() - fwd * BEHIND_DIST
    dest.z = GetGroundPosition(dest, hero).z

    local from = hero:GetAbsOrigin()
    local delta = dest - from
    local dist = delta:Length2D()
    if dist > MAX_BLINK then
        dest = from + delta:Normalized() * MAX_BLINK
        dest.z = GetGroundPosition(dest, hero).z
    end

    local p = ParticleManager:CreateParticle(BLINK_VFX, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(p, 0, from)
    ParticleManager:SetParticleControl(p, 1, dest)
    ParticleManager:ReleaseParticleIndex(p)

    EmitSoundOn("Hero_Riki.Blink_Strike", hero)

    hero:SetAbsOrigin(dest)
    FindClearSpaceForUnit(hero, dest, true)
    hero:SetForwardVector(fwd)

    if target:IsHero() and target:IsAlive() and target:GetTeamNumber() ~= hero:GetTeamNumber() then
        target:AddNewModifier(hero, nil, "modifier_clrb_insight_parry_stun", { duration = 1 })
    end
end
