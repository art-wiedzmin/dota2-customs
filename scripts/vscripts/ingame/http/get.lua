--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--获取模式
function Http:GetTp()
    return self.Data.tp
end

--获取SKD
function Http:GetSKD()
    return self.Data.SKD_KEY
end

--获取传输Key
function Http:GetSecretKey()
    return self.Data.secretkey
end

--获取主机地址
function Http:GetUrl()
    return self.Data.url
end
