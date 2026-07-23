--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfYWJpbGl0eV8yNl9idWZmID0gY2xhc3Moe30pCgotLeaYr+WQpuWcqOmdouadv+S4iuaYvuekugpmdW5jdGlvbiBtb2RpZmllcl9hYmlsaXR5XzI2X2J1ZmY6SXNIaWRkZW4oKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYWJpbGl0eV8yNl9idWZmOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2FiaWxpdHlfMjZfYnVmZjpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZSAtLSDkuI3lj6/ooqvpqbHmlaMKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hYmlsaXR5XzI2X2J1ZmY6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hYmlsaXR5XzI2X2J1ZmY6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gInNjcm9sbC9hYmlsaXR5X2l0ZW1fMjYiCmVuZAoKLS3liJvlu7rml7borr7nva4KZnVuY3Rpb24gbW9kaWZpZXJfYWJpbGl0eV8yNl9idWZmOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgLS0g5aaC5p6c5LuO546w5pyJbW9kaWZpZXLliJvlu7rvvIzojrflj5bloIblj6Dkv6Hmga8KICAgIGlmIHNlbGY6R2V0U3RhY2tDb3VudCgpID09IDAgdGhlbgogICAgICAgIHNlbGY6U2V0U3RhY2tDb3VudCgxKQogICAgZW5kCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYWJpbGl0eV8yNl9idWZmOk9uUmVmcmVzaChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgbG9jYWwgY291bnQgPSBzZWxmOkdldFBhcmVudCgpCiAgICAtLSDmm7TmlrDmoIjorqHmlbAKICAgIC0tIHNlbGY6U2V0U3RhY2tDb3VudChjb3VudCAqIDEwKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2FiaWxpdHlfMjZfYnVmZjpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfVE9PTFRJUCwKICAgIH0KZW5kCgotLSDlt6Xlhbfmj5DnpLoy77ya5pi+56S65bGC5pWwCmZ1bmN0aW9uIG1vZGlmaWVyX2FiaWxpdHlfMjZfYnVmZjpPblRvb2x0aXAoKQogICAgcmV0dXJuIHNlbGY6R2V0U3RhY2tDb3VudCgpICogMjAKZW5kCg==]]
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