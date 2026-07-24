--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 成就领取：单飞 + 队列 + 冷却，避免连续点击频繁请求服务端

local ACHIEVE_CLAIM_COOLDOWN = 0.45
local ACHIEVE_CLAIM_TIMER_PREFIX = "achieve_claim_pump_"

function AchieveModule:EnqueueClaim(ID, category, key)
    if not ID or not category or not key then
        return
    end
    local d = self.Data[ID]
    if not d or d.enabled ~= true then
        if Msgs and Msgs.Pop then
            Msgs:Pop(ID, "成就未开放")
        end
        return
    end

    if not d.claim_queue then
        d.claim_queue = {}
    end

    if self:IsClaimQueueDuplicate(d, category, key) then
        return
    end

    d.claim_queue[#d.claim_queue + 1] = {
        category = category,
        key = key,
    }

    self:PumpClaimQueue(ID)
end

function AchieveModule:PumpClaimQueue(ID)
    local d = self.Data[ID]
    if not d or d.enabled ~= true then
        return
    end

    if d.claim_inflight == true then
        return
    end

    local now = Time()
    if d.claim_cooldown_until and now < d.claim_cooldown_until then
        local tid = ACHIEVE_CLAIM_TIMER_PREFIX .. tostring(ID)
        Timers:RemoveTimer(tid)
        Timers:CreateTimer(tid, {
            useGameTime = false,
            endTime = d.claim_cooldown_until - now,
            callback = function()
                self:PumpClaimQueue(ID)
                return nil
            end,
        })
        return
    end

    if not d.claim_queue or #d.claim_queue == 0 then
        return
    end

    local job = table.remove(d.claim_queue, 1)
    d.claim_inflight = true

    Http:POST("/achieve/claim", {
        category = job.category,
        key = job.key,
    }, ID, function(keys)
        d.claim_inflight = false
        d.claim_cooldown_until = Time() + ACHIEVE_CLAIM_COOLDOWN

        if keys and keys.code == 200 and keys.data then
            self:ApplyClaimResult(ID, keys.data, "领取成功")
        else
            local msg = "领取失败"
            if keys and keys.message and keys.message ~= "" then
                msg = keys.message
            end
            if Msgs and Msgs.Pop then
                Msgs:Pop(ID, msg)
            end
            self:SendData(ID)
        end

        local tid = ACHIEVE_CLAIM_TIMER_PREFIX .. tostring(ID)
        Timers:RemoveTimer(tid)
        Timers:CreateTimer(tid, {
            useGameTime = false,
            endTime = ACHIEVE_CLAIM_COOLDOWN,
            callback = function()
                self:PumpClaimQueue(ID)
                return nil
            end,
        })
    end)
end
