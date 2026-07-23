--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gT3ZlckRhdGE6R2V0VUlEYXRhKElELCBkYXRhKQogICAgaWYgbm90IElEIG9yIG5vdCBkYXRhIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgLS3mmoLlgZznpoHmraLkvKDmlbDmja4KICAgIC0tIGlmIEdhbWVSdWxlczpJc0dhbWVQYXVzZWQoKSB0aGVuCiAgICAtLSAgICAgcmV0dXJuCiAgICAtLSBlbmQKICAgIC0t5Yid5aeL5YyW5pWw5o2uCiAgICBpZiBkYXRhLnRwID09ICJpbml0IiB0aGVuCiAgICAgICAgc2VsZjpTZW5kRGF0YShJRCkKICAgIGVuZAogICAgaWYgZGF0YS50cCA9PSAiT3BlblBhZ2UiIHRoZW4KICAgICAgICBzZWxmOk9wZW5QYWdlKElEKQogICAgZW5kCiAgICBpZiBkYXRhLnRwID09ICJDbG9zZVBhZ2UiIHRoZW4KICAgICAgICBzZWxmOkNsb3NlUGFnZShJRCkKICAgIGVuZAplbmQKCi0t57uZ5YmN56uv5Y+R5pWw5o2uCmZ1bmN0aW9uIE92ZXJEYXRhOlNlbmREYXRhKElEKQogICAgaWYgbm90IElEIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgbG9jYWwgZGF0YSA9IHNlbGYuRGF0YVtJRF0KICAgIC0tIHByaW50KGRhdGEpCiAgICBVdGlsOlNlbmQySnNJRCgiVUlfT3ZlckRhdGEiLCBkYXRhLCBJRCkKZW5kCg==]]
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