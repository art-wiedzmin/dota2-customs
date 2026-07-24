--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g5YeP55SyZGVidWZmIG1vZGlmaWVyCm1vZGlmaWVyX2FuY2hvcl9idWZmID0gY2xhc3Moe30pCgpmdW5jdGlvbiBtb2RpZmllcl9hbmNob3JfYnVmZjpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hbmNob3JfYnVmZjpJc0RlYnVmZigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2FuY2hvcl9idWZmOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIHRydWUgLS0g5Y+v5Lul6KKr6amx5pWjCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfYW5jaG9yX2J1ZmY6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2FuY2hvcl9idWZmOk9uQ3JlYXRlZChwYXJhbXMpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuIHJldHVybiBlbmQKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hbmNob3JfYnVmZjpPblJlZnJlc2gocGFyYW1zKQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICAtLSDliLfmlrDml7bkuI3pnIDopoHlgZrpop3lpJbmk43kvZwKZW5kCgotLSDlo7DmmI7kv67mlLnlh73mlbAKZnVuY3Rpb24gbW9kaWZpZXJfYW5jaG9yX2J1ZmY6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX0JBU0VEQU1BR0VPVVRHT0lOR19QRVJDRU5UQUdFLAogICAgfQplbmQKCi0tIOiuoeeul+aAu+aKpOeUsumZjeS9juWAvApmdW5jdGlvbiBtb2RpZmllcl9hbmNob3JfYnVmZjpHZXRNb2RpZmllckJhc2VEYW1hZ2VPdXRnb2luZ19QZXJjZW50YWdlKCkKICAgIGxvY2FsIGxldmVsID0gc2VsZjpHZXRBYmlsaXR5KCk6R2V0TGV2ZWwoKQogICAgLS0g6L+U5Zue6LSf5YC86KGo56S66ZmN5L2O5oqk55SyCiAgICByZXR1cm4gLTIwICogbGV2ZWwKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9hbmNob3JfYnVmZjpHZXRFZmZlY3RBdHRhY2hUeXBlKCkKICAgIHJldHVybiBQQVRUQUNIX09WRVJIRUFEX0ZPTExPVwplbmQKCi0tIOeKtuaAgeWbvuaghwpmdW5jdGlvbiBtb2RpZmllcl9hbmNob3JfYnVmZjpHZXRUZXh0dXJlKCkKICAgIHJldHVybiAidGlkZWh1bnRlcl9hbmNob3Jfc21hc2giCmVuZAo=]]
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