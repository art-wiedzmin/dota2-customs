local encoded=[[bW9kaWZpZXJfamN5cyA9IGNsYXNzKHt9KQoKLS3or6Vtb2RpZmllcuaYr+WQpuaYr+i0n+mdoueahApmdW5jdGlvbiBtb2RpZmllcl9qY3lzOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLog73lkKbooqvmuIXpmaQKZnVuY3Rpb24gbW9kaWZpZXJfamN5czpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfamN5czpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCi0t5q275Lqh5pe25piv5ZCm56e76ZmkCmZ1bmN0aW9uIG1vZGlmaWVyX2pjeXM6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLSDliJ3lp4vljJZtb2RpZmllcgpmdW5jdGlvbiBtb2RpZmllcl9qY3lzOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAoKICAgIC0tIOWIneWni+WMluWPmOmHjwogICAgc2VsZi5qY3lzID0ga3YuamN5cyBvciAwCiAgICAtLSDkvb/nlKjmoIjorqHmlbDlkIzmraXmlbDmja7liLDlrqLmiLfnq68KICAgIC0tIOWwhuenu+WKqOmAn+W6puWAvOS5mOS7pTEwMOS7peS/neeVmeWwj+aVsOeyvuW6pu+8jOWtmOWCqOWcqOagiOiuoeaVsOS4rQogICAgc2VsZjpTZXRTdGFja0NvdW50KHNlbGYuamN5cyAqIDEwMCkKICAgIC0tIOWmguaenOmcgOimgeWTjeW6lOaAp+abtOaWsO+8jOiwg+eUqOi/meS4qgogICAgc2VsZjpGb3JjZVJlZnJlc2goKQplbmQKCi0tIOS7juaVsOaNruihqOS4reivu+WPlum7mOiupOWAvO+8iOWPr+mAie+8iQpmdW5jdGlvbiBtb2RpZmllcl9qY3lzOk9uUmVmcmVzaChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgaWYga3YuamN5cyB0aGVuCiAgICAgICAgc2VsZi5qY3lzID0ga3YuamN5cwogICAgICAgIC0tIOabtOaWsOagiOiuoeaVsAogICAgICAgIHNlbGY6U2V0U3RhY2tDb3VudChzZWxmLmpjeXMgKiAxMDApCiAgICBlbmQKICAgIC0tc2VsZjpGb3JjZVJlZnJlc2goKQplbmQKCi0tIOWjsOaYjuimgeS/ruaUueeahOWHveaVsApmdW5jdGlvbiBtb2RpZmllcl9qY3lzOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICAtLU1PRElGSUVSX1BST1BFUlRZX1BIWVNJQ0FMX0FSTU9SX0JPTlVTLAogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX01PVkVTUEVFRF9CT05VU19DT05TVEFOVAogICAgfQplbmQKCi0tIOWKqOaAgei/lOWbnuenu+WKqOmAn+W6puWKoOaIkApmdW5jdGlvbiBtb2RpZmllcl9qY3lzOkdldE1vZGlmaWVyTW92ZVNwZWVkQm9udXNfQ29uc3RhbnQoKQogICAgLS0g5LuO5qCI6K6h5pWw6I635Y+W56e75Yqo6YCf5bqm5YC877yI6Zmk5LulMTAw5oGi5aSN5Y6f5aeL5YC877yJCiAgICBsb2NhbCBzdGFja19jb3VudCA9IHNlbGY6R2V0U3RhY2tDb3VudCgpCiAgICBsb2NhbCBzcGVlZF9ib251cyA9IHN0YWNrX2NvdW50IC8gMTAwCiAgICByZXR1cm4gc3BlZWRfYm9udXMKZW5kCgotLSDorr7nva7np7vliqjpgJ/luqbnmoTmlrnms5UKZnVuY3Rpb24gbW9kaWZpZXJfamN5czpTZXRTcGVlZEJvbnVzKHZhbHVlKQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBzZWxmLmpjeXMgPSB2YWx1ZQogICAgc2VsZjpTZXRTdGFja0NvdW50KHZhbHVlICogMTAwKSAtLSDlkIzmraXliLDlrqLmiLfnq68KICAgIHNlbGY6Rm9yY2VSZWZyZXNoKCkKZW5kCg==]]
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