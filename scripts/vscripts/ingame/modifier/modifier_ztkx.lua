local encoded=[[bW9kaWZpZXJfenRreCA9IGNsYXNzKHt9KQoKLS3or6Vtb2RpZmllcuaYr+WQpuaYr+i0n+mdoueahApmdW5jdGlvbiBtb2RpZmllcl96dGt4OklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLog73lkKbooqvmuIXpmaQKZnVuY3Rpb24gbW9kaWZpZXJfenRreDpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfenRreDpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCi0t5q275Lqh5pe25piv5ZCm56e76ZmkCmZ1bmN0aW9uIG1vZGlmaWVyX3p0a3g6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLSDliJ3lp4vljJZtb2RpZmllcgpmdW5jdGlvbiBtb2RpZmllcl96dGt4Ok9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAoKICAgIC0tIOWIneWni+WMluWPmOmHjwogICAgc2VsZi5udW0gPSBrdi5udW0gb3IgMAogICAgLS0g5L2/55So5qCI6K6h5pWw5ZCM5q2l5pWw5o2u5Yiw5a6i5oi356uvCiAgICAtLSDlsIbnp7vliqjpgJ/luqblgLzkuZjku6UxMDDku6Xkv53nlZnlsI/mlbDnsr7luqbvvIzlrZjlgqjlnKjmoIjorqHmlbDkuK0KICAgIHNlbGY6U2V0U3RhY2tDb3VudChzZWxmLm51bSAqIDEwMCkKICAgIC0tIOWmguaenOmcgOimgeWTjeW6lOaAp+abtOaWsO+8jOiwg+eUqOi/meS4qgogICAgc2VsZjpGb3JjZVJlZnJlc2goKQplbmQKCi0tIOS7juaVsOaNruihqOS4reivu+WPlum7mOiupOWAvO+8iOWPr+mAie+8iQpmdW5jdGlvbiBtb2RpZmllcl96dGt4Ok9uUmVmcmVzaChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgaWYga3YubnVtIHRoZW4KICAgICAgICBzZWxmLm51bSA9IGt2Lm51bQogICAgICAgIC0tIOabtOaWsOagiOiuoeaVsAogICAgICAgIHNlbGY6U2V0U3RhY2tDb3VudChzZWxmLm51bSAqIDEwMCkKICAgIGVuZAogICAgLS1zZWxmOkZvcmNlUmVmcmVzaCgpCmVuZAoKLS0g5aOw5piO6KaB5L+u5pS555qE5Ye95pWwCmZ1bmN0aW9uIG1vZGlmaWVyX3p0a3g6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX1NUQVRVU19SRVNJU1RBTkNFX1NUQUNLSU5HLAogICAgICAgIC0tTU9ESUZJRVJfUFJPUEVSVFlfTU9WRVNQRUVEX0JPTlVTX0NPTlNUQU5UCiAgICB9CmVuZAoKLS0g5Yqo5oCB6L+U5Zue5oqk55SyCmZ1bmN0aW9uIG1vZGlmaWVyX3p0a3g6R2V0TW9kaWZpZXJTdGF0dXNSZXNpc3RhbmNlU3RhY2tpbmcoKQogICAgLS0g5LuO5qCI6K6h5pWw6I635Y+W56e75Yqo6YCf5bqm5YC877yI6Zmk5LulMTAw5oGi5aSN5Y6f5aeL5YC877yJCiAgICBsb2NhbCBzdGFja19jb3VudCA9IHNlbGY6R2V0U3RhY2tDb3VudCgpCiAgICBsb2NhbCBoal9ib251cyA9IHN0YWNrX2NvdW50IC8gMTAwCiAgICByZXR1cm4gaGpfYm9udXMKZW5k]]
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