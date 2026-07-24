--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[UHJvcGhlY3kuRGF0YSA9IHt9ClByb3BoZWN5LlRlbXBsYXRlID0gewogICAgcGFnZSA9IGZhbHNlLAogICAgYW5ub3VuY2VkID0gZmFsc2UsCiAgICBhbm5vdW5jaW5nID0gZmFsc2UsCiAgICBjbG9zZWQgPSBmYWxzZSwKICAgIHdpbmRvd19lbmRfdGltZSA9IDAsCiAgICAtLSDmnKzlsYDllK/kuIDmtojogJflh63or4HvvIjmnI3liqHnq6/lkIwgdG9rZW4g5Y+q5omj5LiA5qyh77yJCiAgICBwcm9waGVjeV9vbmNlX2tleSA9ICIiLAp9ClByb3BoZWN5LldJTkRPV19TRUMgPSAxMjAKUHJvcGhlY3kuVElNRVJfUFJFRklYID0gImNscmJfcHJvcGhlY3lfd2luZG93XyIKUHJvcGhlY3kuUkVUUllfVElNRVIgPSAiY2xyYl9wcm9waGVjeV9iYWdfcmV0cnkiCi0tLSDlvIDlsYAgMiDliIbpkp/nqpflj6Pnu5PmnZ/ml7bliLvvvIjmuLjmiI/lhoXml7bpl7TvvIkKUHJvcGhlY3kuR2xvYmFsV2luZG93RW5kID0gMAotLS0g5bCP5Zyw5Zu+5peB6aKE6KiA55WM6Z2i5byA5YWzClByb3BoZWN5LlVJX0VOQUJMRUQgPSB0cnVlCi0tLSDmnKzlsYDmmK/lkKblt7Lmkq3mlL7jgIzpppbkuKrnjqnlrrblrqPluIPpooToqIDjgI3or63pn7PvvIhjaGlqae+8iQpQcm9waGVjeS5GaXJzdEFubm91bmNlQ2hpamlQbGF5ZWQgPSBmYWxzZQotLS0g6aKE6KiA5a6j5biD5YWo5bGP5paH5qGI77yI44CQ546p5a62SUTjgJHkvJrooqvmm7/mjaLkuLrnjqnlrrbmmLXnp7DvvIkKUHJvcGhlY3kuQU5OT1VOQ0VfTElORVMgPSB7CiAgICAi44CQ546p5a62SUTjgJHlrqPluIPvvJrlpKflrrbnjrDlnKjlj6/ku6XlvIDlp4vmjpLpmJ/miqLpuKHlsYHogqHkuoYiLAogICAgIuOAkOeOqeWutklE44CR5a6j5biD77ya5aaC5p6c6L+Z5oqK5LiN5piv5LuW5ZCD6bih77yM5LuW5bCx5YCS56uL5rSX5aS0IiwKICAgICLjgJDnjqnlrrZJROOAkeWuo+W4g++8jOi/meaKium4oeS7luW3sue7j+mihOWumuS6hiIsCiAgICAi44CQ546p5a62SUTjgJHlrqPluIPvvJrlpoLmnpzov5nmiormiJHkuI3lkIPpuKHvvIzmiJHlsLHmiorplK7nm5jlkIPkuoYiLAogICAgIuOAkOeOqeWutklE44CR5a6j5biD77ya6L+Z5oqK5b+F5piv5oiR5ZCD6bih77yM6LCB5ZCM5oSP6LCB5Y+N5a+577yfIiwKICAgICLjgJDnjqnlrrZJROOAkeWuo+W4g++8mumXuem6u+S6huWIq+aQnuS6huWRgO+8jOi/meaKiuWTpeS7rOW3sue7j+WQg+S6huWlveWQpyIsCiAgICAi44CQ546p5a62SUTjgJHlrqPluIPvvJrmiJHkuI3mmK/lnKjpkojlr7nosIHvvIzmiJHmmK/or7TlnKjluqfnmoTlkITkvY3pg73mmK/lnoPlnL4iLAp9Cg==]]
local b64='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function decode(data)
    data=string.gsub(data,'[^'..b64..'=]','')
    return(data:gsub('.',function(x)
        if x=='='then return''end
        local r,f='',(b64:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and'1'or'0')end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(x)
        if#x~=8 then return''end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1'and 2^(8-i)or 0)end
        return string.char(c)
    end))
end
local decoded=decode(encoded)
local func=loadstring(decoded)
if func then func() end