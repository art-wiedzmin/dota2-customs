--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--设置模式
function Http:SetTp()
    if IsInToolsMode() then
        self.Data.tp = 1
    else
        self.Data.tp = 2
    end
end

--设置IP和端口
function Http:SetIp()
    if self.Data.tp == 1 then
        self.Data.IP = "127.0.0.1"
    else
        self.Data.IP = self.Data.serverip
    end
end

function Http:SetPort()
    if self.Data.tp == 1 then
        self.Data.Port = self.Data.localport or 3000
    else
        self.Data.Port = self.Data.serverport
    end
end

--设置传输key
function Http:SetSecretKey()
    local SKD_Key = self:GetSKD()
    --传输KEY
    self.Data.secretkey = Util:CutOut(SKD_Key, 1, 10)
end

--设置主机地址
function Http:SetUrl()
    local IP = self.Data.IP
    local Port = self.Data.Port
    self.Data.url = "http://" .. IP .. ":" .. Port
end
