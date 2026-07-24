--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


function HeroData:HeroGainAttr(ID, hero)
    if not ID or not hero then return end
    local cost_ll = self.Data[ID].cost.llcz
    local cost_mj = self.Data[ID].cost.mjcz
    local cost_zl = self.Data[ID].cost.zlcz

    local add_ll = self.Data[ID].attr.llcz
    local add_mj = self.Data[ID].attr.mjcz
    local add_zl = self.Data[ID].attr.zlcz

    local zy_ll = add_ll
    local zy_mj = add_mj
    local zy_zl = add_zl

    hero:ModifyStrength(zy_ll)
    hero:ModifyAgility(zy_mj)
    hero:ModifyIntellect(zy_zl)
end

-- 随机成长属性
function HeroData:RollGain(ID)
    local star = self.Data[ID].star
    -- 基础星级
    if star == 0 then return end
    -- local add_star = star - base_star
    local add_num = star * 108
    -- 属性基础保底
    local base_attr = self.Static.base_attr
    -- 保底属性
    local save_attr = add_num * base_attr / 1000
    -- 剩余随机属性
    local sy_attr = add_num - (3 * save_attr)
    -- 三个属性随机一个(1:力量，2：敏捷，3智力)
    local attr_list = {1, 2, 3}
    local add_ll = 0
    local add_mj = 0
    local add_zl = 0
    -- 随机第一个属性
    local roll_1 = Util:TabRandom(attr_list)
    for k, v in pairs(attr_list) do
        if roll_1 == v then attr_list[k] = nil end
    end
    -- 第一个属性加值
    local add_1 = math.random(0, sy_attr)
    if roll_1 == 1 then add_ll = add_1 end
    if roll_1 == 2 then add_mj = add_1 end
    if roll_1 == 3 then add_zl = add_1 end
    sy_attr = sy_attr - add_1
    -- 随机第二个属性
    local roll_2 = Util:TabRandom(attr_list)
    for k, v in pairs(attr_list) do
        if roll_2 == v then attr_list[k] = nil end
    end
    -- 第二个属性加值
    local add_2 = math.random(0, sy_attr)
    if roll_2 == 1 then add_ll = add_2 end
    if roll_2 == 2 then add_mj = add_2 end
    if roll_2 == 3 then add_zl = add_2 end
    sy_attr = sy_attr - add_2
    local add_3 = sy_attr
    -- 随机第二个属性
    local roll_3 = Util:TabRandom(attr_list)
    if roll_3 == 1 then add_ll = add_3 end
    if roll_3 == 2 then add_mj = add_3 end
    if roll_3 == 3 then add_zl = add_3 end

    local init_ll = 0
    local init_mj = 0
    local init_zl = 0

    local all_ll = (init_ll + add_ll + save_attr) / 100
    local all_mj = (init_mj + add_mj + save_attr) / 100
    local all_zl = (init_zl + add_zl + save_attr) / 100

    self.Data[ID].attr.llcz = utilex:FloatSet(all_ll, 1)
    self.Data[ID].attr.mjcz = utilex:FloatSet(all_mj, 1)
    self.Data[ID].attr.zlcz = utilex:FloatSet(all_zl, 1)
end

-- 固定成长属性
function HeroData:BaseGain(ID)
    self.Data[ID].attr.llcz = self.Data[ID].attr.llcz + 0.36
    self.Data[ID].attr.mjcz = self.Data[ID].attr.mjcz + 0.36
    self.Data[ID].attr.zlcz = self.Data[ID].attr.zlcz + 0.36
end
