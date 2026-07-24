--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 选人天赋 passive / 辅助 buff（与 item_talent_skill_* 展示物品配合）

CLRB_TALENT_SKILL_ITEM_PREFIX = "item_talent_skill_"
CLRB_NATIVE_TP_ITEM = "item_tpscroll"

---@param hero CDOTA_BaseNPC_Hero
function ClrbGetOwnerPlayerId(hero)
    if not hero or hero:IsNull() then
        return -1
    end
    local pid = hero:GetPlayerOwnerID()
    if pid >= 0 then
        return pid
    end
    if hero.pseudo_player_id ~= nil then
        return hero.pseudo_player_id
    end
    return -1
end

---@param talent_index number
---@return string
function ClrbTalentItemNameForIndex(talent_index)
    local t = ClrbSanitizeTalentIndex and ClrbSanitizeTalentIndex(talent_index)
        or tonumber(talent_index) or 1
    return CLRB_TALENT_SKILL_ITEM_PREFIX .. tostring(t)
end

---@param item CDOTA_Item|nil
---@return boolean
function ClrbIsTalentSkillItem(item)
    if not item or item:IsNull() or not item.GetName then
        return false
    end
    return string.match(item:GetName(), "^item_talent_skill_%d+$") ~= nil
end

function ClrbTalentTpSlot()
    return tonumber(rawget(_G, "DOTA_ITEM_TP_SLOT")) or 15
end

function ClrbIsLockedTalentTpSlot(slot)
    return slot ~= nil and slot == ClrbTalentTpSlot()
end

local function clrb_remove_item_by_name(hero, item_name)
    if not hero or hero:IsNull() or not item_name then
        return
    end
    for slot = 0, 23 do
        local it = hero:GetItemInSlot(slot)
        if it and not it:IsNull() and it:GetName() == item_name then
            pcall(function()
                hero:RemoveItem(it)
            end)
        end
    end
end

local function clrb_remove_all_native_tpscroll(hero)
    clrb_remove_item_by_name(hero, CLRB_NATIVE_TP_ITEM)
end

local function clrb_remove_other_talent_skill_items(hero, keep_name)
    if not hero or hero:IsNull() then
        return
    end
    for slot = 0, 23 do
        local it = hero:GetItemInSlot(slot)
        if ClrbIsTalentSkillItem(it) and it:GetName() ~= keep_name then
            pcall(function()
                hero:RemoveItem(it)
            end)
        end
    end
end

local function clrb_swap_talent_item_to_tp_slot(hero, item, target)
    if not hero or hero:IsNull() or not item or item:IsNull() or not hero.SwapItems then
        return
    end
    local cur = item:GetItemSlot()
    if cur == target then
        return
    end
    pcall(function()
        hero:SwapItems(cur, target)
    end)
    if Timers then
        Timers(0.06, function()
            if not hero or hero:IsNull() or not item or item:IsNull() then
                return
            end
            local c = item:GetItemSlot()
            if c ~= target and hero.SwapItems then
                pcall(function()
                    hero:SwapItems(c, target)
                end)
            end
        end)
    end
end

--- 开局 / 换天赋：移除原生回城卷轴，发放 item_talent_skill_N 并固定到回城卷轴栏
function ClrbEnsureTalentItemInTpSlot(hero)
    if not IsServer() or not hero or hero:IsNull() then
        return false
    end
    clrb_remove_all_native_tpscroll(hero)
    local target = ClrbTalentTpSlot()
    local want_name = ClrbTalentItemNameForIndex(ClrbGetTalentIndexForHero(hero))
    clrb_remove_other_talent_skill_items(hero, want_name)

    local found
    for slot = 0, 23 do
        local it = hero:GetItemInSlot(slot)
        if it and not it:IsNull() and it:GetName() == want_name then
            found = it
            clrb_swap_talent_item_to_tp_slot(hero, it, target)
            break
        end
    end
    if found then
        return true
    end

    local it = CreateItem(want_name, hero, hero)
    if not it or it:IsNull() then
        return false
    end
    hero:AddItem(it)
    if Timers then
        Timers(0, function()
            ClrbEnsureTalentItemInTpSlot(hero)
        end)
    end
    return false
end

--- 兼容旧引用
ClrbIsTalentTpItem = ClrbIsTalentSkillItem

--- 同步给客户端，供物品 GetAbilityTextureName / GetCooldown（客户端无 InitPlayer）
function ClrbSyncTalentNettable(player_id, talent_index)
    if not IsServer() or not player_id or not CustomNetTables then
        return
    end
    local t = ClrbSanitizeTalentIndex(talent_index)
    CustomNetTables:SetTableValue("clrb_talent", tostring(player_id), { talent_index = t })
    ClrbTalentSyncEquipTooltipNettable(player_id)
    if Util and Util.ID2Hero then
        local hero = Util:ID2Hero(player_id)
        if hero and not hero:IsNull() then
            ClrbEnsureTalentItemInTpSlot(hero)
        end
    end
end

--- 天赋 9 金币档位：供客户端 getter / HUD
function ClrbSyncTalent9GoldTier(player_id, tier)
    if not IsServer() or player_id == nil or not CustomNetTables then
        return
    end
    local k = tonumber(tier) or 0
    if k < 0 then k = 0 end
    CustomNetTables:SetTableValue("clrb_talent9_gold", tostring(player_id), { tier = k })
end

function ClrbTalentIsHidden(talent_index)
    local t = tonumber(talent_index)
    if not t then
        return false
    end
    if IsServer() and SelectHero and SelectHero.IsTalentHidden then
        return SelectHero:IsTalentHidden(t)
    end
    -- 客户端兜底（与 SelectHero.HiddenTalentIndices 同步）
    return false
end

function ClrbSanitizeTalentIndex(talent_index)
    local t = tonumber(talent_index) or 1
    if t < 1 then
        t = 1
    end
    if t > 9 then
        t = 9
    end
    if ClrbTalentIsHidden(t) then
        if IsServer() and SelectHero and SelectHero.DefaultTalentIndex then
            t = tonumber(SelectHero.DefaultTalentIndex) or 1
        else
            t = 1
        end
    end
    return t
end

function ClrbGetTalentIndexForHero(hero)
    local pid = ClrbGetOwnerPlayerId(hero)
    if pid < 0 then
        return 1
    end
    -- 选人 UI 里天赋可能在点选英雄之后才改，只写了 SelectHero/Data + NetTable，InitPlayer 仍是旧值
    if IsServer() and SelectHero and SelectHero.Data and SelectHero.Data[pid] and SelectHero.Data[pid].talent_index ~= nil then
        local t = ClrbSanitizeTalentIndex(SelectHero.Data[pid].talent_index)
        return t
    end
    if IsServer() and InitPlayer and InitPlayer.GetPlayerData then
        local p = InitPlayer:GetPlayerData(pid)
        if p and p.talent_index ~= nil then
            return ClrbSanitizeTalentIndex(p.talent_index)
        end
    end
    if CustomNetTables then
        local row = CustomNetTables:GetTableValue("clrb_talent", tostring(pid))
        if row then
            return ClrbSanitizeTalentIndex(row.talent_index)
        end
    end
    return 1
end

--- 天赋 1–9 均为被动，不可主动施放
function ClrbTalentIsPassive(talent_index)
    local t = tonumber(talent_index) or 1
    if t < 1 then
        t = 1
    end
    if t > 9 then
        t = 9
    end
    return t >= 1 and t <= 9
end

--- 铁匠（天赋 3）：天赋装备各等级升级所需杀敌数减少量（对应 up_0 … up_4）
local BLACKSMITH_KILL_REDUCE = { 10, 20, 20, 30, 30 }

---@param player_id number
---@return boolean
function ClrbTalentPlayerHasBlacksmith(player_id)
    if player_id == nil then
        return false
    end
    local hero = Util and Util.ID2Hero and Util:ID2Hero(player_id)
    if hero and not hero:IsNull() then
        return ClrbGetTalentIndexForHero(hero) == 3
    end
    if IsServer() and SelectHero and SelectHero.Data and SelectHero.Data[player_id] then
        return (tonumber(SelectHero.Data[player_id].talent_index) or 1) == 3
    end
    if IsServer() and InitPlayer and InitPlayer.GetPlayerData then
        local pd = InitPlayer:GetPlayerData(player_id)
        if pd and pd.talent_index ~= nil then
            return (tonumber(pd.talent_index) or 1) == 3
        end
    end
    return false
end

--- 当前等级段升级所需杀敌数（equip_level 0–4 → up_0 … up_4）
---@param player_id number
---@param equip_level number
---@return number
function ClrbTalentGetEquipUpgradeKillsRequired(player_id, equip_level)
    local lv = tonumber(equip_level) or 0
    if lv < 0 then
        lv = 0
    end
    if lv > 4 then
        lv = 4
    end
    local key = "up_" .. lv
    local base = Talent and Talent.Static and Talent.Static[key]
    if not base then
        return 0
    end
    if not ClrbTalentPlayerHasBlacksmith(player_id) then
        return base
    end
    local reduce = BLACKSMITH_KILL_REDUCE[lv + 1] or 0
    return math.max(1, base - reduce)
end

--- 铁匠：天赋装备基础属性 +30%（迅捷之刃攻速/移速、荆棘者之甲护甲/生命增幅、斗篷技能增强/作用范围、雷电戟全属性）
local BLACKSMITH_EQUIP_ATTR_MULT = 1.3

local BLACKSMITH_EQUIP_BOOST_KEYS = {
    item_goods_17 = { gjsd = true, jcys = true },
    item_goods_18 = { smzf = true, wlkx = true },
    item_goods_19 = { jnzq = true, zyfw = true },
    item_goods_24 = { jcll = true, jcmj = true, jczl = true },
}

---@param player_id number
---@param item_name string
---@param attr_key string
---@param base_value number
---@return number
function ClrbTalentBlacksmithScaledEquipAttr(player_id, item_name, attr_key, base_value)
    local base = tonumber(base_value) or 0
    if base <= 0 then
        return base
    end
    if not ClrbTalentPlayerHasBlacksmith(player_id) then
        return base
    end
    local keys = BLACKSMITH_EQUIP_BOOST_KEYS[item_name]
    if not keys or not keys[attr_key] then
        return base
    end
    return math.floor(base * BLACKSMITH_EQUIP_ATTR_MULT + 0.5)
end

--- 天赋装备 hover：按 Talent.Equip 累计各等级基础属性（铁匠时含 +30%）
---@param player_id number
---@param item_name string
---@param attr_key string
---@param as_percent boolean
---@return table
local function clrb_talent_build_equip_tip_cumulative(player_id, item_name, attr_key, as_percent)
    local nums = {}
    local sum = 0
    if not Talent or not Talent.Equip or not Talent.Equip[item_name] then
        return nums
    end
    for lv = 0, 5 do
        local rank = "rank" .. lv
        local rank_row = Talent.Equip[item_name][rank]
        local v = rank_row and tonumber(rank_row[attr_key]) or 0
        if v > 0 and ClrbTalentBlacksmithScaledEquipAttr then
            v = ClrbTalentBlacksmithScaledEquipAttr(player_id, item_name, attr_key, v)
        end
        sum = sum + v
        local text = tostring(sum)
        if as_percent then
            text = text .. "%"
        end
        nums[tostring(lv)] = text
    end
    return nums
end

--- 同步天赋装备 tooltip 基础属性条（talenttip / bagtipnew）
---@param player_id number
function ClrbTalentSyncEquipTooltipNettable(player_id)
    if not IsServer() or player_id == nil or not CustomNetTables then
        return
    end
    local row = {
        item_goods_17 = {
            attr_1 = { attr_num = clrb_talent_build_equip_tip_cumulative(player_id, "item_goods_17", "gjsd", false) },
            attr_2 = { attr_num = clrb_talent_build_equip_tip_cumulative(player_id, "item_goods_17", "jcys", false) },
        },
        item_goods_18 = {
            attr_1 = { attr_num = clrb_talent_build_equip_tip_cumulative(player_id, "item_goods_18", "wlkx", false) },
            attr_2 = { attr_num = clrb_talent_build_equip_tip_cumulative(player_id, "item_goods_18", "smzf", true) },
        },
        item_goods_19 = {
            attr_1 = { attr_num = clrb_talent_build_equip_tip_cumulative(player_id, "item_goods_19", "jnzq", true) },
            attr_2 = { attr_num = clrb_talent_build_equip_tip_cumulative(player_id, "item_goods_19", "zyfw", false) },
        },
        item_goods_24 = {
            attr_1 = { attr_num = clrb_talent_build_equip_tip_cumulative(player_id, "item_goods_24", "jcll", false) },
        },
    }
    CustomNetTables:SetTableValue("clrb_talent_equip_tip", tostring(player_id), row)
end

--- 与天赋展示物品一致（当前均为被动，CD 为 0）
function ClrbTalentItemCooldownSeconds(talent_index)
    local cd = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    local t = tonumber(talent_index) or 1
    if t < 1 then t = 1 end
    if t > 9 then t = 9 end
    return cd[t] or 0
end

--- 被动天赋 modifier：modifier_talent_skill_<1–9>，见各独立文件
local PASSIVE_MODIFIER_NAMES = {
    "modifier_talent_skill_1",
    "modifier_talent_skill_2",
    "modifier_talent_skill_3",
    "modifier_talent_skill_4",
    "modifier_talent_skill_5",
    "modifier_talent_skill_6",
    "modifier_talent_skill_7",
    "modifier_talent_skill_8",
    "modifier_talent_skill_9",
}

-- 学者：使用技能书时随机绿字属性（力量/敏捷/智力之一）
local SCHOLAR_BOOK_STAT_RANGE = {
    item_goods_14 = { min = 1, max = 2 },   -- 初级
    item_goods_15 = { min = 3, max = 4 },   -- 高级
    item_goods_16 = { min = 5, max = 8 },   -- 究极
}

local function ClrbTalentScholarRollStatBonus(item_name)
    local range = SCHOLAR_BOOK_STAT_RANGE[item_name]
    if not range then
        return 0
    end
    return RandomInt(range.min, range.max)
end

local SCHOLAR_STAT_ROLL = {
    { field = "str_bonus", label = "力量" },
    { field = "agi_bonus", label = "敏捷" },
    { field = "int_bonus", label = "智力" },
}

---@param player_id number
---@param item_name string
function ClrbTalentScholarOnBookUsed(player_id, item_name)
    if not IsServer() or player_id == nil or not item_name then
        return
    end
    local bonus = ClrbTalentScholarRollStatBonus(item_name)
    if bonus <= 0 then
        return
    end
    local hero = Util:ID2Hero(player_id)
    if not hero or hero:IsNull() then
        return
    end
    if ClrbGetTalentIndexForHero(hero) ~= 2 then
        return
    end
    local m = hero:FindModifierByName("modifier_talent_skill_2")
    if not m or m:IsNull() then
        ClrbTalentApplyPassives(player_id, hero)
        m = hero:FindModifierByName("modifier_talent_skill_2")
    end
    if not m or m:IsNull() then
        return
    end
    if m.str_bonus == nil then
        m.str_bonus = 0
        m.agi_bonus = 0
        m.int_bonus = 0
    end
    local pick = SCHOLAR_STAT_ROLL[RandomInt(1, #SCHOLAR_STAT_ROLL)]
    m[pick.field] = (m[pick.field] or 0) + bonus
    if m._SyncTooltipStack then
        m:_SyncTooltipStack()
    else
        m:SetStackCount((m.str_bonus or 0) + (m.agi_bonus or 0) + (m.int_bonus or 0))
    end
    hero:CalculateStatBonus(true)
    if Util and Util.BottomMsg2ID then
        Util:BottomMsg2ID(player_id, string.format("学者：%s +%d", pick.label, bonus), "yellow", 2)
    end
end

local SCHOLAR_BOOK_TIER_ITEM = {
    T2 = "item_goods_14",
    T1 = "item_goods_15",
    T0 = "item_goods_16",
}

--- Skill:UseBook 打开三选一页面时结算（见 Skill:UseBook）
function ClrbTalentScholarOnBookTier(player_id, book_tier)
    if not book_tier then
        return
    end
    local item_name = SCHOLAR_BOOK_TIER_ITEM[book_tier]
    if item_name then
        ClrbTalentScholarOnBookUsed(player_id, item_name)
    end
end

--- 选人阶段英雄未生成时，延迟重挂被动（学者发书等）
---@param player_id number
function ClrbTalentScheduleApplyPassives(player_id)
    if not IsServer() or player_id == nil or not Timers then
        return
    end
    for _, delay in ipairs({ 0.5, 2, 5 }) do
        Timers(delay, function()
            if not ClrbTalentApplyPassives then
                return
            end
            local hero = Util and Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(player_id)
            if not hero or hero:IsNull() then
                hero = Util and Util.ID2Hero and Util:ID2Hero(player_id)
            end
            if hero and not hero:IsNull() then
                ClrbTalentApplyPassives(player_id, hero)
            end
        end)
    end
end

---@param player_id number
---@param hero CDOTA_BaseNPC_Hero
function ClrbTalentApplyPassives(player_id, hero)
    if not hero or hero:IsNull() then
        return
    end
    for _, name in ipairs(PASSIVE_MODIFIER_NAMES) do
        hero:RemoveModifierByName(name)
    end
    -- 切换天赋时清掉法神临时增伤层
    hero:RemoveModifierByName("modifier_talent_skill_5_buff")
    -- 旧版「开了」被动视野残留清理
    if hero._clrb_talent5_vision_applied and HeroData and HeroData.AddSX then
        local pid = player_id
        if pid == nil or pid < 0 then
            pid = ClrbGetOwnerPlayerId(hero)
        end
        if pid >= 0 then
            HeroData:AddSX(pid, "syjc", -150)
        end
        hero._clrb_talent5_vision_applied = nil
    end
    local t = ClrbGetTalentIndexForHero(hero)
    if t == 1 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_1", {})
    elseif t == 2 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_2", {})
    elseif t == 3 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_3", {})
    elseif t == 4 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_4", { player_id = player_id })
    elseif t == 5 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_5", {})
    elseif t == 6 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_6", {})
    elseif t == 7 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_7", {})
    elseif t == 8 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_8", {})
    elseif t == 9 then
        hero:AddNewModifier(hero, nil, "modifier_talent_skill_9", {})
    end
    ClrbEnsureTalentItemInTpSlot(hero)
end

--------------------------------------------------------------------------------
-- 通用短眩晕
modifier_clrb_stun = class({})

function modifier_clrb_stun:IsHidden()
    return false
end

function modifier_clrb_stun:IsDebuff()
    return true
end

function modifier_clrb_stun:IsStunDebuff()
    return true
end

function modifier_clrb_stun:IsPurgable()
    return true
end

function modifier_clrb_stun:OnCreated(kv)
    if not IsServer() then
        return
    end
    local d = tonumber(kv and kv.duration)
    if d and d > 0 then
        self:SetDuration(d, true)
    end
end

function modifier_clrb_stun:CheckState()
    return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_clrb_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_clrb_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
-- 识破反制：短眩晕，无视技能免疫
modifier_clrb_insight_parry_stun = class({})

function modifier_clrb_insight_parry_stun:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_clrb_insight_parry_stun:IsHidden()
    return false
end

function modifier_clrb_insight_parry_stun:IsDebuff()
    return true
end

function modifier_clrb_insight_parry_stun:IsStunDebuff()
    return true
end

function modifier_clrb_insight_parry_stun:IsPurgable()
    return true
end

function modifier_clrb_insight_parry_stun:OnCreated(kv)
    if not IsServer() then
        return
    end
    local d = tonumber(kv and kv.duration)
    if d and d > 0 then
        self:SetDuration(d, true)
    end
end

function modifier_clrb_insight_parry_stun:CheckState()
    return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_clrb_insight_parry_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_clrb_insight_parry_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
-- 绝境：100% 减伤（非无敌，仍受部分非伤害效果影响）
modifier_clrb_invuln = class({})

function modifier_clrb_invuln:IsHidden()
    return false
end

function modifier_clrb_invuln:IsDebuff()
    return false
end

function modifier_clrb_invuln:IsPurgable()
    return false
end

function modifier_clrb_invuln:OnCreated()
    if not IsServer() then
        return
    end
    local p = self:GetParent()
    if p and not p:IsNull() then
        EmitSoundOn("Hero_Omniknight.GuardianAngel.Cast", p)
    end
end

function modifier_clrb_invuln:DeclareFunctions()
    return {}
end

--------------------------------------------------------------------------------
-- 传送门落地：极短无敌（无音效、隐藏）
modifier_clrb_door_teleport_invuln = class({})

function modifier_clrb_door_teleport_invuln:IsHidden()
    return true
end

function modifier_clrb_door_teleport_invuln:IsDebuff()
    return false
end

function modifier_clrb_door_teleport_invuln:IsPurgable()
    return false
end

function modifier_clrb_door_teleport_invuln:OnCreated(kv)
    if not IsServer() then
        return
    end
    local d = tonumber(kv and kv.duration)
    if d and d > 0 then
        self:SetDuration(d, true)
    end
end

function modifier_clrb_door_teleport_invuln:CheckState()
    return { [MODIFIER_STATE_INVULNERABLE] = true }
end

--------------------------------------------------------------------------------
-- 拘魂：缠绕 + 承受额外魔法（替代奶绿减速为缠绕）
modifier_clrb_ethereal_root = class({})

function modifier_clrb_ethereal_root:IsHidden()
    return false
end

function modifier_clrb_ethereal_root:IsDebuff()
    return true
end

function modifier_clrb_ethereal_root:IsPurgable()
    return true
end

function modifier_clrb_ethereal_root:CheckState()
    return {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = false,
    }
end

function modifier_clrb_ethereal_root:DeclareFunctions()
    return { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS }
end

function modifier_clrb_ethereal_root:GetModifierMagicalResistanceBonus()
    return -25
end

function modifier_clrb_ethereal_root:GetEffectName()
    return "particles/items_fx/ethereal_blade.vpcf"
end

function modifier_clrb_ethereal_root:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
