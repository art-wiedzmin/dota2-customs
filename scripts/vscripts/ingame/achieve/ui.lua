--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gQWNoaWV2ZU1vZHVsZTpHZXRVSURhdGEoSUQsIGRhdGEpCiAgICBpZiBub3QgSUQgb3Igbm90IGRhdGEgb3Igbm90IGRhdGEudHAgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCgogICAgbG9jYWwgdHAgPSBkYXRhLnRwCiAgICBpZiB0cCA9PSAiaW5pdCIgb3IgdHAgPT0gIk9wZW5QYWdlIiB0aGVuCiAgICAgICAgc2VsZi5EYXRhW0lEXS5wYWdlID0gMQogICAgICAgIHNlbGY6U2VuZERhdGEoSUQpCiAgICBlbHNlaWYgdHAgPT0gIkNsb3NlUGFnZSIgdGhlbgogICAgICAgIHNlbGYuRGF0YVtJRF0ucGFnZSA9IDAKICAgICAgICBzZWxmOlNlbmREYXRhKElEKQogICAgZWxzZWlmIHRwID09ICJTd2l0Y2hUYWIiIGFuZCBkYXRhLnRhYiB0aGVuCiAgICAgICAgc2VsZi5EYXRhW0lEXS50YWIgPSBkYXRhLnRhYgogICAgICAgIHNlbGY6U2VuZERhdGEoSUQpCiAgICBlbHNlaWYgdHAgPT0gIlN5bmMiIHRoZW4KICAgICAgICBzZWxmOlNlbmREYXRhKElEKQogICAgZWxzZWlmIHRwID09ICJDbGFpbSIgdGhlbgogICAgICAgIGxvY2FsIGNhdGVnb3J5ID0gZGF0YS5jYXRlZ29yeSBvciBzZWxmOlRhYlRvQ2F0ZWdvcnkoZGF0YS50YWIpCiAgICAgICAgbG9jYWwga2V5ID0gZGF0YS5pZCBvciBkYXRhLmtleQogICAgICAgIGlmIGNhdGVnb3J5IGFuZCBrZXkgYW5kIGtleSB+PSAiIiB0aGVuCiAgICAgICAgICAgIHNlbGY6RW5xdWV1ZUNsYWltKElELCBjYXRlZ29yeSwga2V5KQogICAgICAgIGVuZAogICAgZW5kCmVuZAoKZnVuY3Rpb24gQWNoaWV2ZU1vZHVsZTpTZW5kRGF0YShJRCkKICAgIGlmIG5vdCBJRCBvciBub3Qgc2VsZi5EYXRhW0lEXSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIGQgPSBzZWxmLkRhdGFbSURdCiAgICBVdGlsOlNlbmQySnNJRCgiVUlfQWNoaWV2ZSIsIHsKICAgICAgICBwYWdlID0gZC5wYWdlLAogICAgICAgIHRhYiA9IGQudGFiLAogICAgICAgIGVuYWJsZWQgPSBkLmVuYWJsZWQgPT0gdHJ1ZSwKICAgICAgICBhY2hpZXZlID0gZC5hY2hpZXZlLAogICAgICAgIHJlY2hhcmdlX3RvdGFsID0gZC5yZWNoYXJnZV90b3RhbCBvciAwLAogICAgICAgIGhhc19jbGFpbWFibGUgPSBzZWxmOkhhc0NsYWltYWJsZVJld2FyZHMoSUQpLAogICAgfSwgSUQpCmVuZAo=]]
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