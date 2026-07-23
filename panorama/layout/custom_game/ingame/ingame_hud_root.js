--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


(function () {
  //print("hud_root");
  $("#MainGame").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/MainGame/MainGame.xml",
    false,
    false
  );
  $("#HeroData").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/HeroData/HeroData.xml",
    false,
    false
  );
  $("#BoxData").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/BoxData/BoxData.xml",
    false,
    false
  );
  $("#BoxFun").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/BoxFun/BoxFun.xml",
    false,
    false
  );
  $("#Talent").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Talent/Talent.xml",
    false,
    false
  );
  $("#Bag").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Bag/Bag.xml",
    false,
    false
  );
  $("#AttrList").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/AttrList/AttrList.xml",
    false,
    false
  );
  $("#bagtipnew").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/bagtipnew/bagtipnew.xml",
    false,
    false
  );
  $("#Skill").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Skill/Skill.xml",
    false,
    false
  );
  $("#DelSkill").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/DelSkill/DelSkill.xml",
    false,
    false
  );
  $("#SkillSlot").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/SkillSlot/SkillSlot.xml",
    false,
    false
  );
  $("#ChangeSkill").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/ChangeSkill/ChangeSkill.xml",
    false,
    false
  );
  $("#Pack").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Pack/Pack.xml",
    false,
    false
  );
  $("#Loding").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Loding/Loding.xml",
    false,
    false
  );
  $("#OverData").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/OverData/OverData.xml",
    false,
    false
  );
  $("#Menu").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Menu/Menu.xml",
    false,
    false
  );
  // $("#Person").BLoadLayout(
  //   "file://{resources}/layout/custom_game/ingame/Person/Person.xml",
  //   false,
  //   false
  // );

  // $("#Shop").BLoadLayout(
  //   "file://{resources}/layout/custom_game/ingame/Shop/Shop.xml",
  //   false,
  //   false
  // );
  // $("#Rank").BLoadLayout(
  //   "file://{resources}/layout/custom_game/ingame/Rank/Rank.xml",
  //   false,
  //   false
  // );
  $("#Task").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Task/Task.xml",
    false,
    false
  );
  $("#Achieve").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Achieve/Achieve.xml",
    false,
    false
  );

  $("#Monster").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Monster/Monster.xml",
    false,
    false
  );
  $("#Prophecy").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Prophecy/Prophecy.xml",
    false,
    false
  );
  $("#Public").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/public/public.xml",
    false,
    false
  );

  $("#baghover").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/baghover/baghover.xml",
    false,
    false
  );
  $("#Reborn").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Reborn/Reborn.xml",
    false,
    false
  );
  $("#Code").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Code/Code.xml",
    false,
    false
  );
  // 成功弹窗 此页面需要放在最上面一级
  $("#alter").BLoadLayout(
    "file://{resources}/layout/custom_game/alter/alter.xml",
    false,
    false
  );
  $("#Msg").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Msg/Msg.xml",
    false,
    false
  );
  $("#Model").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/model/model.xml",
    false,
    false
  );
  $("#Point").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Point/Point.xml",
    false,
    false
  );
  $("#Stat").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Stat/Stat.xml",
    false,
    false
  );
  $("#scoreboard").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/scoreboard/scoreboard.xml",
    false,
    false
  );
  $("#logo").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/logo/logo.xml",
    false,
    false
  );
  $("#Invite").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Invite/Invite.xml",
    false,
    false
  );
  $("#Book").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/Book/Book.xml",
    false,
    false
  );
  $("#LeaveConfirm").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/LeaveConfirm/LeaveConfirm.xml",
    false,
    false
  );
  $("#HeroCard").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/HeroCard/HeroCard.xml",
    false,
    false
  );
  $("#EazyShop").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/EazyShop/EazyShop.xml",
    false,
    false
  );
  $("#FreeBook").BLoadLayout(
    "file://{resources}/layout/custom_game/ingame/FreeBook/FreeBook.xml",
    false,
    false
  );
  if (typeof ClrbIsLocalToolsMode === "function" && ClrbIsLocalToolsMode()) {
    $("#DevTools").BLoadLayout(
      "file://{resources}/layout/custom_game/ingame/DevTools/DevTools.xml",
      false,
      false
    );
  }
})();