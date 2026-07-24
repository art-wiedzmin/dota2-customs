function CustomSets:use_ability(keys)
    local ability_name = keys.abilityname
    if ability_name ~= "muerta_spectral_slug" then
        return
    end

    local hero = Util:ID2Hero(keys.PlayerID)
    if not hero or hero:IsNull() then
        return
    end

    -- 内置技能 C++ 播 Hero_Muerta.SpectralBlast；旧插件音效包缺此事件已替换正版包
    -- 这里再保底播一次，避免非穆尔塔英雄/预加载异常时无声
    EmitSoundOn("Hero_Muerta.SpectralBlast", hero)

    local target = hero:GetCursorTarget()
    if target and not target:IsNull() then
        Timers(0.12, function()
            if target and not target:IsNull() then
                EmitSoundOn("Hero_Muerta.SpectralBlast.Ethereal", target)
            end
        end)
    end
end
