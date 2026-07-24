--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 客户端独立 Lua VM：不会执行 addon_game_mode.lua 的 Activate；须在此 require modifier注册表，否则会刷 unknown modifier。
require("init.precache.modifier_all")