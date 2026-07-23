local encoded=[[UmFuay5EYXRhID0ge30KLS3mjpLooYzmppzvvIg1djUgPSBkYXRhMe+8jDF2MSA9IGRhdGEy77yJCi0tbGlzdF81djUgLyBsaXN0XzF2MTog5ZCE5qih5byP5o6S6KGM5qac5YiX6KGoIHJhbmsxLi5yYW5rMTAwCi0tZGF0YS5yYW5rIC8gZGF0YS5wb2ludDogNXY1IOaOkuWQjeS4juWIhuaVsO+8m2RhdGEucmFuazIgLyBkYXRhLnBvaW50MjogMXYxIOaOkuWQjeS4juWIhuaVsApSYW5rLlRlbXBsYXRlID0gewogICAgcGFnZSA9IGZhbHNlLAogICAgbGlzdCA9IHt9LAogICAgbGlzdF81djUgPSB7fSwKICAgIGxpc3RfMXYxID0ge30sCiAgICBsaXN0X2JvdF8xdjEgPSB7fSwKICAgIC0tIOW9k+WJjeWJjeerr+inhuWbvuaooeW8j++8miI1djUiIC8gIjF2MSIgLyAiYm90XzF2MSIKICAgIHZpZXdfbW9kZSA9ICIxdjEiLAogICAgLS0gbGl2ZT3lvZPliY3otZvlraMgaGlzdG9yeT3ljoblj7LotZvlraMKICAgIHJhbmtfdmlldyA9ICJsaXZlIiwKICAgIGhpc3Rvcnlfc2Vhc29uID0gIiIsCiAgICBzZWFzb25zID0ge30sCiAgICBjdXJyZW50X3NlYXNvbl9sYWJlbCA9ICJTMCIsCiAgICBkYXRhID0gewogICAgICAgIHBpZCA9IC0xLAogICAgICAgIHNpZCA9IC0xLAogICAgICAgIHJhbmsgPSAtMSwKICAgICAgICBwb2ludCA9IC0xLAogICAgICAgIHJhbmsyID0gLTEsCiAgICAgICAgcG9pbnQyID0gLTEsCiAgICAgICAgLS0tIOS6uuacuiAxdjEg56ue6YCf5qac77yIZGF0YTPvvInvvJrkuIrmppzml7blkI3mrKHkuI7mppzkuIrnmoTnlKjml7bvvIjnp5LvvIkKICAgICAgICByYW5rX2JvdCA9IC0xLAogICAgICAgIHBvaW50X2JvdCA9IC0xLAogICAgfQp9ClJhbmsuUHVibGljID0gewogICAgc2VydmVyID0gZmFsc2UsCiAgICBzZWFzb25zX2xvYWRlZCA9IGZhbHNlLAogICAgbGl2ZV9kYXRhMSA9IG5pbCwKICAgIGxpdmVfZGF0YTIgPSBuaWwsCiAgICBsaXZlX2RhdGEzID0gbmlsLAogICAgZGF0YSA9IHt9Cn0K]]
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