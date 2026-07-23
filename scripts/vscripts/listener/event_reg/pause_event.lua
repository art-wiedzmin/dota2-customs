-- 自定义暂停系统：禁用默认暂停 + 统计次数
local MAX_PAUSE_PER_PLAYER = 2

function CustomSets:InitCustomPause()
    -- 初始化暂停计数
    self.pause_count = {}
    self.pause_state = false
    -- GameRules:SetPauseEnabled(false) -- 禁用系统自带暂停


    CustomGameEventManager:RegisterListener("custom_unpause_request",
        function(_, keys) self:OnCustomUnpauseRequest(keys) end)

end


function CustomSets:OnCustomUnpauseRequest(keys)
    if self.pause_state then
        PauseGame(false)
        self.pause_state=false
        return
    end

    local playerID = keys.PlayerID
    if playerID == nil or playerID < 0 then
        return
    end

    local player = PlayerResource:GetPlayer(playerID)
    -- print("playerIDis",playerID)
    if player == nil then
        return
    end
    local used = self.pause_count[playerID] or 0
    if used >= MAX_PAUSE_PER_PLAYER then
        CustomGameEventManager:Send_ServerToPlayer(player, "custom_pause_result", {
            ok = false,
            msg = "你只可以暂停两次"
        })
        return
    end
    -- print(player)
    self.pause_count[playerID] = used + 1
    self.pause_state = true
    GameRules:SendCustomMessage("<font color='#ffcc00'>" .. playerID .. "</font> 暂停了游戏", 0, 0)

    PauseGame(true)

end
