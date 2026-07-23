local encoded=[[LS0g5a+55bGA57uT566X5omp5bGV57uf6K6h77yI5Lq657G7546p5a6277yJ77ya6Iux6ZuEL+iDnOi0n+aIluWQjeasoS/mioDog70v6KOF5aSHL+aWree6vwpPdmVyU3RhdC5EYXRhID0ge30KT3ZlclN0YXQuVGVtcGxhdGUgPSB7fQpPdmVyU3RhdC5EaXNjb25uZWN0cyA9IHt9Ci0tIOWNleWxgOavj+S7tuijheWkh+iOt+W+l+iusOW9leS4iumZkO+8iOmYsiBQT1NUIOi/h+Wkp++8iQpPdmVyU3RhdC5NQVhfSVRFTV9HQUlOX0VWRU5UUyA9IDQwMAo=]]
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