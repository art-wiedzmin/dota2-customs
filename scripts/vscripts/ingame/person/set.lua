local encoded=[[ZnVuY3Rpb24gUGVyc29uOk9wZW5QYWdlKElEKQogICAgc2VsZi5EYXRhW0lEXS5wYWdlID0gdHJ1ZQogICAgc2VsZjpTZW5kRGF0YShJRCkKZW5kCgpmdW5jdGlvbiBQZXJzb246Q2xvc2VQYWdlKElEKQogICAgc2VsZi5EYXRhW0lEXS5wYWdlID0gZmFsc2UKICAgIHNlbGY6U2VuZERhdGEoSUQpCmVuZAo=]]
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