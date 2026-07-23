--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfYm94XzI4ID0gY2xhc3Moe30pCgotLeivpW1vZGlmaWVy5piv5ZCm5piv6LSf6Z2i55qECmZ1bmN0aW9uIG1vZGlmaWVyX2JveF8yODpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLeivpW1vZGlmaWVy6IO95ZCm6KKr5riF6ZmkCmZ1bmN0aW9uIG1vZGlmaWVyX2JveF8yODpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfYm94XzI4OklzSGlkZGVuKCkKICAgIHJldHVybiB0cnVlCmVuZAoKLS3mrbvkuqHml7bmmK/lkKbnp7vpmaQKZnVuY3Rpb24gbW9kaWZpZXJfYm94XzI4OlJlbW92ZU9uRGVhdGgoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKLS0g5Yid5aeL5YyWbW9kaWZpZXIKZnVuY3Rpb24gbW9kaWZpZXJfYm94XzI4Ok9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAplbmQKCi0tIOWjsOaYjuimgeS/ruaUueeahOWHveaVsApmdW5jdGlvbiBtb2RpZmllcl9ib3hfMjg6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIE1PRElGSUVSX0VWRU5UX09OX0FUVEFDS19MQU5ERUQsIC0tIOWbuuWumuaUu+WHu+mAn+W6puWKoOaIkAogICAgfQplbmQKCi0tIOaUu+WHu+WRveS4reaXtgpmdW5jdGlvbiBtb2RpZmllcl9ib3hfMjg6T25BdHRhY2tMYW5kZWQocGFyYW1zKQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBsb2NhbCBhdHRhY2tlciA9IHBhcmFtcy5hdHRhY2tlcgogICAgbG9jYWwgdGFyZ2V0ID0gcGFyYW1zLnRhcmdldAogICAgaWYgYXR0YWNrZXIgfj0gc2VsZjpHZXRQYXJlbnQoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHV0aWxleDpVbml0RGFtKGF0dGFja2VyLCB0YXJnZXQsIDUwLCAibWYiKQplbmQK]]
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