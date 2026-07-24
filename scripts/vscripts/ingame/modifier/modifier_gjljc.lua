--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfZ2psamMgPSBjbGFzcyh7fSkKCi0t6K+lbW9kaWZpZXLmmK/lkKbmmK/otJ/pnaLnmoQKZnVuY3Rpb24gbW9kaWZpZXJfZ2psamM6SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKLS3or6Vtb2RpZmllcuiDveWQpuiiq+a4hemZpApmdW5jdGlvbiBtb2RpZmllcl9namxqYzpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfZ2psamM6SXNIaWRkZW4oKQogICAgcmV0dXJuIHRydWUKZW5kCgotLeatu+S6oeaXtuaYr+WQpuenu+mZpApmdW5jdGlvbiBtb2RpZmllcl9namxqYzpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0tIOWIneWni+WMlm1vZGlmaWVyCmZ1bmN0aW9uIG1vZGlmaWVyX2dqbGpjOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAoKICAgIC0tIOWIneWni+WMluWPmOmHjwogICAgc2VsZi5qY2dqbCA9IGt2LmpjZ2psIG9yIDAKICAgIC0tIOS9v+eUqOagiOiuoeaVsOWQjOatpeaVsOaNruWIsOWuouaIt+errwogICAgLS0g5bCG56e75Yqo6YCf5bqm5YC85LmY5LulMTAw5Lul5L+d55WZ5bCP5pWw57K+5bqm77yM5a2Y5YKo5Zyo5qCI6K6h5pWw5LitCiAgICBzZWxmOlNldFN0YWNrQ291bnQoc2VsZi5qY2dqbCAqIDEwMCkKICAgIC0tIOWmguaenOmcgOimgeWTjeW6lOaAp+abtOaWsO+8jOiwg+eUqOi/meS4qgogICAgc2VsZjpGb3JjZVJlZnJlc2goKQplbmQKCi0tIOS7juaVsOaNruihqOS4reivu+WPlum7mOiupOWAvO+8iOWPr+mAie+8iQpmdW5jdGlvbiBtb2RpZmllcl9namxqYzpPblJlZnJlc2goa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKICAgIGlmIGt2LmpjZ2psIHRoZW4KICAgICAgICBzZWxmLmpjZ2psID0ga3YuamNnamwKICAgICAgICAtLSDmm7TmlrDmoIjorqHmlbAKICAgICAgICBzZWxmOlNldFN0YWNrQ291bnQoc2VsZi5qY2dqbCAqIDEwMCkKICAgIGVuZAogICAgLS1zZWxmOkZvcmNlUmVmcmVzaCgpCmVuZAoKLS0g5aOw5piO6KaB5L+u5pS555qE5Ye95pWwCmZ1bmN0aW9uIG1vZGlmaWVyX2dqbGpjOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9QUkVBVFRBQ0tfQk9OVVNfREFNQUdFCiAgICB9CmVuZAoKLS0g5Yqo5oCB6L+U5Zue5oqk55SyCmZ1bmN0aW9uIG1vZGlmaWVyX2dqbGpjOkdldE1vZGlmaWVyUHJlQXR0YWNrX0JvbnVzRGFtYWdlKCkKICAgIC0tIOS7juagiOiuoeaVsOiOt+WPluenu+WKqOmAn+W6puWAvO+8iOmZpOS7pTEwMOaBouWkjeWOn+Wni+WAvO+8iQogICAgbG9jYWwgc3RhY2tfY291bnQgPSBzZWxmOkdldFN0YWNrQ291bnQoKQogICAgbG9jYWwgaGpfYm9udXMgPSBzdGFja19jb3VudCAvIDEwMAogICAgcmV0dXJuIGhqX2JvbnVzCmVuZAo=]]
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