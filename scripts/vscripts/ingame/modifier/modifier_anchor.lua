--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if modifier_anchor == nil then
    modifier_anchor = class({})
end



--该modifier是否是负面的
function modifier_anchor:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_anchor:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_anchor:IsHidden()
    return true
end

--死亡时是否移除
function modifier_anchor:RemoveOnDeath()
    return false
end

function modifier_anchor:OnCreated(kv)
    if not IsServer() then return end
    --print("添加攻击buff")
    self:ForceRefresh()
end

-- 刷新modifier
function modifier_anchor:OnRefresh(kv)
    if not IsServer() then return end
    local hero = self:GetParent()
    local ID = Util:Hero2ID(hero)
end

function modifier_anchor:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED, -- 攻击命中时
    }
end

function modifier_anchor:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.attacker == self:GetParent() then
        --print("攻击命中")
        -- 命中时触发技能效果
        local ca = self:GetParent()
        local ta = keys.target
        if ca:IsHero() and ca:HasAbility("tidehunter_anchor_smash") then
            local ID = Util:Hero2ID(ca)
            if ID then
                if math.random(1, 100) <= 50 then
                    local ab = ca:FindAbilityByName("tidehunter_anchor_smash")
                    local level = ab:GetLevel()
                    local list = { 50, 100, 150, 200 }
                    local num = list[level]
                    local dam = ca:GetBaseDamageMax() + num
                    local radius = ca:Script_GetAttackRange() + ab:GetSpecialValueFor("additional_range") + 200
                    local units = utilex:GetRadiusUnit(ca, ca:GetAbsOrigin(), radius, "bad")
                    if units then
                        for k, v in pairs(units) do
                            utilex:UnitDam(ca, v, dam, "wl")
                            LinkLuaModifier("modifier_anchor_buff", "ingame/modifier/modifier_anchor_buff",
                                LUA_MODIFIER_MOTION_NONE)
                            v:AddNewModifier(
                                v,                      -- 施法者
                                ab,                     -- 技能
                                "modifier_anchor_buff", -- 修饰器名称
                                { duration = 6 }        -- 参数
                            )
                        end
                    end

                    if ca.StartGesture then
                        ca:StartGesture(ACT_DOTA_CAST_ABILITY_3)
                    end

                    local pfx = ParticleManager:CreateParticle(
                        "particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf",
                        PATTACH_WORLDORIGIN,
                        nil
                    )
                    ParticleManager:SetParticleControl(pfx, 0, ca:GetAbsOrigin())
                    ParticleManager:SetParticleControl(pfx, 2, Vector(radius, 0, 0))
                    ParticleManager:ReleaseParticleIndex(pfx)
                    EmitSoundOn("Hero_Tidehunter.AnchorSmash", ca)
                end
            end
        end
    end
end
