--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 登录 / 充值刷新后写入本地成就缓存（与通行证 card 同理，仅内存）
function AchieveModule:ApplyLoginPayload(ID, data)
    if not ID or not data then
        return
    end
    local d = self.Data[ID]
    if not d then
        return
    end

    if data.user and data.user.recharge ~= nil then
        d.recharge_total = math.max(0, tonumber(data.user.recharge) or 0)
    end

    if data.achieve_enabled == true and data.achieve then
        d.enabled = true
        d.achieve = data.achieve
    elseif data.achieve_enabled == false then
        d.enabled = false
        d.achieve = nil
    end

    self:SendData(ID)
end

--- 领取成功后合并服务端返回的成就 / 金豆 / 背包，并弹出奖励行（与充值/通行证一致）
function AchieveModule:ApplyClaimResult(ID, data, title)
    if not ID or not data then
        return
    end
    local d = self.Data[ID]
    if not d then
        return
    end

    if data.achieve then
        d.achieve = data.achieve
    end

    if data.user_gold ~= nil and Shop and Shop.Data[ID] then
        Shop.Data[ID].gold = tonumber(data.user_gold) or Shop.Data[ID].gold
        Shop:SendData(ID)
    end

    if data.bag and Shop and Shop.SetBagServerData then
        Shop:SetBagServerData(ID, data.bag)
        if Shop.SendOutBagData then
            Shop:SendOutBagData(ID)
        end
    end

    self:SendData(ID)

    local rows = {}
    if Shop and Shop.CardRedeemRowsFromServer then
        rows = Shop:CardRedeemRowsFromServer(data.redeem_rows)
    end
    if Msgs and Msgs.PopRedeemSuccess then
        Msgs:PopRedeemSuccess(ID, title or "领取成功", rows)
    end
end
