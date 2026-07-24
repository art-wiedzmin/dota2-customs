--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if modifier_talent_1 == nil then
    modifier_talent_1 = class({})
end

--该modifier是否是负面的
function modifier_talent_1:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_talent_1:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_talent_1:IsHidden()
    return true
end

--死亡时是否移除
function modifier_talent_1:RemoveOnDeath()
    return false
end

function modifier_talent_1:OnCreated(kv)
    if not IsServer() then return end
    --print("添加攻击buff")
    self:ForceRefresh()
end

-- 刷新modifier
function modifier_talent_1:OnRefresh(kv)
    if not IsServer() then return end
    local hero = self:GetParent()
    local ID = Util:Hero2ID(hero)
    self.lqjs = HeroData.Data[ID].hero_attr.lqjs
    self:SetStackCount(self.lqjs)
    hero:CalculateStatBonus(true)
end

function modifier_talent_1:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED, -- 攻击命中时
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_AOE_BONUS_PERCENTAGE,

    }
end

function modifier_talent_1:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.attacker == self:GetParent() then
        --print("攻击命中")
        -- 命中时触发技能效果
        local ca = self:GetParent()
        local ta = keys.target
        if not ta or ta:IsNull() or not ta:IsAlive() then return end
        if ca:IsHero() then
            local dmg_amp_name = "modifier_talent_1_damage_amp_debuff"
            local dmg_amp_dur = 3
            if ta:GetTeamNumber() ~= ca:GetTeamNumber()
                and not ta:IsMagicImmune()
                and not ta:IsBuilding()
                and not ta:IsCourier() then
                local m = ta:FindModifierByName(dmg_amp_name)
                if m then
                    m:SetStackCount(math.min(999, m:GetStackCount() + 1))
                    m:SetDuration(dmg_amp_dur, true)
                else
                    ta:AddNewModifier(ca, nil, dmg_amp_name, { duration = dmg_amp_dur })
                end
            end
            local ID = Util:Hero2ID(ca)
            if ID then
                local level = Talent.Data[ID].level
                local num = 1
                local hj = 0
                if level == 0 then
                    num = 0.6
                    hj = -3
                end
                if level == 1 then
                    num = 0.8
                    hj = -4
                end
                if level == 2 then
                    num = 1
                    hj = -5
                end
                if level == 3 then
                    num = 1.2
                    hj = -6
                end
                if level == 4 then
                    num = 1.4
                    hj = -7
                end
                if level == 5 then
                    num = 1.6
                    hj = -8
                end
                if math.random(1, 100) <= 15 then
                    local dam = ca:GetAttackDamage() * num
                    -- print(dam)
                    utilex:UnitDam(ca, ta, dam, "wl")
                    local tx1 = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_attack_blur_crit.vpcf"
                    utilex:AddTx(tx1, ta, 1)
                    --phantom_assassin_coup_de_grace_png
                    EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", ca)
                end
                -- LinkLuaModifier("modifier_talent_1_buff", "ingame/modifier/modifier_talent_1_buff",
                --     LUA_MODIFIER_MOTION_NONE)
                -- ta:AddNewModifier(
                --     ta,                       -- 施法者
                --     nil,                      -- 技能
                --     "modifier_talent_1_buff", -- 修饰器名称
                --     { dur = 7, hj = hj }      -- 参数
                -- )
            end
        end
    end
end

function modifier_talent_1:GetModifierPercentageCooldown(kv)
    local count = self:GetStackCount()
    return count
end

