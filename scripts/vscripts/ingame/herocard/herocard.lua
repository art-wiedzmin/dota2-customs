--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[aWYgSGVyb0NhcmQgPT0gbmlsIHRoZW4KICAgIEhlcm9DYXJkID0gY2xhc3Moe30pCmVuZApyZXF1aXJlKCJpbmdhbWUuSGVyb0NhcmQuQ29uZmlnIikKcmVxdWlyZSgiaW5nYW1lLkhlcm9DYXJkLkZ1bmMiKQpyZXF1aXJlKCJpbmdhbWUuSGVyb0NhcmQuVWkiKQoKLS0gVUkg5Y+v6IO95pep5LqOIEluaXRQbGF5ZXI6SW5pdF9JRCDlm57osIPvvIzpgb/lhY0gc2VsZi5EYXRhW0lEXSDkuLrnqboKZnVuY3Rpb24gSGVyb0NhcmQ6RW5zdXJlUGxheWVyRGF0YShJRCkKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGlmIG5vdCBzZWxmLkRhdGFbSURdIHRoZW4KICAgICAgICBzZWxmLkRhdGFbSURdID0gVXRpbDpEZWVwQ29weVRhYihzZWxmLlRlbXBsYXRlKQogICAgZW5kCmVuZAoKZnVuY3Rpb24gSGVyb0NhcmQ6SW5pdChJRCkKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHNlbGYuRGF0YVtJRF0gPSBVdGlsOkRlZXBDb3B5VGFiKHNlbGYuVGVtcGxhdGUpCmVuZAoKZnVuY3Rpb24gSGVyb0NhcmQ6T3BlblBhZ2UoSUQpCiAgICBpZiBub3QgSUQgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBzZWxmOkVuc3VyZVBsYXllckRhdGEoSUQpCiAgICBzZWxmLkRhdGFbSURdLnBhZ2UgPSB0cnVlCiAgICAtLSBzZWxmOlNlbmREYXRhKElEKQplbmQKCmZ1bmN0aW9uIEhlcm9DYXJkOkNsb3NlUGFnZShJRCkKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHNlbGY6RW5zdXJlUGxheWVyRGF0YShJRCkKICAgIHNlbGYuRGF0YVtJRF0ucGFnZSA9IGZhbHNlCiAgICBzZWxmOlNlbmREYXRhKElEKQplbmQKCi0tIOafpeeci+iLsembhOS/oeaBr++8iOanveS9jeWPguaVsOS4jiBTdGF0IOS4gOiHtO+8mjV2NSDkvKAgc2lkZStnaWTvvIwxdjEwIOS8oCByb3fvvIkKZnVuY3Rpb24gSGVyb0NhcmQ6SGVyb0luZm8oSUQsIGRhdGEpCiAgICBpZiBub3QgSUQgb3Igbm90IGRhdGEgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBsb2NhbCBwaWQgPSBzZWxmOlJlc29sdmVQbGF5ZXJJZEZyb21TbG90KGRhdGEpCiAgICBpZiBub3QgcGlkIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgc2VsZjpPcGVuUGFnZShJRCkKICAgIGxvY2FsIHBheWxvYWQgPSBzZWxmOkJ1aWxkUGF5bG9hZChwaWQpCiAgICBzZWxmLkRhdGFbSURdLmRhdGEgPSBwYXlsb2FkCiAgICBzZWxmOlNlbmREYXRhKElEKQplbmQK]]
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