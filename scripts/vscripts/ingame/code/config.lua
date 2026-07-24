--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Code.Data = {}
-- 与服务端 gameRechargeDelivery.js 金豆倍数保持一致
Code.FIRST_CHARGE_GOLD_MULT = 3
Code.RECHARGE_GOLD_MULT = 2
-- 月卡 / 季卡附赠金豆（与 clrb_server gameRechargeDelivery 固定发放一致）
Code.MONTH_CARD_GOLD_BONUS = 300
Code.CARD2_GOLD_BONUS = 900
-- 充值成功弹窗 redeem_rows 金豆图标（与 Shop.lua 兑换一致）
Code.PAY_REWARD_GOLD_ICON = "raw://resource/flash3/images/shop/b_cost.png"
-- 通行证经验图标（与 BattlePass 任务经验 icon 一致）
Code.PAY_REWARD_CARD_XP_ICON = "raw://resource/flash3/images/card/taskexp.png"
-- 高级通行证激活图标
Code.PAY_REWARD_CARD_PREMIUM_ICON = "raw://resource/flash3/images/card/zl.png"
Code.Template = {
    --页面开关
    page = false,
    --支付方式（默认为1：微信，2：支付宝）
    pay_type = 1,
    --商品信息
    goods = "",
    --商品名字
    goods_name = "",
    --商品价格
    price = 0,
    --二维码页面显示开关
    pay_page = false,
    --微信订单号（不用展示）
    order1 = "",
    --支付宝订单号（不用展示）
    order2 = "",
    --微信二维码
    ewm1 = "",
    --支付宝二维码
    ewm2 = "",
    -- 购买通行证等级数量（CARD_LEVEL 专用）
    card_level_count = 0,
}
Code.Goods = {
    goods_1 = "MONTH_CARD",
    goods_2 = "DIAMOND_60",
    goods_3 = "DIAMOND_300",
    goods_4 = "DIAMOND_680",
    goods_5 = "DIAMOND_1280",
    goods_6 = "DIAMOND_3280",
    goods_7 = "DIAMOND_6480",
    goods_8 = "CARD2",
    goods_9 = "CARD3",
    goods_10 = "DIAMOND_12800",
    goods_11 = "HOLIDAY_DW_30",
    goods_12 = "HOLIDAY_DW_68",
    goods_13 = "HOLIDAY_DW_128",
}
-- 购买通行证等级：与 CardService / payment 一致，每级 5 元、500 通行证经验
Code.CardLevelProduct = "CARD_LEVEL"
Code.CardLevelPriceYuan = 5
Code.CardLevelXpPerLevel = 500
Code.GoodsPrice = {
    MONTH_CARD = 30,
    DIAMOND_60 = 6,
    DIAMOND_300 = 30,
    DIAMOND_680 = 68,
    DIAMOND_1280 = 128,
    DIAMOND_3280 = 328,
    DIAMOND_6480 = 648,
    DIAMOND_12800 = 1280,
    CARD2 = 88,
    CARD3 = 98,
    HOLIDAY_DW_30 = 30,
    HOLIDAY_DW_68 = 68,
    HOLIDAY_DW_128 = 128,
}
Code.GoodsName = {
    MONTH_CARD = "card1",
    DIAMOND_60 = "gold6",
    DIAMOND_300 = "gold30",
    DIAMOND_680 = "gold68",
    DIAMOND_1280 = "gold128",
    DIAMOND_3280 = "gold328",
    DIAMOND_6480 = "gold648",
    DIAMOND_12800 = "gold1280",
    CARD2 = "card2",
    CARD3 = "card3",
    CARD_LEVEL = "card_level",
    HOLIDAY_DW_30 = "dw_30",
    HOLIDAY_DW_68 = "dw_68",
    HOLIDAY_DW_128 = "dw_128",
}
