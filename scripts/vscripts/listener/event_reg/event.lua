--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


local EventTable = require("listener.event_reg.eventtable")
-- require("listener.event_reg.item_pick")
require("listener.event_reg.state_change")
require("listener.event_reg.gain_level")
require("listener.event_reg.npc_spawn")
require("listener.event_reg.full_connect")
require("listener.event_reg.dis_connect")
require("listener.event_reg.re_connect")
require("listener.event_reg.entity_killed")
-- require("listener.event_reg.inventory_change")
-- require("listener.event_reg.inventory_add")
-- require("listener.event_reg.item_drag")
-- require("listener.event_reg.shop_buy")
require("listener.event_reg.learn_ability")
require("listener.event_reg.use_ability")
require("listener.event_reg.pause_event")
function CustomSets:EventSet()
	if not CustomSets.Event_Has_Reg then
		CustomSets.Event_Has_Reg = {}
	end
	for k, v in pairs(EventTable) do
		if not CustomSets.Event_Has_Reg[k] then
			ListenToGameEvent(k, Dynamic_Wrap(self, v), self)
			CustomSets.Event_Has_Reg[k] = true
		end
	end
end