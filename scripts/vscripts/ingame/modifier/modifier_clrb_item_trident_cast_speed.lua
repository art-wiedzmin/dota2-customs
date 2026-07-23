local encoded=[[LS0g5LiJ5YWD6YeN5oif77yaVmFsdmUg5Y6f55SfIG1vZGlmaWVyX2l0ZW1fdHJpZGVudCDmnKrlrp7njrAgY2FzdF9zcGVlZF9wY3TvvJvprZTms5XmlLvlh7vot7PlrZfkuI7ph5Hnro3mo5LlkIzmrL4KaWYgbW9kaWZpZXJfY2xyYl9pdGVtX3RyaWRlbnRfY2FzdF9zcGVlZCA9PSBuaWwgdGhlbgogICAgbW9kaWZpZXJfY2xyYl9pdGVtX3RyaWRlbnRfY2FzdF9zcGVlZCA9IGNsYXNzKHt9KQplbmQKCmxvY2FsIENBU1RfU1BFRURfUENUID0gMzAKbG9jYWwgTUFHSUNfQVRUQUNLX0RBTUFHRSA9IDMwCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX2l0ZW1fdHJpZGVudF9jYXN0X3NwZWVkOklzSGlkZGVuKCkKICAgIHJldHVybiB0cnVlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9pdGVtX3RyaWRlbnRfY2FzdF9zcGVlZDpJc0RlYnVmZigpCiAgICByZXR1cm4gZmFsc2UKZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX2l0ZW1fdHJpZGVudF9jYXN0X3NwZWVkOklzUHVyZ2FibGUoKQogICAgcmV0dXJuIGZhbHNlCmVuZAoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl9pdGVtX3RyaWRlbnRfY2FzdF9zcGVlZDpSZW1vdmVPbkRlYXRoKCkKICAgIHJldHVybiBmYWxzZQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfaXRlbV90cmlkZW50X2Nhc3Rfc3BlZWQ6RGVjbGFyZUZ1bmN0aW9ucygpCiAgICByZXR1cm4gewogICAgICAgIE1PRElGSUVSX1BST1BFUlRZX0NBU1RUSU1FX1BFUkNFTlRBR0UsCiAgICAgICAgTU9ESUZJRVJfRVZFTlRfT05fQVRUQUNLX0xBTkRFRCwKICAgIH0KZW5kCgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX2l0ZW1fdHJpZGVudF9jYXN0X3NwZWVkOkdldE1vZGlmaWVyUGVyY2VudGFnZUNhc3R0aW1lKCkKICAgIHJldHVybiBDQVNUX1NQRUVEX1BDVAplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfaXRlbV90cmlkZW50X2Nhc3Rfc3BlZWQ6T25BdHRhY2tMYW5kZWQocGFyYW1zKQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBsb2NhbCBhdHRhY2tlciA9IHBhcmFtcy5hdHRhY2tlcgogICAgaWYgYXR0YWNrZXIgfj0gc2VsZjpHZXRQYXJlbnQoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGlmIG5vdCBhdHRhY2tlcjpJc0hlcm8oKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIGxvY2FsIHRhcmdldCA9IHBhcmFtcy50YXJnZXQKICAgIGlmIG5vdCB0YXJnZXQgb3IgdGFyZ2V0OklzTnVsbCgpIG9yIG5vdCB0YXJnZXQ6SXNBbGl2ZSgpIHRoZW4KICAgICAgICByZXR1cm4KICAgIGVuZAogICAgaWYgdGFyZ2V0OkdldFRlYW1OdW1iZXIoKSA9PSBhdHRhY2tlcjpHZXRUZWFtTnVtYmVyKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBpZiB0YXJnZXQ6SXNCdWlsZGluZygpIG9yIHRhcmdldDpJc0NvdXJpZXIoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHV0aWxleDpVbml0RGFtKGF0dGFja2VyLCB0YXJnZXQsIE1BR0lDX0FUVEFDS19EQU1BR0UsICJtZiIsIG5pbCwgdHJ1ZSkKZW5kCg==]]
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