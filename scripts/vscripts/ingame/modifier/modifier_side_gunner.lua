--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g55+u5Lq655u05Y2H5py677ya5L6n57+85py65YWz5p6q5aeL57uI6ZqQ6JeP77yM5pyJIEEg5p2W5pe257u05oyBIDEg57qn5Lul5ZCv55So6KKr5Yqo5pWI5p6cCm1vZGlmaWVyX3NpZGVfZ3VubmVyID0gY2xhc3Moe30pCgpmdW5jdGlvbiBtb2RpZmllcl9zaWRlX2d1bm5lcjpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3NpZGVfZ3VubmVyOklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3NpZGVfZ3VubmVyOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfc2lkZV9ndW5uZXI6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9zaWRlX2d1bm5lcjpJc1Blcm1hbmVudCgpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3NpZGVfZ3VubmVyOk9uQ3JlYXRlZCgpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHNlbGY6UmVmcmVzaFNpZGVHdW5uZXIoKQogICAgc2VsZjpTdGFydEludGVydmFsVGhpbmsoMC41KQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3NpZGVfZ3VubmVyOk9uSW50ZXJ2YWxUaGluaygpCiAgICBzZWxmOlJlZnJlc2hTaWRlR3VubmVyKCkKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9zaWRlX2d1bm5lcjpSZWZyZXNoU2lkZUd1bm5lcigpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIGhlcm8gPSBzZWxmOkdldFBhcmVudCgpCiAgICBpZiBub3QgaGVybyBvciBoZXJvOklzTnVsbCgpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgSGVyb0RhdGEgYW5kIEhlcm9EYXRhLkFwcGx5R3lyb2NvcHRlclNpZGVHdW5uZXJQYXNzaXZlU3RhdGUgdGhlbgogICAgICAgIEhlcm9EYXRhOkFwcGx5R3lyb2NvcHRlclNpZGVHdW5uZXJQYXNzaXZlU3RhdGUoaGVybykKICAgIGVuZAplbmQK]]
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