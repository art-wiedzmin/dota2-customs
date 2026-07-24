--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function HeroData:GetUIData(ID, data)
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

    if data.tp == "RollStar" then
        -- print(InitPlayer.Public.players)
        -- print("随机升星")
        
        self:RollStar(ID)
    end
    if data.tp == "LevelStar" then
        self:LevelStar(ID)
    end
    --属性转换
    --力量转敏捷 1  价格100
    --力量转智力 2  价格100
    --敏捷转力量 3  价格100
    --敏捷转智力 4  价格100
    --智力转力量 5  价格100
    --智力转敏捷 6  价格100
    --删除技能 7    价格500
    --技能点 8      价格350
    if data.tp == "AttrChange" then
        self:AttrChange(ID, data.text)
    end
end

--给前端发数据
function HeroData:SendData(ID)
    if not ID then
        return
    end
    local data = self.Data[ID]
    --print(data)
    Util:Send2JsID("UI_HeroData", data, ID)
end

--复活数据
function HeroData:SendRebornData(ID)

end
