--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[bW9kaWZpZXJfZ2pqbCA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfZ2pqbDpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9nampsOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfZ2pqbDpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2dqamw6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9nampsOkFsbG93SWxsdXNpb25EdXBsaWNhdGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfZ2pqbDpHZXRBdHRyaWJ1dGVzKCkKICAgIHJldHVybiBNT0RJRklFUl9BVFRSSUJVVEVfUEVSTUFORU5UICsgTU9ESUZJRVJfQVRUUklCVVRFX0lHTk9SRV9JTlZVTE5FUkFCTEUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9nampsOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgbG9jYWwgdiA9IG1hdGguZmxvb3IodG9udW1iZXIoa3YgYW5kIGt2LmdqamwpIG9yIDApCiAgICBpZiB2IDwgMCB0aGVuIHYgPSAwIGVuZAogICAgc2VsZjpTZXRTdGFja0NvdW50KHYpCiAgICBzZWxmOkZvcmNlUmVmcmVzaCgpCiAgICBsb2NhbCBwYSA9IHNlbGY6R2V0UGFyZW50KCkKICAgIGlmIHBhIHRoZW4gcGE6Q2FsY3VsYXRlU3RhdEJvbnVzKHRydWUpIGVuZAplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2dqamw6T25SZWZyZXNoKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCiAgICBpZiBrdiBhbmQga3YuZ2pqbCB+PSBuaWwgdGhlbgogICAgICAgIGxvY2FsIHYgPSBtYXRoLmZsb29yKHRvbnVtYmVyKGt2LmdqamwpIG9yIDApCiAgICAgICAgaWYgdiA8IDAgdGhlbiB2ID0gMCBlbmQKICAgICAgICBzZWxmOlNldFN0YWNrQ291bnQodikKICAgICAgICBsb2NhbCBwYSA9IHNlbGY6R2V0UGFyZW50KCkKICAgICAgICBpZiBwYSB0aGVuIHBhOkNhbGN1bGF0ZVN0YXRCb251cyh0cnVlKSBlbmQKICAgIGVuZAplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2dqamw6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4geyBNT0RJRklFUl9QUk9QRVJUWV9BVFRBQ0tfUkFOR0VfQk9OVVMgfQplbmQKCi0tIFN0YWNrQ291bnQg5ZCM5q2l5Yiw5a6i5oi356uv77yMSFVEIOaUu+WHu+i3neemu+ato+ehrgpmdW5jdGlvbiBtb2RpZmllcl9nampsOkdldE1vZGlmaWVyQXR0YWNrUmFuZ2VCb251cygpCiAgICByZXR1cm4gc2VsZjpHZXRTdGFja0NvdW50KCkgb3IgMAplbmQK]]
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