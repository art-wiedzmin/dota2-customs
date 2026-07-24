function UpdateTips(){
   var root=GetRoot()
   var ItemName=root.GetAttributeString("ID","")
   var ItemIndex=root.GetAttributeString("Type","")
   if(!ItemName){
       return
   }
   GetPanel("tip_img").SetImage("raw://resource/flash3/images/tag/" + ItemName + "_h.png");
}
(function(){

})()
