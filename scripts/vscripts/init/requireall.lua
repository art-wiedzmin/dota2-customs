--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 必须先于任意 AddNewModifier：modifier_all 不可放在 Pre_Resource 条件块内，否则可能从未执行
require("init.precache.modifier_all")
require("init.precache.precacheresource") -- 预加载资源
require("util.util")                      -- 自定义工具包
require("util.utilex")                    -- 自定义拓展工具包
require("util.timersv5")                  -- timer
require("util.animations")                -- 动画工具
require("util.notifications")             -- 提示字
require("util.NotifyUtil")                -- 提示字
require("util.table")                     -- 表工具
require("util.string")                    -- 字符工具
require("util.bit")                       -- 位运算
require("util.RedTip")                    -- 技能提示

JSON = require("util.dkjson")
EntityHelper = require("util.EntityHelper") -- 实体工具
PlayerUtil = require("util.PlayerUtil")     -- 玩家工具
NotifyUtil = require("util.NotifyUtil")     -- 封装提示工具
TimerUtil = require("util.TimerUtil")       -- 时间工具
DotaEx = require("util.DotaEx")

require("listener.customsets")          -- 自定义设置
-- 游戏内系统加载
require("ingame.InitPlayer.InitPlayer") -- 初始玩家
require("ingame.SelectHero.SelectHero") -- 选英雄
require("ingame.Book.Book")             -- 图鉴（依赖 HeroList，需在 SelectHero 之后）
require("ingame.MainGame.MainGame")     -- 游戏开始
require("ingame.Monster.Monster")       -- 游戏开始
require("ingame.Prophecy.Prophecy")     -- 预言卡
require("ingame.HeroData.HeroData")     -- 游戏开始
require("ingame.Item.Item")             -- 游戏开始
require("ingame.Box.Box")               -- 游戏开始
require("ingame.Talent.Talent")         -- 游戏开始
require("ingame.Skill.Skill")           -- 游戏开始
require("ingame.Pack.Pack")             -- 游戏开始
require("ingame.OverData.OverData")     -- 游戏开始
require("ingame.Person.Person")         -- 游戏开始
require("ingame.Stat.Stat")             -- 游戏开始
require("ingame.OverStat.OverStat")     -- 结算扩展统计（依赖 Skill / Stat / HeroData）
require("ingame.HeroCard.HeroCard")     -- 顶部栏英雄信息卡
require("ingame.Shop.Shop")             -- 游戏开始
require("ingame.HolidayPack.HolidayPack") -- 节日礼包
require("ingame.Rank.Rank")             -- 游戏开始
require("ingame.Point.Point")           -- 游戏开始
require("ingame.Code.Code")             -- 游戏开始
require("ingame.Server.Server")         -- 游戏开始
require("ingame.Http.Http")             -- 游戏开始
require("ingame.Msgs.Msgs")             -- 游戏开始
require("ingame.Pet.Pet")               -- 游戏开始
require("ingame.Title.Title")           -- 头顶称号
require("ingame.Effect.Effect")         -- 周身特效
require("ingame.AttackEffect.AttackEffect") -- 攻击弹道特效
require("ingame.ShowMsg.ShowMsg")       -- 游戏开始
require("ingame.Invite.Invite")         -- 游戏开始
require("ingame.Boot.Boot")             -- 游戏开始
require("ingame.EazyShop.EazyShop")     -- 游戏开始
require("ingame.KeySet.KeySet")         -- 游戏开始
require("ingame.Achieve.Achieve")       -- 成就系统
require("ingame.LeaveConfirm.LeaveConfirm") -- 中途离开确认
require("ingame.DevTools.DevTools")     -- 本地工具模式面板