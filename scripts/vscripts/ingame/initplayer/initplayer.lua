--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if InitPlayer == nil then
    InitPlayer = class({})
    require("ingame.BotAI.BotAI")
    require("ingame.InitPlayer.Config")
    require("ingame.InitPlayer.Set")
    require("ingame.InitPlayer.Get")
    require("ingame.InitPlayer.Func")
end

--加载游戏
function InitPlayer:Init_Public()
    if self.Public.game_state then
        return
    end
    self.Public.game_state = true
end

--加载玩家
function InitPlayer:Init_Player()
    if self.Public.player_state then
        return
    end
    self.Public.player_state = true
end

--加载英雄
function InitPlayer:Init_Hero()
    if self.Public.hero_state then
        return
    end
    self.Public.hero_state = true
end

--加载玩家
function InitPlayer:Init_ID_And_Server()
    --加载玩家
    Util:F5Player()
    Util:InitAllPlayers()
    for i = 1, #PD.IDs do
        local ID = PD.IDs[i]
        if not self:GetPlayerData(ID) then
            self:InitPlayerData(ID, i)
            self:Init_ID(ID)
            Box:InitDummy(ID)
        end
    end
end

--加载玩家数据
function InitPlayer:InitPlayerData(ID, index)
    if not ID or not index then
        return
    end
    local player_key = "player_" .. ID
    local old_data = self.Public.players[player_key]
    self.Public.players[player_key] = Util:DeepCopyTab(self.PlayerTemp)
    self.Public.players[player_key].id = ID
    self.Public.players[player_key].index = index
    self.Public.players[player_key].state = true
    self.Public.players[player_key].online = true
    -- 注意：old_data.team 可能在早期初始化时是 -1/0，后续即使引擎分配了阵营也不会被刷新
    -- 这里只在 old_data.team 是有效阵营号时才沿用，否则强制从 PlayerResource 取一次
    if old_data and old_data.team and old_data.team > 1 then
        self.Public.players[player_key].team = old_data.team
    else
        -- 机器人/伪玩家也需要正确的阵营号，否则计分板/结算无法归队
        local t = PlayerResource and PlayerResource.GetTeam and PlayerResource:GetTeam(ID) or nil
        if t == nil and Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
            t = -1
        end
        self.Public.players[player_key].team = t
    end
    local init_pos = Util:TabRandom(self.Public.hero_pos)
    self.Public.players[player_key].init_pos = init_pos
    for k, v in pairs(self.Public.hero_pos) do
        if init_pos == v then
            self.Public.hero_pos[k] = nil
        end
    end
end
