--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function KeySet:GetUIData(ID, data)
    if not ID or not data then
        return
    end
    --暂停禁止传数据
    if GameRules:IsGamePaused() then
        return
    end
    --初始化数据
    if data.tp == "init" then
        self:SendData(ID)
        KeySet:SendPublicData()
    end
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    --保存（list改键；pet 表与 Item.Rb 项名对应，布尔为是否点亮）
    if data.tp == "SaveKeyBind" then
        self:SaveKeyBind(ID, data.list or data.text, data)
    end
    -- 前端自定义热键按下（SkillSlot CreateCustomKeyBind）
    if data.tp == "PlayerKeyDown" then
        self:OnPlayerKeyDown(ID, data)
    end
end

--给前端发数据
function KeySet:SendData(ID)
    if not ID then
        return
    end
    local data = self.Data[ID]
    if not data then
        return
    end
    self:EnsureKeybindDefaults(ID)
    self:EnsurePetKeys(ID)
    self:SyncActivePetToRow(ID)
    local payload = Util:DeepCopyTab(data)
    payload.pet_rb_order = Util:DeepCopyTab(Item.Rb or {})
    Util:Send2JsID("UI_KeySet", payload, ID)
end
