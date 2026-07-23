if GameProfiler==nil then
   GameProfiler=class({})
   GameProfiler.profiling={} 
   GameProfiler.TimerIndex=nil
   GameProfiler.TotalTime=0
   GameProfiler.m_start=collectgarbage("count")
end

local function ProfilingReport(funcinfo)
    local name = funcinfo.name or 'anonymous'
    local line = funcinfo.linedefined or 0
    local source = funcinfo.short_src or 'C_FUNC'
    local key = name .. source .. line

    local report = GameProfiler.profiling.report_key[key]
    if not report then
        report = {
            funcinfo = funcinfo,
            callcount = 0,
            totaltime = 0
        }
        GameProfiler.profiling.report_key[key] = report
        table.insert(GameProfiler.profiling.report, report)
    end
    return report
end

local function ProfilingTitle(funcinfo)
    local name = funcinfo.name or 'anonymous'
    local line = string.format("%d", funcinfo.linedefined or 0)
    local source = funcinfo.short_src or 'C_FUNC'
    return string.format("%-30s | %s: %s", name, source, line)
end

local function ProfilingCall(funcinfo)
    local report = ProfilingReport(funcinfo)
    report.calltime = GetSystemTimeMS()
    report.callcount = report.callcount + 1
end

local function ProfilingReturn(funcinfo)
    local stoptime = GetSystemTimeMS()
    local report = ProfilingReport(funcinfo)
    if report.calltime and report.calltime > 0 then
        report.totaltime = report.totaltime + (stoptime - report.calltime)
        report.calltime = 0
    end
end

local function ProfilingHandler(hooktype)
    local funcinfo = debug.getinfo(2, 'nS')
    if hooktype == "call" then
        ProfilingCall(funcinfo)
    elseif hooktype == "return" then
        ProfilingReturn(funcinfo)
    end
end

--开始性能分析
function GameProfiler:ProfilingStart()
    GameProfiler.profiling.report = GameProfiler.profiling.report or {}
    GameProfiler.profiling.report_key = GameProfiler.profiling.report_key or {}
    GameProfiler.profiling.time = GameProfiler.profiling.time or GetSystemTimeMS()
    debug.sethook(ProfilingHandler, 'cr', 0)
end

-- 结束性能分析
function GameProfiler:ProfilingStop()
    debug.sethook()
    self:ProfilingReadReport()
end

-- 打印性能分析报考
function GameProfiler:ProfilingReadReport()
    local totaltime = GetSystemTimeMS() - GameProfiler.profiling.time

    table.sort(GameProfiler.profiling.report, function(a, b)
        if a.totaltime ~= b.totaltime then
            return a.totaltime > b.totaltime
        end
        if a.callcount ~= b.callcount then
            return a.callcount > b.callcount
        end
        return false
    end)

    GameProfiler:Print(
        "--------------------------------------------- profiling report start ---------------------------------------------",
        nil)
    GameProfiler:Print(string.format("%10s | %6s | %10s | %-30s | %s", "totaltime", "percent", "callcount", "function",
        "source"), nil)
    local num = 15
    local n = 0
    for _, report in ipairs(GameProfiler.profiling.report) do
        local percent = 0
        if report.totaltime > 0 and n < num and report.funcinfo.name then
            percent = (report.totaltime / totaltime) * 100
            n = n + 1
            GameProfiler:Print(string.format("%8.3fms | %6.2f%% | %10d | %s", report.totaltime, percent,
                report.callcount, ProfilingTitle(report.funcinfo)), nil)
        end
    end

    GameProfiler:Print(
        "---------------------------------------------- profiling report end ----------------------------------------------",
        nil)

end

-- 控制台输出
function GameProfiler:Print(content, identifier)
    if IsInToolsMode() then
        local result = ""
        if identifier then
            result = result .. identifier .. " : "
        end
        local content_string = tostring(content)
        result = result .. content_string
        if type(content) == "table" then
            result = result .. "\n----------------- " .. content_string .. " start -----------------"
            local temp_str = ""
            for k, v in pairs(content) do
                result = result .. "\n" .. string.format("%-20s", k) .. " = " .. tostring(v) .. " (" .. type(v) .. ")"
            end
            result = result .. "\n------------------ " .. content_string .. " end ------------------\n"
        end
        print(result)
    end
end

function GameProfiler:ClearTimer()
         self.TimerIndex=nil
end
function GameProfiler:CacheTimer(index)
         self.TimerIndex=index
end
function GameProfiler:GetTimer()
         return self.TimerIndex
end
function GameProfiler:CountTotalTime()
         self.TotalTime=self.TotalTime+1
end
function GameProfiler:GetTotalTime()
         return self.TotalTime
end

function GameProfiler:RepeatHook()
        if not IsInToolsMode() then return end
        if self.TimerIndex then return end

        collectgarbage("collect")
        local m_last=self.m_start
        self:ProfilingStart()

        self.TimerIndex=Timers(1,function()
            --停止
            if self.OpenRepeat==false then
                self:ProfilingStop()
                self:ClearTimer()
                return
            end
            --计时
            self:CountTotalTime()
            local time=self:GetTotalTime()
            if time%5==0 then 
                self:ProfilingReadReport()
                collectgarbage("collect")
                local m_end=collectgarbage("count")
                print(string.format("初始内存= %f kb",self.m_start))
                print(string.format("当前内存= %f kb",m_end))
                print(string.format("耗时 = %f s,内存总增加 = %f kb,上次增加 = %f kb",time,m_end-self.m_start,m_end-m_last))
                m_last=m_end
                return 1
            else
                --print(string.format("分析计时 %f",time))
                return 1
            end
        end)
end

GameProfiler.OpenRepeat=false
if GameProfiler.OpenRepeat and IsInToolsMode() then
   GameProfiler:RepeatHook()
end