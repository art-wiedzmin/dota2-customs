function UpdateTips(){
   var root=GetRoot()
   var ItemName=root.GetAttributeString("ID","")
   var ItemIndex=root.GetAttributeString("Type","")
   if(!ItemName||ItemIndex==""){
       return
   }
    if(ItemIndex=="xt"){
        GetPanel("tip_img").SetImage("raw://resource/flash3/images/xt/" + ItemName + ".png")
    }else{
        GetPanel("tip_img").SetImage("raw://resource/flash3/images/tf/" + ItemName + ".png")
    }


}
(function(){

})()
