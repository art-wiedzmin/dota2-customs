local encoded=[[LS0g54mp55CG56m/6YCP5rWL6K+VIG1vZGlmaWVyCi0tIOS9v+eUqCBNb2REb3RhIEFQSTogTU9ESUZJRVJfUFJPUEVSVFlfUEhZU0lDQUxfQVJNT1JfUElFUkNJTkdfUEVSQ0VOVEFHRV9UQVJHRVQgKDE4OCkKLS0g5oyC5Zyo5pS75Ye76ICF6Lqr5LiK77yM6L+U5Zue5a+544CM5b2T5YmN5pmu5pS7L+aKgOiDveebruagh+OAjeW/veeVpeeahOaKpOeUsueZvuWIhuavlO+8iDB+MTAw77yJCi0tIOa1i+ivle+8mue7meiLsembhOWKoOS4iuatpCBtb2RpZmllciDlkI7mma7mlLvpq5jmiqTnlLLljZXkvY3vvIzkvKTlrrPkvJrmj5Dpq5gKbW9kaWZpZXJfYXJtb3JfcGllcmNlX3Rlc3QgPSBjbGFzcyh7fSkKCmZ1bmN0aW9uIG1vZGlmaWVyX2FybW9yX3BpZXJjZV90ZXN0OklzSGlkZGVuKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYXJtb3JfcGllcmNlX3Rlc3Q6SXNEZWJ1ZmYoKSByZXR1cm4gZmFsc2UgZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hcm1vcl9waWVyY2VfdGVzdDpJc1B1cmdhYmxlKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYXJtb3JfcGllcmNlX3Rlc3Q6R2V0VGV4dHVyZSgpIHJldHVybiAiaXRlbV9sZXNzZXJfY3JpdCIgZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hcm1vcl9waWVyY2VfdGVzdDpPbkNyZWF0ZWQoa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKICAgIC0tIHByaW50KCLnqb/nlLJCdWZm5Yib5bu65oiQ5YqfIikKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hcm1vcl9waWVyY2VfdGVzdDpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIC0tIE1PRElGSUVSX1BST1BFUlRZX1BIWVNJQ0FMX0FSTU9SX1BJRVJDSU5HX1BFUkNFTlRBR0VfVEFSR0VUID0gMTg477yI6KeBIE1vZERvdGEgQVBJ77yJCiAgICByZXR1cm4ge01PRElGSUVSX1BST1BFUlRZX1BIWVNJQ0FMX0FSTU9SX1BJRVJDSU5HX1BFUkNFTlRBR0VfVEFSR0VUICB9CmVuZAoKLS0g5a+555uu5qCH5b+955Wl55qE54mp55CG5oqk55Sy55m+5YiG5q+U77yIMH4xMDDvvInjgILkvovlpoIgNTAg6KGo56S66KeG5Li655uu5qCH5oqk55Sy5YeP5bCRIDUwJQpmdW5jdGlvbiBtb2RpZmllcl9hcm1vcl9waWVyY2VfdGVzdDpHZXRNb2RpZmllcklnbm9yZVBoeXNpY2FsQXJtb3IoCiAgICBrZXlzKSByZXR1cm4gNTAgZW5kCg==]]
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