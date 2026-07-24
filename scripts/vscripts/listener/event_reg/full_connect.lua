--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--[[
{
	PlayerID  (string)= 0  (number)
	game_event_listener  (string)= 50331654  (number)
	game_event_name  (string)= player_connect_full  (string)
	index  (string)= 1  (number)
	splitscreenplayer  (string)= -1  (number)
	userid  (string)= 0  (number)
	userid_pawn  (string)= 389349739  (number)
}
]]
function CustomSets:Full_Connect(keys)
    local ID = keys and keys.PlayerID
    if ID == nil then
        return true
    end
    ID = tonumber(ID)
    if not ID or ID < 0 then
        return true
    end

    -- player_reconnected 早于客户端完全就绪；connect_full 后再绑英雄并推金币
    Timers(0.5, function()
        if not GameRules or not GameRules.State_Get then
            return
        end
        local state = GameRules:State_Get()
        if state == nil or state < DOTA_GAMERULES_STATE_PRE_GAME then
            return
        end
        if not PlayerResource or not PlayerResource.IsValidPlayer or not PlayerResource:IsValidPlayer(ID) then
            return
        end
        if InitPlayer and InitPlayer.GetPlayerData and SelectHero and SelectHero.ApplyEnginePickForPlayer then
            local d = InitPlayer:GetPlayerData(ID)
            if d and (not d.bot) and d.hero_name and d.hero_name ~= "" then
                SelectHero:ApplyEnginePickForPlayer(ID, d.hero_name, false)
            end
        end
        if InitPlayer and InitPlayer.ReconnectFullInitAndSync then
            InitPlayer:ReconnectFullInitAndSync(ID)
        end
        if Util and Util.ClrbSchedulePlayerGoldResync then
            Util:ClrbSchedulePlayerGoldResync(ID)
        end
    end)

    return true
end