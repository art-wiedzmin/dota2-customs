--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


require("ingame.modifier.modifier_clrb_talents")

function InitPlayer:GetPlayerData(ID)
    if not ID then
        return
    end
    local player_key = "player_" .. ID
    if not self.Public.players[player_key] then
        return
    else
        return self.Public.players[player_key]
    end
end

function InitPlayer:SetHeroState(ID, heroname, hero_index)
    if not ID or not heroname then
        return
    end
    local data = self:GetPlayerData(ID)
    data.hero_state = true
    data.hero_name = heroname
    data.hero_index = hero_index
    SelectHero.Data[ID].hero_name = heroname
    local ti = 1
    if SelectHero.Data[ID] and SelectHero.Data[ID].talent_index ~= nil then
        ti = SelectHero:SanitizeTalentIndex(SelectHero.Data[ID].talent_index)
    end
    data.talent_index = ti
    ClrbSyncTalentNettable(ID, ti)
end
