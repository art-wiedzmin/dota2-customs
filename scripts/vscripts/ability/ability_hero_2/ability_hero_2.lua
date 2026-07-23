--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


LinkLuaModifier("modifier_hero_2", "Ability/ability_hero_2/ability_hero_2",
    LUA_MODIFIER_MOTION_NONE)

ability_hero_2 = class({})

function ability_hero_2:GetIntrinsicModifierName()
    return "modifier_hero_2"
end

modifier_hero_2 = class({})

-- 添加必要的modifier函数
function modifier_hero_2:IsHidden() return true end

function modifier_hero_2:IsPurgable() return false end

function modifier_hero_2:IsDebuff() return false end

function modifier_hero_2:OnCreated()
    if not IsServer() then return end
    -- 修正：使用GetParent()而不是GetCaster()
    local hero = self:GetParent()
end

function modifier_hero_2:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_hero_2:OnAttackLanded(keys)
    if not IsServer() then return end
    -- 检查攻击者是否是拥有此modifier的英雄
    if keys.attacker == self:GetParent() then
        local attacker = self:GetParent()
        local target = keys.target
        -- 检查目标是否有效
        if not target or target:IsNull() or not target:IsAlive() then
            return
        end
        if attacker.ability_hero_2 == true then
            return
        end
        if math.random(1, 100) <= 15 then
            attacker.ability_hero_2 = true
            Timers(3, function()
                attacker.ability_hero_2 = false
            end)

            local hero = attacker
            local ab = hero:FindAbilityByName("ability_hero_2")
            local level = ab:GetLevel()
            local dam_list = { 200, 300, 400 }
            local range_list = { 450, 525, 600 }
            local range = range_list[level]
            local dam1 = dam_list[level]

            local tx = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf"
            local effect_cast = ParticleManager:CreateParticle(tx, PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControl(effect_cast, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(effect_cast, 1, Vector(range, range, 0)) -- 半径影响范围
            ParticleManager:ReleaseParticleIndex(effect_cast)
            EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse", hero)
            local enemies = utilex:GetRadiusUnit(hero, target:GetAbsOrigin(), range, "bad")
            if enemies then
                for k, v in pairs(enemies) do
                    if v and not v:IsNull() then
                        local dam2 = (attacker:GetMana() - v:GetMana()) * 0.4
                        if dam2 < 0 then
                            dam2 = 0
                        end
                        local dam = math.floor(dam1 + dam2)
                        utilex:UnitDam(hero, v, dam, "mf")
                    end
                end
            end
        end
    end
end