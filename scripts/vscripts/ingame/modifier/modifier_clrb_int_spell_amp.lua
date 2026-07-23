local encoded=[[bW9kaWZpZXJfY2xyYl9pbnRfc3BlbGxfYW1wID0gY2xhc3Moe30pCgotLSDmr48gMSDngrnmmbrlipsgKzAuMDUlIOaKgOiDveWinuW8uu+8iDEwMCDmmbrlipsgPSA1Je+8iQpsb2NhbCBJTlRfUEVSX1NQRUxMX0FNUF9QRVJDRU5UID0gMC4wNQoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9pbnRfc3BlbGxfYW1wOklzSGlkZGVuKCkKICAgIHJldHVybiB0cnVlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9pbnRfc3BlbGxfYW1wOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfaW50X3NwZWxsX2FtcDpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfaW50X3NwZWxsX2FtcDpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfaW50X3NwZWxsX2FtcDpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfU1BFTExfQU1QTElGWV9QRVJDRU5UQUdFLAogICAgfQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfaW50X3NwZWxsX2FtcDpHZXRNb2RpZmllclNwZWxsQW1wbGlmeV9QZXJjZW50YWdlKCkKICAgIGxvY2FsIHBhcmVudCA9IHNlbGY6R2V0UGFyZW50KCkKICAgIGlmIG5vdCBwYXJlbnQgb3IgcGFyZW50OklzTnVsbCgpIG9yIG5vdCBwYXJlbnQuR2V0SW50ZWxsZWN0IHRoZW4KICAgICAgICByZXR1cm4gMAogICAgZW5kCiAgICByZXR1cm4gcGFyZW50OkdldEludGVsbGVjdCh0cnVlKSAqIElOVF9QRVJfU1BFTExfQU1QX1BFUkNFTlQKZW5kCg==]]
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