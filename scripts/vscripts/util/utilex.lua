--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if utilex == nil then _G.utilex = class({}) end

-- 主要记录用到的一些算法工具

-- 让字符串按指定字符分割成数组
function utilex:split(str, reps)
    local resultStrList = {}
    string.gsub(str, '[^' .. reps .. ']+',
        function(w) table.insert(resultStrList, w) end)
    return resultStrList
end

-- 将 SteamID32 转换为 17 位 SteamID64（字符串运算版）
function utilex:ConvertSteamID32To64_Safe(steamId32)
    -- 输入验证
    if type(steamId32) ~= "number" and type(steamId32) ~= "string" then
        return nil
    end

    local id32 = tostring(steamId32)
    -- 移除可能的空格等
    id32 = id32:match("^(%d+)$")
    if not id32 then
        print("[ConvertSteamID32To64] 错误：输入不是有效的数字。")
        return nil
    end

    -- 核心：将 SteamID32 与大基数相加（使用字符串模拟大数加法）
    -- 基数：76561197960265728
    local base = "76561197960265728"
    local result = ""
    local carry = 0
    local i = #base
    local j = #id32

    -- 从最低位开始逐位相加
    while i > 0 or j > 0 or carry > 0 do
        local digit1 = i > 0 and tonumber(base:sub(i, i)) or 0
        local digit2 = j > 0 and tonumber(id32:sub(j, j)) or 0
        local sum = digit1 + digit2 + carry

        result = tostring(sum % 10) .. result
        carry = math.floor(sum / 10)

        i = i - 1
        j = j - 1
    end

    -- 验证结果是否为17位（SteamID64的固定特征）
    if #result == 17 and result:sub(1, 7) == "7656119" then
        return result
    else
        print("[ConvertSteamID32To64] 警告：转换结果格式异常: " ..
            result)
        return result -- 但仍返回结果
    end
end

-- 指定物品被动提供技能吸血（%），与 scripts/npc/items.txt 中 spell_lifesteal 一致
local UTX_HERO_JNXX_ITEMS = {
    item_voodoo_mask = 15,
    item_veil_of_discord = 18,
    item_revenants_brooch = 15,
}
-- 血精开启后（Bloodpact）为 60%，引擎修饰器名以版本为准，多列作兜底
local UTX_BLOODSTONE_ACTIVE_MODS = {
    "modifier_item_bloodstone_active",
}

--获取英雄在dota2物品中获得的技能吸血数值（百分比，整数）；多件不叠加，取其中最高的一档
function utilex:GetHeroJnxx(hero)
    if not hero or hero:IsNull() or not hero:IsAlive() then
        return 0
    end
    if type(hero.HasInventory) == "function" and not hero:HasInventory() then
        return 0
    end
    if type(hero.HasItemInInventory) ~= "function" then
        return 0
    end
    local best = 0
    for item_name, pct in pairs(UTX_HERO_JNXX_ITEMS) do
        if hero:HasItemInInventory(item_name) and type(pct) == "number" and pct > best then
            best = pct
        end
    end
    if hero:HasItemInInventory("item_bloodstone") then
        local blood_pct = 20
        for _, mname in ipairs(UTX_BLOODSTONE_ACTIVE_MODS) do
            if type(hero.HasModifier) == "function" and hero:HasModifier(mname) then
                blood_pct = 60
                break
            end
        end
        if blood_pct > best then
            best = blood_pct
        end
    end
    return best
end

-- 通过指定字符分隔字符串后获取其中第index位置的值
function utilex:splitIndex(str, reps, index)
    local resultStrList = {}
    string.gsub(str, '[^' .. reps .. ']+',
        function(w) table.insert(resultStrList, w) end)
    if index > #resultStrList then return end
    return resultStrList[index]
end

-- 表里随机取键
function utilex:TabRandomKey(tab)
    local keys = {}
    for k, v in pairs(tab) do table.insert(keys, k) end

    local keys2 = {}
    for k, _ in pairs(keys) do table.insert(keys2, k) end
    local key = keys[RandomInt(1, #keys2)]
    return key
end

-- 修改生命（尸体上 AddNewModifier 常无效，与 HeroData:QueueRbzfDeathBonus… 一致；需在复活后再次调用）
function utilex:BaseSmjc(ID)
    LinkLuaModifier("modifier_smjc", "ingame/modifier/modifier_smjc",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    if not hero:IsAlive() then
        return
    end
    hero:AddNewModifier(hero,                      -- 施法者
        nil,                                       -- 技能
        "modifier_smjc",                           -- 修饰器名称
        { num = HeroData.Data[ID].hero_attr.smjc } -- 参数
    )
end

function utilex:BaseLqjs(ID)
    LinkLuaModifier("modifier_lqjs", "ingame/modifier/modifier_lqjs",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero,                      -- 施法者
        nil,                                       -- 技能
        "modifier_lqjs",                           -- 修饰器名称
        { num = HeroData.Data[ID].hero_attr.lqjs } -- 参数
    )
end

-- 状态抗性
function utilex:BaseZtkx(ID)
    LinkLuaModifier("modifier_ztkx", "ingame/modifier/modifier_ztkx",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero,                      -- 施法者
        nil,                                       -- 技能
        "modifier_ztkx",                           -- 修饰器名称
        { num = HeroData.Data[ID].hero_attr.ztkx } -- 参数
    )
end

-- 修改护甲
function utilex:BaseHj(ID)
    LinkLuaModifier("modifier_hj", "ingame/modifier/modifier_hj",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero,                       -- 施法者
        nil,                                        -- 技能
        "modifier_hj",                              -- 修饰器名称
        { jchj = HeroData.Data[ID].hero_attr.wlkx } -- 参数
    )
end

-- 魔法抗性
function utilex:BaseMfkx(ID)
    LinkLuaModifier("modifier_mfkx", "ingame/modifier/modifier_mfkx",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero,                      -- 施法者
        nil,                                       -- 技能
        "modifier_mfkx",                           -- 修饰器名称
        { num = HeroData.Data[ID].hero_attr.mfkx } -- 参数
    )
end

-- 修改绿字攻击力（单实例 modifier_gjljc，避免每次 AddNewModifier 叠乘；与 modifier_attr_buff 的 jcgj 只保留一处生效）
function utilex:BaseGjl(ID)
    LinkLuaModifier("modifier_gjljc", "ingame/modifier/modifier_gjljc",
        LUA_MODIFIER_MOTION_NONE)
    if not ID or not HeroData.Data[ID] then return end
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then return end
    local jcgj = math.floor(tonumber(HeroData.Data[ID].hero_attr.jcgj) or 0)
    local stack = jcgj * 100
    local keep = hero:FindModifierByName("modifier_gjljc")
    if keep then
        keep:SetStackCount(stack)
        keep:ForceRefresh()
        if hero.FindAllModifiersByName then
            local all = hero:FindAllModifiersByName("modifier_gjljc")
            if all then
                for _, m in pairs(all) do
                    if m and m ~= keep and not m:IsNull() then
                        m:Destroy()
                    end
                end
            end
        end
    else
        hero:AddNewModifier(hero, nil, "modifier_gjljc", { jcgjl = jcgj })
    end
end

-- 修改移速
function utilex:BaseYs(ID)
    LinkLuaModifier("modifier_jcys", "ingame/modifier/modifier_jcys",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero,                       -- 施法者
        nil,                                        -- 技能
        "modifier_jcys",                            -- 修饰器名称
        { jcys = HeroData.Data[ID].hero_attr.jcys } -- 参数
    )
end

-- 生命恢复
function utilex:BaseSmhf(ID)
    LinkLuaModifier("modifier_smhf", "ingame/modifier/modifier_smhf",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero,                               -- 施法者
        nil,                                                -- 技能
        "modifier_smhf",                                    -- 修饰器名称
        { health_regen = HeroData.Data[ID].hero_attr.smhf } -- 参数
    )
end

function utilex:BaseJnzq(ID)
    LinkLuaModifier("modifier_jnzq", "ingame/modifier/modifier_jnzq",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero,                            -- 施法者
        nil,                                             -- 技能
        "modifier_jnzq",                                 -- 修饰器名称
        { spell_amp = HeroData.Data[ID].hero_attr.jnzq } -- 参数
    )
end

function utilex:BaseGjsd(ID)
    LinkLuaModifier("modifier_gjsd", "ingame/modifier/modifier_gjsd",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero,                               -- 施法者
        nil,                                                -- 技能
        "modifier_gjsd",                                    -- 修饰器名称
        { attack_speed = HeroData.Data[ID].hero_attr.gjsd } -- 参数
    )
end

-- 基础作用范围（hero_attr.zyfw）：单实例，AOE_BONUS_CONSTANT / STACKING
function utilex:BaseZyfw(ID)
    if not ID or not HeroData or not HeroData.Data or not HeroData.Data[ID] then
        return
    end
    LinkLuaModifier("modifier_zyfw", "ingame/modifier/modifier_zyfw",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    local zyfw = math.floor(tonumber(HeroData.Data[ID].hero_attr.zyfw) or 0)
    if zyfw < 0 then zyfw = 0 end
    local m = hero:FindModifierByName("modifier_zyfw")
    if m then
        m:SetStackCount(zyfw)
        m:ForceRefresh()
    else
        hero:AddNewModifier(hero, nil, "modifier_zyfw", { zyfw = zyfw })
    end
    hero:CalculateStatBonus(true)
end

-- 攻击距离加成（hero_attr.gjjl）：单实例，避免多次 AddSX 叠加多个同名 modifier
function utilex:BaseGjjl(ID)
    LinkLuaModifier("modifier_gjjl", "ingame/modifier/modifier_gjjl",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    local gjjl = math.floor(tonumber(HeroData.Data[ID].hero_attr.gjjl) or 0)
    if gjjl < 0 then gjjl = 0 end
    local m = hero:FindModifierByName("modifier_gjjl")
    if m then
        m:SetStackCount(gjjl)
        m:ForceRefresh()
        hero:CalculateStatBonus(true)
    else
        hero:AddNewModifier(hero, nil, "modifier_gjjl", { gjjl = gjjl })
    end
end

function utilex:BaseGjjc(ID)
    LinkLuaModifier("modifier_gjjc", "ingame/modifier/modifier_gjjc",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    local v = math.floor(tonumber(HeroData.Data[ID].hero_attr.gjjc) or 0)
    local m = hero:FindModifierByName("modifier_gjjc")
    if m then
        m:SetStackCount(v)
        m:ForceRefresh()
        hero:CalculateStatBonus(true)
    else
        hero:AddNewModifier(hero, nil, "modifier_gjjc", { gjjc = v })
    end
end

function utilex:BaseSmzf(ID)
    LinkLuaModifier("modifier_smzf", "ingame/modifier/modifier_smzf",
        LUA_MODIFIER_MOTION_NONE)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    local v = math.floor(tonumber(HeroData.Data[ID].hero_attr.smzf) or 0)
    local m = hero:FindModifierByName("modifier_smzf")
    if m then
        m:SetStackCount(v)
        m:ForceRefresh()
        hero:CalculateStatBonus(true)
    else
        hero:AddNewModifier(hero, nil, "modifier_smzf", { smzf = v })
    end
end

function utilex:Box28(ID)
    local hero = Util.GetHeroForPlayerData and Util:GetHeroForPlayerData(ID) or Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return
    end
    hero:AddNewModifier(hero, -- 施法者
        nil,                  -- 技能
        "modifier_box_28",    -- 修饰器名称
        { attack_speed = 45 } -- 参数
    )
end

-- 表里取真随机健
function utilex:TabTrueKey(tab)
    local flag = false
    local num = 0
    local true_key
    repeat
        num = num + 1
        if num > 300 then flag = true end
        local key = self:TabRandomKey(tab)
        if tab[key] == true then
            flag = true
            true_key = key
        end
    until flag
    return true_key
end

-- 表里取最大值的健
function utilex:GetMaxKeyInTab(tab)
    local max = 0
    local max_key = nil
    for k, v in pairs(tab) do
        if v >= max then
            max = v
            max_key = k
        end
    end
    return max_key
end

-- 表里取最小值
function utilex:GetMinKeyInTab(tab)
    local min = 999
    local min_key = nil
    for k, v in pairs(tab) do
        if v <= min then
            min = v
            min_key = k
        end
    end
    return min_key
end

-- 将浮点数转换为N位小数
function utilex:FloatSet(num, n)
    n = n or 2;
    local fmt = "%." .. n .. "f"
    local value = string.format(fmt, num);
    return tonumber(value)
end

-- 英雄是否存活
function utilex:HeroIsAlive(ID)
    if not ID then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    if hero == nil then return false end
    if hero:IsAlive() then
        return true
    else
        return false
    end
end

-- 一次性增加英雄属性（包含力，敏，智）,list:属性列表
function utilex:AddHeroAttr(ID, list)
    if not ID or not list then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    -- for k, v in pairs(list) do
    --     if k == "jcll" then
    --         hero:ModifyStrength(v)
    --     elseif k == "jcmj" then
    --         hero:ModifyAgility(v)
    --     elseif k == "jczl" then
    --         hero:ModifyIntellect(v)
    --     else
    --         SX:Add(k, v, ID)
    --     end
    -- end
    for k, v in pairs(list) do SX:Add(k, v, ID) end
end

-- 增加当前全属性百分比（白字）
function utilex:Addattributes(hero, num)
    if not hero or hero:IsNull() then return end
    if not hero:IsRealHero() then return end
    local Strength = hero:GetBaseStrength()
    local agility = hero:GetBaseAgility()
    local Intellect = hero:GetBaseIntellect()
    hero:ModifyStrength(Strength * num)
    hero:ModifyAgility(agility * num)
    hero:ModifyIntellect(Intellect * num)
end

-- 增加当前全属性百分比（根据白字加在绿字上）
function utilex:Addattributes_green(hero, num)
    if not hero or hero:IsNull() then return end
    if not hero:IsRealHero() then return end
    local ID = Util:Hero2ID(hero)
    SX:Add("lljc", num, ID)
    SX:Add("mjjc", num, ID)
    SX:Add("zljc", num, ID)
end

-- 增加升级成长值
function utilex:AddAttributeUp(hero, num, ID)
    if not hero or hero:IsNull() then return end
    if not hero:IsRealHero() then return end
    SX:Add("llcz", num, ID)
    SX:Add("mjcz", num, ID)
    SX:Add("zlcz", num, ID)
end

-- 获取英雄或英雄周围一个固定的点，然后在该点周围随机范围内再取一个点
function utilex:GetRandomPoint(ID, pos, around)
    if not ID or not pos then return end
    local hero = Util:ID2Hero(ID)
    if not hero then return end
    local hero_point = hero:GetAbsOrigin()
    local sum = 0
    local flag = false
    repeat
        local random_point = hero_point + RandomVector(RandomFloat(0, around))
        if CanFindPath(hero_point, random_point) then
            flag = true
            return random_point
        end
        sum = sum + 1
        if sum > 10000 then return hero_point end
    until (flag)
end

-- 获取一个位置周围的随机位置
function utilex:RandomPos(pos, min, max)
    if not pos then return end
    local flag = false
    local num = 0
    repeat
        num = num + 1
        local ed = pos + RandomVector(RandomFloat(min, max))
        if CanFindPath(pos, ed) then
            flag = true
            return ed
        end
        if num > 10000 then return pos end
    until (flag)
end

-- 立即杀死一个单位（不播放死亡动画）
function utilex:AddKill(unit)
    if not unit then return end
    if self:IsClrbCourierPet(unit) then
        return
    end
    if self:IsTrueEntity(unit) then
        local name = unit:GetUnitName()
        for k, v in pairs(Victory.NoRemoveNpc) do
            if name == v then return end
        end
        if unit.Serial ~= nil then FollowTips:RemoveEntity(unit.Serial) end
        utilex:Particles2(unit:GetAbsOrigin())
        Util:AddKill(unit, 0)
        unit:AddNoDraw()
        Hp_Bar:RemoveCustomHpBar(unit)
    end
end

-- 对一个单位添加buff（可以重复添加）
function utilex:AddModifierRefresh(unit, buff, time)
    if not unit or not buff then return end
    unit:AddNewModifier(unit, nil, buff, { duration = time })
end

-- 对一个单位加buff(不带参数)
function utilex:AddModifier(unit, buff)
    if not unit or not buff then return end
    if unit:HasModifier(buff) then return end
    unit:AddNewModifier(unit, nil, buff, {})
end

-- 对一个单位加buff（带参数）
function utilex:AddModifierTime(unit, buff, time)
    if not unit or not buff or not time then return end
    unit:AddNewModifier(unit, nil, buff, { dur = time })
end

-- 创建一个单位
-- name:单位名字
-- pos:创建地点
-- time：单位存活时间可以为空
-- in_particle：出场特效可以为空(特效路径path),leave_particle:离场特效
-- team：阵营可以为空默认为敌对good或者bad
-- ID:是否有拥有者，确定奖励对象，可以为空默认就是没有
function utilex:CreateUnit(name, pos, time, team)
    if not name or not pos then return end
    if team == "bad" or team == nil then team = DOTA_TEAM_BADGUYS end
    if team == "good" then team = DOTA_TEAM_GOODGUYS end
    local ve = Util:FindCanReachPos(pos)
    local unit = CreateUnitByName(name, ve, true, nil, nil, team)
    if time ~= nil and type(time) == "number" then
        Util:AddKill(unit, time)
        local remove_time = time - 0.2
        Timers(remove_time, function()
            if self:IsTrueEntity(unit) then self:AddKill(unit) end
        end)
    end
    FindClearSpaceForUnit(unit, ve, true)
    unit:AddNewModifier(unit, nil, "modifier_phased", { duration = 0.1 })
    return unit
end

-- 创造一个单位
function utilex:CreateMonster(name, pos)
    if MainGame and MainGame.Data and MainGame.Data.over then
        return nil
    end
    if not name or not pos then return end
    local ve = Util:FindCanReachPos(pos)
    local unit = CreateUnitByName(name, ve, true, nil, nil, 4)
    if not unit or unit:IsNull() then
        return nil
    end
    FindClearSpaceForUnit(unit, ve, true)
    unit:AddNewModifier(unit, nil, "modifier_phased", { duration = 0.1 })
    return unit
end

-- 判断一个实体是否是有效的物品
function utilex:IsTrueItem(item)
    if not item then return end
    if IsValidEntity(item) and not item:IsNull() and item:GetClassname() ==
        "item_datadriven" then
        return true
    else
        return false
    end
end

-- 判断一个实体是否是一个有效且存活的英雄
function utilex:IsTrueHero(hero)
    if not hero then return end
    if IsValidEntity(hero) and hero:IsAlive() and hero:IsHero() then
        return true
    else
        return false
    end
end

-- 判断一个实体是否是一个有效且存活的单位(不包括英雄)
function utilex:IsTrueEntity(entity)
    if not entity then return end
    if IsValidEntity(entity) and entity:IsAlive() and not entity:IsNull() then
        return true
    else
        return false
    end
end

--- 随从单位 CardPet：大范围删单位 / 定时秒杀等不得移除（勿用 modifier_petbuff 判断：dummy 等同名 buff 会误判）
function utilex:IsClrbCourierPet(entity)
    if not entity or entity:IsNull() then
        return false
    end
    if type(entity.GetUnitName) ~= "function" then
        return false
    end
    local n = tostring(entity:GetUnitName() or "")
    local nl = string.lower(n)
    return n == "CardPet" or n == "CardPetTi10" or nl == "npc_dota_cardpet" or nl == "npc_dota_cardpetti10"
end

-- 添加动作模组
function utilex:AnimationModifier(unit)
    if not unit then return end

    local active = {
        "walk", "run", "run_fast", "fast", "faster", "fastest", "end",
        "attack_01_near", "attack_01_near_fast"
    }
    -- if unit:GetUnitName() == "m_2_3" then
    --     -- 英雄骨架 + 至宝 wearables：arcana/aggressive 驱动至宝攻击外观
    --     active = {
    --         "walk", "run", "run_fast",
    --         "fast", "faster",
    --         "aggressive", "arcana",
    --     }
    -- end
    if unit:GetUnitName() == "m_2_3" then
        active = {
            "walk", "run", "run_fast",
            "fast", "faster", "fastest", "end",
            "attack_01_near", "attack_01_near_fast",
            "aggressive", "arcana",
        }
    end
    for k, v in pairs(active) do unit:AddActivityModifier(v) end
end

-- 添加一个动作
function utilex:AddAnimation(unit, active, dur, rate)
    if not unit or not active then return end
    if not dur then dur = 9999999 end
    if not rate then rate = 1 end
    local table = { duration = dur, activity = active, rate = rate }
    StartAnimation(unit, table)
end

-- 红色警戒圈
function utilex:RedTip(pos, rang, time)
    local tx = RedTip:PointCircleVector(pos, rang, time)
    Timers(time + 1, function()
        ParticleManager:DestroyParticle(tx, true)
        ParticleManager:ReleaseParticleIndex(tx)
    end)
end

-- 函数定义: 设置单位A面朝单位B
-- 计算并设置unit1面向unit2
function utilex:FaceUnitTowards(unitToFace, targetUnit)
    if unitToFace and targetUnit then
        local direction =
            (targetUnit:GetAbsOrigin() - unitToFace:GetAbsOrigin()):Normalized()
        local forwardVector = Vector(direction.x, direction.y, 0)
        unitToFace:SetForwardVector(forwardVector)
    end
end

function utilex:FacePosTowards(unitToFace, pos)
    if unitToFace and pos then
        local direction = (pos - unitToFace:GetAbsOrigin()):Normalized()
        local forwardVector = Vector(direction.x, direction.y, 0)
        unitToFace:SetForwardVector(forwardVector)
    end
end

function utilex:IsInventoryAndPersonalBagFull(unit)
    if not unit then return end
    -- if not unit:IsAlive() then return end
    if not unit:IsHero() then return end
    if unit:IsNull() then return end


    for i = 0, 8 do
        local item = unit:GetItemInSlot(i)
        if not item then return false end
    end
    for i = 9, 14 do
        local item = unit:GetItemInSlot(i)
        if not item then return false end
    end
    return true
end

-- 获取一个范围内的所有指定队伍的单位
-- (pos：点，radius：范围，team：队伍)
-- radius为nil，搜索范围为全地图
-- team为nil，搜索范围为所有队伍
function utilex:GetRadiusUnit(unit, pos, radius, team)
    if not unit then return end
    if unit:IsNull() then
        return
    end
    if not IsValidEntity(unit) then
        return
    end
    local kind = nil
    local around = nil
    if radius == nil then
        around = FIND_UNITS_EVERYWHERE
    else
        around = radius
    end
    if team == "good" then kind = DOTA_UNIT_TARGET_TEAM_FRIENDLY end
    if team == "bad" then kind = DOTA_UNIT_TARGET_TEAM_ENEMY end
    if team == nil then kind = DOTA_UNIT_TARGET_TEAM_BOTH end
    local units = FindUnitsInRadius(unit:GetTeamNumber(), pos, nil, around,
        kind, DOTA_UNIT_TARGET_HERO +
        DOTA_UNIT_TARGET_BASIC, 0, 1, false)
    return units
end

-- 修改单位生命值(hp:生命上限百分比)
function utilex:UnitHp(unit, hp)
    if not unit then return end
    if not unit:IsAlive() then return end
    if utilex:IsTrueEntity(unit) or utilex:IsTrueHero(unit) then
        -- 获得最大生命
        local Maxhealth = unit:GetMaxHealth()
        -- 计算血量
        local hp_num = Maxhealth * hp * 0.01
        if hp > 0 then
            if hp_num > 999999999 then
                local chip_hp = hp_num * 0.1
                if hp == 100 then
                    for i = 1, 11 do unit:Heal(chip_hp, nil) end
                else
                    for i = 1, 10 do unit:Heal(chip_hp, nil) end
                end
            else
                unit:Heal(hp_num, nil)
            end
        else
            utilex:UnitDam(unit, unit, -hp_num, "cc")
        end
    end
end

-- 对一个单位造成伤害（可选 ability：带 inflictor，供法术增幅/成就统计等）
-- 可选第 6 参数 bonus_magic_float：true 时用附加法术伤害跳字（同金箍棒/三元重戟魔法攻击）
function utilex:UnitDam(attack, victim, dam, dam_type, ability, bonus_magic_float)
    if not attack or not victim or not dam or not dam_type then return end
    if attack:IsNull() then
        return
    end
    if not IsValidEntity(attack) then
        return
    end
    if victim:IsNull() then
        return
    end
    if not IsValidEntity(victim) then
        return
    end
    if not victim:IsAlive() then
        return
    end
    local dam_kind = nil
    if dam_type == "mf" then dam_kind = DAMAGE_TYPE_MAGICAL end
    if dam_type == "wl" then dam_kind = DAMAGE_TYPE_PHYSICAL end
    if dam_type == "cc" then dam_kind = DAMAGE_TYPE_PURE end
    if not dam_kind then return end
    --减少技能增强的效果
    -- if no_jnzq then
    --     if attack:IsHero() and attack:GetSpellAmplification(false) then
    --         local jnzq = attack:GetSpellAmplification(false)
    --         local num = math.floor(jnzq * 100)
    --         if num > 0 then
    --             dam = dam / (1 + (num / 100))
    --             print("=============")
    --             print("伤害：" .. dam)
    --             --动态获取技能增强数值然受手动减少对应伤害
    --             -- dam = math.max(0, math.floor(dam + 0.5))
    --             -- dam = math.ceil(dam / (100 + jnzq) / 100)
    --         end
    --     end
    -- end
    local tab = {
        attacker = attack,
        victim = victim,
        damage = dam,
        damage_type = dam_kind
    }
    if bonus_magic_float then
        local no_float = rawget(_G, "DOTA_DAMAGE_FLAG_NO_DAMAGE_FLOATS")
        if no_float then
            tab.damage_flags = no_float
        end
    end
    if ability and not ability:IsNull() then
        tab.ability = ability
    end
    ApplyDamage(tab)
    if bonus_magic_float then
        local shown = math.floor(dam)
        if shown > 0 then
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, victim, shown, nil)
        end
    end
end

-- 判断一个表中索引指向的单位是否存活有效，如果是无效就就移除(不包括英雄)
function utilex:ClearTableIndex(list)
    for k, v in pairs(list) do
        if v then
            local unit = EntIndexToHScript(v)
            if not utilex:IsTrueEntity(unit) then list[k] = nil end
        end
    end
end

-- 杀死一个索引表中所有存在的实体（不包括英雄）
function utilex:ClearTableUnit(list)
    if not list then return end
    for k, v in pairs(list) do
        if v and type(v) == "number" then
            local unit = EntIndexToHScript(v)
            if self:IsTrueEntity(unit) then self:AddKill(unit) end
        end
    end
end

-- 杀死一个表中所有实体并清空表
function utilex:ClearTable(list)
    self:ClearTableUnit(list)
    self:ClearTableIndex(list)
end

-- 慢动作
function utilex:SlowMotion()
    Convars:SetFloat('host_timescale', 0.2)
    Timers(2 * 0.2 + FrameTime(),
        function() Convars:SetFloat('host_timescale', 1) end)
end

-- #region 玩家

-- 获取所有在线玩家
function utilex:GetAllPlayer()
    local list = {}
    for i = 1, #PD.IDs do
        local ID = PD.IDs[i]
        if Util:ID2IfValid(ID) and Util:ID2IfOnline(ID) then
            table.insert(list, ID)
        end
    end
    return list
end

-- 对所有玩家播放声音
function utilex:EmitSound(sounds)
    local players = utilex:GetAllPlayer()
    for k, v in pairs(players) do
        local hero = Util:ID2Hero(v)
        if hero and not hero:IsNull() then
            hero:EmitSoundParams(sounds, 1, 500, 1)
        end
    end
end

-- 对指定玩家播放声音
function utilex:Sound(ID, bgm)
    if not ID or not bgm then return end
    local player = Util:ID2Player(ID)
    if player then EmitSoundOnClient(bgm, player) end
end

-- 对所有玩家播放声音
function utilex:SoundAll(bgm)
    if not bgm then return end
    for k, v in pairs(utilex:GetAllPlayer()) do
        local player = Util:ID2Player(v)
        if player then EmitSoundOnClient(bgm, player) end
    end
end

-- #endregion

-- #region 特效

-- 对一个点添加特效(默认特效点加在0)
function utilex:AddParticllesPos(path, pos, dur)
    if not path or not pos then return end
    local tx = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(tx, 0, pos)
    if dur == nil then dur = 1000 end
    if dur then
        Timers(dur, function()
            ParticleManager:DestroyParticle(tx, true)
            ParticleManager:ReleaseParticleIndex(tx)
        end)
    end
    return tx
end

-- 对一个单位加特效(控制点默认为0)
function utilex:AddTx(path, target, dur)
    if not path or not target then return end
    if target:IsNull() then return end
    local target_pos = target:GetAbsOrigin()
    local tx = ParticleManager:CreateParticle(path, PATTACH_ABSORIGIN_FOLLOW,
        target)
    -- 获取当前粒子系统的信息
    ParticleManager:SetParticleControl(tx, 0, target_pos)
    if dur then
        Timers(dur, function()
            ParticleManager:DestroyParticle(tx, true)
            ParticleManager:ReleaseParticleIndex(tx)
        end)
    end
    return tx
end

-- 对一个单位添加一个特效(只能加一个，如果还要加得先清除)
-- path:特效路径
-- dur：持续时间
-- target:目标单位
-- count:特效id
function utilex:AddParticles(path, target, dur, count)
    if not path or not target then return end
    if not IsValidEntity(target) then return end
    -- 给单位身上添加特效
    local target_pos = target:GetAbsOrigin()
    -- if target.particles ~= nil and target.particles.state then
    --     return
    -- end
    local tx = ParticleManager:CreateParticle(path, PATTACH_ABSORIGIN_FOLLOW,
        target)
    -- 获取当前粒子系统的信息
    ParticleManager:SetParticleControl(tx, count, target_pos)
    target.particles = { id = tx, state = true }
    if dur then
        Timers(dur, function()
            ParticleManager:DestroyParticle(tx, true)
            ParticleManager:ReleaseParticleIndex(tx)
            target.particles = nil
        end)
    end
    return tx
end

-- 清除目标身上的所有特效(只有通过AddParticles添加的特效才能使用)
function utilex:ClearTargetParticles(unit)
    if not unit then return end
    if unit.particles == nil then return end
    for k, v in pairs(unit.particles) do
        if k == "id" then
            ParticleManager:DestroyParticle(v, true)
            ParticleManager:ReleaseParticleIndex(v)
        end
    end
    unit.particles = {}
end

-- 移除特效(传入特效id)
function utilex:ClearTx(tx)
    if not tx then return end
    ParticleManager:DestroyParticle(tx, false)
    ParticleManager:ReleaseParticleIndex(tx)
end

-- 添加一个进场特效（天降光束）
function utilex:Particles1(pos)
    local path =
    "particles/econ/events/fall_2021/blink_dagger_fall_2021_start_lvl2.vpcf"
    local tx = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(tx, 0, pos)
    ParticleManager:SetParticleControl(tx, 1, pos)
    Timers(1, function()
        utilex:ClearTx(tx)
    end)
end

-- 离场光束特效
function utilex:Particles2(pos)
    local path =
    "particles/econ/events/fall_2021/blink_dagger_fall_2021_lvl2_fogring.vpcf"
    local tx = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(tx, 0, pos)
    ParticleManager:SetParticleControl(tx, 1, pos)
    ParticleManager:ReleaseParticleIndex(tx)
end

-- 复活特效2
function utilex:Particles7(pos)
    local path =
    "particles/econ/items/huskar/huskar_2022_immortal/huskar_2022_immortal_life_break_gold_vertical_lightbeam.vpcf"
    local tx = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(tx, 0, pos)
    ParticleManager:SetParticleControl(tx, 1, pos)
    ParticleManager:ReleaseParticleIndex(tx)
end

-- #endregion

-- 在一个圆内随机取点
function utilex:FindPosInRaidus(center, radius)
    return center + RandomVector(Script_RandomFloat(0, radius))
end

-- 获取一个点的最远位置随机点。max_attempts 默认 32（野怪巡逻等高频调用应传小值）；省略则保持旧版大上限以免改坏其它逻辑
function utilex:GetRandomPosMax(pos, len, max_attempts)
    if not pos or not len then return end
    local cap = max_attempts
    if cap == nil then
        cap = 10000
    end
    local num = 0
    while num < cap do
        num = num + 1
        local ed = pos + RandomVector(RandomFloat(0, len))
        if CanFindPath(pos, ed) then
            ed = Util:FindCanReachPos(ed)
            return ed
        end
    end
    local ed = pos + RandomVector(RandomFloat(0, math.min(len, 420)))
    return Util:FindCanReachPos(ed)
end

-- #region 技能

-- 释放下标技能(只能使用无目标技能)
function utilex:CastNoTargetAbility(unit, index)
    if not unit or not index then return end
    if self:IsTrueEntity(unit) then
        local ab = unit:GetAbilityByIndex(index)
        -- 冷却时间
        local time = ab:GetCooldownTime()
        if time == 0 then unit:CastAbilityNoTarget(ab, -1) end
    end
end

-- 击退周围所有敌方单位(单位，时间，高度，范围，距离)
function utilex:Repel(unit, dur, height, around, len)
    if not IsServer() then
        return
    end
    if not unit or unit:IsNull() or not unit:IsAlive() then
        return
    end
    if not dur or not height or not around or not len then
        return
    end
    local pos = unit:GetAbsOrigin()
    local units = utilex:GetRadiusUnit(unit, pos, around, "bad")
    if not units then
        return
    end
    for _, victim in pairs(units) do
        if victim and not victim:IsNull() and victim:IsAlive() then
            local dv = victim:GetAbsOrigin() - pos
            dv.z = 0
            if dv:Length2D() < 1 then
                dv = unit:GetForwardVector()
                dv.z = 0
            end
            local arc = victim:AddNewModifier(unit, nil, "modifier_generic_arc", {
                duration = dur,
                height = height,
                dir_x = dv.x,
                dir_y = dv.y,
                distance = len,
            })
            if arc and arc.SetEndCallback then
                arc:SetEndCallback(function()
                    if not victim or victim:IsNull() or not victim:IsAlive() then
                        return
                    end
                    local ve = victim:GetAbsOrigin()
                    ve = Util:FindCanReachPos(ve)
                    victim:SetAbsOrigin(ve)
                    EndAnimation(victim)
                    victim:AddNewModifier(victim, nil, "modifier_phased", { duration = 0.1 })
                end)
            end
        end
    end
end

-- #endregion

-- 物品飞向玩家
function utilex:ItemFlyParticle(ID, item)
    if not ID or not item then return end
    -- local hero = Util:ID2Hero(ID)
    local hero = SpawnUnit:GetPlayerHero(ID)
    -- if PersonalBackpack:IsFull(hero) then
    --     return
    -- end
    if hero and utilex:IsTrueItem(item) then
        local box = item:GetContainer()
        if box then
            local pid = CreateParticleEx(
                "particles/item_pick/item_pick_01.vpcf",
                PATTACH_CUSTOMORIGIN, hero, 1, true)
            ParticleManager:SetParticleControl(pid, 0, box:GetAbsOrigin())
            Util:ParticleSetControlEntHitlocOrAbsFollow(pid, 1, hero)
            Timers(1, function()
                ParticleManager:DestroyParticle(pid, false)
                ParticleManager:ReleaseParticleIndex(pid)
            end)
            local item_index = item:GetEntityIndex()
            -- 更新表
            ItemClass:UpDataItemTip(item_index)
            -- 判断是否要立即使用物品
            if ItemClass:IsPickUse(ID, item) then
                local item_name = item:GetName()
                if ItemClass:IsElixir(item_name) then
                    ItemUser:Use_Elixir(ID, item_name)
                end
                if ItemClass:IsExpend(item_name) then
                    ItemUser:Use_Expend(ID, item_name)
                end
                if item_name == "item_kill_2" or item_name == "item_kill_5" then
                    local num = tonumber(utilex:splitIndex(item_name, "_", 3))
                    CurrencyClass:AddKilltoCurrency(ID, num)
                end
                box:RemoveSelf()
            else
                if not PersonalBackpack:IsFull(hero) then
                    ItemClass:AddItem(hero, item)
                    box:RemoveSelf()
                end
            end
        end
    end
end

-- 获取距离该点最近的玩家英雄位置
function utilex:GetRecentPlayerVector(pos)
    if not pos then return end
    Util:InitAllPlayers()
    -- 英雄位置到点的距离
    local len = nil
    -- 最近玩家ID
    local near_player = -1
    for k, v in pairs(PD.IDs) do
        local hero = Util:ID2Hero(v)
        if hero and hero:IsHero() then
            local hero_point = hero:GetAbsOrigin()
            -- 玩家点和该点的距离
            local new_len = (pos - hero_point):Length2D()
            if len == nil then
                len = new_len
                near_player = v
            end
            if new_len < len then
                len = new_len
                near_player = v
            end
        end
    end
    local hero = Util:ID2Hero(near_player)
    if hero then
        local hero_v = hero:GetAbsOrigin()
        return hero_v
    else
        return nil
    end
end

-- 获取距离该点最近的英雄
function utilex:GetRecentPlayerHero(pos)
    if not pos then return end
    Util:InitAllPlayers()
    -- 英雄位置到点的距离
    local len = nil
    -- 最近玩家ID
    local near_player = -1
    for k, v in pairs(PD.IDs) do
        local hero = Util:ID2Hero(v)
        if hero and hero:IsHero() then
            local hero_point = hero:GetAbsOrigin()
            -- 玩家点和该点的距离
            local new_len = (pos - hero_point):Length2D()
            if len == nil then
                len = new_len
                near_player = v
            end
            if new_len < len then
                len = new_len
                near_player = v
            end
        end
    end
    local hero = Util:ID2Hero(near_player)
    if hero then
        return hero
    else
        return nil
    end
end

-- 获取玩家数量
function utilex:GetPlayerCount()
    local num = #PD.IDs
    -- if num > 4 then num = 4 end
    return num
end

-- 添加存档失败后续处理
function utilex:SendEquip(ID, Equip)
    if not ID or not Equip then return end
    local num = 0
    local stop_time = false
    local success = false
    Timers(1, function()
        if success == true then return end
        if stop_time == true then return 1 end
        num = num + 1
        -- 超过30次就失败
        if num > 10 then
            -- 保存失败 重新刷一次背包
            EquipBagClass:AutoCheck(ID)
            PopWindow:Tip(ID, "网络波动或背包已满，装备获取失败")
            return
        end
        -- 如果
        if stop_time == false then
            stop_time = true
            Server_Net_Equip:SaveEquipPool(ID, Equip, function(keys)
                if keys.code == 200 then
                    Server_Net_Equip:SaveEquipBag(ID)
                    success = true
                else
                    stop_time = false
                end
            end)
        end
        return 1
    end)
end

-- 获取一个商品数量
function utilex:GetOutNum(ID, item_name)
    if not ID or not item_name then return end
    local num = NetMall:GetItemNum(ID, item_name)
    return num
end

-- 加减商品
function utilex:AddOutItem(ID, item_name, num, func)
    if not ID or not item_name or not num then return end
    local temp = {}
    local tab2 = { tp = "net_mall", name = item_name, num = num }
    table.insert(temp, tab2)
    NetLottery:AddAndCost(ID, temp, nil, function(keys)
        if keys.code == 200 then func() end
    end)
end