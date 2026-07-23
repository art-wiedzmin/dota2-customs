--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


require("listener.filter_reg.order")
require("listener.filter_reg.damage")
require("listener.filter_reg.exp")
require("listener.filter_reg.gold")
require("listener.filter_reg.heal")
require("listener.filter_reg.modifier")
require("listener.filter_reg.inventory")

function CustomSets:FilterRegister()
   local mode = GameRules:GetGameModeEntity()
   if not mode then return end
   if CustomSets.Filter_Has_Reg == nil then
      CustomSets.Filter_Has_Reg = {}
   end
   if not CustomSets.Filter_Has_Reg["Order_Filter"] then
      mode:SetExecuteOrderFilter(Dynamic_Wrap(self, "Order_Filter"), self)
      CustomSets.Filter_Has_Reg["Order_Filter"] = true
   end
   if not CustomSets.Filter_Has_Reg["Damage_Filter"] then
      mode:SetDamageFilter(Dynamic_Wrap(self, "Damage_Filter"), self)
      CustomSets.Filter_Has_Reg["Damage_Filter"] = true
      --print("注册攻击监听")
   end
   if not CustomSets.Filter_Has_Reg["Exp_Filter"] then
      mode:SetModifyExperienceFilter(Dynamic_Wrap(self, "Exp_Filter"), self)
      CustomSets.Filter_Has_Reg["Exp_Filter"] = true
   end
   if not CustomSets.Filter_Has_Reg["Gold_Filter"] then
      mode:SetModifyGoldFilter(Dynamic_Wrap(self, "Gold_Filter"), self)
      CustomSets.Filter_Has_Reg["Gold_Filter"] = true
   end
   if not CustomSets.Filter_Has_Reg["Heal_Filter"] then
      mode:SetHealingFilter(Dynamic_Wrap(self, "Heal_Filter"), self)
      CustomSets.Filter_Has_Reg["Heal_Filter"] = true
   end
   if not CustomSets.Filter_Has_Reg["Modifier_Filter"] then
      mode:SetModifierGainedFilter(Dynamic_Wrap(self, "Modifier_Filter"), self)
      CustomSets.Filter_Has_Reg["Modifier_Filter"] = true
   end
   if not CustomSets.Filter_Has_Reg["Inventory_Filter"] then
      mode:SetItemAddedToInventoryFilter(Dynamic_Wrap(self, "Inventory_Filter"), self)
      CustomSets.Filter_Has_Reg["Inventory_Filter"] = true
   end
end