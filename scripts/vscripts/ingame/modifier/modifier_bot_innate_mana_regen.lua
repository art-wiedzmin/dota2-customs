--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfYm90X2lubmF0ZV9tYW5hX3JlZ2VuID0gY2xhc3Moe30pCgpsb2NhbCBNQU5BX1JFR0VOX0NPTlNUID0gcmF3Z2V0KF9HLCAiTU9ESUZJRVJfUFJPUEVSVFlfTUFOQV9SRUdFTl9DT05TVEFOVCIpCgpmdW5jdGlvbiBtb2RpZmllcl9ib3RfaW5uYXRlX21hbmFfcmVnZW46SXNIaWRkZW4oKQogICAgcmV0dXJuIHRydWUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9ib3RfaW5uYXRlX21hbmFfcmVnZW46SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYm90X2lubmF0ZV9tYW5hX3JlZ2VuOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYm90X2lubmF0ZV9tYW5hX3JlZ2VuOlJlbW92ZU9uRGVhdGgoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYm90X2lubmF0ZV9tYW5hX3JlZ2VuOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNQU5BX1JFR0VOX0NPTlNUIG9yIE1PRElGSUVSX1BST1BFUlRZX01BTkFfUkVHRU5fQ09OU1RBTlQsCiAgICB9CmVuZAoKLS0g5Zu65a6a6aKd5aSW5rOV5Yqb5Zue5aSNL+enku+8m+aVsOWAvOingSBCb3RBSS5Db25maWcuYm90X2lubmF0ZV9tYW5hX3JlZ2VuX3Blcl9zZWNvbmTvvIjpu5jorqQgNTDvvIkKZnVuY3Rpb24gbW9kaWZpZXJfYm90X2lubmF0ZV9tYW5hX3JlZ2VuOkdldE1vZGlmaWVyQ29uc3RhbnRNYW5hUmVnZW4oKQogICAgbG9jYWwgdiA9IDUwCiAgICBpZiBCb3RBSSBhbmQgQm90QUkuQ29uZmlnIGFuZCB0eXBlKEJvdEFJLkNvbmZpZy5ib3RfaW5uYXRlX21hbmFfcmVnZW5fcGVyX3NlY29uZCkgPT0gIm51bWJlciIgdGhlbgogICAgICAgIHYgPSBCb3RBSS5Db25maWcuYm90X2lubmF0ZV9tYW5hX3JlZ2VuX3Blcl9zZWNvbmQKICAgIGVuZAogICAgcmV0dXJuIHYKZW5kCg==]]
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