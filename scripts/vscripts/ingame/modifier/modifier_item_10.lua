--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfaXRlbV8xMCA9IGNsYXNzKHt9KQoKLS3mmK/lkKblnKjpnaLmnb/kuIrmmL7npLoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMDpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzEwOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMTA6SXNQdXJnYWJsZSgpCiAgICByZXR1cm4gZmFsc2UgLS0g5LiN5Y+v6KKr6amx5pWjCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMDpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMTA6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gInNjcm9sbC9uZWl6YWlxaWFubmVuZyIKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzEwOkFsbG93SWxsdXNpb25EdXBsaWNhdGUoKQogICAgcmV0dXJuIHRydWUKZW5kCgotLeWIm+W7uuaXtuiuvue9rgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzEwOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgbG9jYWwgY2FzdGVyID0gc2VsZjpHZXRQYXJlbnQoKQogICAgY2FzdGVyOk1vZGlmeVN0cmVuZ3RoKDEwKQogICAgY2FzdGVyOk1vZGlmeUFnaWxpdHkoMTApCiAgICBjYXN0ZXI6TW9kaWZ5SW50ZWxsZWN0KDEwKQplbmQKCg==]]
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