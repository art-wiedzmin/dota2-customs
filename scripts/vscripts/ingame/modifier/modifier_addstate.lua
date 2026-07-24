--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfYWRkc3RhdGUgPSBjbGFzcyh7fSkKCmZ1bmN0aW9uIG1vZGlmaWVyX2FkZHN0YXRlOklzSGlkZGVuKCkgcmV0dXJuIHRydWUgZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hZGRzdGF0ZTpJc1B1cmdhYmxlKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYWRkc3RhdGU6T25DcmVhdGVkKCkKICAgIGlmIElzU2VydmVyKCkgdGhlbgogICAgICAgIC0tIHByaW50KCJtb2RpZmllciDlt7LliJvlu7oiKQogICAgZW5kCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYWRkc3RhdGU6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX0FPRV9CT05VU19QRVJDRU5UQUdFLAogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX0FPRV9CT05VU19DT05TVEFOVCwKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9BT0VfQk9OVVNfQ09OU1RBTlRfU1RBQ0tJTkcsCiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfU1RBVFVTX1JFU0lTVEFOQ0UsCiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfU0xPV19SRVNJU1RBTkNFX1VOSVFVRQogICAgfQplbmQKCi0t5Yqg54q25oCB5oqX5oCnCmZ1bmN0aW9uIG1vZGlmaWVyX2FkZHN0YXRlOkdldE1vZGlmaWVyU3RhdHVzUmVzaXN0YW5jZSgpCiAgICByZXR1cm4gMjAKZW5kCgotLeWHj+mAn+aKl+aApwpmdW5jdGlvbiBtb2RpZmllcl9hZGRzdGF0ZTpHZXRNb2RpZmllclNsb3dSZXNpc3RhbmNlX1VuaXF1ZSgpCiAgICByZXR1cm4gMjAKZW5kCgotLeWKoOS9nOeUqOiMg+WbtApmdW5jdGlvbiBtb2RpZmllcl9hZGRzdGF0ZTpHZXRNb2RpZmllckFPRUJvbnVzUGVyY2VudGFnZSgpCiAgICByZXR1cm4gMTAwCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYWRkc3RhdGU6R2V0TW9kaWZpZXJBT0VCb251c0NvbnN0YW50KCkKICAgIHJldHVybiAxMDAKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hZGRzdGF0ZTpHZXRNb2RpZmllckFPRUJvbnVzQ29uc3RhbnRTdGFja2luZygpCiAgICByZXR1cm4gMTAwCmVuZAo=]]
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