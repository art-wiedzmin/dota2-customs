--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gRGV2VG9vbHM6SXNFbmFibGVkKCkKICAgIHJldHVybiBJc0luVG9vbHNNb2RlKCkgPT0gdHJ1ZQplbmQKCmZ1bmN0aW9uIERldlRvb2xzOkdldE1hbmlmZXN0KCkKICAgIHNlbGY6SW5pdFJlZ2lzdHJ5KCkKICAgIGxvY2FsIGxpc3QgPSB7fQogICAgZm9yIF8sIGVudHJ5IGluIHBhaXJzKHNlbGYuUmVnaXN0cnkpIGRvCiAgICAgICAgaWYgZW50cnkuc2hvd19pbl9wYW5lbCB0aGVuCiAgICAgICAgICAgIGxpc3RbI2xpc3QgKyAxXSA9IHsKICAgICAgICAgICAgICAgIGNtZCA9IGVudHJ5LmNtZCwKICAgICAgICAgICAgICAgIGxhYmVsID0gZW50cnkubGFiZWwsCiAgICAgICAgICAgICAgICBncm91cCA9IGVudHJ5Lmdyb3VwLAogICAgICAgICAgICB9CiAgICAgICAgZW5kCiAgICBlbmQKICAgIHRhYmxlLnNvcnQobGlzdCwgZnVuY3Rpb24oYSwgYikKICAgICAgICBpZiBhLmdyb3VwIH49IGIuZ3JvdXAgdGhlbgogICAgICAgICAgICByZXR1cm4gdG9zdHJpbmcoYS5ncm91cCkgPCB0b3N0cmluZyhiLmdyb3VwKQogICAgICAgIGVuZAogICAgICAgIHJldHVybiB0b3N0cmluZyhhLmxhYmVsKSA8IHRvc3RyaW5nKGIubGFiZWwpCiAgICBlbmQpCiAgICByZXR1cm4gbGlzdAplbmQK]]
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