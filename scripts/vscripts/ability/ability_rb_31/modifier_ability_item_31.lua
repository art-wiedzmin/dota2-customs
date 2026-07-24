--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


-- 技能modifier
modifier_ability_item_31 = class({})

function modifier_ability_item_31:IsHidden()
    return true
end

function modifier_ability_item_31:IsPurgable()
    return false
end

function modifier_ability_item_31:OnCreated()
    if not IsServer() then return end
end

-- 声明修改函数
function modifier_ability_item_31:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_ability_item_31:OnDeath(params)
    if IsServer() then
        local unit = params.unit

        -- 检查死亡的单位是否是携带此modifier的单位
        if unit == self:GetParent() then
            local ab = unit:FindAbilityByName("ability_item_31")
            if not ab then return end
            local dam_pct = ab:GetSpecialValueFor("num1")
            local dam = unit:GetMaxHealth() * dam_pct / 100
            -- local model_size = unit:GetModelScale()
            local range = ab:GetSpecialValueFor("num2")
            local pos = unit:GetAbsOrigin()
            local range_per_step = ab:GetSpecialValueFor("num4")
            -- if model_size > 1 then
            --     local big_size = model_size - 1
            --     local big_pect = math.ceil(big_size / 0.1)
            --     range = range + (big_pect * range_per_step)
            -- end
            local stun_sec = ab:GetSpecialValueFor("num3")
            EmitSoundOn("Hero_Brewmaster.ThunderClap", unit)
            -- local tx1 = "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf"
            -- local tx2 = "particles/econ/events/monster_hunter/high_five_poogie_overhead.vpcf"
            local tx3 = "particles/units/heroes/hero_techies/techies_blast_off.vpcf"
            -- local tx4 = "particles/units/heroes/hero_earthshaker/earthshaker_totem_cast.vpcf"
            -- utilex:AddTx(tx1, unit, 1)
            -- utilex:AddTx(tx2, unit, 1)
            utilex:AddTx(tx3, unit, 1)
            -- utilex:AddTx(tx4, unit, 1)
            -- utilex:Repel(unit, 0.5, 300, 450, 300)
            local units = utilex:GetRadiusUnit(unit, unit:GetAbsOrigin(), range, "bad")
            if units then
                for k, v in pairs(units) do
                    if v then
                        local len = (pos - v:GetAbsOrigin()):Length2D()
                        if len > 150 and len <= 300 then
                            dam = dam * 0.6
                        end
                        if len > 300 then
                            dam = dam * 0.4
                        end
                        utilex:UnitDam(unit, v, dam, "mf")
                        if AchieveStat and AchieveStat.Add then
                            local ID = Util:Hero2ID(unit)
                            if ID then
                                AchieveStat:Add(ID, "dmg_suicide", math.floor(dam))
                            end
                        end
                    end
                end
            end
        end
    end
end