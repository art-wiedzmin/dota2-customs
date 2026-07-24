--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function DevTools:IsEnabled()
    return IsInToolsMode() == true
end

function DevTools:GetManifest()
    self:InitRegistry()
    local list = {}
    for _, entry in pairs(self.Registry) do
        if entry.show_in_panel then
            list[#list + 1] = {
                cmd = entry.cmd,
                label = entry.label,
                group = entry.group,
            }
        end
    end
    table.sort(list, function(a, b)
        if a.group ~= b.group then
            return tostring(a.group) < tostring(b.group)
        end
        return tostring(a.label) < tostring(b.label)
    end)
    return list
end
