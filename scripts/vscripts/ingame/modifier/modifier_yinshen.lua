--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g5paH5Lu25ZCN77yabW9kaWZpZXJfeWluc2hlbi5sdWEKbW9kaWZpZXJfeWluc2hlbiA9IGNsYXNzKHt9KQoKLS0g5Z+656GA6YWN572uCmZ1bmN0aW9uIG1vZGlmaWVyX3lpbnNoZW46SXNIaWRkZW4oKQogICAgcmV0dXJuIGZhbHNlIC0tIOmakOiXj+eKtuaAgeagj+aYvuekuuWbvuaghwplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3lpbnNoZW46SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfeWluc2hlbjpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZSAtLSDkuI3lj6/ooqvpqbHmlaMKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl95aW5zaGVuOlJlbW92ZU9uRGVhdGgoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfeWluc2hlbjpBbGxvd0lsbHVzaW9uRHVwbGljYXRlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3lpbnNoZW46T25DcmVhdGVkKGt2KQogICAgaWYgSXNTZXJ2ZXIoKSB0aGVuCgogICAgZW5kCmVuZAoKLS0g6KaG55uW5YWN55ar5bGe5oCnCmZ1bmN0aW9uIG1vZGlmaWVyX3lpbnNoZW46RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewoKICAgIH0KZW5kCgpmdW5jdGlvbiBtb2RpZmllcl95aW5zaGVuOkNoZWNrU3RhdGUoKQogICAgcmV0dXJuIHsKICAgICAgICBbTU9ESUZJRVJfU1RBVEVfSU5WSVNJQkxFXSA9IHRydWUsIC0tIOmakOi6qwogICAgfQplbmQK]]
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