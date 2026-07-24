--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--如果在游戏结算之前，所有玩家全部掉线，并且是非人机局，就返还玩家本局消耗的所有豆子，（此方法在确认所有玩家掉线后只执行一次）
function Server:ReturnAllGold()
    if not IsServer() then
        return
    end

    if not MainGame or not MainGame.Data or MainGame.Data.over == true then
        return
    end
    if not InitPlayer or not InitPlayer.Public or not InitPlayer.Public.players then
        return
    end
    if not Shop or not Shop.Data then
        return
    end

    local any_bot = false
    local human_ids = {}
    for _, row in pairs(InitPlayer.Public.players) do
        if row and row.id ~= nil and type(row.id) == "number" then
            if row.bot then
                any_bot = true
            else
                human_ids[#human_ids + 1] = row.id
            end
        end
    end

    -- 非人机局：本局无任何 bot 槽位
    if any_bot then
        return
    end
    if #human_ids == 0 then
        return
    end
    -- 全部真人玩家均不在线（CONNECTED 视为仍在线）
    for _, hid in ipairs(human_ids) do
        if Util:ID2IfOnline(hid) then
            return
        end
    end
    if self._return_all_gold_done then
        return
    end
    for _, hid in ipairs(human_ids) do
        local sd = Shop.Data[hid]
        if sd then
            local cost = tonumber(sd.cost) or 0
            if cost > 0 then
                cost = math.floor(cost + 0.5)
                sd.gold = (tonumber(sd.gold) or 0) + cost
                sd.cost = 0
                Shop:SyncGold(hid)
            end
        end
    end
    self._return_all_gold_done = true

    -- 上传简报：Skill.Skill1 槽位中的 dota 技能 id；mj/sz=魔晶、神杖 0/1
    table.sort(human_ids)
    local segs = { "[GameBreak]" }
    for _, hid in ipairs(human_ids) do
        local mj = 0
        local sz = 0
        local hero = HeroData and HeroData.GetHero and HeroData:GetHero(hid)
        if hero and not hero:IsNull() then
            if hero:HasModifier("modifier_item_aghanims_shard") then
                mj = 1
            end
            if hero:HasModifier("modifier_item_ultimate_scepter") then
                sz = 1
            end
        end
        local ids = {}
        local s1 = Skill and Skill.Data and Skill.Data[hid] and Skill.Data[hid].Skill1
        if s1 then
            for _, key in ipairs({ "slot_1", "slot_2", "slot_3", "slot_4" }) do
                local sl = s1[key]
                if sl and sl.id ~= nil then
                    local idn = tonumber(sl.id)
                    if idn and idn > -1 then
                        ids[#ids + 1] = tostring(idn)
                    end
                end
            end
        end
        local id_str = #ids > 0 and table.concat(ids, ",") or ""
        local tail = id_str ~= "" and (" " .. id_str) or ""
        segs[#segs + 1] = string.format("p%d mj%d sz%d%s", hid, mj, sz, tail)
    end
    local err_text = table.concat(segs, " ")
    Server:SendError(err_text, "GameBreak")
end
