local encoded=[[bW9kaWZpZXJfYm90X2lubmF0ZV9sZXZlbF9iYXNlX2F0dGFjayA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfYm90X2lubmF0ZV9sZXZlbF9iYXNlX2F0dGFjazpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2JvdF9pbm5hdGVfbGV2ZWxfYmFzZV9hdHRhY2s6SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYm90X2lubmF0ZV9sZXZlbF9iYXNlX2F0dGFjazpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2JvdF9pbm5hdGVfbGV2ZWxfYmFzZV9hdHRhY2s6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9ib3RfaW5uYXRlX2xldmVsX2Jhc2VfYXR0YWNrOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9CQVNFQVRUQUNLX0JPTlVTREFNQUdFLAogICAgICAgIE1PRElGSUVSX0VWRU5UX09OX0xFVkVMX1VQLAogICAgfQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2JvdF9pbm5hdGVfbGV2ZWxfYmFzZV9hdHRhY2s6T25MZXZlbFVwKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBpZiBzZWxmLkZvcmNlUmVmcmVzaCB0aGVuCiAgICAgICAgc2VsZjpGb3JjZVJlZnJlc2goKQogICAgZW5kCmVuZAoKLS0g5q+P5Y2H5LiA57qnICtib3RfYmFzZV9hdHRhY2tfYm9udXNfcGVyX2xldmVsIOeCueWfuuehgOaUu+WHu+WKm++8iDEg57qn5Li6IDDvvIwyIOe6p+i1t+e0r+iuoe+8iQpmdW5jdGlvbiBtb2RpZmllcl9ib3RfaW5uYXRlX2xldmVsX2Jhc2VfYXR0YWNrOkdldE1vZGlmaWVyQmFzZUF0dGFja19Cb251c0RhbWFnZSgpCiAgICBsb2NhbCB1ID0gc2VsZjpHZXRQYXJlbnQoKQogICAgaWYgbm90IHUgb3IgdTpJc051bGwoKSBvciBub3QgdS5HZXRMZXZlbCB0aGVuCiAgICAgICAgcmV0dXJuIDAKICAgIGVuZAogICAgbG9jYWwgbHZsID0gdTpHZXRMZXZlbCgpIG9yIDEKICAgIGxvY2FsIHBlciA9IDMwCiAgICBpZiBCb3RBSSBhbmQgQm90QUkuQ29uZmlnIGFuZCB0eXBlKEJvdEFJLkNvbmZpZy5ib3RfYmFzZV9hdHRhY2tfYm9udXNfcGVyX2xldmVsKSA9PSAibnVtYmVyIiB0aGVuCiAgICAgICAgcGVyID0gQm90QUkuQ29uZmlnLmJvdF9iYXNlX2F0dGFja19ib251c19wZXJfbGV2ZWwKICAgIGVuZAogICAgcmV0dXJuIG1hdGgubWF4KDAsIGx2bCAtIDEpICogcGVyCmVuZAo=]]
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