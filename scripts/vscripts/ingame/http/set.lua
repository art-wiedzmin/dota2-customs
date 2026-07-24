--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS3orr7nva7mqKHlvI8KZnVuY3Rpb24gSHR0cDpTZXRUcCgpCiAgICBpZiBJc0luVG9vbHNNb2RlKCkgdGhlbgogICAgICAgIHNlbGYuRGF0YS50cCA9IDEKICAgIGVsc2UKICAgICAgICBzZWxmLkRhdGEudHAgPSAyCiAgICBlbmQKZW5kCgotLeiuvue9rklQ5ZKM56uv5Y+jCmZ1bmN0aW9uIEh0dHA6U2V0SXAoKQogICAgaWYgc2VsZi5EYXRhLnRwID09IDEgdGhlbgogICAgICAgIHNlbGYuRGF0YS5JUCA9ICIxMjcuMC4wLjEiCiAgICBlbHNlCiAgICAgICAgc2VsZi5EYXRhLklQID0gc2VsZi5EYXRhLnNlcnZlcmlwCiAgICBlbmQKZW5kCgpmdW5jdGlvbiBIdHRwOlNldFBvcnQoKQogICAgaWYgc2VsZi5EYXRhLnRwID09IDEgdGhlbgogICAgICAgIHNlbGYuRGF0YS5Qb3J0ID0gc2VsZi5EYXRhLmxvY2FscG9ydCBvciAzMDAwCiAgICBlbHNlCiAgICAgICAgc2VsZi5EYXRhLlBvcnQgPSBzZWxmLkRhdGEuc2VydmVycG9ydAogICAgZW5kCmVuZAoKLS3orr7nva7kvKDovpNrZXkKZnVuY3Rpb24gSHR0cDpTZXRTZWNyZXRLZXkoKQogICAgbG9jYWwgU0tEX0tleSA9IHNlbGY6R2V0U0tEKCkKICAgIC0t5Lyg6L6TS0VZCiAgICBzZWxmLkRhdGEuc2VjcmV0a2V5ID0gVXRpbDpDdXRPdXQoU0tEX0tleSwgMSwgMTApCmVuZAoKLS3orr7nva7kuLvmnLrlnLDlnYAKZnVuY3Rpb24gSHR0cDpTZXRVcmwoKQogICAgbG9jYWwgSVAgPSBzZWxmLkRhdGEuSVAKICAgIGxvY2FsIFBvcnQgPSBzZWxmLkRhdGEuUG9ydAogICAgc2VsZi5EYXRhLnVybCA9ICJodHRwOi8vIiAuLiBJUCAuLiAiOiIgLi4gUG9ydAplbmQK]]
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