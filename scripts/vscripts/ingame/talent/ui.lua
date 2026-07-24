--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Talent:GetUIData(ID, data)
    -- print("22222")
    if not ID or not data then return end
    -- 暂停禁止传数据
    if GameRules:IsGamePaused() then return end
    -- 观战者或未初始化玩家无 Talent 数据：强制下发隐藏 tooltip，避免观战模式下 tooltip 常驻显示
    if not self.Data[ID] then
        Util:Send2JsID("UI_TipData", { page = false }, ID)
        return
    end
    -- 初始化数据
    if data.tp == "init" then
        -- print("11111")
        Talent:SendData(ID)
        Talent:SendKillData(ID)
        Talent:SendBagData(ID)
        Talent:SendTipData(ID)
    end
    -- 打开页面
    if data.tp == "OpenPage" then self:OpenPage(ID) end
    -- 关闭页面
    if data.tp == "ClosePage" then self:ClosePage(ID) end
    if data.tp == "SelectTalent" then self:SelectTalent(ID, data.text) end
    if data.tp == "drag" then self:Drap(ID) end
    if data.tp == "LevelUp" then self:LevelUp(ID) end
    -- 随机属性
    if data.tp == "RollAttr" then self:RollAttr(ID) end
    -- 关闭属性页面
    if data.tp == "CloseAttr" then self:CloseAttr(ID) end
    -- 选择属性
    if data.tp == "SelectAttr" then self:SelectAttr(ID, data.text) end
    -- 显示tip
    if data.tp == "show_tip" then self:ShowTip(ID) end
    -- 隐藏tip
    if data.tp == "close_tip" then self:CloseTip(ID) end
    -- 局内天赋技能图标点击 → 与使用回城格 item_tpscroll 相同
    if data.tp == "cast_talent_skill" then self:CastTalentSkillItem(ID) end
end

-- 给前端发数据
function Talent:SendData(ID)
    if not ID then return end
    -- print(self.Data[ID])
    local hero_name = HeroData:GetHeroName(ID)
    if hero_name then
        self.Data[ID].hero_name = hero_name
    end
    Util:Send2JsID("UI_Talent", self.Data[ID], ID)
end

-- 给背包发送消息，更新背包槽位
function Talent:SendBagData(ID, slot)
    local list = { slot = slot }
    Util:Send2JsID("UI_BagSlot", list, ID)
end

-- 更新杀敌数和升级
function Talent:SendKillData(ID)
    local list = {
        bag_page = self.Data[ID].bag_page,
        up = self.Data[ID].up,
        sy = self.Data[ID].sy,
        text_page = self.Data[ID].text_page
    }
    Util:Send2JsID("UI_BagKill", list, ID)
    Talent:SendData(ID)
end

-- 更新属性信息
function Talent:SendAttrData(ID)
    -- print("4444")
    local list = {
        page = self.Data[ID].attr_page,
        list = self.Data[ID].attr_list,
        roll_num = self.Data[ID].roll_num,
        cost = self.Data[ID].cost,
        refresh_state = self.Data[ID].refresh_state
    }
    Util:Send2JsID("UI_AttrData", list, ID)
    Talent:SendData(ID)
end

-- 更新tip信息
function Talent:SendTipData(ID)
    if not self.Data[ID] then
        -- 观战者等无数据玩家：只下发隐藏，避免报错与 tooltip 常驻
        Util:Send2JsID("UI_TipData", { page = false }, ID)
        return
    end
    local list = {
        page = self.Data[ID].tip_page,
        item_name = self.Data[ID].item_name,
        attr = self.Data[ID].equip_attr.attr,
        level = self.Data[ID].level
    }
    Util:Send2JsID("UI_TipData", list, ID)
    Talent:SendData(ID)
end
