--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- item_recipe_red_moon_crystal：配方物品，逻辑由引擎合成处理；脚本仅满足 item_lua 加载与充能回调签名。
if item_recipe_red_moon_crystal == nil then
    item_recipe_red_moon_crystal = class({})
end

function item_recipe_red_moon_crystal:OnChargeCountChanged(_kv)
end