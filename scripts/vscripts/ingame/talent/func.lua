--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 已选先天装备的玩家：保证对应 talent modifier 存在（丢失时补加，存在则刷新）
function Talent:EnsureTalentEquipModifier(ID)
    if not ID or not self.Data or not self.Data[ID] then
        return
    end
    local row = self.Data[ID]
    if row.select_talent ~= true then
        return
    end
    local item_name = row.item_name
    if not item_name or item_name == "" then
        return
    end
    local buff_name
    if item_name == "item_goods_17" then
        buff_name = "modifier_talent_1"
    elseif item_name == "item_goods_18" then
        buff_name = "modifier_talent_2"
    elseif item_name == "item_goods_19" then
        buff_name = "modifier_talent_3"
    elseif item_name == "item_goods_24" then
        buff_name = "modifier_talent_4"
    else
        return
    end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() or not hero:IsAlive() or not hero:IsRealHero() then
        return
    end
    if item_name == "item_goods_17" then
        LinkLuaModifier("modifier_talent_1", "ingame/modifier/modifier_talent_1", LUA_MODIFIER_MOTION_NONE)
        LinkLuaModifier("modifier_talent_1_damage_amp_debuff",
            "ingame/modifier/modifier_talent_1_damage_amp_debuff", LUA_MODIFIER_MOTION_NONE)
    elseif item_name == "item_goods_18" then
        LinkLuaModifier("modifier_talent_2", "ingame/modifier/modifier_talent_2", LUA_MODIFIER_MOTION_NONE)
        LinkLuaModifier("modifier_talent_2_aura_debuff", "ingame/modifier/modifier_talent_2", LUA_MODIFIER_MOTION_NONE)
    elseif item_name == "item_goods_24" then
        LinkLuaModifier("modifier_talent_4", "ingame/modifier/modifier_talent_4", LUA_MODIFIER_MOTION_NONE)
    else
        LinkLuaModifier("modifier_talent_3", "ingame/modifier/modifier_talent_3", LUA_MODIFIER_MOTION_NONE)
    end
    local modifier = hero:FindModifierByName(buff_name)
    if modifier then
        modifier:ForceRefresh()
    else
        hero:AddNewModifier(hero, nil, buff_name, {})
    end
end

function Talent:RefreshBuff(ID)
    self:EnsureTalentEquipModifier(ID)
end

function Talent:AutoPage(ID)
    if not ID then
        return
    end
    Timers(10, function()
        if self.Data[ID].select_talent == true then
            return
        end
        if self.Data[ID].page == true then
            return
        end
        if self.Data[ID].select_talent == false then
            self:OpenPage(ID)
        end
    end)
end
