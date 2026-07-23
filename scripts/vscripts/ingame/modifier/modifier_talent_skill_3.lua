local encoded=[[LS0g6KKr5Yqo5aSp6LWLIDPvvJrpk4HljKDigJTigJTnirbmgIHmoI/lm77moIfvvJvmnYDmlYzljYfnuqflh4/lhY3kuI7oo4XlpIfln7rnoYDlsZ7mgKcgKzMwJSDop4EgVGFsZW50IC8gbW9kaWZpZXJfY2xyYl90YWxlbnRzCi0tIFRvb2x0aXAg6ZSu77yaRE9UQV9Ub29sdGlwX21vZGlmaWVyX3RhbGVudF9za2lsbF8zCgptb2RpZmllcl90YWxlbnRfc2tpbGxfMyA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50X3NraWxsXzM6SXNIaWRkZW4oKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50X3NraWxsXzM6SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50X3NraWxsXzM6SXNQdXJnYWJsZSgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfc2tpbGxfMzpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF9za2lsbF8zOklzUGVybWFuZW50KCkKICAgIHJldHVybiB0cnVlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50X3NraWxsXzM6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gImJ1ZmYvdGFsZW50XzMiCmVuZAo=]]
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