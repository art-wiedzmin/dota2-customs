--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gQm9vazpHZXRVSURhdGEoSUQsIGRhdGEpCiAgICBpZiBub3QgSUQgb3Igbm90IGRhdGEgdGhlbiByZXR1cm4gZW5kCiAgICAtLSDmmoLlgZznpoHmraLkvKDmlbDmja4KICAgIC0tIGlmIEdhbWVSdWxlczpJc0dhbWVQYXVzZWQoKSB0aGVuIHJldHVybiBlbmQKICAgIC0tIOWIneWni+WMluaVsOaNrgogICAgaWYgZGF0YS50cCA9PSAiaW5pdCIgdGhlbiBzZWxmOlNlbmREYXRhKElEKSBlbmQKICAgIGlmIGRhdGEudHAgPT0gIk9wZW5QYWdlIiB0aGVuIHNlbGY6T3BlblBhZ2UoSUQpIGVuZAogICAgaWYgZGF0YS50cCA9PSAiQ2xvc2VQYWdlIiB0aGVuIHNlbGY6Q2xvc2VQYWdlKElEKSBlbmQKICAgIGlmIGRhdGEudHAgPT0gIlNlbGVjdFBhZ2UiIHRoZW4gc2VsZjpTZWxlY3RQYWdlKElELCBkYXRhLnRleHQpIGVuZAogICAgaWYgZGF0YS50cCA9PSAiTGVhcm5BYmlsaXR5IiB0aGVuIHNlbGY6TGVhcm5BYmlsaXR5KElELCBkYXRhLnRleHQpIGVuZAplbmQKCmZ1bmN0aW9uIEJvb2s6U2VuZERhdGEoSUQpCiAgICBpZiBub3QgSUQgdGhlbiByZXR1cm4gZW5kCiAgICBsb2NhbCBkYXRhID0gc2VsZi5EYXRhW0lEXQogICAgVXRpbDpTZW5kMkpzSUQoIlVJX0Jvb2siLCBkYXRhLCBJRCkKZW5kCgpmdW5jdGlvbiBCb29rOk9wZW5QYWdlKElEKQogICAgaWYgbm90IElEIHRoZW4gcmV0dXJuIGVuZAogICAgaWYgSXNJblRvb2xzTW9kZSgpIGFuZCBzZWxmLkluaXRIZXJvTGlzdCB0aGVuCiAgICAgICAgc2VsZjpJbml0SGVyb0xpc3QoSUQpCiAgICBlbmQKICAgIHNlbGYuRGF0YVtJRF0ucGFnZSA9IHRydWUKICAgIHNlbGY6U2VuZERhdGEoSUQpCmVuZAoKZnVuY3Rpb24gQm9vazpDbG9zZVBhZ2UoSUQpCiAgICBpZiBub3QgSUQgdGhlbiByZXR1cm4gZW5kCiAgICBzZWxmLkRhdGFbSURdLnBhZ2UgPSBmYWxzZQogICAgc2VsZjpTZW5kRGF0YShJRCkKZW5kCgpmdW5jdGlvbiBCb29rOlNlbGVjdFBhZ2UoSUQsIHRleHQpCiAgICBpZiBub3QgSUQgb3Igbm90IHRleHQgdGhlbiByZXR1cm4gZW5kCiAgICBzZWxmLkRhdGFbSURdLnBhZ2VfdHlwZSA9IHRleHQKICAgIHNlbGY6U2VuZERhdGEoSUQpCmVuZAoKZnVuY3Rpb24gQm9vazpMZWFybkFiaWxpdHkoSUQsIG5hbWUpCiAgICBpZiBub3QgSXNJblRvb2xzTW9kZSgpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgbm90IElEIG9yIG5vdCBuYW1lIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgU2tpbGwgYW5kIFNraWxsLlRvb2xzTGVhcm5Ta2lsbEJvb2tDeWNsaWMgdGhlbgogICAgICAgIFNraWxsOlRvb2xzTGVhcm5Ta2lsbEJvb2tDeWNsaWMoSUQsIG5hbWUpCiAgICBlbmQKZW5kCg==]]
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