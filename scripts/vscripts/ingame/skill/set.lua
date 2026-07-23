local encoded=[[LS3lhbPpl63mp73kvY3lm77moIcKZnVuY3Rpb24gU2tpbGw6Q2xvc2VDaGFuZ2VJbWcoSUQpCiAgICBzZWxmLkRhdGFbSURdLnNsb3RfaW1nX3BhZ2UgPSBmYWxzZQogICAgc2VsZjpTZW5kRGF0YShJRCkKZW5kCgotLeaJk+W8gOanveS9jeWbvuaghwpmdW5jdGlvbiBTa2lsbDpPcGVuQ2hhbmdlSW1nKElEKQogICAgaWYgbm90IHNlbGYuRGF0YVtJRF0gdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBpZiBzZWxmLkRhdGFbSURdLnNsb3RfaW1nX3BhZ2UgPT0gdHJ1ZSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHNlbGYuRGF0YVtJRF0uc2xvdF9pbWdfcGFnZSA9IHRydWUKICAgIHNlbGY6U2VuZERhdGEoSUQpCmVuZAoKLS3op6PplIEKZnVuY3Rpb24gU2tpbGw6VW5Mb2NrKGlkKQogICAgLS0gZm9yIGssIHYgaW4gcGFpcnMoc2VsZi5QdWJsaWMpIGRvCiAgICAtLSAgICAgaWYgdiBhbmQgdiA9PSBpZCB0aGVuCiAgICAtLSAgICAgICAgIHNlbGYuUHVibGljW2tdID0gbmlsCiAgICAtLSAgICAgZW5kCiAgICAtLSBlbmQKZW5kCg==]]
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