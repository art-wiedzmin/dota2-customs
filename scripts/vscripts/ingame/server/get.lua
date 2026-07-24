--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Server:IsWhiteList(ID)
    return Server.Data[ID].whitelist
end

function Server:IsAllWhiteList()
    for k, v in pairs(utilex:GetAllPlayer()) do
        if not self:IsWhiteList(v) then
            return false
        end
    end
end

--- 新一局开始时清空本局错误上报去重表
function Server:ResetClientLogDedup()
    self._client_log_sent_match = {}
end

--- 本局去重键：优先 source；无 source 时用首行摘要
function Server:ClientLogDedupKey(source, text)
    local src = tostring(source or "")
    if src ~= "" then
        return src
    end
    local first = string.match(text, "^[^\n]+") or text
    if #first > 256 then
        first = string.sub(first, 1, 256)
    end
    return first
end

--- 将客户端 Lua 异常栈发到服务端落日志（POST /game/client_log，与 Http 其它接口同 Header secretkey）
--- 每局每种错误（按 source / 首行）只上报一次
--- @param err_text string|any xpcall 第二返回值或任意可 tostring 内容
--- @param source string|nil 可选，如 "MainGame:StartTime"、"MainGame:EventTrigger:map1"
function Server:SendError(err_text, source)
    if err_text == nil then
        return
    end
    local text = tostring(err_text)
    if text == "" then
        return
    end
    if #text > 12000 then
        text = string.sub(text, 1, 12000) .. "\n...[truncated]"
    end
    local src = tostring(source or "")

    self._client_log_sent_match = self._client_log_sent_match or {}
    local key = self:ClientLogDedupKey(src, text)
    if self._client_log_sent_match[key] then
        return
    end
    self._client_log_sent_match[key] = true

    local ID = PD and PD.Host
    if not ID or not PlayerResource:IsValidPlayerID(ID) then
        local players = utilex and utilex.GetAllPlayer and utilex:GetAllPlayer()
        if players then
            for _, pid in pairs(players) do
                if pid ~= nil and PlayerResource:IsValidPlayerID(pid) then
                    ID = pid
                    break
                end
            end
        end
    end
    if not ID or not PlayerResource:IsValidPlayerID(ID) then
        return
    end

    local body = {
        message = text,
        source = src,
        log_level = "error",
    }
    if MainGame and MainGame.GetTime then
        body.game_time_sec = MainGame:GetTime()
    end
    if GetMapName then
        body.map_name = GetMapName()
    end
    if MainGame and MainGame.GetGameType then
        body.game_type = MainGame:GetGameType()
    end
    Http:POST("/game/client_log", body, ID, function()
    end)
end