--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function Box:GetUIData(ID, data)
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
    end
    --打开宝箱页面
    if data.tp == "OpenPage" then
        self:OpenPage(ID)
    end
    --关闭宝箱页面
    if data.tp == "ClosePage" then
        self:ClosePage(ID)
    end
    --放弃本次宝箱选取（消耗次数）
    if data.tp == "GiveUp" then
        self:GiveUp(ID)
    end
    --抽取宝箱
    if data.tp == "Draw" then
        if self.Data[ID].draw_state == true then
            self:Draw(ID)
        else
            if self.Data[ID].page == true then
                self:ClosePage(ID)
            else
                self:OpenPage(ID)
                self:SendData(ID)
            end
        end
    end
    --随机宝物
    if data.tp == "DrawRoll" then
        self:DrawRoll(ID)
        self:SendData(ID, true)
    end
    --选择宝物
    if data.tp == "Select" then
        self:Select(ID, data.text)
    end
    --摧毁宝物
    if data.tp == "BreakItem" then
        self:BreakItem(ID, data.text)
    end
    --加速
    if data.tp == "Run" then
        -- self:Run(ID)
    end
    if data.tp == "AddItem" then
        self:HostAddItem(ID, data.pid, data.item)
    end
end

--给前端发数据
function Box:SendData(ID, movie, clear)
    if not ID then
        return
    end
    local list = {
        show = self.Data[ID].show,
        page = self.Data[ID].page,
        box_sy_draw = math.max(0, self.Data[ID].box_sy_draw),
        roll_sy_draw = self.Data[ID].roll_sy_draw,
        bag = self.Data[ID].bag,
        list = self.Data[ID].list,
        clear = false,
        movie = false,
        cost = self.Data[ID].cost
    }
    if movie then
        list.movie = true
    end
    if clear then
        list.clear = true
    end
    Util:Send2JsID("UI_Box", list, ID)
end

--发送加速数据
function Box:SendRunData(ID)
    if not ID then
        return
    end
    local list = {
        run_state = self.Data[ID].run_state,
        run_cd = self.Data[ID].run_cd
    }
    Util:Send2JsID("UI_RunBox", list, ID)
end
