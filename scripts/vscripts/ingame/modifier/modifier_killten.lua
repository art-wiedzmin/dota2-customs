--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_killten = class({})

function modifier_killten:IsHidden() return false end

function modifier_killten:IsDebuff() return false end

function modifier_killten:IsPurgable() return false end

function modifier_killten:RemoveOnDeath() return true end

function modifier_killten:GetTexture() return "buff/sljk" end

function modifier_killten:GetStatusEffectName()
    return "particles/status_fx/status_effect_bloodrage.vpcf"
end

-- 提高状态特效优先级，避免被其他特效盖住或不显示
function modifier_killten:GetStatusEffectPriority() return 99 end

function modifier_killten:GetEffectAttachType() return PATTACH_ROOTBONE_FOLLOW end

function modifier_killten:OnCreated(keys)
    if not IsServer() then return end
    local hero = self:GetParent()
    if not hero or hero:IsNull() then return end
    local ID = Util:Hero2ID(hero)
    EmitSoundOn("hero_bloodseeker.bloodRage", hero)
    if ID ~= nil then
        Util:BottomMsg2ID(ID,
                          "杀红了眼：造成伤害+25%，受到伤害+50%",
                          "red", 3)
    end
end

-- function modifier_killten:OnIntervalThink()
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

function modifier_killten:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        if parent then parent.KillCount = 0 end
    end
end

function modifier_killten:DeclareFunctions()
    return {MODIFIER_PROPERTY_MODEL_SCALE, MODIFIER_PROPERTY_TOOLTIP2}
end

function modifier_killten:GetModifierModelScale()
    -- 注意：这里返回的是额外缩放，不是总缩放
    -- 实际缩放 = 基础缩放 * (1 + 这里返回的值/100)
    return 50 -- 增加20%（变成1.2倍）
end

function modifier_killten:OnTooltip2() return self:GetStackCount() end
