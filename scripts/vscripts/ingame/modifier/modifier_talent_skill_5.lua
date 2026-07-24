--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 5：法神——施法后叠魔法增伤；15 分钟后获得 15% 技能吸血
-- 展示物品 item_talent_skill_5（回城栏）；叠层 buff 状态栏显示层数与魔法增伤（同攻击升级）
-- Tooltip 键：DOTA_Tooltip_modifier_talent_skill_5 / modifier_talent_skill_5_buff

require("ingame.modifier.modifier_clrb_talents")

modifier_talent_skill_5 = class({})
modifier_talent_skill_5_buff = class({})

local BUFF_DURATION = 6.0
local BUFF_STACK_PCT = 6
local BUFF_MAX_STACKS = 5
local SPELL_LS_UNLOCK_MIN = 15
local SPELL_LS_PCT = 15
local TEXTURE_BUFF = "buff/talent_5"

local BEHAVIOR_TOGGLE = tonumber(rawget(_G, "DOTA_ABILITY_BEHAVIOR_TOGGLE")) or 512
local BEHAVIOR_AUTOCAST = tonumber(rawget(_G, "DOTA_ABILITY_BEHAVIOR_AUTOCAST")) or 4096
local BEHAVIOR_ATTACK = tonumber(rawget(_G, "DOTA_ABILITY_BEHAVIOR_ATTACK"))
local BEHAVIOR_PASSIVE = tonumber(rawget(_G, "DOTA_ABILITY_BEHAVIOR_PASSIVE")) or 2

--- 开关 / 法球(自动施法攻击修饰) / 被动：不叠层
local function ClrbTalent5IsExcludedAbility(ability)
    if not ability or ability:IsNull() then
        return true
    end
    if type(ability.IsItem) == "function" and ability:IsItem() then
        return true
    end
    if type(ability.GetAbilityName) == "function" then
        local an = ability:GetAbilityName() or ""
        if string.sub(an, 1, 5) == "item_" then
            return true
        end
        if string.sub(an, 1, 17) == "item_talent_skill" then
            return true
        end
    end
    if type(ability.GetBehavior) ~= "function" or not bit or type(bit.band) ~= "function" then
        return false
    end
    local ok, b = pcall(function()
        return ability:GetBehavior()
    end)
    if not ok or b == nil then
        return false
    end
    b = tonumber(b) or 0
    if BEHAVIOR_PASSIVE and bit.band(b, BEHAVIOR_PASSIVE) ~= 0 then
        return true
    end
    if bit.band(b, BEHAVIOR_TOGGLE) ~= 0 then
        return true
    end
    if bit.band(b, BEHAVIOR_AUTOCAST) ~= 0 then
        return true
    end
    if BEHAVIOR_ATTACK and bit.band(b, BEHAVIOR_ATTACK) ~= 0 then
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- 永久被动：监听施法 + 15 分钟技能吸血解锁（状态栏常驻，图标同天赋）
--------------------------------------------------------------------------------
function modifier_talent_skill_5:IsHidden()
    -- 常驻被动不占状态栏；叠层效果只显示 modifier_talent_skill_5_buff
    return true
end

function modifier_talent_skill_5:IsDebuff()
    return false
end

function modifier_talent_skill_5:IsPurgable()
    return false
end

function modifier_talent_skill_5:RemoveOnDeath()
    return false
end

function modifier_talent_skill_5:IsPermanent()
    return true
end

function modifier_talent_skill_5:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_EVENT_ON_RESPAWN,
    }
end

function modifier_talent_skill_5:IsSpellLifestealUnlocked()
    return self.spell_lifesteal_unlocked == true
end

function modifier_talent_skill_5:_TryUnlockSpellLifesteal()
    if self.spell_lifesteal_unlocked then
        return
    end
    local game_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
    if game_min < SPELL_LS_UNLOCK_MIN then
        return
    end
    self.spell_lifesteal_unlocked = true
    local p = self:GetParent()
    if not p or p:IsNull() then
        return
    end
    local pid = ClrbGetOwnerPlayerId and ClrbGetOwnerPlayerId(p) or -1
    if pid >= 0 and Util and Util.BottomMsg2ID then
        Util:BottomMsg2ID(pid, "法神：获得 15% 技能吸血", "yellow", 3)
    end
end

function modifier_talent_skill_5:_AddMagicAmpStack()
    local p = self:GetParent()
    if not p or p:IsNull() or not p:IsAlive() then
        return
    end
    local buff = p:FindModifierByName("modifier_talent_skill_5_buff")
    local stacks = 1
    if buff and not buff:IsNull() then
        stacks = math.min(BUFF_MAX_STACKS, (buff:GetStackCount() or 0) + 1)
    end
    buff = p:AddNewModifier(p, nil, "modifier_talent_skill_5_buff", { duration = BUFF_DURATION })
    if buff and not buff:IsNull() then
        buff:SetStackCount(stacks)
        if buff.ForceRefresh then
            buff:ForceRefresh()
        end
    end
end

function modifier_talent_skill_5:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    local p = self:GetParent()
    if not p or p:IsNull() or params.unit ~= p then
        return
    end
    if ClrbTalent5IsExcludedAbility(params.ability) then
        return
    end
    self:_AddMagicAmpStack()
end

function modifier_talent_skill_5:OnRespawn()
    if not IsServer() then
        return
    end
    self:_TryUnlockSpellLifesteal()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_5:OnCreated()
    if not IsServer() then
        return
    end
    self.spell_lifesteal_unlocked = false
    self:_TryUnlockSpellLifesteal()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_5:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:_TryUnlockSpellLifesteal()
end

function modifier_talent_skill_5:OnTooltip()
    return self:IsSpellLifestealUnlocked() and SPELL_LS_PCT or 0
end

function modifier_talent_skill_5:GetTexture()
    return TEXTURE_BUFF
end

--------------------------------------------------------------------------------
-- 临时 buff：图标显示层数；悬浮显示层数 + 魔法增伤%（参考攻击升级）
--------------------------------------------------------------------------------
function modifier_talent_skill_5_buff:IsHidden()
    return false
end

function modifier_talent_skill_5_buff:IsDebuff()
    return false
end

function modifier_talent_skill_5_buff:IsPurgable()
    return true
end

function modifier_talent_skill_5_buff:RemoveOnDeath()
    return true
end

function modifier_talent_skill_5_buff:DestroyOnExpire()
    return true
end

function modifier_talent_skill_5_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_talent_skill_5_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

function modifier_talent_skill_5_buff:OnCreated()
    if not IsServer() then
        return
    end
    if (self:GetStackCount() or 0) < 1 then
        self:SetStackCount(1)
    end
end

function modifier_talent_skill_5_buff:OnRefresh()
    -- duration / 层数由外部 AddNewModifier + SetStackCount 处理
end

function modifier_talent_skill_5_buff:GetMagicAmpPercent()
    return math.max(0, self:GetStackCount() or 0) * BUFF_STACK_PCT
end

--- 悬浮：魔法增伤百分比
function modifier_talent_skill_5_buff:OnTooltip()
    return self:GetMagicAmpPercent()
end

--- 悬浮：当前层数
function modifier_talent_skill_5_buff:OnTooltip2()
    return math.max(0, self:GetStackCount() or 0)
end

function modifier_talent_skill_5_buff:GetTexture()
    return TEXTURE_BUFF
end
