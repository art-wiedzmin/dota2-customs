--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[aWYgRGV2VG9vbHMgPT0gbmlsIHRoZW4KICAgIERldlRvb2xzID0gY2xhc3Moe30pCiAgICByZXF1aXJlKCJpbmdhbWUuRGV2VG9vbHMuQ29uZmlnIikKICAgIHJlcXVpcmUoImluZ2FtZS5EZXZUb29scy5HZXQiKQogICAgcmVxdWlyZSgiaW5nYW1lLkRldlRvb2xzLkZ1bmMiKQogICAgcmVxdWlyZSgiaW5nYW1lLkRldlRvb2xzLkNvbW1hbmRzIikKICAgIHJlcXVpcmUoImluZ2FtZS5EZXZUb29scy5DdXN0b20iKQogICAgcmVxdWlyZSgiaW5nYW1lLkRldlRvb2xzLkNoYXQiKQogICAgcmVxdWlyZSgiaW5nYW1lLkRldlRvb2xzLlVpIikKZW5kCgpmdW5jdGlvbiBEZXZUb29sczpJbml0KElEKQogICAgaWYgbm90IElEIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAplbmQKCmZ1bmN0aW9uIERldlRvb2xzOkdhbWVSZWFkeSgpCiAgICBpZiBub3Qgc2VsZjpJc0VuYWJsZWQoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHNlbGY6SW5pdFJlZ2lzdHJ5KCkKICAgIGlmIG5vdCBQRCBvciBub3QgUEQuSURzIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgZm9yIF8sIElEIGluIHBhaXJzKFBELklEcykgZG8KICAgICAgICBpZiBJRCBhbmQgVXRpbCBhbmQgVXRpbC5JRDJJZk9ubGluZSBhbmQgVXRpbDpJRDJJZk9ubGluZShJRCkgdGhlbgogICAgICAgICAgICBzZWxmOlNlbmREYXRhKElEKQogICAgICAgIGVuZAogICAgZW5kCmVuZAo=]]
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