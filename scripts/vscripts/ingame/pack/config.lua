local encoded=[[UGFjay5UZWFtMiA9IHt9ClBhY2suVGVhbTMgPSB7fQpQYWNrLlNsb3RUZW1wbGF0ZSA9IHsKICAgIHNsb3QgPSAtMSwKICAgIHN0YXRlID0gZmFsc2UsCiAgICBpdGVtID0gIiIsCiAgICBudW0gPSAtMSwKfQpQYWNrLlN0YXRpYyA9IHsKICAgIHNsb3RfbWF4ID0gMjAsCiAgICBwb3MgPSB7CiAgICAgICAgcG9zMSA9IHsKICAgICAgICAgICAgbmFtZSA9ICJQYWNrIiwKICAgICAgICAgICAgdmUgPSBWZWN0b3IoLTQ4NzYuNDg1MzUyLCAzMDQyLjgwOTMyNiwgMTI4LjAwMDAwMCksCiAgICAgICAgICAgIHR1cm4gPSA5MCwKICAgICAgICAgICAgdGVhbSA9ICJnb29kIgogICAgICAgIH0sCiAgICAgICAgcG9zMiA9IHsKICAgICAgICAgICAgbmFtZSA9ICJQYWNrIiwKICAgICAgICAgICAgdmUgPSBWZWN0b3IoNDM2Mi45NzUwOTgsIC03MzQ1LjkyNjc1OCwgMTI4LjAwMDAwMCksCiAgICAgICAgICAgIHR1cm4gPSAwLAogICAgICAgICAgICB0ZWFtID0gImdvb2QiCiAgICAgICAgfSwKICAgICAgICBwb3MzID0gewogICAgICAgICAgICBuYW1lID0gIkJhZFBhY2siLAogICAgICAgICAgICB2ZSA9IFZlY3RvcigtNDc2Ni4xNDU1MDgsIC02MDQxLjg0NzE2OCwgMTI4LjAwMDAwMCksCiAgICAgICAgICAgIHR1cm4gPSAxODAsCiAgICAgICAgICAgIHRlYW0gPSAiYmFkIgogICAgICAgIH0sCiAgICAgICAgcG9zNCA9IHsKICAgICAgICAgICAgbmFtZSA9ICJCYWRQYWNrIiwKICAgICAgICAgICAgdmUgPSBWZWN0b3IoNDQ1OC4xMTc2NzYsIDY5NjcuOTc5OTgwLCAxMjguMDAwMDAwKSwKICAgICAgICAgICAgdHVybiA9IC05MCwKICAgICAgICAgICAgdGVhbSA9ICJiYWQiCiAgICAgICAgfSwKICAgIH0KfQpQYWNrLkRhdGEgPSB7fQpQYWNrLlRlbXBsYXRlID0gewogICAgcGFja190cCA9ICIiLAogICAgcGFjayA9IHt9LAogICAgcGFnZSA9IGZhbHNlLAp9Cg==]]
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