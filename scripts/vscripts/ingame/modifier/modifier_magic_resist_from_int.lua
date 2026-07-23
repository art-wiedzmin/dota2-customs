local encoded=[[bW9kaWZpZXJfbWFnaWNfcmVzaXN0X2Zyb21faW50ID0gY2xhc3Moe30pCgpmdW5jdGlvbiBtb2RpZmllcl9tYWdpY19yZXNpc3RfZnJvbV9pbnQ6SXNIaWRkZW4oKQogICAgcmV0dXJuIHRydWUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9tYWdpY19yZXNpc3RfZnJvbV9pbnQ6SXNQdXJnYWJsZSgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9tYWdpY19yZXNpc3RfZnJvbV9pbnQ6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgoKZnVuY3Rpb24gbW9kaWZpZXJfbWFnaWNfcmVzaXN0X2Zyb21faW50OkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHtNT0RJRklFUl9QUk9QRVJUWV9NQUdJQ0FMX1JFU0lTVEFOQ0VfRElSRUNUX01PRElGSUNBVElPTn0KZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9tYWdpY19yZXNpc3RfZnJvbV9pbnQ6R2V0TW9kaWZpZXJNYWdpY2FsUmVzaXN0YW5jZURpcmVjdE1vZGlmaWNhdGlvbigpCgogICAgbG9jYWwgcGFyZW50ID0gc2VsZjpHZXRQYXJlbnQoKQogICAgLS0gcmV0dXJuIDIwCiAgICByZXR1cm4gcGFyZW50OkdldEludGVsbGVjdCh0cnVlKSAqICgtMC4wNSkKZW5kCgoKZnVuY3Rpb24gbW9kaWZpZXJfbWFnaWNfcmVzaXN0X2Zyb21faW50Ok9uQ3JlYXRlZCgpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKZW5kCg==]]
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