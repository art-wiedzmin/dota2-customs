--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


if DeBugerTool == nil then
     DeBugerTool = class({})
     DeBugerTool.HasCrash = {}
end

-- --崩溃追踪
-- if __debug_trace_back_original__ == nil then
--    __debug_trace_back_original__ = debug.traceback
-- end

-- debug.traceback = function(thread, message, level)
--     local trace
--     if thread == nil and message == nil and level == nil then
--        trace = __debug_trace_back_original__()
--     else
--        trace = __debug_trace_back_original__(thread, message, level)
--     end

--     if Http and not IsInToolsMode() then
--       local param = {
--                       message = trace
--                     }
--       Http:DebugPOST(param)
--     end

--     return trace
-- end


--Debug日志信息

if __debug_trace_back_original__ == nil then
     __debug_trace_back_original__ = debug.traceback
end

-- 扩展debug信息的函数
local function extendedDebugInfo()
     local info = ""
     local level = 2
     while true do
          local stackInfo = debug.getinfo(level, "nSl")
          if not stackInfo then break end
          info = info ..
              string.format("[%s]: %s in function '%s'\n", stackInfo.short_src, stackInfo.currentline,
                   stackInfo.name or "")
          if level == 3 then
               for i = 1, math.huge do
                    local name, value = debug.getlocal(level, i)
                    if not name then break end
                    if type(value) ~= "table" then
                         info = info .. "获取局部:" .. string.format("\t%s=%s\n", name, value)
                    end
               end
          end

          level = level + 1
     end

     return info
end

debug.traceback = function(thread, message, level)
     local trace
     if thread == nil and message == nil and level == nil then
          trace = __debug_trace_back_original__()
     else
          trace = __debug_trace_back_original__(thread, message, level)
     end

     if Http and not IsInToolsMode() then
          local param = {
               message = trace,
               extended = extendedDebugInfo()
          }
          --只发一次就行了
          local md5=Md5Tool.sumhexa(param.extended)
          if md5 and not DeBugerTool.HasCrash[md5] then
               DeBugerTool.HasCrash[md5] = true
               Http:DebugPOST(param)
          end
     end
     
     return trace
end

-- local a = require("config.Player.Player_Default_Attr_Config")
-- local param = {
--      message = JSON.encode(a),
--      extended = "extendedDebugInfo()"
-- }
-- Http:DebugPOST(param)

-- local param = {
--      message = JSON.encode("5656565"),
--      extended = "extendedDebugInfo()"
-- }
-- Http:DebugPOST(param)