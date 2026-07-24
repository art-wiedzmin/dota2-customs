--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


Talent.Data = {}
Talent.Template = {
    Init = true,
    --是否已选取天赋装备
    select_talent = false,
    page = false,
    item_index = -1,
    item_name = "",
    hero_name = "",
    bag_page = false,
    -- 当前等级
    level = 0,
    -- 升级剩余数量
    sy = 0,
    -- 总计杀敌数量
    kill = 0,
    -- 上次天赋装备升级时的累计杀敌（本段升级进度 = kill - kill_at_levelup）
    kill_at_levelup = 0,
    -- 升级状态
    up = false,
    -- 属性页面
    attr_page = false,
    -- roll属性值次数
    roll_num = 0,
    attr_list = {
        slot_1 = { state = false, name = "", value = -1, rank = -1 },
        slot_2 = { state = false, name = "", value = -1, rank = -1 },
        slot_3 = { state = false, name = "", value = -1, rank = -1 }
    },
    -- 装备信息
    equip_attr = { attr = {}, text = "" },
    tip_page = false,
    text_page = false,
    -- 自动升级
    auto_levelup = true,
    -- 金币花费
    cost = 0,
    -- 是否可以刷新
    refresh_state = true,
    -- 是否正在进行属性选择
    select_attr = false,
    -- 选天赋装备时英雄尚未出生：延后到出生后补属性与 modifier
    pending_equip_attr = false,
    -- 铁匠：局内改选天赋 3 后是否已补算过既有等级的基础属性 +30%
    clrb_blacksmith_catchup_done = false
}
Talent.Cost = { num1 = 0, num2 = 1, num3 = 9, num4 = 19, num5 = 19 }

-- 天赋装备随机词条：这些英雄永不刷新「视野加成」(syjc)
Talent.AttrRollExcludeSyjcHeroes = {
    npc_dota_hero_monkey_king = true,
    npc_dota_hero_batrider = true,
    -- npc_dota_hero_night_stalker = true,
}

Talent.Equip = {
    item_goods_17 = {
        rank0 = { gjsd = 30, jcys = 15, wlct = 5 },
        rank1 = { gjsd = 15, jcys = 15, wlct = 5 },
        rank2 = { gjsd = 15, jcys = 15, wlct = 5 },
        rank3 = { gjsd = 20, jcys = 15, wlct = 5 },
        rank4 = { gjsd = 30, jcys = 15, wlct = 5 },
        rank5 = { gjsd = 40, jcys = 15, wlct = 5 }
    },
    item_goods_18 = {
        rank0 = { smzf = 3, wlkx = 4 },
        rank1 = { smzf = 3, wlkx = 4 },
        rank2 = { smzf = 3, wlkx = 4 },
        rank3 = { smzf = 3, wlkx = 4 },
        rank4 = { smzf = 3, wlkx = 4 },
        rank5 = { smzf = 3, wlkx = 4 }
    },
    item_goods_19 = {
        rank0 = { jnzq = 4, zyfw = 15 },
        rank1 = { jnzq = 4, zyfw = 15 },
        rank2 = { jnzq = 4, zyfw = 15 },
        rank3 = { jnzq = 4, zyfw = 15 },
        rank4 = { jnzq = 4, zyfw = 15 },
        rank5 = { jnzq = 4, zyfw = 15 }
    },
    item_goods_24 = {
        rank0 = { jcll = 6, jcmj = 6, jczl = 6 },
        rank1 = { jcll = 6, jcmj = 6, jczl = 6 },
        rank2 = { jcll = 6, jcmj = 6, jczl = 6 },
        rank3 = { jcll = 6, jcmj = 6, jczl = 6 },
        rank4 = { jcll = 6, jcmj = 6, jczl = 6 },
        rank5 = { jcll = 6, jcmj = 6, jczl = 6 }
    }
}
--- 各等级段升级所需杀敌数（0→1 … 4→5）；铁匠天赋在此基础上再减免
Talent.Static = { up_0 = 70, up_1 = 90, up_2 = 110, up_3 = 130, up_4 = 150 }
Talent.RollNum = {
    num_1 = { rank_1 = 35, rank_2 = 25, rank_3 = 20, rank_4 = 12, rank_5 = 8 },
    num_2 = { rank_1 = 0, rank_2 = 0, rank_3 = 60, rank_4 = 25, rank_5 = 15 },
    num_3 = { rank_1 = 0, rank_2 = 0, rank_3 = 0, rank_4 = 70, rank_5 = 30 },
    num_4 = { rank_1 = 0, rank_2 = 0, rank_3 = 0, rank_4 = 0, rank_5 = 10 }
}
Talent.Attr = {
    -- 金币加成
    jbjc = { rank_1 = 6, rank_2 = 8, rank_3 = 10, rank_4 = 12, rank_5 = 15 },
    -- 基础敏捷
    jcmj = { rank_1 = 10, rank_2 = 12, rank_3 = 14, rank_4 = 16, rank_5 = 20 },
    -- 基础力量
    jcll = { rank_1 = 10, rank_2 = 12, rank_3 = 14, rank_4 = 16, rank_5 = 20 },
    -- 基础智力
    jczl = { rank_1 = 10, rank_2 = 12, rank_3 = 14, rank_4 = 16, rank_5 = 20 },
    -- 力量加成
    lljc = { rank_1 = 7, rank_2 = 9, rank_3 = 11, rank_4 = 13, rank_5 = 15 },
    -- 敏捷加成
    mjjc = { rank_1 = 7, rank_2 = 9, rank_3 = 11, rank_4 = 13, rank_5 = 15 },
    -- 全属性加成（4/5 级升级池；同时写入 lljc/mjjc/zljc）
    qsxjc = { rank_1 = 4, rank_2 = 5, rank_3 = 6, rank_4 = 7, rank_5 = 8 },
    -- 智力加成
    zljc = { rank_1 = 7, rank_2 = 9, rank_3 = 11, rank_4 = 13, rank_5 = 15 },
    -- 等级上限
    djsx = { rank_1 = 1, rank_2 = 2, rank_3 = 3, rank_4 = 4, rank_5 = 5 },
    -- 护甲
    wlkx = { rank_1 = 6, rank_2 = 8, rank_3 = 10, rank_4 = 12, rank_5 = 14 },
    -- 基础移速
    jcys = { rank_1 = 20, rank_2 = 25, rank_3 = 30, rank_4 = 35, rank_5 = 40 },
    -- 经验加成
    jyjc = { rank_1 = 4, rank_2 = 8, rank_3 = 12, rank_4 = 16, rank_5 = 20 },
    --基础攻击（固定绿字）
    jcgj = { rank_1 = 8, rank_2 = 11, rank_3 = 14, rank_4 = 17, rank_5 = 20 },
    -- 攻击力加成 %（hero_attr.gjjc + modifier_gjjc），数值表与 jcgj 相同
    gjjc = { rank_1 = 8, rank_2 = 11, rank_3 = 14, rank_4 = 17, rank_5 = 20 },
    -- 最终减伤
    zzjs = { rank_1 = 7, rank_2 = 9, rank_3 = 11, rank_4 = 13, rank_5 = 15 },
    -- 技能增强
    jnzq = { rank_1 = 10, rank_2 = 11, rank_3 = 12, rank_4 = 13, rank_5 = 15 },
    -- 攻击距离
    gjjl = { rank_1 = 60, rank_2 = 70, rank_3 = 80, rank_4 = 90, rank_5 = 120 },
    -- 最终伤害
    zzsh = { rank_1 = 5, rank_2 = 6, rank_3 = 7, rank_4 = 8, rank_5 = 10 },
    -- 生命上限
    smjc = {
        rank_1 = 500,
        rank_2 = 600,
        rank_3 = 700,
        rank_4 = 800,
        rank_5 = 1000
    },
    lqjs = { rank_1 = 5, rank_2 = 6, rank_3 = 7, rank_4 = 8, rank_5 = 10 },
    -- 杀敌金币
    sdjb = { rank_1 = 2, rank_2 = 4, rank_3 = 6, rank_4 = 8, rank_5 = 10 },
    -- 物理格挡
    wlgd = { rank_1 = 16, rank_2 = 20, rank_3 = 24, rank_4 = 28, rank_5 = 32 },
    -- 魔法攻击
    mfgj = { rank_1 = 24, rank_2 = 30, rank_3 = 36, rank_4 = 42, rank_5 = 48 },
    -- 吸血
    gjxx = { rank_1 = 2.5, rank_2 = 3, rank_3 = 3.5, rank_4 = 4, rank_5 = 5 },
    -- 视野加成
    syjc = {
        rank_1 = 120,
        rank_2 = 160,
        rank_3 = 200,
        rank_4 = 240,
        rank_5 = 280
    },
    -- 生命增幅（%），仅后两条稀有词条
    smzf = { rank_1 = 6, rank_2 = 8, rank_3 = 10, rank_4 = 12, rank_5 = 15 },
    --魔法抗性
    mfkx = { rank_1 = 7, rank_2 = 9, rank_3 = 11, rank_4 = 13, rank_5 = 15 }
}
Talent.Item = {
    item_goods_17 = {
        rank_1 = {
            jbjc = true,
            mfkx = true,
            -- jcmj = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_2 = {
            jbjc = true,
            mfkx = true,

            -- jcmj = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_3 = {
            jbjc = true,
            mfkx = true,

            -- jcmj = true,
            -- djsx = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_4 = {
            gjjc = true,
            djsx = true,
            zzjs = true,
            jnzq = true,
            gjjl = true,
            zzsh = true,
            mjjc = true,
            -- qsxjc = true,
            smzf = true
        },
        rank_5 = {
            gjjc = true,
            djsx = true,
            zzjs = true,
            jnzq = true,
            gjjl = true,
            zzsh = true,
            mjjc = true,
            -- qsxjc = true,
            smzf = true
        }
    },
    item_goods_18 = {
        rank_1 = {
            jbjc = true,
            mfkx = true,

            -- jcll = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_2 = {
            jbjc = true,
            mfkx = true,

            -- jcll = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_3 = {
            jbjc = true,
            mfkx = true,

            -- jcll = true,
            -- djsx = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_4 = {
            gjjc = true,
            djsx = true,
            zzjs = true,
            jnzq = true,
            gjjl = true,
            zzsh = true,
            lljc = true,
            smzf = true
        },
        rank_5 = {
            gjjc = true,
            djsx = true,
            zzjs = true,
            jnzq = true,
            gjjl = true,
            zzsh = true,
            lljc = true,
            smzf = true
        }
    },
    item_goods_19 = {
        rank_1 = {
            jbjc = true,
            mfkx = true,

            -- jczl = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_2 = {
            jbjc = true,
            mfkx = true,

            -- jczl = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_3 = {
            jbjc = true,
            mfkx = true,

            -- jczl = true,
            -- djsx = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            -- lqjs = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_4 = {
            gjjc = true,
            djsx = true,
            zzjs = true,
            jnzq = true,
            gjjl = true,
            zzsh = true,
            zljc = true,
            smzf = true
        },
        rank_5 = {
            gjjc = true,
            djsx = true,
            zzjs = true,
            jnzq = true,
            gjjl = true,
            zzsh = true,
            zljc = true,
            smzf = true
        }
    },
    item_goods_24 = {
        rank_1 = {
            jbjc = true,
            mfkx = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_2 = {
            jbjc = true,
            mfkx = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_3 = {
            jbjc = true,
            mfkx = true,
            wlkx = true,
            jcys = true,
            jyjc = true,
            smjc = true,
            sdjb = true,
            wlgd = true,
            mfgj = true,
            gjxx = true,
            syjc = true
        },
        rank_4 = {
            gjjc = true,
            djsx = true,
            zzjs = true,
            jnzq = true,
            gjjl = true,
            zzsh = true,
            -- lljc = true,
            qsxjc = true,
            -- zljc = true,
            smzf = true
        },
        rank_5 = {
            gjjc = true,
            djsx = true,
            zzjs = true,
            jnzq = true,
            gjjl = true,
            zzsh = true,
            -- lljc = true,
            qsxjc = true,
            -- zljc = true,
            smzf = true
        }
    }
}
