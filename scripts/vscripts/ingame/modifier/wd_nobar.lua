local encoded=[[aWYgd2Rfbm9iYXIgPT0gbmlsIHRoZW4KICAgIHdkX25vYmFyID0gY2xhc3Moe30pCmVuZApmdW5jdGlvbiB3ZF9ub2JhcjpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiB3ZF9ub2JhcjpJc0hpZGRlbigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiB3ZF9ub2JhcjpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiB0cnVlCmVuZAoKZnVuY3Rpb24gd2Rfbm9iYXI6T25DcmVhdGVkKGt2KQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbiByZXR1cm4gZW5kCmVuZAoKZnVuY3Rpb24gd2Rfbm9iYXI6T25JbnRlcnZhbFRoaW5rKCkKICAgIGlmIG5vdCBJc1NlcnZlcigpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAplbmQKCmZ1bmN0aW9uIHdkX25vYmFyOk9uRGVzdHJveSgpCmVuZAoKZnVuY3Rpb24gd2Rfbm9iYXI6Q2hlY2tTdGF0ZSgpCiAgICBsb2NhbCBzdGF0ZSA9IHsKICAgICAgICBbTU9ESUZJRVJfU1RBVEVfSU5WVUxORVJBQkxFXSA9IHRydWUsCiAgICAgICAgW01PRElGSUVSX1NUQVRFX05PX0hFQUxUSF9CQVJdID0gdHJ1ZSwKICAgICAgICBbTU9ESUZJRVJfU1RBVEVfTk9fVU5JVF9DT0xMSVNJT05dID0gdHJ1ZSwgLS0g5peg6KeG5Y2V5L2N56Kw5pKeCiAgICB9CiAgICByZXR1cm4gc3RhdGUKZW5kCgpmdW5jdGlvbiB3ZF9ub2JhcjpEZWNsYXJlRnVuY3Rpb25zKCkKICAgIGxvY2FsIGZ1bmNzID0gewogICAgICAgIC0tTU9ESUZJRVJfUFJPUEVSVFlfTUlOX0hFQUxUSAogICAgfQogICAgcmV0dXJuIGZ1bmNzCmVuZAoKZnVuY3Rpb24gd2Rfbm9iYXI6R2V0U3RhdHVzRWZmZWN0TmFtZSgpCiAgICByZXR1cm4KZW5kCgo=]]
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