local encoded=[[aWYgUG9pbnQgPT0gbmlsIHRoZW4KICAgIFBvaW50ID0gY2xhc3Moe30pCiAgICByZXF1aXJlKCJpbmdhbWUuUG9pbnQuQ29uZmlnIikKICAgIHJlcXVpcmUoImluZ2FtZS5Qb2ludC5TZXQiKQogICAgcmVxdWlyZSgiaW5nYW1lLlBvaW50LkdldCIpCiAgICByZXF1aXJlKCJpbmdhbWUuUG9pbnQuVWkiKQplbmQKCmZ1bmN0aW9uIFBvaW50OkluaXQoSUQpCiAgICBpZiBub3QgSUQgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBzZWxmLkRhdGFbSURdID0gVXRpbDpEZWVwQ29weVRhYihzZWxmLlRlbXBsYXRlKQplbmQK]]
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