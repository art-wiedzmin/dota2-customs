--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_stillkill = class({})

function modifier_stillkill:IsHidden() return false end

function modifier_stillkill:IsDebuff() return false end

function modifier_stillkill:IsPurgable() return false end

function modifier_stillkill:RemoveOnDeath() return true end

function modifier_stillkill:GetTexture() return "scroll/sljk" end

function modifier_stillkill:GetStatusEffectName()
    return "particles/status_fx/status_effect_bloodrage.vpcf"
end

-- 提高状态特效优先级，避免被其他特效盖住或不显示
function modifier_stillkill:GetStatusEffectPriority() return 10 end

function modifier_stillkill:GetEffectAttachType() return PATTACH_ROOTBONE_FOLLOW end

function modifier_stillkill:OnCreated(keys)
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
    -- self:OnIntervalThink(1)
end

-- function modifier_stillkill:OnIntervalThink()
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

function modifier_stillkill:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        if parent then parent.KillCount = 0 end
    end
end

function modifier_stillkill:DeclareFunctions()
    return {MODIFIER_PROPERTY_MODEL_SCALE}
end

function modifier_stillkill:GetModifierModelScale()
    -- 注意：这里返回的是额外缩放，不是总缩放
    -- 实际缩放 = 基础缩放 * (1 + 这里返回的值/100)
    return 50 -- 增加20%（变成1.2倍）
end

