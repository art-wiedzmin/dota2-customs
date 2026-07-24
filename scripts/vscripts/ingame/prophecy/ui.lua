local encoded=[[ZnVuY3Rpb24gUHJvcGhlY3k6R2V0VUlEYXRhKElELCBkYXRhKQogICAgaWYgbm90IElEIG9yIG5vdCBkYXRhIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgR2FtZVJ1bGVzOklzR2FtZVBhdXNlZCgpIGFuZCBkYXRhLnRwIH49ICJpbml0IiB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGlmIG5vdCBzZWxmLkRhdGFbSURdIHRoZW4KICAgICAgICBzZWxmOkluaXQoSUQpCiAgICBlbmQKICAgIGlmIGRhdGEudHAgPT0gImluaXQiIHRoZW4KICAgICAgICBpZiBzZWxmOkhhc0ZpbmlzaGVkV2luZG93KElEKSBvciBzZWxmOklzUGFnZU9wZW4oSUQpIHRoZW4KICAgICAgICAgICAgc2VsZjpTZW5kRGF0YShJRCkKICAgICAgICBlbHNlaWYgbm90IHNlbGY6VHJ5T3BlbihJRCkgdGhlbgogICAgICAgICAgICBzZWxmOlNlbmREYXRhKElEKQogICAgICAgIGVuZAogICAgZW5kCiAgICBpZiBkYXRhLnRwID09ICJBbm5vdW5jZSIgdGhlbgogICAgICAgIHNlbGY6QW5ub3VuY2UoSUQpCiAgICBlbmQKICAgIGlmIGRhdGEudHAgPT0gIkNsb3NlIiB0aGVuCiAgICAgICAgc2VsZjpDbG9zZVBhZ2UoSUQpCiAgICBlbmQKZW5kCgpmdW5jdGlvbiBQcm9waGVjeTpTZW5kRGF0YShJRCkKICAgIGlmIG5vdCBJRCBvciBub3Qgc2VsZi5EYXRhW0lEXSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIHN0YXRlID0gc2VsZi5EYXRhW0lEXQogICAgbG9jYWwgcGFnZU9wZW4gPSBzZWxmOklzVWlFbmFibGVkKCkgYW5kIHNlbGY6SXNQYWdlT3BlbihJRCkKICAgIFV0aWw6U2VuZDJKc0lEKCJVSV9Qcm9waGVjeSIsIHsKICAgICAgICBwYWdlID0gcGFnZU9wZW4gYW5kIDEgb3IgMCwKICAgICAgICBhbm5vdW5jZWQgPSBzdGF0ZS5hbm5vdW5jZWQgPT0gdHJ1ZSBhbmQgMSBvciAwLAogICAgICAgIGFubm91bmNpbmcgPSBzdGF0ZS5hbm5vdW5jaW5nID09IHRydWUgYW5kIDEgb3IgMCwKICAgICAgICBjbG9zZWQgPSBzdGF0ZS5jbG9zZWQgPT0gdHJ1ZSBhbmQgMSBvciAwLAogICAgICAgIHdpbmRvd19lbmRfdGltZSA9IHRvbnVtYmVyKHNlbGYuR2xvYmFsV2luZG93RW5kKSBvciAwLAogICAgICAgIHJlbWFpbl9zZWMgPSBzZWxmOldpbmRvd1JlbWFpblNlYygpLAogICAgICAgIHByb3BoZWN5X2NhcmRfY291bnQgPSBzZWxmOkdldFByb3BoZWN5Q2FyZENvdW50KElEKSwKICAgICAgICBjYW5fYW5ub3VuY2VfbWF0Y2ggPSBzZWxmOkNhbkFubm91bmNlTWF0Y2goKSBhbmQgMSBvciAwLAogICAgICAgIGNhbl9hbm5vdW5jZSA9IHNlbGY6Q2FuQW5ub3VuY2UoSUQpIGFuZCAxIG9yIDAsCiAgICB9LCBJRCkKZW5kCg==]]
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