--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if HeroCard == nil then
    HeroCard = class({})
end
require("ingame.HeroCard.Config")
require("ingame.HeroCard.Func")
require("ingame.HeroCard.Ui")

-- UI 可能早于 InitPlayer:Init_ID 回调，避免 self.Data[ID] 为空
function HeroCard:EnsurePlayerData(ID)
    if not ID then
        return
    end
    if not self.Data[ID] then
        self.Data[ID] = Util:DeepCopyTab(self.Template)
    end
end

function HeroCard:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

function HeroCard:OpenPage(ID)
    if not ID then
        return
    end
    self:EnsurePlayerData(ID)
    self.Data[ID].page = true
    -- self:SendData(ID)
end

function HeroCard:ClosePage(ID)
    if not ID then
        return
    end
    self:EnsurePlayerData(ID)
    self.Data[ID].page = false
    self:SendData(ID)
end

-- 查看英雄信息（槽位参数与 Stat 一致：5v5 传 side+gid，1v10 传 row）
function HeroCard:HeroInfo(ID, data)
    if not ID or not data then
        return
    end
    local pid = self:ResolvePlayerIdFromSlot(data)
    if not pid then
        return
    end
    self:OpenPage(ID)
    local payload = self:BuildPayload(pid)
    self.Data[ID].data = payload
    self:SendData(ID)
end
