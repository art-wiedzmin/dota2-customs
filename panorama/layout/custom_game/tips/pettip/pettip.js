function UpdateTips(){
   var root=GetRoot()
   var ItemName=root.GetAttributeString("ID","")
   var ItemIndex=root.GetAttributeString("Type","")
   if(!ItemName){
       return
   }
   GetPanel("tip_text").text=ItemName;
    


}
(function(){

})()
