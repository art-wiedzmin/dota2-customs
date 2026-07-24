--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function HolidayPack:OpenPage(ID)
    if not ID or not self.Data[ID] then
        return
    end
    self.Data[ID].page = true
    self:SendData(ID)
    -- 打开页时再拉一次，避免开局请求尚未返回时只看到空列表
    self:LoadGiftPacks(ID)
end

function HolidayPack:ClosePage(ID)
    if not ID or not self.Data[ID] then
        return
    end
    self.Data[ID].page = false
    self:SendData(ID)
end

function HolidayPack:ApplyUserFields(ID, user)
    if not ID or not user or not self.Data[ID] then
        return
    end
    if user.dw_free_day ~= nil then
        self.Data[ID].dw_free_day = user.dw_free_day
    end
    if user.dw_30_buy ~= nil then
        self.Data[ID].dw_30_buy = user.dw_30_buy
    end
    if user.dw_68_buy ~= nil then
        self.Data[ID].dw_68_buy = user.dw_68_buy
    end
    if user.dw_128_buy ~= nil then
        self.Data[ID].dw_128_buy = user.dw_128_buy
    end
    if user.dw_free_open ~= nil then
        self.Data[ID].dw_free_open = user.dw_free_open == true or user.dw_free_open == 1
    end
    if user.dw_free_event_status ~= nil then
        self.Data[ID].dw_free_event_status = user.dw_free_event_status
    end
    if self.Data[ID].page then
        self:SendData(ID)
    end
end

function HolidayPack:OnShopDataUpdated(ID)
    if not ID or not Shop or not Shop.Data or not Shop.Data[ID] then
        return
    end
    if not self.Data[ID] then
        return
    end
    local sd = Shop.Data[ID]
    self.Data[ID].dw_free_day = sd.dw_free_day
    self.Data[ID].dw_free_open = sd.dw_free_open
    self.Data[ID].dw_free_event_status = sd.dw_free_event_status
    self.Data[ID].dw_30_buy = sd.dw_30_buy
    self.Data[ID].dw_68_buy = sd.dw_68_buy
    self.Data[ID].dw_128_buy = sd.dw_128_buy
    if self.Data[ID].page then
        self:SendData(ID)
    end
end
