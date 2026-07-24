if IsInToolsMode() then
    local state = GameRules:State_Get()
    if state == DOTA_GAMERULES_STATE_INIT then return end
    print("开发模式重载")
    local hero = Util:ID2Hero(0)
    if not hero then return end
    if hero:IsNull() then return end
    CustomSets:TestFunc(0, hero)
    CustomSets:TestFunc2(0, hero)
end
