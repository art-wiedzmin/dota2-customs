--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfd2VhdGhlcl8zID0gY2xhc3Moe30pCgotLSDmmK/lkKblnKjpnaLmnb/kuIrmmL7npLoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8zOklzSGlkZGVuKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8zOklzRGVidWZmKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8zOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlIC0tIOS4jeWPr+iiq+mpseaVowplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMzpSZW1vdmVPbkRlYXRoKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8zOkdldFRleHR1cmUoKSByZXR1cm4gInNjcm9sbC93ZWF0aGVyX2Z4XzJfcHNkIiBlbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMzpBbGxvd0lsbHVzaW9uRHVwbGljYXRlKCkgcmV0dXJuIGZhbHNlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl8zOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHtNT0RJRklFUl9QUk9QRVJUWV9IRUFMVEhfUkVHRU5fUEVSQ0VOVEFHRX0KZW5kCgotLSDpm6jpnLLvvJrojrflvpcgMyUg55Sf5ZG95YC85Zue5aSN77yI5oyJ5pyA5aSn55Sf5ZG95YC85q+P56eS5Zue5aSN77yJCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMzpHZXRNb2RpZmllckhlYWx0aFJlZ2VuUGVyY2VudGFnZSgpIHJldHVybiAzIGVuZAoKLS0g5Yib5bu65pe26K6+572uCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfMzpPbkNyZWF0ZWQoa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKICAgIHNlbGY6U2V0RHVyYXRpb24oa3YuZHVyLCB0cnVlKQplbmQK]]
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