--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Http == nil then
    Http = class({})
    require("ingame.Http.Config")
    require("ingame.Http.Get")
    require("ingame.Http.Set")
    
end

--初始化
function Http:Init()
    -- print("设置网络")
    -- ToolsMode 也走线上服（与 Config.tp=2 / serverip 一致）；勿自动切 127.0.0.1
    --self:SetTp()
    self:SetSecretKey()
    self:SetIp()
    self:SetPort()
    self:SetUrl()
end

-- 服务端 JWT（GAME_JWT_SECRET）：/user/login 下发的 accessToken，按玩家槽位保存
function Http:SetPlayerAccessToken(ID, token)
    if not ID then
        return
    end
    self._accessToken = self._accessToken or {}
    self._accessToken[ID] = token
end

function Http:GetPlayerAccessToken(ID)
    if not ID then
        return nil
    end
    self._accessToken = self._accessToken or {}
    return self._accessToken[ID]
end

--设置请求头
function Http:SetHeaders(ID, req)
    req:SetHTTPRequestHeaderValue("secretkey", self:GetSecretKey())
    local token = self:GetPlayerAccessToken(ID)
    if token and token ~= "" then
        req:SetHTTPRequestHeaderValue("Authorization", "Bearer " .. token)
    end
    --req:SetHTTPRequestHeaderValue("modeltp", self:GetTp())
end

--GET
function Http:GET(router, tab, ID, fun)
    --必须加入有效玩家AID
    --tab = self:AddPlayerID(tab, ID)
    if not tab then return end
    --拼接路由
    local url = self:GetUrl() .. router
    --print(url)
    if not url then return end
    local req = CreateHTTPRequest("GET", url)
    --req.headers(密钥+游戏版本)
    self:SetHeaders(ID, req)
    --req.query
    if tab then
        for k, v in pairs(tab) do
            req:SetHTTPRequestGetOrPostParameter(k, tostring(v))
        end
    end
    --60秒超时
    req:SetHTTPRequestAbsoluteTimeoutMS(60000)
    --回调
    req:Send(function(keys)
        -- print("------------------")
        self:SeverCallBack(keys, ID, fun)
    end)
end

--POST
-- opts.allow_no_pid：白名单/英雄强度等公开接口，Host 尚无 SteamID 时仍可请求
function Http:POST(router, tab, ID, fun, opts)
    opts = opts or {}
    tab = tab or {}
    if type(tab) ~= "table" then
        return
    end
    if opts.allow_no_pid then
        if ID and PlayerResource:IsValidPlayer(ID) then
            local aid = PlayerResource:GetSteamAccountID(ID)
            if aid and aid ~= 0 then
                tab.pid = aid
            end
        end
    else
        tab = self:AddPlayerID(tab, ID)
        if not tab then return end
    end
    -- 服务端开启 JWT 时随 JSON 一并传 accessToken（与 Authorization 头二选一即可）
    local token = self:GetPlayerAccessToken(ID)
    if token and token ~= "" then
        tab.accessToken = token
    end
    --拼接路由
    local url = self:GetUrl() .. router
    if not url then return end
    local req = CreateHTTPRequest("POST", url)
    --req.headers(密钥+游戏版本)
    self:SetHeaders(ID, req)
    --req.body
    req:SetHTTPRequestRawPostBody("application/json", JSON.encode(tab))
    --60秒超时
    req:SetHTTPRequestAbsoluteTimeoutMS(60000)
    --回调
    req:Send(function(keys)
        self:SeverCallBack(keys, ID, fun)
    end)
end

--回调处理
function Http:SeverCallBack(keys, ID, fun)
    --print(keys)
    local body = keys.Body
    local scode = keys.StatusCode
    --print(body)
    --print(scode)
    --直接失败
    if not body or not scode then
        pcall(function() fun({ code = 0 }) end)
        return
    end

    --DOTA系统判定此次连接失败
    if not scode or scode ~= 200 then
        pcall(function() fun({ code = 0 }) end)
        return
    end
    --响应成功 则转码送入回调
    local tab = {}
    local success, json = pcall(function() return JSON.decode(body) end)
    if success then tab = json end
    if tab == nil then
        tab = {}
    end
    -- print("============")
    --执行正确回调
    if type(fun) == "function" then
        pcall(function() fun(tab) end)
    end
end

--每次给数据默认加入玩家ID
function Http:AddPlayerID(tab, ID)
    if not tab or not ID then return end
    if not PlayerResource:IsValidPlayer(ID) then return end
    if type(tab) ~= "table" then return end
    local aid = PlayerResource:GetSteamAccountID(ID)
    if not aid or aid == 0 then return end
    tab.pid = aid
    return tab
end

--较验本条数据的AID是否匹配
function Http:VerifyAid(ID, aid)
    if not ID or not aid then return end
    if type(ID) ~= "number" or type(aid) ~= "number" then
        return
    end
    if not PlayerResource:IsValidPlayer(ID) then return end
    local localaid = PlayerResource:GetSteamAccountID(ID)
    if aid == localaid then return true end
end
