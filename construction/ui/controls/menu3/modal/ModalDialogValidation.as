package menu3.modal
{
   public class ModalDialogValidation
   {
       
      
      protected var message:String;
      
      protected var level:int;
      
      protected var minChars:int = 0;
      
      public function ModalDialogValidation(param1:Object)
      {
         super();
         this.level = param1.level == null ? 0 : int(param1.level);
         this.minChars = param1.minChars == null ? 0 : int(param1.minChars);
         this.message = param1.message;
      }
      
      public function getMessage() : String
      {
         return this.message;
      }
      
      public function getLevel() : int
      {
         return this.level;
      }
      
      public function validate(param1:String) : Boolean
      {
         if(this.minChars == 0 && param1 == null)
         {
            return true;
         }
         if(param1 == null)
         {
            return false;
         }
         return param1.length >= this.minChars;
      }
   }
}
