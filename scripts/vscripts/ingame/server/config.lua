--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Server.Data = {}
-- 连续未能完成 /user/login（含网络失败）时踢出，见 Server:CheckUser
Server.LOGIN_FAIL_MAX = 20
Server.Template = {
    whitelist = true,
    user_state = false,
    login_fail_count = 0,
    login_inflight = false,
    login_gave_up = false,
    user_data = {},
    pay = {
        ewm = "",
        pay_index = -1
    }
}
Server.WList = {}
-- 开局一次拉取：hero_id -> { damage_dealt_pct, damage_taken_reduce_pct }
Server.HeroBalanceById = {}
Server.HeroBalanceLoaded = false
Server.UserTemplate = {
    pid = 0,
    gold = 0,
    card1 = 0,
    card2 = 0,
    gold6 = 0,
    gold30 = 0,
    gold68 = 0,
    gold128 = 0,
    gold328 = 0,
    gold648 = 0,
    gold1280 = 0,
    gold_day = 0,
    free_day = 1,
    point = 1000,
}
