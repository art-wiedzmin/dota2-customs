local encoded=[[ZnVuY3Rpb24gSGVyb0RhdGE6U2V0SGVyb0Nvc3RHYWluKElELCBoZXJvKQogICAgaWYgbm90IHNlbGYuRGF0YVtJRF0gdGhlbgogICAgICAgIHNlbGY6SW5pdChJRCkKICAgIGVuZAogICAgbG9jYWwgbGxjeiAgICAgICAgICAgICAgPSBoZXJvOkdldFN0cmVuZ3RoR2FpbigpCiAgICBsb2NhbCBtamN6ICAgICAgICAgICAgICA9IGhlcm86R2V0QWdpbGl0eUdhaW4oKQogICAgbG9jYWwgemxjeiAgICAgICAgICAgICAgPSBoZXJvOkdldEludGVsbGVjdEdhaW4oKQoKICAgIHNlbGYuRGF0YVtJRF0uY29zdC5sbGN6ID0gdXRpbGV4OkZsb2F0U2V0KGxsY3osIDEpCiAgICBzZWxmLkRhdGFbSURdLmNvc3QubWpjeiA9IHV0aWxleDpGbG9hdFNldChtamN6LCAxKQogICAgc2VsZi5EYXRhW0lEXS5jb3N0LnpsY3ogPSB1dGlsZXg6RmxvYXRTZXQoemxjeiwgMSkKICAgIHNlbGY6U2VuZERhdGEoSUQpCmVuZAoKZnVuY3Rpb24gSGVyb0RhdGE6QWRkR29sZChJRCwgZ29sZCkKICAgIGlmIG5vdCBJRCBvciBub3QgZ29sZCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHNlbGYuRGF0YVtJRF0uZ29sZCA9IHNlbGYuRGF0YVtJRF0uZ29sZCArIGdvbGQKZW5kCgpmdW5jdGlvbiBIZXJvRGF0YTpBZGREYW0oSUQsIGRhbSkKICAgIHNlbGYuRGF0YVtJRF0uZGFtYWdlID0gc2VsZi5EYXRhW0lEXS5kYW1hZ2UgKyBkYW0KZW5kCgpmdW5jdGlvbiBIZXJvRGF0YTpBZGRUYW5rKElELCB0YW5rKQogICAgc2VsZi5EYXRhW0lEXS50YW5rID0gc2VsZi5EYXRhW0lEXS50YW5rICsgdGFuawplbmQKCi0t6K6+572u6Iux6ZuE57Si5byVCmZ1bmN0aW9uIEhlcm9EYXRhOlNldEhlcm9JbmRleChJRCwgaGVybykKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGlmIG5vdCBzZWxmLkRhdGFbSURdIHRoZW4KICAgICAgICBzZWxmOkluaXQoSUQpCiAgICBlbmQKICAgIHNlbGYuRGF0YVtJRF0uaGVyb19pbmRleCA9IGhlcm86R2V0RW50aXR5SW5kZXgoKQplbmQK]]
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