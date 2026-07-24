local encoded=[[bW9kaWZpZXJfbWZreCA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfbWZreDpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9tZmt4OklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfbWZreDpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX21ma3g6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9tZmt4Ok9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgc2VsZi5udW0gPSBrdi5udW0gb3IgMAogICAgc2VsZjpTZXRTdGFja0NvdW50KHNlbGYubnVtICogMTAwKQogICAgc2VsZjpGb3JjZVJlZnJlc2goKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX21ma3g6T25SZWZyZXNoKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBpZiBrdi5udW0gdGhlbgogICAgICAgIHNlbGYubnVtID0ga3YubnVtCiAgICAgICAgc2VsZjpTZXRTdGFja0NvdW50KHNlbGYubnVtICogMTAwKQogICAgZW5kCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfbWZreDpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfTUFHSUNBTF9SRVNJU1RBTkNFX0JPTlVTLAogICAgfQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX21ma3g6R2V0TW9kaWZpZXJNYWdpY2FsUmVzaXN0YW5jZUJvbnVzKCkKICAgIHJldHVybiBzZWxmOkdldFN0YWNrQ291bnQoKSAvIDEwMAplbmQKCg==]]
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