--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 天赋 3 主动：沿施法时朝向分段位移（近似推推棒，每帧一小步）

modifier_talent_skill_3_slide = class({})

function modifier_talent_skill_3_slide:IsHidden()
    return true
end

function modifier_talent_skill_3_slide:IsPurgable()
    return false
end

function modifier_talent_skill_3_slide:RemoveOnDeath()
    return true
end

function modifier_talent_skill_3_slide:OnCreated(kv)
    if not IsServer() then
        return
    end
    local max_dur = tonumber(kv and kv.duration) or 1.2
    self:SetDuration(max_dur, true)

    self.interval = 1 / 30
    local total = 700
    -- 略慢于原版推推 ~600/0.5s，700 约 0.65s 完成
    local target_secs = 0.5
    self.steps = math.max(10, math.floor(target_secs / self.interval + 0.99))
    self.step_len = total / self.steps
    self.traveled = 0
    self.total = total

    local fwd = self:GetParent():GetForwardVector()
    fwd = Vector(fwd.x, fwd.y, 0)
    if fwd:Length2D() < 0.01 then
        fwd = Vector(1, 0, 0)
    else
        fwd = fwd:Normalized()
    end
    self.fwd = fwd

    local parent = self:GetParent()
    if parent and not parent:IsNull() then
        EmitSoundOn("DOTA_Item.ForceStaff.Activate", parent)
    end

    self:StartIntervalThink(self.interval)
end

function modifier_talent_skill_3_slide:OnIntervalThink()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    if not parent or parent:IsNull() or not parent:IsAlive() then
        self:Destroy()
        return
    end

    local remain = self.total - self.traveled
    if remain <= 0 then
        self:Destroy()
        return
    end

    local step = math.min(self.step_len, remain)
    local dest = parent:GetAbsOrigin() + self.fwd * step
    dest.z = GetGroundPosition(dest, parent).z

    parent:SetAbsOrigin(dest)
    self.traveled = self.traveled + step

    if self.traveled >= self.total - 0.001 then
        FindClearSpaceForUnit(parent, dest, true)
        self:Destroy()
    end
end
