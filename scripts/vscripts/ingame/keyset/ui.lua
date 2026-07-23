--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[ZnVuY3Rpb24gS2V5U2V0OkdldFVJRGF0YShJRCwgZGF0YSkKICAgIGlmIG5vdCBJRCBvciBub3QgZGF0YSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIC0t5pqC5YGc56aB5q2i5Lyg5pWw5o2uCiAgICBpZiBHYW1lUnVsZXM6SXNHYW1lUGF1c2VkKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICAtLeWIneWni+WMluaVsOaNrgogICAgaWYgZGF0YS50cCA9PSAiaW5pdCIgdGhlbgogICAgICAgIHNlbGY6U2VuZERhdGEoSUQpCiAgICAgICAgS2V5U2V0OlNlbmRQdWJsaWNEYXRhKCkKICAgIGVuZAogICAgaWYgZGF0YS50cCA9PSAiT3BlblBhZ2UiIHRoZW4KICAgICAgICBzZWxmOk9wZW5QYWdlKElEKQogICAgZW5kCiAgICBpZiBkYXRhLnRwID09ICJDbG9zZVBhZ2UiIHRoZW4KICAgICAgICBzZWxmOkNsb3NlUGFnZShJRCkKICAgIGVuZAogICAgLS3kv53lrZjvvIhsaXN05pS56ZSu77ybcGV0IOihqOS4jiBJdGVtLlJiIOmhueWQjeWvueW6lO+8jOW4g+WwlOS4uuaYr+WQpueCueS6ru+8iQogICAgaWYgZGF0YS50cCA9PSAiU2F2ZUtleUJpbmQiIHRoZW4KICAgICAgICBzZWxmOlNhdmVLZXlCaW5kKElELCBkYXRhLmxpc3Qgb3IgZGF0YS50ZXh0LCBkYXRhKQogICAgZW5kCiAgICAtLSDliY3nq6/oh6rlrprkuYnng63plK7mjInkuIvvvIhTa2lsbFNsb3QgQ3JlYXRlQ3VzdG9tS2V5QmluZO+8iQogICAgaWYgZGF0YS50cCA9PSAiUGxheWVyS2V5RG93biIgdGhlbgogICAgICAgIHNlbGY6T25QbGF5ZXJLZXlEb3duKElELCBkYXRhKQogICAgZW5kCmVuZAoKLS3nu5nliY3nq6/lj5HmlbDmja4KZnVuY3Rpb24gS2V5U2V0OlNlbmREYXRhKElEKQogICAgaWYgbm90IElEIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgbG9jYWwgZGF0YSA9IHNlbGYuRGF0YVtJRF0KICAgIGlmIG5vdCBkYXRhIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgc2VsZjpFbnN1cmVLZXliaW5kRGVmYXVsdHMoSUQpCiAgICBzZWxmOkVuc3VyZVBldEtleXMoSUQpCiAgICBzZWxmOlN5bmNBY3RpdmVQZXRUb1JvdyhJRCkKICAgIGxvY2FsIHBheWxvYWQgPSBVdGlsOkRlZXBDb3B5VGFiKGRhdGEpCiAgICBwYXlsb2FkLnBldF9yYl9vcmRlciA9IFV0aWw6RGVlcENvcHlUYWIoSXRlbS5SYiBvciB7fSkKICAgIFV0aWw6U2VuZDJKc0lEKCJVSV9LZXlTZXQiLCBwYXlsb2FkLCBJRCkKZW5kCg==]]
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