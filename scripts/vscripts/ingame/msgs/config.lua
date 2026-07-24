--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[TXNncy5EYXRhID0ge30KTXNncy5UZW1wbGF0ZSA9IHsKICAgIC0t6aG16Z2i5byA5YWzCiAgICBwYWdlID0gZmFsc2UsCiAgICAtLeaYr+WQpuacieeJqeWTgeWlluWKsQogICAgaXRlbV9zdGF0ZSA9IGZhbHNlLAogICAgLS3mj5DnpLrmloflrZcKICAgIHRleHQgPSAiIiwKICAgIC0t54mp5ZOB5aWW5Yqx5YiX6KGoCiAgICBpdGVtID0ge30sCiAgICAtLSDlhZHmjaLnoIHlvLnnqpfvvJoibm9uZSIgfCAib2siIHwgImZhaWwiCiAgICByZWRlZW1fc3RhdGUgPSAibm9uZSIsCiAgICAtLSDlhZHmjaLmiJDlip/ml7bmr4/ooYzvvJp7IGltZywgY291bnQsIHVuaXQgfQogICAgcmVkZWVtX3Jvd3MgPSB7fSwKfQpNc2dzLkF3YXJkID0gewogICAgZ29vZHNfMiA9IHsKICAgICAgICBpdGVtMSA9IDYwCiAgICB9LAogICAgZ29vZHNfMyA9IHsKICAgICAgICBpdGVtMSA9IDMwMAogICAgfSwKICAgIGdvb2RzXzQgPSB7CiAgICAgICAgaXRlbTEgPSA2ODAKICAgIH0sCiAgICBnb29kc181ID0gewogICAgICAgIGl0ZW0xID0gMTI4MAogICAgfSwKICAgIGdvb2RzXzYgPSB7CiAgICAgICAgaXRlbTEgPSAzMjgwCiAgICB9LAogICAgZ29vZHNfNyA9IHsKICAgICAgICBpdGVtMSA9IDY0ODAKICAgIH0sCiAgICBnb29kc18xMCA9IHsKICAgICAgICBpdGVtMSA9IDEyODAwCiAgICB9LAogICAgZ29vZHNfOCA9IHsKICAgICAgICBpdGVtMSA9IDMwCiAgICB9LAogICAgZ29vZHNfOSA9IHsKICAgICAgICBpdGVtMSA9IDUwCiAgICB9LAp9Cg==]]
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