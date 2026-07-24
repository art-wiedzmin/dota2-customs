--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[aWYgQWNoaWV2ZU1vZHVsZSA9PSBuaWwgdGhlbgogICAgQWNoaWV2ZU1vZHVsZSA9IGNsYXNzKHt9KQogICAgcmVxdWlyZSgiaW5nYW1lLkFjaGlldmUuQ29uZmlnIikKICAgIHJlcXVpcmUoImluZ2FtZS5BY2hpZXZlLlNldCIpCiAgICByZXF1aXJlKCJpbmdhbWUuQWNoaWV2ZS5HZXQiKQogICAgcmVxdWlyZSgiaW5nYW1lLkFjaGlldmUuVWkiKQogICAgcmVxdWlyZSgiaW5nYW1lLkFjaGlldmUuQ2xhaW0iKQogICAgcmVxdWlyZSgiaW5nYW1lLkFjaGlldmUuQWNoaWV2ZVN0YXQiKQplbmQKCkFjaGlldmVNb2R1bGUuRGF0YSA9IEFjaGlldmVNb2R1bGUuRGF0YSBvciB7fQoKZnVuY3Rpb24gQWNoaWV2ZU1vZHVsZTpJbml0KElEKQogICAgaWYgbm90IElEIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgc2VsZi5EYXRhW0lEXSA9IFV0aWw6RGVlcENvcHlUYWIoc2VsZi5UZW1wbGF0ZSkKZW5kCg==]]
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