--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[U2VydmVyLkRhdGEgPSB7fQotLSDov57nu63mnKrog73lrozmiJAgL3VzZXIvbG9naW7vvIjlkKvnvZHnu5zlpLHotKXvvInml7bouKLlh7rvvIzop4EgU2VydmVyOkNoZWNrVXNlcgpTZXJ2ZXIuTE9HSU5fRkFJTF9NQVggPSAyMApTZXJ2ZXIuVGVtcGxhdGUgPSB7CiAgICB3aGl0ZWxpc3QgPSB0cnVlLAogICAgdXNlcl9zdGF0ZSA9IGZhbHNlLAogICAgbG9naW5fZmFpbF9jb3VudCA9IDAsCiAgICBsb2dpbl9pbmZsaWdodCA9IGZhbHNlLAogICAgbG9naW5fZ2F2ZV91cCA9IGZhbHNlLAogICAgdXNlcl9kYXRhID0ge30sCiAgICBwYXkgPSB7CiAgICAgICAgZXdtID0gIiIsCiAgICAgICAgcGF5X2luZGV4ID0gLTEKICAgIH0KfQpTZXJ2ZXIuV0xpc3QgPSB7fQotLSDlvIDlsYDkuIDmrKHmi4nlj5bvvJpoZXJvX2lkIC0+IHsgZGFtYWdlX2RlYWx0X3BjdCwgZGFtYWdlX3Rha2VuX3JlZHVjZV9wY3QgfQpTZXJ2ZXIuSGVyb0JhbGFuY2VCeUlkID0ge30KU2VydmVyLkhlcm9CYWxhbmNlTG9hZGVkID0gZmFsc2UKU2VydmVyLlVzZXJUZW1wbGF0ZSA9IHsKICAgIHBpZCA9IDAsCiAgICBnb2xkID0gMCwKICAgIGNhcmQxID0gMCwKICAgIGNhcmQyID0gMCwKICAgIGdvbGQ2ID0gMCwKICAgIGdvbGQzMCA9IDAsCiAgICBnb2xkNjggPSAwLAogICAgZ29sZDEyOCA9IDAsCiAgICBnb2xkMzI4ID0gMCwKICAgIGdvbGQ2NDggPSAwLAogICAgZ29sZDEyODAgPSAwLAogICAgZ29sZF9kYXkgPSAwLAogICAgZnJlZV9kYXkgPSAxLAogICAgcG9pbnQgPSAxMDAwLAp9Cg==]]
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