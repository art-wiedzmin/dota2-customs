--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


--- 注册工具指令（聊天 / 左侧面板共用）
--- @param opts table|nil { group, tools_only=true, show_in_panel=true }
function DevTools:RegisterTool(cmd, label, handler, opts)
    if not cmd or cmd == "" or type(handler) ~= "function" then
        return
    end
    opts = opts or {}
    self.Registry[cmd] = {
        cmd = cmd,
        label = label or cmd,
        group = opts.group or self.DefaultGroup,
        handler = handler,
        tools_only = opts.tools_only ~= false,
        show_in_panel = opts.show_in_panel ~= false,
    }
end

function DevTools:InitRegistry()
    if self._registry_inited then
        return
    end
    self._registry_inited = true
    if self.InitBuiltinCommands then
        self:InitBuiltinCommands()
    end
    if self.RegisterCustomTools then
        self:RegisterCustomTools()
    end
end

function DevTools:RunCommand(ID, cmd)
    if not ID or not cmd or cmd == "" then
        return false
    end
    self:InitRegistry()
    local entry = self.Registry[cmd]
    if not entry or not entry.handler then
        return false
    end
    if entry.tools_only and not self:IsEnabled() then
        return false
    end
    local hero = Util:ID2Hero(ID)
    if not hero or hero:IsNull() then
        return false
    end
    local ok, err = pcall(entry.handler, ID, hero)
    if not ok and Server and Server.SendError then
        Server:SendError(tostring(err), "DevTools:RunCommand:" .. tostring(cmd))
    end
    return ok
end

--- 工具模式：发放称号到背包、佩戴，并弹出测试版获得称号奖励窗
function DevTools:GrantTitleAndEquip(ID, hero, item_key)
    if not ID or not hero or hero:IsNull() or not item_key or item_key == "" then
        return
    end
    if not Shop then
        return
    end
    ID = tonumber(ID) or ID
    if Shop.EnsurePlayerData and not Shop:EnsurePlayerData(ID) then
        Util:BottomMsg2ID(ID, "玩家数据未初始化", "red", 3)
        return
    end
    local meta = Shop.ItemList and Shop.ItemList[item_key]
    if not meta then
        Util:BottomMsg2ID(ID, "未知称号: " .. tostring(item_key), "red", 3)
        return
    end

    local function onReady()
        if not Shop:OutBagOwnsItem(ID, item_key) then
            Util:BottomMsg2ID(ID, "称号未入背包", "red", 3)
            return
        end
        if Shop.OutBagEquip then
            Shop:OutBagEquip(ID, "title", item_key)
        end
        if Title and Title.ApplyTitle then
            Title:ApplyTitle(hero, item_key, ID, true)
        end
        local rows = {}
        if Shop.BuildTitleRedeemRow then
            local row = Shop:BuildTitleRedeemRow(item_key)
            if row then
                rows[1] = row
            end
        end
        if Msgs and Msgs.PopRedeemSuccess then
            Msgs:PopRedeemSuccess(ID, "获得称号（测试）", rows)
        end
    end

    if Shop:OutBagOwnsItem(ID, item_key) then
        onReady()
        return
    end

    -- DevTools 称号：始终本地入背包（RunCommand 已保证工具模式；不依赖服务端 grant 白名单）
    if Shop.AddBagItemLocal and Shop:AddBagItemLocal(ID, item_key, 1) then
        onReady()
        -- 已登录时后台同步服务端，失败不影响本地背包与佩戴
        if Shop.GrantBagItemServer and Http and Http.GetPlayerAccessToken then
            local token = Http:GetPlayerAccessToken(ID)
            if token and token ~= "" then
                Shop:GrantBagItemServer(ID, item_key, 1, function(ok)
                    if ok and Shop.SendOutBagData then
                        Shop:SendOutBagData(ID)
                    end
                end)
            end
        end
        return
    end

    Util:BottomMsg2ID(ID, "称号发放失败", "red", 3)
end

--- 工具模式：预览周身特效（先清旧特效再挂新粒子，不叠加）
function DevTools:PreviewBodyEffect(ID, hero, fx, label)
    if not hero or hero:IsNull() or not fx or fx == "" then
        return
    end
    ID = tonumber(ID) or ID
    -- 先登记预览路径，避免 OutBagUnequip → Effect:Sync 把刚挂上的粒子清掉
    if Effect and Effect.SetToolsPreview then
        Effect:SetToolsPreview(ID, fx)
    end
    if Shop and Shop.GetEquippedEffectKey and Shop:GetEquippedEffectKey(ID) and Shop.OutBagUnequip then
        Shop:OutBagUnequip(ID, "effect")
    elseif Effect and Effect.RemoveEffect then
        Effect:RemoveEffect(hero)
    end
    if Effect and Effect.ApplyEffectFx then
        Effect:ApplyEffectFx(hero, fx)
    end
    Util:BottomMsg2ID(ID, label or "已切换周身特效", "green", 2)
end

--- 工具模式：清除当前周身特效
function DevTools:RemoveBodyEffect(ID, hero, label)
    if not hero or hero:IsNull() then
        return
    end
    ID = tonumber(ID) or ID
    if Effect and Effect.ClearToolsPreview then
        Effect:ClearToolsPreview(ID)
    end
    if Effect and Effect.RemoveEffect then
        Effect:RemoveEffect(hero)
    end
    if Shop and Shop.OutBagUnequip then
        local equipped = Shop.GetEquippedEffectKey and Shop:GetEquippedEffectKey(ID)
        if equipped then
            Shop:OutBagUnequip(ID, "effect")
        end
    end
    Util:BottomMsg2ID(ID, label or "已移除周身特效", "yellow", 2)
end

--- 工具模式：发放周身特效到背包、佩戴，并弹出测试版获得特效奖励窗
function DevTools:GrantEffectAndEquip(ID, hero, item_key)
    if not ID or not hero or hero:IsNull() or not item_key or item_key == "" then
        return
    end
    if not Shop then
        return
    end
    ID = tonumber(ID) or ID
    if Shop.EnsurePlayerData and not Shop:EnsurePlayerData(ID) then
        Util:BottomMsg2ID(ID, "玩家数据未初始化", "red", 3)
        return
    end
    local meta = Shop.ItemList and Shop.ItemList[item_key]
    if not meta then
        Util:BottomMsg2ID(ID, "未知特效: " .. tostring(item_key), "red", 3)
        return
    end

    local function onReady()
        if not Shop:OutBagOwnsItem(ID, item_key) then
            Util:BottomMsg2ID(ID, "特效未入背包", "red", 3)
            return
        end
        if Shop.OutBagEquip then
            Shop:OutBagEquip(ID, "effect", item_key)
        end
        if Effect and Effect.ApplyEffect then
            Effect:ApplyEffect(hero, item_key)
        end
        local rows = {}
        if meta.icon and meta.icon ~= "" then
            rows[1] = {
                img = meta.icon,
                count = meta.name or item_key,
                unit = "特效",
            }
        end
        if Msgs and Msgs.PopRedeemSuccess then
            Msgs:PopRedeemSuccess(ID, "获得特效（测试）", rows)
        end
    end

    if Shop:OutBagOwnsItem(ID, item_key) then
        onReady()
        return
    end

    if Shop.AddBagItemLocal and Shop:AddBagItemLocal(ID, item_key, 1) then
        onReady()
        if Shop.GrantBagItemServer and Http and Http.GetPlayerAccessToken then
            local token = Http:GetPlayerAccessToken(ID)
            if token and token ~= "" then
                Shop:GrantBagItemServer(ID, item_key, 1, function(ok)
                    if ok and Shop.SendOutBagData then
                        Shop:SendOutBagData(ID)
                    end
                end)
            end
        end
        return
    end

    Util:BottomMsg2ID(ID, "特效发放失败", "red", 3)
end

--- 工具模式：为英雄添加 Diretide 攻击弹道特效（atv1/atv2/atv3）
function DevTools:GrantAttackEffect(ID, hero, effect_key, label)
    if not hero or hero:IsNull() or not effect_key or effect_key == "" then
        return
    end
    if hero:HasModifier("modifier_attack_effect") then
        hero:RemoveModifierByName("modifier_attack_effect")
    end
    hero:AddNewModifier(hero, nil, "modifier_attack_effect", {
        attack_effect = effect_key,
    })
    Util:BottomMsg2ID(ID, label or ("已添加攻击特效 " .. effect_key), "green", 2)
end

function DevTools:RemoveAttackEffect(ID, hero)
    if not hero or hero:IsNull() then
        return
    end
    if hero:HasModifier("modifier_attack_effect") then
        hero:RemoveModifierByName("modifier_attack_effect")
    end
    Util:BottomMsg2ID(ID, "已清除攻击特效", "yellow", 2)
end
