--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function DevTools:RegisterChat()
    if self._chat_registered then
        return
    end
    ListenToGameEvent("player_chat", Dynamic_Wrap(self, "OnPlayerChat"), self)
    self._chat_registered = true
end

function DevTools:ParseChatKeys(keys)
    local ID = keys.playerid
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    local text = string.lower(keys.text or "")
    return Util:Split(text, " ")
end

function DevTools:OnPlayerChat(keys)
    local ID = keys.playerid
    local tab = self:ParseChatKeys(keys)
    if not tab or not tab[1] then
        return
    end
    local cmd = tab[1]

    if keys.teamonly == 0 then
        if cmd == "我是萌新" or cmd == "我是菜鸟" then
            self:RunCommand(ID, cmd)
            return
        end
    end

    if cmd == "-zs" then
        self:RunCommand(ID, cmd)
        return
    end

    if not self:IsEnabled() then
        return
    end

    self:RunCommand(ID, cmd)
end
