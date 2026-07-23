--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


--拾取并添加一个物品
--[[
{
	game_event_listener  (string)= 1291845641  (number)
	game_event_name  (string)= dota_inventory_item_added  (string)
	inventory_parent_entindex  (string)= 269  (number)
	inventory_player_id  (string)= 0  (number)
	is_courier  (string)= 0  (number)
	item_entindex  (string)= 323  (number)
	item_slot  (string)= 17  (number)
	itemname  (string)= item_test_goods  (string)
	splitscreenplayer  (string)= -1  (number)
}
--当物品进入物品栏
--会调用两次 除非是特殊情况才使用此事件
--猜测 物品先进入17槽，然后判断是否装备槽满，再挪进装备槽
--17槽事件必定触发
]]
function CustomSets:inventory_add(keys)
	
end