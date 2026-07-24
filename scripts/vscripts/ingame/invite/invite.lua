--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Invite == nil then
    Invite = class({})
    require("ingame.Invite.Config")
    require("ingame.Invite.Set")
    require("ingame.Invite.Get")
    -- require("ingame.Invite.Func")
    require("ingame.Invite.Ui")
end

function Invite:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
    self.Data[ID].vid = PlayerResource:GetSteamAccountID(ID)
end

-- data 可为完整 { invited, fans, invites 或 inviteds }；只更新存在的字段
function Invite:LoadInvite(ID, data)
    if not ID or not data then return end
    if data.invited ~= nil then self.Data[ID].invited = data.invited end
    if data.fans ~= nil then self.Data[ID].fans = data.fans end
    -- 服务端 User 字段为 inviteds，部分接口若用 invites 也兼容
    local invites = data.invites or data.inviteds
    if invites then
        for i = 1, 10 do
            local k = "award" .. i
            if invites[k] ~= nil then
                self.Data[ID].list[k] = invites[k]
            end
        end
    end
    self:SendData(ID)
end

-- 填写邀请码：仅当未填写过(invited==0)时可提交
function Invite:WriteInvite(ID, v_id)
    if not ID or not v_id or tostring(v_id) == "" then return end
    if self.Data[ID].invited == 1 then
        Msgs:Pop(ID, "已填写过邀请码", {})
        return
    end
    local mine = tonumber(tostring(self.Data[ID].vid))
    local inv = tonumber(tostring(v_id):match("^%s*(.-)%s*$"))
    if mine and inv and mine == inv then
        Msgs:Pop(ID, "不能填写自己的邀请码", {})
        return
    end
    Http:POST("/user/apply_invite", {inviterPid = v_id}, ID, function(keys)
        if keys.code == 200 then
            local res = keys.data
            if res and (res.invited ~= nil or res.invites or res.inviteds) then
                Invite:LoadInvite(ID, res.user or res)
            else
                self.Data[ID].invited = 1
                self:SendData(ID)
            end
            Shop:PopFreeSuccess(ID, "邀请码填写成功", res, 1000)
            if Shop and Shop.LoadShop then Shop:LoadShop(ID) end
        else
            Msgs:Pop(ID, keys.msg or "填写失败", {})
        end
    end)
end

-- 领取档位奖励：num 为 1～10；list.awardN==1 表示已领取（与 UI/服务端一致）
function Invite:GetInvite(ID, num)
    -- print("GetInvite", ID, num)
    if not ID or not num then return end
    local n = tonumber(num)
    if not n or n < 1 or n > 10 then return end
    local awardkey = "award" .. n
    if self.Data[ID].list[awardkey] == 1 then return end
    Http:POST("/user/claim_invite_reward", {rewardIndex = n}, ID, function(keys)
        if keys.code == 200 then
            local data = keys.data
            if data then
                if data.invites or data.inviteds then
                    Invite:LoadInvite(ID, data)
                else
                    self.Data[ID].list[awardkey] = 1
                    if data.fans ~= nil then
                        self.Data[ID].fans = data.fans
                    end
                    self:SendData(ID)
                end
            end
            Shop:PopFreeSuccess(ID, "奖励发放", data, 1000)
            if Shop and Shop.LoadShop then Shop:LoadShop(ID) end
        else
            Msgs:Pop(ID, keys.msg or "领取失败", {})
        end
    end)
end
