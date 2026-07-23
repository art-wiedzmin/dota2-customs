--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[SHR0cC5EYXRhID0gewogICAgLS3orr7nva7lvZPliY3mqKHlvI8oMSzmnKzlnLDvvIwy77yM57q/5LiKKeOAgum7mOiupOe6v+S4iu+8m0luaXQg5LiN6Ieq5Yqo5ZugIFRvb2xzTW9kZSDliIfmnKzlnLDjgIIKICAgIHRwID0gMiwKICAgIC0t5pyN5Yqh5Zmo5Zyw5Z2ACiAgICBzZXJ2ZXJpcCA9ICI0Ny44My4xNzYuMTkxIiwKICAgIHNlcnZlcnBvcnQgPSA4MCwKICAgIC0tIOS7heW9k+aJi+WKqCBTZXRUcCgpIOS4uuacrOWcsOaooeW8j+aXtuS9v+eUqAogICAgbG9jYWxwb3J0ID0gMzAwMCwKICAgIFNLRF9LRVkgPSAiQ0xSQl9TRVZFUl9DT0RFX05BTUUiLAogICAgLS3kvKDovpNLRVkKICAgIHNlY3JldGtleSA9ICIiLAogICAgSVAgPSAiIiwKICAgIFBvcnQgPSAiIiwKICAgIC0t5Li75py65Zyw5Z2ACiAgICB1cmwgPSAiIiwKfQo=]]
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