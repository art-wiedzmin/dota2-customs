--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[SW5pdFBsYXllci5QdWJsaWMgPSB7CiAgICAtLeWKoOi9vea4uOaIjwogICAgZ2FtZV9zdGF0ZSA9IGZhbHNlLAogICAgLS3liqDovb3njqnlrrYKICAgIHBsYXllcl9zdGF0ZSA9IGZhbHNlLAogICAgLS3liqDovb3oi7Hpm4QKICAgIGhlcm9fc3RhdGUgPSBmYWxzZSwKICAgIC0t6Iux6ZuE5L2N572uCiAgICBoZXJvX3BvcyA9IHsgMSwgMiwgMSwgNCwgNSwgNiwgNywgOCwgOSwgMTAgfSwKICAgIC0t5omA5pyJ546p5a626KGoCiAgICBwbGF5ZXJzID0ge30sCn0KSW5pdFBsYXllci5QbGF5ZXJUZW1wID0gewogICAgLS3njqnlrrbkvY3nva4KICAgIGluZGV4ID0gLTEsCiAgICAtLeeOqeWutklECiAgICBpZCA9IC0xLAogICAgLS3mmK/lkKblrZjlnKgKICAgIHN0YXRlID0gZmFsc2UsCiAgICAtLeaYr+WQpuWcqOe6vwogICAgb25saW5lID0gZmFsc2UsCiAgICAtLeaYr+WQpuW3sumAieaLqeiLsembhAogICAgaGVyb19zdGF0ZSA9IGZhbHNlLAogICAgLS3oi7Hpm4TmmK/lkKblt7Lnu4/nlJ/miJAKICAgIGhlcm9fc3Bhd25lZCA9IGZhbHNlLAogICAgLS3oi7Hpm4TlkI3np7AKICAgIGhlcm9fbmFtZSA9ICIiLAogICAgLS3lh7rnlJ/ngrkKICAgIGluaXRfcG9zID0gLTEsCiAgICAtLemYn+S8jQogICAgdGVhbSA9IC0xLAogICAgLS3njqnlrrbnvJblj7cKICAgIHRlYW1fbnVtID0gMCwKICAgIC0t6Iux6ZuE57Si5byVCiAgICBoZXJvX2luZGV4ID0gLTEsCiAgICAtLSDpgInkurrlpKnotYsgMeKAkznvvIjnlLEgU2VsZWN0SGVyby5EYXRhIOWQjOatpe+8iQogICAgdGFsZW50X2luZGV4ID0gMSwKICAgIC0t5bGV56S65ZCN5a2XCiAgICBuYW1lID0gIiIsCiAgICAtLeaYr+WQpuS4uuS8queOqeWutuacuuWZqOS6ugogICAgYm90ID0gZmFsc2UsCiAgICAtLSDpgInkurrlkI7mlq3nur/jgIHotbDlvILmraXlh7rnnJ/vvJrlu7bov5/liLDph43ov57lho3ot5EgSGVyb0RhdGE6SW5pdEhlcm/vvIhucGNfc3Bhd24g5LiN6LCD5bqmIEluaXRIZXJv77yJCiAgICBjbHJiX2RlZmVyX2luaXRoZXJvX3VudGlsX3JlY29ubmVjdCA9IGZhbHNlLAp9Cg==]]
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