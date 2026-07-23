--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[cmVxdWlyZSgiaW5nYW1lLm1vZGlmaWVyLm1vZGlmaWVyX2NscmJfdGFsZW50cyIpCgpmdW5jdGlvbiBJbml0UGxheWVyOkdldFBsYXllckRhdGEoSUQpCiAgICBpZiBub3QgSUQgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBsb2NhbCBwbGF5ZXJfa2V5ID0gInBsYXllcl8iIC4uIElECiAgICBpZiBub3Qgc2VsZi5QdWJsaWMucGxheWVyc1twbGF5ZXJfa2V5XSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbHNlCiAgICAgICAgcmV0dXJuIHNlbGYuUHVibGljLnBsYXllcnNbcGxheWVyX2tleV0KICAgIGVuZAplbmQKCmZ1bmN0aW9uIEluaXRQbGF5ZXI6U2V0SGVyb1N0YXRlKElELCBoZXJvbmFtZSwgaGVyb19pbmRleCkKICAgIGlmIG5vdCBJRCBvciBub3QgaGVyb25hbWUgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBsb2NhbCBkYXRhID0gc2VsZjpHZXRQbGF5ZXJEYXRhKElEKQogICAgZGF0YS5oZXJvX3N0YXRlID0gdHJ1ZQogICAgZGF0YS5oZXJvX25hbWUgPSBoZXJvbmFtZQogICAgZGF0YS5oZXJvX2luZGV4ID0gaGVyb19pbmRleAogICAgU2VsZWN0SGVyby5EYXRhW0lEXS5oZXJvX25hbWUgPSBoZXJvbmFtZQogICAgbG9jYWwgdGkgPSAxCiAgICBpZiBTZWxlY3RIZXJvLkRhdGFbSURdIGFuZCBTZWxlY3RIZXJvLkRhdGFbSURdLnRhbGVudF9pbmRleCB+PSBuaWwgdGhlbgogICAgICAgIHRpID0gU2VsZWN0SGVybzpTYW5pdGl6ZVRhbGVudEluZGV4KFNlbGVjdEhlcm8uRGF0YVtJRF0udGFsZW50X2luZGV4KQogICAgZW5kCiAgICBkYXRhLnRhbGVudF9pbmRleCA9IHRpCiAgICBDbHJiU3luY1RhbGVudE5ldHRhYmxlKElELCB0aSkKZW5kCg==]]
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