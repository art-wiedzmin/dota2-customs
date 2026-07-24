--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 被动天赋 8：猎人——对中立野怪额外 +30% 物理伤害；每击杀中立野怪 +3 生命上限（见 Talent:Kill）
-- 6 / 15 / 21 分钟分别获得狼王内丹、肉山心脏、风暴核心

modifier_talent_skill_8 = class({})

local HUNTER_ITEM_MILESTONES = {
    { min = 6,  item = "item_goods_10", label = "狼王内丹", flag = "_granted_wolf" },
    { min = 15, item = "item_goods_11", label = "肉山心脏", flag = "_granted_bear" },
    { min = 21, item = "item_goods_26", label = "风暴核心", flag = "_granted_dragon" },
}

local function hunter_grant_bonus_crystal(player_id)
    if not player_id or player_id < 0 or not Item or not Item.AddItem then
        return
    end
    local added = Item:AddItem(player_id, "item_goods_25")
    if added and Util and Util.BottomMsg2ID then
        Util:BottomMsg2ID(player_id, "猎人：额外获得 雷纹结晶", "yellow", 3)
    end
end

local function hunter_owner_player_id(mod)
    local hero = mod and mod:GetParent()
    if not hero or hero:IsNull() then
        return -1
    end
    if ClrbGetOwnerPlayerId then
        return ClrbGetOwnerPlayerId(hero)
    end
    return hero:GetPlayerOwnerID()
end

function modifier_talent_skill_8:IsHidden()
    return true
end

function modifier_talent_skill_8:IsDebuff()
    return false
end

function modifier_talent_skill_8:IsPurgable()
    return false
end

function modifier_talent_skill_8:RemoveOnDeath()
    return false
end

function modifier_talent_skill_8:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_RESPAWN }
end

function modifier_talent_skill_8:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    local t = keys.target
    if not t or t:IsNull() or not t:IsAlive() then
        return
    end
    if t:IsHero() then
        return
    end
    local base = keys.original_damage or keys.damage or 0
    if base <= 0 then
        return
    end
    ApplyDamage({
        victim = t,
        attacker = keys.attacker,
        damage = base * 0.3,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = nil,
    })
end

function modifier_talent_skill_8:_TryGrantTimedItems()
    if not IsServer() then
        return
    end
    local game_min = (MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin()) or 0
    local pid = hunter_owner_player_id(self)
    if pid < 0 or not Item or not Item.AddItem then
        return
    end

    for _, row in ipairs(HUNTER_ITEM_MILESTONES) do
        if game_min >= row.min and not self[row.flag] then
            self[row.flag] = true
            local added = Item:AddItem(pid, row.item)
            if added and Util and Util.BottomMsg2ID then
                Util:BottomMsg2ID(pid, "猎人：获得 " .. row.label, "yellow", 3)
            end
            -- 仅通过天赋里程碑发放时额外给雷纹结晶（击杀掉落等不触发）
            if added then
                hunter_grant_bonus_crystal(pid)
            end
        end
    end
end

function modifier_talent_skill_8:OnRespawn()
    if not IsServer() then
        return
    end
    self:_TryGrantTimedItems()
    self:StartIntervalThink(1)
end

function modifier_talent_skill_8:OnCreated()
    if IsServer() then
        self:_TryGrantTimedItems()
        self:StartIntervalThink(1)
    end
end

function modifier_talent_skill_8:OnIntervalThink()
    if not IsServer() then
        return
    end
    self:_TryGrantTimedItems()
end

function modifier_talent_skill_8:GetTexture()
    return "item_bfury"
end
