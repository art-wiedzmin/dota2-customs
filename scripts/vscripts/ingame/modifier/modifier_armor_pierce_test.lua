--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 物理穿透测试 modifier
-- 使用 ModDota API: MODIFIER_PROPERTY_PHYSICAL_ARMOR_PIERCING_PERCENTAGE_TARGET (188)
-- 挂在攻击者身上，返回对「当前普攻/技能目标」忽略的护甲百分比（0~100）
-- 测试：给英雄加上此 modifier 后普攻高护甲单位，伤害会提高
modifier_armor_pierce_test = class({})

function modifier_armor_pierce_test:IsHidden() return false end

function modifier_armor_pierce_test:IsDebuff() return false end

function modifier_armor_pierce_test:IsPurgable() return false end

function modifier_armor_pierce_test:GetTexture() return "item_lesser_crit" end

function modifier_armor_pierce_test:OnCreated(kv)
    if not IsServer() then return end
    -- print("穿甲Buff创建成功")
end

function modifier_armor_pierce_test:DeclareFunctions()
    -- MODIFIER_PROPERTY_PHYSICAL_ARMOR_PIERCING_PERCENTAGE_TARGET = 188（见 ModDota API）
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_PIERCING_PERCENTAGE_TARGET  }
end

-- 对目标忽略的物理护甲百分比（0~100）。例如 50 表示视为目标护甲减少 50%
function modifier_armor_pierce_test:GetModifierIgnorePhysicalArmor(
    keys) return 50 end
