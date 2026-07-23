-- item_recipe_equip_6：配方物品，逻辑由引擎合成处理；脚本仅满足 item_lua 加载与充能回调签名。
if item_recipe_equip_6 == nil then
    item_recipe_equip_6 = class({})
end

function item_recipe_equip_6:OnChargeCountChanged(_kv)
end
