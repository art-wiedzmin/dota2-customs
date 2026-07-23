--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g6Zu36ZyG6ZmN5LiW77ya5Y+X5LykICsxNSXvvIjlpKnmsJTkuYvlrZAgbW9kaWZpZXJfd2VhdGhlcl81IOWFjeeWq++8jOeUsSBNYWluR2FtZSDmlr3liqDml7bot7Pov4fvvIkKbW9kaWZpZXJfd2VhdGhlcl82ID0gY2xhc3Moe30pCgpsb2NhbCBJTkNPTUlOR19ETUdfUENUID0gMTUKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfNjpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzY6SXNEZWJ1ZmYoKQogICAgcmV0dXJuIHRydWUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzY6SXNQdXJnYWJsZSgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzY6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzY6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gInNjcm9sbC93ZWF0aGVyXzYiCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl82OkFsbG93SWxsdXNpb25EdXBsaWNhdGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl82Ok9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgc2VsZjpTZXREdXJhdGlvbihrdi5kdXIsIHRydWUpCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl82OkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9JTkNPTUlOR19EQU1BR0VfUEVSQ0VOVEFHRSwKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9UT09MVElQLAogICAgfQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfNjpHZXRNb2RpZmllckluY29taW5nRGFtYWdlX1BlcmNlbnRhZ2UoKQogICAgcmV0dXJuIElOQ09NSU5HX0RNR19QQ1QKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzY6T25Ub29sdGlwKCkKICAgIHJldHVybiBJTkNPTUlOR19ETUdfUENUCmVuZAo=]]
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