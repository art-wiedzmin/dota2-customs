modifier_ability_bf_1_buff = class({})

function modifier_ability_bf_1_buff:IsHidden() return false end

function modifier_ability_bf_1_buff:IsDebuff() return false end

function modifier_ability_bf_1_buff:IsPurgable() return false end

function modifier_ability_bf_1_buff:GetTexture() return "buff/sljk" end

function modifier_ability_bf_1_buff:GetStatusEffectName()
    return "particles/status_fx/status_effect_bloodrage.vpcf"
end

-- 提高状态特效优先级，避免被其他特效盖住或不显示
function modifier_ability_bf_1_buff:GetStatusEffectPriority() return 10 end

function modifier_ability_bf_1_buff:GetEffectAttachType()
    return PATTACH_ROOTBONE_FOLLOW
end

function modifier_ability_bf_1_buff:OnCreated(keys)
    if not IsServer() then return end
    local hero = self:GetParent()
    if not hero or hero:IsNull() then return end
    local ID = Util:Hero2ID(hero)
    EmitSoundOn("hero_bloodseeker.bloodRage", hero)
    if ID ~= nil then
        Util:BottomMsg2ID(ID,
            "杀红了眼：造成伤害+25%，受到伤害+50%，被所有人可见",
            "red", 3)
    end
    self:StartIntervalThink(1.0)
end

function modifier_ability_bf_1_buff:OnIntervalThink()
    if not IsServer() then
        return
    end

    local hero = self:GetParent()
    if not hero or hero:IsNull() then
        return
    end

    local heroTeam = hero:GetTeam()
    local heroPos = hero:GetAbsOrigin()

    local teams = {DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS, DOTA_TEAM_CUSTOM_1, DOTA_TEAM_CUSTOM_2, DOTA_TEAM_CUSTOM_3,
                   DOTA_TEAM_CUSTOM_4, DOTA_TEAM_CUSTOM_5, DOTA_TEAM_CUSTOM_6, DOTA_TEAM_CUSTOM_7, DOTA_TEAM_CUSTOM_8}

    for _, targetTeam in pairs(teams) do
        if targetTeam ~= heroTeam then
            AddFOWViewer(targetTeam, heroPos, 1000, 1, false)
        end
    end
end



-- function modifier_ability_bf_1_buff:OnIntervalThink()
--     if IsServer() then
--         local parent = self:GetParent()
--         if parent:GetHealthPercent() > 25 then
--             local ability = self:GetAbility()
--             local dam = parent:GetMaxHealth() * 5 / 100
--             -- 造成周期伤害
--             local damageTable = {
--                 victim = parent,
--                 attacker = MainGame:GetDummy(),
--                 damage = dam,
--                 damage_type = DAMAGE_TYPE_PURE,
--                 ability = ability
--             }
--             ApplyDamage(damageTable)
--         end
--     end
-- end

function modifier_ability_bf_1_buff:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        if parent then parent.KillCount = 0 end
    end
end

function modifier_ability_bf_1_buff:DeclareFunctions()
    return {MODIFIER_PROPERTY_MODEL_SCALE}
end

function modifier_ability_bf_1_buff:GetModifierModelScale()
    -- 注意：这里返回的是额外缩放，不是总缩放
    -- 实际缩放 = 基础缩放 * (1 + 这里返回的值/100)
    return 20 -- 增加20%（变成1.2倍）
end

