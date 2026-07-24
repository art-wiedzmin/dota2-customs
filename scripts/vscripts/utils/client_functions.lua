function C_DOTA_BaseNPC:HasShard()
    return self:HasModifier("modifier_item_aghanims_shard")
end

function IsValid(...)
    for i = 1, select("#", ...) do
        local entity = select(i, ...)
        if not entity or not entity.IsNull or entity:IsNull() then
            return false
        end
    end
    return true
end