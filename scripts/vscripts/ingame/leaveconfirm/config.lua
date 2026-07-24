--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


LeaveConfirm.Data = {}
--- 本局是否已惩罚过（仅第一个持续断线超时的玩家）
LeaveConfirm.penalty_claimed = LeaveConfirm.penalty_claimed or false
--- 断线后等待「持续离线满 5 分钟」的监视标记
LeaveConfirm._abandon_watch = LeaveConfirm._abandon_watch or {}
--- 本局唯一 id，随 early_leave 上报，供服务端去重
LeaveConfirm.match_uid = LeaveConfirm.match_uid or nil
LeaveConfirm.Template = {
    page = false,
}
