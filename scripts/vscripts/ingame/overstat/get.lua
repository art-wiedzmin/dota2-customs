--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 本地化/展示名辅助（服务端无 Panorama，失败时返回空串或原名）

function OverStat:GetGameTimeDota()
    local gr = GameRules
    if gr and gr.GetDOTATime then
        return gr:GetDOTATime(true, true)
    end
    return 0
end

function OverStat:ItemTitleZh(item_name)
    if not item_name or item_name == "" then
        return ""
    end
    local key = "DOTA_Tooltip_ability_" .. item_name
    local gr = GameRules
    if gr and type(gr.GetLocalizedString) == "function" then
        local ok, s = pcall(function()
            return gr:GetLocalizedString(key)
        end)
        if ok and s and s ~= "" and s ~= key then
            return s
        end
    end
    return ""
end

function OverStat:AbilityTitleZh(ability_name)
    if not ability_name or ability_name == "" then
        return ""
    end
    local key = "DOTA_Tooltip_ability_" .. ability_name
    local gr = GameRules
    if gr and type(gr.GetLocalizedString) == "function" then
        local ok, s = pcall(function()
            return gr:GetLocalizedString(key)
        end)
        if ok and s and s ~= "" and s ~= key then
            return s
        end
    end
    return ""
end
