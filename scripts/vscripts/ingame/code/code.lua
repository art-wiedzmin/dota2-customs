--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Code == nil then
    Code = class({})
    require("ingame.Code.Config")
    require("ingame.Code.Set")
    require("ingame.Code.Get")
    require("ingame.Code.Ui")
end

function Code:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

local CODE_PAY_POLL_PREFIX = "code_paypoll_"
local CODE_PAY_POLL_INTERVAL = 2
local CODE_PAY_POLL_MAX_DURATION = 600

function Code:StopPaymentStatusPoll(ID)
    if ID == nil then
        return
    end
    Timers:RemoveTimer(CODE_PAY_POLL_PREFIX .. tostring(ID))
end

-- 轮询查单：未成单不关闭页面，网络异常不弹窗。
function Code:RequestPaymentStatus(ID)
    if not ID then
        return
    end
    local order_key = "order" .. self:GetPayTp(ID)
    local order = self.Data[ID][order_key]
    if order == "" then
        self:StopPaymentStatusPoll(ID)
        return
    end
    Http:POST("/payment/status", { outTradeNo = order }, ID, function(keys)
        local d = Code.Data[ID]
        if not d or d[order_key] ~= order then
            return
        end
        if keys.code == 200 then
            local data = keys.data
            if data.status == "SUCCESS" then
                self:StopPaymentStatusPoll(ID)
                Msgs:PopRedeemSuccess(ID, "充值成功", self:PayRewardRows(ID))
                self:ClearCode(ID)
                Shop:LoadShop(ID)
                if HolidayPack and HolidayPack.LoadGiftPacks then
                    HolidayPack:LoadGiftPacks(ID)
                end
            end
        end
    end)
end

function Code:StartPaymentStatusPoll(ID)
    if not ID or not self.Data[ID] then
        return
    end
    self:StopPaymentStatusPoll(ID)
    local tid = CODE_PAY_POLL_PREFIX .. tostring(ID)
    local t0 = Time()
    -- 先发一次请求，再配合定时重复
    self:RequestPaymentStatus(ID)
    Timers:CreateTimer(tid, {
        useGameTime = false,
        endTime = CODE_PAY_POLL_INTERVAL,
        callback = function()
            local d = Code.Data[ID]
            if not d or d.pay_page ~= true then
                return nil
            end
            if Time() - t0 >= CODE_PAY_POLL_MAX_DURATION then
                Code:StopPaymentStatusPoll(ID)
                return nil
            end
            Code:RequestPaymentStatus(ID)
            return CODE_PAY_POLL_INTERVAL
        end
    })
end

function Code:Pay(ID, pay_tp)
    if not ID or not pay_tp then
        return
    end
    self:StopPaymentStatusPoll(ID)
    --打开页面
    self:OpenPage(ID)
    --设置支付方式
    self:SetPayTp(ID, pay_tp)
    local pay_list = {
        productType = self:GetGoods(ID),
        paymentMethod = self:GetPayTp(ID)
    }
    if self.Data[ID].goods == Code.CardLevelProduct then
        pay_list.levelCount = self.Data[ID].card_level_count or 1
    end
    if self.Data[ID].goods == "" then
        return
    end
    Http:POST("/payment/create", pay_list, ID, function(keys)
        --print(keys)
        if keys.code == 200 then
            local data = keys.data
            -- print(data)
            self:SetEwm(ID, data)
            self:SendData(ID)
            self:StartPaymentStatusPoll(ID)
        else
            local msg = nil
            if keys and keys.data and keys.data.message then
                msg = keys.data.message
            elseif keys and keys.message and keys.message ~= "" then
                msg = keys.message
            end
            Msgs:Pop(ID, msg or "网络异常")
        end
    end)
end

function Code:PayType(ID, tp)
    if not ID or not tp then
        return
    end
    if tp == self:GetPayTp(ID) then
        return
    end
    local ewm_key = "ewm" .. tp
    if self.Data[ID][ewm_key] == "" then
        Code:Pay(ID, tp)
    else
        self:SetPayTp(ID, tp)
        self:SendData(ID)
    end
end

function Code:ClearCode(ID)
    if not ID then
        return
    end
    self:StopPaymentStatusPoll(ID)
    --关闭页面
    self.Data[ID].page = false
    self.Data[ID].goods = ""
    self.Data[ID].price = 0
    self.Data[ID].goods_name = ""
    self.Data[ID].card_level_count = 0
    self.Data[ID].pay_tp = -1
    self.Data[ID].order1 = ""
    self.Data[ID].order2 = ""
    self.Data[ID].pay_page = false
    self.Data[ID].ewm1 = ""
    self.Data[ID].ewm2 = ""
    self:SendData(ID)
end
