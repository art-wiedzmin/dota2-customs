local encoded=[[bW9kaWZpZXJfZ2pqYyA9IGNsYXNzKHt9KQoKLS3or6Vtb2RpZmllcuaYr+WQpuaYr+i0n+mdoueahApmdW5jdGlvbiBtb2RpZmllcl9nampjOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLog73lkKbooqvmuIXpmaQKZnVuY3Rpb24gbW9kaWZpZXJfZ2pqYzpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfZ2pqYzpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCi0t5q275Lqh5pe25piv5ZCm56e76ZmkCmZ1bmN0aW9uIG1vZGlmaWVyX2dqamM6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLSDliJ3lp4vljJZtb2RpZmllcgpmdW5jdGlvbiBtb2RpZmllcl9nampjOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgbG9jYWwgSUQgPSBVdGlsOkhlcm8ySUQoc2VsZjpHZXRQYXJlbnQoKSkKICAgIHNlbGY6U2V0U3RhY2tDb3VudChIZXJvRGF0YS5EYXRhW0lEXS5oZXJvX2F0dHIuZ2pqYykKICAgIC0tIOWIneWni+WMluWPmOmHjwogICAgLS0g5aaC5p6c6ZyA6KaB5ZON5bqU5oCn5pu05paw77yM6LCD55So6L+Z5LiqCiAgICBzZWxmOkZvcmNlUmVmcmVzaCgpCmVuZAoKLS0g5LuO5pWw5o2u6KGo5Lit6K+75Y+W6buY6K6k5YC877yI5Y+v6YCJ77yJCmZ1bmN0aW9uIG1vZGlmaWVyX2dqamM6T25SZWZyZXNoKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCgogICAgbG9jYWwgSUQgPSBVdGlsOkhlcm8ySUQoc2VsZjpHZXRQYXJlbnQoKSkKICAgIHNlbGY6U2V0U3RhY2tDb3VudChIZXJvRGF0YS5EYXRhW0lEXS5oZXJvX2F0dHIuZ2pqYykKCiAgICAtLXNlbGY6Rm9yY2VSZWZyZXNoKCkKZW5kCgotLSDlo7DmmI7opoHkv67mlLnnmoTlh73mlbAKZnVuY3Rpb24gbW9kaWZpZXJfZ2pqYzpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfQkFTRURBTUFHRU9VVEdPSU5HX1BFUkNFTlRBR0UKICAgIH0KZW5kCgotLSDliqjmgIHov5Tlm57miqTnlLIKZnVuY3Rpb24gbW9kaWZpZXJfZ2pqYzpHZXRNb2RpZmllckJhc2VEYW1hZ2VPdXRnb2luZ19QZXJjZW50YWdlKCkKICAgIC0tIOS7juagiOiuoeaVsOiOt+WPluenu+WKqOmAn+W6puWAvO+8iOmZpOS7pTEwMOaBouWkjeWOn+Wni+WAvO+8iQogICAgcmV0dXJuIHNlbGY6R2V0U3RhY2tDb3VudCgpCmVuZAo=]]
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