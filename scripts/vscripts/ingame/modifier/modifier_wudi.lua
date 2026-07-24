--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 文件名：modifier_wudi.lua
modifier_wudi = class({})

-- 基础配置
function modifier_wudi:IsHidden()
    return false -- 隐藏状态栏显示图标
end

function modifier_wudi:IsDebuff()
    return false
end

function modifier_wudi:IsPurgable()
    return false -- 不可被驱散
end

function modifier_wudi:RemoveOnDeath()
    return false
end

function modifier_wudi:AllowIllusionDuplicate()
    return false
end

function modifier_wudi:GetTexture()
    return "scroll/weather_moonbeam_png"
end

function modifier_wudi:OnCreated(kv)
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    if not parent or parent:IsNull() then
        return
    end
    -- AddNewModifier 常用 { duration = x }，与 kv.dur 对齐；特效生命周期在 OnDestroy 回收，与 modifier 一致
    local dur = tonumber(kv and kv.dur) or tonumber(kv and kv.duration)
    if (not dur or dur < 0) and self.GetRemainingTime then
        dur = self:GetRemainingTime()
    end
    if dur and dur > 0 then
        self:SetDuration(dur, true)
    end
    local path = "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal.vpcf"
    -- 不传 dur 给 AddTx，避免与 modifier 结束时刻不一致导致残留；统一在 OnDestroy 里 ClearTx
    -- self.fx = utilex:AddTx(path, parent, 1)
end

function modifier_wudi:GetEffectName()
    return "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal.vpcf"
end

function modifier_wudi:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

-- 提高状态特效优先级，避免被其他特效盖住或不显示
function modifier_wudi:GetStatusEffectPriority() return 10 end

function modifier_wudi:OnDestroy()
    if not IsServer() then
        return
    end
    if self.fx then
        utilex:ClearTx(self.fx)
        self.fx = nil
    end
end

-- 覆盖免疫属性
function modifier_wudi:DeclareFunctions()
    return {

    }
end

function modifier_wudi:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true, -- 无敌（时长见复活逻辑）
    }
end
