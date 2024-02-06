package menu3.modal
{
   public class ModalDialogRegexValidation extends ModalDialogValidation
   {
       
      
      public var regEx:RegExp;
      
      public function ModalDialogRegexValidation(param1:Object, param2:Object)
      {
         super(param1);
         this.regEx = new RegExp(param2.source,param2.flags);
      }
      
      override public function validate(param1:String) : Boolean
      {
         if(!super.validate(param1))
         {
            return false;
         }
         this.regEx.lastIndex = 0;
         return this.regEx.test(param1);
      }
   }
}
