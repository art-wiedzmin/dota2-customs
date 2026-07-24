local encoded=[[bW9kaWZpZXJfc216ZiA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfc216ZjpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9zbXpmOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfc216ZjpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3NtemY6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9zbXpmOk9uQ3JlYXRlZCgpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHNlbGY6X1N5bmNTdGFja0Zyb21IZXJvRGF0YSgpCiAgICBzZWxmOkZvcmNlUmVmcmVzaCgpCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfc216ZjpPblJlZnJlc2goKQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBzZWxmOl9TeW5jU3RhY2tGcm9tSGVyb0RhdGEoKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3NtemY6X1N5bmNTdGFja0Zyb21IZXJvRGF0YSgpCiAgICBsb2NhbCBwYXJlbnQgPSBzZWxmOkdldFBhcmVudCgpCiAgICBpZiBub3QgcGFyZW50IG9yIHBhcmVudDpJc051bGwoKSB0aGVuCiAgICAgICAgc2VsZjpTZXRTdGFja0NvdW50KDApCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIElEID0gVXRpbDpIZXJvMklEKHBhcmVudCkKICAgIGlmIG5vdCBJRCBvciBub3QgSGVyb0RhdGEgb3Igbm90IEhlcm9EYXRhLkRhdGEgb3Igbm90IEhlcm9EYXRhLkRhdGFbSURdIHRoZW4KICAgICAgICBzZWxmOlNldFN0YWNrQ291bnQoMCkKICAgICAgICByZXR1cm4KICAgIGVuZAogICAgbG9jYWwgcGN0ID0gbWF0aC5mbG9vcih0b251bWJlcihIZXJvRGF0YS5EYXRhW0lEXS5oZXJvX2F0dHIuc216Zikgb3IgMCkKICAgIHNlbGY6U2V0U3RhY2tDb3VudChwY3QpCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfc216ZjpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfRVhUUkFfSEVBTFRIX1BFUkNFTlRBR0UsCiAgICB9CmVuZAoKLS0g55Sf5ZG95aKe5bmFJe+8muaMieiLsembhOW9k+WJjeacgOWkp+eUn+WRve+8iOWQqyBzbWpjIOetieWbuuWumuWKoOihgOWQju+8iemineWkluWinuWKoOWQjOavlOS+i+acgOWkp+eUn+WRvQpmdW5jdGlvbiBtb2RpZmllcl9zbXpmOkdldE1vZGlmaWVyRXh0cmFIZWFsdGhQZXJjZW50YWdlKCkKICAgIHJldHVybiBzZWxmOkdldFN0YWNrQ291bnQoKSBvciAwCmVuZAo=]]
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