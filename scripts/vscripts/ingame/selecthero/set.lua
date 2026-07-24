--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 客户端高亮某槽但未确定时同步；刷新列表后在 AddHeroToList 内清零
function SelectHero:SetPreviewSlot(ID, slot)
    if not ID or not self.Data[ID] then
        return
    end
    if self.Data[ID].hero_state then
        return
    end
    local s = tonumber(slot)
    if not s or s < 1 or s > 3 then
        self.Data[ID].pending_slot = 0
        return
    end
    self.Data[ID].pending_slot = math.floor(s)
end

function SelectHero:OpenPage(ID)
    if not ID then
        return
    end
    self.Data[ID].page = true
    self:SendData(ID)
end

function SelectHero:ClosePage(ID)
    if not ID then
        return
    end
    self.Data[ID].page = false
    self:SendData(ID)
end

function SelectHero:OpenLoad(ID)
    if not ID then
        return
    end
    self.Data[ID].load = true
    self:SendData(ID)
end

function SelectHero:CloseLoad(ID)
    if not ID then
        return
    end
    -- print("关闭加载页面")
    self.Data[ID].load = false
    self:SendData(ID)
end

--- 月卡/季卡各 1 次资格（随 Shop 读库更新；选人阶段可能晚于 HeroPage 才就绪）
function SelectHero:CardBonusEligible(ID)
    if not ID or not Shop.Data[ID] then
        return 0
    end
    local n = 0
    if Shop.Data[ID].card1 > 0 then
        n = n + 1
    end
    if Shop.Data[ID].card2 > 0 then
        n = n + 1
    end
    return n
end

--- 仍可用的月卡/季卡免费次数（不占金豆档位，不扣 refresh）
function SelectHero:GetCardFreeLeft(ID)
    if not ID or not self.Data[ID] then
        return 0
    end
    local el = self:CardBonusEligible(ID)
    local used = self.Data[ID].card_bonus_used or 0
    if used > el then
        used = el
        self.Data[ID].card_bonus_used = used
    end
    return math.max(0, el - used)
end

--- User 到账后触发：登录晚于选人页打开时补足月卡/季卡免费显示
function SelectHero:OnShopDataUpdated(ID)
    if not ID or not self.Data[ID] then
        return
    end
    if self.Data[ID].hero_state then
        return
    end
    self:SetRefreshCost(ID)
    if self.Data[ID].page then
        self:SendData(ID)
    end
end

function SelectHero:SetRefreshCost(ID)
    if not ID then
        return
    end
    local num = self.Data[ID].refresh
    self.Data[ID].free = false

    if self:GetCardFreeLeft(ID) > 0 then
        self.Data[ID].free = true
        self.Data[ID].cost = 0
        return
    end
    if (self.Data[ID].base_free_left or 0) > 0 then
        self.Data[ID].free = true
        self.Data[ID].cost = 0
        return
    end

    -- num = 剩余可刷新次数（可降为负）；金豆档位见 Cost.num1～num10
    -- 超出原配额后以 num1 为准（与同系列「第10次刷新」等价：剩余次数落至 1 时的档位）
    local tier = num
    if tier < 1 then
        tier = 1
    elseif tier > 10 then
        tier = 10
    end
    local key = "num" .. tier
    self.Data[ID].cost = self.Cost[key] or 0
end
