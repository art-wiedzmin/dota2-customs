--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Item.Data = {}
Item.Template = {}
Item.Static = {
    use = {
        "item_goods_1", "item_goods_2", "item_goods_3", "item_goods_4",
        "item_goods_5", "item_goods_6", "item_goods_7", "item_goods_8",
        "item_goods_9", -- 技能点：拾取时保留不触发 UseItem，走堆叠逻辑，避免宠物捡第二个时 EjectItemFromStash 导致两个都不可用
        "item_goods_20" -- 删除技能：拾取时保留不触发 UseItem，走堆叠逻辑，避免宠物捡第二个时 EjectItemFromStash 导致两个都不可用
    }
}
Item.Stack = {
    "item_goods_3", "item_goods_4", "item_goods_5", "item_goods_6",
    "item_goods_7", "item_goods_8", "item_goods_9", "item_goods_14",
    "item_goods_15", "item_goods_16", "item_goods_20", "item_goods_22", "item_goods_23",
    "item_skill_1",
    "item_skill_2", "item_skill_3", "item_skill_4", "item_skill_5",
    "item_skill_6", "item_skill_7", "item_skill_8", "item_skill_9",
    -- "item_skill_10",
    "item_skill_11", "item_skill_12", "item_skill_13", "item_skill_14",
    "item_skill_15", "item_skill_16", "item_skill_17", "item_skill_18",
    "item_skill_19", "item_skill_20", "item_skill_21", "item_skill_22",
    "item_skill_23", "item_skill_24", "item_skill_25", "item_skill_26",
    "item_skill_27", "item_skill_28", "item_skill_29", -- "item_skill_30",
    "item_skill_31", "item_skill_32", "item_skill_33", "item_skill_34",
    "item_skill_35", "item_skill_36", "item_skill_37", "item_skill_38"
}
Item.StackSkill = {
    "item_goods_14", "item_goods_15", "item_goods_16",
    "item_skill_1", "item_skill_2", "item_skill_3", "item_skill_4",
    "item_skill_5", "item_skill_6", "item_skill_7", "item_skill_8",
    "item_skill_9", "item_skill_10", "item_skill_11", "item_skill_12",
    "item_skill_13", "item_skill_14", "item_skill_15", "item_skill_16",
    "item_skill_17", "item_skill_18", "item_skill_19", "item_skill_20",
    "item_skill_21", "item_skill_22", "item_skill_23", "item_skill_24",
    "item_skill_25", "item_skill_26", "item_skill_27", "item_skill_28",
    "item_skill_29", "item_skill_30", "item_skill_31", "item_skill_32",
    "item_skill_33", "item_skill_34", "item_skill_35", "item_skill_36",
    "item_skill_37", "item_skill_38",
}
Item.Rb = {
    "item_skill_1", "item_skill_2", "item_skill_3", -- "item_skill_4",
    "item_skill_5", "item_skill_6", "item_skill_7", -- "item_skill_8",
    "item_skill_9",                                 -- "item_skill_10",
    "item_skill_11",                                -- "item_skill_12",
    "item_skill_13", "item_skill_14", "item_skill_15", "item_skill_16",
    "item_skill_17", "item_skill_18", "item_skill_19", "item_skill_20",
    "item_skill_21", "item_skill_22", "item_skill_23", "item_skill_24",
    "item_skill_25", "item_skill_26", "item_skill_27", "item_skill_28",
    "item_skill_29", -- "item_skill_30", 血肉丰碑暂时隐藏
    "item_skill_31", "item_skill_32",
    "item_skill_33", "item_skill_34", "item_skill_35", "item_skill_36",
    "item_skill_37", "item_skill_38"
}
Item.Tx = {
    item_goods_10 = "particles/item_rank1_p.vpcf",
    item_goods_11 = "particles/item_rank2_p.vpcf",
    item_goods_12 = "particles/item_rank5_1.vpcf",
    item_goods_15 = "particles/item_rank1_p.vpcf",
    item_goods_16 = "particles/item_rank5_p.vpcf",
    item_goods_25 = "particles/item_rank1_p.vpcf",
    item_goods_26 = "particles/item_rank5_1.vpcf",
}

Item.Goods25Fx = {
    bolt = "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf",
    start = "particles/units/heroes/hero_zuus/zuus_lightning_bolt_start.vpcf",
    glow = "particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf",
    cast = "particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf",
    sky_z = 2000,
}
