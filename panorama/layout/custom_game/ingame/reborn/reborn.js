--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


//获取数据
function GetData(data) {
  if (!data) {
    return;
  }
  //print(data);
  GetRoot().style.opacity = data.page;
  if (data.page == 1) {
    GetPanel("time").text = data.time;
    Time = data.time;
    TimeStar();
  }
}

var Time = -1;

function TimeStar() {
  Timers(1, function () {
    Time = Time - 1;
    GetPanel("time").text = Time;
    if (Time == 0) {
      Time = -1;
      GetRoot().style.opacity = 0;
      return;
    }
    TimeStar();
  });
}

(function () {
  SubEvent("UI_Reborn", GetData);
})();