local encoded=[[LS0g6L+F5o235LmL5YiD77yIaXRlbV9nb29kc18xNyAvIG1vZGlmaWVyX3RhbGVudF8x77yJ77ya5pmu5pS75Y+g5bGC5piT5Lyk77yM5Y+v6KKr6amx5pWj77yM5LiN56m/6YCP6a2U5YWNCmlmIG1vZGlmaWVyX3RhbGVudF8xX2RhbWFnZV9hbXBfZGVidWZmID09IG5pbCB0aGVuCiAgICBtb2RpZmllcl90YWxlbnRfMV9kYW1hZ2VfYW1wX2RlYnVmZiA9IGNsYXNzKHt9KQplbmQKCmxvY2FsIEFNUF9QRVJfU1RBQ0tfUENUID0gMQpsb2NhbCBNQVhfU1RBQ0tTID0gOTk5CgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfMV9kYW1hZ2VfYW1wX2RlYnVmZjpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfMV9kYW1hZ2VfYW1wX2RlYnVmZjpJc0RlYnVmZigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF8xX2RhbWFnZV9hbXBfZGVidWZmOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIHRydWUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfMV9kYW1hZ2VfYW1wX2RlYnVmZjpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiB0cnVlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50XzFfZGFtYWdlX2FtcF9kZWJ1ZmY6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gInNjcm9sbC9tb2RpZmllcl90YWxlbnRfMV9idWZmIgplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF8xX2RhbWFnZV9hbXBfZGVidWZmOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9JTkNPTUlOR19EQU1BR0VfUEVSQ0VOVEFHRSwKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9UT09MVElQLAogICAgfQplbmQKCi0tLSDmr4/lsYIgMSXvvIzkuI7lsYLmlbDnur/mgKflj6DliqDvvIjmgLvliqDmt7EgPSDlsYLmlbAgw5cgMSXvvIkKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50XzFfZGFtYWdlX2FtcF9kZWJ1ZmY6R2V0TW9kaWZpZXJJbmNvbWluZ0RhbWFnZV9QZXJjZW50YWdlKCkKICAgIGxvY2FsIG4gPSBtYXRoLm1pbihzZWxmOkdldFN0YWNrQ291bnQoKSwgTUFYX1NUQUNLUykKICAgIHJldHVybiBuICogQU1QX1BFUl9TVEFDS19QQ1QKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfMV9kYW1hZ2VfYW1wX2RlYnVmZjpPblRvb2x0aXAoKQogICAgcmV0dXJuIHNlbGY6R2V0TW9kaWZpZXJJbmNvbWluZ0RhbWFnZV9QZXJjZW50YWdlKCkKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfMV9kYW1hZ2VfYW1wX2RlYnVmZjpPbkNyZWF0ZWQoKQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBpZiBzZWxmOkdldFN0YWNrQ291bnQoKSA8IDEgdGhlbgogICAgICAgIHNlbGY6U2V0U3RhY2tDb3VudCgxKQogICAgZW5kCmVuZAo=]]
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