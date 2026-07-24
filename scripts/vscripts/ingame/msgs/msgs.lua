--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Msgs == nil then
    Msgs = class({})
    require("ingame.Msgs.Config")
    require("ingame.Msgs.Ui")
end

function Msgs:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

function Msgs:OpenPage(ID)
    self.Data[ID].page = true
    self:SendData(ID)
end

function Msgs:ClosePage(ID)
    self.Data[ID].page = false
    self.Data[ID].text = ""
    self.Data[ID].item_state = false
    self.Data[ID].item = {}
    self.Data[ID].redeem_state = "none"
    self.Data[ID].redeem_rows = {}
    self:SendData(ID)
end

function Msgs:Pop(ID, text, list)
    if not ID or not text then
        return
    end
    self.Data[ID].text = text
    self.Data[ID].redeem_state = "none"
    self.Data[ID].redeem_rows = {}
    if list then
        self.Data[ID].item_state = true
        self.Data[ID].item = list
    else
        -- 无列表时必须清掉，否则 item 仍为 {}、Panorama 里 {} 为真，会误显示「请重新尝试」
        self.Data[ID].item_state = false
        self.Data[ID].item = {}
    end
    self:OpenPage(ID)
end

--- 兑换码成功：展示图标行（redeem_rows 为顺序表）
function Msgs:PopRedeemSuccess(ID, title, rows)
    if not ID then
        return
    end
    self.Data[ID].text = title or "兑换成功"
    self.Data[ID].redeem_state = "ok"
    self.Data[ID].redeem_rows = rows or {}
    self.Data[ID].item_state = false
    self.Data[ID].item = {}
    self:OpenPage(ID)
end

--- 兑换码失败：标题 + 前端显示「请重新尝试」
function Msgs:PopRedeemFail(ID, title)
    if not ID then
        return
    end
    self.Data[ID].text = title or "兑换失败"
    self.Data[ID].redeem_state = "fail"
    self.Data[ID].redeem_rows = {}
    self.Data[ID].item_state = false
    self.Data[ID].item = {}
    self:OpenPage(ID)
end
