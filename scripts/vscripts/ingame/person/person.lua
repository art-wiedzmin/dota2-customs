--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


if Person == nil then
    Person = class({})
    require("ingame.Person.Config")
    require("ingame.Person.Set")
    require("ingame.Person.Get")
    require("ingame.Person.Ui")
end

function Person:Init(ID)
    if not ID then
        return
    end
    self.Data[ID] = Util:DeepCopyTab(self.Template)
end

--- user.daily_game_bonus_day 转为 YYYYMMDD（与 Util:GetDate() 同源本地日历）
local function Person_bonusDayDigits8(stored)
    if not stored then
        return ""
    end
    local d = string.gsub(tostring(stored), "%D", "")
    return string.sub(d, 1, 8)
end

--- 读取登录用户表中的完赛金豆字段，写入 daily_game_bonus_today（0～5）
function Person:ApplyDailyGameBonusFromUser(ID, user)
    if not ID or not user or not self.Data[ID] then
        return
    end
    local today = Util:GetDate()
    local sd = Person_bonusDayDigits8(user.daily_game_bonus_day)
    local cnt = tonumber(user.daily_game_bonus_count)
    if not cnt or cnt < 0 then
        cnt = 0
    end
    if sd ~= today or sd == "" then
        self.Data[ID].daily_game_bonus_today = 0
    else
        if cnt > 5 then
            cnt = 5
        end
        self.Data[ID].daily_game_bonus_today = cnt
    end
    local tpcf = tonumber(user.tpcf)
    if not tpcf or tpcf < 0 then
        tpcf = 0
    end
    self.Data[ID].tpcf = math.floor(tpcf)
end

--- 本模式天梯分是否已从服务端成功加载（用于结算防护）
function Person:IsLadderScoreSynced(ID, game_tp)
    if not ID or not self.Data[ID] then
        return false
    end
    if game_tp == 1 or game_tp == 2 or game_tp == 3 then
        return self.Data[ID].score_synced_1v1 == true
    end
    return false
end

function Person:SetPersonData(ID, data)
    if not ID or not data then
        return
    end
    -- print("加载玩家战绩")
    -- print(data)
    local total = tonumber(data.total_games)
    local total1v1 = tonumber(data.total_games2)
    local win = tonumber(data.win_count)
    local tag7 = tonumber(data.tag7_count)
    if not total then
        total = 0
    end
    if not total1v1 then
        total1v1 = 0
    end
    if not win then
        win = 0
    end
    if not tag7 then
        tag7 = 0
    end
    local total_all_modes = total + total1v1
    local p5 = tonumber(data.point)
    if p5 ~= nil and p5 >= 0 then
        self.Data[ID].point = p5
        self.Data[ID].score_synced_5v5 = true
    else
        self.Data[ID].score_synced_5v5 = false
    end
    local p1 = tonumber(data.point2)
    if p1 ~= nil and p1 >= 0 then
        self.Data[ID].point2 = p1
        self.Data[ID].score_synced_1v1 = true
    else
        self.Data[ID].score_synced_1v1 = false
    end
    self.Data[ID].high_point = data.highest_point
    self.Data[ID].win_count = win
    self.Data[ID].total_game = total
    self.Data[ID].lose_count = data.lose_count

    self.Data[ID].highest_point2 = data.highest_point2
    self.Data[ID].total_game2 = data.total_games2
    self.Data[ID].top_count = data.top_count
    self.Data[ID].top3_count = data.top3_count
    if data.bot_time then
        self.Data[ID].bot_time = data.bot_time
    end
    self.Data[ID].tags.tag1 = data.tag1_count
    self.Data[ID].tags.tag2 = data.tag2_count
    self.Data[ID].tags.tag3 = data.tag3_count
    self.Data[ID].tags.tag4 = data.tag4_count
    self.Data[ID].tags.tag5 = data.tag5_count
    self.Data[ID].tags.tag6 = data.tag6_count
    self.Data[ID].tags.tag7 = data.tag7_count
    self.Data[ID].tags.tag8 = data.tag8_count
    self.Data[ID].tags.tag9 = data.tag9_count
    self.Data[ID].tags.tag10 = data.tag10_count
    self.Data[ID].tags.tag11 = data.tag11_count
    self.Data[ID].tags.tag12 = data.tag12_count
    self.Data[ID].tags.tag13 = data.tag13_count
    self.Data[ID].tags.tag14 = data.tag14_count
    self.Data[ID].tags.tag15 = data.tag15_count
    -- total==0 时避免 0/0 → nan，百分比按 0
    local win_num = total > 0 and (win / total * 100) or 0
    self.Data[ID].win_rate = utilex:FloatSet(win_num, 1)
    -- 逃跑率 = 逃跑称号(tag7)次数 / 全模式总场数（5v5+3x4 计 total_games，1v1 计 total_games2）
    local run_num = total_all_modes > 0 and (tag7 / total_all_modes) * 100 or 0
    self.Data[ID].run_rate = math.floor(run_num + 0.5)
    self:ApplyDailyGameBonusFromUser(ID, data)
    self:SendData(ID)

    if Rank and Rank.Data and Rank.Data[ID] and Rank.Data[ID].data then
        Rank.Data[ID].data.point = Person.Data[ID].point
        Rank.Data[ID].data.point2 = Person.Data[ID].point2
        if Rank.Data[ID].page then
            Rank:SendData(ID)
        end
    end
end
