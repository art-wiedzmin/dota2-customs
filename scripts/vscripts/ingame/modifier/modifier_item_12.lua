local encoded=[[bW9kaWZpZXJfaXRlbV8xMiA9IGNsYXNzKHt9KQoKLS0g5YWz6ZSu5L+u5pS577ya5b+F6aG76K6+5Li6IGZhbHNl77yM6K6pTW9kaWZpZXLlnKjnirbmgIHmoI/lj6/op4EKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMjpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UgLS0g5LuOIHRydWUg5pS55Li6IGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMjpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzEyOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlIC0tIOS4jeWPr+iiq+mpseaVowplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMTI6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzEyOkFsbG93SWxsdXNpb25EdXBsaWNhdGUoKQogICAgcmV0dXJuIHRydWUKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzEyOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgc2VsZjpHZXRQYXJlbnQoKTpDYWxjdWxhdGVTdGF0Qm9udXModHJ1ZSkKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9pdGVtXzEyOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9IRUFMVEhfQk9OVVMsCiAgICB9CmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMjpHZXRNb2RpZmllckhlYWx0aEJvbnVzKCkKICAgIHJldHVybiAyMDAwCmVuZAoKLS0g44CQ5paw5aKe44CR5o+Q5L6b5LiA5Liq5Zu+5qCH77yM5L2/5YW25Zyo54q25oCB5qCP5Y+v6KeBCmZ1bmN0aW9uIG1vZGlmaWVyX2l0ZW1fMTI6R2V0VGV4dHVyZSgpCiAgICByZXR1cm4gIml0ZW1fYWVvbl9kaXNrIiAtLSDkvb/nlKjmsLjmgZLkuYvnm5jnmoTlm77moIfvvIzku6PooajnirbmgIHmipfmgKcKICAgIC0tIOaIluiAheS9v+eUqOS9oOeJqeWTgeeahOiHquWumuS5ieWbvuagh+WQje+8jOWmgiBgaXRlbV8xMmAKZW5kCgotLSDjgJDlj6/pgInjgJHmt7vliqDlt6Xlhbfmj5DnpLrvvIzpvKDmoIfmgqzlgZzml7blj6/nnIvliLDlhbfkvZPmlbDlgLwKZnVuY3Rpb24gbW9kaWZpZXJfaXRlbV8xMjpHZXRUb29sdGlwKCkKICAgIHJldHVybiAi54q25oCB5oqX5oCn77yaKzIwJVxu55Sf5ZG95YC877yaKzIwMDAiCmVuZAo=]]
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