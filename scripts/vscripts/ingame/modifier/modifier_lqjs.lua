--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfbHFqcyA9IGNsYXNzKHt9KQoKLS3or6Vtb2RpZmllcuaYr+WQpuaYr+i0n+mdoueahApmdW5jdGlvbiBtb2RpZmllcl9scWpzOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLog73lkKbooqvmuIXpmaQKZnVuY3Rpb24gbW9kaWZpZXJfbHFqczpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfbHFqczpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCi0t5q275Lqh5pe25piv5ZCm56e76ZmkCmZ1bmN0aW9uIG1vZGlmaWVyX2xxanM6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLSDliJ3lp4vljJZtb2RpZmllcgpmdW5jdGlvbiBtb2RpZmllcl9scWpzOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgbG9jYWwgaGVybyA9IHNlbGY6R2V0UGFyZW50KCkKICAgIGxvY2FsIElEID0gVXRpbDpIZXJvMklEKGhlcm8pCiAgICBzZWxmLm51bSA9IEhlcm9EYXRhLkRhdGFbSURdLmhlcm9fYXR0ci5scWpzCiAgICAtLSDkvb/nlKjmoIjorqHmlbDlkIzmraXmlbDmja7liLDlrqLmiLfnq68KICAgIC0tIOWwhuenu+WKqOmAn+W6puWAvOS5mOS7pTEwMOS7peS/neeVmeWwj+aVsOeyvuW6pu+8jOWtmOWCqOWcqOagiOiuoeaVsOS4rQogICAgLS0gc2VsZjpTZXRTdGFja0NvdW50KHNlbGYubnVtICogMTAwKQogICAgLS0g5aaC5p6c6ZyA6KaB5ZON5bqU5oCn5pu05paw77yM6LCD55So6L+Z5LiqCiAgICBzZWxmOkZvcmNlUmVmcmVzaCgpCmVuZAoKLS0g5Yi35pawbW9kaWZpZXIKZnVuY3Rpb24gbW9kaWZpZXJfbHFqczpPblJlZnJlc2goa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKICAgIGxvY2FsIGhlcm8gPSBzZWxmOkdldFBhcmVudCgpCiAgICBsb2NhbCBJRCA9IFV0aWw6SGVybzJJRChoZXJvKQogICAgc2VsZi5udW0gPSBIZXJvRGF0YS5EYXRhW0lEXS5oZXJvX2F0dHIubHFqcwogICAgaGVybzpDYWxjdWxhdGVTdGF0Qm9udXModHJ1ZSkKICAgIHNlbGY6U2V0U3RhY2tDb3VudChzZWxmLm51bSAqIDEwMCkKZW5kCgotLSDlo7DmmI7opoHkv67mlLnnmoTlh73mlbAKZnVuY3Rpb24gbW9kaWZpZXJfbHFqczpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfQ09PTERPV05fUEVSQ0VOVEFHRSwKICAgIH0KZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9scWpzOkdldE1vZGlmaWVyUGVyY2VudGFnZUNvb2xkb3duKCkKICAgIGxvY2FsIHN0YWNrX2NvdW50ID0gc2VsZjpHZXRTdGFja0NvdW50KCkKICAgIGxvY2FsIGhqX2JvbnVzID0gc3RhY2tfY291bnQgLyAxMDAKICAgIHJldHVybiBoal9ib251cwplbmQK]]
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