--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Code:OpenPage(ID)
    self.Data[ID].page = true
end

function Code:ClosePage(ID)
    if not ID then
        return
    end
    -- 仅隐藏界面；保留订单与轮询，避免关窗后支付成功无法弹窗/到账
    self.Data[ID].page = false
    self:SendData(ID)
end

function Code:SetPayTp(ID, num)
    if not ID or not num then
        return
    end
    self.Data[ID].pay_type = num
end

function Code:SetCardLevelGoods(ID, level_count)
    if not ID then
        return false
    end
    local max_n = Shop:GetRemainingBuyableLevels(ID)
    if max_n <= 0 then
        return false
    end
    local n = tonumber(level_count) or 1
    if n < 1 then
        n = 1
    end
    if n > max_n then
        n = max_n
    end
    self.Data[ID].goods = Code.CardLevelProduct
    self.Data[ID].card_level_count = n
    self.Data[ID].price = n * (Code.CardLevelPriceYuan or 5)
    self.Data[ID].goods_name = Code.GoodsName[Code.CardLevelProduct] or "card_level"
    return true
end

function Code:SetGoods(ID, goods_id)
    if not ID or not goods_id then
        return
    end
    local goods_key = "goods_" .. goods_id
    local goods = self.Goods[goods_key]
    self.Data[ID].goods = goods
    self.Data[ID].price = self.GoodsPrice[goods]
    self.Data[ID].goods_name = self.GoodsName[goods]
    self.Data[ID].card_level_count = 0
end

-- 动态礼包等：直接指定服务端 productType / 价格 / 展示名
function Code:SetProductType(ID, product_type, price, goods_name)
    if not ID or not product_type or product_type == "" then
        return false
    end
    self.Data[ID].goods = tostring(product_type)
    self.Data[ID].price = tonumber(price) or 0
    self.Data[ID].goods_name = goods_name and tostring(goods_name) or tostring(product_type)
    self.Data[ID].card_level_count = 0
    return true
end

function Code:SetEwm(ID, data)
    if not ID or not data then
        return
    end
    local ewm_key = "ewm" .. self:GetPayTp(ID)
    local order_key = "order" .. self:GetPayTp(ID)
    self.Data[ID].pay_page = true
    self.Data[ID][ewm_key] = data.qrCodeUrl
    self.Data[ID][order_key] = data.outTradeNo
    self:SendData(ID)
end

function Code:SetOrder(ID)
    if not ID then
        return
    end
end
