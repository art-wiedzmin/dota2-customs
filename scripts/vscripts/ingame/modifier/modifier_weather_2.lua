--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfd2VhdGhlcl8yID0gY2xhc3Moe30pCgotLeaYr+WQpuWcqOmdouadv+S4iuaYvuekugpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzI6SXNIaWRkZW4oKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8yOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMjpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZSAtLSDkuI3lj6/ooqvpqbHmlaMKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzI6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzI6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gInNjcm9sbC93ZWF0aGVyX3Blc3RpbGVuY2VfcG5nIgplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMjpBbGxvd0lsbHVzaW9uRHVwbGljYXRlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t54uC6aOOCi0t5Yib5bu65pe26K6+572uCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMjpPbkNyZWF0ZWQoa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKICAgIHNlbGY6U2V0RHVyYXRpb24oa3YuZHVyLCB0cnVlKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMjpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfQVRUQUNLU1BFRURfQk9OVVNfQ09OU1RBTlQsIC0t5pS75Ye76YCf5bqmCiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfTU9WRVNQRUVEX0JPTlVTX1BFUkNFTlRBR0UsIC0t56e75Yqo6YCf5bqm5Yqg5oiQCiAgICB9CmVuZAoKLS0g6I635Y+W5pS75Ye76YCf5bqm5bi45pWw5aKe55uKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMjpHZXRNb2RpZmllckF0dGFja1NwZWVkQm9udXNfQ29uc3RhbnQoKQogICAgcmV0dXJuIDYwCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8yOkdldE1vZGlmaWVyTW92ZVNwZWVkQm9udXNfUGVyY2VudGFnZSgpCiAgICByZXR1cm4gMTAKZW5kCg==]]
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