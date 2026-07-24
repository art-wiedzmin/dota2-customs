--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 攻击者modifier
local MODIFIER_ABILITY_ITEM_30_MAX_STACK = 40

modifier_ability_item_30 = class({})

function modifier_ability_item_30:IsHidden() return true end

function modifier_ability_item_30:IsPurgable() return false end

function modifier_ability_item_30:OnCreated()
    if not IsServer() then return end
    local hero = self:GetParent()
    if not Util:IsPlayerHeroForData(hero) then return end
    local ability = self:GetAbility()
    hero.modifier_ability_item_30_buff = 0
    hero.modifier_ability_item_30_buff_kill = 0
    hero:AddNewModifier(hero, ability, "modifier_ability_item_30_buff", {})
end

function modifier_ability_item_30:OnDestroy()
    if not IsServer() then return end
    local hero = self:GetParent()
    if Util:IsPlayerHeroForData(hero) then
        local ID = Util:Hero2ID(hero)
        if ID then
            local num = hero.modifier_ability_item_30_buff or 0
            local ab = self:GetAbility()
            local amp = 1
            if ab and not ab:IsNull() then
                amp = ab:GetSpecialValueFor("smzf_per_stack")
            end
            if not amp or amp <= 0 then
                amp = 1
            end
            HeroData:AddSX(ID, "smzf", num * amp * -1)
        end
    end
    hero:RemoveModifierByName("modifier_ability_item_30_buff")
end

-- 声明修改函数
function modifier_ability_item_30:DeclareFunctions()
    return { MODIFIER_EVENT_ON_DEATH }
end

function modifier_ability_item_30:OnDeath(params)
    if not IsServer() then return end
    -- print(params)
    -- print(params.attacker:GetUnitName())
    local attacker = params.attacker
    if not attacker then return end
    local ability = self:GetAbility()
    if not ability then return end
    local hero = self:GetParent()
    if not Util:IsPlayerHeroForData(hero) then return end
    local ID = Util:Hero2ID(hero)
    if not ID then return end
    local need_kill = math.floor(ability:GetSpecialValueFor("num1"))
    local unit = params.unit
    local buff = hero:FindModifierByName("modifier_ability_item_30_buff")
    -- 自己死亡
    if unit == self:GetParent() then
        -- local buff_num = hero.modifier_ability_item_30_buff
        -- local cost = math.floor(buff_num / 2)
        -- hero.modifier_ability_item_30_buff = hero.modifier_ability_item_30_buff - cost
        -- local cost_hp = 200 * -1 * cost
        -- HeroData:AddSX(ID, "smjc", cost_hp)
        -- local num = hero.modifier_ability_item_30_buff
        -- local size = 1 + (num * 0.1)
        -- hero:SetModelScale(size)
        -- buff:ForceRefresh()
    else
        local amp = ability:GetSpecialValueFor("smzf_per_stack")
        if not amp or amp <= 0 then
            amp = 1
        end
        if unit:IsHero() then
            if attacker == hero then
                -- 英雄击杀
                local cur = hero.modifier_ability_item_30_buff or 0
                if cur < MODIFIER_ABILITY_ITEM_30_MAX_STACK then
                    hero.modifier_ability_item_30_buff = cur + 1
                    HeroData:AddSX(ID, "smzf", amp)
                    if buff then buff:ForceRefresh() end
                    EmitSoundOn("Tiny.Grow", hero)
                end
            end
        else
            if attacker == hero then
                -- 小怪击杀
                local cur = hero.modifier_ability_item_30_buff or 0
                if cur >= MODIFIER_ABILITY_ITEM_30_MAX_STACK then
                    return
                end
                hero.modifier_ability_item_30_buff_kill =
                    hero.modifier_ability_item_30_buff_kill + 1
                if hero.modifier_ability_item_30_buff_kill >= need_kill then
                    hero.modifier_ability_item_30_buff_kill = 0
                    hero.modifier_ability_item_30_buff = cur + 1
                    HeroData:AddSX(ID, "smzf", amp)
                    if buff then buff:ForceRefresh() end
                    EmitSoundOn("Tiny.Grow", hero)
                end
            end
        end
    end
end