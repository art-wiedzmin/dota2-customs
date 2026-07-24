--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[TGVhdmVDb25maXJtLkRhdGEgPSB7fQotLS0g5pys5bGA5piv5ZCm5bey5oOp572a6L+H77yI5LuF56ys5LiA5Liq5oyB57ut5pat57q/6LaF5pe255qE546p5a6277yJCkxlYXZlQ29uZmlybS5wZW5hbHR5X2NsYWltZWQgPSBMZWF2ZUNvbmZpcm0ucGVuYWx0eV9jbGFpbWVkIG9yIGZhbHNlCi0tLSDmlq3nur/lkI7nrYnlvoXjgIzmjIHnu63nprvnur/mu6EgNSDliIbpkp/jgI3nmoTnm5Hop4bmoIforrAKTGVhdmVDb25maXJtLl9hYmFuZG9uX3dhdGNoID0gTGVhdmVDb25maXJtLl9hYmFuZG9uX3dhdGNoIG9yIHt9Ci0tLSDmnKzlsYDllK/kuIAgaWTvvIzpmo8gZWFybHlfbGVhdmUg5LiK5oql77yM5L6b5pyN5Yqh56uv5Y676YeNCkxlYXZlQ29uZmlybS5tYXRjaF91aWQgPSBMZWF2ZUNvbmZpcm0ubWF0Y2hfdWlkIG9yIG5pbApMZWF2ZUNvbmZpcm0uVGVtcGxhdGUgPSB7CiAgICBwYWdlID0gZmFsc2UsCn0K]]
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