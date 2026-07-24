local encoded=[[S2V5U2V0LkRhdGEgPSB7fQpLZXlTZXQuVGVtcGxhdGUgPSB7CiAgICAtLeiHquWumuS5ieaMiemUrgogICAga2V5YmluZCA9IHsKICAgICAgICBzY29yZWJvYXJkID0gIlRhYiIsCiAgICAgICAgZWF6eXNob3AgPSAiIiwKICAgIH0sCiAgICBwZXQgPSB7fSwKICAgIC0tLSDkuInlpZfmi77lj5bpooTorr7vvJvlsYDlhoXmi77lj5bkvb/nlKggcGV0X3ByZXNldF9hY3RpdmUg5a+55bqU55qE6YKj5LiA5aWX77yI5LiOIHJvdy5wZXQg5ZCM5q2l77yJCiAgICBwZXRfcHJlc2V0cyA9IHsgWzFdID0ge30sIFsyXSA9IHt9LCBbM10gPSB7fSB9LAogICAgcGV0X3ByZXNldF9hY3RpdmUgPSAxLAp9Cg==]]
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