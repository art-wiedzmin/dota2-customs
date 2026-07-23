--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gUGVyc29uOkdldFVJRGF0YShJRCwgZGF0YSkKICAgIGlmIG5vdCBJRCBvciBub3QgZGF0YSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIC0t5pqC5YGc56aB5q2i5Lyg5pWw5o2uCiAgICAtLSBpZiBHYW1lUnVsZXM6SXNHYW1lUGF1c2VkKCkgdGhlbgogICAgLS0gICAgIHJldHVybgogICAgLS0gZW5kCiAgICAtLeWIneWni+WMluaVsOaNrgogICAgaWYgZGF0YS50cCA9PSAiaW5pdCIgdGhlbgogICAgICAgIHNlbGY6U2VuZERhdGEoSUQpCiAgICBlbmQKICAgIGlmIGRhdGEudHAgPT0gIk9wZW5QYWdlIiB0aGVuCiAgICAgICAgc2VsZjpPcGVuUGFnZShJRCkKICAgIGVuZAogICAgaWYgZGF0YS50cCA9PSAiQ2xvc2VQYWdlIiB0aGVuCiAgICAgICAgc2VsZjpDbG9zZVBhZ2UoSUQpCiAgICBlbmQKZW5kCgotLee7meWJjeerr+WPkeaVsOaNrgpmdW5jdGlvbiBQZXJzb246U2VuZERhdGEoSUQpCiAgICBpZiBub3QgSUQgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBsb2NhbCBkYXRhID0gc2VsZi5EYXRhW0lEXQogICAgVXRpbDpTZW5kMkpzSUQoIlVJX1BlcnNvbiIsIGRhdGEsIElEKQplbmQK]]
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