--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g5a6d566x6I635b6X6LiP5LqR6Z2077yIaXRlbV9ib3hfOTHvvInml7bljZXni6zmjILovb3vvIzkuI3kvp3otZYgZHVtbXkg5LiK54mp5ZOB5qCP5L2N77yb5Y245LiLL+aRp+avgeivpeeuseS9jeijheWkh+aXtuenu+mZpApyZXF1aXJlKCJpbmdhbWUubW9kaWZpZXIuY2xyYl9mbHlfY2xvdWRfdXRpbCIpCgptb2RpZmllcl9jbHJiX3R5eF90ZXJyYWluID0gY2xhc3Moe30pCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3R5eF90ZXJyYWluOklzSGlkZGVuKCkKICAgIHJldHVybiB0cnVlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl90eXhfdGVycmFpbjpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3R5eF90ZXJyYWluOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl90eXhfdGVycmFpbjpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfdHl4X3RlcnJhaW46Q2hlY2tTdGF0ZSgpCiAgICByZXR1cm4gewogICAgICAgIFtNT0RJRklFUl9TVEFURV9GTFlJTkddID0gdHJ1ZSwKICAgICAgICBbTU9ESUZJRVJfU1RBVEVfRkxZSU5HX0ZPUl9QQVRISU5HX1BVUlBPU0VTX09OTFldID0gdHJ1ZSwKICAgIH0KZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3R5eF90ZXJyYWluOk9uQ3JlYXRlZCgpCiAgICBpZiBJc1NlcnZlcigpIHRoZW4KICAgICAgICBDbHJiRmx5Q2xvdWRTeW5jKHNlbGY6R2V0UGFyZW50KCkpCiAgICBlbmQKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3R5eF90ZXJyYWluOk9uRGVzdHJveSgpCiAgICBpZiBJc1NlcnZlcigpIHRoZW4KICAgICAgICBDbHJiRmx5Q2xvdWRTeW5jKHNlbGY6R2V0UGFyZW50KCkpCiAgICBlbmQKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3R5eF90ZXJyYWluOkRlY2xhcmVGdW5jdGlvbnMoKQogICAgcmV0dXJuIHsgTU9ESUZJRVJfRVZFTlRfT05fUkVTUEFXTiB9CmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl90eXhfdGVycmFpbjpPblJlc3Bhd24oKQogICAgaWYgSXNTZXJ2ZXIoKSB0aGVuCiAgICAgICAgQ2xyYkZseUNsb3VkU2NoZWR1bGVTeW5jKHNlbGY6R2V0UGFyZW50KCkpCiAgICBlbmQKZW5kCg==]]
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