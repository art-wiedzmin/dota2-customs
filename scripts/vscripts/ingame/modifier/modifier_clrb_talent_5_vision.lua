--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local encoded=[[LS0g5aSp6LWLIDXjgIzlvIDkuobjgI3vvJrlnKjoh6rouqvkvY3nva7mjIHnu63mj5DkvpsgMjIwMCDnoIHpq5jnqbogRk9XIOinhumHju+8jOmaj+iLsembhOenu+WKqAptb2RpZmllcl9jbHJiX3RhbGVudF81X3Zpc2lvbiA9IGNsYXNzKHt9KQoKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl90YWxlbnRfNV92aXNpb246SXNIaWRkZW4oKSByZXR1cm4gdHJ1ZSBlbmQKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl90YWxlbnRfNV92aXNpb246SXNQdXJnYWJsZSgpIHJldHVybiBmYWxzZSBlbmQKZnVuY3Rpb24gbW9kaWZpZXJfY2xyYl90YWxlbnRfNV92aXNpb246UmVtb3ZlT25EZWF0aCgpIHJldHVybiB0cnVlIGVuZAoKbG9jYWwgUkFESVVTID0gMjIwMApsb2NhbCBUSElOSyA9IDAuMjUKbG9jYWwgRk9XX1BVTFNFID0gMC40CgpmdW5jdGlvbiBtb2RpZmllcl9jbHJiX3RhbGVudF81X3Zpc2lvbjpPbkNyZWF0ZWQoKQogICAgaWYgbm90IElzU2VydmVyKCkgdGhlbgogICAgICAgIHJldHVybgogICAgZW5kCiAgICBzZWxmOlB1bHNlRm93KCkKICAgIHNlbGY6U3RhcnRJbnRlcnZhbFRoaW5rKFRISU5LKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfdGFsZW50XzVfdmlzaW9uOk9uSW50ZXJ2YWxUaGluaygpCiAgICBpZiBub3QgSXNTZXJ2ZXIoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIHNlbGY6UHVsc2VGb3coKQplbmQKCmZ1bmN0aW9uIG1vZGlmaWVyX2NscmJfdGFsZW50XzVfdmlzaW9uOlB1bHNlRm93KCkKICAgIGxvY2FsIHAgPSBzZWxmOkdldFBhcmVudCgpCiAgICBpZiBub3QgcCBvciBwOklzTnVsbCgpIG9yIG5vdCBwOklzQWxpdmUoKSB0aGVuCiAgICAgICAgcmV0dXJuCiAgICBlbmQKICAgIEFkZEZPV1ZpZXdlcihwOkdldFRlYW1OdW1iZXIoKSwgcDpHZXRBYnNPcmlnaW4oKSwgUkFESVVTLCBGT1dfUFVMU0UsIGZhbHNlKQplbmQK]]
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