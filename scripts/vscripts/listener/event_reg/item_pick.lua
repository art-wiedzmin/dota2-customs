--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function CustomSets:Item_Pick(keys)
    --print("Item_Pick")
    -- print(keys)
    -- if keys.HeroEntityIndex and keys.ItemEntityIndex then
    --     local hero = EntIndexToHScript(keys.HeroEntityIndex)
    --     if hero and not hero:IsNull() then
    --         local item = EntIndexToHScript(keys.ItemEntityIndex)
    --         if item and not item:IsNull() then
    --             local item_name = item:GetName()
    --             print(item_name)
    --             if item_name == "item_goods_14" then
    --                 if item:IsStackable() and Item:IsHaveItem(hero:GetPlayerOwnerID(), item_name) then
    --                     local bag_item = Item:FindItem(hero:GetPlayerOwnerID(), item_name)
    --                     if bag_item then
    --                         bag_item:SetCurrentCharges(bag_item:GetCurrentCharges() + 1)
    --                         return false
    --                     end
    --                 else
    --                     hero:AddItem(item)
    --                     return false
    --                 end
    --             end
    --         end
    --     end
    -- end
end