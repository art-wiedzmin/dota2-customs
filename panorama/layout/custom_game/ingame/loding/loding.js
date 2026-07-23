--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


function GetData(data) {
  var root = GetRoot();
  var page = data.page;
  var show = page === true || page === 1;
  root.style.opacity = show ? 1 : 0;
  root.hittest = show;
}

(function () {
  //print("HeroData");
  SubEvent("UI_Loding", GetData);
})();