--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfd2VhdGhlcl80ID0gY2xhc3Moe30pCkxpbmtMdWFNb2RpZmllcigibW9kaWZpZXJfd2VhdGhlcl80X2J1ZmYiLAogICAgICAgICAgICAgICAgImluZ2FtZS9tb2RpZmllci9tb2RpZmllcl93ZWF0aGVyXzRfYnVmZiIsCiAgICAgICAgICAgICAgICBMVUFfTU9ESUZJRVJfTU9USU9OX05PTkUpCgotLSDmmK/lkKblnKjpnaLmnb/kuIrmmL7npLoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80OklzSGlkZGVuKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80OklzRGVidWZmKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80OklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlIC0tIOS4jeWPr+iiq+mpseaVowplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfNDpSZW1vdmVPbkRlYXRoKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80OkdldFRleHR1cmUoKSByZXR1cm4gInNjcm9sbC93ZWF0aGVyX3Nub3dfcG5nIiBlbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfNDpBbGxvd0lsbHVzaW9uRHVwbGljYXRlKCkgcmV0dXJuIGZhbHNlIGVuZAoKLS0g5a+S6Zyc77ya5YeP5bCR55Sf5ZG95Zue5aSN5LiO5rK755aX5pWI5p6c77yM6ZmN5L2O56e76YCf77yb5pS75Ye75ZG95Lit5pe25LuN5Y+v5pa95Yqg5a+S6ZycIGRlYnVmZgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzQ6T25DcmVhdGVkKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBzZWxmOlNldER1cmF0aW9uKGt2LmR1ciwgdHJ1ZSkKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzQ6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4geyAtLSDnlJ/lkb3lm57lpI3vvIjotJ/lgLw95YeP5bCR77yJICAtLSDnp7vpgJ/vvIjotJ/lgLw95YeP6YCf77yJCiAgICAgICAgTU9ESUZJRVJfRVZFTlRfT05fQVRUQUNLX0xBTkRFRAogICAgfQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfNDpPbkF0dGFja0xhbmRlZChrZXlzKQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBpZiBrZXlzLmF0dGFja2VyID09IHNlbGY6R2V0UGFyZW50KCkgdGhlbgogICAgICAgIC0tIHByaW50KCLmlLvlh7vlkb3kuK0iKQogICAgICAgIC0tIOWRveS4reaXtuinpuWPkeaKgOiDveaViOaenAogICAgICAgIGxvY2FsIGNhID0gc2VsZjpHZXRQYXJlbnQoKQogICAgICAgIGxvY2FsIHRhID0ga2V5cy50YXJnZXQKICAgICAgICB0YTpBZGROZXdNb2RpZmllcihjYSwgLS0g5pa95rOV6ICFCiAgICAgICAgc2VsZiwgLS0g5oqA6IO9CiAgICAgICAgIm1vZGlmaWVyX3dlYXRoZXJfNF9idWZmIiwgLS0g5L+u6aWw5Zmo5ZCN56ewCiAgICAgICAge2R1ciA9IDJ9IC0tIOWPguaVsAogICAgICAgICkKICAgIGVuZAplbmQK]]
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