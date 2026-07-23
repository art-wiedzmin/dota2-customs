local encoded=[[aWYgQm90QUkgPT0gbmlsIHRoZW4KICAgIEJvdEFJID0gY2xhc3Moe30pCgogICAgLS0g5LiOIGluaXQucHJlY2FjaGUubW9kaWZpZXJfYWxsIOmHjeWkjeazqOWGjOaXoOWus++8m+mBv+WFjeS7hSByYXdnZXQg5aSx6LSl5pe26Z2Z6buY6Lez6L+H5a+86Ie0IHVua25vd24gbW9kaWZpZXIKICAgIExpbmtMdWFNb2RpZmllcigibW9kaWZpZXJfYm90X2lubmF0ZV9tYW5hX3JlZ2VuIiwgImluZ2FtZS9tb2RpZmllci9tb2RpZmllcl9ib3RfaW5uYXRlX21hbmFfcmVnZW4iLAogICAgICAgIExVQV9NT0RJRklFUl9NT1RJT05fTk9ORSkKICAgIExpbmtMdWFNb2RpZmllcigibW9kaWZpZXJfYm90X2lubmF0ZV9sZXZlbF9iYXNlX2F0dGFjayIsCiAgICAgICAgImluZ2FtZS9tb2RpZmllci9tb2RpZmllcl9ib3RfaW5uYXRlX2xldmVsX2Jhc2VfYXR0YWNrIiwgTFVBX01PRElGSUVSX01PVElPTl9OT05FKQoKICAgIEJvdEFJLkRhdGEgPSBCb3RBSS5EYXRhIG9yIHt9CgogICAgcmVxdWlyZSgiaW5nYW1lLkJvdEFJLkNvbmZpZyIpCiAgICByZXF1aXJlKCJpbmdhbWUuQm90QUkuRnVuYyIpCmVuZAo=]]
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