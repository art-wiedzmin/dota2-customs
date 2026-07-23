-- 客户端独立 Lua VM：不会执行 addon_game_mode.lua 的 Activate；须在此 require modifier注册表，否则会刷 unknown modifier。
require("init.precache.modifier_all")
