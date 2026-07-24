--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g5pys5Zyw5YyWL+WxleekuuWQjei+heWKqe+8iOacjeWKoeerr+aXoCBQYW5vcmFtYe+8jOWksei0peaXtui/lOWbnuepuuS4suaIluWOn+WQje+8iQoKZnVuY3Rpb24gT3ZlclN0YXQ6R2V0R2FtZVRpbWVEb3RhKCkKICAgIGxvY2FsIGdyID0gR2FtZVJ1bGVzCiAgICBpZiBnciBhbmQgZ3IuR2V0RE9UQVRpbWUgdGhlbgogICAgICAgIHJldHVybiBncjpHZXRET1RBVGltZSh0cnVlLCB0cnVlKQogICAgZW5kCiAgICByZXR1cm4gMAplbmQKCmZ1bmN0aW9uIE92ZXJTdGF0Okl0ZW1UaXRsZVpoKGl0ZW1fbmFtZSkKICAgIGlmIG5vdCBpdGVtX25hbWUgb3IgaXRlbV9uYW1lID09ICIiIHRoZW4KICAgICAgICByZXR1cm4gIiIKICAgIGVuZAogICAgbG9jYWwga2V5ID0gIkRPVEFfVG9vbHRpcF9hYmlsaXR5XyIgLi4gaXRlbV9uYW1lCiAgICBsb2NhbCBnciA9IEdhbWVSdWxlcwogICAgaWYgZ3IgYW5kIHR5cGUoZ3IuR2V0TG9jYWxpemVkU3RyaW5nKSA9PSAiZnVuY3Rpb24iIHRoZW4KICAgICAgICBsb2NhbCBvaywgcyA9IHBjYWxsKGZ1bmN0aW9uKCkKICAgICAgICAgICAgcmV0dXJuIGdyOkdldExvY2FsaXplZFN0cmluZyhrZXkpCiAgICAgICAgZW5kKQogICAgICAgIGlmIG9rIGFuZCBzIGFuZCBzIH49ICIiIGFuZCBzIH49IGtleSB0aGVuCiAgICAgICAgICAgIHJldHVybiBzCiAgICAgICAgZW5kCiAgICBlbmQKICAgIHJldHVybiAiIgplbmQKCmZ1bmN0aW9uIE92ZXJTdGF0OkFiaWxpdHlUaXRsZVpoKGFiaWxpdHlfbmFtZSkKICAgIGlmIG5vdCBhYmlsaXR5X25hbWUgb3IgYWJpbGl0eV9uYW1lID09ICIiIHRoZW4KICAgICAgICByZXR1cm4gIiIKICAgIGVuZAogICAgbG9jYWwga2V5ID0gIkRPVEFfVG9vbHRpcF9hYmlsaXR5XyIgLi4gYWJpbGl0eV9uYW1lCiAgICBsb2NhbCBnciA9IEdhbWVSdWxlcwogICAgaWYgZ3IgYW5kIHR5cGUoZ3IuR2V0TG9jYWxpemVkU3RyaW5nKSA9PSAiZnVuY3Rpb24iIHRoZW4KICAgICAgICBsb2NhbCBvaywgcyA9IHBjYWxsKGZ1bmN0aW9uKCkKICAgICAgICAgICAgcmV0dXJuIGdyOkdldExvY2FsaXplZFN0cmluZyhrZXkpCiAgICAgICAgZW5kKQogICAgICAgIGlmIG9rIGFuZCBzIGFuZCBzIH49ICIiIGFuZCBzIH49IGtleSB0aGVuCiAgICAgICAgICAgIHJldHVybiBzCiAgICAgICAgZW5kCiAgICBlbmQKICAgIHJldHVybiAiIgplbmQK]]
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