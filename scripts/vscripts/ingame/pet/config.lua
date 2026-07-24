--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Pet.Data = {}
Pet.Template = {
    --宠物是否要去捡东西
    pick = false,
    -- 是否开启自动拾取（局外背包佩戴宠物时为 true）
    pick_enabled = false,
    pick_list = {},
    session_pet_ready = false,
    -- 当前局内宠物对应的局外 item_key（切换佩戴时需重生单位换模型）
    equipped_pet_key = "",
    --宠物索引
    index = -1,
}
Pet.Static = {
    --宠物追随范围
    follow = 300,
    --返回范围
    back = 1000,
    --捡东西范围
    pick = 800
}
Pet.PickList = {
    "item_goods_14",
    "item_goods_15",
}
