--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gSW52aXRlOklzRW5hYmxlZCgpCiAgICByZXR1cm4gc2VsZi5FbmFibGVkIH49IGZhbHNlCmVuZAoKZnVuY3Rpb24gSW52aXRlOkdldFVJRGF0YShJRCwgZGF0YSkKICAgIGlmIG5vdCBJRCBvciBub3QgZGF0YSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGlmIG5vdCBzZWxmOklzRW5hYmxlZCgpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgLS3mmoLlgZznpoHmraLkvKDmlbDmja4KICAgIGlmIEdhbWVSdWxlczpJc0dhbWVQYXVzZWQoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIC0t5Yid5aeL5YyW5pWw5o2uCiAgICBpZiBkYXRhLnRwID09ICJpbml0IiB0aGVuCiAgICAgICAgc2VsZjpTZW5kRGF0YShJRCkKICAgIGVuZAogICAgLS3miZPlvIDlrp3nrrHpobXpnaIKICAgIGlmIGRhdGEudHAgPT0gIk9wZW5QYWdlIiB0aGVuCiAgICAgICAgc2VsZjpPcGVuUGFnZShJRCkKICAgIGVuZAogICAgLS3lhbPpl63lrp3nrrHpobXpnaIKICAgIGlmIGRhdGEudHAgPT0gIkNsb3NlUGFnZSIgdGhlbgogICAgICAgIHNlbGY6Q2xvc2VQYWdlKElEKQogICAgZW5kCiAgICAtLei+k+WFpemCgOivtwogICAgaWYgZGF0YS50cCA9PSAiV3JpdGVJbnZpdGUiIHRoZW4KICAgICAgICBzZWxmOldyaXRlSW52aXRlKElELCBkYXRhLnRleHQpCiAgICBlbmQKICAgIC0t6I635Y+W5aWW5YqxCiAgICBpZiBkYXRhLnRwID09ICJHZXRJbnZpdGUiIHRoZW4KICAgICAgICBzZWxmOkdldEludml0ZShJRCwgZGF0YS50ZXh0KQogICAgZW5kCmVuZAoKZnVuY3Rpb24gSW52aXRlOlNlbmREYXRhKElEKQogICAgaWYgbm90IElEIG9yIG5vdCBzZWxmOklzRW5hYmxlZCgpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgVXRpbDpTZW5kMkpzSUQoIlVJX0ludml0ZSIsIHNlbGYuRGF0YVtJRF0sIElEKQplbmQK]]
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