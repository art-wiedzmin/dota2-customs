--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 治疗过滤（含普攻吸血 / 撒旦等引擎走 Heal 的回复）。
-- Tools 模式下在服务端控制台打印；正式对局不刷屏。
function CustomSets:Heal_Filter(keys)
    if IsInToolsMode() and IsServer() then
        local h = tonumber(keys.heal) or 0
        if h ~= 0 then
            local inflictor_name = "nil"
            local inf_idx = tonumber(keys.entindex_inflictor_const) or -1
            if inf_idx > 0 then
                local inf = EntIndexToHScript(inf_idx)
                if inf and not inf:IsNull() then
                    if type(inf.GetAbilityName) == "function" then
                        inflictor_name = inf:GetAbilityName()
                    elseif type(inf.GetUnitName) == "function" then
                        inflictor_name = "ent:" .. tostring(inf:GetUnitName())
                    else
                        inflictor_name = tostring(inf)
                    end
                end
            end
            -- local tgt_idx = tonumber(keys.entindex_target_const)
            -- local healer_idx = tonumber(keys.entindex_healer_const)
            -- if healer_idx then
            --     local healer = EntIndexToHScript(healer_idx)
            --     if healer and not healer:IsNull() and healer:HasModifier("modifier_talent_2_aura_debuff") then
            --         h = math.floor(h * 0.7)
            --     end
            -- end
            -- if h > 5 then
            --     print(string.format(
            --         "[HealFilter] heal=%s target_ent=%s healer_ent=%s inflictor=%s",
            --         tostring(h),
            --         tostring(tgt_idx),
            --         tostring(healer_idx),
            --         inflictor_name
            --     ))
            -- end
        end
    end
    return true
end