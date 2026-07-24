local encoded=[[bW9kaWZpZXJfbWZ4aGpzID0gY2xhc3Moe30pCgotLeivpW1vZGlmaWVy5piv5ZCm5piv6LSf6Z2i55qECmZ1bmN0aW9uIG1vZGlmaWVyX21meGhqczpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgotLeivpW1vZGlmaWVy6IO95ZCm6KKr5riF6ZmkCmZ1bmN0aW9uIG1vZGlmaWVyX21meGhqczpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCi0t6K+lbW9kaWZpZXLmmK/lkKbpmpDol48KZnVuY3Rpb24gbW9kaWZpZXJfbWZ4aGpzOklzSGlkZGVuKCkKICAgIHJldHVybiB0cnVlCmVuZAoKLS3mrbvkuqHml7bmmK/lkKbnp7vpmaQKZnVuY3Rpb24gbW9kaWZpZXJfbWZ4aGpzOlJlbW92ZU9uRGVhdGgoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKLS0g5Yid5aeL5YyWbW9kaWZpZXIKZnVuY3Rpb24gbW9kaWZpZXJfbWZ4aGpzOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgLS0g5by65Yi25bGe5oCn5Yi35pawCiAgICBzZWxmOkZvcmNlUmVmcmVzaCgpCmVuZAoKLS0g5Yi35pawbW9kaWZpZXIKZnVuY3Rpb24gbW9kaWZpZXJfbWZ4aGpzOk9uUmVmcmVzaChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAplbmQKCi0tIOWjsOaYjuimgeS/ruaUueeahOWHveaVsApmdW5jdGlvbiBtb2RpZmllcl9tZnhoanM6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX01BTkFDT1NUX1BFUkNFTlRBR0VfU1RBQ0tJTkcsCiAgICB9CmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfbWZ4aGpzOkdldE1vZGlmaWVyUGVyY2VudGFnZU1hbmFjb3N0U3RhY2tpbmcoKQogICAgcmV0dXJuIDI1IC0tIOWHj+WwkTI1JemtlOazlea2iOiAlwplbmQK]]
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