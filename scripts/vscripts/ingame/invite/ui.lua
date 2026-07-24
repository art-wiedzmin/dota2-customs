--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Invite:IsEnabled()
    return self.Enabled ~= false
end

function Invite:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    if not self:IsEnabled() then
        return
    end
    --暂停禁止传数据
    if GameRules:IsGamePaused() then
        return
    end
    --初始化数据
    if data.tp == "init" then
        self:SendData(ID)
    end
    --打开宝箱页面
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    --关闭宝箱页面
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    --输入邀请
    if data.tp == "WriteInvite" then
        self:WriteInvite(ID, data.text)
    end
    --获取奖励
    if data.tp == "GetInvite" then
        self:GetInvite(ID, data.text)
    end
end

function Invite:SendData(ID)
    if not ID or not self:IsEnabled() then
        return
    end
    Util:Send2JsID("UI_Invite", self.Data[ID], ID)
end
