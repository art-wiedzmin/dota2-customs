--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 2：学者——每分钟随机发一本技能书（未满15分钟初级94%/高级5%；满15分钟后初级94%/高级5%/究极1%）；用书加绿字属性见 modifier_clrb_talents
-- Tooltip 键：DOTA_Tooltip_modifier_talent_skill_2（三维数值经 CustomNetTables clrb_scholar_attr 同步至客户端）

modifier_talent_skill_2 = class({})

local BOOK_INTERVAL = 60
local SCHOLAR_ULTIMATE_UNLOCK_MIN = 15
local SCHOLAR_NETTABLE = "clrb_scholar_attr"

local SCHOLAR_BOOK_ROLL = {
    item_goods_14 = 94,
    item_goods_15 = 5,
    item_goods_16 = 1,
}

local SCHOLAR_BOOK_ROLL_BEFORE_ULTIMATE = {
    item_goods_14 = 94,
    item_goods_15 = 5,
}

local SCHOLAR_BOOK_LABEL = {
    item_goods_14 = "初级技能书",
    item_goods_15 = "高级技能书",
    item_goods_16 = "究极技能书",
}

function ClrbTalentScholarRollBookItemName()
    if not Util or not Util.Weight then
        return "item_goods_14"
    end
    local roll = SCHOLAR_BOOK_ROLL
    local game_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
    if game_min < SCHOLAR_ULTIMATE_UNLOCK_MIN then
        roll = SCHOLAR_BOOK_ROLL_BEFORE_ULTIMATE
    end
    return Util:Weight(roll) or "item_goods_14"
end

local function scholar_owner_player_id(mod)
    local hero = mod and mod:GetParent()
    if not hero or hero:IsNull() then
        return -1
    end
    if ClrbGetOwnerPlayerId then
        return ClrbGetOwnerPlayerId(hero)
    end
    return hero:GetPlayerOwnerID()
end

function modifier_talent_skill_2:IsHidden()
    return false
end

function modifier_talent_skill_2:IsDebuff()
    return false
end

function modifier_talent_skill_2:IsPurgable()
    return false
end

function modifier_talent_skill_2:RemoveOnDeath()
    return false
end

function modifier_talent_skill_2:IsPermanent()
    return true
end

function modifier_talent_skill_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
        MODIFIER_EVENT_ON_RESPAWN,
    }
end

function modifier_talent_skill_2:_EnsureAttrInit()
    if self.str_bonus == nil then
        self.str_bonus = 0
        self.agi_bonus = 0
        self.int_bonus = 0
    end
end

function modifier_talent_skill_2:_PushScholarNetTable(pid)
    if not IsServer() or pid == nil or pid < 0 or not CustomNetTables then
        return
    end
    self:_EnsureAttrInit()
    CustomNetTables:SetTableValue(SCHOLAR_NETTABLE, tostring(pid), {
        str = math.floor(self.str_bonus or 0),
        agi = math.floor(self.agi_bonus or 0),
        int = math.floor(self.int_bonus or 0),
    })
end

function modifier_talent_skill_2:_ReadScholarAttr(which)
    self:_EnsureAttrInit()
    if IsServer() then
        if which == 1 then
            return self.str_bonus or 0
        elseif which == 2 then
            return self.agi_bonus or 0
        end
        return self.int_bonus or 0
    end
    local pid = scholar_owner_player_id(self)
    if pid >= 0 and CustomNetTables then
        local row = CustomNetTables:GetTableValue(SCHOLAR_NETTABLE, tostring(pid))
        if row then
            if which == 1 then
                return tonumber(row.str) or 0
            elseif which == 2 then
                return tonumber(row.agi) or 0
            end
            return tonumber(row.int) or 0
        end
    end
    if which == 1 then
        return self.str_bonus or 0
    elseif which == 2 then
        return self.agi_bonus or 0
    end
    return self.int_bonus or 0
end

function modifier_talent_skill_2:AddCustomTransmitterData()
    self:_EnsureAttrInit()
    return {
        s = math.floor(self.str_bonus or 0),
        a = math.floor(self.agi_bonus or 0),
        i = math.floor(self.int_bonus or 0),
    }
end

function modifier_talent_skill_2:HandleCustomTransmitterData(data)
    if not data then
        return
    end
    self.str_bonus = tonumber(data.s) or 0
    self.agi_bonus = tonumber(data.a) or 0
    self.int_bonus = tonumber(data.i) or 0
end

function modifier_talent_skill_2:_SyncTooltipStack()
    if not IsServer() then
        return
    end
    self:_EnsureAttrInit()
    local total = (self.str_bonus or 0) + (self.agi_bonus or 0) + (self.int_bonus or 0)
    self:SetStackCount(total)
    self:_PushScholarNetTable(scholar_owner_player_id(self))
    if self.SendBuffRefreshToClients then
        self:SendBuffRefreshToClients()
    end
    if self.ForceRefresh then
        self:ForceRefresh()
    end
end

function modifier_talent_skill_2:GetModifierBonusStats_Strength()
    return self:_ReadScholarAttr(1)
end

function modifier_talent_skill_2:GetModifierBonusStats_Agility()
    return self:_ReadScholarAttr(2)
end

function modifier_talent_skill_2:GetModifierBonusStats_Intellect()
    return self:_ReadScholarAttr(3)
end

function modifier_talent_skill_2:OnTooltip()
    return self:_ReadScholarAttr(1)
end

function modifier_talent_skill_2:OnTooltip2()
    return self:_ReadScholarAttr(2)
end

function modifier_talent_skill_2:_ScholarPlayerId()
    local p = self:GetParent()
    if not p or p:IsNull() then
        return -1
    end
    local pid = scholar_owner_player_id(self)
    if pid >= 0 then
        return pid
    end
    if Util and Util.Hero2ID then
        return Util:Hero2ID(p) or -1
    end
    return -1
end

-- 发书节奏与修仙 modifier_talent_skill_6:_TryAddXiuWei 一致（按对局时间每满 60s 结算，死亡期间同样累计）
function modifier_talent_skill_2:_TryGrantBook()
    if not IsServer() then
        return
    end
    local p = self:GetParent()
    if not p or p:IsNull() then
        return
    end

    local now = GameRules:GetGameTime()
    if not self._last_book_time then
        self._last_book_time = now
        return
    end

    local grants = 0
    while (now - self._last_book_time) >= BOOK_INTERVAL do
        grants = grants + 1
        self._last_book_time = self._last_book_time + BOOK_INTERVAL
    end

    if grants <= 0 then
        return
    end

    local pid = self:_ScholarPlayerId()
    if pid < 0 or not Item or not Item.AddItem then
        return
    end

    for _ = 1, grants do
        local item_name = ClrbTalentScholarRollBookItemName()
        local added = Item:AddItem(pid, item_name)
        if Util and Util.BottomMsg2ID and added then
            local label = SCHOLAR_BOOK_LABEL[item_name] or item_name
            Util:BottomMsg2ID(pid, "学者：获得 " .. label, "yellow", 2)
        end
    end
end

function modifier_talent_skill_2:OnRespawn()
    if not IsServer() then
        return
    end
    self:_TryGrantBook()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_2:OnCreated()
    self:_EnsureAttrInit()
    if IsServer() then
        local legacy = self:GetStackCount() or 0
        if legacy > 0 and (self.str_bonus or 0) + (self.agi_bonus or 0) + (self.int_bonus or 0) == 0 then
            self.str_bonus = legacy
            self.agi_bonus = legacy
            self.int_bonus = legacy
        end
        self:_SyncTooltipStack()
        self._last_book_time = GameRules:GetGameTime()
        self:StartIntervalThink(1)
    end
end

function modifier_talent_skill_2:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:_TryGrantBook()
end

function modifier_talent_skill_2:GetTexture()
    return "buff/talent_2"
end
