-- item_recipe_equip_5：配方物品，逻辑由引擎合成处理；脚本仅满足 item_lua 加载与充能回调签名。
if item_recipe_equip_5 == nil then
    item_recipe_equip_5 = class({})
end

function item_recipe_equip_5:OnChargeCountChanged(_kv)
end
