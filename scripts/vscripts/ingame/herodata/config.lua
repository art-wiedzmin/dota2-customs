--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


HeroData.Data = {}
HeroData.Template = {
    id = -1,
    index = -1,
    -- 英雄实体索引
    hero_index = -1,
    -- 死亡次数
    death_num = 0,
    -- 肉搏祝福死亡绿字全属性：死亡瞬间挂 modifier 常无效，复活后一次性结算
    rbzf_death_bonus_pending = 0,
    -- 死亡送宝箱抽：<10 分钟全时段最多 1 次；10–18 分钟（g_min<18）内该来源最多 1 次；≥18 分钟后每次满足死亡次数都送
    box_draw_death_pre10_done = false,
    box_draw_death_10to18_done = false,
    -- 杀敌数
    kill = 0,
    -- 击杀送宝箱抽：游戏时间 <18 分钟时整局最多送 1 次（仍按每 12 杀判定）；≥18 分钟后每满 12 杀不限次数
    box_draw_kill_pre18_done = false,
    --- 本局已通过「生命之书」生效次数（便捷商店 + 背包）；与 smjc 千点加成分开计数
    life_book_applies = 0,
    --- 本局已食用「雷纹结晶」次数
    goods_25_applies = 0,
    --- 雷纹结晶累计 5 次里程碑奖励已发放
    goods_25_milestone_5 = false,
    --- 雷纹结晶累计 10 次里程碑奖励已发放
    goods_25_milestone_10 = false,
    -- 杀怪数
    framer = 0,
    -- 英雄第一次初始化
    init = false,
    name = "",
    star = 0,
    shop = false,
    first_star = true,
    -- 随机星星消费
    cost_star = 0,
    base_star = 0,
    --第一次随机星星
    first_roll = true,
    roll_star = { min = 0, max = 5 },
    roll_count = 0,
    attr = { llcz = 0, mjcz = 0, zlcz = 0 },
    -- 英雄基础的成长
    cost = { llcz = 0, mjcz = 0, zlcz = 0 },
    -- 英雄属性buff
    hero_attr = {
        --回到过去
        hdgq = 0,
        lqjs = 0,
        -- 生命加成
        smjc = 0,
        -- 攻击加成（%）：按白字（基础伤害+主属性）额外加等量 PreAttack 绿字，见 modifier_attr_buff
        gjjc = 0,
        --基础攻击
        jcgj = 0,
        -- 金币加成
        jbjc = 0,
        -- 力量加成
        lljc = 0,
        -- 敏捷加成
        mjjc = 0,
        -- 智力加成
        zljc = 0,
        -- 等级上限
        djsx = 30,
        -- 护甲
        wlkx = 0,
        -- 魔法抗性
        mfkx = 0,
        -- 生命恢复
        smhf = 0,
        -- 基础移速
        jcys = 0,
        -- 经验加成
        jyjc = 0,
        -- 攻击间隔
        gjjg = 0,
        -- 攻击速度
        gjsd = 0,
        -- 最终减伤
        zzjs = 0,
        -- 技能增强
        jnzq = 0,
        -- 攻击距离（modifier_gjjl / utilex:BaseGjjl）
        gjjl = 0,
        -- 基础作用范围（modifier_zyfw / utilex:BaseZyfw，AOE_BONUS_CONSTANT）
        zyfw = 0,
        -- 最终伤害
        zzsh = 0,
        -- 状态抗性
        ztkx = 0,
        -- 杀敌金币
        sdjb = 0,
        -- 物理护甲穿透（%）：0–100，伤害过滤按有效护甲折算补偿，见 HeroData:GetPhysicalArmorPenDamageScale
        wlct = 0,
        -- 物理格挡
        wlgd = 0,
        -- 攻击附带魔法伤害
        mfgj = 0,
        -- 吸血
        gjxx = 0,
        -- 视野加成
        syjc = 0,
        -- 生命增幅（%）
        smzf = 0,
        --- 攻击升级 ability_item_26：满级后击杀英雄的累计层数（删除技能时清零并回收 jcgj/gjjc）
        skill_26_kills = 0,
        --- 万化冥想 ability_item_32：已储存经验（状态栏层数同步）
        skill_32_stored_exp = 0
    },
    -- 金币
    gold = 500,
    -- 伤害
    damage = 0,
    -- 承受伤害
    tank = 0,
    -- 连杀数
    kills_num = 0,
    kills_time = 0,
    tag = {
        tag1 = false,
        tag2 = false,
        tag3 = false,
        tag4 = false,
        tag5 = false,
        tag6 = false,
        tag7 = false,
        tag8 = false,
        tag9 = false,
        tag10 = false,
        tag11 = false,
        tag12 = false,
        tag13 = false,
        tag14 = false,
        tag15 = false,
        --- 死亡后断线：尸体上挂 modifier_petbuff 易失败，复活流程里再补挂
        pending_disconnect_petbuff = false
    },
    hero_bf_2 = {
        jcgjl = 0
    }
}
HeroData.Static = {
    -- 击杀英雄赏金（在金币加成 jbjc 之后结算；基础数额由引擎按等级/连杀等计算）
    -- hero_kill_gold_pct：百分比，100 = 保持原逻辑，50 = 减半，200 = 翻倍
    hero_kill_gold_pct = 100,
    -- hero_kill_gold_flat：每次击杀英雄额外加减固定金币（可填负数）
    hero_kill_gold_flat = 0,
    -- 升级保底星星所需消费金币
    roll_cost = 1250,
    -- UI 显示星级 = star + star_display_bonus（3 颗假星星）
    star_display_bonus = 3,
    -- 真实星星数量上限（显示 20 星 = 17）
    star_limit = 17,
    -- 1500 购买升星真实上限（显示 16 星 = 13；超过后仅 250 随机升星可继续）
    star_purchase_cap = 13,
    -- 真实星级达到该值后，250 随机升星改为概率 +1（显示 16 星 = 13）
    star_roll_high_threshold = 13,
    star_roll_high_chance_pct = 10,
    -- 随机星星价格
    roll_star_price = 250,
    -- 升级星星价格
    level_up_price = 1500,
    -- 属性基础保底(20%)
    base_attr = 20,
    -- 历史：HeroPos 曾按 Rebron 表轮询；现复活/选位已改为圈内随机+中心可达，此项可保留兼容
    reborn_index = 1,
    -- 各档复活时间在 GetRebornTime 计算结果上额外增加的秒数
    reborn_time_extra = 1,
    -- 历史字段
    rebron_num = 20
}
HeroData.Rebron1 = {
    pos1 = Vector(-6529.647949, 6587.524902, 128.000000),
    pos2 = Vector(-6286.942383, 4722.639160, 128.000000),
    pos3 = Vector(-3815.180908, 6537.210938, 128.000000),
    pos4 = Vector(-6583.977539, -1070.720215, 0.000000),
    pos5 = Vector(-450.757935, 6501.365234, 128.000000),
    pos6 = Vector(5365.558105, 4333.780273, 0.000000),
    pos7 = Vector(4579.340820, 6624.495605, 128.000000),
    pos8 = Vector(3555.239990, 4727.228516, 128.000000),
    pos9 = Vector(6857.412598, 3640.889160, 128.000000),
    pos10 = Vector(-1605.743774, 1804.364136, 128.000000),
    pos11 = Vector(7242.862305, 297.585999, 128.000000),
    pos12 = Vector(-5876.666016, -2491.648926, 0.000000),
    pos13 = Vector(3888.024902, 2066.210693, 256.000000),
    pos14 = Vector(-7201.273438, -3496.057617, 128.000000),
    pos15 = Vector(2999.709717, -422.105591, 256.000000),
    pos16 = Vector(-128.855148, -2172.526855, 128.000000),
    pos17 = Vector(1232.402954, -3326.610107, 128.000000),
    pos18 = Vector(5068.639648, -1749.492920, 128.000000),
    pos19 = Vector(-1420.949951, -631.012146, 128.000000),
    pos20 = Vector(4610.246094, -3919.133301, 128.000000),
    pos21 = Vector(-3518.222656, -782.983093, 256.000000),
    pos22 = Vector(7370.242188, -3685.314209, 128.000000),
    pos23 = Vector(-4240.954102, -2771.424316, 128.000000),
    pos24 = Vector(5779.709473, -6505.085938, 256.000000),
    pos25 = Vector(-5829.502441, -4965.269531, 128.000000),
    pos26 = Vector(7077.339355, -7325.924316, 128.000000),
    pos27 = Vector(-3595.107178, -6385.583496, 0.000000),
    pos28 = Vector(3984.310791, -7587.387207, 128.000000),
    pos29 = Vector(-33.974060, -7727.750488, 128.000000),
    pos30 = Vector(738.733826, -6415.809082, 128.000000),
    pos31 = Vector(5888.724121, -6435.418945, 256.000000),
    pos32 = Vector(7271.304199, -7236.738770, 128.000000),
    pos33 = Vector(4051.351562, -7532.243164, 128.000000),
    pos34 = Vector(1078.753662, -6676.901367, 128.000000),
    pos35 = Vector(-3259.090332, -7748.024414, 128.000000),
}
HeroData.Rebron2 = {
    pos1 = Vector(-3778.527344, 913.570740, 256.000000),
    pos2 = Vector(-207.478851, 690.382935, 128.000000),
    pos3 = Vector(-3230.250244, -766.845825, 256.000000),
    pos4 = Vector(-1396.014282, 1673.776001, 128.000000),
    pos5 = Vector(-4310.228516, -1394.026855, 128.000000),
    pos6 = Vector(-2390.540283, 2923.288574, 128.000000),
    pos7 = Vector(-3338.653320, -2521.322998, 128.000000),
    pos8 = Vector(202.836914, 3309.115967, 128.000000),
    pos9 = Vector(-1799.935913, -3167.968262, 128.000000),
    pos10 = Vector(2303.400391, 3143.077148, 0.000000),
    pos11 = Vector(-1534.482544, -4320.911133, 0.000000),
    pos12 = Vector(3953.278809, 1043.563232, 256.000000),
    pos13 = Vector(-74.071564, -3182.151611, 0.000000),
    pos14 = Vector(4511.832031, -1436.992310, 226.294662),
    pos15 = Vector(1071.587036, -3561.559082, 128.000000),
    pos16 = Vector(3046.332764, -682.255676, 256.000000),
    pos17 = Vector(332.365631, -4444.461426, 128.000000),
    pos18 = Vector(3466.805176, -3657.928955, 128.000000),
    pos19 = Vector(1131.932007, -5284.599609, 128.000000),
    pos20 = Vector(2583.667236, -2341.063721, 256.000000)
}

-- 人机（伪玩家）白天/夜晚视野基准，见 modifier_attr_buff OnRefresh（仍会叠加 hero_attr.syjc）
HeroData.BOT_VISION_DAY_NIGHT = 1700
