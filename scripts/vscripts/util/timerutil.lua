--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local m = {}

---创建一个立即执行的计时器（依赖于游戏时间），返回计时器名字。
--@param #function func 执行函数
function m.CreateTimer(func)
  return Timers:CreateTimer(func);
end

---创建一个延迟执行的计时器（依赖于游戏时间），返回计时器名字
--@param #number delay 延迟时间,单位秒
--@param #function func 执行函数
function m.CreateTimerWithDelay(delay,func)
	return Timers:CreateTimer(delay,func);
end

---创建一个立即执行，且包含上下文的计时器（依赖于游戏时间），返回计时器名字。
--@param #function func 执行函数
--@param #any context 上下文
function m.CreateTimerWithContext(func,context)
  return Timers:CreateTimer(func,context);
end

---使用Entity的contextthink创建计时器，在游戏暂停的时候不执行函数逻辑
---@param entity CBaseEntity 
---@param func function 注意：func逻辑里面的self是基于CreateTimerWithEntity上下文的，和entity没有关系。要使用entity可以使用局部变量，或者使用func的第一个实参（系统会传入entity）
---@param delay number
---@return string timerName 返回计时器名字，可以用来停止(entity:StopThink(timerName))
function m.CreateTimerWithEntity(entity,func,delay)
	if EntityNotNull(entity) and type(func) == "function" then
		local timerName = DoUniqueString("timer")
		entity:SetContextThink(timerName,function(...)
			if GameRules:IsGamePaused() then
				return 0.01
			end
		
			local status,nextCall = pcallx(func,...)
			
			if not status then
				DebugPrint(nextCall)
			else
				return nextCall;
			end
		end,delay or 0)

		return timerName;
	end
end

---偷懒：创建一个绑定在mode实体上的计时器
function m.CreateTimerOnGameMode(func,delay)
	return m.CreateTimerWithEntity(GameRules:GetGameModeEntity(), func, delay)
end

--****************************下面是依赖于现实时间的计时器***********************

---创建一个立即执行的计时器（依赖于现实时间），返回计时器名字
--@param #function func 执行函数
function m.CreateTimerWithRealTime(func,delay)
  return Timers:CreateTimer({
		useGameTime = false,
		callback = func,
  		endTime	= delay
	});
end


---根据计时器名字移除计时器
function m.RemoveTimer(name)
	Timers:RemoveTimer(name)
end

---移除某个实体上的指定timer  
---***注意：在timer的逻辑里面不要同步调用Remove，7.31版本后dota这样调用会导致游戏崩溃***
---@param entity any
---@param name any
function m.RemoveTimerWithEntity(entity,name)
	if EntityNotNull(entity) and name then
		entity:StopThink(name)
	end
end

return m;