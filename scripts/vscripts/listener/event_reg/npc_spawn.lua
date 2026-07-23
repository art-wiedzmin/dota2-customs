--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


require("ingame.modifier.modifier_clrb_talents")

function CustomSets:Npc_Spawn(key)
    local index = key.entindex
    if not index then return end
    local Entity = Util:Index2Entity(index)
    if not Entity then return end
    if Entity:IsNull() then return end
    -- 幻象 / 风暴双雄等：继承战斗属性与普通攻击，摘除全部技能（本体见 IsRealHero 分支）
    if Entity:IsHero() then
        Util:ApplyIllusionHeroNoAbilitiesRule(Entity)
    end
    if not Entity:IsRealHero() then return end
    -- 大圣：立即移除猴子猴孙技能，防止进游戏时饰品产生幻象导致宝宝跟随bug
    if Entity:GetUnitName() == "npc_dota_hero_monkey_king" then
        for _, ab_name in ipairs({ "monkey_king_wukongs_command", "monkey_king_untransform", "monkey_king_transfiguration" }) do
            if Entity:HasAbility(ab_name) then
                Entity:RemoveAbility(ab_name)
            end
        end
    end
    local ID = Util:Hero2ID(Entity)
    if not ID then return end
    if ID and Entity:IsHero() then
        local init_data = InitPlayer and InitPlayer.GetPlayerData and InitPlayer:GetPlayerData(ID)
        if not (init_data and init_data.bot) and ClrbEnsureTalentItemInTpSlot then
            ClrbEnsureTalentItemInTpSlot(Entity)
        end
        ---设置英雄索引
        HeroData:SetHeroIndex(ID, Entity)
        Talent:TryApplyPendingEquipAttr(ID)
        if not Entity:HasModifier("modifier_clrb_int_spell_amp") then
            Entity:AddNewModifier(Entity, nil, "modifier_clrb_int_spell_amp", {})
        end
        Entity.attrlist = {
            jcgjl = 0
        }
        -- 仅整场第一次把英雄放到 init*：用标志位，勿再用 hero_data.init==false。
        -- 否则 InitHero 未成功置 init 的人机、或复活时再次触发 npc_spawn 时，0.2s 后仍会拉回出生点，盖住人机随机复活。
        Timers(0.2, function()
            local h = Util:ID2Hero(ID)
            if not h or h:IsNull() then
                return
            end
            local hero_init_pos = HeroData:HeroInitPos(ID)
            local hero_data = HeroData.Data[ID]
            if hero_init_pos and hero_data and not hero_data._clrb_first_spawn_place_done then
                hero_data._clrb_first_spawn_place_done = true
                h:SetAbsOrigin(hero_init_pos)
                FindClearSpaceForUnit(h, hero_init_pos, true)
            end
        end)
        -- 选完人断线、异步出真：仅当**仍无 HPlayer** 时跳过 Init；若出怪时玩家已重连则照常 Timers
        local p_lookup = Util and Util.ID2Player and Util.ID2Player(Util, ID)
        local still_no_player = not p_lookup
        local defer_inithero = init_data and init_data.clrb_defer_inithero_until_reconnect and still_no_player
        if not defer_inithero then
            Timers(1, function() HeroData:InitHero(ID, Entity) end)
            Timers(3, function() HeroData:InitHero(ID, Entity) end)
            Timers(5, function() HeroData:InitHero(ID, Entity) end)
        else
            -- 断线异步出真：若出怪后玩家很快重连，补绑 CPlayer（避免等第二次重连）
            for _, delay in ipairs({ 0, 0.5, 1.5 }) do
                Timers(delay, function()
                    if not PlayerResource or not PlayerResource.IsValidPlayer or not PlayerResource:IsValidPlayer(ID) then
                        return
                    end
                    if not SelectHero or not SelectHero.ApplyEnginePickForPlayer then
                        return
                    end
                    if not init_data or not init_data.hero_name or init_data.hero_name == "" then
                        return
                    end
                    SelectHero:ApplyEnginePickForPlayer(ID, init_data.hero_name, false)
                end)
            end
        end
    end
    return true
end