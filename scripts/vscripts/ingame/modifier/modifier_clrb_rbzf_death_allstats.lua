--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g6IKJ5pCP56Wd56aP77ya5q+P5qyh5q275Lqh6KGl5YG/55qE6aKd5aSW5YWo5bGe5oCn77yI57u/5a2X77yJ77yM55So5bGC5pWw57Sv6K6hIFNUUi9BR0kvSU5UIOWQhCArc3RhY2sKbW9kaWZpZXJfY2xyYl9yYnpmX2RlYXRoX2FsbHN0YXRzID0gY2xhc3Moe30pCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3JiemZfZGVhdGhfYWxsc3RhdHM6SXNIaWRkZW4oKQogICAgcmV0dXJuIHRydWUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3JiemZfZGVhdGhfYWxsc3RhdHM6SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9yYnpmX2RlYXRoX2FsbHN0YXRzOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9yYnpmX2RlYXRoX2FsbHN0YXRzOlJlbW92ZU9uRGVhdGgoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9yYnpmX2RlYXRoX2FsbHN0YXRzOkFsbG93SWxsdXNpb25EdXBsaWNhdGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9yYnpmX2RlYXRoX2FsbHN0YXRzOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9TVEFUU19TVFJFTkdUSF9CT05VUywKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9TVEFUU19BR0lMSVRZX0JPTlVTLAogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX1NUQVRTX0lOVEVMTEVDVF9CT05VUywKICAgIH0KZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3JiemZfZGVhdGhfYWxsc3RhdHM6R2V0TW9kaWZpZXJCb251c1N0YXRzX1N0cmVuZ3RoKCkKICAgIHJldHVybiBzZWxmOkdldFN0YWNrQ291bnQoKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfcmJ6Zl9kZWF0aF9hbGxzdGF0czpHZXRNb2RpZmllckJvbnVzU3RhdHNfQWdpbGl0eSgpCiAgICByZXR1cm4gc2VsZjpHZXRTdGFja0NvdW50KCkKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3JiemZfZGVhdGhfYWxsc3RhdHM6R2V0TW9kaWZpZXJCb251c1N0YXRzX0ludGVsbGVjdCgpCiAgICByZXR1cm4gc2VsZjpHZXRTdGFja0NvdW50KCkKZW5kCg==]]
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