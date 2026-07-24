--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Prophecy.Data = {}
Prophecy.Template = {
    page = false,
    announced = false,
    announcing = false,
    closed = false,
    window_end_time = 0,
    -- 本局唯一消耗凭证（服务端同 token 只扣一次）
    prophecy_once_key = "",
}
Prophecy.WINDOW_SEC = 120
Prophecy.TIMER_PREFIX = "clrb_prophecy_window_"
Prophecy.RETRY_TIMER = "clrb_prophecy_bag_retry"
--- 开局 2 分钟窗口结束时刻（游戏内时间）
Prophecy.GlobalWindowEnd = 0
--- 小地图旁预言界面开关
Prophecy.UI_ENABLED = true
--- 本局是否已播放「首个玩家宣布预言」语音（chiji）
Prophecy.FirstAnnounceChijiPlayed = false
--- 预言宣布全屏文案（【玩家ID】会被替换为玩家昵称）
Prophecy.ANNOUNCE_LINES = {
    "【玩家ID】宣布：大家现在可以开始排队抢鸡屁股了",
    "【玩家ID】宣布：如果这把不是他吃鸡，他就倒立洗头",
    "【玩家ID】宣布，这把鸡他已经预定了",
    "【玩家ID】宣布：如果这把我不吃鸡，我就把键盘吃了",
    "【玩家ID】宣布：这把必是我吃鸡，谁同意谁反对？",
    "【玩家ID】宣布：闹麻了别搞了呀，这把哥们已经吃了好吧",
    "【玩家ID】宣布：我不是在针对谁，我是说在座的各位都是垃圾",
}
