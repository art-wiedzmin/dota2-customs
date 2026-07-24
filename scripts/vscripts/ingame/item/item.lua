--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Item == nil then
    Item = class({})
    require("ingame.Item.Config")
end

LinkLuaModifier("modifier_item_10", "ingame/modifier/modifier_item_10",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_11", "ingame/modifier/modifier_item_11",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_12", "ingame/modifier/modifier_item_12",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_26", "ingame/modifier/modifier_item_26",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_goods_25", "ingame/modifier/modifier_goods_25",
    LUA_MODIFIER_MOTION_NONE)

function Item:Init(ID)
    if not ID then return end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

function Item:GetItemTx(item_name)
    if not item_name then return end
    local tx = self.Tx[item_name]
    return tx
end

function Item:ReleaseGoods25Pfx(fx, delay)
    if not fx then
        return
    end
    Timers(delay or 2, function()
        ParticleManager:DestroyParticle(fx, false)
        ParticleManager:ReleaseParticleIndex(fx)
    end)
end

function Item:PlayGoods25ZeusBoltFx(hero)
    if not hero or hero:IsNull() then
        return
    end
    local cfg = self.Goods25Fx or {}
    local pos = hero:GetAbsOrigin()
    local sky_z = cfg.sky_z or 2000
    local sky = pos + Vector(0, 0, sky_z)

    if cfg.start then
        local fx_start = ParticleManager:CreateParticle(cfg.start, PATTACH_ABSORIGIN_FOLLOW, hero)
        self:ReleaseGoods25Pfx(fx_start, 1.5)
    end

    if cfg.cast then
        local fx_cast = ParticleManager:CreateParticle(cfg.cast, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(fx_cast, 0, pos)
        self:ReleaseGoods25Pfx(fx_cast, 2.5)
    end

    if cfg.bolt then
        local fx_bolt = ParticleManager:CreateParticle(cfg.bolt, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(fx_bolt, 0, pos)
        ParticleManager:SetParticleControl(fx_bolt, 1, sky)
        ParticleManager:SetParticleControl(fx_bolt, 2, pos)
        self:ReleaseGoods25Pfx(fx_bolt, 2)
    end

    if cfg.glow then
        local fx_glow = ParticleManager:CreateParticle(cfg.glow, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(fx_glow, 0, pos)
        ParticleManager:SetParticleControl(fx_glow, 1, sky)
        ParticleManager:SetParticleControl(fx_glow, 2, pos)
        self:ReleaseGoods25Pfx(fx_glow, 2)
    end
end

function Item:PlayGoods25ThunderFx(hero)
    if not hero or hero:IsNull() then
        return
    end
    self:PlayGoods25ZeusBoltFx(hero)
    local pos = hero:GetAbsOrigin()
    if Monster and Monster.PlayLightningBelieverSpawnFx then
        Monster:PlayLightningBelieverSpawnFx(pos, hero)
    end
    if MainGame and MainGame.Weather6PlayThunderStrikeOnHero then
        MainGame:Weather6PlayThunderStrikeOnHero(hero)
    end
end

function Item:Goods25SelfStrikeDamage(hero, item)
    if not hero or hero:IsNull() or not hero:IsAlive() then
        return
    end
    local damage = math.floor(hero:GetMaxHealth() * 0.10)
    if damage <= 0 then
        return
    end
    ApplyDamage({
        attacker = hero,
        victim = hero,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = item,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    })
end

-- 英雄添加一件装备
function Item:AddItem(ID, item_name)
    if not ID or not item_name then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    local bag_item = Item:FindItem(ID, item_name)
    if bag_item then
        bag_item:SetCurrentCharges(bag_item:GetCurrentCharges() + 1)
        return bag_item
    end
    local item = CreateItem(item_name, hero, hero)
    if not item or item:IsNull() then
        return
    end
    if not hero:AddItem(item) then
        CreateItemOnPositionSync(hero:GetAbsOrigin(), item)
    end
    -- print("bbbbbbbbbbbbbb")
    if OverStat and OverStat.RecordItemGain then
        -- print("cccccccccccc")
        OverStat:RecordItemGain(ID, item_name)
        -- print("dddddddddddddd")
    end
    return item
end

-- 是否可以直接使用
function Item:IsUseItem(item_name)
    for k, v in pairs(self.Static.use) do
        if item_name == v then return true end
    end
end

function Item:IsHaveItem(ID, item_name)
    if not ID or not item_name then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    for i = 0, 15 do
        local item = hero:GetItemInSlot(i)
        if item and item:GetName() == item_name then return true end
    end
end

function Item:FindItem(ID, item_name)
    if not ID or not item_name then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    for i = 0, 15 do
        local item = hero:GetItemInSlot(i)
        if item and item:GetName() == item_name then return item end
    end
end

function Item:UseItem(hero, item)
    if not hero or not item then return end
    local item_name = item:GetName()
    local ID = Util:Hero2ID(hero)
    if item_name == "item_goods_1" then
        HeroData:RollStar(ID)
        PlayerResource:ModifyGold(ID, HeroData.Static.roll_star_price, false, 0)
    end
    if item_name == "item_goods_2" then
        HeroData:LevelStar(ID)
        PlayerResource:ModifyGold(ID, HeroData.Static.roll_cost, false, 0)
    end
    hero:EjectItemFromStash(item)
end

function Item:IsStackItem(item_name)
    for k, v in pairs(self.Stack) do if item_name == v then return true end end
end

function Item:IsStackSkill(item_name)
    for k, v in pairs(self.StackSkill) do if item_name == v then return true end end
end

function AddEquip(key) -- print("装备物品")
end

function UseEquip(key)
    local hero = key.unit
    local ID = Util:Hero2ID(hero)
    local caster = key.caster
    local item = key.ability
    local item_name = item:GetName()
    -- 黑黄杖
    if item_name == "item_equip_1" then
        LinkLuaModifier("modifier_equip_1", "ingame/modifier/modifier_equip_1",
            LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_equip_1", { duration = 5 })
    end
    -- 刷新球
    if item_name == "item_equip_2" then
        local tx = "particles/items2_fx/refresher.vpcf"
        utilex:AddTx(tx, hero, 1)
        EmitSoundOn("DOTA_Item.Refresher.Activate", hero)
        for i = 0, hero:GetAbilityCount() - 1 do
            local ability = hero:GetAbilityByIndex(i)
            if ability and not ability:IsNull() then
                local ability_name = ability:GetAbilityName()
                -- 跳过某些不应该刷新的技能
                if Skill:IsSkill(ability_name) then
                    -- 结束冷却
                    ability:EndCooldown()
                    -- 重置充能（如果有）
                    -- if ability:GetCurrentCharges() then
                    --     if ability:GetCurrentCharges() < ability:GetMaxCharges() then
                    --         ability:RefundManaCost()
                    --     end
                    -- end
                end
            end
        end
        for i = 0, 5 do
            local item = hero:GetItemInSlot(i)
            if item then
                local item_name = item:GetName()
                if item_name ~= "item_equip_2" then
                    item:EndCooldown()
                end
            end
        end
    end
end

function UseSkill(key)
    -- print("使用肉搏技能书")
    local hero = key.unit
    local ID = Util:Hero2ID(hero)
    local caster = key.caster
    local item = key.ability
    local item_name = item:GetName()
    if MainGame and MainGame.IsPassiveModeBannedPurchaseItem
        and MainGame:IsPassiveModeBannedPurchaseItem(item_name) then
        Util:BottomMsg2ID(ID, "被动模式下不可使用该技能书", "red", 1)
        return
    end
    if Skill:AddSkill2(ID, item_name) then
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
end

function LeaderItemUse(key)
    -- print(key)
    local hero = key.unit
    local ID = Util:Hero2ID(hero)
    local caster = key.caster
    local item = key.ability
    local item_name = item:GetName()
    if item_name == "item_goods_0" then
        Talent:OpenPage(ID)
        UTIL_Remove(item)
    end
    if item_name == "item_goods_10" then
        local buff_name = "modifier_item_10"
        if hero:HasModifier(buff_name) then
            return Util:BottomMsg2ID(ID, "同类物品仅能使用一次",
                "yellow")
        end
        hero:AddNewModifier(hero, -- 施法者
            nil,                  -- 技能
            buff_name,            -- 修饰器名称
            {}                    -- 参数
        )
        EmitSoundOn("Item.MoonShard.Consume", hero)
        HeroData:AddSX(ID, "jcys", 20)
        UTIL_Remove(item)
    end
    if item_name == "item_goods_11" then
        local buff_name = "modifier_item_11"
        if hero:HasModifier(buff_name) then
            return Util:BottomMsg2ID(ID, "同类物品仅能使用一次",
                "yellow")
        end
        -- HeroData:AddSX(ID, "gjjc", 20)
        -- HeroData:AddSX(ID, "jnzq", 10)
        HeroData:AddSX(ID, "wlkx", 15)
        HeroData:AddSX(ID, "smjc", 1000)
        HeroData:AddSX(ID, "mfkx", 20)
        -- HeroData:AddSX(ID,"wlkx",15)
        hero:AddNewModifier(hero, -- 施法者
            nil,                  -- 技能
            buff_name,            -- 修饰器名称
            {}                    -- 参数
        )
        EmitSoundOn("Item.MoonShard.Consume", hero)
        UTIL_Remove(item)
    end
    if item_name == "item_goods_12" then
        local buff_name = "modifier_item_12"
        if hero:HasModifier(buff_name) then
            return Util:BottomMsg2ID(ID, "同类物品仅能使用一次",
                "yellow")
        end
        EmitSoundOn("Item.MoonShard.Consume", hero)
        HeroData:AddSX(ID, "ztkx", 20)
        HeroData:AddSX(ID, "hdgq", 10)
        hero:AddNewModifier(hero, -- 施法者
            nil,                  -- 技能
            buff_name,            -- 修饰器名称
            {}                    -- 参数
        )
        UTIL_Remove(item)
    end
    if item_name == "item_goods_14" then
        if Skill:UseBook(ID, "T2") then
            if item:GetCurrentCharges() > 1 then
                item:SetCurrentCharges(item:GetCurrentCharges() - 1)
            else
                UTIL_Remove(item)
            end
        end
    end
    if item_name == "item_goods_15" then
        if Skill:UseBook(ID, "T1") then
            if item:GetCurrentCharges() > 1 then
                item:SetCurrentCharges(item:GetCurrentCharges() - 1)
            else
                UTIL_Remove(item)
            end
        end
    end
    if item_name == "item_goods_16" then
        if Skill:UseBook(ID, "T0") then
            if item:GetCurrentCharges() > 1 then
                item:SetCurrentCharges(item:GetCurrentCharges() - 1)
            else
                UTIL_Remove(item)
            end
        end
    end
    if item_name == "item_goods_3" then
        if hero:GetBaseStrength() <= 10 then
            return Util:BottomMsg2ID(ID, "力量不足", "red")
        end
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
        hero:ModifyStrength(-10)
        hero:ModifyAgility(10)
    end
    if item_name == "item_goods_4" then
        if hero:GetBaseStrength() <= 10 then
            return Util:BottomMsg2ID(ID, "力量不足", "red")
        end
        hero:ModifyStrength(-10)
        hero:ModifyIntellect(10)
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
    if item_name == "item_goods_5" then
        if hero:GetBaseAgility() <= 10 then
            Util:BottomMsg2ID(ID, "敏捷不足", "red")
            return
        end
        hero:ModifyStrength(10)
        hero:ModifyAgility(-10)
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
    if item_name == "item_goods_6" then
        if hero:GetBaseAgility() <= 10 then
            Util:BottomMsg2ID(ID, "敏捷不足", "red")
            return
        end
        hero:ModifyAgility(-10)
        hero:ModifyIntellect(10)
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
    if item_name == "item_goods_7" then
        if hero:GetBaseIntellect() <= 10 then
            Util:BottomMsg2ID(ID, "智力不足", "red")
            return
        end
        hero:ModifyStrength(10)
        hero:ModifyIntellect(-10)
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
    if item_name == "item_goods_8" then
        if hero:GetBaseIntellect() <= 10 then
            Util:BottomMsg2ID(ID, "智力不足", "red")
            return
        end
        hero:ModifyAgility(10)
        hero:ModifyIntellect(-10)
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
    if item_name == "item_goods_9" then
        -- print("获得技能点")
        local point = hero:GetAbilityPoints()
        local add_point = point + 1
        hero:SetAbilityPoints(add_point)
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
    if item_name == "item_goods_20" then
        -- print("删除肉搏技能")
        if Skill:OpenDelSkill(ID) then
            if item:GetCurrentCharges() > 1 then
                item:SetCurrentCharges(item:GetCurrentCharges() - 1)
            else
                UTIL_Remove(item)
            end
        end
    end
    if item_name == "item_goods_21" then
        if not HeroData:TryApplyLifeBookSmjc(ID) then
            Util:BottomMsg2ID(ID, "本局生命之书加成次数已达上限", "orange", 2)
            return
        end
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
    if item_name == "item_goods_25" then
        Item:PlayGoods25ThunderFx(hero)
        Item:Goods25SelfStrikeDamage(hero, item)
        HeroData:ApplyGoods25Consume(ID, hero)
        UTIL_Remove(item)
    end
    if item_name == "item_goods_26" then
        local buff_name = "modifier_item_26"
        if hero:HasModifier(buff_name) then
            return Util:BottomMsg2ID(ID, "同类物品仅能使用一次", "yellow")
        end
        HeroData:AddSX(ID, "smjc", 1500)
        HeroData:AddSX(ID, "lljc", 20)
        HeroData:AddSX(ID, "mjjc", 20)
        HeroData:AddSX(ID, "zljc", 20)
        HeroData:AddSX(ID, "zzsh", 10)
        hero:AddNewModifier(hero, nil, buff_name, {})
        EmitSoundOn("Item.MoonShard.Consume", hero)
        UTIL_Remove(item)
    end
    if item_name == "item_goods_23" then
        if not HeroData:TryAddStarFromItem(ID) then
            return
        end
        if item:GetCurrentCharges() > 1 then
            item:SetCurrentCharges(item:GetCurrentCharges() - 1)
        else
            UTIL_Remove(item)
        end
    end
end

function TianShuItemUse(key)
    local hero = key.unit
    local item = key.ability
    if not hero or not item then
        return
    end
    local ID = Util:Hero2ID(hero)
    if not ID then
        return
    end
    if item:GetCurrentCharges() > 1 then
        item:SetCurrentCharges(item:GetCurrentCharges() - 1)
    else
        UTIL_Remove(item)
    end
    if EazyShop and EazyShop.OpenTianShuPickerFromItem then
        EazyShop:OpenTianShuPickerFromItem(ID)
    end
end
