--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 日常成就局内会话缓存（仅内存，不写服务端）
-- 局内伤害/击杀/掠夺等在此累计；OverData:LogGame 结算上报 custom_data.achieve_day_stat；
-- 服务端仅在 /game/submit 成功后才 merge 到 achieve.daystat。
if AchieveStat == nil then
    AchieveStat = class({})
end

--- 本局会话计数（AchieveStat.Data[playerID]），非持久化
AchieveStat.Data = AchieveStat.Data or {}

AchieveStat.StatTemplate = {
    dmg_suicide = 0,
    dmg_lightning = 0,
    dmg_crush = 0,
    bash_enemy = 0,
    dmg_flame = 0,
    plunder_gold = 0,
    kill_neutral = 0,
    kill_hero = 0,
}

AchieveStat.DmgAbilityMap = {
    ability_item_20 = "dmg_lightning",
    ability_item_20_up = "dmg_lightning",
    -- ability_item_13 纯粹伤害在普攻帧无 inflictor，见 TrackSkillDamage / modifier_ability_item_13
    ability_item_14 = "dmg_crush",
    ability_item_14_up = "dmg_crush",
    ability_item_36 = "dmg_flame",
}

--- 仅 modifier 内累计的技能 → daystat 键（与 achieveDayConfig bash_enemy_500.statKey 一致）
AchieveStat.ModifierOnlyDmgAbilityMap = {
    ability_item_13 = "bash_enemy",
}

function AchieveStat:IsHumanPlayer(ID)
    if not ID then
        return false
    end
    local init_data = InitPlayer:GetPlayerData(ID)
    return init_data and not init_data.bot
end

--- 与通行证任务相同：仅合格对局才累计本会话（不合格局即使局内有数据也不会上报入库）
function AchieveStat:IsSessionEligible(ID)
    if not self:IsHumanPlayer(ID) then
        return false
    end
    if OverData and OverData.ShouldCountCardTaskStats then
        return OverData:ShouldCountCardTaskStats(ID) == true
    end
    return true
end

function AchieveStat:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.StatTemplate)
end

function AchieveStat:Add(ID, key, amount)
    if not ID or not key or not self:IsSessionEligible(ID) then
        return
    end
    if not self.StatTemplate[key] then
        return
    end
    local row = self.Data[ID]
    if not row then
        self:Init(ID)
        row = self.Data[ID]
    end
    local add = math.floor(tonumber(amount) or 0)
    if add <= 0 then
        return
    end
    row[key] = (tonumber(row[key]) or 0) + add
end

--- 肉搏攻击触发类伤害：纯粹伤害在 OnAttackLanded 帧内往往没有 inflictor，过滤器无法识别，须在 modifier 内直接累计
function AchieveStat:TrackSkillDamage(attacker, ability, damage)
    if not IsServer() then
        return
    end
    if not attacker or attacker:IsNull() or not ability or ability:IsNull() then
        return
    end
    local ID = Util:Hero2ID(attacker)
    if not ID then
        return
    end
    local ab_name = ability:GetAbilityName()
    if (not ab_name or ab_name == "") and type(ability.GetName) == "function" then
        ab_name = ability:GetName()
    end
    if not ab_name or ab_name == "" then
        return
    end
    local stat_key = self.ModifierOnlyDmgAbilityMap[ab_name] or self.DmgAbilityMap[ab_name]
    if stat_key then
        self:Add(ID, stat_key, damage)
    end
end

function AchieveStat:OnDamageDealt(attacker, inflictor_ent, victim, damage)
    if not IsServer() then
        return
    end
    if not attacker or attacker:IsNull() or not attacker:IsHero() then
        return
    end
    local ID = Util:Hero2ID(attacker)
    if not ID or not self:IsSessionEligible(ID) then
        return
    end
    local dmg = math.floor(tonumber(damage) or 0)
    if dmg <= 0 then
        return
    end

    local ab_name = nil
    if inflictor_ent and not inflictor_ent:IsNull() then
        if type(inflictor_ent.GetAbilityName) == "function" then
            ab_name = inflictor_ent:GetAbilityName()
        end
        if (not ab_name or ab_name == "") and type(inflictor_ent.GetName) == "function" then
            ab_name = inflictor_ent:GetName()
        end
    end

    if ab_name and self.DmgAbilityMap[ab_name] then
        self:Add(ID, self.DmgAbilityMap[ab_name], dmg)
    end
end

function AchieveStat:OnNeutralKill(ID)
    self:Add(ID, "kill_neutral", 1)
end

function AchieveStat:OnHeroKill(ID)
    self:Add(ID, "kill_hero", 1)
end

--- 结算上报用：取出本会话增量（仅 LogGame 调用，不在局内 HTTP）
function AchieveStat:BuildForLog(ID)
    if not self:IsSessionEligible(ID) then
        return nil
    end
    local row = self.Data[ID]
    if not row then
        return nil
    end
    local out = {}
    local has = false
    for key, _ in pairs(self.StatTemplate) do
        local v = math.floor(tonumber(row[key]) or 0)
        if v > 0 then
            out[key] = v
            has = true
        end
    end
    -- 兼容旧会话键 dmg_bash → bash_enemy（线上 daystat 仅 merge bash_enemy）
    local legacy_bash = math.floor(tonumber(row.dmg_bash) or 0)
    if legacy_bash > 0 then
        out.bash_enemy = (out.bash_enemy or 0) + legacy_bash
        has = true
    end
    if has then
        return out
    end
    return nil
end

--- 结算入库成功后清空本会话缓存，避免重复计入下一局
function AchieveStat:ClearSession(ID)
    if not ID then
        return
    end
    self.Data[ID] = nil
end
