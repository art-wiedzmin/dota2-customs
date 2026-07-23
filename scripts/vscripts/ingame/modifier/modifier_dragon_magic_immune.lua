local encoded=[[bW9kaWZpZXJfZHJhZ29uX21hZ2ljX2ltbXVuZSA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfZHJhZ29uX21hZ2ljX2ltbXVuZTpJc0hpZGRlbigpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2RyYWdvbl9tYWdpY19pbW11bmU6SXNEZWJ1ZmYoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfZHJhZ29uX21hZ2ljX2ltbXVuZTpJc1B1cmdhYmxlKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2RyYWdvbl9tYWdpY19pbW11bmU6UmVtb3ZlT25EZWF0aCgpCiAgICByZXR1cm4gdHJ1ZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2RyYWdvbl9tYWdpY19pbW11bmU6Q2hlY2tTdGF0ZSgpCiAgICByZXR1cm4gewogICAgICAgIFtNT0RJRklFUl9TVEFURV9NQUdJQ19JTU1VTkVdID0gdHJ1ZSwKICAgIH0KZW5kCg==]]
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