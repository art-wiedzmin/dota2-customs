local encoded=[[bW9kaWZpZXJfaGogPSBjbGFzcyh7fSkKCi0t6K+lbW9kaWZpZXLmmK/lkKbmmK/otJ/pnaLnmoQKZnVuY3Rpb24gbW9kaWZpZXJfaGo6SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKLS3or6Vtb2RpZmllcuiDveWQpuiiq+a4hemZpApmdW5jdGlvbiBtb2RpZmllcl9oajpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfaGo6SXNIaWRkZW4oKQogICAgcmV0dXJuIHRydWUKZW5kCgotLeatu+S6oeaXtuaYr+WQpuenu+mZpApmdW5jdGlvbiBtb2RpZmllcl9oajpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0tIOWIneWni+WMlm1vZGlmaWVyCmZ1bmN0aW9uIG1vZGlmaWVyX2hqOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAoKICAgIC0tIOWIneWni+WMluWPmOmHjwogICAgc2VsZi5qY2hqID0ga3YuamNoaiBvciAwCiAgICAtLSDkvb/nlKjmoIjorqHmlbDlkIzmraXmlbDmja7liLDlrqLmiLfnq68KICAgIC0tIOWwhuenu+WKqOmAn+W6puWAvOS5mOS7pTEwMOS7peS/neeVmeWwj+aVsOeyvuW6pu+8jOWtmOWCqOWcqOagiOiuoeaVsOS4rQogICAgc2VsZjpTZXRTdGFja0NvdW50KHNlbGYuamNoaiAqIDEwMCkKICAgIC0tIOWmguaenOmcgOimgeWTjeW6lOaAp+abtOaWsO+8jOiwg+eUqOi/meS4qgogICAgc2VsZjpGb3JjZVJlZnJlc2goKQplbmQKCi0tIOS7juaVsOaNruihqOS4reivu+WPlum7mOiupOWAvO+8iOWPr+mAie+8iQpmdW5jdGlvbiBtb2RpZmllcl9oajpPblJlZnJlc2goa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKICAgIGlmIGt2LmpjaGogdGhlbgogICAgICAgIHNlbGYuamNoaiA9IGt2LmpjaGoKICAgICAgICAtLSDmm7TmlrDmoIjorqHmlbAKICAgICAgICBzZWxmOlNldFN0YWNrQ291bnQoc2VsZi5qY2hqICogMTAwKQogICAgZW5kCiAgICAtLXNlbGY6Rm9yY2VSZWZyZXNoKCkKZW5kCgotLSDlo7DmmI7opoHkv67mlLnnmoTlh73mlbAKZnVuY3Rpb24gbW9kaWZpZXJfaGo6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX1BIWVNJQ0FMX0FSTU9SX0JPTlVTLAogICAgICAgIC0tTU9ESUZJRVJfUFJPUEVSVFlfTU9WRVNQRUVEX0JPTlVTX0NPTlNUQU5UCiAgICB9CmVuZAoKLS0g5Yqo5oCB6L+U5Zue5oqk55SyCmZ1bmN0aW9uIG1vZGlmaWVyX2hqOkdldE1vZGlmaWVyUGh5c2ljYWxBcm1vckJvbnVzKCkKICAgIC0tIOS7juagiOiuoeaVsOiOt+WPluenu+WKqOmAn+W6puWAvO+8iOmZpOS7pTEwMOaBouWkjeWOn+Wni+WAvO+8iQogICAgbG9jYWwgc3RhY2tfY291bnQgPSBzZWxmOkdldFN0YWNrQ291bnQoKQogICAgbG9jYWwgaGpfYm9udXMgPSBzdGFja19jb3VudCAvIDEwMAogICAgcmV0dXJuIGhqX2JvbnVzCmVuZAoKLS0g6K6+572u56e75Yqo6YCf5bqm55qE5pa55rOVCmZ1bmN0aW9uIG1vZGlmaWVyX2hqOlNldFNwZWVkQm9udXModmFsdWUpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKICAgIHNlbGYuamNoaiA9IHZhbHVlCiAgICBzZWxmOlNldFN0YWNrQ291bnQodmFsdWUgKiAxMDApIC0tIOWQjOatpeWIsOWuouaIt+errwogICAgc2VsZjpGb3JjZVJlZnJlc2goKQplbmQK]]
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