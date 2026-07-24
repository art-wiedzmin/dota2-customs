--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Server == nil then
    Server = class({})
    require("ingame.Server.Config")
    require("ingame.Server.Set")
    require("ingame.Server.Get")
    require("ingame.Server.Func")
end

-- 初始化玩家数据
function Server:InitID(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

-- 白名单检测
function Server:LoadWhiteList()
    if not IsInToolsMode() and GameRules:IsCheatMode() then
        Util:Send2JsBotsSafe("UI_OverGame", {state = true})
    end
    -- 加载白名单
    Server:GetWhiteList()
    -- 游戏性调整：英雄强度（整局仅拉一次）
    Server:LoadHeroBalance()
    -- 获取排行榜数据
    Rank:LoadServer()
    Timers(0, function()
        local need = false
        for _, v in pairs(utilex:GetAllPlayer()) do
            local d = self.Data[v]
            local aid = PlayerResource:GetSteamAccountID(v)
            if d
                and aid and aid ~= 0
                and (not d.user_state)
                and (not d.login_gave_up)
                and ((d.login_fail_count or 0) < (self.LOGIN_FAIL_MAX or 20))
            then
                need = true
            end
        end
        for k, v in pairs(utilex:GetAllPlayer()) do
            self:CheckUser(v)
        end
        if not need then
            return nil
        end
        return 1
    end)
end

-- 验证白名单
function Server:GetWhiteList()
    local ID = PD.Host
    Http:POST("/whitelist/player", {}, ID, function(keys)
        -- print(keys)
        if keys.code == 200 then
            for k, v in pairs(keys.data) do
                if v then
                    local pid = v.pid
                    table.insert(Server.WList, pid)
                end
            end
        end
    end)
end

-- 游戏性调整：英雄强度配置（开局一次）
function Server:LoadHeroBalance()
    if self.HeroBalanceLoaded or self._heroBalanceRequesting then
        return
    end
    self._heroBalanceRequesting = true
    self.HeroBalanceById = {}
    local ID = PD.Host
    -- 走 /game/hero_balance_list：线上 /heroBalance/list 会错误命中礼包接口
    Http:POST("/game/hero_balance_list", {}, ID, function(keys)
        self._heroBalanceRequesting = false
        self.HeroBalanceLoaded = true
        local n = 0
        if keys and keys.code == 200 and keys.data then
            local rows = keys.data.rows or keys.data
            if type(rows) == "table" then
                for _, row in pairs(rows) do
                    if row and row.hero_id then
                        local hid = tonumber(row.hero_id)
                        if hid then
                            self.HeroBalanceById[hid] = {
                                damage_dealt_pct = math.floor(tonumber(row.damage_dealt_pct) or 0),
                                damage_taken_reduce_pct = math.floor(tonumber(row.damage_taken_reduce_pct) or 0),
                            }
                            n = n + 1
                        end
                    end
                end
            end
        end
        if ClrbHeroBalanceApplyAllPlayers then
            ClrbHeroBalanceApplyAllPlayers()
        end
    end, { allow_no_pid = true })
end

-- 验证白名单
function Server:CheckPlayer(ID)
    if not ID then return end
    local pid = PlayerResource:GetSteamAccountID(ID)
    for k, v in pairs(self.WList) do
        if pid == v then Server.Data[ID].whitelist = true end
    end
    if Server.Data[ID].whitelist then SelectHero:CloseLoad(ID) end
end

-- 验证用户数据
function Server:CheckUser(ID)
    -- print("验证用户")
    if not ID then return end
    if not self.Data[ID] then return end
    -- 验证玩家 Steam 账户 ID 是否有效（避免用户 ID 0）
    local aid = PlayerResource:GetSteamAccountID(ID)
    if not aid or aid == 0 then return end
    -- SelectHero:ExitGame(ID)
    if not IsInToolsMode() and GameRules:IsCheatMode() then
        SelectHero:ExitGame(ID)
    end
    if self.Data[ID].user_state == true then return end
    if self.Data[ID].login_gave_up then return end
    if self.Data[ID].login_inflight then return end
    self.Data[ID].login_inflight = true
    local maxFail = self.LOGIN_FAIL_MAX or 20
    Http:POST("/user/login", {}, ID, function(keys)
        if not self.Data[ID] then
            return
        end
        self.Data[ID].login_inflight = false

        local function onLoginFail()
            local d = self.Data[ID]
            if not d or d.user_state or d.login_gave_up then
                return
            end
            d.login_fail_count = (d.login_fail_count or 0) + 1
            -- print("登录未成功 第 " .. d.login_fail_count .. " 次, 用户ID" .. tostring(ID))
            if d.login_fail_count >= maxFail then
                d.login_gave_up = true
                -- print("登录连续失败 " .. maxFail .. " 次，请求退出, 用户ID" .. tostring(ID))
                if SelectHero and SelectHero.Data and SelectHero.Data[ID] then
                    SelectHero:ExitGame(ID)
                end
            end
        end

        if keys.code == 200 then
            local data = keys.data
            if data and data.accessToken then
                Http:SetPlayerAccessToken(ID, data.accessToken)
            else
                Http:SetPlayerAccessToken(ID, nil)
            end
            if data and data.user then
                self.Data[ID].user_state = true
                self.Data[ID].login_fail_count = 0
                local fo = data.first_recharge_double_open
                if fo == nil then
                    fo = true
                end
                Shop:SetShopServerData(ID, data.user, fo)
                -- 进游戏登录：立刻按当前通行证赛季刷新 UI（称号/特效图 + 截止日期）
                if data.pass_cosmetics and Shop.ApplyPassCosmetics then
                    Shop:ApplyPassCosmetics(ID, data.pass_cosmetics)
                elseif data.season_id and Shop.ApplyPassCosmetics then
                    Shop:ApplyPassCosmetics(ID, {
                        season_id = data.season_id,
                        deadline_text = data.deadline_text,
                    })
                end
                if data.card then
                    Shop:SetCardServerData(ID, data.card)
                else
                    Shop:SendData(ID)
                end
                if Shop and Shop.PushPassSeasonToClient then
                    Shop:PushPassSeasonToClient(ID)
                end
                Person:SetPersonData(ID, data.user)
                KeySet:ApplyUserKeyset(ID, data.user)
                KeySet:SendData(ID)
                if data.user and (data.user.invited ~= nil or data.user.invites or data.user.inviteds) then
                    Invite:LoadInvite(ID, data.user)
                end
                if Shop and Shop.ApplyLoginBag and data.bag then
                    Shop:ApplyLoginBag(ID, data)
                elseif Shop and Shop.SyncOutBag then
                    Shop:SyncOutBag(ID)
                end
                if AchieveModule and AchieveModule.ApplyLoginPayload then
                    AchieveModule:ApplyLoginPayload(ID, data)
                end
                SelectHero:CloseLoad(ID)
                -- print("用户加载成功，用户ID" .. ID)
            else
                -- print("用户加载失败，用户ID" .. ID)
                onLoginFail()
            end
        else
            -- print("服务器加载失败，用户ID" .. ID)
            onLoginFail()
        end
    end)
end
