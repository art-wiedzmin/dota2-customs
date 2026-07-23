--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


-- 肉搏「尖刺外壳」(ability_item_17) 反弹排除表（手动维护）
-- 当本次受击的 OnAttackLanded 能解析到「伤害来源」为某个技能/（视为技能的物品）时，
-- 若其 GetAbilityName() 与本表某键相同，则本次不造成反弹。键 = 引擎技能/物品名。
-- 普通平 A 通常无 inflictor/ability，不会匹配本表，反弹仍按原逻辑生效。

return {
    -- 示例：下列技能名作为来源时不反弹
    -- ["phantom_assassin_stifling_dagger"] = true,
    -- ["item_bfury"] = true,
}