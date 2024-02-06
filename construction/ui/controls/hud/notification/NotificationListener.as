package hud.notification
{
   import common.BaseControl;
   
   public class NotificationListener extends BaseControl
   {
       
      
      public function NotificationListener()
      {
         super();
      }
      
      public function onSetData(param1:Object) : void
      {
         this.ShowNotification(param1.category,param1.description,param1.viewData);
      }
      
      public function ShowNotification(param1:String, param2:String, param3:Object) : void
      {
      }
      
      public function HideNotification() : void
      {
      }
      
      public function SetText(param1:String) : void
      {
         this.ShowNotification(param1,"",{});
      }
   }
}
