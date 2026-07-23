--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfdGFsZW50XzFfYnVmZiA9IGNsYXNzKHt9KQoKLS3mmK/lkKblnKjpnaLmnb/kuIrmmL7npLoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50XzFfYnVmZjpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl90YWxlbnRfMV9idWZmOklzRGVidWZmKCkKICAgIHJldHVybiB0cnVlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50XzFfYnVmZjpJc1B1cmdhYmxlKCkKICAgIHJldHVybiB0cnVlIC0tIOS4jeWPr+iiq+mpseaVowplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF8xX2J1ZmY6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF8xX2J1ZmY6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gInNjcm9sbC9tb2RpZmllcl90YWxlbnRfMV9idWZmIgplbmQKCi0t5Yib5bu65pe26K6+572uCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF8xX2J1ZmY6T25DcmVhdGVkKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBzZWxmOlNldER1cmF0aW9uKGt2LmR1ciwgdHJ1ZSkKICAgIC0tIOWIneWni+WMluWPmOmHjwogICAgc2VsZi5qY2hqID0ga3YuaGoKICAgIC0tIOS9v+eUqOagiOiuoeaVsOWQjOatpeaVsOaNruWIsOWuouaIt+errwogICAgLS0g5bCG56e75Yqo6YCf5bqm5YC85LmY5LulMTAw5Lul5L+d55WZ5bCP5pWw57K+5bqm77yM5a2Y5YKo5Zyo5qCI6K6h5pWw5LitCiAgICBzZWxmOlNldFN0YWNrQ291bnQoc2VsZi5qY2hqICogMTAwKQogICAgc2VsZjpGb3JjZVJlZnJlc2goKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3RhbGVudF8xX2J1ZmY6T25SZWZyZXNoKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBpZiBrdi5oaiB0aGVuCiAgICAgICAgc2VsZi5qY2hqID0ga3YuaGoKICAgICAgICAtLSDmm7TmlrDmoIjorqHmlbAKICAgICAgICBzZWxmOlNldFN0YWNrQ291bnQoc2VsZi5qY2hqICogMTAwKQogICAgZW5kCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50XzFfYnVmZjpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIHJldHVybiB7CiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfUEhZU0lDQUxfQVJNT1JfQk9OVVMsIC0t5oqk55SyCiAgICB9CmVuZAoKLS3miqTnlLLpmY3kvY4KZnVuY3Rpb24gbW9kaWZpZXJfdGFsZW50XzFfYnVmZjpHZXRNb2RpZmllclBoeXNpY2FsQXJtb3JCb251cygpCiAgICBsb2NhbCBzdGFja19jb3VudCA9IHNlbGY6R2V0U3RhY2tDb3VudCgpCiAgICBsb2NhbCBoal9ib251cyA9IHN0YWNrX2NvdW50IC8gMTAwCiAgICByZXR1cm4gaGpfYm9udXMKZW5kCg==]]
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