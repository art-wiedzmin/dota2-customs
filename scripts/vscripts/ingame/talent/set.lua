--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS3miZPlvIDpobXpnaIKZnVuY3Rpb24gVGFsZW50Ok9wZW5QYWdlKElEKQogICAgaWYgbm90IElEIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgc2VsZi5EYXRhW0lEXS5wYWdlID0gdHJ1ZQogICAgc2VsZjpTZW5kRGF0YShJRCkKZW5kCgpmdW5jdGlvbiBUYWxlbnQ6Q2xvc2VQYWdlKElEKQogICAgaWYgbm90IElEIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgc2VsZi5EYXRhW0lEXS5wYWdlID0gZmFsc2UKICAgIHNlbGY6U2VuZERhdGEoSUQpCmVuZAoKZnVuY3Rpb24gVGFsZW50Ok9wZW5UZXh0UGFnZShJRCkKICAgIHNlbGYuRGF0YVtJRF0udGV4dF9wYWdlID0gdHJ1ZQogICAgc2VsZjpTZW5kS2lsbERhdGEoSUQpCmVuZAoKZnVuY3Rpb24gVGFsZW50OkNsb3NlVGV4dFBhZ2UoSUQpCiAgICBzZWxmLkRhdGFbSURdLnRleHRfcGFnZSA9IGZhbHNlCiAgICBzZWxmOlNlbmRLaWxsRGF0YShJRCkKZW5kCg==]]
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