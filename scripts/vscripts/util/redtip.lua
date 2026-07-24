--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--直线提示器
LinkLuaModifier("modifier_tip_linetip", "util/redtipmodifier/modifier_tip_linetip", LUA_MODIFIER_MOTION_NONE)

if RedTip == nil then
   RedTip = class({})
end

--收缩圆  x控制 前摇圈 只有半径控制 0坐标 1外圈大小 2收缩圈大小
function RedTip:PointCircle(ca, radius, life)
   --前摇提示圈 1秒
   local str = "particles/myfx/mytipcircle2.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_CUSTOMORIGIN, ca)
   ParticleManager:SetParticleControl(fx, 0, ca:GetAbsOrigin())
   ParticleManager:SetParticleControl(fx, 1, Vector(radius, 0, 0))
   ParticleManager:SetParticleControl(fx, 2, Vector(radius, 0, 0))
   if life then
      ParticleManager:SetParticleControl(fx, 3, Vector(life, 0, 0))
   end
   return fx
end

--收缩圆 仅坐标
function RedTip:PointCircleVector(ve, radius, life)
   local str = "particles/myfx/mytipcircle2.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, ve)
   ParticleManager:SetParticleControl(fx, 1, Vector(radius, 0, 0))
   ParticleManager:SetParticleControl(fx, 2, Vector(radius, 0, 0))
   if life then
      ParticleManager:SetParticleControl(fx, 3, Vector(life, 0, 0))
   end
   return fx
end

--收缩圆 仅坐标 蓝色
function RedTip:PointCircleVector_Blue(ve, radius, life)
   local str = "particles/myfx/mytipcircle_2_blue2.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, ve)
   ParticleManager:SetParticleControl(fx, 1, Vector(radius, 0, 0))
   ParticleManager:SetParticleControl(fx, 2, Vector(radius, 0, 0))
   if life then
      ParticleManager:SetParticleControl(fx, 3, Vector(life, 0, 0))
   end
   return fx
end

--扩张圆 x控制 技能点圈 半径+生命 0坐标 1生命 2半径
function RedTip:LifeCircle(ve, life, radius)
   --前摇提示圈 1秒
   local str = "particles/myfx/lifecirclesimple.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, ve)
   ParticleManager:SetParticleControl(fx, 1, Vector(life, 0, 0))
   ParticleManager:SetParticleControl(fx, 2, Vector(radius, 0, 0))
   return fx
end

--目标 起点 终点 持续时间
function RedTip:PointLineTip(ca, a, b, duration, radius)
   if not ca or not a or not b then return end
   ca:AddNewModifier(ca, nil, "modifier_tip_linetip", {
      duration = duration,
      ax = a.x,
      ay = a.y,
      az = a.z,
      bx = b.x,
      by = b.y,
      bz = b.z,
      radius = radius or 135
   })
end

--目标 起点 终点 持续时间
--新版特效
function RedTip:PointLineTip_new(ca, a, b, duration, endwidth, color, startwidth, aplha)
   if not ca or not a or not b then return end
   local distance = (b - a):Length2D()
   if not startwidth then
      startwidth = endwidth
   end
   if not aplha then
      aplha = 1
   end
   local str = "particles/dev/warning/linear_warning_finger.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, a)
   ParticleManager:SetParticleControl(fx, 1, b)
   ParticleManager:SetParticleControl(fx, 2, Vector(duration, 0, 0))
   if color then
      ParticleManager:SetParticleControl(fx, 10, color)
   end
   ParticleManager:SetParticleControl(fx, 12, Vector(distance, startwidth, endwidth))
   ParticleManager:SetParticleControl(fx, 13, Vector(0, aplha, 0))
   ParticleManager:SetParticleControl(fx, 14, Vector(distance / duration, aplha, 0))
   Timers(duration, function()
      ParticleManager:DestroyParticle(fx, true)
      ParticleManager:ReleaseParticleIndex(fx)
   end)
end

--
function RedTip:CireleLineTip(ca, len, num, duration, radius)
   if not ca or not len or not duration then return end
   local pos = ca:GetAbsOrigin()
   local fx = ca:GetForwardVector()
   local fpos = pos + fx * len
   local deg = 360 / num

   local tab = {}
   tab.center = pos --中心位置
   tab.circle = {}  --外圈外围
   tab.len = len    --距离

   for i = 1, num do
      local newpos = RotatePosition(pos, QAngle(0, deg * (i - 1), 0), fpos)
      self:PointLineTip(ca, pos, newpos, duration, radius)
      table.insert(tab.circle, newpos)
   end
   return tab
end

--朝某个方向分叉发射 指示器
function RedTip:SectorLindeTip(ca, len, num, deg, duration, radius)
   if not ca or not len or not num or not deg
       or not duration then
      return
   end
   local pos = ca:GetAbsOrigin()
   local fx = ca:GetForwardVector()
   local fpos = pos + fx * len
   local half = (num - 1) * deg * 0.5
   fpos = RotatePosition(pos, QAngle(0, -half, 0), fpos)

   local tab = {}
   tab.center = pos --中心位置
   tab.circle = {}  --外圈外围
   tab.len = len    --距离

   for i = 1, num do
      local newpos = RotatePosition(pos, QAngle(0, deg * (i - 1), 0), fpos)
      self:PointLineTip(ca, pos, newpos, duration, radius)
      table.insert(tab.circle, newpos)
   end
   return tab
end

--朝某个方向分叉发射 指示器（传方向）
function RedTip:SectorLindeTip_origin(origin, ca, len, num, deg, duration, radius)
   if not origin or not len or not num or not deg
       or not duration or not ca then
      return
   end
   local pos = origin
   local ca_orgin = ca:GetAbsOrigin()
   local distance = (pos - ca_orgin)
   local fx = distance:Normalized()
   pos = ca_orgin
   local fpos = pos + fx * len
   local half = (num - 1) * deg * 0.5
   fpos = RotatePosition(pos, QAngle(0, -half, 0), fpos)

   local tab = {}
   tab.center = pos --中心位置
   tab.circle = {}  --外圈外围
   tab.len = len    --距离

   for i = 1, num do
      local newpos = RotatePosition(pos, QAngle(0, deg * (i - 1), 0), fpos)
      self:PointLineTip(ca, ca_orgin, newpos, duration, radius)
      table.insert(tab.circle, newpos)
   end
   return tab
end

--扩张圆 x控制 技能点圈 半径+生命 0坐标 1生命 2半径
--带提示圈
function RedTip:LifeCircle_add(ve, life, radius)
   local str = "particles/myfx/mytipcircle_add.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, ve)
   ParticleManager:SetParticleControl(fx, 3, Vector(life, 0, 0))
   ParticleManager:SetParticleControl(fx, 2, Vector(radius, 0, 0))
   ParticleManager:SetParticleControl(fx, 1, Vector(radius, 0, 0))
   return fx
end

--扩张圆 x控制 技能点圈  坐标 半径 持续时间  透明度 颜色(RGB) 扩张   颜色_静态
--没定义透明度 默认为0.5
--没定义颜色 默认为红色
--带提示圈 新版的
function RedTip:LifeCircle_add_new(ve, life, radius, alpha, color_extend, color_static)
   local str = "particles/dev/warning/aoe_waring.vpcf"
   if not alpha then alpha = 1 end
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, ve)
   ParticleManager:SetParticleControl(fx, 1, Vector(radius, alpha, 0))
   ParticleManager:SetParticleControl(fx, 2, Vector(life, 0, 0))
   if color_extend then
      ParticleManager:SetParticleControl(fx, 15, color_extend)
   end
   if color_static then
      ParticleManager:SetParticleControl(fx, 16, color_static)
   end

   return fx
end

--扇形圆(可旋转) 默认时间2S(目前无法修改)
--参数 坐标、半径、生成扇形角度、旋转速度（速度/S）、 neg-取反
function RedTip:Sector_add(ca, radius, angle, rotate, neg)
   local face = ca:EyeAngles().y
   if neg then
      local pos = Util:GetForwardVector(ca, -10)
      local dis = pos - ca:GetAbsOrigin()
      local new = VectorToAngles(dis).y
      face = new
   end
   local fc = (360 - angle) + 90 * (face / 45)
   local str = "particles/ability/tips/warning_angle.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, ca:GetAbsOrigin())
   ParticleManager:SetParticleControl(fx, 1, Vector(radius, angle, 0))
   ParticleManager:SetParticleControl(fx, 3, Vector(0, 1, 1))
   ParticleManager:SetParticleControl(fx, 4, Vector(rotate, 0, 0))
   ParticleManager:SetParticleControl(fx, 5, Vector(fc, 0, 0))
   Timers:CreateTimer(2, function()
      ParticleManager:DestroyParticle(fx, true)
      ParticleManager:ReleaseParticleIndex(fx)
   end)
   return fx
end

--扇形圆(可旋转) 默认时间1S(目前无法修改)(大圣BOSS修改版)
--参数 坐标、半径、生成扇形角度、旋转速度（速度/S）、 neg-取反
function RedTip:Sector_add_boss(ca, radius, angle, rotate, neg)
   local face = ca:EyeAngles().y
   if neg then
      local pos = Util:GetForwardVector(ca, -10)
      local dis = pos - ca:GetAbsOrigin()
      local new = VectorToAngles(dis).y
      face = new
   end
   local fc = (360 - angle) + 90 * (face / 45)
   local str = "particles/ability/tips/warning_angle_3.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, ca:GetAbsOrigin())
   ParticleManager:SetParticleControl(fx, 1, Vector(radius, angle, 0))
   ParticleManager:SetParticleControl(fx, 3, Vector(0, 1, 1))
   ParticleManager:SetParticleControl(fx, 4, Vector(rotate, 0, 0))
   ParticleManager:SetParticleControl(fx, 5, Vector(fc, 0, 0))
   Timers:CreateTimer(1, function()
      ParticleManager:DestroyParticle(fx, true)
      ParticleManager:ReleaseParticleIndex(fx)
   end)
   return fx
end

--扇形圆(可旋转) 默认时间1.5S(目前无法修改)(大圣BOSS修改版)
--参数 坐标、半径、生成扇形角度、旋转速度（速度/S）、 neg-取反
function RedTip:Sector_add_new(ca, radius, angle, rotate, neg)
   local face = ca:EyeAngles().y
   if neg then
      local pos = Util:GetForwardVector(ca, -10)
      local dis = pos - ca:GetAbsOrigin()
      local new = VectorToAngles(dis).y
      face = new
   end
   local fc = (360 - angle)
   local str = "particles/ability/tips/warning_angle_4.vpcf"
   local fx = ParticleManager:CreateParticle(str, PATTACH_WORLDORIGIN, nil)
   ParticleManager:SetParticleControl(fx, 0, ca:GetAbsOrigin())
   ParticleManager:SetParticleControl(fx, 1, Vector(radius, angle, 0))
   ParticleManager:SetParticleControl(fx, 3, Vector(0, 1, 1))
   ParticleManager:SetParticleControl(fx, 4, Vector(rotate, 0, 0))
   ParticleManager:SetParticleControl(fx, 5, Vector(fc, 0, 0))
   Timers:CreateTimer(1.5, function()
      ParticleManager:DestroyParticle(fx, true)
      ParticleManager:ReleaseParticleIndex(fx)
   end)
   return fx
end

--圆环，同心圆 by40
--位置/时间/半径/宽度
function RedTip:LifeRing_add(location, duration, radius, width)
   local tx = ParticleManager:CreateParticle(
      "particles/ability/boss/boss_angry/primal_beast_pummel_ripple_preview_c_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
   ParticleManager:SetParticleControl(tx, 0, location)
   ParticleManager:SetParticleControl(tx, 1, Vector(radius, width, 0))
   ParticleManager:SetParticleControl(tx, 2, Vector(duration, 0, 0))
   Timers:CreateTimer(duration, function()
      ParticleManager:DestroyParticle(tx, false)
      ParticleManager:ReleaseParticleIndex(tx)
   end)
   return tx
end