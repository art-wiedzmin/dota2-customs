--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


if Pre_Resource == nil then
    Pre_Resource = class({})
end

--- 同一加载周期内每种资源只注册一次，避免 KV 递归扫描重复路径；并降低顶到引擎 CLoadingResource 上限（约 32767）的风险。
function Pre_Resource:PrecacheResourceDedup(kind, path, context)
    if type(path) ~= "string" or path == "" then
        return
    end
    if not self._precache_seen then
        self._precache_seen = {}
    end
    local key = tostring(kind) .. "\0" .. path
    if self._precache_seen[key] then
        return
    end
    self._precache_seen[key] = true
    PrecacheResource(kind, path, context)
end
-- 英雄名字集
Pre_Resource.HeroNames = require('init.precache.heronames')
-- 技能特效集
Pre_Resource.Particles = require('init.precache.particlessets')
-- 声音集
Pre_Resource.Sounds = require('init.precache.soundsets')
-- 声音集
Pre_Resource.Models = require('init.precache.modelsets')

function Pre_Resource:StartLoad(context)
    self:SetClientKey()
    self:LoadHeroSounds(context)
    self:LoadParticles(context)
    self:LoadSounds(context)
    self:LoadModels(context)
    self:LoadFromKv(context)
end

function Pre_Resource:LoadHeroSounds(context)
    local temp = Pre_Resource.HeroNames
    for i = 1, #temp do
        -- PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_" .. temp[i] .. ".vsndevts", context)
        -- PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_" .. temp[i] .. ".vsndevts", context)
    end
end

function Pre_Resource:LoadParticles(context)
    local temp = Pre_Resource.Particles
    for i = 1, #temp do
        self:PrecacheResourceDedup("particle", temp[i], context)
    end
end

function Pre_Resource:LoadSounds(context)
    local temp = Pre_Resource.Sounds
    for i = 1, #temp do
        self:PrecacheResourceDedup("soundfile", temp[i], context)
    end
end

function Pre_Resource:LoadModels(context)
    local temp = Pre_Resource.Models
    for i = 1, #temp do
        self:PrecacheResourceDedup("model", temp[i], context)
    end
end

function Pre_Resource:LoadFromKv(context)
    -- 勿对 Valve 整套 npc_heroes.txt / items.txt / npc_units.txt 做递归 Precache：
    -- 会把 CLoadingResource 链表撑到引擎 16 位上限（观战/客户端易 FATAL 32767）。
    -- 仅扫描本图 custom 与玩法相关 KV；英雄拆分见 LoadFromKvHeroSplitFiles + activelist。
    local kv_files = {
        -- "scripts/npc/npc_abilities.txt",
        "scripts/npc/npc_abilities_custom.txt",
        -- "scripts/npc/items.txt",
        "scripts/npc/npc_items_custom.txt",
        -- "scripts/npc/npc_heroes.txt",
        "scripts/npc/npc_heroes_custom.txt",
        -- "scripts/npc/npc_units.txt",
        "scripts/npc/npc_units_custom.txt",
    }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then self:PrecacheEverythingFromTable(context, kvs) end
    end
    -- 运行时无法枚举目录；按 activelist 白名单加载 scripts/npc/heroes/*.txt（与文件名 npc_dota_hero_* 对应）
    self:LoadFromKvHeroSplitFiles(context)
end

--- scripts/npc/heroes/ 下按英雄拆分的 KV：无法 listdir，用 activelist 里的 npc_dota_hero_* 拼路径逐个 LoadKeyValues。
--- 若目录里有额外英雄文件但不在 activelist，可把路径表放到 Pre_Resource.ExtraHeroKvPaths（可选）。
function Pre_Resource:LoadFromKvHeroSplitFiles(context)
    local wl = LoadKeyValues("scripts/npc/activelist.txt")
    local list = wl and (wl.whitelist or wl.Whitelist)
    if type(list) ~= "table" then
        return
    end
    for hero_key, _ in pairs(list) do
        if type(hero_key) == "string" and string.match(hero_key, "^npc_dota_hero_") then
            local path = "scripts/npc/heroes/" .. hero_key .. ".txt"
            local kvs = LoadKeyValues(path)
            if kvs then
                self:PrecacheEverythingFromTable(context, kvs)
            end
        end
    end
    local extra = Pre_Resource.ExtraHeroKvPaths
    if type(extra) == "table" then
        for i = 1, #extra do
            local p = extra[i]
            if type(p) == "string" and p ~= "" then
                local kvs = LoadKeyValues(p)
                if kvs then
                    self:PrecacheEverythingFromTable(context, kvs)
                end
            end
        end
    end
end

-- 全加载
function Pre_Resource:PrecacheEverythingFromTable(context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            self:PrecacheEverythingFromTable(context, value)
        else
            if string.find(value, "vpcf") then
                self:PrecacheResourceDedup("particle", value, context)
            end
            if string.find(value, "vmdl") then
                self:PrecacheResourceDedup("model", value, context)
            end
            if string.find(value, "vsndevts") then
                self:PrecacheResourceDedup("soundfile", value, context)
            end
        end
    end
end

--[[
local m={}
function m.DumpOut()
  local key=CustomNetTables:GetTableValue("ntab","miyao")
  return key
end
return m
]]
function Pre_Resource:SetClientKey()
    -- 传到网表
    CustomNetTables:SetTableValue("ntab", "miyao", { key = SKD_Key })
end