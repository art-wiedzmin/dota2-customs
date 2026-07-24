--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g5a6d566x54mp5ZOB77ya5rOV5pyv5qOx6ZWc77yIaXRlbV9ib3hfMzLvvIktIOaKgOiDveS4jueJqeWTgeWGt+WNtOaXtumXtOWHj+WwkQppZiBtb2RpZmllcl9pdGVtX3NwZWxsX3ByaXNtID09IG5pbCB0aGVuCiAgICBtb2RpZmllcl9pdGVtX3NwZWxsX3ByaXNtID0gY2xhc3Moe30pCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV9zcGVsbF9wcmlzbTpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fc3BlbGxfcHJpc206SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV9zcGVsbF9wcmlzbTpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fc3BlbGxfcHJpc206UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtX3NwZWxsX3ByaXNtOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9DT09MRE9XTl9QRVJDRU5UQUdFCiAgICB9CmVuZAoKLS0g5rOV5pyv5qOx6ZWc77yaMTIlIOWGt+WNtOaXtumXtOWHj+Wwke+8iOaKgOiDveS4jueJqeWTge+8iQpmdW5jdGlvbiBtb2RpZmllcl9pdGVtX3NwZWxsX3ByaXNtOkdldE1vZGlmaWVyUGVyY2VudGFnZUNvb2xkb3duKCkKICAgIHJldHVybiAxMgplbmQKCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtX3NwZWxsX3ByaXNtOk9uQ3JlYXRlZCgpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKZW5kCg==]]
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