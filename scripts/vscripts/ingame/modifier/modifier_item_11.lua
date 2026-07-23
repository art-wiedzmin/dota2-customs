--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfaXRlbV8xMSA9IGNsYXNzKHt9KQoKLS3mmK/lkKblnKjpnaLmnb/kuIrmmL7npLoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMTpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzExOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMTE6SXNQdXJnYWJsZSgpCiAgICByZXR1cm4gZmFsc2UgLS0g5LiN5Y+v6KKr6amx5pWjCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMTpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMTE6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gInNjcm9sbC9ibGFja19kcmFnb25faGVhcnQiCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMTpBbGxvd0lsbHVzaW9uRHVwbGljYXRlKCkKICAgIHJldHVybiB0cnVlCmVuZAoKLS3liJvlu7rml7borr7nva4KZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMTpPbkNyZWF0ZWQoa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKICAgIC0tIOW8uuWItuWxnuaAp+WIt+aWsAogICAgc2VsZjpGb3JjZVJlZnJlc2goKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMTE6T25SZWZyZXNoKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICAtLXNlbGY6Rm9yY2VSZWZyZXNoKCkKICAgIC0tIHNlbGY6R2V0UGFyZW50KCk6Q2FsY3VsYXRlU3RhdEJvbnVzKHRydWUpCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMTpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfU1BFTExfQU1QTElGWV9QRVJDRU5UQUdFCiAgICAgICAgLS0gTU9ESUZJRVJfUFJPUEVSVFlfQ09PTERPV05fUEVSQ0VOVEFHRSAtLSDmioDog73lhrfljbTnmb7liIbmr5Tlh4/lsJEKICAgIH0KZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzExOkdldE1vZGlmaWVyU3BlbGxBbXBsaWZ5X1BlcmNlbnRhZ2UoKQogICAgcmV0dXJuIDEwCmVuZAo=]]
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