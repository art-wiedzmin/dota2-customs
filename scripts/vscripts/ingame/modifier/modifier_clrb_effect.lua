--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_clrb_effect = class({})

function modifier_clrb_effect:IsHidden()
    return true
end

function modifier_clrb_effect:IsDebuff()
    return false
end

function modifier_clrb_effect:IsPurgable()
    return false
end

function modifier_clrb_effect:RemoveOnDeath()
    return true
end

function modifier_clrb_effect:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.effect_fx = (kv and kv.effect_fx)
        or "particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf"
    self:_UpdateParticle()
end

function modifier_clrb_effect:OnRefresh(kv)
    if not IsServer() then
        return
    end
    if kv and kv.effect_fx and kv.effect_fx ~= "" then
        self.effect_fx = kv.effect_fx
    end
    self:_UpdateParticle()
end

function modifier_clrb_effect:OnDestroy()
    if not IsServer() then
        return
    end
    self:_DestroyParticle()
end

function modifier_clrb_effect:OnRemoved()
    if not IsServer() then
        return
    end
    self:_DestroyParticle()
end

function modifier_clrb_effect:_DestroyParticle()
    if self.particle then
        ParticleManager:DestroyParticle(self.particle, true)
        ParticleManager:ReleaseParticleIndex(self.particle)
        self.particle = nil
    end
end

--- 信使染色 CP15；铂金肉山 ambient 需要显式染色
function modifier_clrb_effect:_NeedsCourierTint(fx)
    if not fx then
        return false
    end
    return string.find(fx, "platinum_roshan_ambient", 1, true) ~= nil
end

--- 急雪拖尾整包：只挂父级 courier_trail_flurry，子级 _b 自动带上
function modifier_clrb_effect:_IsFlurryPack(fx)
    if not fx then
        return false
    end
    return string.find(fx, "courier_trail_flurry", 1, true) ~= nil
end

--- 铂金肉山整包（ambient 父级）需要 CP0/1/2 绑眼睛挂点，子特效会自动跟随
function modifier_clrb_effect:_IsPlatinumRoshanPack(fx)
    if not fx then
        return false
    end
    return string.find(fx, "platinum_roshan_ambient", 1, true) ~= nil
        or string.find(fx, "platinum_roshan_eye", 1, true) ~= nil
end

function modifier_clrb_effect:_HasAttachment(parent, name)
    if not parent or parent:IsNull() or not name then
        return false
    end
    local id = parent:ScriptLookupAttachment(name)
    return id and id > 0
end

function modifier_clrb_effect:_PickBodyAttach(parent)
    for _, name in ipairs({ "attach_hitloc", "attach_head", "attach_attack1", "attach_origin" }) do
        if self:_HasAttachment(parent, name) then
            return name
        end
    end
    return "attach_hitloc"
end

--- 肉山原装：CP0/1/2 = attach_eye_l/m/r；英雄无此挂点时落到头部区域并左右错开
function modifier_clrb_effect:_BindPlatinumRoshanControlPoints(p, parent)
    local has_l = self:_HasAttachment(parent, "attach_eye_l")
    local has_m = self:_HasAttachment(parent, "attach_eye_m")
    local has_r = self:_HasAttachment(parent, "attach_eye_r")

    if has_l and has_m and has_r then
        ParticleManager:SetParticleControlEnt(p, 0, parent, PATTACH_POINT_FOLLOW, "attach_eye_l", Vector(0, 0, 0), true)
        ParticleManager:SetParticleControlEnt(p, 1, parent, PATTACH_POINT_FOLLOW, "attach_eye_m", Vector(0, 0, 0), true)
        ParticleManager:SetParticleControlEnt(p, 2, parent, PATTACH_POINT_FOLLOW, "attach_eye_r", Vector(0, 0, 0), true)
        return
    end

    local body = "attach_hitloc"
    if self:_HasAttachment(parent, "attach_head") then
        body = "attach_head"
    elseif self:_HasAttachment(parent, "attach_hitloc") then
        body = "attach_hitloc"
    else
        body = self:_PickBodyAttach(parent)
    end

    -- 本地偏移：左 / 中 / 右，近似三只眼在英雄头胸位置
    ParticleManager:SetParticleControlEnt(p, 0, parent, PATTACH_POINT_FOLLOW, body, Vector(-14, 2, 8), true)
    ParticleManager:SetParticleControlEnt(p, 1, parent, PATTACH_POINT_FOLLOW, body, Vector(0, 4, 12), true)
    ParticleManager:SetParticleControlEnt(p, 2, parent, PATTACH_POINT_FOLLOW, body, Vector(14, 2, 8), true)
end

function modifier_clrb_effect:_UpdateParticle()
    self:_DestroyParticle()
    local parent = self:GetParent()
    if not parent or parent:IsNull() or not self.effect_fx or self.effect_fx == "" then
        return
    end
    local fx = self.effect_fx

    -- ABSORIGIN_FOLLOW：父粒子 CreateOnModel 才能贴英雄模型；子粒子由父级自动创建
    self.particle = ParticleManager:CreateParticle(fx, PATTACH_ABSORIGIN_FOLLOW, parent)
    if not self.particle or self.particle < 0 then
        self.particle = nil
        return
    end

    if self:_IsPlatinumRoshanPack(fx) then
        self:_BindPlatinumRoshanControlPoints(self.particle, parent)
    elseif self:_IsFlurryPack(fx) then
        -- 跟脚底即可；颜色已写进粒子，不依赖 CP15 Remap（易把效果染没）
        ParticleManager:SetParticleControlEnt(
            self.particle, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0, 0, 0), true
        )
    end

    if self:_NeedsCourierTint(fx) then
        -- 离子之气（courier_platinum_roshan）红色；铂金肉山周身（clrb）蓝色加强
        if string.find(fx, "courier_platinum_roshan", 1, true) then
            ParticleManager:SetParticleControl(self.particle, 15, Vector(255, 48, 32))
        else
            ParticleManager:SetParticleControl(self.particle, 15, Vector(64, 170, 255))
        end
        ParticleManager:SetParticleControl(self.particle, 16, Vector(1, 0, 0))
    end
end

function modifier_clrb_effect:GetStatusEffectPriority()
    return 10
end
