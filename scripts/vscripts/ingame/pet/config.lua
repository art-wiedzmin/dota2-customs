--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[UGV0LkRhdGEgPSB7fQpQZXQuVGVtcGxhdGUgPSB7CiAgICAtLeWuoOeJqeaYr+WQpuimgeWOu+aNoeS4nOilvwogICAgcGljayA9IGZhbHNlLAogICAgLS0g5piv5ZCm5byA5ZCv6Ieq5Yqo5ou+5Y+W77yI5bGA5aSW6IOM5YyF5L2p5oi05a6g54mp5pe25Li6IHRydWXvvIkKICAgIHBpY2tfZW5hYmxlZCA9IGZhbHNlLAogICAgcGlja19saXN0ID0ge30sCiAgICBzZXNzaW9uX3BldF9yZWFkeSA9IGZhbHNlLAogICAgLS0g5b2T5YmN5bGA5YaF5a6g54mp5a+55bqU55qE5bGA5aSWIGl0ZW1fa2V577yI5YiH5o2i5L2p5oi05pe26ZyA6YeN55Sf5Y2V5L2N5o2i5qih5Z6L77yJCiAgICBlcXVpcHBlZF9wZXRfa2V5ID0gIiIsCiAgICAtLeWuoOeJqee0ouW8lQogICAgaW5kZXggPSAtMSwKfQpQZXQuU3RhdGljID0gewogICAgLS3lrqDnianov73pmo/ojIPlm7QKICAgIGZvbGxvdyA9IDMwMCwKICAgIC0t6L+U5Zue6IyD5Zu0CiAgICBiYWNrID0gMTAwMCwKICAgIC0t5o2h5Lic6KW/6IyD5Zu0CiAgICBwaWNrID0gODAwCn0KUGV0LlBpY2tMaXN0ID0gewogICAgIml0ZW1fZ29vZHNfMTQiLAogICAgIml0ZW1fZ29vZHNfMTUiLAp9Cg==]]
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