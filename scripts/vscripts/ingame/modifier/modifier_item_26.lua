--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfaXRlbV8yNiA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8yNjpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzI2OklzRGVidWZmKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMjY6SXNQdXJnYWJsZSgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzI2OlJlbW92ZU9uRGVhdGgoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8yNjpHZXRUZXh0dXJlKCkKICAgIHJldHVybiAiaXRlbV9vY3RhcmluZV9jb3JlIgplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMjY6R2V0VG9vbHRpcCgpCiAgICByZXR1cm4gIumjjuaatOaguOW/g++8misxNTAwIOeUn+WRveWAvOOAgSsyMCDlhajlsZ7mgKfjgIErMTAlIOacgOe7iOS8pOWusyIKZW5kCg==]]
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