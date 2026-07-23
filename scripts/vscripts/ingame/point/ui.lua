local encoded=[[ZnVuY3Rpb24gUG9pbnQ6R2V0VUlEYXRhKElELCBkYXRhKQogICAgaWYgbm90IElEIG9yIG5vdCBkYXRhIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgLS3mmoLlgZznpoHmraLkvKDmlbDmja4KICAgIGlmIEdhbWVSdWxlczpJc0dhbWVQYXVzZWQoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIC0t5Yid5aeL5YyW5pWw5o2uCiAgICBpZiBkYXRhLnRwID09ICJpbml0IiB0aGVuCiAgICAgICAgc2VsZjpTZW5kRGF0YShJRCkKICAgIGVuZAoKICAgIGlmIGRhdGEudHAgPT0gIk9wZW5QYWdlIiB0aGVuCiAgICAgICAgc2VsZjpPcGVuUGFnZShJRCkKICAgIGVuZAogICAgaWYgZGF0YS50cCA9PSAiQ2xvc2VQYWdlIiB0aGVuCiAgICAgICAgc2VsZjpDbG9zZVBhZ2UoSUQpCiAgICBlbmQKZW5kCgotLee7meWJjeerr+WPkeaVsOaNrgpmdW5jdGlvbiBQb2ludDpTZW5kRGF0YShJRCkKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIGRhdGEgPSBzZWxmLkRhdGFbSURdCiAgICBVdGlsOlNlbmQySnNJRCgiVUlfUG9pbnQiLCBkYXRhLCBJRCkKZW5kCg==]]
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