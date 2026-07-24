--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function AchieveModule:GetUIData(ID, data)
    if not ID or not data or not data.tp then
        return
    end

    local tp = data.tp
    if tp == "init" or tp == "OpenPage" then
        self.Data[ID].page = 1
        self:SendData(ID)
    elseif tp == "ClosePage" then
        self.Data[ID].page = 0
        self:SendData(ID)
    elseif tp == "SwitchTab" and data.tab then
        self.Data[ID].tab = data.tab
        self:SendData(ID)
    elseif tp == "Sync" then
        self:SendData(ID)
    elseif tp == "Claim" then
        local category = data.category or self:TabToCategory(data.tab)
        local key = data.id or data.key
        if category and key and key ~= "" then
            self:EnqueueClaim(ID, category, key)
        end
    end
end

function AchieveModule:SendData(ID)
    if not ID or not self.Data[ID] then
        return
    end
    local d = self.Data[ID]
    Util:Send2JsID("UI_Achieve", {
        page = d.page,
        tab = d.tab,
        enabled = d.enabled == true,
        achieve = d.achieve,
        recharge_total = d.recharge_total or 0,
        has_claimable = self:HasClaimableRewards(ID),
    }, ID)
end
