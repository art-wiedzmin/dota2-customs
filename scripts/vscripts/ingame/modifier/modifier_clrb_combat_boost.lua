--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0gMTUg56eS5YaFICs2MCDmlLvpgJ/jgIErMzAlIOenu+mAn+OAgSszMCUg54q25oCB5oqX5oCn77yI5Y+v6LCDIGR1cmF0aW9u77yJCgptb2RpZmllcl9jbHJiX2NvbWJhdF9ib29zdCA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9jb21iYXRfYm9vc3Q6SXNIaWRkZW4oKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9jb21iYXRfYm9vc3Q6SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9jb21iYXRfYm9vc3Q6SXNQdXJnYWJsZSgpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfY29tYmF0X2Jvb3N0OlJlbW92ZU9uRGVhdGgoKQogICAgcmV0dXJuIHRydWUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX2NvbWJhdF9ib29zdDpPbkNyZWF0ZWQoa3YpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIGdqc2QgPSBrdi5nanNkIG9yIDYwCiAgICBsb2NhbCB6dGt4ID0ga3YuenRreCBvciAzMAogICAgbG9jYWwgeWRzZCA9IGt2Lnlkc2Qgb3IgMzAKICAgIGxvY2FsIGQgPSAzCiAgICBpZiBkIDwgMCB0aGVuCiAgICAgICAgZCA9IDE1CiAgICBlbmQKICAgIHNlbGY6U2V0RHVyYXRpb24oZCwgdHJ1ZSkKICAgIHNlbGYuZ2pzZCA9IGdqc2QKICAgIHNlbGYuenRreCA9IHp0a3gKICAgIHNlbGYueWRzZCA9IHlkc2QKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX2NvbWJhdF9ib29zdDpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfQVRUQUNLU1BFRURfQk9OVVNfQ09OU1RBTlQsCiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfTU9WRVNQRUVEX0JPTlVTX1BFUkNFTlRBR0UsCiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfU1RBVFVTX1JFU0lTVEFOQ0VfU1RBQ0tJTkcsCiAgICB9CmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9jb21iYXRfYm9vc3Q6R2V0TW9kaWZpZXJBdHRhY2tTcGVlZEJvbnVzX0NvbnN0YW50KGt2KQogICAgLS0gcHJpbnQoc2VsZikKICAgIHJldHVybiBzZWxmLmdqc2QKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX2NvbWJhdF9ib29zdDpHZXRNb2RpZmllck1vdmVTcGVlZEJvbnVzX1BlcmNlbnRhZ2Uoa3YpCiAgICByZXR1cm4gc2VsZi55ZHNkCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9jb21iYXRfYm9vc3Q6R2V0TW9kaWZpZXJTdGF0dXNSZXNpc3RhbmNlU3RhY2tpbmcoa3YpCiAgICByZXR1cm4gc2VsZi56dGt4CmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9jb21iYXRfYm9vc3Q6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gIml0ZW1faHlwZXJzdG9uZSIKZW5kCg==]]
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