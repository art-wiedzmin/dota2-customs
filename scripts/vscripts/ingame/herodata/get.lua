--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--英雄第一次出生
function HeroData:HeroInitPos(ID)
    if not ID then
        return
    end
    local player_data = InitPlayer:GetPlayerData(ID)
    if not player_data then
        return
    end
    local init_pos = player_data.init_pos
    if not init_pos or type(init_pos) ~= "number" or init_pos < 1 then
        return
    end
    local init_key = "init" .. init_pos
    local all_pos = Entities:FindAllByClassname("info_target")
    for k, v in pairs(all_pos) do
        if v and v:GetName() == init_key then
            return v:GetAbsOrigin()
        end
    end
end

-- 随机偏移最大距离，用于预留圈内余量（仅缩圈前大圈）
local REBORN_RANDOM_MARGIN = 600
-- 缩圈后复活「远离边界」：内收 POISON_RING_RESPAWN_INSET；仅第一波缩圈(stage<2,rang1)需要，第二波(stage>=2,rang2)不再内收允许贴沿
local POISON_RING_RESPAWN_INSET = 2200
-- 缩圈前（state==1）复活：落点与死亡点最小平面距离
local REBORN_MIN_DIST_FROM_DEATH_PRE_SHRINK = 5000
local REBORN_SAMPLE_ATTEMPTS = 80
-- 复活落点与树木最小平面距离（码）；IsNearbyTree 用该半径检测是否与树碰撞/重叠
local REBORN_MIN_TREE_CLEARANCE = 150

-- 与 MainGame 英雄毒伤一致：state<2 时尚未按 rang 毒英雄，不裁剪
local function HeroData_GetCurrentPoisonRingRadius()
    local mg_state = (MainGame and MainGame.GetState and MainGame:GetState()) or 1
    if mg_state < 2 then
        return nil
    end
    local stage = Monster and Monster.Data and Monster.Data.stage or 1
    if stage >= 2 then
        return MainGame.Static.rang2
    end
    return MainGame.Static.rang1
end

local function HeroData_ShouldInsetRespawnFromPoisonEdge()
    local mg_state = (MainGame and MainGame.GetState and MainGame:GetState()) or 1
    if mg_state < 2 then
        return false
    end
    local stage = Monster and Monster.Data and Monster.Data.stage or 1
    return stage < 2
end

-- 将地面落点沿径向收进「毒圈半径 - （仅第一波缩圈时）POISON_RING_RESPAWN_INSET」内（人机/真人复活共用）
local function HeroData_ClampPosToPoisonRingInset(ground_pos, hero_for_ground)
    if not ground_pos then
        return nil
    end
    local ring_center = Monster and Monster.Static and Monster.Static.map_center
    if not ring_center then
        return ground_pos
    end
    local radius = HeroData_GetCurrentPoisonRingRadius()
    if radius == nil then
        return ground_pos
    end
    local inset_use = HeroData_ShouldInsetRespawnFromPoisonEdge() and POISON_RING_RESPAWN_INSET or 0
    local max_dist = math.max(0, radius - inset_use)
    local v = ground_pos - ring_center
    local len = v:Length2D()
    if len <= max_dist then
        return ground_pos
    end
    if len < 1e-6 then
        return GetGroundPosition(ring_center, hero_for_ground)
    end
    local s = max_dist / len
    local p = Vector(ring_center.x + v.x * s, ring_center.y + v.y * s, ground_pos.z)
    return GetGroundPosition(p, hero_for_ground)
end

-- 人机从 Rebron 表直落时无 HeroPos 裁剪，二圈后可能落在毒圈外；按当前 stage 与毒圈半径收进安全区
local function HeroData_ClampBotPosToCurrentRing(ground_pos, hero_for_ground)
    return HeroData_ClampPosToPoisonRingInset(ground_pos, hero_for_ground)
end

-- FindClearSpace / 引擎挤位可能把单位推到毒圈边；再收一进（需在 BotOnly / ApplyRebornClearPos 可见，故置于此）
local function HeroData_RebornFinalizePosInsidePoisonRing(hero)
    if not hero or hero:IsNull() then
        return
    end
    local gp = GetGroundPosition(hero:GetAbsOrigin(), hero)
    local v = Vector(gp.x, gp.y, gp.z)
    local clamped = HeroData_ClampPosToPoisonRingInset(v, hero)
    if not clamped then
        return
    end
    if (clamped - v):Length2D() < 4 then
        return
    end
    hero:SetAbsOrigin(clamped)
    FindClearSpaceForUnit(hero, clamped, true)
    gp = GetGroundPosition(hero:GetAbsOrigin(), hero)
    hero:SetAbsOrigin(Vector(gp.x, gp.y, gp.z))
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
end

local function HeroData_RebornPointClearOfTrees(pos)
    if not pos then
        return false
    end
    if not GridNav or not GridNav.IsNearbyTree then
        return true
    end
    local ok, overlaps = pcall(function()
        return GridNav:IsNearbyTree(pos, REBORN_MIN_TREE_CLEARANCE, true)
    end)
    if not ok then
        return true
    end
    return not overlaps
end

-- 从 Rebron1（缩圈前）/ Rebron2（缩圈后）中随机取一个英雄复活点，作为随机采样圆心；毒圈与路径仍相对地图中心 map_center
local function HeroData_PickRandomRebronBase(mg_state)
    local tab = (mg_state == 1) and HeroData.Rebron1 or HeroData.Rebron2
    if not tab then
        return nil
    end
    local list = {}
    for _, v in pairs(tab) do
        if v and v.x then
            list[#list + 1] = v
        end
    end
    if #list == 0 then
        return nil
    end
    return list[RandomInt(1, #list)]
end

--- 人机专用复活落点（与真人 ApplyRebornClearPos / HeroPos 完全无关）。
--- 在 RespawnUnit() 之后由服务端延迟调用：从 HeroData.Rebron1 / Rebron2（Config）随机取一点贴地传送。
--- 延后一帧 + 短延迟再设一次，避免引擎默认复活区覆盖坐标。
function HeroData:BotOnly_RespawnTeleportFromTable(bot_player_id)
    if bot_player_id == nil then
        return
    end
    local function pick_hero()
        local h = Util:ID2Hero(bot_player_id)
        if not h or h:IsNull() then
            h = HeroData:GetHero(bot_player_id)
        end
        if h and not h:IsNull() then
            return h
        end
    end
    local function do_place(h)
        if not h then
            return
        end
        if h.Stop then
            pcall(function()
                h:Stop()
            end)
        end
        local mg_state = (MainGame and MainGame.GetState and MainGame:GetState() or 1)
        local ring_fb = Monster and Monster.Static and Monster.Static.map_center
        local pos
        for _ = 1, 20 do
            local raw = HeroData_PickRandomRebronBase(mg_state)
            if raw then
                pos = GetGroundPosition(Vector(raw.x, raw.y, raw.z), h)
            elseif ring_fb then
                pos = GetGroundPosition(ring_fb, h)
            end
            if pos and HeroData_RebornPointClearOfTrees(pos) then
                pos = HeroData_ClampBotPosToCurrentRing(pos, h)
                break
            end
            pos = nil
        end
        if not pos and ring_fb then
            pos = GetGroundPosition(ring_fb, h)
        end
        if pos then
            pos = HeroData_ClampBotPosToCurrentRing(pos, h)
            h._clrb_bot_reborn_dst = pos
            h:SetAbsOrigin(pos)
            HeroData_RebornFinalizePosInsidePoisonRing(h)
        end
    end
    Timers(0, function()
        do_place(pick_hero())
    end)
    Timers(0.08, function()
        local h = pick_hero()
        if h and h._clrb_bot_reborn_dst then
            h:SetAbsOrigin(GetGroundPosition(h._clrb_bot_reborn_dst, h))
            h._clrb_bot_reborn_dst = nil
            HeroData_RebornFinalizePosInsidePoisonRing(h)
        end
    end)
end

-- 英雄复活点：在毒圈允许半径内随机采样，采样圆心为随机 Rebron 点（非地图中心）；缩圈前还须从地图中心 CanFindPath 可达，且距死亡点至少 REBORN_MIN_DIST_FROM_DEATH_PRE_SHRINK；缩圈后在圈内随机可行走点（相对 map_center 的 rang，不能落在毒圈外）。
-- Rebron1/Rebron2 亦用于 Bot 巡逻等逻辑。
function HeroData:HeroPos(avoid_death_pos)
    local mg_state = 1
    if MainGame and MainGame.GetState then
        mg_state = MainGame:GetState() or 1
    end
    local ring_center = Monster and Monster.Static and Monster.Static.map_center
    if not ring_center then
        return Vector(0, 0, 0)
    end
    local sample_base = HeroData_PickRandomRebronBase(mg_state) or ring_center

    local radius
    if mg_state == 1 then
        radius = 10000
    else
        local stage = Monster and Monster.Data and Monster.Data.stage or 1
        if stage >= 2 then
            radius = MainGame.Static.rang2
        else
            radius = MainGame.Static.rang1
        end
    end
    local safe_radius = math.max(0, radius - REBORN_RANDOM_MARGIN)
    local inset_px = HeroData_ShouldInsetRespawnFromPoisonEdge() and POISON_RING_RESPAWN_INSET or 0
    -- 缩圈后：采样/裁剪半径不超过当前毒圈；仅第一波缩圈再减 inset_px；缩圈前仍用大圈 safe_radius
    local spawn_cap = (mg_state == 1) and safe_radius or math.max(0, radius - inset_px)
    -- 以随机 Rebron 为圆心、在至多 spawn_cap 距离内均匀随机（大范围）；落点再由 clamp_to_ring 限制在毒圈内，卡树由 ApplyRebornClearPos 多轮挤位
    local jitter_max = spawn_cap

    local center_nav = Util:FindCanReachPos(Vector(ring_center.x, ring_center.y, ring_center.z))
    local require_path_from_center = (mg_state == 1)
    local require_death_clearance = (mg_state == 1 and avoid_death_pos ~= nil)

    local function clamp_to_ring(candidate)
        local v = candidate - ring_center
        local len2d = v:Length2D()
        if len2d < 1e-6 then
            return candidate
        end
        if len2d > spawn_cap then
            local s = spawn_cap / len2d
            return Vector(ring_center.x + v.x * s, ring_center.y + v.y * s, candidate.z)
        end
        return candidate
    end

    local function nav_cell_usable(v)
        if not v then
            return false
        end
        if not GridNav:IsTraversable(v) then
            return false
        end
        if GridNav.IsBlocked then
            local ok, blocked = pcall(function()
                return GridNav:IsBlocked(v)
            end)
            if ok and blocked then
                return false
            end
        end
        return true
    end

    local function candidate_ok(vec)
        local candidate = Util:FindCanReachPos(clamp_to_ring(vec))
        candidate = clamp_to_ring(candidate)
        local gp = GetGroundPosition(candidate, nil)
        candidate = Vector(gp.x, gp.y, gp.z)
        if not nav_cell_usable(candidate) then
            return nil
        end
        if mg_state >= 2 then
            local ld = (candidate - ring_center):Length2D()
            if ld > spawn_cap then
                return nil
            end
        end
        if require_path_from_center and CanFindPath and not CanFindPath(center_nav, candidate) then
            return nil
        end
        if require_death_clearance and (candidate - avoid_death_pos):Length2D() < REBORN_MIN_DIST_FROM_DEATH_PRE_SHRINK then
            return nil
        end
        if not HeroData_RebornPointClearOfTrees(candidate) then
            return nil
        end
        return candidate
    end

    for _ = 1, REBORN_SAMPLE_ATTEMPTS do
        local raw = sample_base + RandomVector(RandomFloat(0, jitter_max))
        local pos = candidate_ok(raw)
        if pos then
            return pos
        end
    end

    if require_death_clearance then
        local away = ring_center - avoid_death_pos
        local l2 = away:Length2D()
        if l2 < 1e-3 then
            away = RandomVector(1)
        end
        away = Vector(away.x, away.y, 0):Normalized()
        local cand = ring_center + away * (spawn_cap * 0.75)
        local pos = candidate_ok(cand)
        if pos then
            return pos
        end
    end

    if mg_state >= 2 then
        for _ = 1, 40 do
            local raw = sample_base + RandomVector(RandomFloat(0, jitter_max * 0.6))
            local c = Util:FindCanReachPos(clamp_to_ring(raw))
            c = clamp_to_ring(c)
            if c and (c - ring_center):Length2D() <= spawn_cap and HeroData_RebornPointClearOfTrees(c) then
                return c
            end
        end
        local fb = clamp_to_ring(center_nav)
        if HeroData_RebornPointClearOfTrees(fb) then
            return fb
        end
    end

    for _ = 1, 24 do
        local jitter = RandomVector(RandomFloat(40, 500))
        local c = GetGroundPosition(center_nav + jitter, nil)
        c = Vector(c.x, c.y, c.z)
        if mg_state >= 2 then
            c = clamp_to_ring(c)
        end
        if nav_cell_usable(c) and HeroData_RebornPointClearOfTrees(c) then
            if mg_state < 2 or (c - ring_center):Length2D() <= spawn_cap then
                return c
            end
        end
    end
    if mg_state >= 2 then
        center_nav = clamp_to_ring(Util:FindCanReachPos(center_nav))
        center_nav = clamp_to_ring(center_nav)
        local gf = GetGroundPosition(center_nav, nil)
        center_nav = Vector(gf.x, gf.y, gf.z)
    end
    return center_nav
end

function HeroData:ApplyRebornClearPos(hero, death_pos_for_reborn)
    if not hero or hero:IsNull() then
        return
    end
    local attempts = 14
    local ring_fb = Monster and Monster.Static and Monster.Static.map_center
    for _ = 1, attempts do
        local pos = self:HeroPos(death_pos_for_reborn)
        if pos then
            local gp = GetGroundPosition(pos, hero)
            pos = Vector(gp.x, gp.y, gp.z)
            hero:SetAbsOrigin(pos)
            FindClearSpaceForUnit(hero, pos, true)
            gp = GetGroundPosition(hero:GetAbsOrigin(), hero)
            hero:SetAbsOrigin(Vector(gp.x, gp.y, gp.z))
            FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
            local ap = hero:GetAbsOrigin()
            if GridNav:IsTraversable(ap) then
                local bad = false
                if GridNav.IsBlocked then
                    local okb, bl = pcall(function()
                        return GridNav:IsBlocked(ap)
                    end)
                    if okb and bl then
                        bad = true
                    end
                end
                if not bad and not HeroData_RebornPointClearOfTrees(ap) then
                    bad = true
                end
                if not bad then
                    HeroData_RebornFinalizePosInsidePoisonRing(hero)
                    return
                end
            end
        end
    end
    if ring_fb then
        local pos = GetGroundPosition(ring_fb, hero)
        pos = HeroData_ClampPosToPoisonRingInset(pos, hero) or pos
        hero:SetAbsOrigin(pos)
        FindClearSpaceForUnit(hero, pos, true)
        HeroData_RebornFinalizePosInsidePoisonRing(hero)
    end
end

--获取英雄属性
function HeroData:GetSX(ID, name)
    if not ID or not name then
        return
    end
    local row = self.Data and self.Data[ID]
    if not row or not row.hero_attr then
        return
    end
    return row.hero_attr[name]
end

--- 物理伤害：按 hero_attr.wlct（%/100 有效护甲削减）在伤害过滤中补偿引擎税后伤害（与 Dota 0.06 护甲系数一致）
function HeroData:GetPhysicalArmorPenDamageScale(attacker, target)
    if not IsServer() then
        return 1
    end
    if not attacker or attacker:IsNull() or not target or target:IsNull() then
        return 1
    end
    if target:IsBuilding() then
        return 1
    end
    if attacker:IsIllusion() then
        return 1
    end
    local ID = Util and Util.Hero2ID and Util:Hero2ID(attacker)
    if not ID then
        return 1
    end
    local reduce_pct = tonumber(self:GetSX(ID, "wlct")) or 0
    local reduce_factor = math.max(0, math.min(reduce_pct, 100)) / 100
    if reduce_factor <= 0 then
        return 1
    end
    local armor = target:GetPhysicalArmorValue(false)
    if armor <= 0 then
        return 1
    end
    return (1 + 0.06 * armor) / (1 + 0.06 * armor * (1 - reduce_factor))
end

--获取ID对应的英雄
function HeroData:GetHero(ID)
    if not ID then
        return
    end
    if not self.Data[ID] then
        return
    end
    local hero_index = self.Data[ID].hero_index
    local hero = EntIndexToHScript(hero_index)
    return hero
end

--获取英雄名字
function HeroData:GetHeroName(ID)
    if not ID then
        return
    end
    local name = SelectHero.Data[ID].hero_name
    return name
end

--获取英雄复活时间
function HeroData:GetRebornTime(hero)
    local level = hero:GetLevel()
    local time = 5
    if level <= 5 then
        time = 3
    end
    if level >= 6 and level <= 10 then
        time = 4
    end
    if level >= 11 and level <= 15 then
        time = 5
    end
    if level >= 16 and level <= 20 then
        time = 5
    end
    if level >= 21 and level <= 25 then
        time = 5
    end
    if level >= 26 then
        time = 5
    end
    if hero.LastGameState == true then
        time = 5
    end
    if hero:HasModifier("modifier_talent_skill_7") then
        time = time - 2
    end
    local extra = (HeroData.Static and HeroData.Static.reborn_time_extra) or 0
    time = time + extra
    return time
end

function HeroData:GetStar(ID)
    return self.Data[ID].star
end

--是否是机器人
function HeroData:IsBot(ID)
    if not ID then
        return
    end
    local player_data = InitPlayer:GetPlayerData(ID)
    if not player_data then
        return
    end
    return player_data.bot
end
