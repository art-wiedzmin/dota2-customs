--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Shop.Data = {}
Shop.Template = {
    page = false,
    --金币
    gold = 0,
    --月卡剩余天数
    card1 = 0,
    --季卡
    card2 = 0,
    --月卡每日领取状态
    card1day = 0,
    --季卡每日领取状态
    card2day = 0,
    --每日领取状态
    freeday = 0,
    -- 节日礼包：每日免费（1可领 0已领）
    dw_free_day = 1,
    dw_free_open = false,
    dw_free_event_status = "ended",
    -- 节日礼包：付费限购已购次数（每档上限3）
    dw_30_buy = 0,
    dw_68_buy = 0,
    dw_128_buy = 0,
    --双倍重置状态
    double = {
        gold6 = 0,
        gold30 = 0,
        gold68 = 0,
        gold128 = 0,
        gold328 = 0,
        gold648 = 0,
        gold1280 = 0,
    },
    --本局消耗的豆子
    cost = 0,
    --刷新状态
    refresh = true,
    -- 全服首充双倍是否开启（与服务器 first_recharge_double_open 一致，仅影响商城展示用 double）
    first_recharge_double_open = true,
    --通行证数据（与服务端 card 表字段一致）
    card = {
        -- 高级通行证是否激活：0否 1是
        state = 0,
        -- 玩家当前通行证经验总和
        exp = 0,
        -- 已领取奖励到达的等级
        get_level = 0,
        -- 进阶轨道已领取奖励到达的等级
        get_level_premium = 0,
        -- 每日游玩场数
        daygamecount = 0,
        -- 每日累计杀敌数
        daykillcount = 0,
        -- 每日获得队伍第一名次数
        daytop1count = 0,
        -- 每周任意模式获得队伍第一名次数（与每日 daytop1count 一致）
        weektop1count = 0,
        -- 每周累计杀敌数
        weekkillcount = 0,
        -- rank_1v1 模式获得第一名次数
        weekmap1top1 = 0,
        -- rank_3x4 模式获得第一名次数
        weekmap2top1 = 0,
        -- rank_5v5 模式获得第一名次数
        weekmap3top1 = 0,
        -- 每日任务1是否已领取奖励：0否 1是
        taskday1 = 0,
        -- 每日任务2是否已领取奖励：0否 1是
        taskday2 = 0,
        -- 每日任务3是否已领取奖励：0否 1是
        taskday3 = 0,
        -- 每日任务4是否已领取奖励：0否 1是
        taskday4 = 0,
        -- 每日任务5是否已领取奖励：0否 1是
        taskday5 = 0,
        -- 每日任务6是否已领取奖励：0否 1是
        taskday6 = 0,
        -- 每周任务1是否已领取奖励：0否 1是
        taskweed1 = 0,
        -- 每周任务2是否已领取奖励：0否 1是
        taskweed2 = 0,
        -- 每周任务3是否已领取奖励：0否 1是
        taskweed3 = 0,
        -- 每周任务4是否已领取奖励：0否 1是
        taskweed4 = 0,
        -- 每周任务5是否已领取奖励：0否 1是
        taskweed5 = 0,
        taskweed6 = 0,
    },
    -- 局外背包（/bag/sync）
    bag = {
        items = {},
        loadout = {
            equipped_title = nil,
            equipped_effect = nil,
            equipped_attack_effect = nil,
            equipped_pet = nil,
        },
    },
    -- 服务端已确认佩戴快照（与 bag.loadout 对比判断是否有未同步改动）
    bag_loadout_server = {
        equipped_title = nil,
        equipped_effect = nil,
        equipped_attack_effect = nil,
        equipped_pet = nil,
    },
    bag_loadout_dirty = false,
}
Shop.Static = {

}
Shop.Goods = {
    --月卡
    goods_1 = {
        id = 1,
        price = 30,
    },
    goods_2 = {
        id = 2,
        price = 6,
    },
    goods_3 = {
        id = "goods3",
        price = 30,
    },
    goods_4 = {
        id = "goods4",
        price = 68,
    },
    goods_5 = {
        id = "goods5",
        price = 128,
    },
    goods_6 = {
        id = "goods6",
        price = 328,
    },
    goods_7 = {
        id = "goods7",
        price = 648,
    },
    goods_10 = {
        id = "goods10",
        price = 1280,
    },
    goods_8 = {
        id = "goods8",
        price = 88,
    },
    -- 高级通行证（card3，仅可购买一次）
    goods_9 = {
        id = "goods9",
        price = 98,
    },
}
--通行证的相关参数
Shop.CardStaticData = {
    -- 每升 1 级所需通行证经验
    xp_per_level = 500,
    -- 购买通行证后立即获得的通行证经验
    purchase_xp_bonus = 5000,
    -- 等级上限与奖励预览（每 50 级为一阶段翻页展示，最高 200）
    max_level = 200,          -- 战令封顶等级
    preview_phase_size = 50,  -- 每阶段 50 级（49 列滚动 + 1 列固定）
    preview_initial_max = 50, -- 初始预览第 1 阶段（1~50 级）
    -- 普通轨道奖励
    free = {
        gold_per_level = 40, -- 每级奖励金豆
        gold_every_10 = 80,  -- 等级为 10 的倍数时奖励金豆
        title_by_level = {   -- 指定等级奖励称号（仅 30 级）
            [30] = "丛林行者",
        },
    },
    -- 激活通行证后的额外奖励
    premium = {
        gold_per_level = 80,            -- 每级奖励金豆
        gold_every_10 = 160,            -- 等级为 10 的倍数时奖励金豆
        hero_pick_every_10 = 1,         -- 等级为 10 的倍数时额外奖励英雄自选卡数量
        can_deduct_ladder_point = true, -- 英雄自选卡可扣天梯分
        title_by_level = {             -- 指定等级奖励称号（仅 30 级）
            [30] = "横扫八荒",
        },
        effect_by_level = {          -- 指定等级奖励攻击弹道特效（仅 1 级）
            [1] = "流星火矢",
        },
    },
}
-- 通行证任务相关参数
Shop.CardTaskData = {
    -- 每日任务（每日重置）
    daily = {
        login = {
            desc = "登录丛林激战",
            xp = 50,
        },
        play_2 = {
            desc = "完成一局任意模式游戏",
            xp = 50,
            target = 1, -- 需完成局数
        },
        play_5 = {
            desc = "完成三局任意模式游戏",
            xp = 100,
            target = 3,
        },
        win_1 = {
            desc = "任意模式游戏获取队伍第一名",
            xp = 200,
            target = 1, -- 需获胜局数
        },
        kills_100 = {
            desc = "任意模式游戏累计杀敌100人",
            xp = 200,
            target = 100,
        },
        kills_200 = {
            desc = "任意模式游戏累计杀敌200人",
            xp = 500,
            target = 200,
        },
    },
    -- 每周任务（每周重置）
    weekly = {
        solo_win_1 = {
            desc = "任意模式游戏累计获取队伍第一名二次",
            xp = 500,
            target = 2,
        },
        duo_win_4 = {
            desc = "任意模式游戏累计获取队伍第一名四次",
            xp = 500,
            target = 4,
        },
        team5_win_8 = {
            desc = "任意模式游戏累计获取队伍第一名八次",
            xp = 500,
            target = 8,
        },
        kills_500 = {
            desc = "任意模式游戏累计杀敌500人",
            xp = 1000,
            target = 500,
        },
        kills_1000 = {
            desc = "任意模式游戏累计杀敌1000人",
            xp = 1000,
            target = 1000,
        },
        kills_2000 = {
            desc = "任意模式游戏累计杀敌2000人",
            xp = 2000,
            target = 2000,
        },
    },
}

--游戏内道具列表(道具类型)
Shop.ItemList = {
    gold = {
        id = 100,
        name = "金豆",
        type = 0,
        stack = true,
        slot = nil,
        icon = "raw://resource/flash3/images/card/jl1.png",
        text = "可用于随机英雄，抽取宝箱装备，刷新装备词条。",
    },
    hero_pick = {
        id = 1,
        name = "英雄自选卡",
        type = 1,
        stack = true,
        slot = nil,
        icon = "raw://resource/flash3/images/card/herocard.png",
        text = "可在选择英雄界面使用，解锁任意英雄自选。",
    },
    prophecy_card = {
        id = 7,
        name = "预言卡",
        type = 1,
        stack = true,
        slot = nil,
        icon = "raw://resource/flash3/images/achive/yyk.png",
        text = "开局2分钟内可以预言，如果游戏结算时获得了第一名，获得888金豆。",
    },
    title_clxx = {
        id = 2,
        name = "丛林新秀",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_clxx.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_clxx_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_wrnd = {
        id = 5,
        name = "无人能挡",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_wrnd.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_wrnd_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_whcl = {
        id = 8,
        name = "卧虎藏龙",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_whcl.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_whcl_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_clxz = {
        id = 9,
        name = "丛林行者",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_clxz.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_clxz_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_wszs = {
        id = 10,
        name = "无双战神",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_wszs.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_wszs_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_hsbh = {
        id = 11,
        name = "横扫八荒",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_hsbh.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_hsbh_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_hdlm = {
        id = 13,
        name = "横刀立马",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_hdlm.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_hdlm_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_ysqwh = {
        id = 14,
        name = "一醉轻王侯",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_ysqwh.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_ysqwh_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_rzlf = {
        id = 15,
        name = "人中龙凤",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_rzlf.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_rzlf_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_clls = {
        id = 16,
        name = "丛林猎手",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_clls.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_clls_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_cllr = {
        id = 17,
        name = "丛林猎人",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_cllr.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_cllr_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_clzw = {
        id = 18,
        name = "丛林之王",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_clzw.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_clzw_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_clmy = {
        id = 19,
        name = "丛林梦魇",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_clmy.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_clmy_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_clzy = {
        id = 20,
        name = "丛林之翼",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_clzy.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_clzy_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_xxqc = {
        id = 21,
        name = "血洗全场",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_xxqc.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_xxqc_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    title_rzzl = {
        id = 22,
        name = "人中之龙",
        type = 2,
        stack = false,
        slot = "title",
        icon = "raw://resource/flash3/images/card/ch_rzzl.png",
        titleIcon = true,
        titleParticle = "particles/clrb/clrb_equip_title_rzzl_loop.vpcf",
        text = "头顶称号特效，可在背包内佩戴。",
    },
    effect_tx1 = {
        id = 6,
        name = "燃烧末日",
        type = 3,
        stack = false,
        slot = "effect",
        icon = "raw://resource/flash3/images/card/tx1.png",
        effectParticle = "particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf",
        text = "周身特效，可在背包内佩戴。",
    },
    effect_lzqz = {
        id = 23,
        name = "离子之气",
        type = 3,
        stack = false,
        slot = "effect",
        icon = "raw://resource/flash3/images/card/tx_lzzq.png",
        effectParticle = "particles/courier_platinum_roshan/platinum_roshan_ambient.vpcf",
        text = "周身特效，可在背包内佩戴。",
    },
    effect_txhb = {
        id = 24,
        name = "嬉戏蝴蝶",
        type = 3,
        stack = false,
        slot = "effect",
        icon = "raw://resource/flash3/images/card/tx_xxhd.png",
        effectParticle = "particles/courier_shagbark/courier_shagbark_ambient.vpcf",
        text = "周身特效，可在背包内佩戴。",
    },
    attack_lxhs = {
        id = 12,
        name = "流星火矢",
        type = 5,
        stack = false,
        slot = "attack_effect",
        icon = "raw://resource/flash3/images/card/txz_lxhs.png",
        attackEffectKey = "atv2",
        text = "攻击弹道特效，可在背包内佩戴。",
    },
    attack_atv3 = {
        id = 25,
        name = "碧光流矢",
        type = 5,
        stack = false,
        slot = "attack_effect",
        icon = "raw://resource/flash3/images/card/tx_bgls.png",
        attackEffectKey = "atv1",
        text = "攻击弹道特效，可在背包内佩戴。",
    },
    effect_blue = {
        id = 3,
        name = "幽蓝冰焰",
        type = 3,
        stack = false,
        slot = "effect",
        icon = "file://{images}/card/bg3.png",
        text = "周身特效，可在背包内佩戴。",
    },
    pet_meat = {
        id = 4,
        name = "小肉山",
        type = 4,
        stack = false,
        slot = "pet",
        icon = "file://{images}/card/card2.png",
        text = "跟随宠物，可在背包内佩戴。",
    },
    pet_baby_rosh = {
        id = 104,
        name = "肉山宝宝",
        type = 4,
        stack = false,
        slot = "pet",
        previewUnit = "CardPet",
        modelPath = "models/courier/baby_rosh/babyroshan.vmdl",
        text = "默认跟随宠物，创建账号后自动获得，可佩戴或卸下。",
    },
    pet_ti10_rosh = {
        id = 105,
        name = "跨纬度肉山宝宝",
        type = 4,
        stack = false,
        slot = "pet",
        icon = "raw://resource/flash3/images/achive/pet.png",
        previewUnit = "CardPetTi10",
        modelPath = "models/courier/baby_rosh/babyroshan_ti10_flying.vmdl",
        petParticle = "particles/econ/courier/courier_babyroshan_ti10/courier_babyroshan_ti10_ambient.vpcf",
        text = "跟随宠物，可在背包内佩戴。",
    },
}
