--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function AchieveModule:TabToCategory(tab)
    if tab == "recharge" then
        return "pay"
    end
    if tab == "daily" then
        return "day"
    end
    return "hero"
end

function AchieveModule:IsClaimQueueDuplicate(d, category, key)
    if not d or not d.claim_queue then
        return false
    end
    for _, job in ipairs(d.claim_queue) do
        if job.category == category and job.key == key then
            return true
        end
    end
    return false
end

local function achieve_bucket_has_claimable(bucket, claimable_status)
    if not bucket then
        return false
    end
    for _, v in pairs(bucket) do
        if tonumber(v) == claimable_status then
            return true
        end
    end
    return false
end

--- 是否存在可领取成就（英雄/充值/日常 + 可重复日常进度）
function AchieveModule:HasClaimableRewards(ID)
    local d = self.Data[ID]
    if not d or d.enabled ~= true or not d.achieve then
        return false
    end
    local a = d.achieve
    local st = Achieve.Status

    if achieve_bucket_has_claimable(a.herodata, st.CLAIMABLE) then
        return true
    end
    if achieve_bucket_has_claimable(a.paydata, st.CLAIMABLE) then
        return true
    end
    if achieve_bucket_has_claimable(a.daydata, st.CLAIMABLE) then
        return true
    end

    local daystat = a.daystat or {}
    local total_games = math.max(0, math.floor(tonumber(a.games) or 0))
    local total_time = math.max(0, math.floor(tonumber(a.time) or 0))
    local games_spent = math.max(0, math.floor(tonumber(daystat.games_hero_pick_spent) or 0))
    if total_games - games_spent >= 30 then
        return true
    end
    local time_spent = math.max(0, math.floor(tonumber(daystat.time_prophecy_spent) or 0))
    if total_time - time_spent >= 300 then
        return true
    end

    return false
end
