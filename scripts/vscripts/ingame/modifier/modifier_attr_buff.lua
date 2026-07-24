--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if modifier_attr_buff == nil then modifier_attr_buff = class({}) end

function modifier_attr_buff:IsDebuff() return false end

-- 是否可以移除
function modifier_attr_buff:IsPurgable() return false end

-- 是否在面板上显示
function modifier_attr_buff:IsHidden() return true end

function modifier_attr_buff:RemoveOnDeath() return false end

-- 幻想是否继承
function modifier_attr_buff:AllowIllusionDuplicate() return false end

function modifier_attr_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

-- 创建时设置
function modifier_attr_buff:OnCreated()
    if not IsServer() then return end
    local pa = self:GetParent()


    local kv = GetUnitKeyValuesByName(pa:GetUnitName())
    if kv then
        self.baseDayVision = tonumber(kv.VisionDaytimeRange) or 1800
        self.baseNightVision = tonumber(kv.VisionNighttimeRange) or 800
    else
        self.baseDayVision = 1800
        self.baseNightVision = 800
    end

    self:OnRefresh()
    self:StartIntervalThink(3)
end

-- 刷新就取值更新
function modifier_attr_buff:OnRefresh()
    if not IsServer() then return end
    local pa = self:GetParent()
    if not pa or not pa:IsRealHero() then return end
    local ID = Util:Hero2ID(pa)
    local tab = HeroData.Data[ID].hero_attr
    if not tab then return end
    -- 拷贝表
    local temp = {}
    for k, v in pairs(tab) do temp[k] = v end
    -- 取三围
    temp.baseSTR = pa:GetBaseStrength()
    temp.baseAGI = pa:GetBaseAgility()
    temp.baseINT = pa:GetBaseIntellect()
    temp.attackDamage = pa:GetAttackDamage()
    self.sx = temp
    -- 视野加成同步到战争迷雾：引擎的 GetBonusDayVision 只影响数值，FOW 需直接设置单位视野范围
    local bonus = temp.syjc or 0
    if pa.SetDayTimeVisionRange and pa.SetNightTimeVisionRange then
        if Util and Util.IsPseudoPlayerID and Util:IsPseudoPlayerID(ID) then
            local baseBot = (HeroData and tonumber(HeroData.BOT_VISION_DAY_NIGHT)) or 1700
            if baseBot < 1 then
                baseBot = 1700
            end
            pa:SetDayTimeVisionRange(baseBot + bonus)
            pa:SetNightTimeVisionRange(baseBot + bonus)
        elseif bonus > 0 then
            pa:SetDayTimeVisionRange(self.baseDayVision + bonus)
            pa:SetNightTimeVisionRange(self.baseNightVision + bonus)
        end
    end
    if utilex and utilex.BaseGjl and ID and HeroData and HeroData.Data and HeroData.Data[ID] then
        utilex:BaseGjl(ID)
    end
    pa:CalculateStatBonus(true)
end

-- 周期自刷新；顺带校正先天装备 talent modifier（如 modifier_talent_3 偶发丢失）
function modifier_attr_buff:OnIntervalThink()
    if not IsServer() then return end
    self:ForceRefresh()
    -- 校正先天装备 modifier（Talent 注释同上）：灼烧等在引擎/换人后偶发被卸，三至秒周期补刷新
    do
        local pa0 = self:GetParent()
        if pa0 and not pa0:IsNull() and pa0:IsRealHero() then
            local TID = Util:Hero2ID(pa0)
            if (not TID or TID < 0) and pa0.GetPlayerOwnerID then
                TID = pa0:GetPlayerOwnerID()
            end
            if TID and TID >= 0 and Talent and Talent.EnsureTalentEquipModifier and Talent.Data
                and Talent.Data[TID] and Talent.Data[TID].select_talent == true
                and (Talent.Data[TID].item_name == "item_goods_19"
                    or Talent.Data[TID].item_name == "item_goods_24") then
                Talent:EnsureTalentEquipModifier(TID)
            end
        end
    end
    local state = MainGame.Data.state
    if state == 1 then
        return
    end
    if MainGame.Data.over then
        return
    end
    local rang
    if state == 2 then
        rang = MainGame.Static.rang1
    end
    if state == 3 then
        rang = MainGame.Static.rang2
    end
    --判断玩家位置，如果玩家在毒圈外，就受到20%最大生命值的伤害
    local pa = self:GetParent()
    if not pa or not pa:IsRealHero() then return end
    local center_pos = Monster.Static.map_center
    local pos = pa:GetAbsOrigin()
    local len = (center_pos - pos):Length2D()
    if len > rang then
        local dummy_att = MainGame:GetDummy()
        local damage = math.floor(pa:GetMaxHealth() * 0.2)
        ApplyDamage({
            attacker = dummy_att or pa,
            victim = pa,
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
        })
    end
end

function modifier_attr_buff:DeclareFunctions()
    return {
        -- 绿字 力量加成%+力量增幅%
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        -- 绿字 敏捷加成%+敏捷增幅%+敏捷常数
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        -- 绿字 智力加成%+智力增幅%+智力常数
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, -- 绿字 回复常数
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, -- 攻击间隔
        -- MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        -- 攻击距离：modifier_gjjl（HeroData:AddSX -> utilex:BaseGjjl）
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        -- 弹道速度加成（修复近战英雄学魔化/变龙/月刃时弹道速度为0导致技能无效的bug）
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,   -- 护甲
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,     -- 白字 常数移动速度
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, -- 绿字 攻击力常数
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        -- 生命增幅% 改由 modifier_smzf（utilex:BaseSmzf）处理
        -- MODIFIER_PROPERTY_HEALTH_BONUS,
        -- 绿字 回复常数
        -- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        -- 攻击速度常数
        -- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        -- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

-- function modifier_attr_buff:GetModifierConstantHealthRegen()
-- 	if not self.sx then return end
-- 	return self.sx.smhf
-- end

-- function modifier_attr_buff:GetModifierMagicalResistanceBonus()
--     return 0.05
-- end

-- 绿字攻击力常数 jcgj 仅由 modifier_gjljc（utilex:BaseGjl）提供，避免与 modifier_attr_buff 重复叠加
function modifier_attr_buff:GetModifierPreAttack_BonusDamage()
    return 0
end

-- 绿字 力量加成%/力量增幅% 血量超21E有问题
function modifier_attr_buff:GetModifierBonusStats_Strength()
    if not self.sx then return end
    local lljc = math.floor((self.sx.baseSTR * self.sx.lljc) / 100)
    return lljc
end

-- 绿字 敏捷加成%+敏捷增幅%+敏捷常数
function modifier_attr_buff:GetModifierBonusStats_Agility()
    if not self.sx then return end
    local mjjc = math.floor((self.sx.baseAGI * self.sx.mjjc) / 100)
    return mjjc
end

-- 绿字 智力加成%+智力增幅%+智力常数
function modifier_attr_buff:GetModifierBonusStats_Intellect()
    if not self.sx then return end
    local zljc = math.floor((self.sx.baseINT * self.sx.zljc) / 100)
    return zljc
end

-- 攻击间隔
-- function modifier_attr_buff:GetModifierBaseAttackTimeConstant()
--     if not self.sx then return end
--     return self.sx.gjjg
-- end

-- 白字 攻击速度
-- function modifier_attr_buff:GetModifierAttackSpeedBonus_Constant()
-- 	if not self.sx then return end
-- 	return self.sx.gjsd
-- end

-- 生命增幅已迁移至 modifier_smzf（见 utilex:BaseSmzf）

-- 视野加成（白天）- 引擎回调名为 GetBonusDayVision，非 GetModifierBonusDayVision
function modifier_attr_buff:GetBonusDayVision()
    if not self.sx then return 0 end
    return self.sx.syjc or 0
end

-- 视野加成（夜晚）- 引擎回调名为 GetBonusNightVision，非 GetModifierBonusNightVision
function modifier_attr_buff:GetBonusNightVision()
    if not self.sx then return 0 end
    return self.sx.syjc or 0
end

-- 弹道速度加成：近战英雄学魔化/变龙/月刃/智慧之刃时，引擎弹道速度为0会导致技能无效，需提供最低弹道速度
function modifier_attr_buff:GetModifierProjectileSpeedBonus()
    local pa = self:GetParent()
    if not pa or not pa:IsRealHero() then return 0 end
    local num = 0
    -- 拥有魔化、变龙、月刃、智慧之刃之一时，提供900弹道速度（与TB/DK/Luna/Silencer原版一致），解决近战英雄弹道为0的bug
    -- if pa:HasAbility("terrorblade_metamorphosis") or
    --     pa:HasAbility("dragon_knight_elder_dragon_form") or
    --     pa:HasAbility("luna_moon_glaive") or
    --     pa:HasAbility("silencer_glaives_of_wisdom") then
    --     local name = pa:GetUnitName()
    --     if Skill:IsRangedAttacker(name) then
    --         num = 900
    --     end
    -- end
    return num
end
