-- item_recipe_equip_4：配方物品，逻辑由引擎合成处理；脚本仅满足 item_lua 加载与充能回调签名。
if item_recipe_equip_4 == nil then
    item_recipe_equip_4 = class({})
end

function item_recipe_equip_4:OnChargeCountChanged(_kv)
end
