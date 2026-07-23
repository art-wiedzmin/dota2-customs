--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function CustomSets:SetXpTable()
   CustomSets.Xptab = {}
   -- 自定义经验表（累计经验）
   local defaultXPTable = {
      0, 240, 640, 1160, 1760, 2440, 3200, 4000, 4900, 5900,
      7100, 8500, 10100, 11900, 13900, 16100, 18500, 21100, 23900, 26900,
      30200, 33800, 37700, 41900, 46900, 52900, 59900, 67900, 76900, 86900,
      98400, 111400, 125900, 141900, 159400, 178400, 198900, 220900, 244400, 269400,
      295900, 323900, 353400, 384400, 416900
   }

   -- 将默认经验表复制到新表中
   for i = 1, 45 do
      CustomSets.Xptab[i] = defaultXPTable[i]
   end
end