--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[RWF6eVNob3AuRGF0YSA9IHt9CkVhenlTaG9wLlRlbXBsYXRlID0gewogICAgcGFnZSA9IGZhbHNlLAogICAgZ29vZHMgPSB7fSwKICAgIHRpYW5fc2h1X3BlbmRpbmcgPSBmYWxzZSwKICAgIHRpYW5fc2h1X2l0ZW1fcmVmdW5kID0gZmFsc2UsCn0KCkVhenlTaG9wLlN0YXRpYyA9IHsKICAgIC0tLSDnlJ/lkb3kuYvkuabvvJrkvr/mjbfotK3kubDkuI7og4zljIXkvb/nlKjlhbHnlKjvvIzmr4/nlJ/mlYjkuIDmrKEgKzEwMDAgc21qY++8m+mYsuatouaXoOmZkOi0reS5sOWPoOWHuuaegeerr+eUn+WRvQogICAgTGlmZUJvb2tNYXhBcHBsaWVzUGVyR2FtZSA9IDEwLAogICAgVGlhblNodVByaWNlID0gMTgwMCwKICAgIC0tLSDkvr/mjbfllYblupfotK3kubDlpKnkuabvvJrmuLjmiI/lhoXml7bpl7TvvIjnp5LvvIxHZXRET1RBVGltZe+8iemcgOi+vuWIsOivpeWAvO+8jOm7mOiupCAyMCDliIbpkp8KICAgIFRpYW5TaHVVbmxvY2tHYW1lVGltZSA9IDkwMCwKICAgIEdvb2RzID0gewogICAgICAgIHsgaWQgPSAiZ29vZHNfMyIsIGl0ZW0gPSAiaXRlbV9nb29kc18zIiwgcHJpY2UgPSAyMDAsIHRpdGxlID0gIuWKm+mHj+i9rOaVj+aNtyIgfSwKICAgICAgICB7IGlkID0gImdvb2RzXzQiLCBpdGVtID0gIml0ZW1fZ29vZHNfNCIsIHByaWNlID0gMjAwLCB0aXRsZSA9ICLlipvph4/ovazmmbrlipsiIH0sCiAgICAgICAgeyBpZCA9ICJnb29kc181IiwgaXRlbSA9ICJpdGVtX2dvb2RzXzUiLCBwcmljZSA9IDIwMCwgdGl0bGUgPSAi5pWP5o236L2s5Yqb6YePIiB9LAogICAgICAgIHsgaWQgPSAiZ29vZHNfNiIsIGl0ZW0gPSAiaXRlbV9nb29kc182IiwgcHJpY2UgPSAyMDAsIHRpdGxlID0gIuaVj+aNt+i9rOaZuuWKmyIgfSwKICAgICAgICB7IGlkID0gImdvb2RzXzciLCBpdGVtID0gIml0ZW1fZ29vZHNfNyIsIHByaWNlID0gMjAwLCB0aXRsZSA9ICLmmbrlipvovazlipvph48iIH0sCiAgICAgICAgeyBpZCA9ICJnb29kc184IiwgaXRlbSA9ICJpdGVtX2dvb2RzXzgiLCBwcmljZSA9IDIwMCwgdGl0bGUgPSAi5pm65Yqb6L2s5pWP5o23IiB9LAogICAgICAgIHsgaWQgPSAic2tpbGxfcG9pbnQiLCBpdGVtID0gIml0ZW1fZ29vZHNfOSIsIHByaWNlID0gMzUwLCB0aXRsZSA9ICLmioDog73ngrkiIH0sCiAgICAgICAgeyBpZCA9ICJkZWxfc2tpbGwiLCBpdGVtID0gIml0ZW1fZ29vZHNfMjAiLCBwcmljZSA9IDUwMCwgdGl0bGUgPSAi5Yig6Zmk5oqA6IO9IiB9LAogICAgICAgIHsgaWQgPSAibGlmZV9ib29rIiwgaXRlbSA9ICJpdGVtX2dvb2RzXzIxIiwgcHJpY2UgPSAxMDAwMCwgdGl0bGUgPSAi55Sf5ZG95LmL5LmmIiB9LAogICAgICAgIHsgaWQgPSAidGlhbl9zaHUiLCBpdGVtID0gIml0ZW1fZ29vZHNfMjIiLCBwcmljZSA9IDE4MDAsIHRpdGxlID0gIuWkqeS5piIgfSwKICAgIH0sCn0K]]
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