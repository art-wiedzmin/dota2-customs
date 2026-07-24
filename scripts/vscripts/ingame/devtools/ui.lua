--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function DevTools:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    if not self:IsEnabled() then
        return
    end
    if data.tp == "init" then
        self:SendData(ID)
        return
    end
    if data.tp == "run" and data.cmd then
        self:RunCommand(ID, tostring(data.cmd))
    end
end

function DevTools:SendData(ID)
    if not ID or not self:IsEnabled() then
        return
    end
    local manifest = self:GetManifest()
    local payload = {
        enabled = true,
        tool_count = #manifest,
        tools_json = "",
    }
    local ok, enc = pcall(function()
        return JSON.encode(manifest)
    end)
    if ok and enc then
        payload.tools_json = enc
    end
    Util:Send2JsID("UI_DevTools", payload, ID)
end
