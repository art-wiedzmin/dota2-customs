--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS3lhazlhbHku5PlupPmmK/lkKbmnInlkIzlkI3pgZPlhbcKZnVuY3Rpb24gUGFjazpJc0hhdmVJdGVtKHRlYW0sIGl0ZW1fbmFtZSkKICAgIGxvY2FsIHRlYW1fa2V5ID0gIlRlYW0iIC4uIHRlYW0KICAgIGZvciBrLCB2IGluIHBhaXJzKHNlbGZbdGVhbV9rZXldKSBkbwogICAgICAgIGlmIHYuc3RhdGUgYW5kIHYubmFtZSA9PSBpdGVtX25hbWUgdGhlbgogICAgICAgICAgICByZXR1cm4gdHJ1ZQogICAgICAgIGVuZAogICAgZW5kCmVuZAoKLS3ojrflj5bnjqnlrrbku5PlupPnirbmgIEKZnVuY3Rpb24gUGFjazpHZXRQYWdlKElEKQogICAgcmV0dXJuIHNlbGYuRGF0YVtJRF0ucGFnZQplbmQK]]
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