--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local function state_ok(v)
    return v == true or v == 1
end

local function attr_int(x)
    x = tonumber(x) or 0
    return math.floor(x)
end

-- 5v5：side + gid；1v10：row（与 Stat.js / Stat.Public 一致）
function HeroCard:ResolvePlayerIdFromSlot(data)
    if not data then
        return
    end
    local gt = MainGame:GetGameType()
    if gt == 1 or gt == 3 then
        local side = tonumber(data.side)
        local gid = tonumber(data.gid)
        if not side or not gid then
            return
        end
        local team = Stat.Public.list["team_" .. side]
        if not team or not team.list then
            return
        end
        local p = team.list["player_" .. gid]
        if p and state_ok(p.state) and p.id and p.id >= 0 then
            return p.id
        end
    elseif gt == 2 then
        local row = tonumber(data.row)
        if not row or row < 1 or row > 10 then
            return
        end
        local teams = {}
        for i = 1, 10 do
            local tk = "team_" .. i
            local td = Stat.Public.list[tk]
            if td and state_ok(td.state) then
                table.insert(teams, td)
            end
        end
        table.sort(teams, function(a, b)
            local ra = a.rank or 999
            local rb = b.rank or 999
            if ra ~= rb then
                return ra < rb
            end
            return (a.team or 0) < (b.team or 0)
        end)
        local td = teams[row]
        if not td or not td.team or not td.list then
            return
        end
        local p = td.list["player_" .. td.team]
        if p and state_ok(p.state) and p.id and p.id >= 0 then
            return p.id
        end
    end
end

-- 简化版：只发卡片展示需要的字段，减少 JSON 体积与前端复杂度
function HeroCard:BuildPayload(pid)
    if pid == nil or pid < 0 then
        return
    end
    local init_data = InitPlayer:GetPlayerData(pid)
    if not init_data then
        return
    end
    local hero = HeroData:GetHero(pid)
    local valid_hero = hero and not hero:IsNull()

    local level = 1
    local hp, hp_max, mana, mana_max = 0, 0, 0, 0
    local atk, armor = 0, 0
    local str, agi, int = 0, 0, 0
    if valid_hero then
        -- 先同步 hero_attr -> modifier_attr_buff（OnRefresh 内会调 BaseGjl 对齐 jcgj / modifier_gjljc），再算加成与攻击力
        HeroData:RefreshModifier(hero)
        hero:CalculateStatBonus(true)
        level = hero:GetLevel()
        hp = attr_int(Util:GetHealth(hero) or 0)
        hp_max = attr_int(Util:GetMaxHealth(hero) or 0)
        mana = attr_int(hero:GetMana() or 0)
        mana_max = attr_int(hero:GetMaxMana() or 0)
        atk = attr_int(Util:GetAverageTrueAttackDamage(hero))
        armor = attr_int(hero:GetPhysicalArmorValue(false) or 0)
        str = attr_int(hero:GetStrength() or 0)
        agi = attr_int(hero:GetAgility() or 0)
        int = attr_int(hero:GetIntellect(false) or 0)
    end
    local item_list = {
        slot_1 = "",
        slot_2 = "",
        slot_3 = "",
        slot_4 = "",
        slot_5 = "",
        slot_6 = "",

    }
    if valid_hero then
        for i = 0, 5 do
            local nm = ""
            local it = hero:GetItemInSlot(i)
            if it and not it:IsNull() then
                nm = it:GetName() or ""
            end
            local slot_key = "slot_" .. (i + 1)
            item_list[slot_key] = nm
        end
    end

    return {
        id = pid,
        hero_name = init_data.hero_name or "",
        bot = init_data.bot and 1 or 0,
        level = level,
        hp = hp,
        hp_max = hp_max,
        mana = mana,
        mana_max = mana_max,
        atk = atk,
        armor = armor,
        str = str,
        agi = agi,
        int = int,
        item_list = item_list,
    }
end

function HeroCard:PushPeerCardToPlayer(requester_id, data)
    if not requester_id or not data then
        return
    end
    local gt = MainGame and MainGame:GetGameType() or -1
    local pid = self:ResolvePlayerIdFromSlot(data)
    if not pid then
        return
    end
    local payload = self:BuildPayload(pid)
    if not payload then
        return
    end
    local ok, enc = pcall(function()
        return JSON.encode(payload)
    end)
    if not ok or not enc or enc == "" then
        return
    end

    Util:Send2JsID("UI_HeroCard", { j = enc }, requester_id)
end
