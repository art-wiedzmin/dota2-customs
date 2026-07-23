-- 中立栏宝箱道具：无冷却，使用即走 Box:Draw；次数由物品充能显示，与 Box.Data[ID].box_sy_draw 同步（见 Box:RefreshNeutralChestItemCharges）
if item_cost_2 == nil then item_cost_2 = class({}) end

-- SetCurrentCharges 会调起；当前引擎 item_lua 的 OnChargeCountChanged 仅 1 个参数（见 item_recipe_equip_4 等同修复）。
-- 带充能物品施法时引擎会自行扣充能，真实次数只在 Box:SubDraw 里减 box_sy_draw；若在未选定奖品时反复使用只会切页，
-- 充能会被扣成 0 而 box_sy_draw 仍 >0，客户端会禁止施法。此处一律把充能与 box_sy_draw 对齐。
function item_cost_2:OnChargeCountChanged(_kv)
end

function item_cost_2:GetCooldown(iLevel)
    return 0
end

function item_cost_2:GetManaCost(iLevel)
    return 0
end

function item_cost_2:IsRefreshable()
    return true
end

function item_cost_2:CastFilterResult()
    return UF_SUCCESS
end

function item_cost_2:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    if not caster or caster:IsNull() or not caster:IsAlive() then return end
    local ID = Util:Hero2ID(caster)
    if not ID then return end
    if Box:GetDrawCount(ID) <= 0 then
        return Util:BottomMsg2ID(ID, "次数不足")
    end
    if Box.Data[ID].draw_state == true then
        Box:Draw(ID)
    else
        if Box.Data[ID].page == true then
            Box:ClosePage(ID)
        else
            Box:OpenPage(ID)
            Box:SendData(ID)
        end
    end
end
