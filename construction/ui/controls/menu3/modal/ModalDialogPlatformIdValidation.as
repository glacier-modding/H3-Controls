package menu3.modal
{
   import common.Log;
   
   public class ModalDialogPlatformIdValidation extends ModalDialogValidation
   {
       
      
      private var m_platformId:String = "0";
      
      public function ModalDialogPlatformIdValidation(param1:Object, param2:String)
      {
         super(param1);
         this.m_platformId = param2;
         Log.xinfo(Log.ChannelModal,"using platformid " + param2 + " for validation");
      }
      
      override public function validate(param1:String) : Boolean
      {
         if(!super.validate(param1))
         {
            return false;
         }
         if(param1 == null || param1.length == 0)
         {
            return true;
         }
         return param1.substr(0,1) == this.m_platformId;
      }
   }
}
