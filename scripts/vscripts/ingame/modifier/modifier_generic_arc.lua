--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--[[
	全局弧度运动控制器

	kv 数据 (默认)):
	-- 方向, 提供一个 (不提供就默认面朝方向):
		dir_x/y (forward), for 单位方向
		target_x/y (forward), for 目标方向
	-- 运动控制, 提供 2 - 3, duration-only (for vertical arc), or all 3
		speed (0)		速度
		duration (0)	持续时间
		distance (0): 	0表示不位移
	-- vertical motion.
		height (0): max height. zero means no vertical motion
		start_offset (0), height offset from ground at start of jump
		end_offset (0), height offset from ground at end of jump
	-- arc types
		fix_end (true): if true, landing z-pos is the same as jumping z-pos, not respecting on landing terrain height (Pounce)
		fix_duration (true): if false, arc ends when unit touches ground, not respecting duration (Shield Crash)
		fix_height (true): if false, arc max height depends on jump distance, height provided is max-height (Tree Dance)
	-- other
		isStun (false), parent is stunned
		isRestricted (false), parent is command restricted
		isForward (false), lock parent forward facing
		activity (none), activity when leaping
   回调
   arc:SetEndCallback(function () end)
]]
--------------------------------------------------------------------------------
modifier_generic_arc = class({})

--------------------------------------------------------------------------------
-- 基本设置
function modifier_generic_arc:IsHidden()
	return true
end

function modifier_generic_arc:IsDebuff()
	return false
end

function modifier_generic_arc:IsStunDebuff()
	return false
end

function modifier_generic_arc:IsPurgable()
	return true
end

function modifier_generic_arc:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- 初始化
function modifier_generic_arc:OnCreated(kv)
	if not IsServer() then return end
	self.interrupted = false
	self:SetJumpParameters(kv)
	self:Jump()
end

function modifier_generic_arc:OnRefresh(kv)
	self:OnCreated(kv)
end

function modifier_generic_arc:OnRemoved()
end

function modifier_generic_arc:OnDestroy()
	if not IsServer() then return end

	if self.motion_manual then
		self:StartIntervalThink(-1)
	end

	local parent = self:GetParent()
	local pos = nil
	if parent and not parent:IsNull() then
		pos = parent:GetOrigin()
		if not self.motion_manual then
			if parent.RemoveHorizontalMotionController then
				parent:RemoveHorizontalMotionController(self)
			end
			if parent.RemoveVerticalMotionController then
				parent:RemoveVerticalMotionController(self)
			end
		end
	end

	-- 高度保持 当有结束位置保持
	if pos and self.end_offset ~= 0 and parent and not parent:IsNull() then
		parent:SetOrigin(pos)
	end

	if self.endCallback then
		self.endCallback(self.interrupted)
	end
end

--------------------------------------------------------------------------------
-- Modifier 效果
function modifier_generic_arc:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	if self:GetStackCount() > 0 then
		table.insert(funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION)
	end

	return funcs
end

function modifier_generic_arc:GetModifierDisableTurning()
	if not self.isForward then return end
	return 1
end

function modifier_generic_arc:GetOverrideAnimation()
	return self:GetStackCount()
end

--------------------------------------------------------------------------------
-- 状态效果
function modifier_generic_arc:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.isStun or false,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = self.isRestricted or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- 运动效果
function modifier_generic_arc:UpdateHorizontalMotion(me, dt)
	if self.fix_duration and self:GetElapsedTime() >= self.duration then return end

	-- 设置相对位置
	local pos = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin(pos)
end

function modifier_generic_arc:UpdateVerticalMotion(me, dt)
	if self.fix_duration and self:GetElapsedTime() >= self.duration then return end

	local pos = me:GetOrigin()
	local time = self:GetElapsedTime()

	-- 设置相对位置
	local height = pos.z
	local speed = self:GetVerticalSpeed(time)
	pos.z = height + speed * dt
	me:SetOrigin(pos)

	if not self.fix_duration then
		local ground = GetGroundHeight(pos, me) + self.end_offset
		if pos.z <= ground then
			-- 在地面以下，将高度设置为地面，然后销毁
			pos.z = ground
			me:SetOrigin(pos)
			self:Destroy()
		end
	end
end

function modifier_generic_arc:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_generic_arc:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

-- 部分客户端/宿主环境单位无 Apply*MotionController，回退为用 IntervalThink 驱动 Update*Motion。
local function try_apply_horizontal_controller(modifier, parent)
	if parent.ApplyHorizontalMotionController then
		local ok = parent:ApplyHorizontalMotionController(modifier)
		if ok ~= false then
			return true
		end
	end
	if modifier.ApplyHorizontalMotionController then
		local ok = modifier:ApplyHorizontalMotionController()
		if ok ~= false then
			return true
		end
	end
	return false
end

local function try_apply_vertical_controller(modifier, parent)
	if parent.ApplyVerticalMotionController then
		local ok = parent:ApplyVerticalMotionController(modifier)
		if ok ~= false then
			return true
		end
	end
	if modifier.ApplyVerticalMotionController then
		local ok = modifier:ApplyVerticalMotionController()
		if ok ~= false then
			return true
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- 运动助手
function modifier_generic_arc:SetJumpParameters(kv)
	self.parent = self:GetParent()

	-- load types
	self.fix_end = true
	self.fix_duration = true
	self.fix_height = true
	if kv.fix_end then
		self.fix_end = kv.fix_end == 1
	end
	if kv.fix_duration then
		self.fix_duration = kv.fix_duration == 1
	end
	if kv.fix_height then
		self.fix_height = kv.fix_height == 1
	end

	-- load other types
	self.isStun = kv.isStun == 1
	self.isRestricted = kv.isRestricted == 1
	self.isForward = kv.isForward == 1
	self.activity = kv.activity or 0
	self:SetStackCount(self.activity)

	-- load direction
	if kv.target_x and kv.target_y then
		local origin = self.parent:GetOrigin()
		local dir = Vector(kv.target_x, kv.target_y, 0) - origin
		dir.z = 0
		dir = dir:Normalized()
		self.direction = dir
	end
	if kv.dir_x and kv.dir_y then
		self.direction = Vector(kv.dir_x, kv.dir_y, 0):Normalized()
	end
	if not self.direction then
		self.direction = self.parent:GetForwardVector()
	end

	-- load horizontal data
	self.duration = kv.duration
	self.distance = kv.distance
	self.speed = kv.speed
	if not self.duration then
		self.duration = self.distance / self.speed
	end
	if not self.distance then
		self.speed = self.speed or 0
		self.distance = self.speed * self.duration
	end
	if not self.speed then
		self.distance = self.distance or 0
		self.speed = self.distance / self.duration
	end

	-- load vertical data
	self.height = kv.height or 0
	self.start_offset = kv.start_offset or 0
	self.end_offset = kv.end_offset or 0

	-- calculate height positions
	local pos_start = self.parent:GetOrigin()
	local pos_end = pos_start + self.direction * self.distance
	local height_start = GetGroundHeight(pos_start, self.parent) + self.start_offset
	local height_end = GetGroundHeight(pos_end, self.parent) + self.end_offset
	local height_max

	-- determine jumping height if not fixed
	if not self.fix_height then
		-- ideal height is proportional to max distance
		self.height = math.min(self.height, self.distance / 4)
	end

	-- determine height max
	if self.fix_end then
		height_end = height_start
		height_max = height_start + self.height
	else
		-- calculate height
		local tempmin, tempmax = height_start, height_end
		if tempmin > tempmax then
			tempmin, tempmax = tempmax, tempmin
		end
		local delta = (tempmax - tempmin) * 2 / 3

		height_max = tempmin + delta + self.height
	end

	-- set duration
	if not self.fix_duration then
		self:SetDuration(-1, false)
	else
		self:SetDuration(self.duration, true)
	end

	-- calculate arc
	self:InitVerticalArc(height_start, height_max, height_end, self.duration)
end

function modifier_generic_arc:Jump()
	local parent = self:GetParent()
	if not parent or parent:IsNull() then
		self:Destroy()
		return
	end

	self.motion_manual = false
	local need_h = self.distance > 0
	local need_v = self.height > 0
	local ok_h = not need_h
	local ok_v = not need_v

	if need_h then
		ok_h = try_apply_horizontal_controller(self, parent)
	end
	if need_v then
		ok_v = try_apply_vertical_controller(self, parent)
	end

	if (need_h and not ok_h) or (need_v and not ok_v) then
		if need_h and ok_h and parent.RemoveHorizontalMotionController then
			parent:RemoveHorizontalMotionController(self)
		end
		if need_v and ok_v and parent.RemoveVerticalMotionController then
			parent:RemoveVerticalMotionController(self)
		end
		self.motion_manual = true
		local dt = FrameTime()
		if not dt or dt <= 0 then
			dt = 1 / 45
		end
		self:StartIntervalThink(dt)
	end
end

function modifier_generic_arc:OnIntervalThink()
	if not IsServer() then
		return
	end
	if not self.motion_manual then
		return
	end
	local parent = self:GetParent()
	if not parent or parent:IsNull() then
		self:Destroy()
		return
	end

	local dt = FrameTime()
	if not dt or dt <= 0 then
		dt = 1 / 45
	end

	if self.fix_duration and self:GetElapsedTime() >= self.duration then
		return
	end

	if self.distance > 0 then
		self:UpdateHorizontalMotion(parent, dt)
	end
	if self.height > 0 then
		self:UpdateVerticalMotion(parent, dt)
	end
end

function modifier_generic_arc:InitVerticalArc(height_start, height_max, height_end, duration)
	local height_end = height_end - height_start
	local height_max = height_max - height_start

	-- fail-safe1: height_max cannot be smaller than height delta
	if height_max < height_end then
		height_max = height_end + 0.01
	end

	-- fail-safe2: height-max must be positive
	if height_max <= 0 then
		height_max = 0.01
	end

	-- math magic
	local duration_end = (1 + math.sqrt(1 - height_end / height_max)) / 2
	self.const1 = 4 * height_max * duration_end / duration
	self.const2 = 4 * height_max * duration_end * duration_end / (duration * duration)
end

function modifier_generic_arc:GetVerticalPos(time)
	return self.const1 * time - self.const2 * time * time
end

function modifier_generic_arc:GetVerticalSpeed(time)
	return self.const1 - 2 * self.const2 * time
end

--------------------------------------------------------------------------------
-- Helper
function modifier_generic_arc:SetEndCallback(func)
	self.endCallback = func
end

--[[
LinkLuaModifier("modifier_generic_arc", "ingame/modifier/generic/modifier_generic_arc",LUA_MODIFIER_MOTION_BOTH)
local arc=ca:AddNewModifier(ca,self,"modifier_generic_arc",{duration=time,height=hig,dir_x=-fx.x,dir_y=-fx.y,distance=len})
    arc:SetEndCallback(function() end)
]]
