--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfZ2pzZCA9IGNsYXNzKHt9KQoKLS3or6Vtb2RpZmllcuaYr+WQpuaYr+i0n+mdoueahApmdW5jdGlvbiBtb2RpZmllcl9nanNkOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLog73lkKbooqvmuIXpmaQKZnVuY3Rpb24gbW9kaWZpZXJfZ2pzZDpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfZ2pzZDpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCi0t5q275Lqh5pe25piv5ZCm56e76ZmkCmZ1bmN0aW9uIG1vZGlmaWVyX2dqc2Q6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLSDliJ3lp4vljJZtb2RpZmllcgpmdW5jdGlvbiBtb2RpZmllcl9nanNkOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAoKICAgIC0tIOS7juWPguaVsOiOt+WPluaUu+WHu+mAn+W6puWKoOaIkO+8jOWmguaenOayoeacieWImeS9v+eUqOm7mOiupOWAvAogICAgc2VsZi5hdHRhY2tfc3BlZWRfYm9udXMgPSBrdi5hdHRhY2tfc3BlZWQgb3IgMSAtLSDpu5jorqQzMOeCueaUu+WHu+mAn+W6pgogICAgLS0g5L2/55So5qCI6K6h5pWw5ZCM5q2l5pWw5o2u5Yiw5a6i5oi356uvCiAgICBzZWxmOlNldFN0YWNrQ291bnQobWF0aC5mbG9vcihzZWxmLmF0dGFja19zcGVlZF9ib251cyAqIDEwMCkpCiAgICAtLSDlvLrliLblsZ7mgKfliLfmlrAKICAgIHNlbGY6Rm9yY2VSZWZyZXNoKCkKICAgIHNlbGY6R2V0UGFyZW50KCk6Q2FsY3VsYXRlU3RhdEJvbnVzKHRydWUpCmVuZAoKLS0g5Yi35pawbW9kaWZpZXIKZnVuY3Rpb24gbW9kaWZpZXJfZ2pzZDpPblJlZnJlc2goa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKCiAgICBpZiBrdi5hdHRhY2tfc3BlZWQgdGhlbgogICAgICAgIHNlbGYuYXR0YWNrX3NwZWVkX2JvbnVzID0ga3YuYXR0YWNrX3NwZWVkCiAgICAgICAgc2VsZjpTZXRTdGFja0NvdW50KG1hdGguZmxvb3Ioc2VsZi5hdHRhY2tfc3BlZWRfYm9udXMgKiAxMDApKQogICAgICAgIHNlbGY6R2V0UGFyZW50KCk6Q2FsY3VsYXRlU3RhdEJvbnVzKHRydWUpCiAgICBlbmQKZW5kCgotLSDlo7DmmI7opoHkv67mlLnnmoTlh73mlbAKZnVuY3Rpb24gbW9kaWZpZXJfZ2pzZDpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfQVRUQUNLU1BFRURfQk9OVVNfQ09OU1RBTlQsIC0tIOWbuuWumuaUu+WHu+mAn+W6puWKoOaIkAogICAgfQplbmQKCi0tIOiOt+WPluaUu+WHu+mAn+W6puWKoOaIkApmdW5jdGlvbiBtb2RpZmllcl9nanNkOkdldE1vZGlmaWVyQXR0YWNrU3BlZWRCb251c19Db25zdGFudCgpCiAgICAtLSDku47moIjorqHmlbDojrflj5bmlLvlh7vpgJ/luqblgLwKICAgIGxvY2FsIHN0YWNrX2NvdW50ID0gc2VsZjpHZXRTdGFja0NvdW50KCkKICAgIGxvY2FsIGF0dGFja19zcGVlZCA9IHN0YWNrX2NvdW50IC8gMTAwLjAKICAgIHJldHVybiBhdHRhY2tfc3BlZWQKZW5kCg==]]
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