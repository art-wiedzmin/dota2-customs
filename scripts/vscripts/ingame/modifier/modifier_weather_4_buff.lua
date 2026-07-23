local encoded=[[bW9kaWZpZXJfd2VhdGhlcl80X2J1ZmYgPSBjbGFzcyh7fSkKCi0tIOaYr+WQpuWcqOmdouadv+S4iuaYvuekugpmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzRfYnVmZjpJc0hpZGRlbigpIHJldHVybiB0cnVlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80X2J1ZmY6SXNEZWJ1ZmYoKSByZXR1cm4gdHJ1ZSBlbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfNF9idWZmOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIHRydWUgLS0g5LiN5Y+v6KKr6amx5pWjCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80X2J1ZmY6UmVtb3ZlT25EZWF0aCgpIHJldHVybiB0cnVlIGVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80X2J1ZmY6R2V0VGV4dHVyZSgpIHJldHVybiAic2Nyb2xsL3dlYXRoZXJfc25vd19wbmciIGVuZAoKLS0g5Yib5bu65pe26K6+572uCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfNF9idWZmOk9uQ3JlYXRlZChrdikKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4gcmV0dXJuIGVuZAogICAgc2VsZjpTZXREdXJhdGlvbihrdi5kdXIsIHRydWUpCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80X2J1ZmY6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIC0tIE1PRElGSUVSX1BST1BFUlRZX0hFQUxUSF9SRUdFTl9QRVJDRU5UQUdFX1VOSVFVRSwKICAgICAgICBNT0RJRklFUl9QUk9QRVJUWV9BVFRBQ0tTUEVFRF9CT05VU19DT05TVEFOVCwgLS0g5pS75Ye76YCf5bqmCiAgICAgICAgTU9ESUZJRVJfUFJPUEVSVFlfTU9WRVNQRUVEX0JPTlVTX1BFUkNFTlRBR0UgLS0g56e75Yqo6YCf5bqm5Yqg5oiQCiAgICB9CmVuZAoKLS0g6I635Y+W5pS75Ye76YCf5bqm5bi45pWw5aKe55uKCmZ1bmN0aW9uIG1vZGlmaWVyX3dlYXRoZXJfNF9idWZmOkdldE1vZGlmaWVyQXR0YWNrU3BlZWRCb251c19Db25zdGFudCgpCiAgICByZXR1cm4gLTYwCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfd2VhdGhlcl80X2J1ZmY6R2V0TW9kaWZpZXJNb3ZlU3BlZWRCb251c19QZXJjZW50YWdlKCkKICAgIHJldHVybiAtMjUKZW5kCgotLSDlh4/lsJEgMzAlIOeUn+WRveWbnuWkjQotLSBmdW5jdGlvbiBtb2RpZmllcl93ZWF0aGVyXzRfYnVmZjpHZXRNb2RpZmllckhlYWx0aFJlZ2VuUGVyY2VudGFnZVVuaXF1ZSgpCi0tICAgICByZXR1cm4gLTMwCi0tIGVuZAo=]]
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