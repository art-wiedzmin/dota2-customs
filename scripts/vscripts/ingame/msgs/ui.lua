--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gTXNnczpHZXRVSURhdGEoSUQsIGRhdGEpCiAgICBpZiBub3QgSUQgb3Igbm90IGRhdGEgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICAtLeaaguWBnOemgeatouS8oOaVsOaNrgogICAgaWYgR2FtZVJ1bGVzOklzR2FtZVBhdXNlZCgpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgLS3liJ3lp4vljJbmlbDmja4KICAgIGlmIGRhdGEudHAgPT0gImluaXQiIHRoZW4KICAgICAgICBzZWxmOlNlbmREYXRhKElEKQogICAgZW5kCiAgICBpZiBkYXRhLnRwID09ICJPcGVuUGFnZSIgdGhlbgogICAgICAgIHNlbGY6T3BlblBhZ2UoSUQpCiAgICBlbmQKICAgIGlmIGRhdGEudHAgPT0gIkNsb3NlUGFnZSIgdGhlbgogICAgICAgIHNlbGY6Q2xvc2VQYWdlKElEKQogICAgZW5kCmVuZAoKLS3nu5nliY3nq6/lj5HmlbDmja4KZnVuY3Rpb24gTXNnczpTZW5kRGF0YShJRCkKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIGRhdGEgPSBzZWxmLkRhdGFbSURdCiAgICAtLSBwcmludChkYXRhKQogICAgVXRpbDpTZW5kMkpzSUQoIlVJX01zZ3MiLCBkYXRhLCBJRCkKZW5kCg==]]
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