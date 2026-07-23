--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gRGV2VG9vbHM6UmVnaXN0ZXJDaGF0KCkKICAgIGlmIHNlbGYuX2NoYXRfcmVnaXN0ZXJlZCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIExpc3RlblRvR2FtZUV2ZW50KCJwbGF5ZXJfY2hhdCIsIER5bmFtaWNfV3JhcChzZWxmLCAiT25QbGF5ZXJDaGF0IiksIHNlbGYpCiAgICBzZWxmLl9jaGF0X3JlZ2lzdGVyZWQgPSB0cnVlCmVuZAoKZnVuY3Rpb24gRGV2VG9vbHM6UGFyc2VDaGF0S2V5cyhrZXlzKQogICAgbG9jYWwgSUQgPSBrZXlzLnBsYXllcmlkCiAgICBsb2NhbCBoZXJvID0gVXRpbDpJRDJIZXJvKElEKQogICAgaWYgbm90IGhlcm8gb3IgaGVybzpJc051bGwoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIHRleHQgPSBzdHJpbmcubG93ZXIoa2V5cy50ZXh0IG9yICIiKQogICAgcmV0dXJuIFV0aWw6U3BsaXQodGV4dCwgIiAiKQplbmQKCmZ1bmN0aW9uIERldlRvb2xzOk9uUGxheWVyQ2hhdChrZXlzKQogICAgbG9jYWwgSUQgPSBrZXlzLnBsYXllcmlkCiAgICBsb2NhbCB0YWIgPSBzZWxmOlBhcnNlQ2hhdEtleXMoa2V5cykKICAgIGlmIG5vdCB0YWIgb3Igbm90IHRhYlsxXSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIGNtZCA9IHRhYlsxXQoKICAgIGlmIGtleXMudGVhbW9ubHkgPT0gMCB0aGVuCiAgICAgICAgaWYgY21kID09ICLmiJHmmK/okIzmlrAiIG9yIGNtZCA9PSAi5oiR5piv6I+c6bifIiB0aGVuCiAgICAgICAgICAgIHNlbGY6UnVuQ29tbWFuZChJRCwgY21kKQogICAgICAgICAgICByZXR1cm4KICAgICAgICBlbmQKICAgIGVuZAoKICAgIGlmIGNtZCA9PSAiLXpzIiB0aGVuCiAgICAgICAgc2VsZjpSdW5Db21tYW5kKElELCBjbWQpCiAgICAgICAgcmV0dXJuCiAgICBlbmQKCiAgICBpZiBub3Qgc2VsZjpJc0VuYWJsZWQoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKCiAgICBzZWxmOlJ1bkNvbW1hbmQoSUQsIGNtZCkKZW5kCg==]]
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