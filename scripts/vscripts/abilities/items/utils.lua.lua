LinkLuaModifier( "modifier_utils", "abilities/items/utils.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if utils == nil then
	utils = class({})
end
function utils:GetIntrinsicModifierName()
	return "modifier_utils"
end
---------------------------------------------------------------------
--Modifiers
if modifier_utils == nil then
	modifier_utils = class({})
end
function modifier_utils:OnCreated(params)
	if IsServer() then
	end
end
function modifier_utils:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_utils:OnDestroy()
	if IsServer() then
	end
end
function modifier_utils:DeclareFunctions()
	return {
	}
end