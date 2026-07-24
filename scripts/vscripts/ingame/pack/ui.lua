--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gUGFjazpHZXRVSURhdGEoSUQsIGRhdGEpCiAgICBpZiBub3QgSUQgb3Igbm90IGRhdGEgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICAtLeaaguWBnOemgeatouS8oOaVsOaNrgogICAgaWYgR2FtZVJ1bGVzOklzR2FtZVBhdXNlZCgpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgLS3liJ3lp4vljJbmlbDmja4KICAgIGlmIGRhdGEudHAgPT0gImluaXQiIHRoZW4KICAgICAgICBzZWxmOlNlbmREYXRhKElEKQogICAgZW5kCiAgICBpZiBkYXRhLnRwID09ICJHZXRVbml0IiB0aGVuCiAgICAgICAgc2VsZjpHZXRVbml0KElELCBkYXRhLnRleHQpCiAgICBlbmQKICAgIGlmIGRhdGEudHAgPT0gIkdldEhlcm8iIHRoZW4KICAgICAgICBzZWxmOlNlbGVjdEhlcm8oSUQsIGRhdGEudGV4dCkKICAgIGVuZAogICAgaWYgZGF0YS50cCA9PSAiVGFja0l0ZW0iIHRoZW4KICAgICAgICBzZWxmOlRhY2tJdGVtKElELCBkYXRhLnRleHQpCiAgICBlbmQKICAgIGlmIGRhdGEudHAgPT0gIkNsb3NlUGFnZSIgdGhlbgogICAgICAgIHNlbGY6Q2xvc2VQYWdlKElEKQogICAgZW5kCmVuZAoKLS3nu5nliY3nq6/lj5HmlbDmja4KZnVuY3Rpb24gUGFjazpTZW5kRGF0YShJRCkKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIGhlcm8gPSBVdGlsOklEMkhlcm8oSUQpCiAgICBpZiBub3QgaGVybyB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIHBhY2tfdHAgPSAiVGVhbSIgLi4gaGVybzpHZXRUZWFtKCkKICAgIHNlbGYuRGF0YVtJRF0ucGFjayA9IHNlbGZbcGFja190cF0KICAgIFV0aWw6U2VuZDJKc0lEKCJVSV9QYWNrIiwgc2VsZi5EYXRhW0lEXSwgSUQpCmVuZAoKLS3lj5HpgIHlhazlhbHmlbDmja4s5ZCM5q2l5Yiw546p5a625Liq5Lq65LuT5bqTCmZ1bmN0aW9uIFBhY2s6U2VuZFB1YmxpY0RhdGEodGVhbSkKICAgIGZvciBrLCB2IGluIHBhaXJzKHV0aWxleDpHZXRBbGxQbGF5ZXIoKSkgZG8KICAgICAgICBsb2NhbCBoZXJvID0gVXRpbDpJRDJIZXJvKHYpCiAgICAgICAgaWYgaGVybyBhbmQgaGVybzpHZXRUZWFtKCkgPT0gdGVhbSBhbmQgc2VsZjpHZXRQYWdlKHYpIHRoZW4KICAgICAgICAgICAgUGFjazpTZW5kRGF0YSh2KQogICAgICAgIGVuZAogICAgZW5kCmVuZAo=]]
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