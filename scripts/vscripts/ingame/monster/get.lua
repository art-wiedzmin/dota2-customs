local encoded=[[ZnVuY3Rpb24gTW9uc3RlcjpNb25zdGVyUG9zKCkKICAgIGxvY2FsIG1heF9jb3VudCA9IHNlbGYuRGF0YS5wb3NfbnVtCiAgICBpZiBtYXhfY291bnQgPD0gMCB0aGVuCiAgICAgICAgbG9jYWwgY2VudGVyID0gc2VsZi5TdGF0aWMubWFwX2NlbnRlcgogICAgICAgIHJldHVybiB1dGlsZXg6UmFuZG9tUG9zKGNlbnRlciwgMCwgMzAwKSBvciBjZW50ZXIKICAgIGVuZAogICAgaWYgc2VsZi5EYXRhLnBvc19pbmRleCA+IG1heF9jb3VudCB0aGVuIHNlbGYuRGF0YS5wb3NfaW5kZXggPSAxIGVuZAogICAgbG9jYWwgaW5kZXggPSBzZWxmLkRhdGEucG9zX2luZGV4CiAgICBzZWxmLkRhdGEucG9zX2luZGV4ID0gc2VsZi5EYXRhLnBvc19pbmRleCArIDEKICAgIGxvY2FsIHBvc19rZXkgPSAicG9zIiAuLiBpbmRleAogICAgbG9jYWwgcG9zID0gc2VsZi5Qb3NbcG9zX2tleV0KICAgIGlmIG5vdCBwb3MgdGhlbgogICAgICAgIGxvY2FsIGNlbnRlciA9IHNlbGYuU3RhdGljLm1hcF9jZW50ZXIKICAgICAgICByZXR1cm4gdXRpbGV4OlJhbmRvbVBvcyhjZW50ZXIsIDAsIDMwMCkgb3IgY2VudGVyCiAgICBlbmQKICAgIGxvY2FsIG1heF9sZW4gPSAxMDAwCiAgICBpZiBNYWluR2FtZTpHZXRTdGF0ZSgpID09IDIgdGhlbiBtYXhfbGVuID0gMzAwIGVuZAogICAgaWYgTWFpbkdhbWU6R2V0U3RhdGUoKSA9PSAzIHRoZW4gbWF4X2xlbiA9IDIwMCBlbmQKICAgIGxvY2FsIHZlID0gdXRpbGV4OlJhbmRvbVBvcyhwb3MsIDUwLCBtYXhfbGVuKQogICAgcmV0dXJuIHZlIG9yIHBvcwplbmQKCi0tIOaYr+WQpuaYr+eyvuiLsQpmdW5jdGlvbiBNb25zdGVyOklzTGVhZGVyKG5hbWUpCiAgICBpZiBub3QgbmFtZSB0aGVuIHJldHVybiBlbmQKICAgIGZvciBrLCB2IGluIHBhaXJzKHNlbGYubGVhZGVyKSBkbyBpZiBuYW1lID09IGsgdGhlbiByZXR1cm4gdHJ1ZSBlbmQgZW5kCmVuZAoKLS0g5o6g5aS677yIYWJpbGl0eV9pdGVtXzI477yJ5LiN5Y+v5YG35Y+W6YeR5biB55qE5Y2V5L2N77ya6Iux6ZuE44CB5LiJ546L44CB6Zu355S15L+h5b6S562JCmZ1bmN0aW9uIE1vbnN0ZXI6SXNQbHVuZGVyRXhjbHVkZWQobmFtZSkKICAgIGlmIG5vdCBuYW1lIHRoZW4gcmV0dXJuIGVuZAogICAgaWYgc2VsZjpJc0xlYWRlcihuYW1lKSB0aGVuIHJldHVybiB0cnVlIGVuZAogICAgaWYgTW9uc3Rlci5MaWdodG5pbmdCZWxpZXZlciBhbmQgbmFtZSA9PSBNb25zdGVyLkxpZ2h0bmluZ0JlbGlldmVyLnVuaXRfbmFtZSB0aGVuCiAgICAgICAgcmV0dXJuIHRydWUKICAgIGVuZAplbmQKCmZ1bmN0aW9uIE1vbnN0ZXI6R2V0TW9uc3RlckxpbWl0KCkKICAgIGxvY2FsIHN0ID0gTWFpbkdhbWU6R2V0U3RhdGUoKQogICAgaWYgc3QgPT0gMSB0aGVuIHJldHVybiAyMzAgZW5kCiAgICBpZiBzdCA9PSAyIHRoZW4gcmV0dXJuIDE2MCBlbmQKICAgIGlmIHN0ID09IDMgdGhlbiByZXR1cm4gMzAgZW5kCiAgICByZXR1cm4gc3QKZW5kCg==]]
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