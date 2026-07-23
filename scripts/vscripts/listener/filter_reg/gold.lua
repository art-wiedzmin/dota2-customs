--金币过滤
--[[
   gold  (string)= 70  (number)
   player_id_const  (string)= 0  (number)
   reason_const  (string)= 13  (number)
   reliable  (string)= 0  (number)
   source_entindex_const  (string)= 777  (number)
]]

function CustomSets:Gold_Filter(key)
   --print("Gold_Filter")
   -- print(key)
   local gold = key.gold
   local unit = EntIndexToHScript(key.source_entindex_const)
   local ID = key.player_id_const
   if ID then
      local jbjc = HeroData:GetSX(ID, "jbjc") or 0
      gold = math.floor((100 + jbjc) * gold / 100)
   end
   -- 仅击杀英雄赏金可调（与其它来源金币无关）
   local hero_kill_reason = DOTA_ModifyGold_HeroKill
   if hero_kill_reason == nil then hero_kill_reason = 13 end
   if key.reason_const == hero_kill_reason and HeroData and HeroData.Static then
      -- local st = HeroData.Static
      -- local pct = tonumber(st.hero_kill_gold_pct) or 100
      -- if pct ~= 100 then
      --    gold = math.floor(gold * pct / 100)
      -- end
      -- local flat = tonumber(st.hero_kill_gold_flat) or 0
      -- if flat ~= 0 then
      --    gold = gold + math.floor(flat)
      -- end
      if gold < 0 then gold = 0 end
      if gold > 1000 then
         gold = 1000
      end
   end
   if ID and HeroData and HeroData.Data and HeroData.Data[ID] then
      HeroData:AddGold(ID, gold)
   end

   -- print("获得金币", gold)
   key.gold = gold
   return true
end
