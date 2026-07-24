--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


modifier_talent_3 = class({})

--该modifier是否是负面的
function modifier_talent_3:IsDebuff()
    return false
end

--该modifier能否被清除
function modifier_talent_3:IsPurgable()
    return false
end

--该modifier是否隐藏
function modifier_talent_3:IsHidden()
    return true
end

--死亡时是否移除
function modifier_talent_3:RemoveOnDeath()
    return false
end

-- 幻象不继承灼烧光环，避免 Talent.Data[ID] / Hero2ID 与本体错位
function modifier_talent_3:AllowIllusionDuplicate()
    return false
end

-- 初始化modifier
function modifier_talent_3:OnCreated(kv)
    if not IsServer() then return end
    -- 获取参数
    self.damage_type = kv.damage_type or DAMAGE_TYPE_MAGICAL -- 伤害类型
    -- print("modifier_talent_3")
    -- 开始伤害间隔
    self:StartIntervalThink(1)
    self:ForceRefresh()
end

-- 刷新modifier
function modifier_talent_3:OnRefresh(kv)
    if not IsServer() then return end
    -- ForceRefresh / 升温改层后偶发丢掉 IntervalThink，与 OnCreated 一致重绑周期
    self:StartIntervalThink(1)

    local hero = self:GetParent()
    if not hero or hero:IsNull() then return end
    local ID = Util:Hero2ID(hero)
    if not ID or not HeroData.Data[ID] or not HeroData.Data[ID].hero_attr then
        self.lqjs = 0
        self:SetStackCount(0)
        return
    end
    self.lqjs = HeroData.Data[ID].hero_attr.lqjs or 0
    self:SetStackCount(self.lqjs)
    hero:CalculateStatBonus(true)
end

-- 注册伤害监听事件
function modifier_talent_3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
end

function modifier_talent_3:GetModifierPercentageCooldown()
    local count = self:GetStackCount()
    return count
end

-- 间隔伤害
function modifier_talent_3:OnIntervalThink()
    if not IsServer() then return end

    local parent = self:GetParent()

    -- 检查父单位是否存活
    if not parent:IsAlive() then
        return
    end

    local ID = Util:Hero2ID(parent)
    -- 掉落线/换人帧等瞬时 Hero2ID 失败时用 PlayerOwner（与 Talent.Data 下标一致）
    if (not ID or ID < 0) and parent.GetPlayerOwnerID then
        ID = parent:GetPlayerOwnerID()
    end

    if not ID or ID < 0 or not Talent.Data or not Talent.Data[ID] then
        return
    end

    if Util and Util.ID2IfOnline and not Util:ID2IfOnline(ID) then
        return
    end

    local level = Talent.Data[ID].level or 0
    local dam = 1
    local radius = 100

    if level == 0 then
        dam = 30
        radius = 400
    end
    if level == 1 then
        dam = 45
        radius = 450
    end
    if level == 2 then
        dam = 60
        radius = 550
    end
    if level == 3 then
        dam = 80 + math.floor(parent:GetMana() * 0.015)
        radius = 600
    end
    if level == 4 then
        dam = 100 + math.floor(parent:GetMana() * 0.03)
        radius = 650
    end
    if level == 5 then
        dam = 120 + math.floor(parent:GetMana() * 0.05)
        radius = 700
    end

    -- 天赋装备基础作用范围（zyfw）：叠加到灼烧寻敌半径（引擎 AOE 加成不作用于 Lua 手写半径）
    if HeroData and HeroData.GetSX then
        radius = radius + math.floor(tonumber(HeroData:GetSX(ID, "zyfw")) or 0)
    end

    local team = parent:GetTeamNumber()
    local position = parent:GetAbsOrigin()

    -- 查找范围内的敌人
    local enemies = FindUnitsInRadius(
        team,
        position,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    -- 对每个敌人造成伤害
    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and enemy:IsAlive() then
            self:ApplyDamage(enemy, dam)
            local tx =
            "particles/econ/events/seasonal_reward_line_winter_2025/radiance_target_winterrewardline_2025.vpcf"
            utilex:AddTx(tx, enemy, 1)
        end
    end
end

-- 应用伤害（不参与 damage.lua 中 zzsh/魔力波动/挨打减免等与普通技能伤害的 Lua 叠算）
function modifier_talent_3:ApplyDamage(target, dam)
    local parent = self:GetParent()

    local damage_table = {
        victim = target,
        attacker = parent,
        damage = dam,
        damage_type = self.damage_type,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = self:GetAbility()
    }

    local fn_enter = rawget(_G, "ClrbDmg_Filter_Talent3AuraIsolation_Enter")
    local fn_leave = rawget(_G, "ClrbDmg_Filter_Talent3AuraIsolation_Leave")
    if fn_enter then
        fn_enter()
    end
    local ok, err_msg = pcall(function()
        ApplyDamage(damage_table)
    end)
    if fn_leave then
        fn_leave()
    end
    if not ok then
        -- print("[modifier_talent_3] ApplyDamage: " .. tostring(err_msg))
        if Server and Server.SendError then
            Server:SendError(tostring(err_msg), "modifier_talent_3:ApplyDamage")
        end
    end
end

