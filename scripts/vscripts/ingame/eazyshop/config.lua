--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


EazyShop.Data = {}
EazyShop.Template = {
    page = false,
    goods = {},
    tian_shu_pending = false,
    tian_shu_item_refund = false,
}

EazyShop.Static = {
    --- 生命之书：便捷购买与背包使用共用，每生效一次 +1000 smjc；防止无限购买叠出极端生命
    LifeBookMaxAppliesPerGame = 10,
    TianShuPrice = 1800,
    --- 便捷商店购买天书：游戏内时间（秒，GetDOTATime）需达到该值，默认 20 分钟
    TianShuUnlockGameTime = 900,
    Goods = {
        { id = "goods_3", item = "item_goods_3", price = 200, title = "力量转敏捷" },
        { id = "goods_4", item = "item_goods_4", price = 200, title = "力量转智力" },
        { id = "goods_5", item = "item_goods_5", price = 200, title = "敏捷转力量" },
        { id = "goods_6", item = "item_goods_6", price = 200, title = "敏捷转智力" },
        { id = "goods_7", item = "item_goods_7", price = 200, title = "智力转力量" },
        { id = "goods_8", item = "item_goods_8", price = 200, title = "智力转敏捷" },
        { id = "skill_point", item = "item_goods_9", price = 350, title = "技能点" },
        { id = "del_skill", item = "item_goods_20", price = 500, title = "删除技能" },
        { id = "life_book", item = "item_goods_21", price = 10000, title = "生命之书" },
        { id = "tian_shu", item = "item_goods_22", price = 1800, title = "天书" },
    },
}
