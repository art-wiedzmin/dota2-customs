--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if ShowMsg == nil then
    ShowMsg = class({})
end
require("ingame.ShowMsg.Config")
--颜色
ShowMsg.Color = {
    --物理
    Physical = Vector(96, 96, 96),
    --魔法
    Magical = Vector(0, 102, 255),
    --纯粹
    Pure = Vector(184, 226, 226),
    --物理暴击
    PhyCrit = Vector(255, 51, 0),
    --魔法暴击
    MagCrit = Vector(0, 0, 102),
    --回血
    Heal = Vector(51, 204, 51),
    --金色
    punch = Vector(255, 234, 0)
}

--特效文件
ShowMsg.FxFile = {
    "particles/msg_fx/msg_damage.vpcf",                  --1
    "particles/msg_fx/msg_countdown.vpcf",               --2
    "particles/msg_fx/msg_crit_damage.vpcf",             --3
    "particles/msg_fx/msg_damage.vpcf",                  --4
    "particles/msg_fx/msg_damage_2.vpcf",                --5
    "particles/msg_fx/msg_damage_3.vpcf",                --6
    "particles/msg_fx/msg_damage_4.vpcf",                --7
    "particles/msg_fx/msg_damage_hero.vpcf",             --8
    "particles/msg_fx/msg_damage_numbers_3.vpcf",        --9
    "particles/msg_fx/msg_damage_sle.vpcf",              --10
    "particles/msg_fx/msg_infinity.vpcf",                --11
    "particles/msg_fx/other/msg_countdown.vpcf",         --12
    "particles/msg_fx/other/msg_crit_damage.vpcf",       --13
    "particles/msg_fx/other/msg_damage.vpcf",            --14
    "particles/msg_fx/other/msg_damage_hero.vpcf",       --15
    "particles/msg_fx/other/msg_damage_other.vpcf",      --16
    "particles/msg_fx/other/msg_damage_sle.vpcf",        --17
    "particles/msg_fx/msg_evade.vpcf",                   --18
    "particles/msg_fx/msg_heal.vpcf",                    --19 --默认伤害类型
    "particles/msg_fx/msg_damage_numbers_outgoing.vpcf", --20 魔法伤害
    "particles/msg_fx/msg_crit.vpcf",                    --21 魔法暴击
    "particles/msg_fx/msg_damage_numbers_outgoing.vpcf", --22  物理伤害
    "particles/msg_fx/msg_crit.vpcf",                    --23  物理暴击
}

--默认使用第1个特效文件
ShowMsg.DefaultFxIndex = 19
--默认显示字体大小
ShowMsg.DefaultSize = 3
--默认位置 备选PATTACH_CENTER_FOLLOW
ShowMsg.DefaultAttach = PATTACH_OVERHEAD_FOLLOW
--默认偏移
ShowMsg.DefaultOffset = Vector(0, 0, 300)
--默认前缀
ShowMsg.DefaultHead = 1
--默认后缀
ShowMsg.DefaultTail = 0
--默认持续时间
ShowMsg.DefaultDuration = 2
--是否显示前缀
ShowMsg.ShowHead = true

--选择一个特效
function ShowMsg:GetFxFile(index)
    if not index then
        index = ShowMsg.DefaultFxIndex
    end
    return ShowMsg.FxFile[index]
end

function ShowMsg:TeamMsg(tab)
    local at = tab.at
    if not at then return end
    if at:IsNull() then return end
    local team = at:GetTeamNumber()
    if not team then return end
    local ta = tab.ta
    if not ta then return end
    if ta:IsNull() then return end
    if at:IsIllusion() then
        at = at:GetOwner()
    end
    local ID = at.OwnerID or Util:Hero2ID(at)
    if not ID then return end

    --存储特效控制点数据
    local ttab = {} --总表
    local ptab = {} --单个控制点存储表

    --特效string
    local FxFile = self:GetFxFile(tab.index)
    --创建
    --   local fx=ParticleManager:CreateParticleForTeam(FxFile,PATTACH_CUSTOMORIGIN,nil,team)
    --附着位置
    local attach = tab.attach or ShowMsg.DefaultAttach
    --坐标+偏移
    local pos = ta:GetAbsOrigin() + (tab.offset or ShowMsg.DefaultOffset)

    --位置设置
    --   ParticleManager:SetParticleControlEnt(fx,0,ta,attach,nil,pos,true)
    ptab.index = 0
    ptab.isfollow = ta
    ptab.hit = attach
    ptab.pos = pos
    table.insert(ttab, ptab)
    --前后缀符号 伤害
    local head = tab.head or ShowMsg.DefaultHead
    local tail = tab.tail or ShowMsg.DefaultTail
    local dmg = tab.dmg or 0
    dmg = math.ceil(dmg)

    if dmg < 100000 then
    elseif dmg >= 100000 and dmg < 1000000000 then --十万
        dmg = math.ceil(dmg / 10000)
        tail = 3
    elseif dmg >= 1000000000 and dmg < 1000000000000 then --十亿
        dmg = math.ceil(dmg / 100000000)
        tail = 2
    elseif dmg >= 1000000000000 and dmg < 10000000000000000 then --万亿
        dmg = math.ceil(dmg / 1000000000000)
        tail = 32
    elseif dmg >= 10000000000000000 and dmg < 100000000000000000000 then --京
        dmg = math.ceil(dmg / 10000000000000000)
        tail = 8
    elseif dmg >= 100000000000000000000 then --万京
        dmg = math.ceil(dmg / 100000000000000000000)
        tail = 38
    end
    --   ParticleManager:SetParticleControl(fx,1,Vector(head,dmg,tail))
    ptab = {}
    ptab.index = 1
    ptab.pos = Vector(head, dmg, tail)
    table.insert(ttab, ptab)
    --持续时间
    local duration = tab.duration or ShowMsg.DefaultDuration
    local len = string.len(tostring(dmg))

    --显示前缀
    if tab.showhead then
        len = len + 1
    end

    --显示后缀
    if tail > 0 then
        len = len + string.len(tostring(tail))
    end

    --   ParticleManager:SetParticleControl(fx,2,Vector(duration,len,0))
    ptab = {}
    ptab.index = 2
    ptab.pos = Vector(duration, len, 0)
    table.insert(ttab, ptab)
    --颜色
    local tp
    if tab.tp == DAMAGE_TYPE_PHYSICAL then
        tp = "Physical"
    elseif tab.tp == DAMAGE_TYPE_MAGICAL then
        tp = "Magical"
    elseif tab.tp == DAMAGE_TYPE_PURE then
        tp = "Pure"
    else
        tp = tab.tp
    end

    local color = ShowMsg.Color[tp] or ShowMsg.Color.Physical

    --大小
    local size = tab.size or ShowMsg.DefaultSize
    --   ParticleManager:SetParticleControl(fx,4,Vector(size,0,0))
    ptab = {}
    ptab.index = 4
    ptab.pos = Vector(size, size, 300)
    table.insert(ttab, ptab)
    --   Timers(1.5,function()
    --       ParticleManager:DestroyParticle(fx,true)
    --       ParticleManager:ReleaseParticleIndex(fx)
    --   end)
    ShowMsg:CreateParticle_msg(ID, FxFile, PATTACH_CUSTOMORIGIN, nil, ttab, 1.5, color)
end

function ShowMsg:CreateParticle_msg(ID, ptname, attach, owner, tab, dy, color)
    if not ID then return end
    if not attach then return end
    local tx_sum = {}
    local ID_Sum = Util:NoAbandonedIDs()
    for k, v in pairs(ID_Sum) do
        if Util:IsPseudoPlayerID(v) then
            goto continue
        end
        local player = Util:ID2Player(v)
        if not player or type(player) ~= "userdata" then
            goto continue
        end
        local ok, particle = pcall(ParticleManager.CreateParticleForPlayer, ParticleManager, ptname, attach, owner, player)
        if not ok or not particle then
            goto continue
        end
        for m, n in pairs(tab) do
            if n.isfollow then
                Util:ParticleSetControlEntHitlocOrAbsFollow(particle, n.index, n.isfollow)
            else
                ParticleManager:SetParticleControl(particle, n.index, n.pos)
            end
        end
        ParticleManager:SetParticleControl(particle, 3, color)
        table.insert(tx_sum, particle)
        ::continue::
    end

    Timers(dy, function()
        for k, v in pairs(tx_sum) do
            ParticleManager:DestroyParticle(v, true)
            ParticleManager:ReleaseParticleIndex(v)
        end
    end)
end

function ShowMsg:ShowGoodDmageMsg(ca, ta, num, dmtp)
    local tab = {
        at = ca,
        ta = ta,
        dmg = num,
        tp = dmtp,
    }
    tab.index = ShowMsg:GetParticleIndex(dmtp)
    if dmtp == "PhyCrit" or dmtp == "MagCrit" then
        tab.showhead = false
        tab.head = 10
    end
    self:TeamMsg(tab)
end

--获取特效
function ShowMsg:GetParticleIndex(dmtp)
    if dmtp == DAMAGE_TYPE_MAGICAL then
        return 20
    end
    if dmtp == "MagCrit" then
        return 21
    end
    if dmtp == DAMAGE_TYPE_PHYSICAL then
        return 22
    end
    if dmtp == "PhyCrit" then
        return 23
    end
    if dmtp == "Heal" then
        return 19
    end
    if dmtp == "Miss" then
        return 18
    end
    return 18
end
