--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[aWYgbW9kaWZpZXJfdGVzdHRhbmsgPT0gbmlsIHRoZW4KICAgIG1vZGlmaWVyX3Rlc3R0YW5rID0gY2xhc3Moe30pCmVuZApmdW5jdGlvbiBtb2RpZmllcl90ZXN0dGFuazpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90ZXN0dGFuazpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90ZXN0dGFuazpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3Rlc3R0YW5rOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3Rlc3R0YW5rOk9uRGVzdHJveSgpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90ZXN0dGFuazpDaGVja1N0YXRlKCkKICAgIGxvY2FsIHN0YXRlID0gewogICAgICAgIFtNT0RJRklFUl9TVEFURV9ESVNBUk1FRF0gPSB0cnVlLCAtLSDnvLTmorAg5LiN6IO95pmu5pS7CiAgICB9CiAgICByZXR1cm4gc3RhdGUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90ZXN0dGFuazpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIGxvY2FsIGZ1bmNzID0gewogICAgICAgIC0tTU9ESUZJRVJfUFJPUEVSVFlfTUlOX0hFQUxUSAogICAgfQogICAgcmV0dXJuIGZ1bmNzCmVuZAo=]]
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