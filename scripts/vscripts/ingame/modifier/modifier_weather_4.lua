--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_weather_4 = class({})
LinkLuaModifier("modifier_weather_4_buff",
                "ingame/modifier/modifier_weather_4_buff",
                LUA_MODIFIER_MOTION_NONE)

-- 是否在面板上显示
function modifier_weather_4:IsHidden() return false end

function modifier_weather_4:IsDebuff() return false end

function modifier_weather_4:IsPurgable()
    return false -- 不可被驱散
end

function modifier_weather_4:RemoveOnDeath() return false end

function modifier_weather_4:GetTexture() return "scroll/weather_snow_png" end

function modifier_weather_4:AllowIllusionDuplicate() return false end

-- 寒霜：减少生命回复与治疗效果，降低移速；攻击命中时仍可施加寒霜 debuff
function modifier_weather_4:OnCreated(kv)
    if not IsServer() then return end
    self:SetDuration(kv.dur, true)
end

function modifier_weather_4:DeclareFunctions()
    return { -- 生命回复（负值=减少）  -- 移速（负值=减速）
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_weather_4:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.attacker == self:GetParent() then
        -- print("攻击命中")
        -- 命中时触发技能效果
        local ca = self:GetParent()
        local ta = keys.target
        ta:AddNewModifier(ca, -- 施法者
        self, -- 技能
        "modifier_weather_4_buff", -- 修饰器名称
        {dur = 2} -- 参数
        )
    end
end
