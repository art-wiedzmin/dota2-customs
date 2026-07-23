--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfd2VhdGhlcl8xID0gY2xhc3Moe30pCgotLeaYr+WQpuWcqOmdouadv+S4iuaYvuekugpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzE6SXNIaWRkZW4oKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8xOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMTpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZSAtLSDkuI3lj6/ooqvpqbHmlaMKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzE6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzE6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gInNjcm9sbC93ZWF0aGVyX2Z4X3BzZCIKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzE6QWxsb3dJbGx1c2lvbkR1cGxpY2F0ZSgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLeiJs+mYswotLeWIm+W7uuaXtuiuvue9rgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzE6T25DcmVhdGVkKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBzZWxmOlNldER1cmF0aW9uKGt2LmR1ciwgdHJ1ZSkKZW5kCgotLSDlhajlm77lpKnmsJTnspLlrZDnlLEgTWFpbkdhbWU6V2VhdGhlclN0YXIg5Y2V54K55oyC6L2977yM5q2k5aSE5LiN5YaN5Y+g6Iux6ZuE6Lqr5LiK54m55pWICgotLSDlo7DmmI7kv67mlLnlh73mlbAKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8xOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9CQVNFREFNQUdFT1VUR09JTkdfUEVSQ0VOVEFHRSwKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9TUEVMTF9BTVBMSUZZX1BFUkNFTlRBR0UKICAgIH0KZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzE6R2V0TW9kaWZpZXJCYXNlRGFtYWdlT3V0Z29pbmdfUGVyY2VudGFnZSgpCiAgICByZXR1cm4gMzAKZW5kCgotLSDojrflj5bmioDog73lop7lvLrnmb7liIbmr5QKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8xOkdldE1vZGlmaWVyU3BlbGxBbXBsaWZ5X1BlcmNlbnRhZ2UoKQogICAgcmV0dXJuIDE1CmVuZAo=]]
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