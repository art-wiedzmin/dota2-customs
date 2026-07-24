local encoded=[[ZnVuY3Rpb24gSGVyb0NhcmQ6R2V0VUlEYXRhKElELCBkYXRhKQogICAgaWYgbm90IElEIG9yIG5vdCBkYXRhIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgR2FtZVJ1bGVzOklzR2FtZVBhdXNlZCgpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgZGF0YS50cCA9PSAiaW5pdCIgdGhlbgogICAgICAgIHNlbGY6U2VuZERhdGEoSUQpCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGlmIGRhdGEudHAgPT0gIk9wZW5QYWdlIiB0aGVuCiAgICAgICAgc2VsZjpPcGVuUGFnZShJRCkKICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgZGF0YS50cCA9PSAiQ2xvc2VQYWdlIiB0aGVuCiAgICAgICAgc2VsZjpDbG9zZVBhZ2UoSUQpCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIC0tIFN0YXQg6aG26YOo5qCP77yadHAgcGVlcu+8m+WFtuWug+eVjOmdouWPr+WPkSB0cCBIZXJvSW5mb++8jOWtl+auteebuOWQjO+8iHNpZGUrZ2lkIOaIliByb3fvvIkKICAgIGlmIGRhdGEudHAgPT0gInBlZXIiIG9yIGRhdGEudHAgPT0gIkhlcm9JbmZvIiB0aGVuCiAgICAgICAgc2VsZjpIZXJvSW5mbyhJRCwgZGF0YSkKICAgICAgICByZXR1cm4KICAgIGVuZAplbmQKCmZ1bmN0aW9uIEhlcm9DYXJkOlNlbmREYXRhKElEKQogICAgaWYgbm90IElEIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgc2VsZjpFbnN1cmVQbGF5ZXJEYXRhKElEKQogICAgVXRpbDpTZW5kMkpzSUQoIlVJX0hlcm9DYXJkIiwgc2VsZi5EYXRhW0lEXSwgSUQpCmVuZAo=]]
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