--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function HeroData:SetHeroCostGain(ID, hero)
    if not self.Data[ID] then
        self:Init(ID)
    end
    local llcz              = hero:GetStrengthGain()
    local mjcz              = hero:GetAgilityGain()
    local zlcz              = hero:GetIntellectGain()

    self.Data[ID].cost.llcz = utilex:FloatSet(llcz, 1)
    self.Data[ID].cost.mjcz = utilex:FloatSet(mjcz, 1)
    self.Data[ID].cost.zlcz = utilex:FloatSet(zlcz, 1)
    self:SendData(ID)
end

function HeroData:AddGold(ID, gold)
    if not ID or not gold then
        return
    end
    self.Data[ID].gold = self.Data[ID].gold + gold
end

function HeroData:AddDam(ID, dam)
    self.Data[ID].damage = self.Data[ID].damage + dam
end

function HeroData:AddTank(ID, tank)
    self.Data[ID].tank = self.Data[ID].tank + tank
end

--设置英雄索引
function HeroData:SetHeroIndex(ID, hero)
    if not ID then
        return
    end
    if not self.Data[ID] then
        self:Init(ID)
    end
    self.Data[ID].hero_index = hero:GetEntityIndex()
end
