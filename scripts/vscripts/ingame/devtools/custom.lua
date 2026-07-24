--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 自定义工具：在此 RegisterTool，与内置指令相同方式扩展
-- 称号 / 周身 / 攻击特效：点击即自动替换当前效果，不再提供「移除 xxx」按钮
function DevTools:RegisterCustomTools()
    self:RegisterTool("fallstar", "陨落星辰", function()
        if MainGame and MainGame.DropFallenStars then
            MainGame:DropFallenStars()
        end
    end, { group = "事件" })

    local function add_title(cmd, label, item_key)
        self:RegisterTool(cmd, label, function(ID, hero)
            if DevTools.GrantTitleAndEquip then
                DevTools:GrantTitleAndEquip(ID, hero, item_key)
            end
        end, { group = "称号" })
    end

    add_title("clxx", "丛林新秀称号", "title_clxx")
    add_title("wrnd", "无人能挡称号", "title_wrnd")
    add_title("whcl", "卧虎藏龙称号", "title_whcl")
    add_title("clxz", "丛林行者称号", "title_clxz")
    add_title("wszs", "无双战神称号", "title_wszs")
    add_title("hsbh", "横扫八荒称号", "title_hsbh")
    add_title("hdlm", "横刀立马称号", "title_hdlm")
    add_title("ysqwh", "一醉轻王侯称号", "title_ysqwh")
    add_title("rzlf", "人中龙凤称号", "title_rzlf")
    add_title("clls", "丛林猎手称号", "title_clls")
    add_title("cllr", "丛林猎人称号", "title_cllr")
    add_title("clzw", "丛林之王称号", "title_clzw")
    add_title("clmy", "丛林梦魇称号", "title_clmy")
    add_title("clzy", "丛林之翼称号", "title_clzy")
    add_title("xxqc", "血洗全场称号", "title_xxqc")
    add_title("rzzl", "人中之龙称号", "title_rzzl")

    -- 周身特效预览：切换时统一走 ApplyEffectFx，先清旧再挂新，不叠加
    -- 铂金肉山：只挂 ambient 父特效，b/c/d/e/f + eyes 整包子粒子会自动带上
    self:RegisterTool("txp", "铂金肉山周身", function(ID, hero)
        if DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/clrb/platinum_roshan_ambient.vpcf",
                "已切换：铂金肉山周身（整包）")
        end
    end, { group = "周身特效" })

    self:RegisterTool("tx1", "燃烧末日周身特效", function(ID, hero)
        if DevTools.GrantEffectAndEquip then
            DevTools:GrantEffectAndEquip(ID, hero, "effect_tx1")
        elseif DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf",
                "已切换：燃烧末日")
        end
    end, { group = "周身特效" })

    self:RegisterTool("tx3", "熔岩肉山周身", function(ID, hero)
        if DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf",
                "已切换：熔岩肉山周身")
        end
    end, { group = "周身特效" })

    self:RegisterTool("txf", "急雪拖尾周身", function(ID, hero)
        if DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/clrb/courier_trail_flurry.vpcf",
                "已切换：急雪拖尾（请移动英雄查看拖尾）")
        end
    end, { group = "周身特效" })

    self:RegisterTool("txhb", "嬉戏蝴蝶", function(ID, hero)
        if DevTools.GrantEffectAndEquip then
            DevTools:GrantEffectAndEquip(ID, hero, "effect_txhb")
        elseif DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/courier_shagbark/courier_shagbark_ambient.vpcf",
                "已切换：嬉戏蝴蝶")
        end
    end, { group = "周身特效" })

    self:RegisterTool("txqh", "离子之气", function(ID, hero)
        if DevTools.GrantEffectAndEquip then
            DevTools:GrantEffectAndEquip(ID, hero, "effect_lzqz")
        elseif DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/courier_platinum_roshan/platinum_roshan_ambient.vpcf",
                "已切换：离子之气")
        end
    end, { group = "周身特效" })

    self:RegisterTool("v4", "徽章默认周身", function(ID, hero)
        if DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/econ/events/diretide_2020/emblem/fall20_emblem_effect.vpcf",
                "已切换：徽章默认")
        end
    end, { group = "周身特效" })

    self:RegisterTool("v3", "徽章 v3 周身", function(ID, hero)
        if DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf",
                "已切换：徽章 v3")
        end
    end, { group = "周身特效" })

    self:RegisterTool("v2", "徽章 v2 周身", function(ID, hero)
        if DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf",
                "已切换：徽章 v2")
        end
    end, { group = "周身特效" })

    self:RegisterTool("v1", "徽章 v1 周身", function(ID, hero)
        if DevTools.PreviewBodyEffect then
            DevTools:PreviewBodyEffect(ID, hero,
                "particles/econ/events/diretide_2020/emblem/fall20_emblem_v1_effect.vpcf",
                "已切换：徽章 v1")
        end
    end, { group = "周身特效" })

    self:RegisterTool("atv1", "攻击特效 v1", function(ID, hero)
        if DevTools.GrantAttackEffect then
            DevTools:GrantAttackEffect(ID, hero, "atv1", "已添加攻击特效 v1")
        end
    end, { group = "攻击特效" })

    self:RegisterTool("atv2", "攻击特效 v2", function(ID, hero)
        if DevTools.GrantAttackEffect then
            DevTools:GrantAttackEffect(ID, hero, "atv2", "已添加攻击特效 v2")
        end
    end, { group = "攻击特效" })

    self:RegisterTool("atv3", "攻击特效 v3", function(ID, hero)
        if DevTools.GrantAttackEffect then
            DevTools:GrantAttackEffect(ID, hero, "atv3", "已添加攻击特效 v3")
        end
    end, { group = "攻击特效" })
end
