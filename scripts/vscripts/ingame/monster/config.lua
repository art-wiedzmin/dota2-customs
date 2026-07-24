--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Monster.Data = {
    page = false,
    limit = 300,
    spawn_time = 10,
    spawn_num = 100,
    normal = {},
    normal_count = 0, -- 缓存存活数量，避免频繁 TabCount 造成卡顿
    leader = {},
    -- 狼
    wolf_state = 1,
    -- 熊
    bear_state = 1,
    -- 龙
    dragon_state = 1,
    wolf_time = 300,
    bear_time = 900,
    --- 与 MainGame 首只魔龙刷新（EventList dragon1，秒）一致，供 HUD 倒计时
    dragon_time = 1260,
    pos_index = 1,
    pos_num = 0,
    stage = 0,
    lightning = {},
}
Monster.LightningBeliever = {
    unit_name = "m_1_6",
    start_time = 600,
    interval = 20,
    max_alive = 12,
    spawn_pfx_bolt = "particles/econ/items/zeus/zeus_immortal_2021/zuus_shard_gold_e.vpcf",
    spawn_pfx_beam = "particles/econ/items/huskar/huskar_2022_immortal/huskar_2022_immortal_life_break_gold_vertical_lightbeam.vpcf",
    spawn_pfx_ground = "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_groundfx_crack.vpcf",
}
Monster.Normal = { "m_1_1", "m_1_2", "m_1_3", "m_1_4" }
Monster.BearPos = {
    pos1 = Vector(-2437.771484, -372.241028, 256.000000),
    pos2 = Vector(8.204834, 1527.295288, 0.000000),
    pos3 = Vector(2370.160400, -519.602600, 256.000000),
    pos4 = Vector(157.535156, -2551.127197, 128.000000),
    pos5 = Vector(2481.999512, -2402.882324, 256.000000),
    pos6 = Vector(-3109.992920, 1940.390503, 128.000000)
}
Monster.DragonPos = Vector(240.545654, -60.089966, 128.000000)

Monster.leader = {
    m_2_1 = "item_goods_10",
    m_2_2 = "item_goods_11",
    m_2_3 = "item_goods_26"
}
--十分钟前掉落概率
Monster.Item1 = {
    --空
    null = 515,
    --肉搏技能书
    item_goods_13 = 400,
    --初级技能书
    item_goods_14 = 70,
    --高级技能书
    item_goods_15 = 15,
    --究极技能书（16 分钟前不掉落，见 Monster:GetNormalDropPool）
    item_goods_16 = 1
}
--二十分钟前掉落概率
Monster.Item2 = {
    --空
    null = 550,
    --肉搏技能
    item_goods_13 = 400,
    --初级技能书
    item_goods_14 = 30,
    --高级技能书
    item_goods_15 = 30,
    --究极技能书（16 分钟前不掉落，见 Monster:GetNormalDropPool）
    item_goods_16 = 1
}
--二十分钟后掉落概率
Monster.Item3 = {
    --空
    null = 640,
    --肉搏技能
    item_goods_13 = 300,
    --初级技能书
    item_goods_14 = 30,
    --高级技能书
    item_goods_15 = 40,
    --究极技能书（16 分钟前不掉落，见 Monster:GetNormalDropPool）
    item_goods_16 = 1,
}

Monster.Static = {
    -- 狼王数量
    wolf_num = 4,
    -- 熊王数量
    bear_num = 4,
    -- 风暴领主数量
    dragon = 1,
    -- 地图中间
    map_center = Vector(191.929428, -424.037048, 128.000000)
}
Monster.Pos = {}
