--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g6KKr5Yqo5aSp6LWLIDfvvJrmrbvmiJjvvIjooqvliqjvvIzlpI3mtLvml7bpl7QtMuenku+8jOavj+asoeWkjea0u+WQjjE156eS5YaF5aKe5YqgNjDmlLvpgJ/jgIEzMCXnp7vpgJ/jgIEzMCXnirbmgIHmipfmgKcKCm1vZGlmaWVyX3RhbGVudF9za2lsbF83ID0gY2xhc3Moe30pCgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfc2tpbGxfNzpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF9za2lsbF83OklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF9za2lsbF83OklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50X3NraWxsXzc6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfc2tpbGxfNzpPbkNyZWF0ZWQoKQogICAgaWYgSXNTZXJ2ZXIoKSB0aGVuCgogICAgZW5kCmVuZAo=]]
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