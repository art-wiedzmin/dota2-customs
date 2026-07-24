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
