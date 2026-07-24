--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[TGlua0x1YU1vZGlmaWVyKCJtb2RpZmllcl9tXzJfM19hdHRhY2siLCAiaW5nYW1lL01vbnN0ZXIvbW9kaWZpZXJfbV8yXzNfYXR0YWNrIiwgTFVBX01PRElGSUVSX01PVElPTl9OT05FKQoKbW9kaWZpZXJfbV8yXzNfYXR0YWNrID0gY2xhc3Moe30pCgpsb2NhbCBQUk9KRUNUSUxFID0gInBhcnRpY2xlcy91bml0cy9oZXJvZXMvaGVyb196dXVzL3p1dXNfYmFzZV9hdHRhY2sudnBjZiIKCmZ1bmN0aW9uIG1vZGlmaWVyX21fMl8zX2F0dGFjazpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX21fMl8zX2F0dGFjazpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX21fMl8zX2F0dGFjazpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX21fMl8zX2F0dGFjazpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7IE1PRElGSUVSX1BST1BFUlRZX1BST0pFQ1RJTEVfTkFNRSB9CmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfbV8yXzNfYXR0YWNrOkdldE1vZGlmaWVyUHJvamVjdGlsZU5hbWUoKQogICAgcmV0dXJuIFBST0pFQ1RJTEUKZW5kCg==]]
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