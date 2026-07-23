--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


if CustomSets == nil then
   _G.CustomSets = class({})
end

require("listener.xptable")           --经验表
require("listener.rules")             --游戏规则
require("listener.event_reg.event")   --游戏事件监听
require("listener.filter_reg.filter") --游戏过滤器注册
require("listener.ui")                --游戏UI事件注册
require("listener.sandbox")           --沙盒注册
require("listener.sandbox2")          --沙盒注册

function CustomSets:GameSet()
   self:SetXpTable()
   self:GameRulesSet()
   self:EventSet()
   self:FilterRegister()
   self:UiRegister()
   self:SandRegister()
   self:InitCustomPause()
   Http:Init()
end