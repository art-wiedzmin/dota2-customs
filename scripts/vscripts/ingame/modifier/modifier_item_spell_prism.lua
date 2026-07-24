--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 宝箱物品：法术棱镜（item_box_32）- 技能与物品冷却时间减少
if modifier_item_spell_prism == nil then
    modifier_item_spell_prism = class({})
end

function modifier_item_spell_prism:IsHidden()
    return true
end

function modifier_item_spell_prism:IsDebuff()
    return false
end

function modifier_item_spell_prism:IsPurgable()
    return false
end

function modifier_item_spell_prism:RemoveOnDeath()
    return false
end

function modifier_item_spell_prism:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
    }
end

-- 法术棱镜：12% 冷却时间减少（技能与物品）
function modifier_item_spell_prism:GetModifierPercentageCooldown()
    return 12
end


function modifier_item_spell_prism:OnCreated()
    if not IsServer() then
        return
    end
end
