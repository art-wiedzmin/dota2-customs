--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gU3RhdDpPcGVuVG9wUGFnZSgpCiAgICBzZWxmLlB1YmxpYy5wYWdlID0gdHJ1ZQogICAgc2VsZjpTZW5kUHVibGljRGF0YSh0cnVlKQplbmQKCmZ1bmN0aW9uIFN0YXQ6Q2xvc2VUb3BQYWdlKCkKICAgIHNlbGYuUHVibGljLnBhZ2UgPSBmYWxzZQogICAgc2VsZjpTZW5kUHVibGljRGF0YSh0cnVlKQplbmQKCi0tIOWQjOS4gOeOqeWutuWPjeWkjeaJk+W8gOiuoeWIhuadv++8muefreiKgua1geWGheWPqumHjeeul+S4gOasoe+8jOaJk+W8gOaXtuW8uuWItuWFqOmHj+amnO+8iOS4jeeUqCBMaXRl77yJCmxvY2FsIFNDT1JFQk9BUkRfUkVGUkVTSF9JTlRFUlZBTCA9IDAuMzUKCmZ1bmN0aW9uIFN0YXQ6T3BlblBhZ2UoSUQpCiAgICBpZiBub3QgSUQgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBzZWxmLkRhdGFbSURdLnBhZ2UgPSB0cnVlCiAgICBzZWxmLl9zY29yZWJvYXJkUmFua1JlZnJlc2hBdCA9IHNlbGYuX3Njb3JlYm9hcmRSYW5rUmVmcmVzaEF0IG9yIHt9CiAgICBsb2NhbCBub3cgPSBHYW1lUnVsZXM6R2V0R2FtZVRpbWUoKQogICAgbG9jYWwgcHJldiA9IHNlbGYuX3Njb3JlYm9hcmRSYW5rUmVmcmVzaEF0W0lEXQogICAgaWYgcHJldiA9PSBuaWwgb3IgKG5vdyAtIHByZXYpID49IFNDT1JFQk9BUkRfUkVGUkVTSF9JTlRFUlZBTCB0aGVuCiAgICAgICAgc2VsZi5fc2NvcmVib2FyZFJhbmtSZWZyZXNoQXRbSURdID0gbm93CiAgICAgICAgc2VsZi5SYW5rTGlzdC51cGRhdGEgPSB0cnVlCiAgICAgICAgc2VsZi5fcmFua1VwZGF0ZVBlbmRpbmcgPSBmYWxzZQogICAgICAgIHNlbGYuX3JhbmtVcGRhdGVMaXRlID0gZmFsc2UKICAgICAgICBzZWxmOl9SdW5SYW5rVXBkYXRlKGZhbHNlKQogICAgICAgIHNlbGY6VXBEYXRhTGlzdChJRCkKICAgIGVuZAogICAgc2VsZjpTZW5kRGF0YShJRCkKZW5kCgpmdW5jdGlvbiBTdGF0OkNsb3NlUGFnZShJRCkKICAgIHNlbGYuRGF0YVtJRF0ucGFnZSA9IGZhbHNlCiAgICBzZWxmOlNlbmREYXRhKElEKQplbmQKCmZ1bmN0aW9uIFN0YXQ6Q2hhbmdlUGFnZShJRCkKICAgIGlmIG5vdCBJRCB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGlmIHNlbGYuRGF0YVtJRF0ucGFnZSA9PSB0cnVlIHRoZW4KICAgICAgICBzZWxmOkNsb3NlUGFnZShJRCkKICAgIGVsc2UKICAgICAgICBzZWxmOk9wZW5QYWdlKElEKQogICAgZW5kCmVuZA==]]
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