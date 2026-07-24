local encoded=[[LS3ojrflj5bmqKHlvI8KZnVuY3Rpb24gSHR0cDpHZXRUcCgpCiAgICByZXR1cm4gc2VsZi5EYXRhLnRwCmVuZAoKLS3ojrflj5ZTS0QKZnVuY3Rpb24gSHR0cDpHZXRTS0QoKQogICAgcmV0dXJuIHNlbGYuRGF0YS5TS0RfS0VZCmVuZAoKLS3ojrflj5bkvKDovpNLZXkKZnVuY3Rpb24gSHR0cDpHZXRTZWNyZXRLZXkoKQogICAgcmV0dXJuIHNlbGYuRGF0YS5zZWNyZXRrZXkKZW5kCgotLeiOt+WPluS4u+acuuWcsOWdgApmdW5jdGlvbiBIdHRwOkdldFVybCgpCiAgICByZXR1cm4gc2VsZi5EYXRhLnVybAplbmQK]]
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