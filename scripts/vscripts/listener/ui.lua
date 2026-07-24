function Lua_SelectHero(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    SelectHero:GetUIData(ID, data)
end

function Lua_HeroData(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    HeroData:GetUIData(ID, data)
end

function Lua_TalentData(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Talent:GetUIData(ID, data)
end

function Lua_BoxData(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Box:GetUIData(ID, data)
end

function Lua_SkillData(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Skill:GetUIData(ID, data)
end

function Lua_PackData(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Pack:GetUIData(ID, data)
end

function Lua_OverData(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    OverData:GetUIData(ID, data)
end

function Lua_Person(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Person:GetUIData(ID, data)
end

function Lua_Shop(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Shop:GetUIData(ID, data)
end

function Lua_HolidayPack(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    HolidayPack:GetUIData(ID, data)
end

function Lua_Rank(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Rank:GetUIData(ID, data)
end

function Lua_Point(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Point:GetUIData(ID, data)
end

function Lua_Code(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Code:GetUIData(ID, data)
end

function Lua_Stat(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Stat:GetUIData(ID, data)
end

function Lua_HeroCard(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    HeroCard:GetUIData(ID, data)
end

function Lua_Monster(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Monster:GetUIData(ID, data)
end

function Lua_Prophecy(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Prophecy:GetUIData(ID, data)
end

function Lua_Msgs(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Msgs:GetUIData(ID, data)
end

function Lua_Invite(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Invite:GetUIData(ID, data)
end

function Lua_Book(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    Book:GetUIData(ID, data)
end

function Lua_EazyShop(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    EazyShop:GetUIData(ID, data)
end

function Lua_KeySet(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    KeySet:GetUIData(ID, data)
end

function Lua_Achieve(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    AchieveModule:GetUIData(ID, data)
end

function Lua_LeaveConfirm(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    LeaveConfirm:GetUIData(ID, data)
end

function Lua_DevTools(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    DevTools:GetUIData(ID, data)
end

function Lua_Team(index, keys)
    local ID = keys.PlayerID
    local data = Util:DecodeUIData(keys)
    if not data or not data.tp then
        return
    end

    local player = PlayerResource:GetPlayer(ID)
    local game_rules = rawget(_G, "GameRules")
    local is_host = player and game_rules and game_rules.PlayerHasCustomGameHostPrivileges and
        game_rules:PlayerHasCustomGameHostPrivileges(player)

    local function ui_team_bot_config_broadcast()
        Boot.Config.bot_passive_mode = false
        if MainGame and MainGame.Data then
            MainGame.Data.passive_mode = false
        end
        local d = tonumber(Boot.Config.bot_difficulty) or 0
        Util:Send2JsBotsSafe("UI_TeamBotConfig", {
            difficulty = d,
            enabled = (Boot.Config.enable_bot_players or d > 0) and 1 or 0,
            passive_mode = 0,
        })
    end

    if data.tp == "init" then
        ui_team_bot_config_broadcast()
        return
    end

    if not is_host then
        return
    end

    if data.tp == "set_bot_difficulty" then
        local d = tonumber(data.difficulty) or 0
        if d < 0 then d = 0 end
        if d > 3 then d = 3 end
        Boot.Config.bot_difficulty = d
        Boot.Config.enable_bot_players = d > 0
        if BotAI and BotAI.ApplyConfigPreset then
            BotAI:ApplyConfigPreset()
        end
        ui_team_bot_config_broadcast()
        return
    end

    if data.tp == "toggle_bot_players" then
        local enabled = data.enabled
        local on = enabled == 1 or enabled == true or enabled == "1" or enabled == "true"
        Boot.Config.enable_bot_players = on
        Boot.Config.bot_difficulty = on and 2 or 0
        if BotAI and BotAI.ApplyConfigPreset then
            BotAI:ApplyConfigPreset()
        end
        ui_team_bot_config_broadcast()
        return
    end
end

local Ui_Reg_Tab = {
    Lua_SelectHero = Lua_SelectHero,
    Lua_HeroData = Lua_HeroData,
    Lua_BoxData = Lua_BoxData,
    Lua_TalentData = Lua_TalentData,
    Lua_SkillData = Lua_SkillData,
    Lua_PackData = Lua_PackData,
    Lua_OverData = Lua_OverData,
    Lua_Person = Lua_Person,
    Lua_Stat = Lua_Stat,
    Lua_HeroCard = Lua_HeroCard,
    Lua_Shop = Lua_Shop,
    Lua_HolidayPack = Lua_HolidayPack,
    Lua_Rank = Lua_Rank,
    Lua_Point = Lua_Point,
    Lua_Code = Lua_Code,
    Lua_Monster = Lua_Monster,
    Lua_Prophecy = Lua_Prophecy,
    Lua_Msgs = Lua_Msgs,
    Lua_Invite = Lua_Invite,
    Lua_Book = Lua_Book,
    Lua_Team = Lua_Team,
    Lua_EazyShop = Lua_EazyShop,
    Lua_KeySet = Lua_KeySet,
    Lua_Achieve = Lua_Achieve,
    Lua_LeaveConfirm = Lua_LeaveConfirm,
    Lua_DevTools = Lua_DevTools,
}

function CustomSets:UiRegister()
    if not CustomSets.Ui_Has_Reg then CustomSets.Ui_Has_Reg = {} end

    -- 注册全局
    for k, v in pairs(Ui_Reg_Tab) do
        if not CustomSets.Ui_Has_Reg[k] then
            CustomGameEventManager:RegisterListener(k, v)
            CustomSets.Ui_Has_Reg[k] = true
        end
    end
end
