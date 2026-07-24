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
