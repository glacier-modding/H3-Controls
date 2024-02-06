package menu3.modal
{
   import common.Log;
   
   public class ModalDialogEditLinePublicId extends ModalDialogGenericEditLine
   {
       
      
      private const PUBLICID_DEFAULT_LENGTH:int = 12;
      
      private var m_failedValidation:ModalDialogValidation = null;
      
      private var m_publicIdLength:int = 12;
      
      private var m_unformattedInput:String = "";
      
      public function ModalDialogEditLinePublicId(param1:Object)
      {
         super(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         this.m_publicIdLength = this.PUBLICID_DEFAULT_LENGTH;
         var _loc2_:int = this.m_publicIdLength;
         _loc2_ += 3;
         param1.maxChars = _loc2_;
         super.onSetData(param1);
      }
      
      override public function setButtonData(param1:Array) : void
      {
         super.setButtonData(param1);
         this.updateState();
      }
      
      override protected function onTextInputChange() : void
      {
         this.updateState();
         var _loc1_:Boolean = checkSubmitValidators();
         if(_loc1_ && getSubmitButton() != null)
         {
            m_callbackSendEvent("onElementDown");
         }
      }
      
      private function updateState() : void
      {
         this.m_unformattedInput = this.getDescriptionText();
         var _loc1_:String = this.formatInputString(this.m_unformattedInput);
         Log.xinfo(Log.ChannelModal,"formatInputString: rawInput=\'" + super.getDescriptionText() + "\' unformatted=\'" + this.m_unformattedInput + "\' formatted=\'" + _loc1_ + "\'");
         updateInputField(_loc1_);
         super.onTextInputChange();
      }
      
      override protected function updateTitle() : void
      {
         setTitle(getOriginalTitle() + " " + "[" + this.m_unformattedInput.length + "/" + this.m_publicIdLength + "]");
      }
      
      override protected function getDescriptionText() : String
      {
         var _loc1_:String = super.getDescriptionText();
         var _loc2_:RegExp = /[^0-9]/g;
         return _loc1_.replace(_loc2_,"").substr(0,this.m_publicIdLength);
      }
      
      private function formatInputString(param1:String) : String
      {
         var _loc4_:int = 0;
         var _loc2_:String = "";
         var _loc3_:String = "-";
         _loc4_ = 0;
         while(_loc4_ < this.m_unformattedInput.length)
         {
            if(_loc4_ == 1 || _loc4_ == 3 || _loc4_ == 10)
            {
               _loc2_ += _loc3_;
            }
            _loc2_ += this.m_unformattedInput.charAt(_loc4_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      override protected function setErrorMessage(param1:ModalDialogValidation) : void
      {
         super.setErrorMessage(param1);
         this.m_failedValidation = param1;
      }
      
      override protected function validate(param1:String) : void
      {
         super.validate(param1);
         if(m_isValid)
         {
            m_isValid = this.m_unformattedInput.length == this.m_publicIdLength;
         }
      }
   }
}
