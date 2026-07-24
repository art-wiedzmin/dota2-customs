--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 结算称号
function MainGame:SetTag()
    -- Mvp
    self:SetTag1()
    self:SetTag4()
    self:SetTag6()
    self:SetTag8()
    self:SetTag9()
    self:SetTag10()
    self:SetTag11()
    self:SetTag13()
    self:SetTag14()
    self:SetTag15()
end

-- mvp
function MainGame:SetTag1()
    if MainGame:GetGameType() == 1 or MainGame:GetGameType() == 3 then
        local win_team = self.Data.win_team
        local win_team_key = "team_" .. win_team
        local list = {}
        for k, v in pairs(Stat.Public.list[win_team_key].list) do
            if v then
                local ID = v.id
                local p_id = "p_" .. ID
                local kk = PlayerResource:GetKills(ID)
                local dd = PlayerResource:GetDeaths(ID)
                local aa = PlayerResource:GetAssists(ID)
                if dd <= 0 then dd = 1 end
                local kda_num = ((kk + aa) / dd)
                local kda = utilex:FloatSet(kda_num, 1)
                list[p_id] = kda
            end
        end
        -- print(list)
        local max_id = utilex:GetMaxKeyInTab(list)
        local mvp_id = tonumber(utilex:splitIndex(max_id, "_", 2))
        HeroData.Data[mvp_id].tag.tag1 = true
    end
    if MainGame:GetGameType() == 2 then
        for k, v in pairs(PD.IDs) do
            if v then
                local ID = v
                local rank = Stat:GetTeamRank(ID)
                if rank == 1 then
                    HeroData.Data[ID].tag.tag1 = true
                    return
                end
            end
        end
    end
end

-- 神
-- 暴
-- 硬
function MainGame:SetTag4()
    local list = {}
    for k, v in pairs(PD.IDs) do
        local p_id = "p_" .. v
        list[p_id] = HeroData.Data[v].tank
    end
    local max_id = utilex:GetMaxKeyInTab(list)
    local mvp_id = tonumber(utilex:splitIndex(max_id, "_", 2))
    HeroData.Data[mvp_id].tag.tag4 = true
end

-- 杀
-- 僵
function MainGame:SetTag6()
    local list = {}
    for k, v in pairs(PD.IDs) do
        local p_id = "p_" .. v
        local kk = PlayerResource:GetKills(v)
        local dd = PlayerResource:GetDeaths(v)
        local aa = PlayerResource:GetAssists(v)
        if dd <= 0 then dd = 1 end
        local kda_num = ((kk + aa) / dd)
        local kda = utilex:FloatSet(kda_num, 1)
        list[p_id] = kda
    end
    local max_id = utilex:GetMinKeyInTab(list)
    local mvp_id = tonumber(utilex:splitIndex(max_id, "_", 2))
    HeroData.Data[mvp_id].tag.tag6 = true
end

-- 逃
-- 伐木
function MainGame:SetTag8()
    local list = {}
    for k, v in pairs(PD.IDs) do
        if v then
            local p_id = "p_" .. v
            list[p_id] = Talent.Data[v].kill
        end
    end
    local max_id = utilex:GetMaxKeyInTab(list)
    local mvp_id = tonumber(utilex:splitIndex(max_id, "_", 2))
    HeroData.Data[mvp_id].tag.tag8 = true
end

-- 力
function MainGame:SetTag9()
    local list = {}
    for k, v in pairs(PD.IDs) do
        if v then
            local hero = Util:ID2Hero(v)
            if hero then
                local p_id = "p_" .. v
                local num = hero:GetStrength()
                list[p_id] = num
            end
        end
    end
    local max_id = utilex:GetMaxKeyInTab(list)
    local mvp_id = tonumber(utilex:splitIndex(max_id, "_", 2))
    HeroData.Data[mvp_id].tag.tag9 = true
end

-- 敏
function MainGame:SetTag10()
    local list = {}
    for k, v in pairs(PD.IDs) do
        if v then
            local hero = Util:ID2Hero(v)
            if hero then
                local p_id = "p_" .. v
                local num = hero:GetAgility()
                list[p_id] = num
            end
        end
    end
    local max_id = utilex:GetMaxKeyInTab(list)
    local mvp_id = tonumber(utilex:splitIndex(max_id, "_", 2))
    HeroData.Data[mvp_id].tag.tag10 = true
end

-- 智
function MainGame:SetTag11()
    local list = {}
    for k, v in pairs(PD.IDs) do
        if v then
            local hero = Util:ID2Hero(v)
            if hero then
                local p_id = "p_" .. v
                local num = hero:GetIntellect(false)
                list[p_id] = num
            end
        end
    end
    local max_id = utilex:GetMaxKeyInTab(list)
    local mvp_id = tonumber(utilex:splitIndex(max_id, "_", 2))
    HeroData.Data[mvp_id].tag.tag11 = true
end

-- 贪
function MainGame:IsStar16(ID, star)
    if self.Data.star_max_state == true then return end
    -- 显示 16 星 = 真实 13（含 3 颗假星星）
    local bonus = (HeroData.Static and HeroData.Static.star_display_bonus) or 3
    if star + bonus >= 16 then
        HeroData.Data[ID].tag.tag12 = true
        self.Data.star_max_state = true
    end
end

-- 无双
function MainGame:SetTag13()
    local list = {}
    for k, v in pairs(PD.IDs) do
        local p_id = "p_" .. v
        local kk = PlayerResource:GetKills(v)
        local dd = PlayerResource:GetDeaths(v)
        local aa = PlayerResource:GetAssists(v)
        local kda_num = ((kk + aa) / dd)
        local kda = utilex:FloatSet(kda_num, 1)
        if kda > 15 then HeroData.Data[v].tag.tag13 = true end
    end
end

-- 夯
function MainGame:SetTag14()
    for k, v in pairs(PD.IDs) do
        local damage = HeroData.Data[v].damage
        if damage > 666666 then HeroData.Data[v].tag.tag14 = true end
    end
end

-- 狂
function MainGame:SetTag15()
    local list = {}
    for k, v in pairs(PD.IDs) do
        local p_id = "p_" .. v
        local kk = PlayerResource:GetKills(v)
        local dd = PlayerResource:GetDeaths(v)
        local kda = kk + dd
        list[p_id] = kda
    end
    local max_id = utilex:GetMaxKeyInTab(list)
    local mvp_id = tonumber(utilex:splitIndex(max_id, "_", 2))
    HeroData.Data[mvp_id].tag.tag15 = true
end

-- 打开传送门
function MainGame:OpenDoor(doorskey)
    if not doorskey then return end
    local tx = self.Static.doors_tx
    for k, v in pairs(self.Data.door[doorskey]) do
        if v then
            local name = v.name
            local pos = v.pos
            local tx_index = utilex:AddParticllesPos(tx, pos, 9999)
            v.tx = tx_index
            v.state = true
            self:DoorsThink(doorskey, name, pos)
        end
    end
end

function MainGame:DoorsThink(doors, name, pos)
    if not name then return end
    Timers(0.2, function()
        if self.Data.door[doors][name].state == true then
            local units =
                FindUnitsInRadius(DOTA_TEAM_NOTEAM, -- 相对队伍，设为DOTA_TEAM_NONE表示不限制相对关系，由targetTeam控制
                    pos,                            -- 搜索中心点
                    nil,                            -- 缓存单位，通常填nil
                    350,                            -- 搜索半径
                    DOTA_UNIT_TARGET_TEAM_BOTH,     -- 目标队伍（敌方/友方/双方）
                    DOTA_UNIT_TARGET_HERO,          -- 目标类型：英雄
                    DOTA_UNIT_TARGET_FLAG_NONE,     -- 额外标志
                    FIND_ANY_ORDER,                 -- 顺序
                    false                           -- 是否缓存
                )
            if #units > 0 then
                for k, v in pairs(units) do
                    if v and not v:IsNull() and v:IsHero()
                        and Util and Util.IsPlayerHeroForData and Util:IsPlayerHeroForData(v) then
                        local hero = v
                        local ID = Util:Hero2ID(hero)
                        local target_pos = self:GetDoorTarget(name)
                        hero:SetAbsOrigin(target_pos)
                        FindClearSpaceForUnit(hero, target_pos, true)
                        local inv = (self.Static and self.Static.door_teleport_invuln) or 0.1
                        hero:RemoveModifierByName("modifier_clrb_door_teleport_invuln")
                        hero:AddNewModifier(hero, nil, "modifier_clrb_door_teleport_invuln",
                            { duration = inv })
                        EmitSoundOn("LoneDruid_SpiritBear.ReturnStart", hero)
                        -- 仅真人本体英雄移动镜头（ID 须为有效 PlayerID）
                        if ID ~= nil and type(ID) == "number" and ID >= 0
                            and PlayerResource and PlayerResource.IsValidPlayer
                            and PlayerResource:IsValidPlayer(ID)
                            and not Util:IsPseudoPlayerID(ID) then
                            local init_data = InitPlayer and InitPlayer.GetPlayerData
                                and InitPlayer:GetPlayerData(ID)
                            if init_data and not init_data.bot then
                                PlayerResource:SetCameraTarget(ID, hero)
                                local cam_id = ID
                                Timers(0.5, function()
                                    if PlayerResource and cam_id ~= nil then
                                        PlayerResource:SetCameraTarget(cam_id, nil)
                                    end
                                end)
                            end
                        end
                    end
                end
                self:CloseDoor(doors)
                return
            end
        end
        return 1
    end)
end

-- 关闭传送门
function MainGame:CloseDoor(doorskey)
    for k, v in pairs(self.Data.door[doorskey]) do
        if v then
            v.state = false
            local tx = v.tx
            utilex:ClearTx(tx)
            v.tx = -1
        end
    end
    Timers(self.Static.doors_cd, function() self:OpenDoor(doorskey) end)
end

-- 清理传送们
function MainGame:ClearDoor()
    for k, v in pairs(self.Data.door) do
        if v then
            for k2, v2 in pairs(v) do
                if v2 then
                    v2.state = false
                    utilex:ClearTx(v2.tx)
                    v2.tx = -1
                end
            end
        end
    end
end
