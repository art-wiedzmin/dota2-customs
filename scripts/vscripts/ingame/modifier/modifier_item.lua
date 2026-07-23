local encoded=[[LS0g5paH5Lu25ZCN77yabW9kaWZpZXJfaXRlbS5sdWEKbW9kaWZpZXJfaXRlbSA9IGNsYXNzKHt9KQoKLS0g5Z+656GA6YWN572uCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW06SXNIaWRkZW4oKQogICAgcmV0dXJuIGZhbHNlIC0tIOmakOiXj+eKtuaAgeagj+aYvuekuuWbvuaghwplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW06SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbTpJc1B1cmdhYmxlKCkKICAgIHJldHVybiB0cnVlIC0tIOS4jeWPr+iiq+mpseaVowplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW06UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtOkFsbG93SWxsdXNpb25EdXBsaWNhdGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbTpPbkNyZWF0ZWQoa3YpCiAgICBpZiBJc1NlcnZlcigpIHRoZW4KCiAgICBlbmQKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtOkNoZWNrU3RhdGUoKQogICAgbG9jYWwgc3RhdGUgPSB7CiAgICAgICAgW01PRElGSUVSX1NUQVRFX0NBTl9VU0VfQkFDS1BBQ0tfSVRFTVNdID0gdHJ1ZQogICAgfQogICAgcmV0dXJuIHN0YXRlCmVuZAo=]]
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