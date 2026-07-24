--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfYm94XzI3ID0gY2xhc3Moe30pCgotLeivpW1vZGlmaWVy5piv5ZCm5piv6LSf6Z2i55qECmZ1bmN0aW9uIG1vZGlmaWVyX2JveF8yNzpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLeivpW1vZGlmaWVy6IO95ZCm6KKr5riF6ZmkCmZ1bmN0aW9uIG1vZGlmaWVyX2JveF8yNzpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfYm94XzI3OklzSGlkZGVuKCkKICAgIHJldHVybiB0cnVlCmVuZAoKLS3mrbvkuqHml7bmmK/lkKbnp7vpmaQKZnVuY3Rpb24gbW9kaWZpZXJfYm94XzI3OlJlbW92ZU9uRGVhdGgoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKLS0g5Yid5aeL5YyWbW9kaWZpZXIKZnVuY3Rpb24gbW9kaWZpZXJfYm94XzI3Ok9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAplbmQKCi0tIOWjsOaYjuimgeS/ruaUueeahOWHveaVsApmdW5jdGlvbiBtb2RpZmllcl9ib3hfMjc6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX0hFQUxUSF9CT05VUywgLS0g5Zu65a6a5pS75Ye76YCf5bqm5Yqg5oiQCiAgICB9CmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYm94XzI3OkdldE1vZGlmaWVySGVhbHRoQm9udXMoKQogICAgcmV0dXJuIDUwMAplbmQK]]
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