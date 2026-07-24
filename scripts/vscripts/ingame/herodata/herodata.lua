--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


require("ingame.modifier.modifier_clrb_talents")

local function hero_ensure_item_run(hero)
    if not hero or hero:IsNull() then
        return
    end
    if ClrbEnsureTalentItemInTpSlot then
        ClrbEnsureTalentItemInTpSlot(hero)
    end
end

local function hero_ensure_modifier_rbzf(hero)
    if not hero or hero:IsNull() or hero:HasModifier("modifier_rbzf") then
        return
    end
    LinkLuaModifier("modifier_rbzf", "ingame/modifier/modifier_rbzf",
        LUA_MODIFIER_MOTION_NONE)
    hero:AddNewModifier(hero, nil, "modifier_rbzf", {})
end

--- 人机：肉搏祝福同套属性（智力魔抗 Direct 削弱较弱），与真人 modifier_rbzf 互斥
local function hero_ensure_modifier_rbzf_bot(hero)
    if not hero or hero:IsNull() or hero:HasModifier("modifier_rbzf_bot") then
        return
    end
    LinkLuaModifier("modifier_rbzf_bot", "ingame/modifier/modifier_rbzf_bot",
        LUA_MODIFIER_MOTION_NONE)
    hero:AddNewModifier(hero, nil, "modifier_rbzf_bot", {})
end

if HeroData == nil then
    HeroData = class({})
    require("ingame.HeroData.Config")
    require("ingame.HeroData.Set")
    require("ingame.HeroData.Get")
    require("ingame.HeroData.Func")
    require("ingame.HeroData.Ui")
end

require("ingame.modifier.modifier_clrb_talents")

local MOD_CLRB_RBZF_DEATH_ALLSTATS = "modifier_clrb_rbzf_death_allstats"

--- 肉搏祝福死亡补偿：额外全属性（绿字），每层 STR/AGI/INT 各 +1（可一次加 n层）
function HeroData:AddRbzfDeathBonusAllStatsGreen(hero, amount)
    if not IsServer() or not hero or hero:IsNull() or not amount or amount <= 0 then
        return
    end
    local m = hero:FindModifierByName(MOD_CLRB_RBZF_DEATH_ALLSTATS)
    if not m then
        m = hero:AddNewModifier(hero, nil, MOD_CLRB_RBZF_DEATH_ALLSTATS, {})
    end
    if m and not m:IsNull() then
        m:SetStackCount((m:GetStackCount() or 0) + amount)
    end
end

--- 死亡时入队（尸体上 AddNewModifier 常无效，见 TryApplyOfflinePetbuff 注释）
function HeroData:QueueRbzfDeathBonusAllStatsGreen(ID, amount)
    if not ID or not amount or amount <= 0 then
        return
    end
    local row = self.Data[ID]
    if not row then
        return
    end
    row.rbzf_death_bonus_pending = (row.rbzf_death_bonus_pending or 0) + amount
end

--- 复活后结算 pending 绿字层数
function HeroData:ApplyPendingRbzfDeathBonusAllStatsGreen(ID, hero)
    if not IsServer() or not ID or not hero or hero:IsNull() then
        return
    end
    local row = self.Data[ID]
    if not row then
        return
    end
    local pending = row.rbzf_death_bonus_pending or 0
    if pending <= 0 then
        return
    end
    row.rbzf_death_bonus_pending = 0
    self:AddRbzfDeathBonusAllStatsGreen(hero, pending)
end

function HeroData:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

--- 离线保护 modifier_petbuff：死亡单位上 AddNewModifier 常无效；死后断线只记 pending_disconnect_petbuff，复活后再挂
function HeroData:TryApplyOfflinePetbuff(ID)
    if not ID or not Util or Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
        return
    end
    if PlayerResource and not PlayerResource:IsValidPlayer(ID) then
        return
    end
    if Util:ID2IfOnline(ID) then
        local row = self.Data[ID]
        if row and row.tag then
            row.tag.pending_disconnect_petbuff = false
        end
        return
    end
    local row = self.Data[ID]
    if not row then
        return
    end
    local hero = self:GetHero(ID)
    if (not hero or hero:IsNull()) and PlayerResource and PlayerResource.GetSelectedHeroEntity then
        hero = PlayerResource:GetSelectedHeroEntity(ID)
    end
    if not hero or hero:IsNull() or not hero.IsHero or not hero:IsHero() then
        return
    end
    if not hero:IsAlive() then
        if row.tag then
            row.tag.pending_disconnect_petbuff = true
        end
        return
    end
    if row.tag then
        row.tag.pending_disconnect_petbuff = false
    end
    if not hero:HasModifier("modifier_petbuff") then
        local ok = pcall(function()
            utilex:AddModifier(hero, "modifier_petbuff")
        end)
        if not ok then
            -- 断线收尾阶段实体可能处于半销毁，避免 Lua 侧再抛错；原生崩溃需依赖上方 IsValidPlayer/英雄判空
        end
    end
end

-- 英雄初始化
function HeroData:InitHero(ID, hero)
    if not ID or not hero then return end
    if not hero then return end
    if hero:IsNull() then return end
    -- 只走一次
    local player = PlayerResource:GetPlayer(ID)
    if not player then return end
    if player:IsNull() then return end
    if HeroData.Data[ID] == nil then
        InitPlayer:Init_ID(ID)
        -- InitPlayer:HeroInit(ID, hero)
        return
    end
    -- 作弊检查
    if not IsInToolsMode() and GameRules:IsCheatMode() then
        SelectHero:ExitGame(ID)
    end
    if HeroData.Data[ID].init == true then return end
    self.Data[ID].init = true
    InitPlayer:HeroInit(ID, hero)
    ClrbTalentApplyPassives(ID, hero)
    if Timers and ClrbTalentApplyPassives then
        Timers(0.5, function()
            local h = Util and Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID)
            if not h or h:IsNull() then
                h = hero
            end
            if h and not h:IsNull() then
                ClrbTalentApplyPassives(ID, h)
            end
        end)
    end
    Talent:TryApplyPendingEquipAttr(ID)
    Talent:AutoPage(ID)
    Box:InitDummy(ID)
    -- 初始化技能配置
    Skill:LoadHeroSkill(ID)

    hero:AddNewModifier(hero, nil, "modifier_phased", { duration = 0.1 })
    --基础魔抗提升至30
    HeroData:AddSX(ID, "mfkx", 5)
    Box:Show(ID)
    -- item_cost_2：开局放入 16 号中立栏（见 Box:TryPlaceItemCost2InNeutralSlot；此后不得再与 16 号槽换位）
    do
        local item2 = CreateItem("item_cost_2", hero, hero)
        if item2 and not item2:IsNull() then
            hero:AddItem(item2)
            Box:TryPlaceItemCost2InNeutralSlot(hero, item2)
            Box:RefreshNeutralChestItemCharges(ID)
        end
    end
    Timers(0, function()
        if hero:IsNull() then
            return
        end
        hero_ensure_item_run(hero)
        -- 肉搏祝福仅真人挂 modifier_rbzf；人机挂 modifier_rbzf_bot（智力魔抗削弱较轻）
        local ip_rb = InitPlayer:GetPlayerData(ID)
        if ip_rb and ip_rb.bot then
            hero_ensure_modifier_rbzf_bot(hero)
        else
            hero_ensure_modifier_rbzf(hero)
        end
        if ClrbLhzfEnsureOnHero then
            ClrbLhzfEnsureOnHero(ID, hero)
        end
        if ClrbHeroBalanceEnsureOnHero then
            ClrbHeroBalanceEnsureOnHero(ID, hero)
        end
    end)
    Timers(0.12, function()
        if hero:IsNull() then
            return
        end
        hero_ensure_item_run(hero)
    end)
    --添加buff
    Timers(2, function()
        -- 真视（不 CreateItem item_gem，避免部分客户端 item_lua 上 OnChargeCountChanged 参数不匹配报错）
        local item = CreateItem("item_gem", hero, hero)
        local buff_name = "modifier_item_gem_of_true_sight"
        hero:AddNewModifier(hero, item, buff_name, {})
        if Pet and Pet.SyncFromOutBag then
            Pet:SyncFromOutBag(ID)
        end
        if Title and Title.SyncFromOutBag then
            Title:SyncFromOutBag(ID)
        end
        if Effect and Effect.SyncFromOutBag then
            Effect:SyncFromOutBag(ID)
        end
        if AttackEffect and AttackEffect.SyncFromOutBag then
            AttackEffect:SyncFromOutBag(ID)
        end
    end)
    --自动抽奖（与肉搏祝福解耦；无抽奖次数则仅跳过抽奖）
    Timers(15, function()
        if not Box.Data[ID] or Box.Data[ID].box_sy_draw <= 0 then
            return
        end
        Box:AutoDraw(ID)
    end)

    Timers(2, function()
        if hero:IsNull() then
            return
        end
        if hero:GetUnitName() == "npc_dota_hero_gyrocopter" then
            HeroData:SetupGyrocopterSideGunner(hero)
        end
    end)
end

-- 英雄技能列表
function HeroData:IsHeroSkill(hero_name, skill_name)
    for k, v in pairs(SelectHero.HeroList[hero_name].list) do
        if skill_name == v then return true end
    end
end

--- 配置为 agh/魔晶 额外技能、不应在英雄初始化时保留的原生技能
function HeroData:IsHeroBlockedAghSkill(hero_name, skill_name)
    if self:IsGyrocopterSideGunnerAbility(hero_name, skill_name) then
        return false
    end
    local row = SelectHero and SelectHero.HeroList and SelectHero.HeroList[hero_name]
    if not row or not row.agh or not skill_name then
        return false
    end
    if type(row.agh) == "table" then
        for _, v in pairs(row.agh) do
            if v == skill_name then
                return true
            end
        end
        return false
    end
    return row.agh == skill_name
end

--- 主技能的二段/子技能（如 techies_reactive_tazer_stop），不应按魔晶额外技能处理
function HeroData:IsSubAbilityOfHeroListSkill(hero_name, skill_name)
    local row = SelectHero and SelectHero.HeroList and SelectHero.HeroList[hero_name]
    if not row or not row.list or not skill_name then
        return false
    end
    for _, main in pairs(row.list) do
        if skill_name ~= main and string.sub(skill_name, 1, #main) == main then
            return true
        end
    end
    return false
end

--- 是否应隐藏 A 杖/魔晶授予、且非技能书占用的额外技能
function HeroData:ShouldSuppressAghShardSkillDisplay(hero, ID, skill_name)
    if not hero or hero:IsNull() or not skill_name then
        return false
    end
    local hero_name = hero:GetUnitName()
    -- 熊猫酒仙：魔晶会把壮胆酒(liquid_courage)从先天被动解锁成可释放技能，强制保持隐藏
    if hero_name == "npc_dota_hero_brewmaster"
        and skill_name == "brewmaster_liquid_courage" then
        return true
    end
    if self:IsGyrocopterSideGunnerAbility(hero_name, skill_name) then
        return false
    end
    if Skill and Skill.ShouldPreserveAghSkillBookGrant
        and Skill:ShouldPreserveAghSkillBookGrant(hero, ID, skill_name) then
        return false
    end
    if Skill and Skill.IsNullSkill and Skill:IsNullSkill(skill_name) then
        return false
    end
    if Skill and Skill.IsMeleeBrawlSkill and Skill:IsMeleeBrawlSkill(skill_name) then
        return false
    end
    if Skill and Skill.IsSkill and Skill:IsSkill(skill_name) then
        return false
    end
    if skill_name == "ability_bf_1" then
        return false
    end
    if self:IsHeroSkill(hero_name, skill_name) then
        return false
    end
    if self:IsHeroHide(hero_name, skill_name) then
        return false
    end
    if self:IsSubAbilityOfHeroListSkill(hero_name, skill_name) then
        return false
    end
    if string.find(skill_name, "special_bonus", 1, true) then
        return false
    end
    if self:IsHeroBlockedAghSkill(hero_name, skill_name) then
        return true
    end
    if not hero.HasModifier then
        return false
    end
    if not hero:HasModifier("modifier_item_ultimate_scepter")
        and not hero:HasModifier("modifier_item_aghanims_shard") then
        return false
    end
    return true
end

HeroData.GYROCOPTER_SIDE_GUNNER_ABILITY = "gyrocopter_side_gunner_spawn_ability"

function HeroData:IsGyrocopterSideGunnerAbility(hero_name, skill_name)
    return hero_name == "npc_dota_hero_gyrocopter"
        and skill_name == self.GYROCOPTER_SIDE_GUNNER_ABILITY
end

function HeroData:GyrocopterHasScepter(hero)
    if not hero or hero:IsNull() then
        return false
    end
    -- 引擎统一判定（含消耗品/魔晶祝福等）
    if hero.HasScepter and hero:HasScepter() then
        return true
    end
    -- 身上已生效的 A 杖 modifier（储藏格 A 杖会被 ClrbFixBackpack 剥掉）
    if hero.HasModifier and hero:HasModifier("modifier_item_ultimate_scepter") then
        return true
    end
    -- 主栏/中立栏已有 A 杖、但 modifier 尚未挂上的短暂窗口（避免被误打成 0 级）
    local scepter_items = {
        item_ultimate_scepter = true,
        item_ultimate_scepter_2 = true,
        item_ultimate_scepter_roshan = true,
    }
    if hero.GetItemInSlot then
        for _, slot in ipairs({ 0, 1, 2, 3, 4, 5, 16 }) do
            local it = hero:GetItemInSlot(slot)
            if it and not it:IsNull() then
                local nm = it.GetName and it:GetName()
                if nm and scepter_items[nm] then
                    return true
                end
            end
        end
    end
    return false
end

HeroData._gyro_side_gunner_rebuild_at = HeroData._gyro_side_gunner_rebuild_at or {}

function HeroData:_GyrocopterSideGunnerKey(hero)
    if not hero or hero:IsNull() then
        return nil
    end
    if hero.GetPlayerOwnerID then
        local pid = hero:GetPlayerOwnerID()
        if pid ~= nil and pid >= 0 then
            return "p" .. tostring(pid)
        end
    end
    if hero.GetEntityIndex then
        return "e" .. tostring(hero:GetEntityIndex())
    end
    return tostring(hero)
end

--- 遍历该英雄所属的侧翼机关枪单位
function HeroData:ForEachGyrocopterSideGunnerUnit(hero, fn)
    if not hero or hero:IsNull() or type(fn) ~= "function" then
        return
    end
    local pid = hero.GetPlayerOwnerID and hero:GetPlayerOwnerID()
    local seen = {}
    local function consider(u)
        if not u or u:IsNull() or seen[u] then
            return
        end
        if not (u.GetUnitName and u:GetUnitName() == "npc_dota_side_gunner") then
            return
        end
        local same_owner = false
        if u.GetOwnerEntity and u:GetOwnerEntity() == hero then
            same_owner = true
        elseif u.GetOwner and u:GetOwner() == hero then
            same_owner = true
        elseif pid ~= nil and u.GetPlayerOwnerID and u:GetPlayerOwnerID() == pid then
            same_owner = true
        end
        if same_owner then
            seen[u] = true
            fn(u)
        end
    end
    if Entities and Entities.FindAllByName then
        local by_name = Entities:FindAllByName("npc_dota_side_gunner")
        if by_name then
            for _, u in pairs(by_name) do
                consider(u)
            end
        end
    end
    if Entities and Entities.FindAllByClassname then
        local by_cls = Entities:FindAllByClassname("npc_dota_side_gunner")
        if by_cls then
            for _, u in pairs(by_cls) do
                consider(u)
            end
        end
    end
end

function HeroData:HasLivingGyrocopterSideGunner(hero)
    local alive = false
    self:ForEachGyrocopterSideGunnerUnit(hero, function(u)
        if u.IsAlive and u:IsAlive() then
            alive = true
        end
    end)
    return alive
end

--- 清理玩家名下残留的侧翼机关枪单位（死后/重建前）
function HeroData:CleanupGyrocopterSideGunnerUnits(hero)
    if not hero or hero:IsNull() then
        return
    end
    self:ForEachGyrocopterSideGunnerUnit(hero, function(u)
        if u.ForceKill then
            u:ForceKill(false)
        elseif UTIL_Remove then
            UTIL_Remove(u)
        end
    end)
end

--- 侧翼机关枪：始终隐藏；无 A 杖 0 级，有 A 杖 1 级（效果由引擎被动驱动）
--- force=true：仅在「等级对但单位丢失」时允许 0→1 重建；已有存活单位时绝不拆掉
function HeroData:ApplyGyrocopterSideGunnerPassiveState(hero, force)
    if not hero or hero:IsNull() or hero:GetUnitName() ~= "npc_dota_hero_gyrocopter" then
        return
    end
    local ab_name = self.GYROCOPTER_SIDE_GUNNER_ABILITY
    local ab = hero:FindAbilityByName(ab_name)
    if not ab or ab:IsNull() then
        ab = hero:AddAbility(ab_name)
    end
    if not ab or ab:IsNull() then
        return
    end
    if not ab:IsHidden() then
        ab:SetHidden(true)
    end

    local key = self:_GyrocopterSideGunnerKey(hero)
    local now = (GameRules and GameRules.GetGameTime and GameRules:GetGameTime()) or 0

    -- 死亡期间必须把技能打回 0，否则复活后 GetLevel==1 不会重建，小飞机只显示不打怪
    if not hero:IsAlive() then
        if ab:GetLevel() > 0 then
            ab:SetLevel(0)
        end
        self:CleanupGyrocopterSideGunnerUnits(hero)
        if key then
            self._gyro_side_gunner_rebuild_at[key] = 0
        end
        return
    end

    local want = self:GyrocopterHasScepter(hero) and 1 or 0
    if want == 0 then
        if ab:GetLevel() > 0 then
            ab:SetLevel(0)
        end
        self:CleanupGyrocopterSideGunnerUnits(hero)
        return
    end

    -- want == 1
    local alive = self:HasLivingGyrocopterSideGunner(hero)
    if ab:GetLevel() == 1 and alive then
        -- 已正常：多次 ForceRefresh / 定时器都不要再 0→1 拆掉
        return
    end

    if ab:GetLevel() ~= 1 then
        -- 首次启用：只升级，让引擎生成；不要先 Cleanup（会杀掉正在生成的单位）
        ab:SetLevel(1)
        if key then
            self._gyro_side_gunner_rebuild_at[key] = now
        end
        return
    end

    -- 等级已是 1，但没有存活单位：可能仍在生成中，或卡在坏状态
    local last = (key and self._gyro_side_gunner_rebuild_at[key]) or 0
    if (now - last) < 1.0 then
        -- 刚升过级，给引擎一点时间生成小飞机，避免 0.03/0.2s 的重复 ForceRefresh 杀掉
        return
    end

    -- 卡住超过 1 秒：0→1 重建
    ab:SetLevel(0)
    self:CleanupGyrocopterSideGunnerUnits(hero)
    ab:SetLevel(1)
    if key then
        self._gyro_side_gunner_rebuild_at[key] = now
    end
end

function HeroData:EnsureGyrocopterSideGunnerModifier(hero)
    if not hero or hero:IsNull() or hero:GetUnitName() ~= "npc_dota_hero_gyrocopter" then
        return
    end
    LinkLuaModifier("modifier_side_gunner", "ingame/modifier/modifier_side_gunner", LUA_MODIFIER_MOTION_NONE)
    if not hero:HasModifier("modifier_side_gunner") then
        hero:AddNewModifier(hero, nil, "modifier_side_gunner", {})
    end
end

--- 复活 / 获得 A 杖后尝试启用侧翼机关枪（有存活单位则不拆）
function HeroData:ForceRefreshGyrocopterSideGunner(hero)
    if not hero or hero:IsNull() or hero:GetUnitName() ~= "npc_dota_hero_gyrocopter" then
        return
    end
    self:EnsureGyrocopterSideGunnerModifier(hero)
    self:ApplyGyrocopterSideGunnerPassiveState(hero, true)
end

function HeroData:SetupGyrocopterSideGunner(hero)
    self:EnsureGyrocopterSideGunnerModifier(hero)
    self:ApplyGyrocopterSideGunnerPassiveState(hero, false)
end

-- 隐藏技能列表
function HeroData:IsHeroHide(hero_name, skill_name)
    -- print(hero_name)
    -- print(skill_name)
    if SelectHero.HeroList[hero_name].hide == nil then return end
    local num = Util:TabCount(SelectHero.HeroList[hero_name].hide)
    -- print(num)
    if num > 0 then
        for k, v in pairs(SelectHero.HeroList[hero_name].hide) do
            if skill_name == v then return true end
        end
    end
end

--- 英雄初始化时剥离的原生技能（不在 list 中、也不保留）
function HeroData:IsHeroStripSkill(hero_name, skill_name)
    local row = SelectHero and SelectHero.HeroList and SelectHero.HeroList[hero_name]
    if not row or not row.strip or not skill_name then
        return false
    end
    for _, v in pairs(row.strip) do
        if skill_name == v then
            return true
        end
    end
    return false
end

--- 最后一击来自召唤物/守卫等时，折到其玩家对应的英雄（如巫医死亡守卫），以便击杀统计与 IncrementKills 与真人英雄一致。
function HeroData:ResolveKillCreditHero(attacker)
    if not attacker or attacker:IsNull() then
        return
    end
    if attacker:IsHero() then
        return attacker
    end
    if attacker.GetPlayerOwnerID then
        local pid = attacker:GetPlayerOwnerID()
        if type(pid) == "number" and pid >= 0 and PlayerResource then
            local pl = PlayerResource:GetPlayer(pid)
            if pl and pl.GetAssignedHero then
                local h = pl:GetAssignedHero()
                if h and not h:IsNull() and h:IsHero() then
                    return h
                end
            end
        end
    end
    if attacker.GetOwnerEntity then
        local o = attacker:GetOwnerEntity()
        if o and not o:IsNull() and o:IsHero() then
            return o
        end
        if o and not o:IsNull() and o.GetAssignedHero then
            local h = o:GetAssignedHero()
            if h and not h:IsNull() and h:IsHero() then
                return h
            end
        end
    end
end

-- 英雄死亡
function HeroData:HeroDeath(hero, attacker)
    if not hero or not attacker then return end
    local killer_hero = self:ResolveKillCreditHero(attacker)
    if killer_hero then
        attacker = killer_hero
    end
    local death_pos_for_reborn = hero:GetAbsOrigin()
    local atk_id = Util:Hero2ID(attacker)
    if attacker:IsHero() then
        local tx1 =
        "particles/econ/items/spectre/spectre_arcana/spectre_arcana_minigame_v2_death_target.vpcf"
        local particle = ParticleManager:CreateParticle(tx1,
            PATTACH_OVERHEAD_FOLLOW,
            hero)
        ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, hero:GetAbsOrigin())
        Timers(2, function()
            ParticleManager:DestroyParticle(particle, true)
            ParticleManager:ReleaseParticleIndex(particle)
        end)
        if hero ~= attacker then
            HeroData.Data[atk_id].kill = HeroData.Data[atk_id].kill + 1
            HeroData.Data[atk_id].kills_num =
                HeroData.Data[atk_id].kills_num + 1
            if AchieveStat and AchieveStat.OnHeroKill and atk_id then
                AchieveStat:OnHeroKill(atk_id)
            end
            -- 真人击杀 AI：补 IncrementKills 同步 PlayerResource；队伍人头仍由 Stat:TeamKill 每杀 +1。
            local vic_id = Util:Hero2ID(hero)
            if atk_id and vic_id then
                local vic_init = InitPlayer:GetPlayerData(vic_id)
                local atk_init = InitPlayer:GetPlayerData(atk_id)
                if vic_init and vic_init.bot and atk_init and not atk_init.bot then
                    attacker:IncrementKills(atk_id)
                end
            end
            local atk_init_data = atk_id and InitPlayer:GetPlayerData(atk_id)
            if atk_init_data and atk_init_data.bot then
                HeroData:AddGold(atk_id, 1000)
            end
            -- 每 12 杀送抽：按 HeroData.kill（与计分一致）
            local hk = atk_id and HeroData.Data[atk_id] and HeroData.Data[atk_id].kill or 0
            if hk > 0 and hk % 12 == 0 then
                local g_min = MainGame:GetTimeMin()
                if g_min < 18 then
                    if not HeroData.Data[atk_id].box_draw_kill_pre18_done then
                        HeroData.Data[atk_id].box_draw_kill_pre18_done = true
                        if Box:CanAddDrawCharge(atk_id) then
                            Box:AddDraw(atk_id)
                        end
                    end
                else
                    if Box:CanAddDrawCharge(atk_id) then
                        Box:AddDraw(atk_id)
                    end
                end
            end
        end

        if HeroData.Data[atk_id].kill >= 30 then
            HeroData.Data[atk_id].tag.tag5 = true
        end
        local num = PlayerResource:GetStreak(atk_id)
        if num >= 10 then HeroData.Data[atk_id].tag.tag2 = true end
        local r_time = HeroData.Data[atk_id].kills_time
        if r_time == 0 then
            HeroData.Data[atk_id].kills_time = 20
            Timers(0, function()
                HeroData.Data[atk_id].kills_time =
                    HeroData.Data[atk_id].kills_time - 1
                if HeroData.Data[atk_id].kills_time <= 0 then
                    HeroData.Data[atk_id].kills_num = 0
                    return
                end
                return 1
            end)
        else
            HeroData.Data[atk_id].kills_time = 20
        end
        local kills_num = HeroData.Data[atk_id].kills_num
        if kills_num >= 5 then HeroData.Data[atk_id].tag.tag3 = true end
    end
    if not hero then return end
    local ID = Util:Hero2ID(hero)
    local init_data = InitPlayer:GetPlayerData(ID)
    local is_bot = init_data and init_data.bot or false
    if ID then
        HeroData:TryApplyOfflinePetbuff(ID)
    end
    if attacker:IsHero() then
        if attacker ~= hero then MainGame:HeroKillAdd(attacker) end
    end
    if not is_bot then
        local add_attr = 1
        local rbzf = hero:FindModifierByName("modifier_rbzf")
        if rbzf then
            local rbzf_stack = rbzf:GetStackCount()
            if rbzf_stack < 10 and MainGame:GetTimeMin() <= 10 then
                self:QueueRbzfDeathBonusAllStatsGreen(ID, add_attr)
                Util:BottomMsg2ID(ID, "死亡获得额外全属性+1", "yellow", 2)
                rbzf:IncrementStackCount()
            elseif MainGame:GetTimeMin() > 10 then
                self:QueueRbzfDeathBonusAllStatsGreen(ID, add_attr)
                Util:BottomMsg2ID(ID, "死亡获得额外全属性+1", "yellow", 2)
                rbzf:IncrementStackCount()
            end
        end
    end
    if is_bot and BotAI and BotAI.HandleDeathAllAttributes then
        BotAI:HandleDeathAllAttributes(hero)
    end

    -- 复活时间
    local reborn_time = self:GetRebornTime(hero)
    local list = { page = true, time = reborn_time }
    if not is_bot then
        Util:Send2JsID("UI_Reborn", list, ID)
    end
    -- 排名与顶部统计在 Stat:TeamKill 内处理（避免同一次死亡重复 UpDataRank）
    Stat:TeamKill(ID, atk_id, reborn_time)
    if hero:HasModifier("modifier_talent_skill_7") then
        if hero.modifier_talent_skill_7_state == true then
            HeroData:AddSX(ID, "gjsd", -60)
            HeroData:AddSX(ID, "ztkx", -30)
            HeroData:AddSX(ID, "jcys", -30)
            hero.modifier_talent_skill_7_state = false
        end
    end
    Timers(reborn_time, function()
        local hero = ID and Util:ID2Hero(ID)
        if not hero or hero:IsNull() then
            hero = ID and HeroData:GetHero(ID)
        end
        if not hero or hero:IsNull() then
            return
        end
        hero:RespawnUnit()
        -- 死亡时选的先天装备：尸体上 modifier 挂不上，复活后补属性与 buff
        if Talent then
            Talent:TryApplyPendingEquipAttr(ID)
            Talent:EnsureTalentEquipModifier(ID)
        end
        if is_bot then
            -- 人机：单独一套逻辑，仅从 Config Rebron1/Rebron2 表随机落点（见 Get.lua BotOnly_RespawnTeleportFromTable），不走真人 HeroPos/ApplyRebornClearPos
            self:BotOnly_RespawnTeleportFromTable(ID)
        else
            self:ApplyRebornClearPos(hero, death_pos_for_reborn)
        end
        -- 复活无敌：仅真人；缩圈前(state<2) modifier_wudi duration=1；缩圈后 duration=0.2。人机无任何无敌 modifier。
        -- _clrb_respawn_wudi_break：下单/背包等可通过 Util:TryClearRespawnProtectionWudi 提前结束无敌。
        if not is_bot then
            local mg_state = MainGame and MainGame.GetState and MainGame:GetState() or 1
            hero._clrb_respawn_wudi_break = true
            if mg_state < 2 then
                hero:AddNewModifier(hero, nil, "modifier_wudi", { duration = 1 })
            else
                hero:AddNewModifier(hero, nil, "modifier_wudi", { duration = 0.2 })
            end
        else
            hero._clrb_respawn_wudi_break = nil
        end
        if ID then
            HeroData:TryApplyOfflinePetbuff(ID)
            HeroData:RefreshGoods25Modifier(ID)
        end
        if Pet and Pet.SyncFromOutBag then
            Pet:SyncFromOutBag(ID)
        end
        if Title and Title.SyncFromOutBag then
            Title:SyncFromOutBag(ID)
        end
        if Effect and Effect.SyncFromOutBag then
            Effect:SyncFromOutBag(ID)
        end
        if AttackEffect and AttackEffect.SyncFromOutBag then
            AttackEffect:SyncFromOutBag(ID)
        end
        if ClrbFlyCloudScheduleSync then
            require("ingame.modifier.clrb_fly_cloud_util")
            ClrbFlyCloudScheduleSync(hero)
        end
        if is_bot then
            hero_ensure_modifier_rbzf_bot(hero)
        else
            hero_ensure_modifier_rbzf(hero)
        end
        if ClrbLhzfEnsureOnHero then
            ClrbLhzfEnsureOnHero(ID, hero)
        end
        if ClrbHeroBalanceEnsureOnHero then
            ClrbHeroBalanceEnsureOnHero(ID, hero)
        end
        self:ApplyPendingRbzfDeathBonusAllStatsGreen(ID, hero)
        if utilex and utilex.BaseSmjc then
            utilex:BaseSmjc(ID)
        end
        local phased_dur = 0.1
        if is_bot then
            phased_dur = (BotAI and BotAI.Config and tonumber(BotAI.Config.bot_respawn_phased_seconds)) or 3
        end
        hero:AddNewModifier(hero, nil, "modifier_phased", { duration = phased_dur })
        if Util and Util.ClrbFixBackpackPassivesAfterInventoryResync then
            Util:ClrbFixBackpackPassivesAfterInventoryResync(hero)
            Timers(0.06, function()
                local hinv = ID and Util:ID2Hero(ID)
                if hinv and not hinv:IsNull() then
                    Util:ClrbFixBackpackPassivesAfterInventoryResync(hinv)
                    if Box and Box.ScheduleEnsureItemCost2InNeutralSlot then
                        Box:ScheduleEnsureItemCost2InNeutralSlot(hinv)
                    end
                    if hinv:GetUnitName() == "npc_dota_hero_gyrocopter"
                        and HeroData and HeroData.ForceRefreshGyrocopterSideGunner then
                        HeroData:ForceRefreshGyrocopterSideGunner(hinv)
                    end
                end
                return nil
            end)
        end
        if hero:GetUnitName() == "npc_dota_hero_gyrocopter"
            and HeroData and HeroData.ForceRefreshGyrocopterSideGunner then
            -- 立即 + 延迟再刷一次，避免与背包 A 杖剥离竞态后仍卡在坏状态
            HeroData:ForceRefreshGyrocopterSideGunner(hero)
            Timers(0.2, function()
                local h2 = ID and Util:ID2Hero(ID)
                if h2 and not h2:IsNull() and h2:GetUnitName() == "npc_dota_hero_gyrocopter" then
                    HeroData:ForceRefreshGyrocopterSideGunner(h2)
                end
                return nil
            end)
        end
        if hero:HasModifier("modifier_talent_skill_7") then
            hero.modifier_talent_skill_7_state = true
            HeroData:AddSX(ID, "gjsd", 60)
            HeroData:AddSX(ID, "ztkx", 30)
            HeroData:AddSX(ID, "jcys", 30)
            local talent_skill_7_time_num = 15
            Timers(0, function()
                talent_skill_7_time_num = talent_skill_7_time_num - 1
                local th = ID and Util:ID2Hero(ID)
                if not th or th:IsNull() then
                    return
                end
                if th.modifier_talent_skill_7_state == false then
                    return
                end
                if talent_skill_7_time_num <= 0 then
                    if th.modifier_talent_skill_7_state == true then
                        HeroData:AddSX(ID, "gjsd", -60)
                        HeroData:AddSX(ID, "ztkx", -30)
                        HeroData:AddSX(ID, "jcys", -30)
                        th.modifier_talent_skill_7_state = false
                    end
                    return
                end
                return 1
            end)
        end
        if is_bot then
            Timers(0.3, function()
                local bh = ID and Util:ID2Hero(ID)
                if bh and not bh:IsNull() then
                    BotAI:Attach(ID, bh)
                end
            end)
        end
        if ID and not is_bot then
            PlayerResource:SetCameraTarget(ID, hero)
        end
        utilex:Particles7(hero:GetAbsOrigin())
        Timers(1, function()
            if ID and not is_bot then
                PlayerResource:SetCameraTarget(ID, nil)
                local list2 = { page = false, time = -1 }
                Util:Send2JsID("UI_Reborn", list2, ID)
            end
        end)
    end)
    self.Data[ID].death_num = self.Data[ID].death_num + 1
    if not is_bot then
        if self.Data[ID].death_num % 3 == 0 then
            if self.Data[ID].death_num <= 15 then
                local item_name = "item_goods_14"
                if Item:IsHaveItem(ID, item_name) then
                    local bag_item = Item:FindItem(ID, item_name)
                    if bag_item then
                        bag_item:SetCurrentCharges(bag_item:GetCurrentCharges() + 1)
                    end
                else
                    Item:AddItem(ID, item_name)
                end
            end
        end
        -- if self.Data[ID].death_num == 3 then
        --     Box:AddDraw(ID)
        -- end
        local death_num = self.Data[ID].death_num
        local add_box_num = 4
        if MainGame:GetTime() >= MainGame.EventList.map1.time then
            add_box_num = 6
        end
        -- 死亡满 4/6 次送抽；<10 分全档最多 1 次；10–18 分（与击杀 pre18 一致，g_min<18）全档该来源最多 1 次；≥18 分每次满足都送
        if death_num % add_box_num == 0 then
            local g_min = MainGame:GetTimeMin()
            if g_min < 10 then
                if not self.Data[ID].box_draw_death_pre10_done then
                    self.Data[ID].box_draw_death_pre10_done = true
                    if Box:CanAddDrawCharge(ID) then
                        Box:AddDraw(ID)
                    end
                end
            elseif g_min < 18 then
                if not self.Data[ID].box_draw_death_10to18_done then
                    self.Data[ID].box_draw_death_10to18_done = true
                    if Box:CanAddDrawCharge(ID) then
                        Box:AddDraw(ID)
                    end
                end
            else
                if Box:CanAddDrawCharge(ID) then
                    Box:AddDraw(ID)
                end
            end
        end
    end
end

-- 随机星星
function HeroData:RollStar(ID)
    if not ID then return end
    local cost = self.Static.roll_star_price
    local limit_star = self.Static.star_limit
    local high_threshold = self.Static.star_roll_high_threshold or 13
    local high_chance = tonumber(self.Static.star_roll_high_chance_pct) or 10
    if PlayerResource:GetGold(ID) < cost then
        return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
    end
    PlayerResource:SpendGold(ID, cost, 0)

    -- 满星后仍可随机，仅刷新成长属性
    if self.Data[ID].star >= limit_star then
        self:RollGain(ID)
        self:SendData(ID)
        return
    end

    -- 显示 16 星（真实 13）后：250 随机仅 10% 概率 +1 星
    if self.Data[ID].star >= high_threshold then
        if math.random(1, 100) <= high_chance then
            self.Data[ID].star = self.Data[ID].star + 1
            self.Data[ID].base_star = self.Data[ID].star
            if self.Data[ID].star >= limit_star then
                self.Data[ID].base_star = limit_star
            end
            self:NotifyStarIncreased(ID)
            MainGame:IsStar16(ID, self.Data[ID].star)
            if OverStat and OverStat.OnStarUpdate then
                OverStat:OnStarUpdate(ID, self.Data[ID].star)
            end
        end
        self:RollGain(ID)
        self:SendData(ID)
        return
    end

    local base_star = self.Data[ID].base_star
    local min = HeroData.Data[ID].roll_star.min
    local max = HeroData.Data[ID].roll_star.max
    if self.Data[ID].first_roll == true then
        min = 1
        self.Data[ID].first_roll = false
    end
    local old_star = self.Data[ID].star
    local roll_star = math.random(min, max) + base_star
    if roll_star > limit_star then roll_star = limit_star end
    self.Data[ID].star = roll_star
    if roll_star > old_star then
        self:NotifyStarIncreased(ID)
    end
    if self.Data[ID].star >= limit_star then
        self.Data[ID].base_star = limit_star
    end
    MainGame:IsStar16(ID, self.Data[ID].star)
    if OverStat and OverStat.OnStarUpdate then
        OverStat:OnStarUpdate(ID, self.Data[ID].star)
    end
    self:RollGain(ID)
    self.Data[ID].cost_star = self.Data[ID].cost_star + cost
    if self.Data[ID].cost_star >= self.Static.roll_cost then
        self.Data[ID].base_star = self.Data[ID].base_star + 1
        self.Data[ID].cost_star = self.Data[ID].cost_star -
            self.Static.roll_cost
    end
    self:SendData(ID)
end

function HeroData:NotifyStarIncreased(ID)
    if not ID or not utilex or not utilex.Sound then
        return
    end
    utilex:Sound(ID, "level_up")
end

--- 固定升星：+1 星并按 1500 购买规则固定提升三围成长（BaseGain，不随机）
function HeroData:ApplyFixedStarUpgrade(ID)
    if not ID or not self.Data[ID] then
        return
    end
    local limit_star = self.Static.star_limit
    self.Data[ID].base_star = self.Data[ID].base_star + 1
    self.Data[ID].star = self.Data[ID].star + 1
    if self.Data[ID].star >= limit_star then
        self.Data[ID].base_star = limit_star
    end
    MainGame:IsStar16(ID, self.Data[ID].star)
    if OverStat and OverStat.OnStarUpdate then
        OverStat:OnStarUpdate(ID, self.Data[ID].star)
    end
    self:NotifyStarIncreased(ID)
    self:BaseGain(ID)
    self:SendData(ID)
end

-- 升星
function HeroData:LevelStar(ID)
    if not ID then return end
    local limit_star = self.Static.star_limit
    local purchase_cap = self.Static.star_purchase_cap or 13
    if self.Data[ID].star >= limit_star then
        return Util:BottomMsg2ID(ID, "星星数量已达到最大", "yellow", 1)
    end
    if self.Data[ID].star >= purchase_cap then
        return Util:BottomMsg2ID(ID, "16星后仅能通过随机升星继续提升", "yellow", 1)
    end
    local cost = self.Static.level_up_price
    if PlayerResource:GetGold(ID) < cost then
        return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
    end
    PlayerResource:SpendGold(ID, cost, 0)
    self:ApplyFixedStarUpgrade(ID)
end

--- 陨落星辰（item_goods_23）：星级未满时 +1 星，效果同 1500 固定升星（不受 16 星购买上限限制）
function HeroData:TryAddStarFromItem(ID)
    if not ID or not self.Data[ID] then
        return false
    end
    if self.Data[ID].star >= self.Static.star_limit then
        Util:BottomMsg2ID(ID, "星星数量已达到最大", "yellow", 1)
        return false
    end
    self:ApplyFixedStarUpgrade(ID)
    return true
end

--- 雷纹结晶（item_goods_25）：每次 +15 魔法攻击、+200 生命；累计 5/10 次里程碑奖励
function HeroData:ApplyGoods25Consume(ID, hero)
    if not ID or not self.Data[ID] then
        return false
    end
    self:AddSX(ID, "mfgj", 15)
    self:AddSX(ID, "smjc", 200)

    local cur = (self.Data[ID].goods_25_applies or 0) + 1
    self.Data[ID].goods_25_applies = cur

    if cur >= 5 and not self.Data[ID].goods_25_milestone_5 then
        self.Data[ID].goods_25_milestone_5 = true
        self:AddSX(ID, "jcll", 15)
        self:AddSX(ID, "jcmj", 15)
        self:AddSX(ID, "jczl", 15)
    end

    if cur >= 10 and not self.Data[ID].goods_25_milestone_10 then
        self.Data[ID].goods_25_milestone_10 = true
        self:AddSX(ID, "jnzq", 15)
        self:AddSX(ID, "gjjc", 20)
    end

    self:RefreshGoods25Modifier(ID, hero)
    return true
end

--- 雷纹结晶：状态栏 modifier（层数 = 累计食用次数）
function HeroData:RefreshGoods25Modifier(ID, hero_opt)
    if not ID or not self.Data[ID] then
        return
    end
    local hero = hero_opt
    if not hero or hero:IsNull() then
        hero = Util:ID2Hero(ID)
    end
    if not hero or hero:IsNull() then
        return
    end
    local n = tonumber(self.Data[ID].goods_25_applies) or 0
    local buff_name = "modifier_goods_25"
    if n <= 0 then
        if hero:HasModifier(buff_name) then
            hero:RemoveModifierByName(buff_name)
        end
        return
    end
    if hero:HasModifier(buff_name) then
        local mod = hero:FindModifierByName(buff_name)
        if mod then
            mod:SetStackCount(n)
            if mod.SendBuffRefreshToClients then
                mod:SendBuffRefreshToClients()
            end
            mod:ForceRefresh()
        end
        return
    end
    hero:AddNewModifier(hero, nil, buff_name, { player_id = ID, stack_count = n })
end

--- 生命之书（item_goods_21 / 便捷商店 life_book）：本局生效次数上限，每次 +1000 smjc
function HeroData:TryApplyLifeBookSmjc(ID)
    if not ID or not self.Data[ID] then
        return false
    end
    local maxN = 30
    if EazyShop and EazyShop.Static and EazyShop.Static.LifeBookMaxAppliesPerGame then
        maxN = tonumber(EazyShop.Static.LifeBookMaxAppliesPerGame) or maxN
    end
    local cur = self.Data[ID].life_book_applies or 0
    if maxN > 0 and cur >= maxN then
        return false
    end
    self.Data[ID].life_book_applies = cur + 1
    self:AddSX(ID, "smjc", 1000)
    return true
end

-- 英雄添加属性
function HeroData:AddSX(ID, name, value)
    if not ID or not name then
        return
    end
    if not self.Data or not self.Data[ID] or not self.Data[ID].hero_attr then
        return
    end
    if self.Data[ID].hero_attr[name] == nil then
        return
    end
    if type(value) ~= "number" then
        return
    end

    local hero = Util:ID2Hero(ID)
    if name == "jcll" then
        if hero and not hero:IsNull() then
            hero:ModifyStrength(value)
        end
        return
    end
    if name == "jcmj" then
        if hero and not hero:IsNull() then
            hero:ModifyAgility(value)
        end
        return
    end
    if name == "jczl" then
        if hero and not hero:IsNull() then
            hero:ModifyIntellect(value)
        end
        return
    end

    self.Data[ID].hero_attr[name] = self.Data[ID].hero_attr[name] + value
    if name == "jcgj" then utilex:BaseGjl(ID) end
    if name == "lqjs" then Talent:RefreshBuff(ID) end
    if name == "smjc" then
        utilex:BaseSmjc(ID)
        if hero and not hero:IsNull() then
            local smzf_mod = hero:FindModifierByName("modifier_smzf")
            if smzf_mod then
                smzf_mod:ForceRefresh()
            end
            hero:CalculateStatBonus(true)
        end
    end
    if name == "ztkx" then utilex:BaseZtkx(ID) end
    if name == "wlkx" then utilex:BaseHj(ID) end
    if name == "mfkx" then utilex:BaseMfkx(ID) end
    if name == "jcys" then utilex:BaseYs(ID) end
    if name == "smhf" then utilex:BaseSmhf(ID) end
    if name == "jnzq" then utilex:BaseJnzq(ID) end
    if name == "gjsd" then utilex:BaseGjsd(ID) end
    if name == "gjjl" then utilex:BaseGjjl(ID) end
    if name == "zyfw" then utilex:BaseZyfw(ID) end
    if name == "gjjg" then
        if hero and not hero:IsNull() then
            local gjjg = hero:GetBaseAttackTime() - value
            self.Data[ID].hero_attr.gjjg = gjjg
        end
    end
    if name == "gjjc" then utilex:BaseGjjc(ID) end
    if name == "smzf" then utilex:BaseSmzf(ID) end

    local heroRefresh = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or hero
    if not heroRefresh then return end
    if heroRefresh:IsNull() then return end
    self:RefreshModifier(heroRefresh)
end

-- 刷新BUFF
function HeroData:RefreshModifier(hero)
    local modifier = hero:FindModifierByName("modifier_attr_buff")
    if modifier then modifier:ForceRefresh() end
end

function HeroData:AttrChange(ID, index)
    if not ID or not index then return end
    index = tonumber(index) or index
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    local ll = hero:GetBaseStrength()
    local mj = hero:GetBaseAgility()
    local zl = hero:GetBaseIntellect()
    local cost = 0
    if index == 1 then
        if ll <= 10 then
            return Util:BottomMsg2ID(ID, "力量不足", "red")
        end
        cost = 100
        if PlayerResource:GetGold(ID) < cost then
            return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
        end
        hero:ModifyStrength(-10)
        hero:ModifyAgility(10)
    end
    if index == 2 then
        if ll <= 10 then
            return Util:BottomMsg2ID(ID, "力量不足", "red")
        end
        cost = 100
        if PlayerResource:GetGold(ID) < cost then
            return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
        end
        hero:ModifyStrength(-10)
        hero:ModifyIntellect(10)
    end
    if index == 3 then
        if mj <= 10 then
            return Util:BottomMsg2ID(ID, "敏捷不足", "red")
        end
        cost = 100
        if PlayerResource:GetGold(ID) < cost then
            return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
        end
        hero:ModifyStrength(10)
        hero:ModifyAgility(-10)
    end
    if index == 4 then
        if mj <= 10 then
            return Util:BottomMsg2ID(ID, "敏捷不足", "red")
        end
        cost = 100
        if PlayerResource:GetGold(ID) < cost then
            return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
        end
        hero:ModifyAgility(-10)
        hero:ModifyIntellect(10)
    end
    if index == 5 then
        if zl <= 10 then
            return Util:BottomMsg2ID(ID, "智力不足", "red")
        end
        cost = 100
        if PlayerResource:GetGold(ID) < cost then
            return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
        end
        hero:ModifyStrength(10)
        hero:ModifyIntellect(-10)
    end
    if index == 6 then
        if zl <= 10 then
            return Util:BottomMsg2ID(ID, "智力不足", "red")
        end
        cost = 100
        if PlayerResource:GetGold(ID) < cost then
            return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
        end
        hero:ModifyAgility(10)
        hero:ModifyIntellect(-10)
    end
    if index == 7 then
        cost = 500
        if PlayerResource:GetGold(ID) < cost then
            return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
        end
        if not Skill:OpenDelSkill(ID) then
            return
        end
    end
    if index == 8 then
        cost = 350
        if PlayerResource:GetGold(ID) < cost then
            return Util:BottomMsg2ID(ID, "金币不足", "red", 1)
        end
        local point = hero:GetAbilityPoints()
        local add_point = point + 1
        hero:SetAbilityPoints(add_point)
    end
    -- 消耗金币
    PlayerResource:SpendGold(ID, cost, 0)
end
