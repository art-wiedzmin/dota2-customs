--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function HolidayPack:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    if data.tp == "init" then
        self:SendData(ID)
    end
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    if data.tp == "Free" or data.tp == "ClaimFreeGift" then
        -- 免费礼包：与端午同一条 /user/free 领取链路
        self:Free(ID)
        return
    end
    if data.tp == "Pay" then
        self:Pay(ID, data.text)
    end
    if data.tp == "PayGift" or data.tp == "ClickGift" then
        self:PayGift(ID, data.text)
    end
end

function HolidayPack:SendData(ID)
    if not ID then
        return
    end
    local src = self.Data[ID]
    if not src then
        return
    end
    -- CustomGameEvent 对嵌套数组不可靠，礼包列表用 JSON 字符串下发
    local payload = {
        page = src.page and true or false,
        dw_free_day = src.dw_free_day,
        dw_free_open = src.dw_free_open,
        dw_free_event_status = src.dw_free_event_status,
        dw_30_buy = src.dw_30_buy,
        dw_68_buy = src.dw_68_buy,
        dw_128_buy = src.dw_128_buy,
        gift_packs_json = "[]",
        gift_buy_counts_json = "{}",
        gift_free_claimed_json = "{}",
    }
    local packs = src.gift_packs
    if type(packs) == "table" then
        local ok, enc = pcall(function()
            return JSON.encode(packs)
        end)
        if ok and enc then
            payload.gift_packs_json = enc
        end
    end
    local counts = src.gift_buy_counts
    if type(counts) == "table" then
        local ok2, enc2 = pcall(function()
            return JSON.encode(counts)
        end)
        if ok2 and enc2 then
            payload.gift_buy_counts_json = enc2
        end
    end
    local free_claimed = src.gift_free_claimed
    if type(free_claimed) == "table" then
        local ok3, enc3 = pcall(function()
            return JSON.encode(free_claimed)
        end)
        if ok3 and enc3 then
            payload.gift_free_claimed_json = enc3
        end
    end
    Util:Send2JsID("UI_HolidayPack", payload, ID)
end
