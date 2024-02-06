package basic
{
   public class ButtonPromtUtil
   {
      
      private static var s_buttonPromptOwners:Vector.<IButtonPromptOwner> = new Vector.<IButtonPromptOwner>();
       
      
      public function ButtonPromtUtil()
      {
         super();
      }
      
      public static function registerButtonPromptOwner(param1:IButtonPromptOwner) : void
      {
         s_buttonPromptOwners.push(param1);
      }
      
      public static function unregisterButtonPromptOwner(param1:IButtonPromptOwner) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < s_buttonPromptOwners.length)
         {
            if(s_buttonPromptOwners[_loc2_] == param1)
            {
               s_buttonPromptOwners.splice(_loc2_,1);
            }
            else
            {
               _loc2_++;
            }
         }
      }
      
      public static function updateButtonPromptOwners() : void
      {
         var _loc1_:IButtonPromptOwner = null;
         for each(_loc1_ in s_buttonPromptOwners)
         {
            _loc1_.updateButtonPrompts();
         }
      }
      
      public static function handlePromptMouseEvent(param1:Function, param2:String) : void
      {
         var _loc3_:int = -1;
         if(param2 == "cancel")
         {
            _loc3_ = 0;
         }
         if(param2 == "accept")
         {
            _loc3_ = 1;
         }
         if(param2 == "action-x")
         {
            _loc3_ = 2;
         }
         if(param2 == "action-y")
         {
            _loc3_ = 5;
         }
         if(param2 == "r")
         {
            _loc3_ = 4;
         }
         if(_loc3_ >= 0)
         {
            param1("onInputAction",_loc3_);
         }
      }
   }
}
