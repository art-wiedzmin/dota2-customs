local encoded=[[ZnVuY3Rpb24gSGVyb0RhdGE6R2V0VUlEYXRhKElELCBkYXRhKQogICAgaWYgbm90IElEIG9yIG5vdCBkYXRhIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgLS3mmoLlgZznpoHmraLkvKDmlbDmja4KICAgIGlmIEdhbWVSdWxlczpJc0dhbWVQYXVzZWQoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIC0t5Yid5aeL5YyW5pWw5o2uCiAgICBpZiBkYXRhLnRwID09ICJpbml0IiB0aGVuCiAgICAgICAgc2VsZjpTZW5kRGF0YShJRCkKICAgIGVuZAoKICAgIGlmIGRhdGEudHAgPT0gIlJvbGxTdGFyIiB0aGVuCiAgICAgICAgLS0gcHJpbnQoSW5pdFBsYXllci5QdWJsaWMucGxheWVycykKICAgICAgICAtLSBwcmludCgi6ZqP5py65Y2H5pifIikKICAgICAgICAKICAgICAgICBzZWxmOlJvbGxTdGFyKElEKQogICAgZW5kCiAgICBpZiBkYXRhLnRwID09ICJMZXZlbFN0YXIiIHRoZW4KICAgICAgICBzZWxmOkxldmVsU3RhcihJRCkKICAgIGVuZAogICAgLS3lsZ7mgKfovazmjaIKICAgIC0t5Yqb6YeP6L2s5pWP5o23IDEgIOS7t+agvDEwMAogICAgLS3lipvph4/ovazmmbrlipsgMiAg5Lu35qC8MTAwCiAgICAtLeaVj+aNt+i9rOWKm+mHjyAzICDku7fmoLwxMDAKICAgIC0t5pWP5o236L2s5pm65YqbIDQgIOS7t+agvDEwMAogICAgLS3mmbrlipvovazlipvph48gNSAg5Lu35qC8MTAwCiAgICAtLeaZuuWKm+i9rOaVj+aNtyA2ICDku7fmoLwxMDAKICAgIC0t5Yig6Zmk5oqA6IO9IDcgICAg5Lu35qC8NTAwCiAgICAtLeaKgOiDveeCuSA4ICAgICAg5Lu35qC8MzUwCiAgICBpZiBkYXRhLnRwID09ICJBdHRyQ2hhbmdlIiB0aGVuCiAgICAgICAgc2VsZjpBdHRyQ2hhbmdlKElELCBkYXRhLnRleHQpCiAgICBlbmQKZW5kCgotLee7meWJjeerr+WPkeaVsOaNrgpmdW5jdGlvbiBIZXJvRGF0YTpTZW5kRGF0YShJRCkKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIGRhdGEgPSBzZWxmLkRhdGFbSURdCiAgICAtLXByaW50KGRhdGEpCiAgICBVdGlsOlNlbmQySnNJRCgiVUlfSGVyb0RhdGEiLCBkYXRhLCBJRCkKZW5kCgotLeWkjea0u+aVsOaNrgpmdW5jdGlvbiBIZXJvRGF0YTpTZW5kUmVib3JuRGF0YShJRCkKCmVuZAo=]]
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