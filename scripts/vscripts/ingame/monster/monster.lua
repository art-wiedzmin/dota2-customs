--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Monster == nil then
    Monster = class({})
    require("ingame.Monster.Config")
    require("ingame.Monster.Set")
    require("ingame.Monster.Get")
    require("ingame.Monster.Func")
    require("ingame.Monster.Ui")
    require("ingame.Monster.ability_m_1_6_flux")
end

function Monster:ReadyPos()
    local all_pos = Entities:FindAllByClassname("info_target")
    local num = 0
    for k, v in pairs(all_pos) do
        if v and v:GetName() == "random_point" then
            num = num + 1
            local pos_key = "pos" .. num
            self.Pos[pos_key] = v:GetAbsOrigin()
        end
    end
    self.Data.pos_num = num
    self.Data.pos_index = 1
end

-- 缩圈后只保留圈内的出生点，避免怪刷在毒圈外
function Monster:RefreshPosForRing(radius)
    if not radius or radius <= 0 then return end
    local center = self.Static.map_center
    local new_pos = {}
    local num = 0
    for i = 1, self.Data.pos_num do
        local p = self.Pos["pos" .. i]
        if p and (p - center):Length2D() <= radius then
            num = num + 1
            new_pos["pos" .. num] = p
        end
    end
    self.Pos = new_pos
    self.Data.pos_num = num
    self.Data.pos_index = 1
end

function Monster:Create()
    -- 每间隔一段时间生成一波怪
    Timers(2, function()
        self:SpawnNormal()
        -- return self.Data.spawn_time
    end)
    self:CreateLightningBelieverLoop()
end

function Monster:GetPoisonRingRadius()
    if not MainGame or not MainGame.GetState then
        return nil
    end
    local st = MainGame:GetState()
    if st == 1 then
        return nil
    end
    if st == 2 then
        return MainGame.Static.rang1
    end
    return MainGame.Static.rang2
end

function Monster:IsInsidePoisonRing(pos)
    if not pos then
        return false
    end
    local radius = self:GetPoisonRingRadius()
    if not radius then
        return true
    end
    local center = self.Static.map_center
    return (pos - center):Length2D() <= radius
end

function Monster:PlayLightningBelieverSpawnFx(pos, sound_unit)
    if not pos then
        return
    end
    local cfg = self.LightningBeliever
    local sky = pos + Vector(0, 0, 1000)
    local bolt = cfg.spawn_pfx_bolt
    if bolt then
        local fx1 = ParticleManager:CreateParticle(bolt, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(fx1, 0, pos)
        ParticleManager:SetParticleControl(fx1, 1, sky)
        Timers(2, function()
            if fx1 then
                ParticleManager:DestroyParticle(fx1, false)
                ParticleManager:ReleaseParticleIndex(fx1)
            end
        end)
    end
    local beam = cfg.spawn_pfx_beam
    if beam then
        local fx_beam = ParticleManager:CreateParticle(beam, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(fx_beam, 0, pos)
        Timers(2, function()
            if fx_beam then
                ParticleManager:DestroyParticle(fx_beam, false)
                ParticleManager:ReleaseParticleIndex(fx_beam)
            end
        end)
    end
    local ground = cfg.spawn_pfx_ground
    if ground then
        local fx2 = ParticleManager:CreateParticle(ground, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(fx2, 3, pos)
        Timers(1.5, function()
            if fx2 then
                ParticleManager:DestroyParticle(fx2, false)
                ParticleManager:ReleaseParticleIndex(fx2)
            end
        end)
    end
    if sound_unit and not sound_unit:IsNull() then
        EmitSoundOnLocationWithCaster(pos, "Hero_Zuus.LightningBolt", sound_unit)
    end
end

function Monster:SetupLightningBeliever(unit)
    if not unit or unit:IsNull() then
        return
    end
    if unit:FindAbilityByName("spawnlord_master_freeze") then
        unit:RemoveAbility("spawnlord_master_freeze")
    end
    if unit:FindAbilityByName("treant_leech_seed") then
        unit:RemoveAbility("treant_leech_seed")
    end
    if unit:HasModifier("modifier_m_1_6_leech_seed_attack") then
        unit:RemoveModifierByName("modifier_m_1_6_leech_seed_attack")
    end
    local ab1 = unit:FindAbilityByName("ability_m_1_6_flux")
    if not ab1 then
        ab1 = unit:AddAbility("ability_m_1_6_flux")
    end
    if ab1 then
        ab1:SetLevel(1)
        if ab1.SetOverrideCastRange then
            ab1:SetOverrideCastRange(800)
        end
    else
        return
    end
    unit:SetMaxMana(math.max(unit:GetMaxMana(), 500))
    unit:SetMana(math.max(unit:GetMana(), 500))
    if unit:FindAbilityByName("zuus_static_field") then
        unit:RemoveAbility("zuus_static_field")
    end
    if unit:FindAbilityByName("ability_m_1_6_lightning_bind") then
        unit:RemoveAbility("ability_m_1_6_lightning_bind")
    end
    local ab2 = unit:FindAbilityByName("ability_m_1_6_static_field")
    if not ab2 then
        ab2 = unit:AddAbility("ability_m_1_6_static_field")
    end
    if ab2 then
        ab2:SetLevel(1)
    end
    if unit:HasModifier("modifier_m_1_6_lightning_bind_attack") then
        unit:RemoveModifierByName("modifier_m_1_6_lightning_bind_attack")
    end
    if ab1 and not unit:HasModifier("modifier_m_1_6_flux_attack") then
        unit:AddNewModifier(unit, ab1, "modifier_m_1_6_flux_attack", {})
    end
end

function Monster:FinalizeLightningBelieverSpawn(unit)
    if not unit or unit:IsNull() then
        return nil
    end
    self:SetupLightningBeliever(unit)
    table.insert(self.Data.lightning, unit:GetEntityIndex())
    self:MonsterAi(unit)
    return unit
end

function Monster:SpawnLightningBelieverAt(pos, skip_checks, sound_unit, on_spawned)
    if not pos then
        if on_spawned then
            on_spawned(nil)
        end
        return
    end
    if not skip_checks then
        if MainGame.Data.jzsg == true then
            return
        end
        if MainGame:GetLastFight() == false then
            return
        end
        if MainGame and MainGame.Data and MainGame.Data.over then
            return
        end
        if GameRules and GameRules.IsGamePaused and GameRules:IsGamePaused() then
            return
        end
        if MainGame:GetTime() < self.LightningBeliever.start_time then
            return
        end
        if not self:IsInsidePoisonRing(pos) then
            return
        end
    end

    self:PlayLightningBelieverSpawnFx(pos, sound_unit)
    Timers(0.35, function()
        if not skip_checks and MainGame and MainGame.Data and MainGame.Data.over then
            if on_spawned then
                on_spawned(nil)
            end
            return
        end
        if not skip_checks and not self:IsInsidePoisonRing(pos) then
            if on_spawned then
                on_spawned(nil)
            end
            return
        end
        local unit = utilex:CreateMonster(self.LightningBeliever.unit_name, pos)
        unit = Monster:FinalizeLightningBelieverSpawn(unit)
        if on_spawned then
            on_spawned(unit)
        end
    end)
end

function Monster:SpawnLightningBeliever()
    local cfg = self.LightningBeliever
    local max_alive = cfg.max_alive or 12
    if self:GetLightningAliveCount() >= max_alive then
        return
    end
    -- 与英雄复活相同：圈内随机点（Rebron），不走野怪刷点
    local pos = HeroData and HeroData.HeroPos and HeroData:HeroPos(nil)
    if not pos then
        return
    end
    self:SpawnLightningBelieverAt(pos, false)
end

function Monster:CreateLightningBelieverLoop()
    local cfg = self.LightningBeliever
    Timers(cfg.start_time, function()
        self:SpawnLightningBeliever()
        Timers(cfg.interval, function()
            if MainGame and MainGame.Data and MainGame.Data.over then
                return nil
            end
            self:SpawnLightningBeliever()
            return cfg.interval
        end)
    end)
end

-- 压缩 normal 列表（移除已销毁索引）；供定时清理与顶人口时节流调用
function Monster:CompactNormalList()
    local new_normal = {}
    for _, v in pairs(self.Data.normal) do
        local unit = EntIndexToHScript(v)
        if utilex:IsTrueEntity(unit) then
            table.insert(new_normal, v)
        end
    end
    self.Data.normal = new_normal
    self.Data.normal_count = #new_normal
end

-- 雷电信徒存活列表压缩（死亡未清理时避免假顶满）
function Monster:CompactLightningList()
    local new_list = {}
    for _, v in pairs(self.Data.lightning or {}) do
        local unit = EntIndexToHScript(v)
        if utilex:IsTrueEntity(unit) and unit:IsAlive() then
            table.insert(new_list, v)
        end
    end
    self.Data.lightning = new_list
    return #new_list
end

function Monster:GetLightningAliveCount()
    return self:CompactLightningList()
end

-- 生成普通怪（优化：紧凑表+缓存数量；降低刷怪 tick 频率、近上限降速；暂停时拉长间隔）
function Monster:SpawnNormal()
    Timers(0.35, function()
        if MainGame.Data.jzsg == true then
            return nil
        end
        --最终决战开始后不再刷怪
        if MainGame:GetLastFight() == false then
            return nil
        end
        if MainGame and MainGame.Data and MainGame.Data.over then
            return nil
        end
        if GameRules and GameRules.IsGamePaused and GameRules:IsGamePaused() then
            return 1
        end
        -- 同步存活数（按游戏秒间隔整表压缩，避免旧逻辑 GetTime()%gap 在同1 秒内触发多次全表扫描）
        self:UpdateNormalCount()
        local limit = self:GetMonsterLimit()
        local cnt = self.Data.normal_count or 0
        -- 计数含已死索引时易「假顶满」不刷怪：近上限时每游戏秒最多压一次表
        if cnt >= limit then
            local gt = MainGame:GetTime()
            if self.Data._cap_compact_gt ~= gt then
                self.Data._cap_compact_gt = gt
                self:CompactNormalList()
                cnt = self.Data.normal_count or 0
            end
        end
        local fill = (limit > 0) and (cnt / limit) or 0

        local refresher_time = 0.2
        if MainGame:GetState() == 2 then
            refresher_time = 0.2
        end
        if MainGame:GetState() == 3 then
            refresher_time = 1
        end
        if MainGame:GetTime() < 60 then
            refresher_time = 0.15
        end
        if fill >= 0.92 then
            refresher_time = refresher_time + 0.7
        elseif fill >= 0.78 then
            refresher_time = refresher_time + 0.3
        end

        if cnt < limit then
            local name = "m_1_" .. math.random(1, 5)
            local pos = Monster:MonsterPos()
            local unit = utilex:CreateMonster(name, pos)
            if unit then
                table.insert(self.Data.normal, unit:GetEntityIndex())
                self.Data.normal_count = cnt + 1
                self:MonsterAi(unit)
            end
        end
        return refresher_time
    end)
end

function Monster:UpdateNormalCount()
    local gap_time = 10
    if MainGame:GetState() == 1 then
        gap_time = 15
    end
    if MainGame:GetState() == 2 then
        gap_time = 30
    end
    local now = MainGame:GetTime()
    local next_at = self.Data._normal_prune_at
    if next_at == nil then
        next_at = -1e9
    end
    if now < next_at then
        return
    end
    self.Data._normal_prune_at = now + gap_time
    self:CompactNormalList()
end

-- 生成狼王
function Monster:CreateWolf()
    utilex:SoundAll("wolf1")
    Util:TopMsg2All("狼王开始刷新！", "red", 5, "#000000cc")
    local num = self.Static.wolf_num
    local name = "m_2_1"
    for i = 1, num do
        Timers(i, function()
            if MainGame and MainGame.Data and MainGame.Data.over then
                return
            end
            local pos = Monster:MonsterPos()
            local unit = utilex:CreateMonster(name, pos)
            if unit then
                self:MonsterAi(unit)
                local ab1 = unit:AddAbility("ability_item_15")
                local ab2 = unit:AddAbility("ability_item_16")
                ab1:SetLevel(10)
                ab2:SetLevel(10)
            end
        end)
    end
end

-- 生成熊王
function Monster:CreateBear()
    utilex:SoundAll("bear")
    Util:TopMsg2All("寰宇肉山刷新了！", "red", 5, "#000000cc")
    local num = self.Static.bear_num
    local name = "m_2_2"
    for i = 1, num do
        local pos = Util:TabRandom(self.BearPos)
        local unit = utilex:CreateMonster(name, pos)
        if unit then
            self:MonsterAi(unit)
            local ab1 = unit:AddAbility("ability_item_1")
            local ab2 = unit:AddAbility("ability_item_13")
            local ab3 = unit:AddAbility("ability_item_14")
            local ab4 = unit:AddAbility("ability_item_27")
            local ab5 = unit:AddAbility("ability_item_22")
            ab1:SetLevel(10)
            ab2:SetLevel(10)
            ab3:SetLevel(10)
            ab4:SetLevel(10)
            ab5:SetLevel(10)
            local ab6 = unit:AddAbility("tidehunter_kraken_shell")
            ab6:SetLevel(4)
        end
    end
end

-- 生成风暴领主
function Monster:CreateDragon()
    utilex:SoundAll("dragon")
    Util:TopMsg2All("风暴领主刷新了！", "red", 5, "#000000cc")
    local num = self.Static.dragon
    local name = "m_2_3"
    for i = 1, num do
        local pos = self.DragonPos
        local unit = utilex:CreateMonster(name, pos)
        if unit then
            utilex:AnimationModifier(unit)
            unit:AddNewModifier(unit, nil, "modifier_m_2_3_attack", {})
            local item = CreateItem("item_monkey_king_bar", nil, nil)
            unit:AddItem(item)
            self:DragonAi(unit)
            local ab1 = unit:AddAbility("ability_m_2_3_eye_of_storm")
            local ab2 = unit:AddAbility("ability_m_2_3_storm_surge")
            local ab3 = unit:AddAbility("ability_m_2_3_plasma_ring")
            local ab4 = unit:AddAbility("ability_boss_1")
            local ab5 = unit:AddAbility("ability_item_17")
            local ab6 = unit:AddAbility("ability_item_22")
            ab1:SetLevel(1)
            ab2:SetLevel(1)
            ab3:SetLevel(1)
            ab4:SetLevel(1)
            ab5:SetLevel(10)
            ab6:SetLevel(10)
            unit:AddAbility("roshan_spell_block")
            local ab7 = unit:AddAbility("tidehunter_kraken_shell")
            ab7:SetLevel(4)
            unit:AddNewModifier(unit, nil, "modifier_roshan_devotion", {})
        end
    end
end

function Monster:DragonAi(unit)
    if not unit then return end
    local init_pos = unit:GetAbsOrigin()
    local buff = "wd_nobar"
    unit.hp_bgm = true
    unit.hp_percent30 = true
    Timers(1, function()
        if MainGame and MainGame.Data and MainGame.Data.over then
            return nil
        end
        if not unit:IsAlive() then return end
        if unit:GetHealthPercent() <= 50 and unit.hp_bgm == true then
            utilex:SoundAll("dragon_hp")
            unit.hp_bgm = false
        end
        if unit:GetHealthPercent() <= 30 and unit.hp_percent30 == true then
            unit.hp_percent30 = false
            local ab_plasma = unit:FindAbilityByName("ability_m_2_3_plasma_ring")
            if ab_plasma and ab_plasma.TriggerPhaseTwo then
                ab_plasma:TriggerPhaseTwo()
            end
        end
        local pos = unit:GetAbsOrigin()
        local len = (pos - init_pos):Length2D()
        if len > 450 then utilex:AddModifier(unit, buff) end
        if len > 600 then unit:MoveToPosition(init_pos) end
        if len < 400 then
            if unit:HasModifier(buff) then
                unit:RemoveModifierByName(buff)
            end
        end

        return 0.5
    end)
end

function Monster:MonsterAi(unit)
    if not unit then return end
    --  unit:AddNewModifier(unit, nil, "modifier_yinshen", {})
    local pos = unit:GetAbsOrigin()
    local order_attack_move = rawget(_G, "DOTA_UNIT_ORDER_ATTACK_MOVE")
    local execute_order = rawget(_G, "ExecuteOrderFromTable")
    -- 错开首次思考，避免同批刷怪同帧打 CanFindPath /下单
    local stagger = 0
    if unit.entindex then
        stagger = (unit:entindex() % 19) * 0.08
    end
    Timers(1 + stagger, function()
        if MainGame:GetLastFight() == false then
            return nil
        end
        if MainGame and MainGame.Data and MainGame.Data.over then
            return nil
        end
        if not utilex:IsTrueEntity(unit) then return end
        if GameRules and GameRules.IsGamePaused and GameRules:IsGamePaused() then
            return 1.2
        end
        local target = unit:GetAggroTarget()
        if not target then
            -- 已在巡逻移动则延后再算新点，减少 GetRandomPosMax/CanFindPath 与重复 A-Move
            if unit.IsMoving and unit:IsMoving() then
                local t = math.random(4, 7)
                if MainGame and MainGame.Data and MainGame.Data.state == 2 then
                    t = math.random(5, 9)
                end
                return t
            end
            local max_len = 1000
            if MainGame:GetState() == 1 then
                max_len = 1000
            else
                max_len = 600
            end
            -- 巡逻高频：限制寻路尝试次数，避免单怪卡死主线程
            local random_pos = utilex:GetRandomPosMax(pos, max_len, 28)
            if not random_pos then
                random_pos = pos + RandomVector(RandomFloat(120, math.min(max_len, 400)))
                random_pos = Util:FindCanReachPos(random_pos)
            end
            -- 攻击移动（类巡逻）：途中进入仇恨范围会立刻接战，而非走完 MoveToPosition 再打人
            if execute_order and order_attack_move and random_pos then
                execute_order({
                    UnitIndex = unit:entindex(),
                    OrderType = order_attack_move,
                    Position = random_pos,
                })
            elseif random_pos then
                unit:MoveToPosition(random_pos)
            end
        else
            if not target:IsAlive() then
                pos = unit:GetAbsOrigin()
                return 1
            end
            local len = (target:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
            if len > 800 then
                pos = unit:GetAbsOrigin()
                unit:SetAggroTarget(nil)
                return 1
            end
        end
        local time = math.random(3, 6)
        if MainGame and MainGame.Data and MainGame.Data.state == 2 then
            time = math.random(5, 9)
        end
        -- return time
        return
    end)
end

-- 50概率掉升级书和删除书
function Monster:IsFirstRingShrunk()
    return MainGame and MainGame.Data and MainGame.Data.state >= 2
end

--- 小怪掉落池：16 分钟前去掉究极技能书（权重并入 null）
function Monster:GetNormalDropPool(item_key)
    local pool = self[item_key]
    if not pool then
        return pool
    end

    local filtered
    local function ensure_copy()
        if not filtered then
            filtered = {}
            for k, w in pairs(pool) do
                filtered[k] = w
            end
        end
    end
    local function strip(key)
        local w = (filtered or pool)[key]
        if not w or w <= 0 then
            return
        end
        ensure_copy()
        filtered[key] = nil
        filtered.null = (filtered.null or 0) + w
    end

    local time_min = MainGame and MainGame.GetTimeMin and MainGame:GetTimeMin() or 0
    if time_min < 16 then
        strip("item_goods_16")
    end

    return filtered or pool
end

function Monster:WolfBearDrag(pos1)
    local roll = math.random(0, 1)
    if roll == 1 then
        local pos2 = utilex:RandomPos(pos1, 30, 300)
        local list = { "item_goods_9", "item_goods_20" }
        local item_name = Util:TabRandom(list)
        local item = CreateItem(item_name, nil, nil)
        CreateItemOnPositionSync(pos1, item)
        item:LaunchLoot(false, 300, 0.5, pos2, nil)
    end
end

-- 野怪死亡
function Monster:Death(unit)
    if not unit then return end
    local name = unit:GetUnitName()
    local pos1 = unit:GetAbsOrigin()
    local pos2 = utilex:RandomPos(pos1, 0, 300)
    local item_name
    if name == "m_1_6" then
        local eid = unit:GetEntityIndex()
        local list = self.Data.lightning
        if list then
            for i = #list, 1, -1 do
                if list[i] == eid then
                    table.remove(list, i)
                    break
                end
            end
        end
        item_name = "item_goods_25"
    elseif self:IsLeader(name) then
        Monster:LeaderDeath(unit)
        local roll = math.random(0, 1)
        -- 如果是龙
        if name == "m_2_3" then
            roll = 1
        else
            -- 如果是狼和熊
            Monster:WolfBearDrag(pos1)
        end
        if name == "m_2_2" then
            roll = 1
        end
        if roll == 1 then item_name = self.leader[name] end
    else
        local time_min = MainGame:GetTimeMin()
        local item_key = ""
        if time_min <= 10 then
            item_key = "Item1"
        end
        if time_min <= 20 and time_min > 10 then
            item_key = "Item2"
        end
        if time_min > 20 then
            item_key = "Item3"
        end
        local roll = Util:Weight(self:GetNormalDropPool(item_key))
        if roll ~= "null" then item_name = roll end
    end
    if not item_name then return end
    local clear = false
    if item_name == "item_goods_13" then
        -- local roll_book = math.random(1, 28)
        item_name = Util:TabRandom(Item.Rb)
        clear = true
    end
    if item_name == "item_goods_14" or item_name == "item_goods_15" then
        clear = true
    end
    local item = CreateItem(item_name, nil, nil)
    CreateItemOnPositionSync(pos1, item)
    item:LaunchLoot(false, 300, 0.5, pos2, nil)
    if item_name == "item_goods_16" then
        local box = item:GetContainer()
        Timers(1, function()
            if item and not item:IsNull() and box and not box:IsNull() then
                local p = "particles/item_drop_beam_2_lvl4.vpcf"
                utilex:AddParticles(p, box, 666, 1)
            end
        end)
    end
    if item_name == "item_goods_25" then
        local box = item:GetContainer()
        Timers(1, function()
            if item and not item:IsNull() and box and not box:IsNull() then
                local p = "particles/item_drop_beam_2_lvl2.vpcf"
                utilex:AddParticles(p, box, 666, 1)
            end
        end)
    end
    if clear then
        local time = 120
        if MainGame.Data.state == 2 then time = 60 end
        if MainGame.Data.state == 3 then time = 10 end
        Timers(time, function()
            if item and not item:IsNull() and item:IsItem() then
                local box = item:GetContainer()
                if box then
                    box:RemoveSelf()
                    UTIL_Remove(item)
                end
            end
        end)
    end
end

function Monster:LeaderDeath(unit)
    local name = unit:GetUnitName()
    local pos1 = unit:GetAbsOrigin()
    local pos2 = utilex:RandomPos(pos1, 0, 300)
    local item_name

    if name == "m_2_1" then item_name = "item_goods_14" end
    if name == "m_2_2" then item_name = "item_goods_15" end
    if name == "m_2_3" then item_name = "item_goods_16" end
    if not item_name then return end
    local item = CreateItem(item_name, nil, nil)
    CreateItemOnPositionSync(pos1, item)
    item:LaunchLoot(false, 300, 0.5, pos2, nil)
    if item_name == "item_goods_16" then
        local box = item:GetContainer()
        Timers(1, function()
            if item and not item:IsNull() and box and not box:IsNull() then
                local p = "particles/item_drop_beam_2_lvl4.vpcf"
                utilex:AddParticles(p, box, 60, 1)
            end
        end)
    end
end

--- 结算界面开启：隐藏并移除本模式野怪（m_ 前缀、中立非英雄），并清空 normal 列表；刷新循环由 MainGame.Data.over 与各 Timers return nil 停止
function Monster:OnSettlementUIStart()
    if not IsServer() then
        return
    end
    self:HideAndRemoveAllWildMonsters()
end

function Monster:HideAndRemoveAllWildMonsters()
    local remove_unit = rawget(_G, "UTIL_Remove")
    local center = self.Static and self.Static.map_center or Vector(0, 0, 128)
    local TEAM_NEUTRAL = rawget(_G, "DOTA_TEAM_NEUTRALS") or 4
    local NOTEAM = rawget(_G, "DOTA_TEAM_NOTEAM") or 0
    local TEAM_BOTH = rawget(_G, "DOTA_UNIT_TARGET_TEAM_BOTH") or 3
    local UTYPE = rawget(_G, "DOTA_UNIT_TARGET_ALL") or rawget(_G, "DOTA_UNIT_TARGET_BASIC") or 2
    local FLAG_NONE = rawget(_G, "DOTA_UNIT_TARGET_FLAG_NONE") or 0
    local FIND_ANY = rawget(_G, "FIND_ANY_ORDER") or 0

    for _, idx in pairs(self.Data.normal or {}) do
        local u = EntIndexToHScript(idx)
        if u and not u:IsNull() and u:IsAlive() then
            if utilex and utilex.IsClrbCourierPet and utilex:IsClrbCourierPet(u) then
                goto _continue_normal_idx
            end
            if u.AddNoDraw then
                u:AddNoDraw()
            end
            if u.Stop then
                u:Stop()
            end
            if remove_unit then
                remove_unit(u)
            elseif u.RemoveSelf then
                u:RemoveSelf()
            end
        end
        ::_continue_normal_idx::
    end
    self.Data.normal = {}
    self.Data.normal_count = 0
    self.Data.lightning = {}

    local units = FindUnitsInRadius(NOTEAM, center, nil, 24000, TEAM_BOTH, UTYPE, FLAG_NONE, FIND_ANY, false)
    for _, u in pairs(units) do
        if u and not u:IsNull() and u:IsAlive() and not u:IsHero() and u:GetTeamNumber() == TEAM_NEUTRAL then
            if utilex and utilex.IsClrbCourierPet and utilex:IsClrbCourierPet(u) then
                goto _continue_radius_unit
            end
            local uname = u.GetUnitName and u:GetUnitName() or ""
            if string.sub(uname, 1, 2) == "m_" then
                if u.AddNoDraw then
                    u:AddNoDraw()
                end
                if u.Stop then
                    u:Stop()
                end
                if remove_unit then
                    remove_unit(u)
                elseif u.RemoveSelf then
                    u:RemoveSelf()
                end
            end
        end
        ::_continue_radius_unit::
    end
end
