--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_item_12 = class({})

-- 关键修改：必须设为 false，让Modifier在状态栏可见
function modifier_item_12:IsHidden()
    return false -- 从 true 改为 false
end

function modifier_item_12:IsDebuff()
    return false
end

function modifier_item_12:IsPurgable()
    return false -- 不可被驱散
end

function modifier_item_12:RemoveOnDeath()
    return false
end

function modifier_item_12:AllowIllusionDuplicate()
    return true
end

function modifier_item_12:OnCreated(kv)
    if not IsServer() then return end
    self:GetParent():CalculateStatBonus(true)
end

function modifier_item_12:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end

function modifier_item_12:GetModifierHealthBonus()
    return 2000
end

-- 【新增】提供一个图标，使其在状态栏可见
function modifier_item_12:GetTexture()
    return "item_aeon_disk" -- 使用永恒之盘的图标，代表状态抗性
    -- 或者使用你物品的自定义图标名，如 `item_12`
end

-- 【可选】添加工具提示，鼠标悬停时可看到具体数值
function modifier_item_12:GetTooltip()
    return "状态抗性：+20%\n生命值：+2000"
end
