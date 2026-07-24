LinkLuaModifier("modifier_hero_3", "Ability/ability_hero_3/ability_hero_3",
    LUA_MODIFIER_MOTION_NONE)

local function schedule_destroy_particle(pid, delay)
    if not pid then
        return
    end
    Timers(delay or 2, function()
        ParticleManager:DestroyParticle(pid, false)
        ParticleManager:ReleaseParticleIndex(pid)
    end)
end

local function RevealSelfToEnemyTeams(hero, radius, duration)
    if not hero or hero:IsNull() then
        return
    end

    local heroTeam = hero:GetTeam()
    local heroPos = hero:GetAbsOrigin()

    local teams = {DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS, DOTA_TEAM_CUSTOM_1, DOTA_TEAM_CUSTOM_2, DOTA_TEAM_CUSTOM_3,
                   DOTA_TEAM_CUSTOM_4, DOTA_TEAM_CUSTOM_5, DOTA_TEAM_CUSTOM_6, DOTA_TEAM_CUSTOM_7, DOTA_TEAM_CUSTOM_8}

    for _, targetTeam in pairs(teams) do
        if targetTeam ~= heroTeam then
            AddFOWViewer(targetTeam, heroPos, radius, duration, false)
        end
    end
end


ability_hero_3 = class({})

function ability_hero_3:GetIntrinsicModifierName()
    return "modifier_hero_3"
end

modifier_hero_3 = class({})

-- 添加必要的modifier函数
function modifier_hero_3:IsHidden() return true end

function modifier_hero_3:IsPurgable() return false end

function modifier_hero_3:IsDebuff() return false end

function modifier_hero_3:OnCreated()
    if not IsServer() then return end
    -- 修正：使用GetParent()而不是GetCaster()
    local hero = self:GetParent()
end

function modifier_hero_3:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_hero_3:OnAttackLanded(keys)
    if not IsServer() then return end
    -- 检查攻击者是否是拥有此modifier的英雄
    if keys.attacker == self:GetParent() then
        local attacker = self:GetParent()
        local target = keys.target
        -- 检查目标是否有效
        if not target or target:IsNull() or not target:IsAlive() then
            return
        end
        if attacker.ability_hero_3_cd == true then
            return
        end
        if math.random(1, 100) <= 15 then
            attacker.ability_hero_3_cd = true
            Timers(3, function()
                attacker.ability_hero_3_cd = false
            end)
            local hero = attacker
            local team = hero:GetTeam()
            local pos = hero:GetAbsOrigin()

            local ab = hero:FindAbilityByName("ability_hero_3")
            local level = ab:GetLevel()
            local dam_list = { 300, 475, 650 }
            local dam1 = hero:GetMaxHealth() * 0.1
            local dam2 = dam_list[level]
            local dam = math.floor(dam1 + dam2)
            for k, v in pairs(HeroList:GetAllHeroes()) do
                if v then
                    local her = v
                    if her and her:GetTeam() ~= team and her:IsAlive() then
                        local vec = hero:GetAbsOrigin()
                        local fx = ParticleManager:CreateParticle(
                            "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf",
                            PATTACH_WORLDORIGIN, her)
                        ParticleManager:SetParticleControl(fx, 0, vec)
                        ParticleManager:SetParticleControl(fx, 1, vec + Vector(0, 0, 1000))
                        ParticleManager:SetParticleControl(fx, 2, vec)
                        schedule_destroy_particle(fx, 2)
                        utilex:UnitDam(hero, her, dam, "mf")

                        -- 前 10 分钟暴露视野 10 秒
                        local gameTime = GameRules:GetGameTime()
                        if gameTime <= 1080 then
                            RevealSelfToEnemyTeams(hero, 600, 5.0)
                        end
                    end
                end
            end

            local tx1 = "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf"
            local tx3 = "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf"
            local fx = ParticleManager:CreateParticle(tx1,
                PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:SetParticleControl(fx, 0, pos)
            ParticleManager:SetParticleControl(fx, 1, pos)
            ParticleManager:SetParticleControl(fx, 2, pos)
            schedule_destroy_particle(fx, 3)

            Timers(0, function()
                local fx2 = ParticleManager:CreateParticle(tx3,
                    PATTACH_ABSORIGIN_FOLLOW, hero)
                ParticleManager:SetParticleControl(fx2, 0, pos)
                ParticleManager:SetParticleControl(fx2, 1, pos)
                ParticleManager:SetParticleControl(fx2, 2, pos)
                schedule_destroy_particle(fx2, 4)
            end)
            EmitSoundOn("Hero_Zuus.GodsWrath", hero)
        end
    end
end

